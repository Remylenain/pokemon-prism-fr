	ctxt "Transform" ; species name
	done
	dw 3, 40 ; height, weight

	db .page2 - .page1
.page1
	ctxt "When it encount-"
	next "ers another Ditto,"
	next "it will move"
	done
.page2
	ctxt "faster than normal"
	next "to duplicate that"
	next "opponent exactly."
	done
