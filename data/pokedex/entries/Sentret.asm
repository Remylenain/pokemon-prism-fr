	ctxt "Scout" ; species name
	done
	dw 8, 60 ; height, weight

	db .page2 - .page1
.page1
	ctxt "When acting as a"
	next "lookout, it warns"
	next "others of danger"
	done
.page2
	ctxt "by screeching and"
	next "hitting the ground"
	next "with its tail."
	done
