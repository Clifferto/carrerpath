Version 4
SymbolType CELL
LINE Normal -32 -32 32 0
LINE Normal -32 32 32 0
LINE Normal -32 -32 -32 32
LINE Normal -28 -16 -20 -16
LINE Normal -28 16 -20 16
LINE Normal -24 20 -24 12
LINE Normal 0 -32 0 -16
LINE Normal 0 32 0 16
LINE Normal 4 -20 12 -20
LINE Normal 8 -24 8 -16
LINE Normal 4 20 12 20
WINDOW 0 16 -32 Left 2
SYMATTR Prefix X
SYMATTR Description VUopamp is a parametric opamp model derived from LTspice's UniversalOpamp2 but with fixes so differential input resistance works as expected and includes input bias current/offset and DC supply current.
SYMATTR Value vuopamp
SYMATTR Value2 Avol=1Meg Rid=1G Vos=0 Ib=0 Ios=0 GBW=10Meg phimargin=45
SYMATTR SpiceLine Slew=10Meg rail=0 ilimit=25m Isupply=0
SYMATTR SpiceLine2 en=0 enk=0 in=0 ink=0 incm=0 incmk=0
SYMATTR ModelFile vuece.lib
PIN -32 16 NONE 0
PINATTR PinName In+
PINATTR SpiceOrder 1
PIN -32 -16 NONE 0
PINATTR PinName In-
PINATTR SpiceOrder 2
PIN 0 -32 NONE 0
PINATTR PinName V+
PINATTR SpiceOrder 3
PIN 0 32 NONE 0
PINATTR PinName V-
PINATTR SpiceOrder 4
PIN 32 0 NONE 0
PINATTR PinName OUT
PINATTR SpiceOrder 5
