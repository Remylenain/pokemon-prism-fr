	ctxt "Big Voice" ; species name
	done
	dw 10, 405 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It shouts loudly"
	next "by inhaling air,"
	next "and then uses"
	done
.page2
	ctxt "its well-built"
	next "stomach muscles"
	next "to exhale."
	done
