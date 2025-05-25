	ctxt "Light" ; species name
	done
	dw 12, 225 ; height, weight

	db .page2 - .page1
.page1
	ctxt "This #mon uses"
	next "the bright part of"
	next "its body, which"
	done
.page2
	ctxt "changed from a"
	next "dorsal fin, to"
	next "lure prey."
	done
