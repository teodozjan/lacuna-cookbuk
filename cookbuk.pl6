use v6;

constant $ANTHRACITE = "Anthracite";
constant $BAUXITE = "Bauxite";
constant $BERYL = "Beryl";
constant $CHALPROPHYTE = "Chalprophyte";
constant $CHROMITE = "Chromite";
constant $FLUORITE = "Fluorite";
constant $GALENA = "Galena";
constant $GEOTHITE = "Geothite";
constant $GOLD = "Gold";
constant $GYPSUM = "Gypsum";
constant $HALITE = "Halite";
constant $KEROGEN = "Kerogen";
constant $MAGNETITE = "Magnetite";
constant $METHANE = "Methane";
constant $MONAZITE = "Monazite";
constant $RUTILE = "Rutile";
constant $SULFUR ="Sulfur";
constant $TRONA = "Trona";
constant $URANITE = "Uranite";
constant $ZIRCON = "Zircon";


constant @glyphs= $ANTHRACITE, $BERYL, $CHALPROPHYTE, $GALENA, $GOLD, $HALITE, $KEROGEN, $MAGNETITE, $METHANE, $MONAZITE, $SULFUR, $TRONA, $URANITE;

constant %recipes = 
  {

   "Algae Pond" => [$METHANE,$URANITE],
   "Amalgus Meadow" => [$BERYL, $TRONA],
   "Beeldeban Nest" => [$ANTHRACITE, $KEROGEN,$TRONA],
   "Black Hole Generator"=> [$ANTHRACITE, $BERYL, $KEROGEN, $MONAZITE],
   "Citadel of Knope" => [$BERYL, $GALENA, $MONAZITE, $SULFUR],
   "Crashed Ship Site" =>[$BAUXITE, $GOLD, $MONAZITE, $TRONA],
   "Denton Brambles" =>[$GEOTHITE, $RUTILE],
   "Gas Giant Settlement Platform" => [$ANTHRACITE, $GALENA, $METHANE, $SULFUR],
   "Geo Thermal Vent" => [$CHALPROPHYTE, $SULFUR],
   "Gratch's Gauntlet" => [$BAUXITE,$FLUORITE,$GOLD, $KEROGEN],
   "Halls of Vrbansk#1" => [$GEOTHITE,$HALITE, $GYPSUM, $TRONA],
   "Halls of Vrbansk#2" => [$GOLD, $ANTHRACITE, $URANITE, $BAUXITE],
   "Halls of Vrbansk#3" => [$KEROGEN, $METHANE, $SULFUR, $ZIRCON],
   "Halls of Vrbansk#4" => [$MONAZITE, $FLUORITE, $BERYL, $MAGNETITE],
   "Halls of Vrbansk#5" => [$RUTILE, $CHROMITE, $CHALPROPHYTE, $GALENA],
   "Interdimensional Rift" => [$GALENA, $METHANE, $ZIRCON],
   "Kalavian Ruins" => [],
   "Lapis Forest" => [],
   "Library of Jith" => [$ANTHRACITE, $BAUXITE, $BERYL, $CHALPROPHYTE],
   "Malcud Field" => [],
   "Natural Spring" => [],
   "Oracle of Anid" => [],
   "Pantheon of Hagness" => [],
   "Ravine" => [],
   "Temple of the Drajilites" => [],
   "Terraforming Platform" => [],
   "Volcano" => [] 
  };

for keys %recipes -> $plan {
			    next unless (%recipes{$plan}.elems);
			    say $plan;
			    for @(%recipes{$plan}) -> $glyph{
							  say "\t", $glyph, " missing!" unless(@glyphs.first($glyph));
							 }
			    say "-"xx 40;say;
			   }
  say;

