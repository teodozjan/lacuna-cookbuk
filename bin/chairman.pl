use v6;
use LacunaCookbuk::Model::LacunaSession;
use LacunaCookbuk::Logic::BodyBuilder;
use LacunaCookbuk::Logic::Chairman;

#session info is static for all classes
my LacunaSession $f = LacunaSession.new;
$f.create_session;

my BodyBuilder $b = BodyBuilder.from_file('./var/bodybuilder.pl');

my $c = Chairman.new(bodybuilder => $b, build_order=>Chairman.glyph_mule_order);
$c.check_space_ports;
$c.all;



$f.close_session;
