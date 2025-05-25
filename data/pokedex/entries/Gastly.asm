	ctxt "Gas" ; species name
	done
	dw 13, 1 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It wraps its op-"
	next "ponent in its gas-"
	next "like body, slowly"
	done
.page2
	ctxt "weakening its prey"
	next "by poisoning it"
	next "through the skin."
	done
