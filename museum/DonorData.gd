
extends RefCounted

# ==========================================
# 1. PLAYER'S INNER THOUGHTS
# ==========================================

static func opening_thoughts() -> Array[String]:
	return [
		"Well...",
		"After everything that happened, I somehow ended up working at this museum.",
		"The Museum of Broken Relationships. Quite a name, huh?",
		"Guess it's a fitting place for me to end up.",
		"Anyway...",
		"From what I've heard, all I have to do is wait for people to come in...",
		"Collect their donations, and fill out some forms.",
		"Sounds simple enough!",
		"[Glances at the seashell necklace on the desk.]",
		"...Funny how people hold on to the smallest things.",
		"...",
		"Whatever.",
        "First day on the job. Better not screw it up."
	]


# ==========================================
# 2. ALL THREE DONORS
# ==========================================

static func all_donors() -> Array[Dictionary]:
	var data: Array[Dictionary] = [

		# CLAIRE : GUITAR SLIDE =====================
		{
			"name": "Claire",

			"lines": [
				{"speaker": "PLAYER", "text": "Oh, hey. Welcome."},
				{"speaker": "CLAIRE", "text": "Hey. Is this where I drop something off?"},
				{"speaker": "PLAYER", "text": "Yep. You've come to the right place."},
				{"speaker": "CLAIRE", "text": "Good. Wasn't sure if I was supposed to make an appointment or something."},

				# Claire places the guitar slide on the desk.
				{"speaker": "PLAYER", "text": "So... what have we got here?"},
				{"speaker": "CLAIRE", "text": "A [url=item]guitar slide[/url]. A steel one, actually."},
				
				# ======================================
				# PAUSE CONVERSATION FOR INSPECTION
				# ======================================
				{"event": "inspect"},

				# ======================================
				# CONTINUE AFTER OBJECT INSPECTION
				# ======================================
				{"speaker": "PLAYER", "text": "Oh. You play?"},
				{"speaker": "CLAIRE", "text": "Not really. It belonged to someone I used to know."},
				{"speaker": "CLAIRE", "text": "It's pretty old. From the [url=age]1920s[/url], I think."},
				{"speaker": "PLAYER", "text": "Wow. That's almost an antique."},
				{"speaker": "CLAIRE", "text": "Yeah. The stamp's practically worn off."},
				{"speaker": "PLAYER", "text": "Must've been used a lot."},
				{"speaker": "CLAIRE", "text": "It was. He was a really talented musician."},
				{"speaker": "PLAYER", "text": "Your ex?"},
				{"speaker": "CLAIRE", "text": "Yes. We were together for [url=duration]six years[/url]."},
				{"speaker": "PLAYER", "text": "That's a long time."},

				{"speaker": "CLAIRE", "text": "He gave it to me once. I think it was probably his favorite thing."},
				{"speaker": "PLAYER", "text": "And you've kept it all this time?"},
				{"speaker": "CLAIRE", "text": "Guess so."},
				{"speaker": "PLAYER", "text": "Must mean a lot to you."},
				{"speaker": "CLAIRE", "text": "..."},

				{"speaker": "CLAIRE", "text": "Things weren't exactly great between us."},
				{"speaker": "CLAIRE", "text": "He could make beautiful music. But he could be pretty awful to live with."},
				{"speaker": "CLAIRE", "text": "It ended badly. I had to stay at a women's shelter when I finally left."},
				{"speaker": "PLAYER", "text": "..."},
				{"speaker": "CLAIRE", "text": "Sorry. Didn't mean to make things awkward."},
				{"speaker": "PLAYER", "text": "No, you're alright. You don't have to apologize."},
				{"speaker": "CLAIRE", "text": "Thanks."},

				{"speaker": "CLAIRE", "text": "Anyway... I've been carrying this thing around for years."},
				{"speaker": "PLAYER", "text": "Couldn't throw it away?"},
				{"speaker": "CLAIRE", "text": "Never quite managed to."},
				{"speaker": "PLAYER", "text": "Then... why donate it now?"},
				{"speaker": "CLAIRE", "text": "I guess I'm tired of keeping something that still feels like it belongs to him."},

				{"speaker": "PLAYER", "text": "...Yeah. I think I get that."},
				{"speaker": "CLAIRE", "text": "So, can you take it?"},
				{"speaker": "PLAYER", "text": "Of course."},
				{"speaker": "CLAIRE", "text": "Thanks. Bye."}
			],

			# ==========================================
			# OBJECT INSPECTION SETTINGS
			# ==========================================

			"inspection": {
				"small": "res://art/guitar_slide_small.png",
				"large": "res://art/guitar_slide_big.png",
				"medium": "res://art/guitar_slide_mid.png",

				"thoughts": [
					"A steel guitar slide...",
					"It's kinda rusty and heavy.",
					"There are scratches all over its surface.",
					"The stamp is almost completely worn away.",
					"It must have been used quite a lot."
				]
			},

			# ==========================================
			# 5. CORRECT FORM ANSWERS
			# ==========================================

			"clues": {
				"item": "steel guitar slide",
				"origin": "Not stated",
				"age": "1920s",
				"duration": "six years"
			},

			# ==========================================
			# 6. INCORRECT ANSWERS
			# ==========================================

			"decoys": [
				"1960s",
				"1990s",
				"two years",
				"ten years",
				"wooden guitar slide"
			]
		},


		{
			"name": "Vincent",

			# ==========================================
			# 1. FULL CONVERSATION
			# ==========================================

			"lines": [
				{"speaker": "PLAYER", "text": "Oh, hello."},
				{"speaker": "VINCENT", "text": "Hi."},
				{"speaker": "PLAYER", "text": "Here to make a donation?"},
				{"speaker": "VINCENT", "text": "Unless you're selling coffee."},
				{"speaker": "PLAYER", "text": "Unfortunately, no."},
				{"speaker": "VINCENT", "text": "Shame. You look like you could use some yourself."},
				{"speaker": "PLAYER", "text": "..."},

				# ======================================
				# 2. OBJECT INSPECTION
				# ======================================

				{"event": "inspect"},
				
				# Vincent hands over the shopping list.
				{"speaker": "PLAYER", "text": "So... what's this?"},
				{"speaker": "VINCENT", "text": "A [url=item]shopping list[/url]."},



				# ======================================
				# 3. CONVERSATION CONTINUES
				# ======================================

				{"speaker": "PLAYER", "text": "...A shopping list?"},
				{"speaker": "VINCENT", "text": "You heard me."},
				{"speaker": "PLAYER", "text": "Right. Sorry. Just wasn't expecting that."},
				{"speaker": "VINCENT", "text": "What, were you expecting an engagement ring? A love letter?"},
				{"speaker": "PLAYER", "text": "Well... something like that."},
				{"speaker": "VINCENT", "text": "How terribly predictable."},

				{"speaker": "PLAYER", "text": "So... who wrote this?"},
				{"speaker": "VINCENT", "text": "An [url=owner]old boyfriend[/url] of mine."},
				{"speaker": "PLAYER", "text": "Ah. How long ago?"},
				{"speaker": "VINCENT", "text": "Oh, let's see... [url=breakup_time]thirty-eight years[/url] since we split."},
				{"speaker": "PLAYER", "text": "Thirty-eight years?! And you kept his shopping list?"},
				{"speaker": "VINCENT", "text": "Not intentionally."},
				{"speaker": "PLAYER", "text": "Huh?"},
				{"speaker": "VINCENT", "text": "I was cleaning out some old clothes last week. Found it in the back pocket of a pair of [url=found_in]jean shorts[/url]."},
				{"speaker": "PLAYER", "text": "After thirty-eight years?"},
				{"speaker": "VINCENT", "text": "Funny, isn't it? All that time, and the damn thing was just sitting in my pocket."},

				{"speaker": "PLAYER", "text": "It's a pretty ordinary list."},
				{"speaker": "VINCENT", "text": "Oh, absolutely."},
				{"speaker": "VINCENT", "text": "But look at the handwriting."},
				{"speaker": "PLAYER", "text": "The handwriting?"},
				{"speaker": "VINCENT", "text": "See those [url=handwriting]little periods everywhere[/url]?"},
				{"speaker": "VINCENT", "text": "He loved those things. Put them after practically everything."},
				{"speaker": "VINCENT", "text": "Even his name. Every letter, every note... always a period at the end."},
				{"speaker": "VINCENT", "text": "He was an oddly specific man."},

				{"speaker": "VINCENT", "text": "I'd almost forgotten that about him."},
				{"speaker": "PLAYER", "text": "..."},
				{"speaker": "VINCENT", "text": "Then I found this stupid little list, and suddenly I remembered."},
				{"speaker": "PLAYER", "text": "You must've really loved him."},
				{"speaker": "VINCENT", "text": "I did."},

				{"speaker": "VINCENT", "text": "Didn't end particularly well, though."},
				{"speaker": "PLAYER", "text": "Oh..."},
				{"speaker": "VINCENT", "text": "Broke my heart when I was [url=age_at_breakup]twenty-seven[/url]."},
				{"speaker": "PLAYER", "text": "I'm sorry."},
				{"speaker": "VINCENT", "text": "Don't be. That was nearly four decades ago."},
				{"speaker": "VINCENT", "text": "Besides, I've had plenty of time to become a distinguished old gentleman."},

				{"speaker": "PLAYER", "text": "So... why donate it?"},
				{"speaker": "VINCENT", "text": "I suppose I don't need it anymore."},
				{"speaker": "PLAYER", "text": "After all these years?"},
				{"speaker": "VINCENT", "text": "Well, technically, I only knew I still had it for about a week."},
				{"speaker": "PLAYER", "text": "Fair enough."},
				{"speaker": "VINCENT", "text": "But throwing it away felt a little cruel."},
				{"speaker": "PLAYER", "text": "Cruel?"},
				{"speaker": "VINCENT", "text": "To the man I used to be, perhaps."},

				{"speaker": "VINCENT", "text": "He loved that boy an awful lot."},
				{"speaker": "PLAYER", "text": "..."},
				{"speaker": "VINCENT", "text": "Anyway. Enough about my tragic youth."},
				{"speaker": "VINCENT", "text": "You'll take it, won't you?"},
				{"speaker": "PLAYER", "text": "Of course."},
				{"speaker": "VINCENT", "text": "Okay, sweetheart. Bye."}
			],

			# ==========================================
			# 4. OBJECT INSPECTION SETTINGS
			# ==========================================

			"inspection": {
				"small": "res://art/shopping_list_small.png",
				"large": "res://art/shopping_list_big.png",
				"medium": "res://art/shopping_list_med.png",

				"thoughts": [
					"A shopping list...?",
					"Batteries, trash bags, detergent...",
					"And a green onion.",
					"It looks like an ordinary piece of paper.",
					"The handwriting is a little unusual, though.",
					"There are periods after almost every item.",
		            "I wonder why he kept something like this for so long."
				]
			},

			# ==========================================
			# 5. CORRECT FORM ANSWERS
			# ==========================================

			"clues": {
				"item": "shopping list",
				"breakup_time": "38 years ago",
				"age_at_breakup": "27 years old",
				"found_in": "jean shorts",
				"owner": "former boyfriend",
				"handwriting": "unusual periods in his handwriting"
			},

			# ==========================================
			# 6. INCORRECT ANSWERS
			# ==========================================

			"decoys": [
				"love letter",
				"18 years ago",
				"32 years old",
				"coat pocket",
				"former husband",
		        "neat cursive handwriting"
			]
		},



	{
		"name": "Evelyn",

		# ==========================================
		# 1. FULL CONVERSATION
		# ==========================================

		"lines": [
			{"speaker": "PLAYER", "text": "Oh, hello. Welcome to the Breakup Museum."},
			{"speaker": "EVELYN", "text": "Hellooo..."},
			{"speaker": "PLAYER", "text": "Here to make a donation?"},
			{"speaker": "EVELYN", "text": "Mhm! I brought something very special."},
			{"speaker": "PLAYER", "text": "Special?"},
			{"speaker": "EVELYN", "text": "Yes...It's a very special envelope"},
			
			{"speaker": "PLAYER", "text": "An envelope?"},
			{"speaker": "EVELYN", "text": "Hehe. Look closer."},
			{"speaker": "PLAYER", "text": "Hm?"},
			
			{"event": "inspect"},

			{"speaker": "PLAYER", "text": "There's... something stuck under the tape."},
			{"speaker": "EVELYN", "text": "You found it!"},
			{"speaker": "PLAYER", "text": "Is that... hair?"},
			{"speaker": "EVELYN", "text": "A [url=contents]single strand[/url]. Isn't it lovely?"},
			{"speaker": "PLAYER", "text": "...Right."},
			{"speaker": "EVELYN", "text": "Careful with it, okay? It's the only one I have."},
			{"speaker": "PLAYER", "text": "Uh... sure."},

			{"speaker": "PLAYER", "text": "So... whose hair is it?"},
			{"speaker": "EVELYN", "text": "[url=owner]Colin's[/url]."},
			{"speaker": "PLAYER", "text": "Colin?"},
			{"speaker": "EVELYN", "text": "Mhm. My boyfriend. Well... my ex-boyfriend."},
			{"speaker": "PLAYER", "text": "Ah. I see."},
			{"speaker": "EVELYN", "text": "He had the prettiest [url=hair_color]auburn curls[/url]. So soft, too..."},
			{"speaker": "PLAYER", "text": "Sounds like you remember him pretty well."},
			{"speaker": "EVELYN", "text": "Of course I do."},

			{"speaker": "", "text": "[i]Giggles.[/i]"},

			{"speaker": "PLAYER", "text": "So... how did you two meet?"},
			{"speaker": "EVELYN", "text": "At an [url=meeting_place]amusement park in Salisbury Beach[/url]."},
			{"speaker": "EVELYN", "text": "He was working the [url=job]Ferris wheel[/url] that summer."},

			{"speaker": "EVELYN", "text": "He was [url=nationality]Scottish[/url], you know. Such a lovely accent."},
			{"speaker": "EVELYN", "text": "After summer ended, I moved away to teach English."},
			{"speaker": "PLAYER", "text": "Where to?"},
			{"speaker": "EVELYN", "text": "[url=destination]Karviná[/url]. A little coal-mining town near the Czech-Polish border."},
			{"speaker": "PLAYER", "text": "That's pretty far away."},
			{"speaker": "EVELYN", "text": "Mhm. And terribly lonely."},
			{"speaker": "EVELYN", "text": "Everything was so gray there. The buildings, the sky... even the people sometimes."},
			{"speaker": "PLAYER", "text": "Sounds depressing."},
			{"speaker": "EVELYN", "text": "Oh, it was."},
			{"speaker": "EVELYN", "text": "But Colin wrote to me."},

			{"speaker": "EVELYN", "text": "Letters and letters... sometimes they were the only good thing about my day."},
			{"speaker": "EVELYN", "text": "I'd check the mailbox every single day."},
			{"speaker": "PLAYER", "text": "So... how did his hair end up in there?"},
			{"speaker": "EVELYN", "text": "Oh! That was an accident."},
			{"speaker": "PLAYER", "text": "An accident?"},
			{"speaker": "EVELYN", "text": "He taped the envelope shut, and one of his little curls got caught underneath."},

			{"speaker": "EVELYN", "text": "A little piece of him, all the way across the ocean..."},

			{"speaker": "", "text": "[i]Gently strokes the envelope with her finger.[/i]"},

			{"speaker": "EVELYN", "text": "A part of his body... his DNA..."},
			{"speaker": "EVELYN", "text": "The very same DNA that would've been passed down to our children someday."},
			{"speaker": "PLAYER", "text": "..."},
			{"speaker": "PLAYER", "text": "...Your children?"},
			{"speaker": "EVELYN", "text": "Mhm!"},

			{"speaker": "EVELYN", "text": "We would've had beautiful children, don't you think?"},
			{"speaker": "PLAYER", "text": "Uh..."},
			{"speaker": "EVELYN", "text": "With his lovely auburn curls..."},

			{"speaker": "", "text": "..."},

			{"speaker": "PLAYER", "text": "So... what happened between you two?"},
			{"speaker": "EVELYN", "text": "Hm?"},
			{"speaker": "PLAYER", "text": "You said he was your ex."},
			{"speaker": "EVELYN", "text": "Oh. Right."},
			{"speaker": "EVELYN", "text": "He stopped writing."},
			{"speaker": "PLAYER", "text": "...Just like that?"},
			{"speaker": "EVELYN", "text": "Mhm."},
			{"speaker": "PLAYER", "text": "Did he ever explain why?"},
			{"speaker": "EVELYN", "text": "Nope!"},
			{"speaker": "EVELYN", "text": "I kept checking, though."},
			{"speaker": "PLAYER", "text": "The mailbox?"},
			{"speaker": "EVELYN", "text": "Every day."},
			{"speaker": "EVELYN", "text": "I thought maybe he'd forgotten. Or maybe the letters got lost..."},
			{"speaker": "EVELYN", "text": "So I waited."},
			{"speaker": "PLAYER", "text": "For how long?"},
			{"speaker": "EVELYN", "text": "Long enough."},

			{"speaker": "EVELYN", "text": "...Funny, isn't it? How someone can just disappear from your life like that?"},
			{"speaker": "EVELYN", "text": "But at least I still had this."},
			{"speaker": "EVELYN", "text": "A little proof that he was real."},
			
			{"speaker": "PLAYER", "text": "..."},
			{"speaker": "PLAYER", "text": "So... why donate it now?"},
			{"speaker": "EVELYN", "text": "Oh, I just thought it'd be nice."},
			{"speaker": "PLAYER", "text": "Nice?"},
			{"speaker": "EVELYN", "text": "For someone else to look after him for a change."},
			{"speaker": "PLAYER", "text": "...Him?"},
			{"speaker": "EVELYN", "text": "The envelope."},

			{"speaker": "PLAYER", "text": "Well... I can take it."},
			{"speaker": "EVELYN", "text": "Of course!"},
			{"speaker": "EVELYN", "text": "Please take good care of him. Bye!"}
		],

		# ==========================================
		# 4. OBJECT INSPECTION SETTINGS
		# ==========================================

		"inspection": {
			"small": "res://art/envelope_small.png",
			"large": "res://art/envelope_big.png",
			"medium": "res://art/envelope_mid.png",

			"thoughts": [
				"A faded blue envelope...",
				"The paper looks old and worn.",
				"There's a piece of tape across the flap.",
				"Wait... is something caught underneath it?",
				"It looks like a tiny strand of hair.",
				"That's an unusual thing to keep."
			]
		},

		# ==========================================
		# 5. CORRECT FORM ANSWERS
		# ==========================================

		"clues": {
			"item": "blue envelope with a strand of hair",
			"contents": "single strand of hair",
			"owner": "Colin",
			"hair_color": "auburn",
			"meeting_place": "amusement park in Salisbury Beach",
			"job": "Ferris wheel operator",
			"nationality": "Scottish",
			"destination": "Karviná"
		},

		# ==========================================
		# 6. INCORRECT ANSWERS
		# ==========================================

		"decoys": [
			"blue envelope with a photograph",
			"lock of hair",
			"Daniel",
			"blond",
			"beach restaurant",
			"carousel operator",
			"Irish",
			"Prague"
		]
	},

	]

	return data
