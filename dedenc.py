# High level overview
# -------------------
# After dithering and quantization, we get a sequence of 4-bit samples. The difference between each
# pair of consecutive samples is encoded with a per-file Huffman code.

# The DED output consists of four parts
# - the Huffman tree (encoded as a "bytecode" that is easy and fast to "compile" into RAM)
# - a 0xff byte separator
# - a 2-byte little-endian integer denoting the length of the sfx in 32-sample blocks
#   (the wave RAM holds 32 samples)
# - the Huffman-encoded deltas

assert str is not bytes, "Python 2 is DEAD and you will soon share its fate for trying to use it"
RATE = 10485.76
VOL = 3.2

import argparse, math, wave, random
from collections import Counter

# tree building
# `tie' stores the value of the leftmost leaf of the subtree. This is used as
# the tiebreaker when comparing nodes with the same `count' to ensure
# determinism.
# One class is used for both leaves and branches, since two separate classes
# make it harder to define a comparison operator.
class HuffTree:
    def __init__(self, count, value, tie):
        self.count = count
        self.value = value
        self.tie = tie

    @classmethod
    def leaf(cls, count, value):
        return HuffTree(count, value, value)

    @classmethod
    def branch(cls, left, right):
        return HuffTree(left.count + right.count, (left, right), left.tie)

    def is_branch(self):
        return isinstance(self.value, tuple)

    def __lt__(self, other):
        return (self.count, self.tie) < (other.count, other.tie)

def decode_sample(sample_bytes):
    # 8-bit samples are usually unsigned
    signed = len(sample_bytes) > 1
    value = int.from_bytes(sample_bytes, "little", signed=signed)
    # unsigned samples need bias
    if len(sample_bytes) == 1:
        value -= 128
    return value

# returns a value between -0.5 and 0.5
def frame_as_float(frame, sample_width, channel_count):
    # average the channels
    total = sum(decode_sample(frame[i:i+sample_width])
                for i in range(0, sample_width * channel_count, sample_width))
    return total / channel_count / 256.0 ** sample_width

# cubic spline interpolation
def cuinterpo(s,n):
    nn = int(n)
    p0 = s[nn]
    p1 = s[nn+1]
    m0 = (s[nn+1]-s[nn-1])/2
    m1 = (s[nn+2]-s[nn])/2
    t1 = math.modf(n)[0]
    t2 = t1 ** 2
    t3 = t1 ** 3
    return (2*t3-3*t2+1)*p0+(t3-2*t2+t1)*m0+(-2*t3+3*t2)*p1+(t3-t2)*m1

# the tree is encoded as follows
# 1100 xxxx 0000 yyyy: leaf leaf, x if 1, y if 0
# 1000 xxxx: internal leaf, x if 1
# 0xxx xxxx: internal internal, x is jump offset
# 1111 1111: terminator, signifies end of stream
# returns (bytecode, compiled_length)
def writetree(tree, addr, prefix, codes):
    left, right = tree.value
    if left.is_branch() and right.is_branch():
        # Code generated for this case:
        # [inline GetDEDBit] ; 6 bytes
        # jr c, .skip ; 2 bytes
        # [left branch]
        # .skip
        # [right branch]
        addr += 8
        leftbytes, skip_addr = writetree(left, addr, prefix + '0', codes)
        rightbytes, end_addr = writetree(right, skip_addr, prefix + '1', codes)
        delta = skip_addr - addr
        # All histograms can be turned into a Huffman tree such that all
        # jumps fit. The algorithm currently being used does not take this into
        # account and may trigger this assertion in some pathological cases.
        # Should such a pathological example arise, the program will need to be
        # modified to always put the smaller subtree as the left child.
        assert delta <= 127
        return delta.to_bytes(1, 'little') + leftbytes + rightbytes, end_addr
    elif left.is_branch():
        # Code generated for this case:
        # [inline GetDEDBit] ; 6 bytes
        # ld b, RIGHT_LEAF ; 2 bytes
        # ret c ; 1 byte
        # [left branch]
        addr += 9
        codes[right.value] = prefix + "1"
        leftbytes, addr = writetree(left, addr, prefix + "0", codes)
        return bytes([0x80 + right.value]) + leftbytes, addr
    else:
        # Code generated for this case:
        # [inline GetDEDBit] ; 6 bytes
        # ld b, RIGHT_LEAF ; 2 bytes
        # ret c ; 1 byte
        # ld b, LEFT_LEFT ; 2 bytes
        # ret ; 1 byte
        addr += 12
        codes[left.value] = prefix + "0"
        codes[right.value] = prefix + "1"
        return bytes([0xc0 + right.value, left.value]), addr

def wavtoded(wavefile, outfile):
    sample_width = wavefile.getsampwidth()
    channel_count = wavefile.getnchannels()
    rate = wavefile.getframerate()
    samples = []

    for _ in range(wavefile.getnframes()):
        sample = frame_as_float(wavefile.readframes(1), sample_width, channel_count)
        samples.append(sample * VOL)
    samples += [0.0] * 2

    if abs(rate-RATE)/RATE > 0.05:
        unstretched = samples
        samples = []
        for i in range(0,int((len(unstretched)-2)*RATE/rate)): # stretch
            samples.append(cuinterpo(unstretched,i*rate/RATE))

    samples = [min(max(sample + (8.0/15.0), 0.0), 1.0) for sample in samples]

    # TPDF dither; calculate deltas between samples
    last = 8
    deltas = []
    random.seed(3490487757541254948)
    for sample in samples:
        value = int(sample * 15)
        error = sample * 15.0 - value
        if error < 0.5: prob = 2.0*error**2
        else: prob = 1.0-(2.0*(1.0-error)**2)

        if prob > random.random(): value += 1

        deltas.append((value - last) % 16)
        last = value

    freq = Counter(deltas)
    # pad to make the sample count divisible by wave RAM capacity
    deltas += [0] * (-len(deltas) % 32)

    # construct huffman tree
    queue = [HuffTree.leaf(count, id_) for id_, count in freq.items()]
    while len(queue) > 1:
        queue.sort()
        le = queue.pop(0)
        preferred_branch = not le.is_branch()
        wanted_count = queue[0].count
        for i, q in enumerate(queue):
            if q.count != wanted_count:
                # No preferred match
                ri = queue.pop(0)
                break
            elif preferred_branch == q.is_branch():
                ri = queue.pop(i)
                break
        else:
            ri = queue.pop(0)
        if not le.is_branch() and ri.is_branch():
            le, ri = ri, le
        queue.append(HuffTree.branch(le, ri))

    # tree writing
    code = {}
    outfile.write(writetree(queue[0], 0, "", code)[0])
    outfile.write(b'\xff')
    outfile.write((len(deltas) // 32).to_bytes(2, "little"))

    # compression
    bits = ''.join(code[v] for v in deltas)
    bits += '1' * (-len(bits) % 8)

    for i in range(0, len(bits), 8):
        outfile.write(bytes([int(bits[i:i+8],2)]))

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('input', metavar='in', type=argparse.FileType('rb'), help='Input file name')
    parser.add_argument('output', metavar='out', type=argparse.FileType('wb'), help='Output file name')
    args = parser.parse_args()

    with wave.open(args.input, "rb") as wavefile:
        wavtoded(wavefile, args.output)
    args.output.close()
