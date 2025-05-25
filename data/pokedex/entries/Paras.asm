	ctxt "Mushroom" ; species name
	done
	dw 3, 54 ; height, weight

	db .page2 - .page1
.page1
	ctxt "The tochukaso"
	next "growing on this"
	next "#mon's back"
	done
.page2
	ctxt "orders it to"
	next "extract juice from"
	next "tree trunks."
	done
