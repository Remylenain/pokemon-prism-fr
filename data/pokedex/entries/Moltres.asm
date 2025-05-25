	ctxt "Flame" ; species name
	done
	dw 20, 600 ; height, weight

	db .page2 - .page1
.page1
	ctxt "Legendary bird"
	next "#mon. It is"
	next "said to migrate"
	done
.page2
	ctxt "from the south"
	next "along with the"
	next "spring."
	done
