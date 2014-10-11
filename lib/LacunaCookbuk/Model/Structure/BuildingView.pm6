use v6;

class BuildingView;

has Str $.level;
has Any $.pending_build;
has Hash $.upgrade;
has $.repair_costs;

submethod damaged {
    say $!repair_costs;
    return any($!repair_costs.values) != 0;
}
