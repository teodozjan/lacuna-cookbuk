
### NAME LacunaCookbuk

LacunaCookbuk was intended to be something similar to cookbook for creating glyphs. But real life changed it to client with library that has only one implementing client. 

### SYNOPSIS

Fun with client:

    $ lacunacookbuk_client --update --tasks=defend
    # will die but will also prefill settings
    $ nano .lacuna_cookbuk/login.pl
    $ lacunacookbuk_client --tasks=defend,ordinary,chairman --update

Writting own:
         [Link documentation] (../master/lib/LacunaCookbuk/Client.pm6)
         
### DESCRIPTION    
    
[![Build Status](https://travis-ci.org/teodozjan/lacuna-cookbuk.svg?branch=v3.1.2)](https://travis-ci.org/teodozjan/lacuna-cookbuk) Don't worry it is usable but SPESH has little bug that prevents it from working

Script helps https://us1.lacunaexpanse.com players doing boring tasks like moving glyphs to one place that can make plans from them or searching where excess fighters can be put. The intention was putting perl6 into life. 

Instalation:

    $ panda install LacunaCookbuk

More about panda [here](https://github.com/tadzik/panda)

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
	- Rename agents to their home planet name
	- Printing what plans can be made from current stock
	- Showing where are the colonies (primitive text)
	- Automatic repair (the evil implementation)
	- Inbox cleaning
