--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.
--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.
local getcommit = function()
	return isfile('rendervape/profiles/commit.txt') and readfile('rendervape/profiles/commit.txt') or 'main'
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/renderintents/Render/'..getcommit()..'/'..select(1, path:gsub('rendervape/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local v18 = loadstring(downloadFile('rendervape/libraries/bedwars/sounds.lua'))()
local damageType = loadstring(downloadFile('rendervape/libraries/bedwars/damagetype.lua'))()

local u21 = {
    ["arrow"] = {
        ["launchVelocity"] = 240,
        ["gravitationalAcceleration"] = 35,
        ["lifetimeSec"] = 2.8,
        ["predictionLifetimeSec"] = 2,
        ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
        ["impactParticles"] = "default",
        ["arrow"] = true,
        ["combat"] = {
            ["damage"] = 18
        },
        ["knockbackMultiplier"] = {
            ["horizontal"] = 0.95
        }
    },
    ["iron_arrow"] = {
        ["launchVelocity"] = 240,
        ["gravitationalAcceleration"] = 35,
        ["lifetimeSec"] = 2.8,
        ["predictionLifetimeSec"] = 2,
        ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
        ["impactParticles"] = "default",
        ["arrow"] = true,
        ["combat"] = {
            ["damage"] = 22
        },
        ["knockbackMultiplier"] = {
            ["horizontal"] = 0.95
        }
    },
    ["firework_arrow"] = {
        ["launchVelocity"] = 300,
        ["gravitationalAcceleration"] = 35,
        ["lifetimeSec"] = 2.8,
        ["predictionLifetimeSec"] = 2,
        ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
        ["combat"] = {
            ["damage"] = 16
        },
        ["knockbackMultiplier"] = {
            ["horizontal"] = 0.95
        },
        ["fireworkExplosion"] = {
            ["damage"] = 12,
            ["radius"] = 12
        }
    },
    ["golden_arrow"] = {
        ["launchVelocity"] = 320,
        ["gravitationalAcceleration"] = 35,
        ["lifetimeSec"] = 2,
        ["predictionLifetimeSec"] = 1.1,
        ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
        ["projectileModel"] = "golden_arrow",
        ["arrow"] = true,
        ["combat"] = {
            ["damage"] = 30
        },
        ["knockbackMultiplier"] = {
            ["horizontal"] = 1.2
        }
    },
    ["golden_arrow_iron"] = {
        ["launchVelocity"] = 320,
        ["gravitationalAcceleration"] = 35,
        ["lifetimeSec"] = 2,
        ["predictionLifetimeSec"] = 1.1,
        ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
        ["projectileModel"] = "golden_arrow",
        ["arrow"] = true,
        ["combat"] = {
            ["damage"] = 34
        },
        ["knockbackMultiplier"] = {
            ["horizontal"] = 1.2
        }
    },
    ["crossbow_arrow"] = {
        ["launchVelocity"] = 400,
        ["gravitationalAcceleration"] = 35,
        ["lifetimeSec"] = 2,
        ["predictionLifetimeSec"] = 1.1,
        ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
        ["projectileModel"] = "arrow",
        ["impactParticles"] = "default",
        ["arrow"] = true,
        ["combat"] = {
            ["damage"] = 34,
            ["armorMultiplier"] = 0.9
        },
        ["knockbackMultiplier"] = {
            ["horizontal"] = 1.1
        }
    },
    ["crossbow_arrow_iron"] = {
        ["launchVelocity"] = 400,
        ["gravitationalAcceleration"] = 35,
        ["lifetimeSec"] = 2,
        ["predictionLifetimeSec"] = 1.1,
        ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
        ["projectileModel"] = "arrow",
        ["impactParticles"] = "default",
        ["arrow"] = true,
        ["combat"] = {
            ["damage"] = 38,
            ["armorMultiplier"] = 0.95
        },
        ["knockbackMultiplier"] = {
            ["horizontal"] = 1.1
        }
    },
    ["crossbow_firework_arrow"] = {
        ["launchVelocity"] = 400,
        ["gravitationalAcceleration"] = 35,
        ["lifetimeSec"] = 2,
        ["predictionLifetimeSec"] = 1.1,
        ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
        ["projectileModel"] = "firework_arrow",
        ["combat"] = {
            ["damage"] = 38,
            ["armorMultiplier"] = 0.95
        },
        ["knockbackMultiplier"] = {
            ["horizontal"] = 1.1
        },
        ["fireworkExplosion"] = {
            ["damage"] = 12,
            ["radius"] = 12
        }
    },
    ["tactical_crossbow_arrow"] = {
        ["launchVelocity"] = 500,
        ["gravitationalAcceleration"] = 35,
        ["lifetimeSec"] = 2,
        ["predictionLifetimeSec"] = 1.1,
        ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
        ["projectileModel"] = "arrow",
        ["arrow"] = true,
        ["combat"] = {
            ["damage"] = 38,
            ["armorMultiplier"] = 0.95
        },
        ["knockbackMultiplier"] = {
            ["horizontal"] = 1.15
        },
        ["impactSound"] = { v18.NEW_ARROW_IMPACT }
    },
    ["tactical_crossbow_arrow_iron"] = {
        ["launchVelocity"] = 500,
        ["gravitationalAcceleration"] = 35,
        ["lifetimeSec"] = 2,
        ["predictionLifetimeSec"] = 1.1,
        ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
        ["projectileModel"] = "arrow",
        ["arrow"] = true,
        ["combat"] = {
            ["damage"] = 44,
            ["armorMultiplier"] = 0.95
        },
        ["knockbackMultiplier"] = {
            ["horizontal"] = 1.15
        },
        ["impactSound"] = { v18.NEW_ARROW_IMPACT }
    },
    ["tactical_headhunter_arrow"] = {
        ["launchVelocity"] = 500,
        ["gravitationalAcceleration"] = 35,
        ["lifetimeSec"] = 2,
        ["predictionLifetimeSec"] = 1.1,
        ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
        ["projectileModel"] = "arrow",
        ["arrow"] = true,
        ["combat"] = {
            ["damage"] = 60,
            ["armorMultiplier"] = 0.95
        },
        ["knockbackMultiplier"] = {
            ["horizontal"] = 1.15
        }
    },
    ["tactical_headhunter_arrow_iron"] = {
        ["launchVelocity"] = 500,
        ["gravitationalAcceleration"] = 35,
        ["lifetimeSec"] = 2,
        ["predictionLifetimeSec"] = 1.1,
        ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
        ["projectileModel"] = "arrow",
        ["arrow"] = true,
        ["combat"] = {
            ["damage"] = 63,
            ["armorMultiplier"] = 0.95
        },
        ["knockbackMultiplier"] = {
            ["horizontal"] = 1.15
        }
    },
    ["tactical_crossbow_firework_arrow"] = {
        ["launchVelocity"] = 500,
        ["gravitationalAcceleration"] = 35,
        ["lifetimeSec"] = 2,
        ["predictionLifetimeSec"] = 1.1,
        ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
        ["projectileModel"] = "firework_arrow",
        ["combat"] = {
            ["damage"] = 44,
            ["armorMultiplier"] = 0.95
        },
        ["knockbackMultiplier"] = {
            ["horizontal"] = 1.15
        },
        ["fireworkExplosion"] = {
            ["damage"] = 12,
            ["radius"] = 12
        }
    },
    ["sheriff_crossbow_arrow"] = {
        ["launchVelocity"] = 500,
        ["gravitationalAcceleration"] = 35,
        ["lifetimeSec"] = 2,
        ["predictionLifetimeSec"] = 1.1,
        ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
        ["projectileModel"] = "arrow",
        ["canHitAllyPlayers"] = true,
        ["combat"] = {
            ["damage"] = 999,
            ["armorMultiplier"] = 0
        },
        ["knockbackMultiplier"] = {
            ["horizontal"] = 1.15
        }
    },
    ["telepearl"] = {
        ["launchVelocity"] = 120,
        ["gravitationalAcceleration"] = 70,
        ["ignoreMaxVelocityCheck"] = true,
        ["flightRotation"] = Vector3.new(0, 1.5707964, 0),
        ["impactParticles"] = "default"
    },
    ["zipline"] = {
        ["launchVelocity"] = 140,
        ["gravitationalAcceleration"] = 65,
        ["lifetimeSec"] = 2.8,
        ["predictionLifetimeSec"] = 2,
        ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
        ["projectileModel"] = "arrow",
        ["impactSound"] = { v18.FORTIFY_BLOCK }
    },
    ["fireball"] = {
        ["launchVelocity"] = 68,
        ["gravitationalAcceleration"] = 0,
        ["projectileModel"] = "fireball"
    },
    ["lasso"] = {
        ["launchVelocity"] = 200,
        ["gravitationalAcceleration"] = 135,
        ["predictionLifetimeSec"] = 0.8,
        ["lifetimeSec"] = 2,
        ["flightRotation"] = Vector3.new(0, 0, 0),
        ["hitscanRegionMultiplier"] = 2.5,
        ["wallHitscanRegionMultiplier"] = 0.75,
        ["returnDistance"] = 70,
        ["destroyOnReturnLerpFinished"] = false,
        ["skins"] = { "mummy", "wrangler_reindeer_lassy", "lifeguard" },
    },
    ["lightning_strike"] = {
        ["launchVelocity"] = 120,
        ["gravitationalAcceleration"] = 50,
        ["flightRotation"] = Vector3.new(0, 1.5707964, 0),
        ["impactSound"] = { v18.WIZARD_LIGHTNING_LAND }
    },
    ["electric_orb"] = {
        ["launchVelocity"] = 20,
        ["gravitationalAcceleration"] = 0,
        ["lifetimeSec"] = 3,
        ["playerCollisionDisabled"] = true,
        ["collisionDisabled"] = true
    }
}
u21.autoTurretBullet = {
    ["launchVelocity"] = 260,
    ["gravitationalAcceleration"] = 10,
    ["predictionLifetimeSec"] = 1,
    ["lifetimeSec"] = 1,
    ["projectileModel"] = "turretBullet",
    ["combat"] = {
        ["damage"] = 40
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.4
    }
}
u21.deploy_spirit = {
    ["launchVelocity"] = 120,
    ["gravitationalAcceleration"] = 120,
    ["flightRotation"] = Vector3.new(0, 1.5707964, 0)
}
u21.rocket_launcher_missile = {
    ["launchVelocity"] = 125,
    ["gravitationalAcceleration"] = 0.1,
    ["flightRotation"] = Vector3.new(0, -1.5707964, 0),
    ["combat"] = {
        ["damage"] = 50
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1.6
    },
    ["impactSound"] = { v18.TNT_EXPLODE_1 }
}
u21.impulse_grenade = {
    ["launchVelocity"] = 60,
    ["gravitationalAcceleration"] = 50
}
u21.smoke_grenade = {
    ["launchVelocity"] = 60,
    ["gravitationalAcceleration"] = 50
}
u21.hot_potato = {
    ["launchVelocity"] = 100,
    ["gravitationalAcceleration"] = 50,
    ["flightRotation"] = Vector3.new(0, -0.15707964, 0)
}
u21.stun_grenade = {
    ["launchVelocity"] = 120,
    ["gravitationalAcceleration"] = 60
}
u21.glitch_stun_grenade = {
    ["launchVelocity"] = 120,
    ["gravitationalAcceleration"] = 60
}
u21.sleep_splash_potion = {
    ["launchVelocity"] = 80,
    ["gravitationalAcceleration"] = 70
}
u21.poison_splash_potion = {
    ["launchVelocity"] = 80,
    ["gravitationalAcceleration"] = 70
}
u21.heal_splash_potion = {
    ["launchVelocity"] = 80,
    ["gravitationalAcceleration"] = 70
}
u21.large_rock = {
    ["launchVelocity"] = 140,
    ["gravitationalAcceleration"] = 65,
    ["lifetimeSec"] = 2.8,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["hitscanRegionMultiplier"] = 10,
    ["projectileModel"] = "large_rock_projectile",
    ["combat"] = {
        ["damage"] = 50
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 3
    }
}
u21.throwable_bridge = {
    ["launchVelocity"] = 140,
    ["gravitationalAcceleration"] = 65,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["projectileModel"] = "arrow",
    ["impactSound"] = { v18.FORTIFY_BLOCK }
}
u21.swap_ball = {
    ["launchVelocity"] = 140,
    ["gravitationalAcceleration"] = 65,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(0, 3.1415927, 0)
}
u21.banana_peel = {
    ["launchVelocity"] = 120,
    ["gravitationalAcceleration"] = 120,
    ["flightRotation"] = Vector3.new(0, 1.5707964, 0)
}
u21.fisherman_bobber = {
    ["launchVelocity"] = 25,
    ["gravitationalAcceleration"] = 30,
    ["flightRotation"] = Vector3.new(1.5707964, 1.5707964, 1.5707964),
    ["useServerModel"] = true,
    ["allowPlayerNetworkOwnership"] = true,
    ["lifetimeSec"] = 60,
    ["predictionLifetimeSec"] = 0.8
}
u21.ghost = {
    ["launchVelocity"] = 70,
    ["gravitationalAcceleration"] = 0,
    ["lifetimeSec"] = 3,
    ["predictionLifetimeSec"] = 1.75,
    ["hitscanRegionMultiplier"] = 2,
    ["combat"] = {
        ["damage"] = 60,
        ["armorMultiplier"] = 0.6
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 2.8
    }
}
u21.spear = {
    ["launchVelocity"] = 120,
    ["gravitationalAcceleration"] = 30,
    ["lifetimeSec"] = 4,
    ["flightRotation"] = Vector3.new(0, 1.5707964, 0),
    ["projectileModel"] = "spear",
    ["impactSound"] = { v18.FORTIFY_BLOCK }
}
u21.oil_projectile = {
    ["launchVelocity"] = 140,
    ["gravitationalAcceleration"] = 65,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 1.5707964),
    ["projectileModel"] = "oil_projectile"
}
local v24 = {
    ["launchVelocity"] = 240,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["combat"] = {
        ["damage"] = 1,
        ["noApplyDamageCooldown"] = true,
        --["damageType"] = u7.SNOWBALL
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.8
    },
    ["impactSound"] = { v18.SNOWBALL_HIT }
}
u21.snowball = v24
local v25 = {
    ["launchVelocity"] = 70,
    ["gravitationalAcceleration"] = 0,
    ["lifetimeSec"] = 0.2,
    ["predictionLifetimeSec"] = 0.2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["combat"] = {
        ["damage"] = 1,
        ["noApplyDamageCooldown"] = true,
        --["damageType"] = u7.SNOWBALL
    },
    ["knockbackMultiplier"] = {
        ["disabled"] = true
    },
    ["impactSound"] = { v18.CACTUS_ATTACH }
}
u21.cactus = v25
local v26 = {
    ["launchVelocity"] = 240,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["projectileModel"] = "frozen_snowball",
    ["combat"] = {
        ["damage"] = 1,
        ["noApplyDamageCooldown"] = true,
        --["damageType"] = u7.SNOWBALL
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.1,
        ["vertical"] = 0.1
    },
    ["impactSound"] = { v18.SNOWBALL_HIT }
}
u21.frozen_snowball = v26
local v27 = {
    ["launchVelocity"] = 240,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["projectileModel"] = "charged_frozen_snowball",
    ["combat"] = {
        ["damage"] = 1,
        ["noApplyDamageCooldown"] = true,
        --["damageType"] = u7.SNOWBALL
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.1,
        ["vertical"] = 0.1
    },
    ["impactSound"] = { v18.SNOWBALL_HIT }
}
u21.rapid_frozen_snowball = v27
local v28 = {
    ["launchVelocity"] = 240,
    ["gravitationalAcceleration"] = 100,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["projectileModel"] = "mega_frozen_snowball",
    ["combat"] = {
        ["damage"] = 50,
        ["noApplyDamageCooldown"] = true,
        --["damageType"] = u7.SNOWBALL
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.8,
        ["vertical"] = 0.8
    },
    ["impactSound"] = { v18.SNOWBALL_HIT }
}
u21.mega_frozen_snowball = v28
local v29 = {
    ["launchVelocity"] = 240,
    ["gravitationalAcceleration"] = 100,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["projectileModel"] = "charged_frozen_snowball",
    ["combat"] = {
        ["damage"] = 1,
        ["noApplyDamageCooldown"] = true,
        --["damageType"] = u7.SNOWBALL
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0,
        ["vertical"] = 0
    },
    ["impactSound"] = { v18.SNOWBALL_HIT }
}
u21.spread_frozen_snowball = v29
local v30 = {
    ["launchVelocity"] = 270,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["combat"] = {
        ["damage"] = 5,
        ["armorMultiplier"] = 0.25,
        --["damageType"] = u7.SNOWBALL
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.1
    },
    ["impactSound"] = { v18.SNOWBALL_HIT }
}
u21.frosted_snowball = v30
u21.blackhole_bomb = {
    ["launchVelocity"] = 120,
    ["gravitationalAcceleration"] = 120,
    ["flightRotation"] = Vector3.new(0, 1.5707964, 0),
    ["projectileModel"] = "blackhole_bomb"
}
u21.popup_cube = {
    ["launchVelocity"] = 120,
    ["gravitationalAcceleration"] = 120,
    ["flightRotation"] = Vector3.new(0, 1.5707964, 0)
}
u21.robbery_ball = {
    ["launchVelocity"] = 140,
    ["gravitationalAcceleration"] = 65,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(0, 3.1415927, 0),
    ["combat"] = {
        ["damage"] = 5
    }
}
u21.santa_bomb = {
    ["launchVelocity"] = 60,
    ["gravitationalAcceleration"] = 50
}
u21.santa_bomb_siege = {
    ["launchVelocity"] = 60,
    ["gravitationalAcceleration"] = 50
}
u21.throwing_knife = {
    ["launchVelocity"] = 170,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2.8,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["projectileModel"] = "throwing_knife",
    ["combat"] = {
        ["damage"] = 10
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.2
    }
}
u21.tornado_missile = {
    ["launchVelocity"] = 35,
    ["lifetimeSec"] = 2,
    ["keepProjectileOnHit"] = true,
    ["gravitationalAcceleration"] = 0,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["noArc"] = true,
    ["projectileModel"] = "tornado_missile",
    ["combat"] = {
        ["damage"] = 15,
        ["armorMultiplier"] = 0.9
    },
    ["knockbackMultiplier"] = {
        ["vertical"] = 2
    }
}
u21.sword_wave = {
    ["launchVelocity"] = 80,
    ["lifetimeSec"] = 2,
    ["gravitationalAcceleration"] = 0,
    ["flightRotation"] = Vector3.new(0, 0, 0),
    ["hitscanRegionMultiplier"] = 1.8,
    ["wallHitscanRegionMultiplier"] = 0.5,
    ["projectileModel"] = "sword_wave",
    ["combat"] = {
        ["damage"] = 21,
        ["armorMultiplier"] = 0.2,
        ["ignoreDamageCooldown"] = true
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.2,
        ["vertical"] = 0.2
    }
}
u21.sword_wave1 = {
    ["launchVelocity"] = 80,
    ["lifetimeSec"] = 2,
    ["hitscanRegionMultiplier"] = 3,
    ["wallHitscanRegionMultiplier"] = 0.5,
    ["gravitationalAcceleration"] = 0,
    ["flightRotation"] = Vector3.new(0, 0, 0),
    ["projectileModel"] = "sword_wave1",
    ["combat"] = {
        ["damage"] = 34,
        ["armorMultiplier"] = 0.2,
        ["ignoreDamageCooldown"] = true
    }
}
u21.festive_sword_wave = {
    ["launchVelocity"] = 80,
    ["lifetimeSec"] = 2,
    ["gravitationalAcceleration"] = 0,
    ["flightRotation"] = Vector3.new(0, 0, 0),
    ["hitscanRegionMultiplier"] = 1.8,
    ["wallHitscanRegionMultiplier"] = 0.5,
    ["projectileModel"] = "festive_sword_wave",
    ["combat"] = {
        ["damage"] = 21,
        ["armorMultiplier"] = 0.2,
        ["ignoreDamageCooldown"] = true
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.2,
        ["vertical"] = 0.2
    }
}
u21.festive_sword_wave1 = {
    ["launchVelocity"] = 80,
    ["lifetimeSec"] = 2,
    ["hitscanRegionMultiplier"] = 3,
    ["wallHitscanRegionMultiplier"] = 0.5,
    ["gravitationalAcceleration"] = 0,
    ["flightRotation"] = Vector3.new(0, 0, 0),
    ["projectileModel"] = "festive_sword_wave1",
    ["combat"] = {
        ["damage"] = 34,
        ["armorMultiplier"] = 0.2,
        ["ignoreDamageCooldown"] = true
    }
}
u21.carrot_rocket = {
    ["launchVelocity"] = 120,
    ["gravitationalAcceleration"] = 50,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(0, 1.5707964, 0),
    ["orbit"] = {
        ["timeTillMaxOrbit"] = 1,
        ["radius"] = 1
    }
}
u21.boba_pearl = {
    ["launchVelocity"] = 230,
    ["gravitationalAcceleration"] = 90,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["hitscanRegionMultiplier"] = 1.1,
    ["impactSound"] = { v18.BOBA_IMPACT }
}
u21.detonated_bomb = {
    ["launchVelocity"] = 180,
    ["gravitationalAcceleration"] = 90,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["impactSound"] = { v18.BOBA_IMPACT }
}
u21.portal_projectile = {
    ["launchVelocity"] = 45,
    ["gravitationalAcceleration"] = 0,
    ["flightRotation"] = Vector3.new(-1.5707964, -1.5707964, -1.5707964),
    ["lifetimeSec"] = 2
}
u21.grappling_hook_projectile = {
    ["launchVelocity"] = 140,
    ["gravitationalAcceleration"] = 0,
    ["lifetimeSec"] = 0.9,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(3.1415927, 1.5707964, 0),
    ["impactParticles"] = "default",
    ["returnDistance"] = 75,
    ["combat"] = {
        ["damage"] = 25
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.95
    }
}
u21.penguin_sniper_shot = {
    ["launchVelocity"] = 40,
    ["gravitationalAcceleration"] = 0,
    ["lifetimeSec"] = 2,
    ["predictionLifetimeSec"] = 1.1,
    ["flightRotation"] = Vector3.new(0, 0, 0),
    ["hitscanRegionMultiplier"] = 2,
    ["projectileModel"] = "carrot_rocket",
    ["impactParticles"] = "default",
    ["combat"] = {
        ["damage"] = 44,
        ["armorMultiplier"] = 0.95
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1.1
    }
}
u21.penguin_ultra_sniper_shot = {
    ["launchVelocity"] = 60,
    ["gravitationalAcceleration"] = 0,
    ["lifetimeSec"] = 2,
    ["predictionLifetimeSec"] = 1.1,
    ["flightRotation"] = Vector3.new(0, 0, 0),
    ["hitscanRegionMultiplier"] = 2,
    ["projectileModel"] = "carrot_rocket",
    ["impactParticles"] = "default",
    ["combat"] = {
        ["damage"] = 66,
        ["armorMultiplier"] = 0.95
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1.1
    }
}
u21.sticky_firework = {
    ["launchVelocity"] = 120,
    ["gravitationalAcceleration"] = 70,
    ["flightRotation"] = Vector3.new(0, 1.5707964, 0),
    ["combat"] = {
        ["damage"] = 1,
        ["noApplyDamageCooldown"] = true,
        ["ignoreDamageTakenCooldown"] = true,
        ["ignoreArmor"] = true
    }
}
u21.dizzy_toad = {
    ["launchVelocity"] = 120,
    ["gravitationalAcceleration"] = 70,
    ["flightRotation"] = Vector3.new(0, 0, 0),
    ["combat"] = {
        ["damage"] = 1,
        ["noApplyDamageCooldown"] = true,
        ["ignoreDamageTakenCooldown"] = true,
        ["ignoreArmor"] = true
    }
}
u21.tennis_ball = {
    ["launchVelocity"] = 180,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 3,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["impactParticles"] = "default",
    ["armorMultiplier"] = 0.8,
    ["combat"] = {
        ["damage"] = 25
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1.3,
        ["vertical"] = 1.15
    },
    ["impactSound"] = { v18.SNOWBALL_HIT }
}
u21.volley_arrow = {
    ["launchVelocity"] = 1,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["impactParticles"] = "default",
    ["noLaunchCooldownProtection"] = true,
    ["noAmmoValidation"] = true,
    ["ignoreMaxVelocityCheck"] = true,
    ["arrow"] = true,
    ["combat"] = {
        ["damage"] = 20,
        ["ignoreDamageTakenCooldown"] = true,
        ["noApplyDamageCooldown"] = true
    },
    ["knockbackMultiplier"] = {
        ["vertical"] = 0.02,
        ["horizontal"] = 0.05
    },
    ["impactSound"] = { v18.ARROW_HIT }
}
u21.blunderbuss_bullet = {
    ["launchVelocity"] = 400,
    ["gravitationalAcceleration"] = 0,
    ["lifetimeSec"] = 3,
    ["impactParticles"] = "default",
    ["noAmmoValidation"] = true,
    ["combat"] = {
        ["damage"] = 20,
        ["ignoreDamageTakenCooldown"] = true,
        ["noApplyDamageCooldown"] = true
    },
    ["knockbackMultiplier"] = {
        ["vertical"] = 0.05,
        ["horizontal"] = 0.18
    }
}
u21.glitch_snowball = {
    ["launchVelocity"] = 240,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["combat"] = {
        ["damage"] = 8
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.7
    },
    ["impactSound"] = { v18.SPIRIT_EXPLODE }
}
u21.glitch_popup_cube = {
    ["launchVelocity"] = 120,
    ["gravitationalAcceleration"] = 120,
    ["flightRotation"] = Vector3.new(0, 1.5707964, 0)
}
u21.glitch_robbery_ball = {
    ["launchVelocity"] = 140,
    ["gravitationalAcceleration"] = 65,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(0, 3.1415927, 0),
    ["combat"] = {
        ["damage"] = 5
    }
}
u21.glitch_throwable_bridge = {
    ["launchVelocity"] = 140,
    ["gravitationalAcceleration"] = 65,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["projectileModel"] = "arrow",
    ["impactSound"] = { v18.FORTIFY_BLOCK }
}
u21.glitch_arrow = {
    ["launchVelocity"] = 100,
    ["gravitationalAcceleration"] = 80,
    ["lifetimeSec"] = 0.01,
    ["predictionLifetimeSec"] = 0.5,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["projectileModel"] = "arrow",
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0,
        ["vertical"] = 0
    }
}
u21.glitch_tactical_arrow = {
    ["launchVelocity"] = 60,
    ["gravitationalAcceleration"] = 0,
    ["lifetimeSec"] = 3,
    ["projectileModel"] = "raven",
    ["impactSound"] = { v18.SPIRIT_EXPLODE }
}
u21.mage_spell_base = {
    ["launchVelocity"] = 160,
    ["gravitationalAcceleration"] = 0,
    ["flightRotation"] = Vector3.new(0, 0, 0),
    ["lifetimeSec"] = 2,
    ["predictionLifetimeSec"] = 1.75,
    ["combat"] = {
        ["damage"] = 20
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.12
    },
    ["impactSound"] = { v18.VOLLEY_ARROW_HIT }
}
u21.mage_spell_nature = {
    ["launchVelocity"] = 200,
    ["gravitationalAcceleration"] = 0,
    ["flightRotation"] = Vector3.new(0, 0, 0),
    ["lifetimeSec"] = 2,
    ["predictionLifetimeSec"] = 1.75,
    ["combat"] = {
        ["damage"] = 35,
        ["armorMultiplier"] = 0.7
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.3
    },
    ["impactSound"] = { v18.VOLLEY_ARROW_HIT }
}
u21.mage_spell_fire = {
    ["launchVelocity"] = 200,
    ["gravitationalAcceleration"] = 0,
    ["flightRotation"] = Vector3.new(0, 0, 0),
    ["lifetimeSec"] = 2,
    ["predictionLifetimeSec"] = 1.75,
    ["combat"] = {
        ["damage"] = 37,
        ["armorMultiplier"] = 0.7
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.3
    },
    ["impactSound"] = { v18.VOLLEY_ARROW_HIT }
}
u21.mage_spell_ice = {
    ["launchVelocity"] = 200,
    ["gravitationalAcceleration"] = 0,
    ["flightRotation"] = Vector3.new(0, 0, 0),
    ["lifetimeSec"] = 2,
    ["predictionLifetimeSec"] = 1.75,
    ["combat"] = {
        ["damage"] = 40,
        ["armorMultiplier"] = 0.3
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.95
    },
    ["impactSound"] = { v18.VOLLEY_ARROW_HIT }
}
u21.dragon_breath = {
    ["launchVelocity"] = 60,
    ["gravitationalAcceleration"] = 0,
    ["lifetimeSec"] = 3,
    ["projectileModel"] = "raven",
    ["impactSound"] = { v18.SPIRIT_EXPLODE }
}
u21.deploy_skeleton = {
    ["predictionLifetimeSec"] = 1,
    ["launchVelocity"] = 80,
    ["gravitationalAcceleration"] = 30,
    ["flightRotation"] = Vector3.new(0, 1.5707964, 0)
}
u21.deploy_chicken = {
    ["predictionLifetimeSec"] = 2,
    ["launchVelocity"] = 60,
    ["gravitationalAcceleration"] = 50,
    ["flightRotation"] = Vector3.new(0.7853982, 0, 0)
}
u21.pumpkin_bomb_1 = {
    ["launchVelocity"] = 100,
    ["gravitationalAcceleration"] = 65,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(0, 3.1415927, 0)
}
u21.pumpkin_bomb_2 = {
    ["launchVelocity"] = 100,
    ["gravitationalAcceleration"] = 75,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(0, 3.1415927, 0)
}
u21.pumpkin_bomb_3 = {
    ["launchVelocity"] = 100,
    ["gravitationalAcceleration"] = 85,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(0, 3.1415927, 0)
}
u21.halloween_obby_falling_object = {
    ["launchVelocity"] = 60,
    ["lifetimeSec"] = 3,
    ["projectileModel"] = "large_rock_projectile",
    ["impactSound"] = { v18.STOMPER_HIT },
    ["combat"] = {
        ["damage"] = 30
    }
}
u21.penguin_web = {
    ["launchVelocity"] = 100,
    ["gravitationalAcceleration"] = 85,
    ["lifetimeSec"] = 3,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(0, 0, 0)
}
u21.big_web = {
    ["launchVelocity"] = 100,
    ["gravitationalAcceleration"] = 85,
    ["lifetimeSec"] = 3,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(0, 0, 0),
    ["projectileModel"] = "penguin_web",
    ["canHitAllyPlayers"] = true
}
u21.glue_trap = {
    ["launchVelocity"] = 100,
    ["gravitationalAcceleration"] = 85,
    ["lifetimeSec"] = 3,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(0, 0, 0)
}
u21.glue_trap_charging = {
    ["launchVelocity"] = 100,
    ["gravitationalAcceleration"] = 85,
    ["lifetimeSec"] = 3,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(0, 0, 0)
}
u21.repair_tool = {
    ["launchVelocity"] = 120,
    ["gravitationalAcceleration"] = 85,
    ["lifetimeSec"] = 4,
    ["predictionLifetimeSec"] = 1.5,
    ["flightRotation"] = Vector3.new(0, 0, 0)
}
u21.ice_fishing_bobber = {
    ["launchVelocity"] = 50,
    ["gravitationalAcceleration"] = 30,
    ["flightRotation"] = Vector3.new(1.5707964, 1.5707964, 1.5707964),
    ["lifetimeSec"] = 60,
    ["predictionLifetimeSec"] = 0.8,
    ["projectileModel"] = "fisherman_bobber"
}
u21.meteor_shower = {
    ["launchVelocity"] = 120,
    ["gravitationalAcceleration"] = 120,
    ["flightRotation"] = Vector3.new(0, 1.5707964, 0)
}
u21.star_projectile = {
    ["launchVelocity"] = 100,
    ["gravitationalAcceleration"] = 20,
    ["lifetimeSec"] = 4,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["impactParticles"] = "default",
    ["combat"] = {
        ["damage"] = 20,
        ["ignoreDamageTakenCooldown"] = true
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.95
    }
}
u21.party_popper = {
    ["launchVelocity"] = 60,
    ["gravitationalAcceleration"] = 50
}
u21.teleport_hat = {
    ["launchVelocity"] = 125,
    ["gravitationalAcceleration"] = 30,
    ["lifetimeSec"] = 3,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(0, -3.1415927, 0),
    ["canHitAllyPlayers"] = true,
    ["hitscanRegionMultiplier"] = 1.5
}
local v31 = {
    ["launchVelocity"] = 220,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2.4,
    ["predictionLifetimeSec"] = 1,
    ["firedFromServer"] = true,
    ["hitscanRegionMultiplier"] = 2,
    ["bypassShooterLock"] = true,
    ["combat"] = {
        ["noApplyDamageCooldown"] = true,
        ["ignoreDamageTakenCooldown"] = true,
        ["armorMultiplier"] = 0.8,
       -- ["damage"] = v3.OWL_SHOOTING_DAMAGE
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1
    }
}
u21.owl_projectile = v31
local v32 = {
    ["launchVelocity"] = 220,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2.4,
    ["predictionLifetimeSec"] = 1,
    ["firedFromServer"] = true,
    ["hitscanRegionMultiplier"] = 2,
    ["bypassShooterLock"] = true,
    ["projectileModel"] = "owl_projectile",
    ["combat"] = {
        ["noApplyDamageCooldown"] = true,
        ["ignoreDamageTakenCooldown"] = true,
        ["armorMultiplier"] = 0.8,
        --["damage"] = v3.OWL_WOOD_DAMAGE
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1
    }
}
u21.owl_projectile_WOOD = v32
local v33 = {
    ["launchVelocity"] = 220,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2.4,
    ["predictionLifetimeSec"] = 1,
    ["firedFromServer"] = true,
    ["hitscanRegionMultiplier"] = 2,
    ["bypassShooterLock"] = true,
    ["projectileModel"] = "owl_projectile",
    ["combat"] = {
        ["noApplyDamageCooldown"] = true,
        ["ignoreDamageTakenCooldown"] = true,
        ["armorMultiplier"] = 0.8,
        --["damage"] = v3.OWL_STONE_DAMAGE
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1
    }
}
u21.owl_projectile_STONE = v33
local v34 = {
    ["launchVelocity"] = 220,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2.4,
    ["predictionLifetimeSec"] = 1,
    ["firedFromServer"] = true,
    ["hitscanRegionMultiplier"] = 2,
    ["bypassShooterLock"] = true,
    ["projectileModel"] = "owl_projectile",
    ["combat"] = {
        ["noApplyDamageCooldown"] = true,
        ["ignoreDamageTakenCooldown"] = true,
        ["armorMultiplier"] = 0.8,
        --["damage"] = v3.OWL_IRON_DAMAGE
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1
    }
}
u21.owl_projectile_IRON = v34
local v35 = {
    ["launchVelocity"] = 220,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2.4,
    ["predictionLifetimeSec"] = 1,
    ["firedFromServer"] = true,
    ["hitscanRegionMultiplier"] = 2,
    ["bypassShooterLock"] = true,
    ["projectileModel"] = "owl_projectile",
    ["combat"] = {
        ["noApplyDamageCooldown"] = true,
        ["ignoreDamageTakenCooldown"] = true,
        ["armorMultiplier"] = 0.8,
        --["damage"] = v3.OWL_DIAMOND_DAMAGE
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1
    }
}
u21.owl_projectile_DIAMOND = v35
local v36 = {
    ["launchVelocity"] = 220,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2.4,
    ["predictionLifetimeSec"] = 1,
    ["firedFromServer"] = true,
    ["hitscanRegionMultiplier"] = 2,
    ["bypassShooterLock"] = true,
    ["projectileModel"] = "owl_projectile",
    ["combat"] = {
        ["noApplyDamageCooldown"] = true,
        ["ignoreDamageTakenCooldown"] = true,
        ["armorMultiplier"] = 0.8,
        --["damage"] = v3.OWL_EMERALD_DAMAGE
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1
    }
}
u21.owl_projectile_EMERALD = v36
u21.rainbow_arrow = {
    ["launchVelocity"] = 150,
    ["gravitationalAcceleration"] = 20,
    ["lifetimeSec"] = 4,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["impactParticles"] = "default",
    ["arrow"] = true,
    ["combat"] = {
        ["damage"] = 30,
        ["ignoreDamageTakenCooldown"] = true
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.95
    }
}
u21.rainbow_bridge = {
    ["launchVelocity"] = 140,
    ["gravitationalAcceleration"] = 65,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["impactSound"] = { v18.FORTIFY_BLOCK }
}
u21.rainbow_bridge_gadget = {
    ["launchVelocity"] = 140,
    ["gravitationalAcceleration"] = 65,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["collisionDisabled"] = true,
    ["projectileModel"] = "rainbow_bridge",
    ["impactSound"] = { v18.FORTIFY_BLOCK }
}
u21.murderer_throwing_knife = {
    ["launchVelocity"] = 170,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2.8,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["projectileModel"] = "throwing_knife",
    ["canHitAllyPlayers"] = true,
    ["combat"] = {
        ["damage"] = 999
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.2
    }
}
u21.beehive_grenade = {
    ["launchVelocity"] = 60,
    ["gravitationalAcceleration"] = 50
}
u21.sand_spear = {
    ["launchVelocity"] = 250,
    ["gravitationalAcceleration"] = 90,
    ["lifetimeSec"] = 8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["impactParticles"] = "default",
    ["impactSound"] = { v18.SAND_SPEAR_HIT },
    ["combat"] = {
        ["damage"] = 30,
        ["ignoreDamageTakenCooldown"] = true
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1.5
    }
}
u21.easter_egg = {
    ["launchVelocity"] = 120,
    ["gravitationalAcceleration"] = 60
}
u21.flower_arrow = {
    ["launchVelocity"] = 240,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["impactParticles"] = "default",
    ["projectileModel"] = "arrow",
    ["arrow"] = true,
    ["combat"] = {
        ["damage"] = 16
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.95
    }
}
u21.flower_arrow_iron = {
    ["launchVelocity"] = 240,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["impactParticles"] = "default",
    ["projectileModel"] = "arrow",
    ["arrow"] = true,
    ["combat"] = {
        ["damage"] = 20
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.95
    }
}
u21.flower_crossbow_arrow = {
    ["launchVelocity"] = 400,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2,
    ["predictionLifetimeSec"] = 1.1,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["projectileModel"] = "arrow",
    ["impactParticles"] = "default",
    ["arrow"] = true,
    ["combat"] = {
        ["damage"] = 34,
        ["armorMultiplier"] = 0.95
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1.1
    }
}
u21.flower_crossbow_arrow_iron = {
    ["launchVelocity"] = 400,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2,
    ["predictionLifetimeSec"] = 1.1,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["projectileModel"] = "arrow",
    ["impactParticles"] = "default",
    ["arrow"] = true,
    ["combat"] = {
        ["damage"] = 38,
        ["armorMultiplier"] = 0.95
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1.1
    }
}
u21.flower_headhunter_arrow = {
    ["launchVelocity"] = 500,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2,
    ["predictionLifetimeSec"] = 1.1,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["projectileModel"] = "arrow",
    ["arrow"] = true,
    ["combat"] = {
        ["damage"] = 55,
        ["armorMultiplier"] = 0.95
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1.15
    },
    ["impactSound"] = { v18.NEW_ARROW_IMPACT }
}
u21.flower_headhunter_arrow_iron = {
    ["launchVelocity"] = 500,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2,
    ["predictionLifetimeSec"] = 1.1,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["projectileModel"] = "arrow",
    ["arrow"] = true,
    ["combat"] = {
        ["damage"] = 59,
        ["armorMultiplier"] = 0.95
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1.15
    },
    ["impactSound"] = { v18.NEW_ARROW_IMPACT }
}
u21.headhunter_arrow = {
    ["launchVelocity"] = 500,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2,
    ["predictionLifetimeSec"] = 1.1,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["projectileModel"] = "arrow",
    ["arrow"] = true,
    ["combat"] = {
        ["damage"] = 55,
        ["armorMultiplier"] = 0.95
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1.15
    }
}
u21.headhunter_arrow_iron = {
    ["launchVelocity"] = 500,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2,
    ["predictionLifetimeSec"] = 1.1,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["projectileModel"] = "arrow",
    ["arrow"] = true,
    ["combat"] = {
        ["damage"] = 59,
        ["armorMultiplier"] = 0.95
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1.15
    }
}
u21.headhunter_firework_arrow = {
    ["launchVelocity"] = 500,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2,
    ["predictionLifetimeSec"] = 1.1,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["projectileModel"] = "firework_arrow",
    ["combat"] = {
        ["damage"] = 49,
        ["armorMultiplier"] = 0.95
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1.15
    },
    ["fireworkExplosion"] = {
        ["damage"] = 12,
        ["radius"] = 12
    }
}
u21.spirit_bridge = {
    ["launchVelocity"] = 140,
    ["lifetimeSec"] = 1.8,
    ["predictionLifetimeSec"] = 1,
    ["flightRotation"] = Vector3.new(0, -0.15707964, 0),
    ["gravitationalAcceleration"] = 3.5,
    ["showIndicatorAtAimingBeamHit"] = true,
    ["impactSound"] = { v18.SPIRIT_BRIDGE_PROJECTILE_LAND }
}
u21.fork_trident_projectile = {
    ["launchVelocity"] = 90,
    ["gravitationalAcceleration"] = 0,
    ["playerCollisionDisabled"] = false,
    ["keepProjectileOnHit"] = true,
    ["hitscanRegionMultiplier"] = 1.5,
    ["returnDistance"] = 120,
    ["returnOnHit"] = true,
    ["predictionLifetimeSec"] = 1.3,
    ["lifetimeSec"] = 2.7,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["wallHitscanRegionMultiplier"] = 0.5,
    --["equipItemOnReturn"] = v16.FORK_TRIDENT,
    ["combat"] = {
        ["damage"] = 15,
        ["armorMultiplier"] = 0.2,
        ["ignoreDamageCooldown"] = true
    }
}
local v37 = {
    ["launchVelocity"] = 80,
    ["gravitationalAcceleration"] = 40,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["impactParticles"] = "default",
    ["combat"] = {
        ["damage"] = 10
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.95
    },
    ["impactSound"] = { v18.NEW_ARROW_IMPACT },
    ["hitSounds"] = {
        { v18.GUMBALL_LAUNCHER_SPLATTER_1, v18.GUMBALL_LAUNCHER_SPLATTER_2, v18.GUMBALL_LAUNCHER_SPLATTER_3 }
    }
}
u21.gumball = v37
u21.dark_ball = {
    ["launchVelocity"] = 240,
    ["gravitationalAcceleration"] = 0,
    ["lifetimeSec"] = 1.8,
    ["combat"] = {
        ["damage"] = 20,
        ["noApplyDamageCooldown"] = true,
        ["ignoreDamageTakenCooldown"] = true
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1
    },
    ["impactSound"] = { v18.DARK_BOLT_HIT }
}
u21.ghost_orb = {
    ["launchVelocity"] = 120,
    ["gravitationalAcceleration"] = 120,
    ["projectileModel"] = "ghost_orb"
}
u21.frozen_fortress = {
    ["launchVelocity"] = 120,
    ["gravitationalAcceleration"] = 120,
    ["flightRotation"] = Vector3.new(0, 1.5707964, 0)
}
u21.bananarang = {
    ["gravitationalAcceleration"] = 0,
    ["launchVelocity"] = 140,
    ["projectileModel"] = "bananarang",
    ["lifetimeSec"] = 20,
    ["predictionLifetimeSec"] = 0.5,
    ["keepProjectileOnHit"] = true,
    ["returnDistance"] = 48,
    ["returnOnHit"] = true,
    ["returnWithConstantVelocity"] = true,
    ["destroyOnReturnLerpFinished"] = true,
    ["spinAxis"] = Vector3.new(0, 0, -1),
    ["spinSpeed"] = 20
}
u21.hero_magical_girl_scepter_projectile = {
    ["launchVelocity"] = 100,
    ["gravitationalAcceleration"] = 15,
    ["lifetimeSec"] = 2,
    ["predictionLifetimeSec"] = 0.75,
    ["flightRotation"] = Vector3.new(0, -1.5707964, 0),
    ["projectileModel"] = "hero_magical_girl_scepter_projectile",
    ["spinAxis"] = Vector3.new(0, -1, 0),
    ["spinSpeed"] = 10,
    ["noLaunchCooldownProtection"] = true,
    ["combat"] = {
        ["damage"] = 15,
        ["noApplyDamageCooldown"] = true
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0,
        ["vertical"] = 0
    }
}
u21.hero_magical_girl_scepter_multi_projectile = {
    ["launchVelocity"] = 100,
    ["gravitationalAcceleration"] = 15,
    ["lifetimeSec"] = 2,
    ["predictionLifetimeSec"] = 0.75,
    ["flightRotation"] = Vector3.new(0, -1.5707964, 0),
    ["projectileModel"] = "hero_magical_girl_scepter_projectile",
    ["spinAxis"] = Vector3.new(0, -1, 0),
    ["spinSpeed"] = 10,
    ["noLaunchCooldownProtection"] = true,
    ["combat"] = {
        ["damage"] = 15,
        ["noApplyDamageCooldown"] = true
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0,
        ["vertical"] = 0
    }
}
u21.villain_magical_girl_scepter_projectile = {
    ["launchVelocity"] = 150,
    ["gravitationalAcceleration"] = 10,
    ["lifetimeSec"] = 2,
    ["predictionLifetimeSec"] = 0.75,
    ["flightRotation"] = Vector3.new(0, -1.5707964, 0),
    ["projectileModel"] = "villain_magical_girl_scepter_projectile",
    ["spinAxis"] = Vector3.new(0, -1, 0),
    ["spinSpeed"] = 10,
    ["noLaunchCooldownProtection"] = true,
    ["combat"] = {
        ["damage"] = 18,
        ["noApplyDamageCooldown"] = true
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0,
        ["vertical"] = 0
    }
}
u21.villain_magical_girl_scepter_multi_projectile = {
    ["launchVelocity"] = 150,
    ["gravitationalAcceleration"] = 10,
    ["lifetimeSec"] = 2,
    ["predictionLifetimeSec"] = 0.75,
    ["flightRotation"] = Vector3.new(0, -1.5707964, 0),
    ["projectileModel"] = "villain_magical_girl_scepter_projectile",
    ["spinAxis"] = Vector3.new(0, -1, 0),
    ["spinSpeed"] = 10,
    ["noLaunchCooldownProtection"] = true,
    ["combat"] = {
        ["damage"] = 18,
        ["noApplyDamageCooldown"] = true
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0,
        ["vertical"] = 0
    }
}
u21.disco_grenade = {
    ["launchVelocity"] = 60,
    ["gravitationalAcceleration"] = 50
}
u21.firework_projectile = {
    ["launchVelocity"] = 0.001,
    ["gravitationalAcceleration"] = 1,
    ["combat"] = {
        ["damage"] = 10
    }
}
u21.firework_rocket_missile = {
    ["launchVelocity"] = 125,
    ["gravitationalAcceleration"] = 0.1,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["combat"] = {
        ["damage"] = 40
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1.6
    },
    ["impactSound"] = { v18.FIREBALL_EXPLODE }
}
local v38 = {
    ["launchVelocity"] = 400,
    ["gravitationalAcceleration"] = 2,
    ["lifetimeSec"] = 1.2,
    ["predictionLifetimeSec"] = 1,
    ["firedFromServer"] = true,
    ["bypassShooterLock"] = true,
    ["projectileModel"] = "hero_magical_girl_rapier_projectile",
    ["spinAxis"] = Vector3.new(0, -1, 0),
    ["spinSpeed"] = 20,
    ["combat"] = {
        ["noApplyDamageCooldown"] = true,
        ["ignoreDamageTakenCooldown"] = true,
        --["damage"] = v2.PROJECTILE_DAMAGE
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.1
    }
}
u21.hero_magical_girl_rapier_projectile = v38
local v39 = {
    ["launchVelocity"] = 400,
    ["gravitationalAcceleration"] = 2,
    ["lifetimeSec"] = 1.2,
    ["predictionLifetimeSec"] = 1,
    ["flightRotation"] = Vector3.new(0, -1.5707964, 0),
    ["firedFromServer"] = true,
    ["bypassShooterLock"] = true,
    ["projectileModel"] = "villain_magical_girl_rapier_projectile",
    ["spinAxis"] = Vector3.new(-1, 0, 0),
    ["spinSpeed"] = 20,
    ["combat"] = {
        ["noApplyDamageCooldown"] = true,
        ["ignoreDamageTakenCooldown"] = true,
        --["damage"] = v2.PROJECTILE_DAMAGE
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.1
    }
}
u21.villain_magical_girl_rapier_projectile = v39
u21.firecrackers = {
    ["launchVelocity"] = 150,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["combat"] = {
        ["damage"] = 1,
        ["noApplyDamageCooldown"] = true
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.8
    }
}
u21.throwable_egg = {
    ["launchVelocity"] = 120,
    ["gravitationalAcceleration"] = 70,
    ["flightRotation"] = Vector3.new(0, 1.5707964, 0),
    ["impactParticles"] = "default",
    ["impactSound"] = { v18.EGG_EXPLOSION }
}
u21.cluster_bomb = {
    ["launchVelocity"] = 120,
    ["gravitationalAcceleration"] = 120,
    ["flightRotation"] = Vector3.new(0, 1.5707964, 0)
}
u21.party_hat_missile = {
    ["launchVelocity"] = 125,
    ["gravitationalAcceleration"] = 0.1,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["combat"] = {
        ["damage"] = 40
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1.6
    },
    ["impactSound"] = { v18.FIREBALL_EXPLODE }
}
u21.harpoon_projectile = {
    ["launchVelocity"] = 160,
    ["gravitationalAcceleration"] = 10,
    ["predictionLifetimeSec"] = 0.463,
    ["lifetimeSec"] = 0.457,
    ["flightRotation"] = Vector3.new(0, 1.5707964, 0),
    ["showIndicatorAtAimingBeamHit"] = true
}
local v40 = {
    ["launchVelocity"] = 1000,
    ["gravitationalAcceleration"] = 100,
    ["lifetimeSec"] = 0.8,
    ["predictionLifetimeSec"] = 1,
    ["firedFromServer"] = true,
    ["bypassShooterLock"] = true,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["projectileModel"] = "ballista_projectile",
    ["combat"] = {
        ["damage"] = 15,
        ["noApplyDamageCooldown"] = true,
        ["ignoreDamageTakenCooldown"] = true
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.5
    },
    ["explosive"] = {
        ["explodeOnImpact"] = true,
        ["explodeOnLifetimeEnd"] = true,
        ["destroyMapBlocks"] = true,
        --["explosionType"] = v8.BALLISTA_PROJECTILE
    }
}
u21.ballista_projectile = v40
local v41 = {
    ["launchVelocity"] = 240,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["projectileModel"] = "life_arrow",
    ["impactParticles"] = "default",
    ["noAmmoValidation"] = true,
    ["arrow"] = true,
    ["combat"] = {
        ["damage"] = 20,
        --["damageType"] = u7.LIFE_ARROW,
        --["armorMultiplier"] = v11.LIFE_BOW_ARMOR_MULTIPLIER
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.95
    },
    ["hitSounds"] = {
        { v18.LIFE_ARROW_HIT_1, v18.LIFE_ARROW_HIT_2 }
    }
}
u21.life_arrow = v41
local v42 = {
    ["launchVelocity"] = 400,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2,
    ["predictionLifetimeSec"] = 1.1,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["projectileModel"] = "life_arrow",
    ["impactParticles"] = "default",
    ["noAmmoValidation"] = true,
    ["arrow"] = true,
    ["combat"] = {
        ["damage"] = 40,
        --["damageType"] = u7.LIFE_ARROW,
        --["armorMultiplier"] = v11.LIFE_CROSSBOW_ARMOR_MULTIPLIER
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1.1
    },
    ["hitSounds"] = {
        { v18.LIFE_ARROW_HIT_1, v18.LIFE_ARROW_HIT_2 }
    }
}
u21.life_crossbow_arrow = v42
local v43 = {
    ["launchVelocity"] = 500,
    ["gravitationalAcceleration"] = 35,
    ["lifetimeSec"] = 2,
    ["predictionLifetimeSec"] = 1.1,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["projectileModel"] = "life_arrow",
    ["arrow"] = true,
    ["combat"] = {
        ["damage"] = 70,
        --["damageType"] = u7.LIFE_ARROW,
        --["armorMultiplier"] = v11.LIFE_HEADHUNTER_ARMOR_MULTIPLIER
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 1.15
    },
    ["hitSounds"] = {
        { v18.LIFE_ARROW_HIT_1, v18.LIFE_ARROW_HIT_2 }
    }
}
u21.life_headhunter_arrow = v43

u21.pit = {
    ["launchVelocity"] = 100,
    ["gravitationalAcceleration"] = 85,
    ["lifetimeSec"] = 3,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(0, 0, 0)
}
u21.spider_web_projectile = {
    ["launchVelocity"] = 400,
    ["gravitationalAcceleration"] = 0,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["impactParticles"] = "default",
    ["combat"] = {
        ["damage"] = 12
    },
    ["knockbackMultiplier"] = {
        ["disabled"] = true
    }
}
u21.spider_web_bridge = {
    ["launchVelocity"] = 800,
    ["gravitationalAcceleration"] = 0,
    ["lifetimeSec"] = 1,
    ["predictionLifetimeSec"] = 1,
    ["firedFromServer"] = true,
    ["bypassShooterLock"] = true,
    ["flightRotation"] = Vector3.new(0, 0, 0),
    ["projectileModel"] = "spider_web_bridge",
    ["impactSound"] = { v18.SPIDER_WEB_BRIDGE_IMPACT }
}
u21.attack_spirit = {
    ["launchVelocity"] = 100,
    ["gravitationalAcceleration"] = 80,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["showIndicatorAtAimingBeamHit"] = true,
    ["customHitIndicator"] = "spirit_summoner",
    ["canHitAllyPlayers"] = true,
    ["projectileModel"] = "attack_spirit",
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0,
        ["vertical"] = 0
    },
}
u21.heal_spirit = {
    ["launchVelocity"] = 100,
    ["gravitationalAcceleration"] = 80,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["showIndicatorAtAimingBeamHit"] = true,
    ["customHitIndicator"] = "spirit_summoner",
    ["canHitAllyPlayers"] = true,
    ["projectileModel"] = "heal_spirit",
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0,
        ["vertical"] = 0
    },
}
u21.watermelon_seed = {
    ["launchVelocity"] = 330,
    ["flightRotation"] = Vector3.new(1.5707964, 0, 0),
    ["gravitationalAcceleration"] = 10,
    ["lifetimeSec"] = 2,
    ["impactParticles"] = "default",
    ["impactSound"] = { v18.BOBA_IMPACT },
    ["combat"] = {
        ["damage"] = 10
    },
    ["knockbackMultiplier"] = {
        ["disabled"] = true
    }
}
u21.water = {
    ["launchVelocity"] = 180,
    ["gravitationalAcceleration"] = 10,
    ["lifetimeSec"] = 2,
    ["impactParticles"] = "splash",
    ["canHitAllyPlayers"] = true,
    ["combat"] = {
        ["damage"] = 4
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.6,
        ["vertical"] = 0.6
    },
    ["impactSound"] = {
        v18.WATER_HIT_1,
        v18.WATER_HIT_2,
        v18.WATER_HIT_3,
        v18.WATER_HIT_4
    }
}
u21.custom_kit_projectile = {
    ["launchVelocity"] = 400,
    ["gravitationalAcceleration"] = 0,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["impactParticles"] = "default",
    ["combat"] = {
        ["damage"] = 1
    },
    ["knockbackMultiplier"] = {
        ["disabled"] = true
    },
}
local v56 = {
    ["launchVelocity"] = 280,
    ["gravitationalAcceleration"] = 0,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["combat"] = {
        ["damage"] = 17,
        ["noApplyDamageCooldown"] = false,
        --["armorMultiplier"] = v10.MIST_DAMAGE_ARMOR_MULTIPLIER,
       -- ["damageType"] = u7.SNOWBALL
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.6
    },
    ["impactSound"] = { v18.SNOWBALL_HIT }
}
u21.frosty_snowball_1 = v56
local v57 = {
    ["launchVelocity"] = 280,
    ["gravitationalAcceleration"] = 0,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["combat"] = {
        ["damage"] = 34,
        ["noApplyDamageCooldown"] = false,
        --["armorMultiplier"] = v10.MIST_DAMAGE_ARMOR_MULTIPLIER,
        --["damageType"] = u7.SNOWBALL
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.8
    },
    ["impactSound"] = { v18.SNOWBALL_HIT }
}
u21.frosty_snowball_2 = v57
local v58 = {
    ["launchVelocity"] = 280,
    ["gravitationalAcceleration"] = 0,
    ["lifetimeSec"] = 2.8,
    ["predictionLifetimeSec"] = 2,
    ["flightRotation"] = Vector3.new(-1.5707964, 0, 0),
    ["combat"] = {
        ["damage"] = 50,
        ["noApplyDamageCooldown"] = false,
        --["armorMultiplier"] = v10.MIST_DAMAGE_ARMOR_MULTIPLIER,
        --["damageType"] = u7.SNOWBALL
    },
    ["knockbackMultiplier"] = {
        ["horizontal"] = 0.8
    },
    ["impactSound"] = { v18.SNOWBALL_HIT }
}
u21.frosty_snowball_3 = v58
return {
    ["ProjectileMeta"] = u21,
    ["ProjectileDamageTypes"] = (function() --[[ Line: 2342 ]]
        --[[
        Upvalues:
            [1] = u21
            [2] = u7
        --]]
        local v59 = {}
        for _, v60 in pairs(u21) do
            local v61 = v60.combat
            if v61 ~= nil then
                v61 = v61.damageType
            end
            if v61 ~= nil then
                v59[v61] = true
            end
        end
        local v62 = {}
        local v63 = #v62
        for v64 in v59 do
            v63 = v63 + 1
            v62[v63] = v64
        end
        v62[v63 + 1] = damageType.PROJECTILE
        return v62
    end)()
}