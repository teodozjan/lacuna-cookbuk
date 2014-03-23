use v6;

my $ACITE = "Anthracite";
my $BERYL = "Beryl";
my $CHPYTE = "Chalprophyte";
my $GAL = "Galena";
my $GOLD = "Gold";
my $HALITE = "Halite";
my $KEROGEN = "Kerogen";
my $MATITE = "Magnetite";
my $METAN = "Methane";
my $MOZITE ="Monazite";
my $SULFUR ="Sulfur";
my $TRONA = "Trona";
my $URAN = "Uranite";


my @glyphs= $ACITE, $BERYL, $CHPYTE, $GAL, $GOLD, $HALITE, $KEROGEN, $MATITE, $METAN, $MOZITE, $SULFUR, $TRONA, $URAN;

my %recipes = 
  {

   "Algae Pond" => [$METAN,$URAN],
   "Amalgus Meadow" => [$BERYL, $TRONA],
   "Beeldeban Nest" => [$ACITE, $KEROGEN,$TRONA],
   "Black Hole Generator"=> [$ACITE, $BERYL, $KEROGEN, $MOZITE],
   "Citadel of Knope" => [$BERYL, $GAL, $MOZITE, $SULFUR],
   "Crashed Ship Site" =>["Bauxite", $GOLD, $MOZITE, $TRONA],
   "Denton Brambles" =>["Geothite", "Rutile"],
   "Gas Giant Settlement Platform" => [$ACITE, $GAL, $METAN, $SULFUR],
   "Geo Thermal Vent" => [$CHPYTE, $SULFUR],
   "Gratch's Gauntlet" => ["Bauxite","Fluorite",$GOLD, $KEROGEN],
   "Halls of Vrbansk#1" => ["Geothite","Halite", "Gypsum", "Trona"],
   "Halls of Vrbansk#2" => ["Gold", $ACITE, $URAN, "Bauxite"],
   "Halls of Vrbansk#3" => ["Kerogen", $METAN, $SULFUR, "Zircon"],
   "Halls of Vrbansk#4" => ["Monazite", "Fluorite", $BERYL, "Magnetite"],
   "Halls of Vrbansk#5" => ["Rutile", "Chromite", $CHPYTE, $GAL],
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

for keys %recipes -> $plan {
			    next unless (%recipes{$plan}.elems);
			    say $plan;
			    for @(%recipes{$plan}) -> $glyph{
							  say "\t", $glyph, " missing!" unless(@glyphs.first($glyph));
							 }
			    say "-"xx 40;say;
			   }
  say;

