	ctxt "Leaf" ; species name
	done
	dw 9, 64 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It loves to bask"
	next "in the sunlight."
	next "It uses the leaf"
	done
.page2
	ctxt "on its head to"
	next "seek out warm"
	next "places."
	done
