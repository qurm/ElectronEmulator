    5 REM ELECTRON EMULATOR
    6 REM September 1984
    7 REM A.E.Frigaard (c) 1984
   10 HIMEM =&5000
   20 PROCI
   30 FORZ=0TO2 STEP2
   40   P%=&940
   50   [OPTZ
   60   
   70   .vdu EQUB0
   80   .vdu22 EQUB0
   90   .wrch
  100   PHA:LDAvdu:BNEvduq
  110   \already a queue ?
  120   PLA:PHA
  130   
  140   CMP#31:BPLendwrch:BNEwr2
  150   LDA#2:JMPwr22
  160   .wr2 CMP#29:BNEwr4
  170   LDA#4:JMPwr22
  180   .wr4 CMP#28:BNEwr6
  190   LDA#4:JMPwr22
  200   .wr6 CMP#25:BNEwr8
  210   LDA#5:JMPwr22
  220   .wr8 CMP#24:BNEwr10
  230   LDA#8:JMPwr22
  240   .wr10 CMP#23:BNEwr11
  250   LDA#9:JMPwr22
  260   
  270   .wr11 CMP#22:BNEwr12
  280   LDA#1:STAvdu22:JMPwr22
  290   
  300   .wr12 CMP#19:BNEwr16
  310   LDA#5:JMPwr22
  320   .wr16 CMP#18:BNEwr18
  330   LDA#2:JMPwr22
  340   .wr18 CMP#17:BNEwr20
  350   LDA#1:JMPwr22
  360   .wr20 CMP#1:BNEendwrch
  370   .wr22 STAvdu
  380   
  390   JMPendwrch
  400   
  410   .vduq LDAvdu22
  420   BEQnotmode
  430   
  440   PLA:AND#7:CMP#7:BNEnotm7
  450   LDA#6
  460   .notm7 PHA
  470   
  480   .notmode DECvdu \still queue
  490   BNEendwrch:LDA#0:STAvdu22
  500   .endwrch PLA:JMP(oldwrch)
  510   .oldwrch EQUW &E0A4
  520   
  530   
  540   .word STXwzp:STYwzp+1:PHA
  550   
  560   CMP#7:BNEword1 \sound?
  570   LDY#0:LDA(wzp),Y
  580   AND#15:BEQso1 \noise
  590   LDA(wzp),Y:AND#&F0
  600   ORA#1:STA(wzp),Y \set to ch.0
  610   .so1 INY:LDA#0:STA(wzp),Y
  620   INY:LDA(wzp),Y:BPLso3
  630   LDA#&F1:STA(wzp),Y
  640   .so3 JMPword2
  650   
  660   .word1 CMP#8:BNEword2 \envelope?
  670   
  680   \ subsitute in the para block
  690   
  700   LDY#8:LDA#126:STA(wzp),Y
  710   INY:LDA#0:STA(wzp),Y
  720   INY:STA(wzp),Y
  730   INY:LDA#&82:STA(wzp),Y
  740   INY:LDA#126:STA(wzp),Y
  750   INY:STA(wzp),Y
  760   
  770   .word2 PLA:LDXwzp:LDYwzp+1:JMP(oldword)
  780   .oldword EQUW &E7EB
  790   
  800   .irq1
  810   LDA&FC:PHA
  820   TYA:PHA
  830   TXA:PHA  \ensure re-entrant o.k.
  840   
  841   
  842   
  845   \ ************ SPEED HERE *******
  850   LDY#1
  860   .irloop1 LDX#0
  870   .irloop2 DEX
  880   BNE irloop2
  890   DEY
  900   BNE irloop1
  901   
  905   .irexit
  920   PLA:TAX
  930   PLA:TAY
  940   PLA:STA&FC \restore old values
  950   
  960   JMP(oldirq1)
  970   
  980   .oldirq1 EQUW&DC93
  990   
 1000   
 1010   .userv
 1020   STXzp:STYzp+1:CMP#1:BNE badcom
 1030   \A=1 *line
 1040   LDY#0:LDA(zp),Y:CMP #ASC("1"):BNEoff
 1050   .on LDA#ASC("E"):JSRWRCH
 1060   
 1070   \redirect vects
 1080   SEI
 1090   LDA#wrch MOD256:STAWRCHV
 1100   LDA#wrch DIV256:STAWRCHV+1
 1110   
 1120   LDA#word MOD256:STAWORDV
 1130   LDA#word DIV256:STAWORDV+1
 1140   
 1150   LDA#irq1 MOD256:STA IRQ1V
 1160   LDA#irq1 DIV256:STA IRQ1V+1
 1170   
 1180   CLI
 1190   RTS
 1200   
 1210   .off CMP#ASC("0"):BNEbadcom
 1220   LDA#ASC("B"):JSRWRCH
 1230   
 1240   \ restore old vects
 1250   SEI
 1260   LDAoldwrch:STAWRCHV
 1270   LDAoldwrch+1:STAWRCHV+1
 1280   
 1290   LDAoldword:STAWORDV
 1300   LDAoldword+1:STAWORDV+1
 1310   
 1320   LDAoldirq1 :STA IRQ1V
 1330   LDAoldirq1+1 :STA IRQ1V+1
 1340   
 1350   CLI
 1360   RTS
 1370   
 1380   
 1390   .badcom JMP(olduserv)
 1400   .olduserv EQUW0
 1410   
 1411   ]:PRINT~P%,;
 1412   [OPTZ
 1420   .Q%
 1430   .elec
 1440   \restore OS vects
 1450   LDA&FFB7:STAtab:LDA&FFB8:STAtab+1
 1460   LDY#0:LDA(tab),Y:STA&200,Y:INY
 1470   LDA(tab),Y:STA&200,Y
 1480   \save userv
 1490   LDA USERV:STA olduserv
 1500   LDA USERV+1:STA olduserv+1
 1510   \redirect userv
 1520   LDA#userv MOD256:STA USERV
 1530   LDA# (userv+1)DIV256:STA USERV+1
 1540   RTS \elec
 1550   ]
 1560 NEXT:VDU11:PRINT~P%:END
 1570 
 1580 DEFPROCI
 1590 REM uses Econent w'space &90...
 1600 
 1610 IRQ1V=&204
 1620 
 1630 WORD=&FFF1
 1640 WORDV=&20C
 1650 
 1660 BYTE=&FFF4
 1670 BYTEV=&20A
 1680 
 1690 WRCH=&FFEE
 1700 WRCHV=&20E
 1710 
 1720 USERV=&200
 1730 zp=&90
 1740 tab=&92
 1750 wzp=&94
 1760 ENDPROC
 1790 RUN TO ASSEMBLE
 1800 CALL Q% : resets vectors set *line
 1810 *line 1 or 0 : on or off
 1840 Turn off before re-assembling!!!
