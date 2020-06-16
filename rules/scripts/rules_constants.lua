-- Referenced constants
CopyrightText = {[1]="The Rolemaster Classic Ruleset (Fantasy Grounds II Conversion) by SmiteWorks USA, LLC, (C) 2013, ALL RIGHTS RESERVED. The Rolemaster Classic Ruleset format, programming code, and presentation is copyrighted by SmiteWorks USA, LLC and Aurigas Aldeberon LLC. Redistribution by print or by file is strictly prohibited.",
				 [2]="Rolemaster Classic (c) 2009-2013 by Aurigas Aldeberon LLC. ALL RIGHTS RESERVED.",
                 [3]="Rolemaster (r) is the registered trademark of Aurigas Aldeberon LLC",
                 [4]="Fantasy Grounds is a trademark of SmiteWorks USA, LLC (C) 2013. ALL RIGHTS RESERVED.",
                 [5]="Rolemaster Classic ruleset for Fantasy Grounds, version 1.7.1",
				 
                };

-- Table IDs				
ManeuverTableDefaultTableId = "SkillTab";
ResistanceRollTableID = "SkillTab";
UtilitySpellRollTableID = "SkillTab";
LargeAttackTableID = "HML-11";
HugeAttackTableID = "HML-12";

SkillType = {};
SkillType.Skill = 1;
SkillType.Spell = 2;
SkillType.Attack = 3;
SkillType.Other = 99;

AttackType = {};
AttackType.Melee = 1;
AttackType.Missile = 2;
AttackType.ElSpell = 3;
AttackType.Spell = 4;
AttackType.Other = 99;

MMType = {};
MMType.Generic  = "Generic MM";
MMType.Movement = "Movement MM";

TableType = {};
TableType.Attack = "Attack";
TableType.Result = "Result";
TableType.Other  = "Other";

DataType = {};
DataType.AttackEffects = "RMCAttackEffects";
DataType.DieRoll = "RMCDieRoll";

DieType = {};
DieType.OpenEnded = "OpenEnded";
DieType.HighOpenEnded = "HighOpenEnded";
DieType.LowOpenEnded = "LowOpenEnded";
DieType.Closed = "Closed";
