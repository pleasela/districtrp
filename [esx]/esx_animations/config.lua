Config = {}

Config.Animations = {
	
	{
		name  = 'festives',
		label = 'Festives',
		items = {
	    {label = "Smoke cigarette", type = "scenario", data = {anim = "WORLD_HUMAN_SMOKING"}},
	    {label = "Play music", type = "scenario", data = {anim = "WORLD_HUMAN_MUSICIAN"}},
	    {label = "Dj", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@dj", anim = "dj"}},
	    {label = "Drink Beer", type = "scenario", data = {anim = "WORLD_HUMAN_DRINKING"}},
	    {label = "Beer in zik", type = "scenario", data = {anim = "WORLD_HUMAN_PARTYING"}},
	    {label = "Air Guitar", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@air_guitar", anim = "air_guitar"}},
	    {label = "Air Shagging", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@air_shagging", anim = "air_shagging"}},
	    {label = "Rock'n'roll", type = "anim", data = {lib = "mp_player_int_upperrock", anim = "mp_player_int_rock"}},
	    {label = "Smoke Pot", type = "scenario", data = {anim = "WORLD_HUMAN_SMOKING_POT"}},
	    {label = "Stuffed on the spot", type = "anim", data = {lib = "amb@world_human_bum_standing@drunk@idle_a", anim = "idle_a"}},
	    {label = "Vomit by car", type = "anim", data = {lib = "oddjobs@taxi@tie", anim = "vomit_outside"}},
		}
	},

	{
		name  = 'greetings',
		label = 'Greetings',
		items = {
	    {label = "Greet", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_hello"}},
	    {label = "Shaking hands", type = "anim", data = {lib = "mp_common", anim = "givetake1_a"}},
	    {label = "Tchek", type = "anim", data = {lib = "mp_ped_interaction", anim = "handshake_guy_a"}},
	    {label = "Hi gangster", type = "anim", data = {lib = "mp_ped_interaction", anim = "hugs_guy_a"}},
	    {label = "Military salute", type = "anim", data = {lib = "mp_player_int_uppersalute", anim = "mp_player_int_salute"}},
		}
	},

	{
		name  = 'work',
		label = 'Work',
		items = {
	    {label = "Suspect: go to the police", type = "anim", data = {lib = "random@arrests@busted", anim = "idle_c"}},
	    {label = "Sinner", type = "scenario", data = {anim = "world_human_stand_fishing"}},
	    {label = "Police: investigate", type = "anim", data = {lib = "amb@code_human_police_investigate@idle_b", anim = "idle_f"}},
	    {label = "Police: talk on the radio", type = "anim", data = {lib = "random@arrests", anim = "generic_radio_chatter"}},
	    {label = "Police : Park Attendent", type = "scenario", data = {anim = "WORLD_HUMAN_CAR_PARK_ATTENDANT"}},
	    {label = "Police : binoculars", type = "scenario", data = {anim = "WORLD_HUMAN_BINOCULARS"}},
	    {label = "Police : Hands on belt", type = "animLoop", data = {lib = "amb@world_human_cop_idles@male@base", anim = "base"}},
	    {label = "Police : Hands on hips", type = "animLoop", data = {lib = "amb@world_human_cop_idles@male@idle_b", anim = "idle_e"}},
	    {label = "Agriculture : pick up", type = "scenario", data = {anim = "world_human_gardener_plant"}},
	    {label = "Mechanic : Repair Under Car", type = "scenario", data = {anim = "world_human_vehicle_mechanic"}},
	    {label = "Mechanic : Repair Engine", type = "anim", data = {lib = "mini@repair", anim = "fixing_a_ped"}},
	    {label = "Medic : Medik Kneel", type = "scenario", data = {anim = "CODE_HUMAN_MEDIC_KNEEL"}},
	    {label = "Taxi : Lean Over", type = "anim", data = {lib = "oddjobs@taxi@driver", anim = "leanover_idle"}},
	    {label = "Taxi : Give Bill", type = "anim", data = {lib = "oddjobs@taxi@cyi", anim = "std_hand_off_ps_passenger"}},
	    {label = "Grocer: give the bag", type = "anim", data = {lib = "mp_am_hold_up", anim = "purchase_beerbox_shopkeeper"}},
	    {label = "Barman: serve a shot", type = "anim", data = {lib = "mini@drinking", anim = "shots_barman_b"}},
	    {label = "Reporter: Take a picture", type = "scenario", data = {anim = "WORLD_HUMAN_PAPARAZZI"}},
	    {label = "All Trades: Take Notes", type = "scenario", data = {anim = "WORLD_HUMAN_CLIPBOARD"}},
	    {label = "All trades: Hammer blow", type = "scenario", data = {anim = "WORLD_HUMAN_HAMMERING"}},
	    {label = "Clochard : Doing Rounds", type = "scenario", data = {anim = "WORLD_HUMAN_BUM_FREEWAY"}},
	    {label = "Clochard : Make a statue", type = "scenario", data = {anim = "WORLD_HUMAN_HUMAN_STATUE"}},
		}
	},

	{
		name  = 'humors',
		label = 'Humeurs',
		items = {
	    {label = "Congratulate", type = "scenario", data = {anim = "WORLD_HUMAN_CHEERING"}},
	    {label = "Super", type = "anim", data = {lib = "mp_action", anim = "thanks_male_06"}},
	    {label = "You", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_point"}},
	    {label = "One", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_come_here_soft"}}, 
	    {label = "Keskya ?", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_bring_it_on"}},
	    {label = "To Me", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_me"}},
	    {label = "I knew it, fucking", type = "anim", data = {lib = "anim@am_hold_up@male", anim = "shoplift_high"}},
	    {label = "Exhausted", type = "scenario", data = {lib = "amb@world_human_jog_standing@male@idle_b", anim = "idle_d"}},
	    {label = "Im in shit", type = "scenario", data = {lib = "amb@world_human_bum_standing@depressed@idle_a", anim = "idle_a"}},
	    {label = "Facepalm", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@face_palm", anim = "face_palm"}},
	    {label = "Calm down ", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_easy_now"}},
	    {label = "What did I do ?", type = "anim", data = {lib = "oddjobs@assassinate@multi@", anim = "react_big_variations_a"}},
	    {label = "Scared shitless", type = "animLoop", data = {lib = "amb@code_human_cower@male@idle_a", anim = "idle_a"}},
	    {label = "be scared", type = "anim", data = {lib = "amb@code_human_cower_stand@male@react_cowering", anim = "base_right"}},
	    {label = "Fight ?", type = "anim", data = {lib = "anim@deathmatch_intros@unarmed", anim = "intro_male_unarmed_e"}},
	    {label = "It's not possible !", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_damn"}},
	    {label = "embrace", type = "anim", data = {lib = "mp_ped_interaction", anim = "kisses_guy_a"}},
	    {label = "Finger of honor", type = "anim", data = {lib = "mp_player_int_upperfinger", anim = "mp_player_int_finger_01_enter"}},
	    {label = "wanker", type = "anim", data = {lib = "mp_player_int_upperwank", anim = "mp_player_int_wank_01"}},
	    {label = "Bullet in the head", type = "anim", data = {lib = "mp_suicide", anim = "pistol"}},
		}
	},

	{
		name  = 'sports',
		label = 'Sports',
		items = {
	    {label = "Show your muscles", type = "anim", data = {lib = "amb@world_human_muscle_flex@arms_at_side@base", anim = "base"}},
	    {label = "Weight bar", type = "anim", data = {lib = "amb@world_human_muscle_free_weights@male@barbell@base", anim = "base"}},
	    {label = "Do push-ups", type = "anim", data = {lib = "amb@world_human_push_ups@male@base", anim = "base"}},
	    {label = "Do chin-ups", type = "anim", data = {lib = "amb@world_human_sit_ups@male@base", anim = "base"}},
	    {label = "Do yoga", type = "anim", data = {lib = "amb@world_human_yoga@male@base", anim = "base_a"}},
		}
	},
	{
        name  = 'dances',
        label = 'Dances',
        items = {
        {label = "Crazy Dance", type = "animLoop", data = {lib = "misschinese2_crystalmazemcs1_cs", anim = "dance_loop_tao"}},
        {label = "Gangster Dance", type = "animLoop", data = {lib = "missfbi3_sniping", anim = "dance_m_default"}},
        {label = "Clown Dance", type = "animLoop", data = {lib = "move_clown@p_m_two_idles@", anim = "fidget_short_dance"}},
        {label = "Cool Dance", type = "animLoop", data = {lib = "rcmnigel1bnmt_1b", anim = "dance_loop_tyler"}},
        {label = "Cool Dance Intro", type = "animLoop", data = {lib = "rcmnigel1bnmt_1b", anim = "dance_intro_tyler"}},
        {label = "Step Dance", type = "animLoop", data = {lib = "special_ped@mountain_dancer@monologue_3@monologue_3a", anim = "mnt_dnc_buttwag"}},
        }
    },
	{
		name  = 'attitudem',
		label = 'Attitudes',
		items = {
	    {label = "Normal M", type = "attitude", data = {lib = "move_m@confident", anim = "move_m@confident"}},
	    {label = "Normal F", type = "attitude", data = {lib = "move_f@heels@c", anim = "move_f@heels@c"}},
	    {label = "Depressif M", type = "attitude", data = {lib = "move_m@depressed@a", anim = "move_m@depressed@a"}},
	    {label = "Depressif F", type = "attitude", data = {lib = "move_f@depressed@a", anim = "move_f@depressed@a"}},
	    {label = "Business", type = "attitude", data = {lib = "move_m@business@a", anim = "move_m@business@a"}},
	    {label = "Determined", type = "attitude", data = {lib = "move_m@brave@a", anim = "move_m@brave@a"}},
	    {label = "Casual", type = "attitude", data = {lib = "move_m@casual@a", anim = "move_m@casual@a"}},
	    {label = "Ate too much", type = "attitude", data = {lib = "move_m@fat@a", anim = "move_m@fat@a"}},
	    {label = "Hipster", type = "attitude", data = {lib = "move_m@hipster@a", anim = "move_m@hipster@a"}},
	    {label = "Injured", type = "attitude", data = {lib = "move_m@injured", anim = "move_m@injured"}},
	    {label = "Intimidated", type = "attitude", data = {lib = "move_m@hurry@a", anim = "move_m@hurry@a"}},
	    {label = "Hobo", type = "attitude", data = {lib = "move_m@hobo@a", anim = "move_m@hobo@a"}},
	    {label = "Unfortunate", type = "attitude", data = {lib = "move_m@sad@a", anim = "move_m@sad@a"}},
	    {label = "Muscle", type = "attitude", data = {lib = "move_m@muscle@a", anim = "move_m@muscle@a"}},
	    {label = "Shock", type = "attitude", data = {lib = "move_m@shocked@a", anim = "move_m@shocked@a"}},
	    {label = "Dark", type = "attitude", data = {lib = "move_m@shadyped@a", anim = "move_m@shadyped@a"}},
	    {label = "Tired", type = "attitude", data = {lib = "move_m@buzzed", anim = "move_m@buzzed"}},
	    {label = "Hurry", type = "attitude", data = {lib = "move_m@hurry_butch@a", anim = "move_m@hurry_butch@a"}},
	    {label = "Proud", type = "attitude", data = {lib = "move_m@money", anim = "move_m@money"}},
	    {label = "Petite course", type = "attitude", data = {lib = "move_m@quick", anim = "move_m@quick"}},
	    {label = "Mangeuse d'homme", type = "attitude", data = {lib = "move_f@maneater", anim = "move_f@maneater"}},
	    {label = "Impertinent", type = "attitude", data = {lib = "move_f@sassy", anim = "move_f@sassy"}},	
	    {label = "Arrogant", type = "attitude", data = {lib = "move_f@arrogant@a", anim = "move_f@arrogant@a"}},
		}
	},
	{
		name  = 'arrest',
		label = 'Arrests',
		items = {
	    {label = "Kneel down hands up", type = "animLoop", data = {lib = "random@arrests", anim = "kneeling_arrest_idle"}},
	    {label = "Kneel down hands behind back", type = "animLoop", data = {lib = "random@arrests@busted", anim = "idle_a"}},
		}
	},
	{
		name  = 'misc',
		label = 'Miscellaneous',
		items = {
	    {label = "Drink a coffee", type = "anim", data = {lib = "amb@world_human_aa_coffee@idle_a", anim = "idle_a"}},
	    {label = "Conversing", type = "animLoop", data = {lib = "missheist_agency3aig_24", anim = "agent01_conversation"}},
	    {label = "Injured", type = "animLoopControl", data = {lib = "move_injured_generic", anim = "walk"}},
	    -- {label = "Sit", type = "animLoop", data = {lib = "random@mugging3", anim = "sit_base"}},
	    {label = "Sit twiddling", type = "animLoop", data = {lib = "anim@heists@prison_heistunfinished_biztarget_idle", anim = "target_idle"}},
	    {label = "Sit down (on the floor)", type = "scenario", data = {anim = "WORLD_HUMAN_PICNIC"}},
	    {label = "Wait against a wall", type = "scenario", data = {anim = "world_human_leaning"}},
	    {label = "Laying on the back", type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE_BACK"}},
	    {label = "Prone", type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE"}},
	    {label = "Clean something", type = "scenario", data = {anim = "world_human_maid_clean"}},
	    {label = "Prepare to eat", type = "scenario", data = {anim = "PROP_HUMAN_BBQ"}},
	    {label = "Search position", type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_bj_to_prop_female"}},
	    {label = "Take a selfie", type = "scenario", data = {anim = "world_human_tourist_mobile"}},
	    {label = "Listen to a door", type = "anim", data = {lib = "mini@safe_cracking", anim = "idle_base"}},
	    {label = "Take phone picture", type = "scenario", data = {anim = "WORLD_HUMAN_MOBILE_FILM_SHOCKING"}},
		}
	},
	{
		name  = 'porn',
		label = 'PEGI 21',
		items = {
	    {label = "1", type = "anim", data = {lib = "oddjobs@towing", anim = "m_blow_job_loop"}},
	    {label = "2", type = "anim", data = {lib = "oddjobs@towing", anim = "f_blow_job_loop"}},
	    {label = "3", type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_player"}},
	    {label = "4", type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_female"}},
	    {label = "5", type = "anim", data = {lib = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch"}},
	    {label = "6", type = "anim", data = {lib = "mini@strip_club@idles@stripper", anim = "stripper_idle_02"}},
	    {label = "7", type = "scenario", data = {anim = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS"}},
	    {label = "8", type = "anim", data = {lib = "mini@strip_club@backroom@", anim = "stripper_b_backroom_idle_b"}},
	    {label = "Strip Tease 1", type = "anim", data = {lib = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", anim = "ld_girl_a_song_a_p1_f"}},
	    {label = "Strip Tease 2", type = "anim", data = {lib = "mini@strip_club@private_dance@part2", anim = "priv_dance_p2"}},
	    {label = "Stip Tease au sol", type = "anim", data = {lib = "mini@strip_club@private_dance@part3", anim = "priv_dance_p3"}},
			}
	},

}