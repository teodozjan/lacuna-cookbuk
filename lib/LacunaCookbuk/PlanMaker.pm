use v6;

use LacunaCookbuk::LacunaSession;
use LacunaCookbuk::RPCMaker;
use LacunaCookbuk::EmpireInfo;

use LacunaBuilding::Trade;
use LacunaBuilding::Archeology;

class PlanMaker is LacunaSession;
has EmpireInfo $.f;

constant $ANTHRACITE = "anthracite";
constant $BAUXITE = "bauxite";
constant $BERYL = "beryl";
constant $CHALPROPHYTE = "chalprophyte";
constant $CHROMITE = "chromite";
constant $FLUORITE = "fluorite";
constant $GALENA = "galena";
constant $GEOTHITE = "geothite";
constant $GOLD = "gold";
constant $GYPSUM = "gypsum";
constant $HALITE = "halite";
constant $KEROGEN = "kerogen";
constant $MAGNETITE = "magnetite";
constant $METHANE = "methane";
constant $MONAZITE = "monazite";
constant $RUTILE = "rutile";
constant $SULFUR ="sulfur";
constant $TRONA = "trona";
constant $URANITE = "uranite";
constant $ZIRCON = "zircon";

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
    "Kalavian Ruins" => [$GALENA, $GOLD],
    "Lapis Forest" => [$HALITE, $ANTHRACITE],
    "Library of Jith" => [$ANTHRACITE, $BAUXITE, $BERYL, $CHALPROPHYTE],
    "Malcud Field" => [$FLUORITE, $KEROGEN],
    "Natural Spring" => [$MAGNETITE, $HALITE],
    "Oracle of Anid" => [$GOLD, $URANITE, $BAUXITE, $GEOTHITE],
    "Pantheon of Hagness" => [$GYPSUM, $TRONA, $BERYL, $ANTHRACITE],
    "Ravine" => [$ZIRCON, $METHANE, $GALENA, $FLUORITE],
    "Temple of the Drajilites" => [$KEROGEN, $RUTILE, $CHROMITE, $CHALPROPHYTE],
    "Terraforming Platform" => [$METHANE, $ZIRCON, $MAGNETITE, $BERYL],
    "Volcano" => [$MAGNETITE, $URANITE]
};


method makePossibleHalls($planet_id) {
    my Trade $t = self.f.find_trade_ministry($planet_id);
    my %glyphs = $t.getGlyphsHash();
   
    for @(keys %recipes).grep(/Halls/) -> $recipename {
	my $count = self!countPlans(%recipes{$recipename}, %glyphs);
	say $count;
	self.createRecipe(%recipes{$recipename}, $count, $planet_id) if $count > 0 ;
    }
}



method !countPlans(@planRecipe, %glyphs) {
    my $num = 0;
    for @planRecipe -> $glp {
	if $num == 0 
	{
	    $num = %glyphs{$glp};
	}
	else
	{
	    min($num, %glyphs{$glp});
	}
    }	
    return $num;
}

method createRecipe(@recipe, $quantity, $planet_id) {
    my Archeology $arch = EmpireInfo.new(session => self.session).find_archeology_ministry($planet_id);
    $arch.assemble_glyphs(@recipe, $quantity)
}

