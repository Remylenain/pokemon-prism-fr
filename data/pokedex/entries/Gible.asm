	ctxt "Land Shark" ; species name
	done
	dw 7, 205 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It once lived in"
	next "the tropics. To"
	next "avoid the cold, it"
	done
.page2
	ctxt "lives in caves"
	next "warmed by"
	next "geothermal heat."
	done
