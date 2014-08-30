
### NAME LacunaCookbuk

LacunaCookbuk was intended to be something similar to cookbook for creating glyphs. But real life changed it to client with library that has only one implementing client. 

### SYNOPSIS

Script helps https://us1.lacunaexpanse.com players doing boring tasks like moving glyphs to one place that can make plans from them or searching where excess fighters can be put. The intention was putting perl6 into life. 

I use parrot backend for building this. 

All planets must have Trade Ministry, Intelligence Ministry and Archaeology Ministry. All space stations must have Parliament.

Compilation:

	$ panda install LacunaCookbuk

Fun with client:

    $ lacunacookbuk_client --taks=all
    # will die but will also prefill settings
    $ nano .lacuna_cookbuk/login.pl
    $ lacunacookbuk_client --taks=all --update

You can also try to use it without compiling

    $  PERL6LIB=/your/path/lacuna-cookbuk/lib: perl6 /your/path/lacuna-cookbuk/bin/lacunacookbuk_client --help
    
Precompiling is the most changin part of perl6 backends so it may be used as failsafe mode

    
Things that seem to work:

	- Caching planets and its buildings
	- Finding out what ores are on planets
	- Checking whether space port or intelligence ministries are full
	- Moving glyphs and plans between planets
	- Assembling halls
	- Upgrading rules
	- Find ineffective ships to replace
	- Automatic voting in parliament
	- List incoming ships
	- Delete Parliament messages automatically 

### TODO Functions

       - Automatic repair
       - Space port plans
       - Automatic trade posting
       - Specify different upgrade order for different planets
       - Autobalance supply chains (send to home planet)
       - Autobalance home planet (if all supply chains will become 0 it won't go negative on happiness)

### TODO Code smell

       - Change some classes into modules
       - Tidy	 - planet/station mess
       - Change loops to list generic functions where possible

