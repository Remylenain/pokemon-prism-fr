The source files are assembled into a ROM using [**rgbds**](https://github.com/gbdev/rgbds).
These instructions explain how to set up the tools required to build.

If you run into trouble, ask on IRC ([**freenode#pret**](https://kiwiirc.com/client/irc.freenode.net/?#pret)).


# `apt`-based Linux

Python 3 is required.

```bash
sudo apt-get install make gcc bison git python python3-pip
sudo pip install pypng

git clone https://github.com/gbdev/rgbds
cd rgbds
sudo make install
cd ..

cd path/to/pokeprism/source
```

To build **pokeprism.gbc**:

```bash
make
```

# Guix

Use `guix environment -m guix.scm` to open a shell with all dependencies
available. Then, to build the ROM, use `make`.

# macOS
This has been tested and works on both Intel and Apple Silicon devices.
## macOS 11 or newer

Launch **Terminal** and run:

```bash
xcode-select --install
```

* Select Install from the on-screen pop-up, then agree to the licence agreement.
* Wait for the command line tools to install.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

* Press return and wait for [Homebrew](https://brew.sh) to install. This may take a while.
* Additional commands are required for Apple Silicon - please pay attention to the end of the install process.
* macOS ships with an old version of bash (3.2 from 2007) as default. This needs to be upgraded.

```bash
brew upgrade
brew install bash
exec bash
sudo nano /etc/shells
```
* Add the shell to the bottom of the list:
 * Intel: `/usr/local/bin/bash`
 * Apple Silicon: `/opt/homebrew/bin/bash`
* You can check the default version of bash with `bash --version`. If it is still 3.2, revise above steps.

```bash
brew install rgbds
brew install python3
pip3 install pypng
```
* **For macOS 11 & 12 only:** `coreutils` will also need to be installed. This is not neccesary on macOS 13 or newer.
```bash
brew install coreutils
```

```bash
cd path/to/pokeprism/source
```

* You can also type `cd`, then drag and drop the pokeprism folder onto the Terminal window.
* **For Apple Silicon only:** Before building, you will need to start a new bash session using the new shell. You will only need to do this once per session and can build multiple times. This is not neccesary on Intel.

```bash
/opt/homebrew/bin/bash
```

To build **pokeprism.gbc**:

```bash
make
```

## macOS 10.15 or older
Launch **Terminal** and run:

```bash
xcode-select --install
```

* Select Install from the on-screen pop-up, then agree to the licence agreement.
* Wait for the command line tools to install.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

* Press return and wait for [Homebrew](https://brew.sh) to install. This may take a while (up to an hour on slower devices).
* macOS ships with an outdated version of bash (3.2 from 2007) as default. This needs to be upgraded.

```bash
brew upgrade
brew install bash
exec bash
sudo nano /etc/shells
```
* Add the shell to the bottom of the list: `/usr/local/bin/bash`
* You can check the default version of bash with `bash --version`. If it is still 3.2, revise above steps.

```bash
brew install rgbds
```

* Homebrew may want to update, and Rust will want to build from source. This may take a very long time (several hours) depending on your computer.
* **rgbds will fail to build.** This is expected. We will install this separately later.

```bash
brew install coreutils
brew install python3
pip3 install pypng
```
* Once you have finished this, download the latest macOS release [from the rgbds repo](https://github.com/gbdev/rgbds/releases).

```bash
cd path/to/rgbds/download/folder
sh install.sh
cd path/to/pokeprism/source
```

* You can also type `cd`, then drag and drop the folders onto the Terminal window.

To build **pokeprism.gbc**:

```bash
make
```

# Windows

To build on Windows, install [**Cygwin**](http://cygwin.com/install.html) with the default settings.

In the installer, select the following packages: `make` `git` `gcc-core` `bison` `python3` `python36-pip` `python36-setuptools` `gettext`

In the **Cygwin terminal**:

```bash
git clone https://github.com/gbdev/rgbds
cd rgbds
sudo make install
cd ..

cd path/to/pokeprism/source
```

To build **pokeprism.gbc**:

```bash
make
```


# Notes

- If `gettext` no longer exists, grab `libsasl2-3` `ca-certificates`.
- In all cases, `make` will simply build the release and debug ROMs. `make gbs` will build the GBS file. In order to
  build the patch, a copy of Crystal 1.1 (SHA-1: `f2f52230b536214ef7c9924f483392993e226cfb`) is needed; place it in
  the source code directory as `baserom.gbc` and type `make patch` in the terminal.
- You might need to install `pypng` if you don't have it. `pip install pypng` (or `pip3 install pypng`) should do it.
- RGBDS releases are too infrequent, and we often rely on features added only to the development head. Building RGBDS
  from source is strongly recommended, if not required.
- The game's calendar defaults to the build date when the game starts. If you want to change the build date, pass the
  `BUILD_DATE` variable to `make` (e.g., `make BUILD_DATE=20161222` sets the build date to 22 December 2016). If you
  want to match the distributed ROM, you will need to set the build date to the date of distribution.
