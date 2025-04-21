
IWB_SPELL_REF  = {
	["Attack"] = {["handler"] = IWBAttack, ["auto_target"] = true},
	
	-- Warrior
	
	["Heroic Strike"] = {["handler"] = IWBRageNextMelee, ["no_rank"] = true, ["auto_target"] = true},
	["Battle Shout"] = {["handler"] = IWBBuff, ["no_rank"] = true},
	["Cleave"] = {["handler"] = IWBRageNextMelee, ["no_rank"] = true, ["auto_target"] = true},
	["Rend"] = {["handler"] = IWBDebuff, ["no_rank"] = true, ["auto_target"] = true},
	["Sunder Armor"] = {["handler"] = IWBDebuffStack, ["no_rank"] = true, ["auto_target"] = true},
	["Battle Stance"] = {["handler"] = IWBStance},
	["Defensive Stance"] = {["handler"] = IWBStance},
	["Berseker Stance"] = {["handler"] = IWBStance},
	["Charge"] = {["handler"] = IWBSpellBase, ["no_rank"] = true},
	["Hamstring"] = {["handler"] = IWBSpellBase, ["no_rank"] = true, ["auto_target"] = true},
	["Mocking Blow"] = {["handler"] = IWBSpellBase, ["no_rank"] = true, ["auto_target"] = true},
	["Overpower"] = {["handler"] = IWBSpellBase, ["no_rank"] = true},
	["Thunder Clap"] = {["handler"] = IWBDebuffOrNot, ["no_rank"] = true},
	["Demoralizing Shout"] = {["handler"] = IWBDebuff, ["no_rank"] = true},
	["Execute"] = {["handler"] = IWBRage, ["no_rank"] = true, ["auto_target"] = true},
	["Intercept"] = {["handler"] = IWBSpellBase, ["no_rank"] = true},
	["Intervene"] = {["handler"] = IWBSpellBase, ["no_rank"] = true},
	["Revenge"] = {["handler"] = IWBSpellBase, ["no_rank"] = true, ["auto_target"] = true},
	["Shield Bash"] = {["handler"] = IWBSpellBase, ["no_rank"] = true, ["auto_target"] = true},
	["Shield Block"] = {["handler"] = IWBBuff, ["no_rank"] = true},
	["Mortal Strike"] = {["handler"] = IWBRage, ["no_rank"] = true, ["auto_target"] = true},
	["Bloodthirst"] = {["handler"] = IWBRage, ["no_rank"] = true, ["auto_target"] = true},
	["Shield Slam"] = {["handler"] = IWBSpellBase, ["no_rank"] = true, ["auto_target"] = true},
	["Concussion Blow"] = {["handler"] = IWBSpellBase, ["no_rank"] = true, ["auto_target"] = true},
	["Slam"] = {["handler"] = IWBSpellBase, ["no_rank"] = true, ["auto_target"] = true},
	["Counterattack"] = {["handler"] = IWBSpellBase, ["no_rank"] = true},
	["Whirlwind"] = {["handler"] = IWBRage},
	["Pummel"] = {["handler"] = IWBSpellBase, ["auto_target"] = true},
	["Disarm"] = {["handler"] = IWBSpellBase, ["auto_target"] = true},
	
	-- Rogue
	
	["Ambush"] = {["handler"] = IWBSpellBase, ["no_rank"] = true, ["auto_target"] = true},
	["Cheap Shot"] = {["handler"] = IWBSpellBase, ["auto_target"] = true},
	["Envenom"] = {["handler"] = IWBCombopointAndBuff, ["no_rank"] = true},
	["Eviscerate"] = {["handler"] = IWBCombopoint, ["no_rank"] = true, ["auto_target"] = true},
	["Sinister Strike"] = {["handler"] = IWBSpellBase, ["no_rank"] = true, ["auto_target"] = true},
	["Slice and Dice"] = {["handler"] = IWBCombopointAndBuff, ["no_rank"] = true},
	["Expose Armor"] = {["handler"] = IWBCombopointAndDebuff, ["no_rank"] = true, ["auto_target"] = true},
	["Garrote"] = {["handler"] = IWBSpellBase, ["no_rank"] = true, ["auto_target"] = true},
	["Kidney Shot"] = {["handler"] = IWBCombopoint, ["no_rank"] = true, ["auto_target"] = true},
	["Rupture"] = {["handler"] = IWBCombopointAndDebuff, ["no_rank"] = true, ["auto_target"] = true},
	["Backstab"] = {["handler"] = IWBSpellBase, ["no_rank"] = true, ["auto_target"] = true},
	["Feint"] = {["handler"] = IWBSpellBase, ["no_rank"] = true},
	["Flourish"] = {["handler"] = IWBCombopoint, ["no_rank"] = true, ["auto_target"] = true},
	["Gouge"] = {["handler"] = IWBSpellBase, ["no_rank"] = true},
	["Kick"] = {["handler"] = IWBSpellBase, ["no_rank"] = true, ["auto_target"] = true},
	["Sprint"] = {["handler"] = IWBSpellBase, ["no_rank"] = true},
	["Sap"] = {["handler"] = IWBSpellBase, ["no_rank"] = true},
	["Stealth"] = {["handler"] = IWBBuff, ["no_rank"] = true},
	["Vanish"] = {["handler"] = IWBSpellBase, ["no_rank"] = true},
	["Ghostly Strike"] = {["handler"] = IWBSpellBase, ["auto_target"] = true},
	["Hemorrhage"] = {["handler"] = IWBSpellBase, ["auto_target"] = true},
	["Mark for Death"] = {["handler"] = IWBSpellBase, ["auto_target"] = true},


	-- Priest
	
	["Divine Spirit"] = {["handler"] = IWBBuff, ["alias"] = "Prayer of Spirit"},
	["Fear Ward"] = {["handler"] = IWBBuff},
	["Inner Fire"] = {["handler"] = IWBBuff},
	["Power Word: Fortitude"] = {["handler"] = IWBBuff, ["alias"] = "Prayer of Fortitude"},
	["Power Word: Shield"] = {["handler"] = IWBShieldBuff},
	["Prayer of Fortitude"] = {["handler"] = IWBBuff},
	["Prayer of Spirit"] = {["handler"] = IWBBuff},
	["Shadow Protection"] = {["handler"] = IWBBuff},
	["Prayer of Shadow Protection"] = {["handler"] = IWBBuff},
	--["Mind Flay"] = {["handler"] = IWBBuff},

}


