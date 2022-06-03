

readMissiles(ByRef d2rprocess, startingOffset) {
    ;global settings
    array := []
    , tableOffset := startingOffset + (3 * 1024)
    , baseAddress := d2rprocess.BaseAddress + tableOffset
    , d2rprocess.readRaw(baseAddress, unitTableBuffer, 128*8)
    Loop, 128
    {
        offset := (8 * (A_Index - 1))
        , arrayUnit := NumGet(&unitTableBuffer , offset, "Int64")
        while (arrayUnit > 0 ) { ; keep following the next pointer
            ; d2rprocess.readRaw(arrayUnit, arrayUnitBuffer, 144)
            ; ; SetFormat, Integer, Hex
            ; Loop, 144
            ; {
            ;     OutputDebug, % NumGet(&arrayUnitBuffer, A_Index-1, "UChar") " " 
            ; }
            ; OutputDebug, % "`n"
            txtFileNo := d2rprocess.read(arrayUnit + 0x04, "UInt")
            if (missleCategory := getMissileCategory(txtFileNo)) {
                pUnitData := d2rprocess.read(arrayUnit + 0x10, "Int64")
                , dwOwnerId := d2rprocess.read(pUnitData + 0x0C, "UInt")
                , skillLevel := d2rprocess.read(pUnitData + 0x5E, "UChar")
                ; d2rprocess.readRaw(pUnitDataPtr, pUnitDataBuf, 144)
                ; ; ; SetFormat, Integer, Hex
                ; OutputDebug, % "UD "
                ; Loop, 144
                ; {
                ;     OutputDebug, % NumGet(&pUnitDataBuf, A_Index-1, "UChar") " " 
                ; }
                
                pPath := d2rprocess.read(arrayUnit + 0x38, "Int64")
                , mode := d2rprocess.read(arrayUnit + 0x0c, "UInt")
                , unitx := d2rprocess.read(pPath + 0x02, "UShort")
                , unity := d2rprocess.read(pPath + 0x06, "UShort")
                , xPosOffset := d2rprocess.read(pPath + 0x00, "UShort") 
                , yPosOffset := d2rprocess.read(pPath + 0x04, "UShort")
                , xPosOffset := xPosOffset / 65536   ; get percentage
                , yPosOffset := yPosOffset / 65536   ; get percentage
                , unitx := unitx + xPosOffset
                , unity := unity + yPosOffset
                , unit := { "txtFileNo": txtFileNo, "x": unitx, "y": unity, "mode": mode, "UnitType": missleCategory}
                ; OutputDebug, % txtFileNo " " skillLevel " " dwOwnerId " " unitx " " unity "`n"
                , array.push(unit)
           }   
           arrayUnit := d2rprocess.read(arrayUnit + 0x150, "Int64")  ; get next unit
        }
    } 
    return array
}

getMissileCategory(txtFileNo) {
    switch (txtFileNo) {
        case 0: return "PhysicalMajor" ;arrow
        case 31: return "PhysicalMajor" ;bolt
        case 115: return "PhysicalMajor" ;corpseexplosion
        case 135: return "PhysicalMajor" ;raven1
        case 136: return "PhysicalMajor" ;raven2
        case 426: return "PhysicalMajor" ;suicidecorpseexplode
        case 525: return "PhysicalMajor" ;ancient_throwing_axe
        case 2: return "PhysicalMinor" ;bighead1
        case 3: return "PhysicalMinor" ;bighead2
        case 4: return "PhysicalMinor" ;bighead3
        case 5: return "PhysicalMinor" ;bighead4
        case 6: return "PhysicalMinor" ;bighead5
        case 7: return "PhysicalMinor" ;spike1
        case 8: return "PhysicalMinor" ;spike2
        case 9: return "PhysicalMinor" ;spike3
        case 10: return "PhysicalMinor" ;spike4
        case 11: return "PhysicalMinor" ;spike5
        case 35: return "PhysicalMinor" ;throwaxe
        case 36: return "PhysicalMinor" ;throwknife
        case 37: return "PhysicalMinor" ;glaive
        case 120: return "PhysicalMinor" ;rogue1
        case 121: return "PhysicalMinor" ;rogue2
        case 122: return "PhysicalMinor" ;rogue3
        case 213: return "PhysicalMinor" ;multipleshotarrow
        case 214: return "PhysicalMinor" ;multipleshotbolt
        case 241: return "PhysicalMinor" ;trap_spike_right
        case 242: return "PhysicalMinor" ;trap_spike_left
        case 243: return "PhysicalMinor" ;trap_cursed_skull_right
        case 244: return "PhysicalMinor" ;trap_cursed_skull_left
        case 266: return "PhysicalMinor" ;blowgun
        case 410: return "PhysicalMinor" ;catapult_spike_ball_on
        case 411: return "PhysicalMinor" ;catapult_spike_ball
        case 412: return "PhysicalMinor" ;catapult_spike_in_air
        case 413: return "PhysicalMinor" ;catapult_spike_on_ground
        case 414: return "PhysicalMinor" ;catapult_spike_explosion
        case 502: return "PhysicalMinor" ;death_mauler
        case 503: return "PhysicalMinor" ;death_mauler_trail
        case 504: return "PhysicalMinor" ;death_mauler_trail_fade
        case 22: return "FireMajor" ;shafire1
        case 23: return "FireMajor" ;shafire2
        case 24: return "FireMajor" ;shafire3
        case 25: return "FireMajor" ;shafire4
        case 26: return "FireMajor" ;shafire5
        case 29: return "FireMajor" ;fireexplode
        case 60: return "FireMajor" ;infernoflame1
        case 61: return "FireMajor" ;infernoflame2
        case 62: return "FireMajor" ;fireball
        case 68: return "FireMajor" ;firewallmaker
        case 69: return "FireMajor" ;firewall
        case 82: return "FireMajor" ;fireexplosion
        case 100: return "FireMajor" ;meteor
        case 101: return "FireMajor" ;meteorcenter
        case 103: return "FireMajor" ;meteorexplode
        case 129: return "FireMajor" ;vampirefireball
        case 130: return "FireMajor" ;vampirefirewallmaker
        case 131: return "FireMajor" ;vampirefirewall
        case 132: return "FireMajor" ;vampiremeteor
        case 133: return "FireMajor" ;vampiremeteorcenter
        case 134: return "FireMajor" ;vampiremeteorexp
        case 265: return "FireMajor" ;fireexplosion2
        case 247: return "FireMajor" ;hydra
        case 404: return "FireMajor" ;impfireball
        case 405: return "FireMajor" ;impfireballexplode
        case 554: return "FireMajor" ;baal_inferno
        case 12: return "FireMinor" ;firearrow
        case 41: return "FireMinor" ;explodingarrow
        case 42: return "FireMinor" ;explodingarrowexp
        case 51: return "FireMinor" ;explosivepotionexp
        case 52: return "FireMinor" ;explosivepotiondebris1
        case 53: return "FireMinor" ;explosivepotiondebris2
        case 54: return "FireMinor" ;explosivepotiondebris3
        case 58: return "FireMinor" ;firebolt
        case 67: return "FireMinor" ;blaze
        case 85: return "FireMinor" ;immolationarrow
        case 102: return "FireMinor" ;meteortail
        case 104: return "FireMinor" ;firesmall
        case 105: return "FireMinor" ;firemedium
        case 127: return "FireMinor" ;skmage3
        case 144: return "FireMinor" ;fetishinferno1
        case 145: return "FireMinor" ;fetishinferno2
        case 172: return "FireMinor" ;diablight
        case 176: return "FireMinor" ;diabfire
        case 179: return "FireMinor" ;diabwallmaker
        case 180: return "FireMinor" ;diabwall
        case 230: return "FireMinor" ;immolationfire
        case 240: return "FireMinor" ;meteorfire
        case 277: return "FireMinor" ;firehead
        case 280: return "FireMinor" ;frogfire
        case 283: return "FireMinor" ;desertfireball
        case 324: return "FireMinor" ;undeadmissile2
        case 300: return "FireMinor" ;mephistofirewallmaker
        case 301: return "FireMinor" ;mephistofirewall

        case 398: return "FireMinor" ;impinfernoflame1
        case 399: return "FireMinor" ;impinfernoflame2
        case 427: return "FireMinor" ;suicidefireexplode
        case 441: return "FireMinor" ;sucfireball
        case 442: return "FireMinor" ;sucfireballexplode
        case 443: return "FireMinor" ;sucfireballtrail
        case 447: return "FireMinor" ;hellfiremissile
        case 448: return "FireMinor" ;hellfireexa
        case 449: return "FireMinor" ;hellfireexb
        case 452: return "FireMinor" ;moltenboulder
        case 453: return "FireMinor" ;moltenboulderemerge
        case 454: return "FireMinor" ;moltenboulderexplode
        case 455: return "FireMinor" ;moltenboulderfirepath
        case 456: return "FireMinor" ;moltenboulder-flyingrocks
        case 457: return "FireMinor" ;firestorm
        case 458: return "FireMinor" ;firestormmaker
        case 480: return "FireMinor" ;volcano_overlay_fire
        case 483: return "FireMinor" ;volcano_small_fire
        case 556: return "FireMinor" ;fistsoffireexplode
        case 557: return "FireMinor" ;fistsoffirefirewall
        case 563: return "FireMinor" ;royalstrikemeteor
        case 564: return "FireMinor" ;royalstrikemeteorcenter
        case 565: return "FireMinor" ;royalstrikemeteortail
        case 566: return "FireMinor" ;royalstrikemeteorexplode
        case 567: return "FireMinor" ;royalstrikemeteorfire
        case 592: return "FireMinor" ;impmiss21
        case 619: return "FireMinor" ;volcanofiretrail
        case 623: return "FireMinor" ;armageddonfire
        case 650: return "FireMinor" ;viper_fire
        case 651: return "FireMinor" ;viper_firecloud
        case 653: return "FireMinor" ;countessfirewallmaker
        case 663: return "FireMinor" ;skmagefire
        case 674: return "FireMinor" ;diablogeddonfire
        case 676: return "FireMinor" ;trapfirebolt
        case 681: return "FireMinor" ;vampiremeteorfire
        case 87: return "IceMajor" ;freezingarrow
        case 88: return "IceMajor" ;freezingarrowexp1
        case 89: return "IceMajor" ;freezingarrowexp2
        case 91: return "IceMajor" ;iceblast
        case 96: return "IceMajor" ;glacialspike
        case 106: return "IceMajor" ;monblizcenter
        case 119: return "IceMajor" ;frostnova
        case 158: return "IceMajor" ;blizzardcenter
        case 260: return "IceMajor" ;frozenorb
        case 262: return "IceMajor" ;frozenorbnova
        case 263: return "IceMajor" ;frozenorbexplode
        case 271: return "IceMajor" ;monglacialspike
        case 679: return "IceMajor" ;mephfrostnova
        case 28: return "IceMinor" ;icearrow
        case 40: return "IceMinor" ;coldarrow
        case 59: return "IceMinor" ;icebolt
        case 107: return "IceMinor" ;monbliz1
        case 108: return "IceMinor" ;monbliz2
        case 109: return "IceMinor" ;monbliz3
        case 110: return "IceMinor" ;monbliz4
        case 111: return "IceMinor" ;monblizexplode1
        case 112: return "IceMinor" ;monblizexplode2
        case 113: return "IceMinor" ;monblizexplode3
        case 126: return "IceMinor" ;skmage2
        case 156: return "IceMinor" ;chillbloodcloud
        case 157: return "IceMinor" ;chillbloodpuff
        case 159: return "IceMinor" ;blizzard1
        case 160: return "IceMinor" ;blizzard2
        case 161: return "IceMinor" ;blizzard3
        case 162: return "IceMinor" ;blizzard4
        case 163: return "IceMinor" ;blizzardexplode1
        case 164: return "IceMinor" ;blizzardexplode2
        case 165: return "IceMinor" ;blizzardexplode3
        case 194: return "IceMinor" ;coldunique
        case 212: return "IceMinor" ;sparkle
        case 261: return "IceMinor" ;frozenorbbolt
        case 264: return "IceMinor" ;chillingarmorbolt
        case 281: return "IceMinor" ;frogcold
        case 415: return "IceMinor" ;catapult_cold_ball_on
        case 416: return "IceMinor" ;catapult_cold_ball
        case 417: return "IceMinor" ;catapult_cold_explosion
        case 493: return "IceMinor" ;frozenhorror_arcticblast1
        case 494: return "IceMinor" ;frozenhorror_arcticblast2
        case 662: return "IceMinor" ;skmagecold

        case 93: return "LightMajor" ;chainlightning
        case 98: return "LightMajor" ;lightningbolt
        case 97: return "LightMajor" ;teleport
        case 99: return "LightMajor" ;lightninghit
        case 166: return "LightMajor" ;thunderstorm1
        case 167: return "LightMajor" ;thunderstorm2
        case 168: return "LightMajor" ;thunderstorm3
        case 169: return "LightMajor" ;thunderstorm4
        case 215: return "LightMajor" ;chargedstrikebolt
        case 225: return "LightMajor" ;buglightning
        case 267: return "LightMajor" ;chainlightning2
        case 276: return "LightMajor" ;mephisto
        case 279: return "LightMajor" ;arcanelightningbolt
        case 558: return "LightMajor" ;clawsofthunderbolt
        case 559: return "LightMajor" ;clawsofthundernova
        case 568: return "LightMajor" ;royalstrikechainlightning
        case 574: return "LightMajor" ;highpriestlightning2
        case 55: return "LightMinor" ;holybolt
        case 56: return "LightMinor" ;chargedbolt
        case 57: return "LightMinor" ;sanctuarybolt
        case 77: return "LightMinor" ;unholybolt1
        case 78: return "LightMinor" ;unholybolt2
        case 79: return "LightMinor" ;unholybolt3
        case 80: return "LightMinor" ;unholybolt4
        case 90: return "LightMinor" ;nova
        case 123: return "LightMinor" ;bat_lightning_bolt
        case 124: return "LightMinor" ;bat_lightning_trail
        case 128: return "LightMinor" ;skmage4
        case 170: return "LightMinor" ;monsterlight
        case 195: return "LightMinor" ;lightunique
        case 201: return "LightMinor" ;nova1
        case 202: return "LightMinor" ;nova2
        case 205: return "LightMinor" ;lightningjavelin
        case 206: return "LightMinor" ;lightningfury
        case 231: return "LightMinor" ;furylightning
        case 232: return "LightMinor" ;lightningstrike
        case 233: return "LightMinor" ;fistoftheheavensdelay
        case 234: return "LightMinor" ;fistoftheheavensbolt
        case 320: return "LightMinor" ;willowisplightningbolt
        case 326: return "LightMinor" ;undeadmissile4
        case 339: return "LightMinor" ;horadriclightning
        case 340: return "LightMinor" ;horadriclight
        case 343: return "LightMinor" ;highpriestlightning
        case 382: return "LightMinor" ;izual_lightning
        case 383: return "LightMinor" ;izual_lightning_trail
        case 384: return "LightMinor" ;cairn_stones_bolt
        case 400: return "LightMinor" ;baallightningbolt
        case 401: return "LightMinor" ;baallightningtrail
        case 402: return "LightMinor" ;baallightningbolt2
        case 403: return "LightMinor" ;baallightningtrail2
        case 406: return "LightMinor" ;catapultchargedball_on
        case 407: return "LightMinor" ;catapultchargedball
        case 408: return "LightMinor" ;catapultchargedballbolt
        case 431: return "LightMinor" ;lightingtrailingjavalin
        case 432: return "LightMinor" ;lightjavalintrail
        case 433: return "LightMinor" ;lightjavalinexplosion
        case 438: return "LightMinor" ;advlighttrailingjav
        case 439: return "LightMinor" ;advlighttrailingjav2
        case 440: return "LightMinor" ;advlightjavexplode
        case 512: return "LightMinor" ;lightningtalons
        case 513: return "LightMinor" ;lightningtalonstrail
        case 526: return "LightMinor" ;sentrylightningbolt
        case 527: return "LightMinor" ;sentrylightninghit
        case 534: return "LightMinor" ;dragonflight
        case 535: return "LightMinor" ;dragonflightmaker
        case 543: return "LightMinor" ;lightning_charge_up_nova
        case 544: return "LightMinor" ;chainlightningcharge_up
        case 547: return "LightMinor" ;baal_taunt_lightning
        case 548: return "LightMinor" ;baal_taunt_lightning_trail
        case 641: return "LightMinor" ;sentrylightningbolt2
        case 642: return "LightMinor" ;sentrylightninghit2
        case 643: return "LightMinor" ;lightningtowernova
        case 654: return "LightMinor" ;baal_taunt_lightning_control
        case 666: return "LightMinor" ;willowisplightningbolt2
        case 678: return "LightMinor" ;trapnova
        case 680: return "LightMinor" ;mephlight
        case 664: return "LightMinor" ;skmageltng

        case 32: return "PoisonMajor" ;andarielspray
        case 116: return "PoisonMajor" ;poisoncorpseexplosion
        case 118: return "PoisonMajor" ;poisonnova
        case 549: return "PoisonMajor" ;baal_taunt_poison

        case 38: return "PoisonMinor" ;poisonjav
        case 39: return "PoisonMinor" ;poisonjavcloud
        case 43: return "PoisonMinor" ;plaguejavelin
        case 45: return "PoisonMinor" ;explosivepotion
        case 46: return "PoisonMinor" ;fulminatingpotion
        case 47: return "PoisonMinor" ;rancidgasepotion
        case 48: return "PoisonMinor" ;chokinggaspoition
        case 49: return "PoisonMinor" ;stranglinggaspotion
        case 63: return "PoisonMinor" ;mummy1
        case 64: return "PoisonMinor" ;mummy2
        case 65: return "PoisonMinor" ;mummy3
        case 66: return "PoisonMinor" ;mummy4
        case 70: return "PoisonMinor" ;goospit1
        case 71: return "PoisonMinor" ;goospit2
        case 72: return "PoisonMinor" ;goospit3
        case 73: return "PoisonMinor" ;goospit4
        case 74: return "PoisonMinor" ;goospit5
        case 75: return "PoisonMinor" ;goosplat
        case 125: return "PoisonMinor" ;skmage1
        case 137: return "PoisonMinor" ;amphibiangoo1
        case 138: return "PoisonMinor" ;amphibiangoo2
        case 139: return "PoisonMinor" ;tentaclegoo
        case 140: return "PoisonMinor" ;amphibianexplode
        case 141: return "PoisonMinor" ;poisonpuff
        case 143: return "PoisonMinor" ;spidergoolay
        case 146: return "PoisonMinor" ;spidergoo
        case 155: return "PoisonMinor" ;corpsepoisoncloud
        case 171: return "PoisonMinor" ;poisonball
        case 203: return "PoisonMinor" ;andypoisonbolt
        case 217: return "PoisonMinor" ;poisonexplosioncloud
        case 220: return "PoisonMinor" ;primepoisoncloud
        case 221: return "PoisonMinor" ;plaguejavcloud
        case 222: return "PoisonMinor" ;rancidgascloud
        case 223: return "PoisonMinor" ;chokinggascloud
        case 224: return "PoisonMinor" ;stranglinggascloud
        case 245: return "PoisonMinor" ;trap_poison_ball_right
        case 246: return "PoisonMinor" ;trap_poison_ball_left
        case 282: return "PoisonMinor" ;frogpois
        case 323: return "PoisonMinor" ;undeadmissile1
        case 418: return "PoisonMinor" ;catapult_plague_ball_on
        case 419: return "PoisonMinor" ;catapult_plague_ball
        case 420: return "PoisonMinor" ;catapult_plague_cloud
        case 648: return "PoisonMinor" ;viper_poisjav
        case 649: return "PoisonMinor" ;viper_poisjavcloud
        case 661: return "PoisonMinor" ;skmagepois

        case 148: return "MagicMajor" ;howl
        case 149: return "MagicMajor" ;shout
        case 92: return "MagicMajor" ;blessedhammer
        case 142: return "MagicMajor" ;curseeffectred
        case 192: return "MagicMajor" ;bonespear
        case 193: return "MagicMajor" ;bonespirit
        case 204: return "MagicMajor" ;teethexplode
        case 235: return "MagicMajor" ;warcry
        case 236: return "MagicMajor" ;battlecommand
        case 237: return "MagicMajor" ;battleorders
        case 287: return "MagicMajor" ;denofevillight
        case 555: return "MagicMajor" ;baal_nova
        case 546: return "MagicMajor" ;baal_taunt_control
        case 550: return "MagicMajor" ;baal_spawn_monsters
        case 587: return "MagicMajor" ;baalcorpseexplodedelay
        case 588: return "MagicMajor" ;baalcorpseexplodeexpl
        case 589: return "MagicMajor" ;baal_cold_maker
        case 590: return "MagicMajor" ;baal_cold_trail
        case 591: return "MagicMajor" ;baal_spawn_monsters_exp
        case 665: return "MagicMajor" ;succubusmiss

        case 27: return "MagicMinor" ;magicarrow
        case 83: return "MagicMinor" ;stuckarrow
        case 84: return "MagicMinor" ;footprint
        case 81: return "MagicMinor" ;sanctuarycenter
        case 86: return "MagicMinor" ;guidedarrow
        case 114: return "MagicMinor" ;teeth
        case 147: return "MagicMinor" ;cursecast
        case 173: return "MagicMinor" ;redemption
        case 174: return "MagicMinor" ;redemptionfail
        case 177: return "MagicMinor" ;fingermagespider
        case 181: return "MagicMinor" ;curseamplifydamage
        case 182: return "MagicMinor" ;cursedimvision
        case 183: return "MagicMinor" ;curseweaken
        case 184: return "MagicMinor" ;curseironmaiden
        case 185: return "MagicMinor" ;curseterror
        case 186: return "MagicMinor" ;curseattract
        case 187: return "MagicMinor" ;cursereversevampire
        case 188: return "MagicMinor" ;curseconfuse
        case 189: return "MagicMinor" ;cursedecrepify
        case 190: return "MagicMinor" ;curselowerresist
        case 191: return "MagicMinor" ;cursecenter
        case 216: return "MagicMinor" ;bonespearexplode
        case 218: return "MagicMinor" ;bonecast
        case 219: return "MagicMinor" ;battlecry
        case 248: return "MagicMinor" ;bonespeartrail
        case 268: return "MagicMinor" ;revivesmall
        case 269: return "MagicMinor" ;revivemedium
        case 270: return "MagicMinor" ;revivelarge
        case 278: return "MagicMinor" ;whilrwind
        case 325: return "MagicMinor" ;undeadmissile3
        case 327: return "MagicMinor" ;bonespiritexplode
        case 328: return "MagicMinor" ;dopplezonexplode
        case 329: return "MagicMinor" ;monbonespirit
        case 451: return "MagicMinor" ;imp_teleport
        case 425: return "MagicMinor" ;healing_vortex
        case 541: return "MagicMinor" ;ancient_death_center
        case 542: return "MagicMinor" ;ancient_death_cloud
        case 640: return "MagicMinor" ;blessedhammerex
        case 652: return "MagicMinor" ;viper_bonespear

        case 13: return "Other" ;cr_arrow1
        case 14: return "Other" ;cr_arrow2
        case 15: return "Other" ;cr_arrow3
        case 16: return "Other" ;cr_arrow4
        case 17: return "Other" ;cr_arrow5
        case 44: return "Other" ;oilpotion
        case 50: return "Other" ;notused50
        case 76: return "Other" ;sand_pile
        case 94: return "Other" ;fistofares
        case 95: return "Other" ;chillblood
        case 150: return "Other" ;dust
        case 151: return "Other" ;redlightmissile
        case 152: return "Other" ;greenlightmissile
        case 153: return "Other" ;bluelightmissile
        case 154: return "Other" ;whitelightmissile
        case 175: return "Other" ;handofgod
        case 178: return "Other" ;electric_throwaxe
        case 196: return "Other" ;skbowarrow1
        case 197: return "Other" ;skbowarrow2
        case 198: return "Other" ;skbowarrow3
        case 199: return "Other" ;skbowarrow4
        case 200: return "Other" ;skbowarrow5
        case 207: return "Other" ;bonewallmaker
        case 208: return "Other" ;necromage1
        case 209: return "Other" ;necromage2
        case 210: return "Other" ;necromage3
        case 211: return "Other" ;necromage4
        case 226: return "Other" ;pantherjav1
        case 227: return "Other" ;pantherjav2
        case 228: return "Other" ;pantherjav3
        case 229: return "Other" ;pantherjav4
        case 238: return "Other" ;pantherpotorange
        case 239: return "Other" ;pantherpotgreen
        case 249: return "Other" ;grimwardsmallstart
        case 250: return "Other" ;grimwardsmall
        case 251: return "Other" ;grimwardsmallstop
        case 252: return "Other" ;grimwardmediumstart
        case 253: return "Other" ;grimwardmedium
        case 254: return "Other" ;grimwardmediumstop
        case 255: return "Other" ;grimwardlargestart
        case 256: return "Other" ;grimwardlarge
        case 257: return "Other" ;grimwardlargestop
        case 258: return "Other" ;zakarumlight
        case 259: return "Other" ;grimwardscare
        case 288: return "Other" ;cairnstones
        case 289: return "Other" ;cairnstonessky
        case 290: return "Other" ;cairnstonesground
        case 291: return "Other" ;towermist
        case 292: return "Other" ;towermisttrail
        case 293: return "Other" ;brdeathsmokes1
        case 294: return "Other" ;brdeathsmokenu
        case 295: return "Other" ;brdeathsmokedt
        case 296: return "Other" ;brdeathspirits1
        case 297: return "Other" ;brdeathspiritnu
        case 298: return "Other" ;brdeathspiritdt
        case 321: return "Other" ;queenpoisoncloud
        case 322: return "Other" ;dirt_pile
        case 330: return "Other" ;towermistfade
        case 332: return "Other" ;towerchestspawner
        case 338: return "Other" ;horadricstaff
        case 341: return "Other" ;regurgitatorcorpse
        case 342: return "Other" ;regurgitatorcorpseexpl
        case 346: return "Other" ;leapknockback
        case 357: return "Other" ;healingbolt
        case 385: return "Other" ;bomb_in_air
        case 386: return "Other" ;bomb_on_ground
        case 387: return "Other" ;bomb_explosion
        case 388: return "Other" ;shock_field_in_air
        case 389: return "Other" ;shock_field_on_ground
        case 390: return "Other" ;throwingstar
        case 391: return "Other" ;acidspray
        case 392: return "Other" ;blade_creeper
        case 393: return "Other" ;distraction
        case 394: return "Other" ;distraction_fog
        case 395: return "Other" ;distraction_puff
        case 396: return "Other" ;distraction_start
        case 397: return "Other" ;distraction_end
        case 409: return "Other" ;imp_spawn_monsters
        case 428: return "Other" ;suicideiceexplode
        case 429: return "Other" ;explodingjavalin
        case 430: return "Other" ;explodingjavalinexp
        case 434: return "Other" ;icejavalin
        case 435: return "Other" ;icejavalinexplode
        case 436: return "Other" ;plaguejavelin2
        case 437: return "Other" ;plaguejavlinexplode
        case 444: return "Other" ;sucshockfieldmissile
        case 445: return "Other" ;sucshockfieldmissileexp
        case 446: return "Other" ;sucshockfield
        case 450: return "Other" ;imp_charged_bolt
        case 459: return "Other" ;arcticblast1
        case 460: return "Other" ;arcticblast2
        case 461: return "Other" ;erruption_center
        case 462: return "Other" ;erruption_crack_1
        case 463: return "Other" ;erruption_crack_2
        case 464: return "Other" ;erruption_smoke_1
        case 465: return "Other" ;erruption_smoke_2
        case 466: return "Other" ;vine_beast_walk_1
        case 467: return "Other" ;vine_beast_walk_2
        case 468: return "Other" ;vine_beast_neutral
        case 469: return "Other" ;vine_beast_attack
        case 470: return "Other" ;vine_beast_death
        case 471: return "Other" ;vines
        case 472: return "Other" ;vines_trail
        case 473: return "Other" ;vines_wither
        case 474: return "Other" ;plague_vines
        case 475: return "Other" ;plague_vines_trail
        case 476: return "Other" ;plague_vines_wither
        case 477: return "Other" ;twister
        case 478: return "Other" ;tornado
        case 479: return "Other" ;volcano
        case 481: return "Other" ;volcano_debris_2
        case 482: return "Other" ;volcano_explosion
        case 484: return "Other" ;dragonbreath_missile
        case 485: return "Other" ;lureprojectile
        case 486: return "Other" ;lurecenter
        case 487: return "Other" ;lurecloud
        case 488: return "Other" ;impmiss1
        case 489: return "Other" ;impmiss2
        case 490: return "Other" ;impmiss3
        case 491: return "Other" ;impmiss4
        case 492: return "Other" ;impmiss5
        case 495: return "Other" ;sentrychargedbolt
        case 496: return "Other" ;sentryspikeinair
        case 497: return "Other" ;sentryspikeonground
        case 498: return "Other" ;recycler_delay
        case 499: return "Other" ;recycler_vine
        case 500: return "Other" ;recycler_fade
        case 501: return "Other" ;recycler_explosion
        case 505: return "Other" ;bladefury1
        case 506: return "Other" ;bladefragment1
        case 507: return "Other" ;bladefury2
        case 508: return "Other" ;bladefragment2
        case 509: return "Other" ;bladefury3
        case 510: return "Other" ;bladefragment3
        case 511: return "Other" ;shockwave
        case 514: return "Other" ;phoenixtrail
        case 515: return "Other" ;rabiesplague
        case 516: return "Other" ;rabiescontagion
        case 517: return "Other" ;wake_of_destruction_maker
        case 518: return "Other" ;wake_of_destruction
        case 519: return "Other" ;deathsentryexplode
        case 520: return "Other" ;tigerfury
        case 521: return "Other" ;tigerfurytrail
        case 522: return "Other" ;tigerfurytrail2
        case 523: return "Other" ;inferno_sentry_1
        case 524: return "Other" ;inferno_sentry_2
        case 536: return "Other" ;progressive_radius_damage
        case 528: return "Other" ;anya_center
        case 529: return "Other" ;anya_icicle
        case 530: return "Other" ;anya_iceimpact
        case 531: return "Other" ;anya_icesteam
        case 532: return "Other" ;anya_icemagic
        case 533: return "Other" ;dragontail_missile
        case 537: return "Other" ;vine_beast_walk_1_fade
        case 538: return "Other" ;vine_beast_walk_2_fade
        case 539: return "Other" ;vine_beast_neutral_fade
        case 540: return "Other" ;vine_recycler_delay
        case 551: return "Other" ;mindblast_hit
        case 552: return "Other" ;blade_shield_missile
        case 553: return "Other" ;blade_shield_attachment
        case 560: return "Other" ;bladesoficeexplode
        case 561: return "Other" ;bladesoficecubes
        case 562: return "Other" ;bladesoficecubesmelt
        case 569: return "Other" ;royalstrikechaosice
        case 575: return "Other" ;infernoflame3
        case 576: return "Other" ;mindblast_center
        case 577: return "Other" ;armageddoncontrol
        case 578: return "Other" ;armageddonrock
        case 579: return "Other" ;armageddontail
        case 580: return "Other" ;armageddonexplosion
        case 581: return "Other" ;hurricaneswoosh
        case 582: return "Other" ;hurricanecart
        case 583: return "Other" ;hurricanerock
        case 584: return "Other" ;hurricanesack
        case 585: return "Other" ;hurricanetree
        case 586: return "Other" ;hurricanevase
        case 593: return "Other" ;impmiss22
        case 594: return "Other" ;impmiss23
        case 595: return "Other" ;impmiss24
        case 596: return "Other" ;impmiss25
        case 644: return "Other" ;skbowarrow6
        case 645: return "Other" ;skbowarrow7
        case 646: return "Other" ;skbowarrow8
        case 647: return "Other" ;bighead6
        case 655: return "Other" ;baal_taunt_poison_control
        case 656: return "Other" ;explodingarrowexp2
        case 657: return "Other" ;freezingarrowexp3
        case 658: return "Other" ;pantherjav5
        case 659: return "Other" ;spike6
        case 660: return "Other" ;cr_arrow6
        case 667: return "Other" ;mummyex
        case 668: return "Other" ;goospitex
        case 669: return "Other" ;impmissex
        case 670: return "Other" ;diablogeddoncontrol
        case 671: return "Other" ;diablogeddonrock
        case 672: return "Other" ;diablogeddontail
        case 673: return "Other" ;diablogeddonexplosion
        case 675: return "Other" ;megademoninferno
        case 677: return "Other" ;trappoisonjavcloud
        case 682: return "Other" ;strafearrow
        case 683: return "Other" ;strafebolt
        case 684: return "Other" ;recklessattacksmissile
    }
    return 0
}
