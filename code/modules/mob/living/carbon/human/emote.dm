/mob/living/carbon/human/emote(var/act,var/m_type=1,var/message = null, var/cooldown = 2)
	var/param = null

	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's  unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	var/muzzled = istype(src.wear_mask, /obj/item/clothing/mask/muzzle)
	//var/m_type = 1

	for (var/obj/item/weapon/implant/I in src)
		if (I.implanted)
			I.trigger(act, src)

	if(src.stat == 2.0 && (act != "deathgasp"))
		return
	if(emote_cooldown > 0)
		return
	switch(act)
		if ("airguitar")
			if (!src.restrained())
				message = "<B>[src]</B> ������� �� ������� � ������� �������, ��� ����� ��������."
				m_type = 1

		if ("blink")
			message = "<B>[src]</B> �������."
			m_type = 1

		if ("blink_r")
			message = "<B>[src]</B> ������ �������."
			m_type = 1

		if ("bow")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "<B>[src]</B> ��������� [param]."
				else
					message = "<B>[src]</B> ���������."
			m_type = 1

		if ("custom")
			var/input = copytext(sanitize(input("Choose an emote to display.") as text|null),1,MAX_MESSAGE_LEN)
			if (!input)
				return
			var/input2 = input("��� ������� ��� �������� ������?") in list("Visible","Hearable")
			if (input2 == "Visible")
				m_type = 1
			else if (input2 == "Hearable")
				if (src.miming)
					return
				m_type = 2
			else
				alert("���������� ������������ ��� ������, ��� ������ ���� ������� ��� ��������.")
				return
			return custom_emote(m_type, message)

		if ("me")
			if(silent)
				return
			if (src.client)
				if (client.prefs.muted & MUTE_IC)
					src << "\red You cannot send IC messages (muted)."
					return
				if (src.client.handle_spam_prevention(message,MUTE_IC))
					return
			if (stat)
				return
			if(!(message))
				return
			return custom_emote(m_type, message)

		if ("salute")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "<B>[src]</B> ������ ����� [param]."
				else
					message = "<B>[src]</b> ��������."
			m_type = 1

		if ("choke")
			if(miming)
				message = "<B>[src]</B> �������� ��������� �� �����!"
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ����������!"
					m_type = 2
				else
					message = "<B>[src]</B> ������ ������� ���."
					m_type = 2

		if ("clap")
			if (!src.restrained())
				message = "<B>[src]</B>  �������."
				m_type = 2
				if(miming)
					m_type = 1
		if ("flap")
			if (!src.restrained())
				message = "<B>[src]</B> ������� ��������."
				m_type = 2
				if(miming)
					m_type = 1

		if ("aflap")
			if (!src.restrained())
				message = "<B>[src]</B> ������ ������� ��������!"
				m_type = 2
				if(miming)
					m_type = 1

		if ("drool")
			message = "<B>[src]</B> ������� �����."
			m_type = 1

		if ("eyebrow")
			message = "<B>[src]</B> ��������� �����."
			m_type = 1

		if ("chuckle")
			if(miming)
				message = "<B>[src]</B> �������� ��������."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ��������."
					m_type = 2
				else
					message = "<B>[src]</B> �����."
					m_type = 2

		if ("twitch")
			message = "<B>[src]</B> ������� ���������."
			m_type = 1

		if ("twitch_s")
			message = "<B>[src]</B> ���������."
			m_type = 1

		if ("faint")
			message = "<B>[src]</B> ������ � �������."
			if(src.sleeping)
				return //Can't faint while asleep
			src.sleeping += 10 //Short-short nap
			m_type = 1

		if ("cough")
			if(miming)
				message = "<B>[src]</B> �������� �������!"
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> �������!"
					m_type = 2
				else
					message = "<B>[src]</B> ������ ������� ���."
					m_type = 2

		if ("frown")
			message = "<B>[src]</B> ��������."
			m_type = 1

		if ("nod")
			message = "<B>[src]</B> ������."
			m_type = 1

		if ("blush")
			message = "<B>[src]</B> ��������."
			m_type = 1

		if ("wave")
			message = "<B>[src]</B> ��������."
			m_type = 1

		if ("gasp")
			if(miming)
				message = "<B>[src]</B>  �� ��������, ����������!"
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ����������!"
					m_type = 2
				else
					message = "<B>[src]</B> ������ ������ ���."
					m_type = 2

		if ("deathgasp")
			message = "<B>[src]</B> seizes up and falls limp, \his eyes dead and lifeless..."
			m_type = 1

		if ("giggle")
			if(miming)
				message = "<B>[src]</B> ���� ��������!"
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ��������."
					m_type = 2
				else
					message = "<B>[src]</B> �����."
					m_type = 2

		if ("glare")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null

			if (param)
				message = "<B>[src]</B> ������� �� [param]."
			else
				message = "<B>[src]</B> �������."

		if ("stare")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null

			if (param)
				message = "<B>[src]</B> ��������� �� [param]."
			else
				message = "<B>[src]</B> ���������."

		if ("look")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break

			if (!M)
				param = null

			if (param)
				message = "<B>[src]</B> ������� �� [param]."
			else
				message = "<B>[src]</B> �������."
			m_type = 1

		if ("grin")
			message = "<B>[src]</B> ������ ����."
			m_type = 1

		if ("cry")
			if(miming)
				message = "<B>[src]</B> ������."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ������."
					m_type = 2
				else
					message = "<B>[src]</B> ������ ������ ���."// \He frowns.
					m_type = 2

		if ("sigh")
			if(miming)
				message = "<B>[src]</B> ��������."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> �����."
					m_type = 2
				else
					message = "<B>[src]</B> ������ ������ ���."
					m_type = 2

		if ("laugh")
			if(miming)
				message = "<B>[src]</B> ������ ������."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> �������."
					m_type = 2
				else
					message = "<B>[src]</B> �����."
					m_type = 2

		if ("mumble")
			message = "<B>[src]</B> ��������!"
			m_type = 2
			if(miming)
				m_type = 1

		if ("grumble")
			if(miming)
				message = "<B>[src]</B> ������!"
				m_type = 1
			if (!muzzled)
				message = "<B>[src]</B> ������!"
				m_type = 2
			else
				message = "<B>[src]</B> �����."
				m_type = 2

		if ("groan")
			if(miming)
				message = "<B>[src]</B> ������ ����!"
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> c�����!"
					m_type = 2
				else
					message = "<B>[src]</B> ������ ������� ���."
					m_type = 2

		if ("moan")
			if(miming)
				message = "<B>[src]</B>  �������� �������!"
				m_type = 1
			else
				message = "<B>[src]</B> ������ �� �����������!"
				m_type = 2

		if ("johnny")
			var/M
			if (param)
				M = param
			if (!M)
				param = null
			else
				if(miming)
					message = "<B>[src]</B>  ������������ ��������� � �������� ��� \"[M]\" � ����."
					m_type = 1
				else
					message = "<B>[src]</B> says, \"[M], please. He had a family.\" [src.name] ������������ ��������� � �������� ���� ���."
					m_type = 2

		if ("point")
			if (!src.restrained())
				var/mob/M = null
				if (param)
					for (var/atom/A as mob|obj|turf|area in view(null, null))
						if (param == A.name)
							M = A
							break

				if (!M)
					message = "<B>[src]</B> ����� �������."
				else
					M.point()

				if (M)
					message = "<B>[src]</B> ���������� �� [M]."
				else
			m_type = 1

		if ("raise")
			if (!src.restrained())
				message = "<B>[src]</B> ��������� ����."
			m_type = 1

		if("shake")
			message = "<B>[src]</B> ������ �������."
			m_type = 1

		if ("shrug")
			message = "<B>[src]</B> �������� �������."
			m_type = 1

		if ("signal")
			if (!src.restrained())
				var/t1 = round(text2num(param))
				if (isnum(t1))
					if (t1 <= 5 && (!src.r_hand || !src.l_hand))
						message = "<B>[src]</B> ��������� [t1] �������."
					else if (t1 <= 10 && (!src.r_hand && !src.l_hand))
						message = "<B>[src]</B> ��������� [t1] �������."
			m_type = 1

		if ("smile")
			message = "<B>[src]</B> ���������."
			m_type = 1

		if ("shiver")
			message = "<B>[src]</B> �����������."
			m_type = 2
			if(miming)
				m_type = 1

		if ("pale")
			message = "<B>[src]</B> �������� �� �������."
			m_type = 1

		if ("tremble")
			message = "<B>[src]</B> ������ � ������!"
			m_type = 1

		if ("sneeze")
			if (miming)
				message = "<B>[src]</B> ������."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ������."
					m_type = 2
				else
					message = "<B>[src]</B> ������ �������� ���."
					m_type = 2

		if ("sniff")
			message = "<B>[src]</B> ������."
			m_type = 2
			if(miming)
				m_type = 1

		if ("snore")
			if (miming)
				message = "<B>[src]</B> ������ �����."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ������."
					m_type = 2
				else
					message = "<B>[src]</B> �����."
					m_type = 2

		if ("whimper")
			if (miming)
				message = "<B>[src]</B> ������ �� ����."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ������."
					m_type = 2
				else
					message = "<B>[src]</B> ������ ������ ���."
					m_type = 2

		if ("wink")
			message = "<B>[src]</B> �����������."
			m_type = 1

		if ("yawn")
			if (!muzzled)
				message = "<B>[src]</B> ������."
				m_type = 2
				if(miming)
					m_type = 1

		if ("collapse")
			Paralyse(2)
			message = "<B>[src]</B> ������!"
			m_type = 2
			if(miming)
				m_type = 1

		if("hug")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					message = "<B>[src]</B> �������� [M]."
				else
					message = "<B>[src]</B> �������� ����."

		if ("handshake")
			m_type = 1
			if (!src.restrained() && !src.r_hand)
				var/mob/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					if (M.canmove && !M.r_hand && !M.restrained())
						message = "<B>[src]</B> �������� ���� [M]."
					else
						message = "<B>[src]</B> ����������� ���� [M]."

		if("dap")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M)
					message = "<B>[src]</B> ��� �������� [M]."
				else
					message = "<B>[src]</B> ��������������� ��� �� ����� ����� ���� ���� �������� ��� �������� ����. ��������." // Translate it 3010

		if ("scream")
			if (miming)
				message = "<B>[src]</B> ������!"
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> ������!"
					call_sound_emote("scream")
					m_type = 2
				else
					message = "<B>[src]</B> ������ ����� ������� ���."
					m_type = 2

		if ("help")
			src << "blink, blink_r, blush, bow-(none)/mob, burp, choke, chuckle, clap, collapse, cough,\ncry, custom, deathgasp, drool, eyebrow, frown, gasp, giggle, groan, grumble, handshake, hug-(none)/mob, glare-(none)/mob,\ngrin, laugh, look-(none)/mob, moan, mumble, nod, pale, point-atom, raise, salute, shake, shiver, shrug,\nsigh, signal-#1-10, smile, sneeze, sniff, snore, stare-(none)/mob, tremble, twitch, twitch_s, whimper,\nwink, yawn"

		else
			message = "<B>[src]</B> [act]."
			cooldown = 0





	if (message)
		message = sanitize_russian(message)
		log_emote("[name]/[key] : [message]")

 //Hearing gasp and such every five seconds is not good emotes were not global for a reason.
 // Maybe some people are okay with that.

		for(var/mob/M in dead_mob_list)
			if(!M.client || istype(M, /mob/new_player))
				continue //skip monkeys, leavers and new players
			if(M.stat == DEAD && (M.client.prefs.toggles & CHAT_GHOSTSIGHT) && !(M in viewers(src,null)))
				M.show_message(message)


		if (m_type & 1)
			for (var/mob/O in get_mobs_in_view(world.view,src))
				O.show_message(message, m_type)
		else if (m_type & 2)
			for (var/mob/O in (hearers(src.loc, null) | get_mobs_in_view(world.view,src)))
				O.show_message(message, m_type)

	emote_cooldown += cooldown

/mob/living/carbon/human/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	pose = copytext(sanitize_uni(input(usr, "This is [src]. \He is...", "Pose", null)  as text), 1, MAX_MESSAGE_LEN)

/mob/living/carbon/human/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	flavor_text =  copytext(sanitize(input(usr, "Please enter your new flavour text.", "Flavour text", null)  as text), 1)

/mob/living/carbon/human/proc/call_sound_emote(var/E)
	switch(E)
		if("scream")
			for(var/mob/M in viewers(usr, null))
				if (src.gender == "male")
					M << sound(pick('sound/voice/Screams_Male_1.ogg', 'sound/voice/Screams_Male_2.ogg', 'sound/voice/Screams_Male_3.ogg'))
				else
					M << sound(pick('sound/voice/Screams_Woman_1.ogg', 'sound/voice/Screams_Woman_2.ogg', 'sound/voice/Screams_Woman_3.ogg'))

