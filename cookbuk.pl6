use v6;

constant $ANTHRACITE = "Anthracite";
constant $BAUXITE = "Bauxite";
constant $BERYL = "Beryl";
constant $CHALPROPHYTE = "Chalprophyte";
constant $GALENA = "Galena";
constant $GOLD = "Gold";
constant $HALITE = "Halite";
constant $KEROGEN = "Kerogen";
constant $MAGNETITE = "Magnetite";
constant $METHANE = "Methane";
constant $MONAZITE ="Monazite";
constant $SULFUR ="Sulfur";
constant $TRONA = "Trona";
constant $URANITE = "Uranite";


constant @glyphs= $ANTHRACITE, $BERYL, $CHALPROPHYTE, $GALENA, $GOLD, $HALITE, $KEROGEN, $MAGNETITE, $METHANE, $MONAZITE, $SULFUR, $TRONA, $URANITE;

constant %recipes = 
  {

   "Algae Pond" => [$METHANE,$URANITE],
   "Amalgus Meadow" => [$BERYL, $TRONA],
   "Beeldeban Nest" => [$ANTHRACITE, $KEROGEN,$TRONA],
   "Black Hole Generator"=> [$ANTHRACITE, $BERYL, $KEROGEN, $MONAZITE],
   "Citadel of Knope" => [$BERYL, $GALENA, $MONAZITE, $SULFUR],
   "Crashed Ship Site" =>["Bauxite", $GOLD, $MONAZITE, $TRONA],
   "Denton Brambles" =>["Geothite", "Rutile"],
   "Gas Giant Settlement Platform" => [$ANTHRACITE, $GALENA, $METHANE, $SULFUR],
   "Geo Thermal Vent" => [$CHALPROPHYTE, $SULFUR],
   "Gratch's Gauntlet" => ["Bauxite","Fluorite",$GOLD, $KEROGEN],
   "Halls of Vrbansk#1" => ["Geothite","Halite", "Gypsum", "Trona"],
   "Halls of Vrbansk#2" => ["Gold", $ANTHRACITE, $URANITE, "Bauxite"],
   "Halls of Vrbansk#3" => ["Kerogen", $METHANE, $SULFUR, "Zircon"],
   "Halls of Vrbansk#4" => ["Monazite", "Fluorite", $BERYL, "Magnetite"],
   "Halls of Vrbansk#5" => ["Rutile", "Chromite", $CHALPROPHYTE, $GALENA],
   "Interdimensional Rift" => ["Galena", "Methane", "Zircon"],
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

