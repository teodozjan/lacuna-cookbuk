use v6;

use LacunaCookbuk::Logic;
use Form;
use Term::ANSIColor;


class Commander does Logic;
my Str $form = '{<<<<<<<<<<<<<<<<<<} ' ~ colored('{||||||}', 'red') ~ colored('{||||||}', 'magenta') ~ colored('{||||||}', 'green');

method find_incoming {

    print BOLD, form($form, 'Body', 'Hostile', 'Ally', 'Own'), RESET;
    for self.bodybuilder.planets, self.bodybuilder.stations -> Body $body {
	my $status = $body.get_status<body>;	
	next if none($status<num_incoming_enemy>,
		     $status<num_incoming_ally>,
		     $status<num_incoming_own>);

	my $name = $body.name;
	$name = colored($name, 'red') if $status<num_incoming_enemy>;
	print form($form, $body.name,
		   $status<num_incoming_enemy>.subst("0","_"),
		   $status<num_incoming_ally>.subst("0","_"),
		   $status<num_incoming_own>.subst("0","_"));
    }
}

