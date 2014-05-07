use v6;

use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Model::Planet;

class PlanMaker is LacunaSession;

constant $ANTHRACITE = "anthracite";
constant $BAUXITE = "bauxite";
constant $BERYL = "beryl";
constant $CHALPROPHYTE = "chalprophyte";
constant $CHROMITE = "chromite";
constant $FLUORITE = "fluorite";
constant $GALENA = "galena";
constant $GOETHITE = "goethite";
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
    "Algae Pond" => @($METHANE,$URANITE),
    "Amalgus Meadow" => @($BERYL, $TRONA),
    "Beeldeban Nest" => @($ANTHRACITE, $KEROGEN,$TRONA),
    "Black Hole Generator"=> @($ANTHRACITE, $BERYL, $KEROGEN, $MONAZITE),
    "Citadel of Knope" => @($BERYL, $GALENA, $MONAZITE, $SULFUR),
    "Crashed Ship Site" =>@($BAUXITE, $GOLD, $MONAZITE, $TRONA),
    "Denton Brambles" =>@($GOETHITE, $RUTILE),
    "Gas Giant Settlement Platform" => @($ANTHRACITE, $GALENA, $METHANE, $SULFUR),
    "Geo Thermal Vent" => @($CHALPROPHYTE, $SULFUR),
    "Gratch's Gauntlet" => @($BAUXITE,$FLUORITE,$GOLD, $KEROGEN),
    "Halls of Vrbansk#1" => @($GOETHITE,$HALITE, $GYPSUM, $TRONA),
    "Halls of Vrbansk#2" => @($GOLD, $ANTHRACITE, $URANITE, $BAUXITE),
    "Halls of Vrbansk#3" => @($KEROGEN, $METHANE, $SULFUR, $ZIRCON),
    "Halls of Vrbansk#4" => @($MONAZITE, $FLUORITE, $BERYL, $MAGNETITE),
    "Halls of Vrbansk#5" => @($RUTILE, $CHROMITE, $CHALPROPHYTE, $GALENA),
    "Interdimensional Rift" => @($GALENA, $METHANE, $ZIRCON),
    "Kalavian Ruins" => @($GALENA, $GOLD),
    "Lapis Forest" => @($HALITE, $ANTHRACITE),
    "Library of Jith" => @($ANTHRACITE, $BAUXITE, $BERYL, $CHALPROPHYTE),
    "Malcud Field" => @($FLUORITE, $KEROGEN),
    "Natural Spring" => @($MAGNETITE, $HALITE),
    "Oracle of Anid" => @($GOLD, $URANITE, $BAUXITE, $GOETHITE),
    "Pantheon of Hagness" => @($GYPSUM, $TRONA, $BERYL, $ANTHRACITE),
    "Ravine" => @($ZIRCON, $METHANE, $GALENA, $FLUORITE),
    "Temple of the Drajilites" => @($KEROGEN, $RUTILE, $CHROMITE, $CHALPROPHYTE),
    "Terraforming Platform" => @($METHANE, $ZIRCON, $MAGNETITE, $BERYL),
    "Volcano" => @($MAGNETITE, $URANITE)
};

has Planet $home_planet = Planet.new(id => self.home_planet_id);

#TODO use achaeology instead of trade
method makePossibleHalls {
    my Trade $t = $home_planet.find_trade_ministry;
    my %glyphs = $t.get_glyphs_hash();
   
    for @(keys %recipes).grep(/Halls/) -> $recipename {
	say $recipename;
	my $count = self!countPlans(%recipes{$recipename}, %glyphs);
	say $count;
	self.createRecipe(%recipes{$recipename}, $count, $home_planet.id) if $count > 0 ;
    }
}



method !countPlans(@planRecipe, %glyphs) {
    my Int $num = 0;
    
    for @planRecipe -> $glp {	
	if !%glyphs{$glp} {
	    return 0;
	}
	elsif $num == 0 
	{
	    $num = %glyphs{$glp};
	}
	else
	{
	    $num = min($num, %glyphs{$glp});
	}
    }	
    return $num;
}

method createRecipe(@recipe, Int $quantity, $planet_id) {
    return if $quantity == 0;
    
    $home_planet.find_archaeology_ministry($planet_id).assemble_glyphs(@recipe, $quantity)
}

