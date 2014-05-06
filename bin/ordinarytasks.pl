use v6;



use LacunaCookbuk::Config;
use JSON::RPC::Client;

class RpcMaker {
    my %rpcs;
    method new {!!!}
    method aq_client_for($name --> JSON::RPC::Client) {
	unless %rpcs{$name} {
	    #say "Creating client for $name";
	    my $url = 'http://us1.lacunaexpanse.com'~ $name;
	    %rpcs{$name} = JSON::RPC::Client.new( url => $url);
	}

	return %rpcs{$name}
    }
}

class LacunaSession {
    has %.session;
    
    method create_session {
	%.session = RpcMaker.aq_client_for('/empire').login(|%login);
    }

    method close_session(){
	RpcMaker.aq_client_for('/empire').logout(self.session_id);
    }

    method session_id{
	%.session<session_id>;
    }

}

class LacunaBuilding is LacunaSession{
    has $.id;
}

class Archeology is LacunaBuilding {

    method assemble_glyphs(@glyphs, $quantity){
	RpcMaker.aq_client_for('/archeology').assemble_glyphs(self.session_id,$.id,@glyphs, $quantity)
    }
}

class Trade is LacunaBuilding {

    method getGlyphs {
#	my @array =
#	gather 
	my @array;
	for RpcMaker.aq_client_for('/trade').get_glyph_summary(self.session_id, $.id)<glyphs> -> @glyph
	{
	    for @glyph -> %sth { 
		my Hash $hash = %(:type("glyph"), :name(%sth<name>), :quantity(%sth<quantity>));
		@array.push($hash);
		
	    }
	    
	}
	return @array;
    } 

    method getGlyphsHash {
	my %hash;
	for $!traderpc.get_glyph_summary(self.session_id, $.id)<glyphs> -> @glyph
	{
	    for @glyph -> %sth { 
		my %hash{%sth<name>} = %sth<quantity>;
	    }
	    
	}
	return %hash;
    } 
    
    method getResources {
	$!traderpc.get_stored_resources(self.session_id, $.id)<resources>;
    }

    
    method getPlans {
	$!traderpc.get_plan_summary(self.session_id, $.id)<plans>;
    } 

    method getPushShips($targetId) {
	$!traderpc.get_trade_ships(self.session_id, $.id, $targetId)<ships>;

    }

    method pushTo($dst_planet_id, $cargo) {
	$!traderpc.push_items(self.session_id, $.id, $dst_planet_id, $cargo)<ship>
    }
}

class EmpireInfo is LacunaSession {

    has $!body = RpcMaker.aq_client_for('/body');
    has $!empire = RpcMaker.aq_client_for('/empire');

    method getPlanetName($planet_id --> Str){
	%.session<status><empire><planets>{$planet_id};
    }

    method find_home_planet_id{
	$.session<status><empire><home_planet_id>;
    }

    method find_planets{
	$.session<status><empire><planets>;
    }

    method find_archeology_ministry($planet_id --> Archeology){
	my %buildings = $!body.get_buildings(self.session_id, $planet_id)<buildings>;
	for keys %buildings -> $building_id {
	    return Archeology.new(id => $building_id, session => self.session) if %buildings{$building_id}<url> ~~ '/archeology';
	}
	#die("No trade ministry on $planet_id");
    }   

    method find_trade_ministry($planet_id --> Trade){
	my %buildings = $!body.get_buildings(self.session_id, $planet_id)<buildings>;
	for keys %buildings -> $building_id {
	    return Trade.new(id => $building_id, session => self.session) if %buildings{$building_id}<url> ~~ '/trade';
	}
	#die("No trade ministry on $planet_id");
    }   
    
    submethod get_buildings($planet_id --> Array){
	my %buildings = $!body.get_buildings(self.session_id, $planet_id)<buildings>;
	gather for keys  %buildings -> $building {
	    my $rpc = RpcMaker.aq_client_for(%buildings{$building}<url>);
	    my %building =  $rpc.view(self.session_id, $building)<building>;	  
	    take %building;
	}     
    }

    submethod calculateSustainablity($planet_id){
	my %balance;
	my %buildings = $!body.get_buildings(self.session_id, $planet_id)<buildings>;
	my @houses = gather for keys  %buildings -> $building {
	    my $rpc = RpcMaker.aq_client_for(%buildings{$building}<url>);
	    my %building =  $rpc.view(self.session_id, $building)<building>;	  
	    take %building;
	}     
#	my @buildings = get_buildings($planet_id); #rakudo bug causes no ICU loaded error
	for @houses -> %building {
	    for (keys %building).grep(/_hour/) -> $key {
		%balance{$key} += %building{$key};
	    }
	}
	return %balance;
    }  
}

class PlanMaker is LacunaSession {
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

    method makePossibleHalls($planet_id) {
	my Trade $t =	$.f.find_trade_ministry($planet_id);
	my @glyphs = $t->getGlyphsHash();
	
	for(keys %recipes).grep(/Halls of Vrbansk/) -> @recipe {
	    my $count = self!countPlans($recipe, @glyphs);
	    self.createRecipe(@recipe, $count);
	}
    }



    method !countPlans(@planRecipe, %glyphs) {
	my $num = 0;
	for @planRecipe -> $glp {
	    if $num == 0 
	    {
		$num = %glyphs{$glp};
	    }else{
		min($num, %glyphs{$glp});
	    }
	}	
	return $num;
    }

    method createRecipe(@recipe, $quantity) {
	my Archeology arch = $f.find_archeology_ministry($planet_id);
	$arch.assemble_glyphs(@recipe, $quantity)
    }

}

my $f = EmpireInfo.new;
$f.create_session;

my $home_planet_id = $f.find_home_planet_id;
my @planets = keys $f.find_planets;

say "Transporting all glyphs to home planet if possible";
for @planets -> $planet_id {
    next if $planet_id == $home_planet_id;
    my $trade = $f.find_trade_ministry($planet_id);
    if $trade
    {
	#say @($trade.getGlyphs);
	next unless $trade.getPushShips($home_planet_id);
	next unless $trade.getGlyphs;



	say $trade.pushTo($home_planet_id, $trade.getGlyphs);
    }
}

say "Checking balance on home planet";
say $f.calculateSustainablity($home_planet_id);

say "Creating all possible halls";
say PlanMaker.new(f => $f).makePossibleHalls();

$f.close_session;




