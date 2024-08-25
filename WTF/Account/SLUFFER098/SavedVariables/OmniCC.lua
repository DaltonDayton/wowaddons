
OmniCCDB = {
["profileKeys"] = {
["Xambank - Ner'zhul"] = "Default",
},
["global"] = {
["dbVersion"] = 6,
["addonVersion"] = "11.0.1",
},
["profiles"] = {
["Default"] = {
["rules"] = {
{
["id"] = "auras",
["patterns"] = {
"Aura",
"Buff",
"Debuff",
},
["name"] = "Auras",
["enabled"] = false,
},
{
["id"] = "plates",
["patterns"] = {
"Plate",
},
["name"] = "Unit Nameplates",
["enabled"] = false,
},
{
["id"] = "actions",
["patterns"] = {
"ActionButton",
"MultiBar",
},
["name"] = "Action Bars",
["enabled"] = false,
},
{
["patterns"] = {
"PlaterMainAuraIcon",
"PlaterSecondaryAuraIcon",
"ExtraIconRowIcon",
},
["id"] = "Plater Nameplates Rule",
["priority"] = 4,
["theme"] = "Plater Nameplates Theme",
},
},
["themes"] = {
["Default"] = {
["textStyles"] = {
["soon"] = {
},
["seconds"] = {
},
["minutes"] = {
},
},
},
["Plater Nameplates Theme"] = {
["textStyles"] = {
["soon"] = {
},
["seconds"] = {
},
["minutes"] = {
},
},
["enableText"] = false,
},
},
},
},
}
OmniCC4Config = nil
