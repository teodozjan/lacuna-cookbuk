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

Usage (examples are in bin directory):
```
$ perl6 your_fancy script.pl
```
