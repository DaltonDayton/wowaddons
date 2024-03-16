
BigWigs3DB = {
	["namespaces"] = {
		["BigWigs_Plugins_Victory"] = {
		},
		["BigWigs_Plugins_Wipe"] = {
			["profiles"] = {
				["ToxiUI-Healer"] = {
					["wipeSound"] = "Awww Crap",
				},
				["ToxiUI-DPS"] = {
					["wipeSound"] = "Awww Crap",
				},
			},
		},
		["BigWigs_Plugins_Colors"] = {
			["profiles"] = {
				["ToxiUI-Healer"] = {
					["barEmphasized"] = {
						["BigWigs_Plugins_Colors"] = {
							["default"] = {
								0.97, -- [1]
								0.09, -- [2]
								0.56, -- [3]
							},
						},
					},
					["barColor"] = {
						["BigWigs_Plugins_Colors"] = {
							["default"] = {
								0.01, -- [1]
								0.63, -- [2]
								0.93, -- [3]
							},
						},
					},
					["red"] = {
						["BigWigs_Plugins_Colors"] = {
							["default"] = {
								0.7, -- [1]
								0.14, -- [2]
								0.14, -- [3]
								1, -- [4]
							},
						},
					},
				},
				["ToxiUI-DPS"] = {
					["barEmphasized"] = {
						["BigWigs_Plugins_Colors"] = {
							["default"] = {
								0.97, -- [1]
								0.09, -- [2]
								0.56, -- [3]
							},
						},
					},
					["barColor"] = {
						["BigWigs_Plugins_Colors"] = {
							["default"] = {
								0.01, -- [1]
								0.63, -- [2]
								0.93, -- [3]
							},
						},
					},
					["red"] = {
						["BigWigs_Plugins_Colors"] = {
							["default"] = {
								0.7, -- [1]
								0.14, -- [2]
								0.14, -- [3]
								1, -- [4]
							},
						},
					},
				},
			},
		},
		["BigWigs_Plugins_Raid Icons"] = {
		},
		["LibDualSpec-1.0"] = {
			["char"] = {
				["Xavaat - Ner'zhul"] = {
					"ToxiUI-Healer", -- [1]
					"ToxiUI-Healer", -- [2]
					"ToxiUI-DPS", -- [3]
					["enabled"] = true,
				},
			},
		},
		["BigWigs_Plugins_Bars"] = {
			["profiles"] = {
				["ToxiUI-Healer"] = {
					["outline"] = "OUTLINE",
					["fontSize"] = 16,
					["visibleBarLimit"] = 8,
					["alignTime"] = "LEFT",
					["BigWigsAnchor_width"] = 285,
					["BigWigsAnchor_y"] = 230,
					["iconPosition"] = "RIGHT",
					["emphasizeGrowup"] = true,
					["BigWigsAnchor_x"] = 1445,
					["spacing"] = 5,
					["fontSizeNameplate"] = 12,
					["barStyle"] = "ElvUI",
					["BigWigsEmphasizeAnchor_height"] = 26,
					["growup"] = true,
					["BigWigsEmphasizeAnchor_width"] = 274,
					["fontName"] = "- M 700",
					["BigWigsAnchor_height"] = 26,
					["emphasizeTime"] = 10,
					["BigWigsEmphasizeAnchor_y"] = 345,
					["visibleBarLimitEmph"] = 4,
					["alignText"] = "RIGHT",
					["BigWigsEmphasizeAnchor_x"] = 1045,
					["fontSizeEmph"] = 16,
					["fill"] = true,
					["texture"] = "- Tx Left",
				},
				["ToxiUI-DPS"] = {
					["BigWigsEmphasizeAnchor_y"] = 330,
					["fontSize"] = 16,
					["visibleBarLimit"] = 8,
					["alignTime"] = "LEFT",
					["BigWigsAnchor_width"] = 285,
					["BigWigsAnchor_y"] = 230,
					["iconPosition"] = "RIGHT",
					["emphasizeGrowup"] = true,
					["BigWigsAnchor_x"] = 1445,
					["spacing"] = 5,
					["fill"] = true,
					["barStyle"] = "ElvUI",
					["BigWigsEmphasizeAnchor_height"] = 26,
					["growup"] = true,
					["BigWigsEmphasizeAnchor_width"] = 274,
					["fontName"] = "- M 700",
					["BigWigsAnchor_height"] = 26,
					["emphasizeTime"] = 10,
					["outline"] = "OUTLINE",
					["visibleBarLimitEmph"] = 4,
					["alignText"] = "RIGHT",
					["BigWigsEmphasizeAnchor_x"] = 1045,
					["fontSizeEmph"] = 16,
					["fontSizeNameplate"] = 12,
					["texture"] = "- Tx Left",
				},
			},
		},
		["BigWigs_Plugins_AltPower"] = {
			["profiles"] = {
				["ToxiUI-Healer"] = {
					["fontSize"] = 14,
					["position"] = {
						nil, -- [1]
						nil, -- [2]
						-392, -- [3]
						-392, -- [4]
					},
					["backgroundColor"] = {
						nil, -- [1]
						nil, -- [2]
						nil, -- [3]
						0.31, -- [4]
					},
					["fontName"] = "- ToxiUI",
					["additionalWidth"] = 28,
				},
				["ToxiUI-DPS"] = {
					["fontSize"] = 14,
					["position"] = {
						nil, -- [1]
						nil, -- [2]
						-392, -- [3]
						-392, -- [4]
					},
					["backgroundColor"] = {
						nil, -- [1]
						nil, -- [2]
						nil, -- [3]
						0.31, -- [4]
					},
					["fontName"] = "- ToxiUI",
					["additionalWidth"] = 28,
				},
			},
		},
		["BigWigs_Plugins_InfoBox"] = {
			["profiles"] = {
				["ToxiUI-Healer"] = {
					["posx"] = 310,
					["posy"] = 207,
				},
				["ToxiUI-DPS"] = {
					["posx"] = 310,
					["posy"] = 207,
				},
			},
		},
		["BigWigs_Plugins_Sounds"] = {
		},
		["BigWigs_Plugins_Proximity"] = {
			["profiles"] = {
				["ToxiUI-Healer"] = {
					["posx"] = 1090,
					["fontSize"] = 24,
					["posy"] = 155,
					["objects"] = {
						["ability"] = false,
						["sound"] = false,
						["close"] = false,
					},
					["fontName"] = "- Big Noodle Titling",
					["width"] = 140.0000152587891,
				},
				["ToxiUI-DPS"] = {
					["objects"] = {
						["ability"] = false,
						["sound"] = false,
						["close"] = false,
					},
					["fontSize"] = 24,
					["posx"] = 1090,
					["posy"] = 155,
					["fontName"] = "- Big Noodle Titling",
					["width"] = 140.0000152587891,
				},
			},
		},
		["BigWigs_Plugins_Statistics"] = {
		},
		["BigWigs_Plugins_AutoReply"] = {
			["profiles"] = {
				["ToxiUI-Healer"] = {
					["exitCombat"] = 4,
					["mode"] = 4,
					["disabled"] = false,
				},
				["ToxiUI-DPS"] = {
					["exitCombat"] = 4,
					["mode"] = 4,
					["disabled"] = false,
				},
			},
		},
		["BigWigs_Plugins_Messages"] = {
			["profiles"] = {
				["ToxiUI-Healer"] = {
					["emphPosition"] = {
						"TOP", -- [1]
						"TOP", -- [2]
						nil, -- [3]
						-215, -- [4]
					},
					["emphUppercase"] = false,
					["align"] = "RIGHT",
					["emphFontName"] = "- M 700",
					["fontName"] = "- M 700",
					["fontSize"] = 20,
					["emphFontSize"] = 24,
					["outline"] = "OUTLINE",
					["normalPosition"] = {
						"CENTER", -- [1]
						"CENTER", -- [2]
						-340, -- [3]
						-160, -- [4]
					},
				},
				["ToxiUI-DPS"] = {
					["emphPosition"] = {
						"TOP", -- [1]
						"TOP", -- [2]
						nil, -- [3]
						-215, -- [4]
					},
					["emphUppercase"] = false,
					["align"] = "RIGHT",
					["emphFontName"] = "- M 700",
					["emphFontSize"] = 24,
					["fontSize"] = 20,
					["outline"] = "OUTLINE",
					["fontName"] = "- M 700",
					["normalPosition"] = {
						"CENTER", -- [1]
						"CENTER", -- [2]
						-340, -- [3]
						-160, -- [4]
					},
				},
			},
		},
		["BigWigs_Plugins_BossBlock"] = {
		},
		["BigWigs_Plugins_Pull"] = {
			["profiles"] = {
				["ToxiUI-Healer"] = {
					["voice"] = "English: Jim",
				},
				["ToxiUI-DPS"] = {
					["voice"] = "English: Jim",
				},
			},
		},
		["BigWigs_Plugins_Countdown"] = {
			["profiles"] = {
				["ToxiUI-Healer"] = {
					["fontSize"] = 100,
					["fontColor"] = {
						["b"] = 0.3,
					},
					["position"] = {
						"CENTER", -- [1]
						"CENTER", -- [2]
						nil, -- [3]
						-150, -- [4]
					},
					["voice"] = "enUS: Default (Male)",
					["fontName"] = "- M 900",
				},
				["ToxiUI-DPS"] = {
					["fontSize"] = 100,
					["fontColor"] = {
						["b"] = 0.3,
					},
					["position"] = {
						"CENTER", -- [1]
						"CENTER", -- [2]
						nil, -- [3]
						-150, -- [4]
					},
					["fontName"] = "- M 900",
					["voice"] = "enUS: Default (Male)",
				},
			},
		},
	},
	["global"] = {
		["watchedMovies"] = {
			[-607] = true,
			[-609] = true,
			[-437] = true,
			[16] = true,
			[-593] = {
				true, -- [1]
				true, -- [2]
			},
			[-2170] = true,
			[-573] = true,
			[-575] = true,
			[-323] = true,
		},
	},
	["profileKeys"] = {
		["Zatta - Ner'zhul"] = "ToxiUI-Healer",
		["Xenoth - Ner'zhul"] = "ToxiUI-Healer",
		["Xamuul - Ner'zhul"] = "ToxiUI-Healer",
		["Yushien - Ner'zhul"] = "ToxiUI-Healer",
		["Xavaat - Ner'zhul"] = "ToxiUI-Healer",
		["Shantyclause - Ner'zhul"] = "ToxiUI-DPS",
		["Faelaena - Ner'zhul"] = "ToxiUI-Healer",
		["Zenndi - Ner'zhul"] = "ToxiUI-DPS",
		["Nokzakan - Ner'zhul"] = "ToxiUI-DPS",
		["Zaldrysa - Ner'zhul"] = "ToxiUI-DPS",
		["Erthaesia - Ner'zhul"] = "ToxiUI-DPS",
	},
	["profiles"] = {
		["ToxiUI-Healer"] = {
			["showZoneMessages"] = true,
			["flash"] = true,
			["fakeDBMVersion"] = true,
		},
		["ToxiUI-DPS"] = {
			["showZoneMessages"] = true,
			["flash"] = true,
			["fakeDBMVersion"] = true,
		},
	},
}
BigWigsIconDB = {
	["hide"] = true,
}
BigWigsStatsDB = {
	[1530] = {
		[1737] = {
			["mythic"] = {
				["best"] = 89.67199999996228,
				["kills"] = 1,
			},
		},
		[1761] = {
			["mythic"] = {
				["best"] = 18.18699999997625,
				["kills"] = 1,
			},
		},
		[1713] = {
			["mythic"] = {
				["best"] = 10.90700000000652,
				["kills"] = 1,
			},
		},
		[1743] = {
			["mythic"] = {
				["best"] = 45.60499999998137,
				["kills"] = 1,
			},
		},
		[1732] = {
			["mythic"] = {
				["best"] = 12.08600000001025,
				["kills"] = 1,
			},
		},
		[1706] = {
			["mythic"] = {
				["best"] = 7.09499999997206,
				["kills"] = 1,
			},
		},
		[1725] = {
			["mythic"] = {
				["best"] = 7.632999999972526,
				["kills"] = 1,
			},
		},
		[1751] = {
			["mythic"] = {
				["best"] = 7.020000000018627,
				["kills"] = 1,
			},
		},
		[1731] = {
			["mythic"] = {
				["best"] = 7.605999999970663,
				["kills"] = 1,
			},
		},
		[1762] = {
			["mythic"] = {
				["best"] = 8.464000000036322,
				["kills"] = 1,
			},
		},
	},
	[2569] = {
		[2529] = {
			["LFR"] = {
				["best"] = 183.4570000000094,
				["kills"] = 5,
			},
		},
		[2522] = {
			["LFR"] = {
				["best"] = 175.2959999999875,
				["kills"] = 5,
			},
		},
		[2530] = {
			["LFR"] = {
				["best"] = 210.7299999999959,
				["kills"] = 5,
			},
		},
		[2523] = {
			["LFR"] = {
				["best"] = 379.2660000000033,
				["kills"] = 3,
			},
		},
		[2524] = {
			["LFR"] = {
				["kills"] = 1,
				["wipes"] = 2,
				["best"] = 290.1050000000978,
			},
		},
		[2532] = {
			["LFR"] = {
				["best"] = 279.0470000000205,
				["kills"] = 1,
			},
		},
		[2525] = {
			["LFR"] = {
				["best"] = 329.2110000000102,
				["kills"] = 1,
			},
		},
		[2527] = {
			["LFR"] = {
				["best"] = 239.9210000000021,
				["kills"] = 2,
			},
		},
		[2520] = {
			["LFR"] = {
				["kills"] = 3,
				["wipes"] = 3,
				["best"] = 454.6989999999933,
			},
		},
	},
	[603] = {
		[1647] = {
			["normal"] = {
				["best"] = 138.9569999999949,
				["kills"] = 1,
			},
		},
		[1644] = {
			["normal"] = {
				["best"] = 4.032000000006519,
				["kills"] = 1,
			},
		},
		[1637] = {
			["normal"] = {
				["best"] = 52.92599999997765,
				["kills"] = 1,
			},
		},
		[1641] = {
			["normal"] = {
				["best"] = 7.369000000006054,
				["kills"] = 1,
			},
		},
		[1645] = {
			["normal"] = {
				["best"] = 200.7600000000093,
				["kills"] = 1,
			},
		},
		[1649] = {
			["normal"] = {
				["best"] = 219.0899999999965,
				["kills"] = 1,
			},
		},
		[1638] = {
			["normal"] = {
				["best"] = 2.744000000006054,
				["kills"] = 1,
			},
		},
		[1642] = {
			["normal"] = {
				["best"] = 0.03700000001117587,
				["kills"] = 1,
			},
		},
		[1646] = {
			["normal"] = {
				["best"] = 8.25700000001234,
				["kills"] = 1,
			},
		},
		[1639] = {
			["normal"] = {
				["best"] = 111.7749999999942,
				["kills"] = 1,
			},
		},
		[1643] = {
			["normal"] = {
				["best"] = 0.0659999999916181,
				["kills"] = 1,
			},
		},
	},
	[1520] = {
		[1703] = {
			["mythic"] = {
				["best"] = 5.42000000004191,
				["kills"] = 1,
			},
		},
		[1738] = {
			["mythic"] = {
				["best"] = 105.2949999999837,
				["kills"] = 1,
			},
		},
	},
}
