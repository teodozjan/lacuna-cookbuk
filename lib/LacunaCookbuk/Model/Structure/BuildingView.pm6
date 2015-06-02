use v6;

unit class LacunaCookbuk::Model::Structure::BuildingView;

has Str $.level;
has Any $.pending_build;
has Hash $.upgrade;
has $.repair_costs;

submethod damaged {
    return any($!repair_costs.values) != 0;
}
