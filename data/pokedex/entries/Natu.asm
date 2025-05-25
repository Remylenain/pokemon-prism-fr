	ctxt "Little Bird" ; species name
	done
	dw 2, 20 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It is extremely"
	next "good at climbing"
	next "tree trunks and"
	done
.page2
	ctxt "likes to eat the"
	next "new sprouts on"
	next "the trees."
	done
