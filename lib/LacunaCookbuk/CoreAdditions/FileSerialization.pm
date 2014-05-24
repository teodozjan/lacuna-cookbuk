use v6;

role FileSerialization;

method serialize returns Str {
    self.perl
}

method deserialize(Str $sth){
    EVAL $sth
}

method to_file($path) {
    given open($path, :w) {
	.say(self.serialize);
	.close
   }
}

method from_file($path) {
     self.deserialize(slurp $path)
}
