/obj/structure/closet/crate
	name = "crate"
	desc = "A rectangular steel crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"
	closet_appearance = /decl/closet_appearance/crate
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	setup = 0
	storage_types = CLOSET_STORAGE_ITEMS
	var/points_per_crate = 5
	var/rigged = 0

/obj/structure/closet/crate/open()
	if((atom_flags & ATOM_FLAG_OPEN_CONTAINER) && !opened && can_open())
		object_shaken()
	. = ..()
	if(.)
		if(rigged)
			visible_message("<span class='danger'>There are wires attached to the lid of [src]...</span>")
			for(var/obj/item/device/assembly_holder/H in src)
				H.process_activation(usr)
			for(var/obj/item/device/assembly/A in src)
				A.activate()

/obj/structure/closet/crate/examine(mob/user)
	. = ..()
	if(rigged && opened)
		var/list/devices = list()
		for(var/obj/item/device/assembly_holder/H in src)
			devices += H
		for(var/obj/item/device/assembly/A in src)
			devices += A
		to_chat(user,"There are some wires attached to the lid, connected to [english_list(devices)].")

/obj/structure/closet/crate/attackby(obj/item/W as obj, mob/user as mob)
	if(opened)
		return ..()
	else if(istype(W, /obj/item/stack/package_wrap))
		return
	else if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W
		if(rigged)
			to_chat(user, "<span class='notice'>[src] is already rigged!</span>")
			return
		if (C.use(1))
			to_chat(user, "<span class='notice'>You rig [src].</span>")
			rigged = 1
			return
	else if(istype(W, /obj/item/device/assembly_holder) || istype(W, /obj/item/device/assembly))
		if(rigged)
			if(!user.unEquip(W, src))
				return
			to_chat(user, "<span class='notice'>You attach [W] to [src].</span>")
			return
	else if(isWirecutter(W))
		if(rigged)
			to_chat(user, "<span class='notice'>You cut away the wiring.</span>")
			playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
			rigged = 0
			return
	else
		return ..()

/obj/structure/closet/crate/secure
	desc = "A secure crate."
	name = "Secure crate"
	icon_state = "securecrate"
	icon_opened = "securecrateopen"
	icon_closed = "securecrate"
	var/redlight = "securecrater"
	var/greenlight = "securecrateg"
	var/sparks = "securecratesparks"
	var/emag = "securecrateemag"
	closet_appearance = /decl/closet_appearance/crate/secure
	setup = CLOSET_HAS_LOCK
	locked = TRUE

/obj/structure/closet/crate/secure/Initialize()
	. = ..()
	update_icon()

/obj/structure/closet/crate/plastic
	name = "plastic crate"
	desc = "A rectangular plastic crate."
	icon_state = "plasticcrate"
	icon_opened = "plasticcrateopen"
	icon_closed = "plasticcrate"
	points_per_crate = 1

/obj/structure/closet/crate/internals
	name = "internals crate"
	desc = "A internals crate."
	icon_state = "o2crate"
	icon_opened = "o2crateopen"
	icon_closed = "o2crate"

/obj/structure/closet/crate/internals/fuel
	name = "\improper Fuel tank crate"
	desc = "A fuel tank crate."

/obj/structure/closet/crate/internals/fuel/WillContain()
	return list(/obj/item/tank/hydrogen = 4)

/obj/structure/closet/crate/trashcart
	name = "trash cart"
	desc = "A heavy, metal trashcart with wheels."
	icon_state = "trashcart"
	icon_opened = "trashcartopen"
	icon_closed = "trashcart"

/obj/structure/closet/crate/medical
	name = "medical crate"
	desc = "A medical crate."
	icon_state = "medicalcrate"
	icon_opened = "medicalcrateopen"
	icon_closed = "medicalcrate"

/obj/structure/closet/crate/rcd
	name = "\improper RCD crate"
	desc = "A crate with rapid construction device."
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"

/obj/structure/closet/crate/rcd/WillContain()
	return list(
		/obj/item/rcd_ammo = 3,
		/obj/item/rcd
	)

/obj/structure/closet/crate/solar
	name = "solar pack crate"

/obj/structure/closet/crate/solar/WillContain()
	return list(
		/obj/item/solar_assembly = 14,
		/obj/item/stock_parts/circuitboard/solar_control,
		/obj/item/tracker_electronics,
		/obj/item/paper/solar
	)

/obj/structure/closet/crate/solar_assembly
	name = "solar assembly crate"

/obj/structure/closet/crate/solar_assembly/WillContain()
	return list(/obj/item/solar_assembly = 16)

/obj/structure/closet/crate/freezer
	name = "freezer"
	desc = "A freezer."
	icon_state = "freezer"
	icon_opened = "freezeropen"
	icon_closed = "freezer"
	temperature = -16 CELSIUS

	var/target_temp = T0C - 40
	var/cooling_power = 40

/obj/structure/closet/crate/freezer/return_air()
	var/datum/gas_mixture/gas = (..())
	if(!gas)	return null
	var/datum/gas_mixture/newgas = new/datum/gas_mixture()
	newgas.copy_from(gas)
	if(newgas.temperature <= target_temp)	return

	if((newgas.temperature - cooling_power) > target_temp)
		newgas.temperature -= cooling_power
	else
		newgas.temperature = target_temp
	return newgas

/obj/structure/closet/crate/freezer/ProcessAtomTemperature()
	return PROCESS_KILL

/obj/structure/closet/crate/freezer/rations //For use in the escape shuttle
	name = "emergency rations"
	desc = "A crate of emergency rations."

/obj/structure/closet/crate/freezer/rations/WillContain()
	return list(/obj/random/mre = 6, /obj/item/reagent_containers/food/drinks/cans/waterbottle = 12)

/obj/structure/closet/crate/freezer/meat
	name = "meat crate"
	desc = "A crate of meat."

/obj/structure/closet/crate/freezer/meat/WillContain()
	return list(
		/obj/item/reagent_containers/food/snacks/meat/beef = 4,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh = 4,
		/obj/item/reagent_containers/food/snacks/fish = 4
	)

/obj/structure/closet/crate/bin
	name = "large bin"
	desc = "A large bin."
	icon_state = "largebin"
	icon_opened = "largebinopen"
	icon_closed = "largebin"

/obj/structure/closet/crate/radiation
	name = "radioactive crate"
	desc = "A leadlined crate with a radiation sign on it."
	icon_state = "radiation"
	icon_opened = "radiationopen"
	icon_closed = "radiation"

/obj/structure/closet/crate/radiation_gear
	name = "radioactive gear crate"
	desc = "A crate with a radiation sign on it."
	icon_state = "radiation"
	icon_opened = "radiationopen"
	icon_closed = "radiation"

/obj/structure/closet/crate/radiation_gear/WillContain()
	return list(/obj/item/clothing/suit/radiation = 8)

/obj/structure/closet/crate/secure/weapon
	name = "weapons crate"
	desc = "A secure weapons crate."
	icon_state = "weaponcrate"
	icon_opened = "weaponcrateopen"
	icon_closed = "weaponcrate"

/obj/structure/closet/crate/secure/phoron
	name = "phoron crate"
	desc = "A secure phoron crate."
	icon_state = "phoroncrate"
	icon_opened = "phoroncrateopen"
	icon_closed = "phoroncrate"

/obj/structure/closet/crate/secure/shuttle
	name = "storage compartment"
	desc = "A secure storage compartment bolted to the floor, to secure loose objects on Zero-G flights."
	anchored = TRUE
	closet_appearance = /decl/closet_appearance/crate/secure/shuttle

/obj/structure/closet/crate/secure/gear
	name = "gear crate"
	desc = "A secure gear crate."
	icon_state = "secgearcrate"
	icon_opened = "secgearcrateopen"
	icon_closed = "secgearcrate"

/obj/structure/closet/crate/secure/hydrosec
	name = "secure hydroponics crate"
	desc = "A crate with a lock on it, painted in the scheme of botany and botanists."
	icon_state = "hydrosecurecrate"
	icon_opened = "hydrosecurecrateopen"
	icon_closed = "hydrosecurecrate"

/obj/structure/closet/crate/large
	name = "large crate"
	desc = "A hefty metal crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "largemetal"
	icon_opened = "largemetalopen"
	icon_closed = "largemetal"
	storage_capacity = 2 * MOB_LARGE
	storage_types = CLOSET_STORAGE_ITEMS|CLOSET_STORAGE_STRUCTURES

/obj/structure/closet/crate/large/hydroponics
	icon_state = "hydro_crate_large"
	icon_opened = "hydro_crate_large_open"
	icon_closed = "hydro_crate_large"

/obj/structure/closet/crate/secure/large
	name = "large crate"
	desc = "A hefty metal crate with an electronic locking system."
	icon = 'icons/obj/storage.dmi'
	icon_state = "largemetal"
	icon_opened = "largemetalopen"
	icon_closed = "largemetal"
	redlight = "largemetalr"
	greenlight = "largemetalg"

	storage_capacity = 2 * MOB_LARGE
	storage_types = CLOSET_STORAGE_ITEMS|CLOSET_STORAGE_STRUCTURES

/obj/structure/closet/crate/secure/large/phoron
	icon_state = "phoron_crate_large"
	icon_opened = "phoron_crate_large_open"
	icon_closed = "phoron_crate_large"

//fluff variant
/obj/structure/closet/crate/secure/large/reinforced
	desc = "A hefty, reinforced metal crate with an electronic locking system."
	icon_state = "largermetal"
	icon_opened = "largermetalopen"
	icon_closed = "largermetal"

/obj/structure/closet/crate/hydroponics
	name = "hydroponics crate"
	desc = "All you need to destroy those pesky weeds and pests."
	icon_state = "hydrocrate"
	icon_opened = "hydrocrateopen"
	icon_closed = "hydrocrate"

/obj/structure/closet/crate/hydroponics/prespawned/WillContain()
	return list(
		/obj/item/reagent_containers/spray/plantbgone = 2,
		/obj/item/material/minihoe = 2,
		/obj/item/storage/plants = 2,
		/obj/item/material/hatchet = 2,
		/obj/item/wirecutters/clippers = 2,
		/obj/item/device/scanner/plant = 2
	)

/obj/structure/closet/crate/secure/biohazard
	name = "biohazard cart"
	desc = "A heavy cart with extensive sealing. You shouldn't eat things you find in it."
	icon_state = "biohazard"
	icon_opened = "biohazardopen"
	icon_closed = "biohazard"
	open_sound = 'sound/items/Deconstruct.ogg'
	close_sound = 'sound/items/Deconstruct.ogg'
	req_access = list(access_xenobiology)
	storage_capacity = 2 * MOB_LARGE
	storage_types = CLOSET_STORAGE_ITEMS|CLOSET_STORAGE_MOBS|CLOSET_STORAGE_STRUCTURES

/obj/structure/closet/crate/secure/biohazard/blanks/WillContain()
	return list(/obj/structure/closet/body_bag/cryobag/blank)

/obj/structure/closet/crate/secure/biohazard/blanks/can_close()
	for(var/obj/structure/closet/closet in get_turf(src))
		if(closet != src && !(istype(closet, /obj/structure/closet/body_bag/cryobag)))
			return 0
	return 1

/obj/structure/closet/crate/secure/biohazard/alt
	name = "biowaste disposal cart"
	desc = "A heavy cart used for organ disposal with markings indicating the things inside are probably gross."
	req_access = list(access_surgery)
	closet_appearance = /decl/closet_appearance/cart/biohazard/alt

/obj/structure/closet/crate/paper_refill
	name = "paper refill crate"
	desc = "A rectangular plastic crate, filled up with blank papers for refilling bins and printers. A bureaucrat's favorite."
	icon_state = "plasticcrate"
	icon_opened = "plasticcrateopen"
	icon_closed = "plasticcrate"

/obj/structure/closet/crate/paper_refill/WillContain()
	return list(/obj/item/paper = 30)

/obj/structure/closet/crate/uranium
	name = "fissibles crate"
	desc = "A crate with a radiation sign on it."
	icon_state = "radiation"
	icon_opened = "radiationopen"
	icon_closed = "radiation"

/obj/structure/closet/crate/uranium/WillContain()
	return list(/obj/item/stack/material/uranium/ten = 5)