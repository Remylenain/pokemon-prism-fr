	ctxt "Rock" ; species name
	done
	dw 10, 1050 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It travels by rol-"
	next "ling on mountain"
	next "paths. If it gains"
	done
.page2
	ctxt "too much speed, it"
	next "stops by running"
	next "into huge rocks."
	done
