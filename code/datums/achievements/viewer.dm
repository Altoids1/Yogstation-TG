//UI adapted from https://github.com/tgstation/tgstation/pull/47058

/datum/achievement_browser
	var/client/client

/datum/achievement_browser/New(client/C)
	client = C

/datum/achievement_browser/proc/get_achievements(client/C)
	var/list/A = list()
	for(var/i in SSachievements.achievements)
		A[i] = SSachievements.has_achievement(i, C)
	return A

/datum/achievement_browser/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.always_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "achievements", "achievements", 450, 450, master_ui, state)
		ui.open()

/datum/achievement_browser/ui_data(mob/user)
	var/data = list("categories" = list())
	var/list/achievements = get_achievements(user.client)
	
	var/list/temp_categories = list()
	for(var/B in achievements)
		var/datum/achievement/achievement = B
		if(!achievement.hidden || achievements[achievement]) // If we don't have to display this achievement
			continue // then don't even send it to their GUI then	
		var/list/A = list(
			"name" = achievement.name,
			"unlocked" = achievements[achievement],
			"desc" = achievement.desc,
		)
		if(!temp_categories[achievement.category])
			temp_categories[achievement.category] = list()
		temp_categories[achievement.category] += list(A) // Has to be made into a list so that A's elements aren't just added in elementwise
	
	for(var/C in temp_categories)
		data["categories"] = list("category_name" = C, "achievements" = temp_categories[C])
		
	return data

/client/verb/checkachievements()
	set category = "OOC"
	set name = "Check achievements"
	set desc = "See all of your achivements"

	if(!SSachievements.initialized)
		to_chat(src, "<span class='warning'>SSachievements has not initialized yet, please wait.</span>")
		return

	var/datum/achievement_browser/achievement_browser = SSachievements.get_browser(src)
	if(!achievement_browser)
		achievement_browser = new(src)
		SSachievements.browsers[ckey] = achievement_browser
	achievement_browser.ui_interact(usr)
