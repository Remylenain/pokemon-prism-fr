	ctxt "Beak" ; species name
	done
	dw 12, 380 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It uses its long"
	next "beak to attack. It"
	next "has a surprisingly"
	done
.page2
	ctxt "long reach, so it"
	next "must be treated"
	next "with caution."
	done
