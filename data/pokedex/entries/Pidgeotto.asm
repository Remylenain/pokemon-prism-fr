	ctxt "Bird" ; species name
	done
	dw 11, 300 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It slowly flies in"
	next "a circular pat-"
	next "tern, all the"
	done
.page2
	ctxt "while keeping a"
	next "sharp lookout for"
	next "prey."
	done
