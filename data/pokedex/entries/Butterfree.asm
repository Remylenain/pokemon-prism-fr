	ctxt "Butterfly" ; species name
	done
	dw 11, 320 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It flits from"
	next "flower to flower,"
	next "collecting honey."
	done
.page2
	ctxt "It can even"
	next "identify distant"
	next "flowers in bloom."
	done
