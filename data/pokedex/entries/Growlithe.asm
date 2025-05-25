	ctxt "Puppy" ; species name
	done
	dw 7, 190 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It controls a big"
	next "territory. If it"
	next "detects an unknown"
	done
.page2
	ctxt "smell, it roars"
	next "loudly to force"
	next "out the intruder."
	done
