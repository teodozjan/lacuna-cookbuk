use v6;

use LacunaCookbuk::Model::LacunaSession;

class Ship is LacunaSession;
has %.attr;

multi method gist {
#if $attr<task> Travelling
    %.attr<type_human> ~ ": " ~ %.attr<from><name> ~ " -> [" ~ %.attr<to><name> ~ %.attr<payload> ~ "]   ETA" ~ %.attr<date_arrives>; 

}


