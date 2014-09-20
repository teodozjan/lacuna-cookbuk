use v6;

use LacunaCookbuk::Model::Body::Planet;
use LacunaCookbuk::Logic::BodyBuilder;
use LacunaCookbuk::Model::Empire;
use LacunaCookbuk::Logic::Transporter::Cargo;

class LacunaCookbuk::Logic::Transporter;

submethod transport(@goods,Planet $src, Planet $dst = home_planet)
{
  	my @cargo;
	my $trade = $src.find_trade_ministry;
	return unless $trade;
	for @goods -> $load {
	    @cargo.push($load.gather($trade))
	}
	my $ship = $trade.find_fastest_ship;
	return unless $ship;

	my @packed = self.cut_size(@cargo, +$ship<hold_size>);
	say $trade.push(@packed) if @packed;   
}

submethod transport_all_cargo(Planet $dst = home_planet) {
    my @goods = (Glyphs, Plans);
    my @planets = planets;
    for @planets -> Planet $planet {
	#note $planet.name;	
	next if $planet.is_home;
	self.transport(@goods, $planet, $dst);
    }

}


method cut_size(@cargo, Int $limit --> Array){
    my Int $space = 0;
    
    my @newCargo;
    for @cargo -> $load {
	my $size = self.container_size($load<type>);
	$space += $size * $load<quantity>;
	
	return @newCargo if $space >= $limit;
	@newCargo.push($load);
    }
    return @newCargo;

}

my %csizes = %("glyph" => 100, "plan" => 10000);
submethod container_size(Str $type --> Int){
    %csizes{$type};
}
