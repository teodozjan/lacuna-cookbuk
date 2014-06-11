lacuna-cookbuk
==============

Script helps [lacunaexpanse.com](https://us1.lacunaexpanse.com/) players doing boring tasks like moving glyphs to one place that can make plans from them or searching where excess fighters can be put. The intention was putting perl6 into life. 

I use parrot backend for building this. 

All planets must have Trade Ministry, Intelligence Ministry and Archaeology Ministry. All space stations must have Parliament.

Compilation:
```
$ panda install JSON::RPC
$ panda install ufo
$ panda install Form 

$ git clone https://github.com/teodozjan/lacuna-cookbuk.git
$ cd lacuna-cookbuk
$ cp lib/LacunaCookbuk/SampleConfig.pm lib/LacunaCookbuk/Config.pm 
$ editor lib/LacunaCookbuk/Config.pm 

$ ufo
$ make install
```

Fun with client:
```
$ perl6 bin/client.pl --taks=all
```

Things that seem to work:
- Caching planets and its buildings
- Finding out what ores are on planets
- Checking whether space port or intelligence ministries are full
- Moving glyphs and plans between planets
- Assembling halls
- Upgrading rules
- Find ineffective ships to replace
- Automatic voting in parliament
 

## TODO
- Specify different upgrade order for different planets
- Autobalance supply chains (send to home planet)
- Autobalance home planet (if all supply chains will become 0 it won't go negative on happiness)
