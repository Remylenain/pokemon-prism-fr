	ctxt "Jolly" ; species name
	done
	dw 12, 325 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It is nocturnal"
	next "and becomes active"
	next "at nightfall. It"
	done
.page2
	ctxt "feeds on aquatic"
	next "mosses that grow"
	next "in the riverbed."
	done
