extends Node2D
# Cog
# Starting Ship - All Rounder, Slow, Decent Cargo, no officers

# Caravel
# Early Game All Rounder - Slow, Increased Cargo, More Officers

# Carrack
# Early Game Cargo Ship - Slow, More Cargo, Higher Officer + Crew Requirements

# Galleon
# Early Mid Game All Rounder - Medium Speed, High Cargo Space, High Officer Count
# High Crew Requirements and Upkeep Costs
# Increased Armaments (1 gun deck?)

# Fluyt
# Dedicated Cargo Ship - Medium Speed, Medium Cargo Space, Middling Officer Count
# Moderate Crew Requirements and Low Upkeep
# Poor or no Armaments

# Clipper
# LATE GAME
# Dedicated Cargo Ship - Fast Speed, High Cargo, Middling Officer Count
# Moderate Crew Requirements and Moderate Upkeep
# Poor or no Armamaments

# Schooner
# Mid - Late Game small all purpose Ship
# Moderate Armamaments - Fast, Low Crew

# Gun Brig / Cutter / Schooner
# unknown number - very common
# Very Small Fast Warship
# 4 - 14 guns
# 20 - 90 Men

# Sloop of war
# 76 vessels
# small fast dedicated warship
# 16 guns
# 90 - 125 men

# Corvette
# 40 vessels
# Dedicated Warship - Medium Speed, Low Cargo, Middling Officer Count
# Moderate Crew Requirements, Moderate Upkeep
# 24 guns
# 100 - 150 men

# Frigate
# Dedicated Warship - Medium Speed, Some Cargo, Middling Officer Count
# Medium Crew Requirements, Medium Upkeep
# 100 Vessels
# Upgraded Warship with 2 gun Decks
# 44 guns
# 2 - 300 men

# Ship Of the Line
# 
# Endgame Warship - Medium Speed, Medium Cargo, High Officer Count
# Highest Crew Requirements, Highest Upkeep, Highest Armament
# Different Ratings with Different Gun Counts

# 1st Rate - 3 Gun Decks - 100+ - 800-875 men
# 2nd Rate - 3 Gun Decks - 80-98 - 700-800 men
# 3rd Rate - 2 Gun Decks - 64-80 - 500 - 650 men
# 4th Rate - 2 Gun Decks - 50-60 - 300 - 500 men



var all_hulls = [
	"galleon",
	"cog"
]
var speed = {
	"galleon": 100,
	"cog": 75
}
var cargo_cap = {
	"galleon": 500,
	"cog": 50}
