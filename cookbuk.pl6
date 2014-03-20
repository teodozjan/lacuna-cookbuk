use v6;

my $ACITE = "Anthracite";
my $CHPYTE = "Chalprophyte";
my $GOLD = "Gold";
my $HALITE = "Halite";
my $KEROGEN = "Kerogen";
my $MATITE = "Magnetite";
my $METAN = "Methane";
my $MOZITE ="Monazite";
my $SULFUR ="Sulfur";
my $TRONA = "Trona";


my @glyphs= $ACITE, $CHPYTE, $GOLD, $HALITE, $KEROGEN, $MATITE, $METAN, $MOZITE, $SULFUR, $TRONA;

my %recipes = 
  {

   "Algae Pond" => [$METAN,"Uranite"],
   "Amalgus Meadow" => ["Beryl", $TRONA],
   "Beeldeban Nest" => [$ACITE, $KEROGEN,$TRONA],
   "Black Hole Generator"=> [$ACITE, "Beryl", $KEROGEN, $MOZITE],
   "Citadel of Knope" => ["Beryl", "Galena", $MOZITE, $SULFUR],
   "Crashed Ship Site" =>["Bauxite", $GOLD, $MOZITE, $TRONA],
   "Denton Brambles" =>["Geothite", "Rutile"],
   "Gas Giant Settlement Platform" => [$ACITE, "Galena", $METAN, $SULFUR],
   "Geo Thermal Vent" => [$CHPYTE, $SULFUR],
   "Gratch's Gauntlet" => ["Bauxite","Fluorite",$GOLD, $KEROGEN],
   "Halls of Vrbansk#1" => [],
   "Halls of Vrbansk#2" => [],
   "Halls of Vrbansk#3" => [],
   "Halls of Vrbansk#4" => [],
   "Interdimensional Rift" => [],
   "Kalavian Ruins" => [],
   "Lapis Forest" => [],
   "Library of Jith" => [],
   "Malcud Field" => [],
   "Natural Spring" => [],
   "Oracle of Anid" => [],
   "Pantheon of Hagness" => [],
   "Ravine" => [],
   "Temple of the Drajilites" => [],
   "Terraforming Platform" => [],
   "Volcano" => [] 
  };

say @glyphs.elems;

for keys %recipes -> $plan {
			    next unless (%recipes{$plan}.elems);
			    say $plan;
			    for @(%recipes{$plan}) -> $glyph{
							  say "\t", $glyph, " missing!" unless(@glyphs.first($glyph));
							 }
			    say "-"xx 40;say;
			   }
  say;

