/obj/structure/glowshroom
	spreadIntoAdjacentChance = 10 // Much lower than the /TG/ value

/obj/structure/glowshroom/Spread()
	if(!myseed.yield)
		return
	
	var/turf/ownturf = loc
	var/shrooms_planted = 0
	
	var/list/possibleLocs = list()
	for(var/turf/open/floor/earth in view(3,src))
		if(is_type_in_typecache(earth, blacklisted_glowshroom_turfs))
			continue
		if(!ownturf.CanAtmosPass(earth))
			continue
		if(prob(spreadIntoAdjacentChance) || !locate(/obj/structure/glowshroom) in view(1,earth))
			possibleLocs += earth
		CHECK_TICK
	if(!possibleLocs.len)
		break
	for(var/i in 1 to myseed.yield)
		if(prob(1/(generation * generation) * 100))//This formula gives you diminishing returns based on generation. 100% with 1st gen, decreasing to 25%, 11%, 6, 4, 2...
			var/turf/newLoc = pick(possibleLocs)
			var/shroomCount = 0 //hacky
			var/placeCount = 1
			for(var/obj/structure/glowshroom/shroom in newLoc)
				shroomCount++
			for(var/wallDir in GLOB.cardinals)
				var/turf/isWall = get_step(newLoc,wallDir)
				if(isWall.density)
					placeCount++
			if(shroomCount >= placeCount)
				continue

			var/obj/structure/glowshroom/child = new type(newLoc, myseed, TRUE)
			child.generation = generation + 1
			shrooms_planted++

			CHECK_TICK
		else
			shrooms_planted++ //if we failed due to generation, don't try to plant one later
	if(shrooms_planted < myseed.yield) //if we didn't get all possible shrooms planted, try again later
		myseed.yield -= shrooms_planted
		delay *= 1.5 // Delay gets longer the more we try to spread
		addtimer(CALLBACK(src, .proc/Spread), delay)