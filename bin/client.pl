use v6;

use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Logic::BodyBuilder;
use LacunaCookbuk::Logic::PlanMaker;
use LacunaCookbuk::Logic::Transporter;
use LacunaCookbuk::Logic::Chairman;
use LacunaCookbuk::Logic::BodyCritic;

class Client {
    has BodyBuilder $!cache;
    has LacunaSession $!session;

    submethod cache {
#todo review
	$!cache = BodyBuilder.new(session =>$!session);
	$!cache.process_all_bodies($!session.planets_hash);
	$!cache.to_file('./var/bodybuilder.pl');
    }

    submethod elaborate {
	$!cache= BodyBuilder.from_file('./var/bodybuilder.pl') unless $!cache;
	BodyCritic.new(bodybuilder => $!cache).elaborate;
    }

    submethod ordinary {
	$!cache= BodyBuilder.from_file('./var/bodybuilder.pl') unless $!cache;
	say "Creating all possible halls";
	PlanMaker.new(bodybuilder => $!cache).makePossibleHalls;
	
	say "Transporting all glyphs to home planet if possible";
	Transporter.new(bodybuilder => $!cache).transport_all_cargo;
    }

    submethod chairman {
	$!cache= BodyBuilder.from_file('./var/bodybuilder.pl') unless $!cache;
	
	my $c = Chairman.new(bodybuilder => $!cache, build_order=>Chairman.glyph_mule_order);
	$c.check_space_ports;
	$c.all;


    }

}


my @todo;

if @*ARGS.grep('all') {
    @todo := <cache elaborate ordinary chairman>
} else {
    @todo := @*ARGS
}

my LacunaSession $f = LacunaSession.new;
$f.create_session;
my Client $client .= new(session => $f);

for @todo -> $willdo {
    $client."$willdo"();
}

$f.close_session;





