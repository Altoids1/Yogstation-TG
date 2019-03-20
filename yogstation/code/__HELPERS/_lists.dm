/proc/compare_lists(list/a, list/b)
	if(!istype(a) || !istype(b))
		return FALSE
	if(a.len != b.len)
		return FALSE
	for(var/i = 1 to a.len)
		if(a[i] != b[i])
			return FALSE
	return TRUE

/proc/sortedtypesof(type) // Returns an alphabetized list from typesof(type), sorted using insertion sort (chosen because these are usually *mostly* sorted anyways)
	var/list/typelist = typesof(type)
	var/list/sortedlist = list(typelist[1])
	for(var/i in 2 to typelist.len)
		for(var/j in sortedlist)
			if(typelist[i] > sortedlist[j])
				sortedlist.Insert(j+1,typelist[i])
	
	return sortedlist