/datum/ai_laws/proc/get_lawset() // Returns a boolean or text describing what lawset this seems to be.
	//NOTE: This proc ignores the supplied list, and assumes there's nothing untowards in those laws. 
	//This proc was first created just to handle some stupid "don't be bad" warnings for Peacekeeper and Security borgs. Be careful using it in real production to determine asimov-ness.
	if(ion.len)
		return FALSE
	if(hacked.len)
		return FALSE
	if(devillaws.len)
		return FALSE
	if(zeroth || zeroth_borg)
		return FALSE

	var/datum/ai_laws/default/asimov/basic = new
	var/datum/ai_laws/default/asimovpp/plus = new
	var/a = basic.inherent ^ inherent // Finds any differences
	var/b = plus.inherent ^ inherent // Finds any differences
	if(a.len && b.len)
		return FALSE
	
	return TRUE
