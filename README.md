# ElectronEmulator
BBC B Emulator for the Acorn Electron

This was used when developing software on the BBC B, and I needed to produce an Electron version, but without the hardware.

There are a couple of versions here, and the main difference is below.  

IN the future I'll try to work out what it is doing and add some more comments.

These values are assumed to be close to Electron speed ..
```
  845   \ ************ SPEED HERE *******
  850   LDY#5
  860   .irloop1 LDX#220
```
and these will be full speed for development purposes.
```
  845   \ ************ SPEED HERE *******
  850   LDY#1
  860   .irloop1 LDX#0
```  
  
