	ctxt "Mushroom" ; species name
	done
	dw 4, 45 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It spouts poison"
	next "spores from the"
	next "top of its head."
	done
.page2
	ctxt "These spores cause"
	next "pain all over if"
	next "inhaled."
	done
