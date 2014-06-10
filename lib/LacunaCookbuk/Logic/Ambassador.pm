use v6;

use LacunaCookbuk::Logic;
use LacunaCookbuk::Model::Body::SpaceStation;
use LacunaCookbuk::Model::Building::Parliament;

class Ambassador does Logic;


submethod delete_messages {



}

submethod vote_all(Bool $vote) {
    for self.bodybuilder.stations -> SpaceStation $station {
	my Parliament $par = $station.find_parliament;
	next unless $par;
	my @prop = $par.view_propositions;
	for @prop -> @weirdo {
	for @weirdo -> $to_vote {
	    next unless $to_vote;
	    say $to_vote.perl;
	    my $number = $vote ?? "1" !! "0";
	    $par.cast_vote($to_vote<id>, $number) unless $to_vote<my_vote>;
	}
	}
    }
}

