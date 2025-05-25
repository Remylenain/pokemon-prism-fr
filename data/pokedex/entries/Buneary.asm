	ctxt "Rabbit" ; species name
	done
	dw 4, 55 ; height, weight

	db .page2 - .page1
.page1
	ctxt "You can tell how"
	next "it feels by the"
	next "way it rolls its"
	done
.page2
	ctxt "ears. When it's"
	next "scared, both ears"
	next "are rolled up."
	done
