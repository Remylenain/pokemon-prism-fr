	ctxt "Virtual" ; species name
	done
	dw 8, 365 ; height, weight

	db .page2 - .page1
.page1
	ctxt "An artificial"
	next "#mon created"
	next "due to extensive"
	done
.page2
	ctxt "research, it can"
	next "perform only what"
	next "is in its program."
	done
