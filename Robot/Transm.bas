'NRF24L01 basic driver module
sub NRF.init
  NRF_CONFIG_RG=0
  NRF_ENAA_RG=1
  NRF_ENRXADDR_RG=2
  NRF_SETUPAW_RG=3
  NRF_SETUPRETR_RG=4
  NRF_RFCH_RG=5
  NRF_RFSETUP_RG=6
  NRF_STATUS_RG=7
  NRF_OBSERVETX_RG=8
  NRF_CD_RG=9
  NRF_RXADDRP0_RG=10
  NRF_RXADDRP1_RG=11
  NRF_RXADDRP2_RG=12
  NRF_RXADDRP3_RG=13
  NRF_RXADDRP4_RG=14
  NRF_RXADDRP5_RG=15
  NRF_TXADDR_RG=16
  NRF_RXPWP0_RG=17
  NRF_RXPWP1_RG=18
  NRF_RXPWP2_RG=19
  NRF_RXPWP3_RG=20
  NRF_RXPWP4_RG=21
  NRF_RXPWP5_RG=22
  NRF_FIFOSTATUS_RG=23
  NRF_MISO=11
  NRF_MOSI=12
  NRF_CLK=13
  NRF_CS=14
  NRF_CE=10
  NRF_IRQ=9
  NRF_ADDRESS_WIDTH=5
  NRF_PAYLOAD_WIDTH=4
  dim NRF_ADDRESS(NRF_ADDRESS_WIDTH)
  dim NRF.RX(NRF_PAYLOAD_WIDTH)
  dim NRF.TX(NRF_PAYLOAD_WIDTH)
  setpin NRF_MISO,2
  setpin NRF_MOSI,8
  pin(NRF_CLK)=0:setpin NRF_CLK,8
  pin(NRF_CS)=1:setpin NRF_CS,8
  pin(NRF_CE)=0:setpin NRF_CE,8
end sub

sub NRF.setTXaddr
  pin(NRF_CS)=0
  junk=spi(NRF_MISO,NRF_MOSI,NRF_CLK,NRF_TX_ADDR_RG+32,H,0,8)
  for I = 1 to NRF_ADDRESS_WIDTH
    junk=spi(NRF_MISO,NRF_MOSI,NRF_CLK,NRF_ADDRESS(I),H,0,8)
  next I
  pin(NRF_CS)=1
end sub  

sub NRF.setRXaddr(P)
  pipe=&H0A+P
  pin(NRF_CS)=0
  junk=spi(NRF_MISO,NRF_MOSI,NRF_CLK,pipe+32,H,0,8)
  for I = 1 to NRF_ADDRESS_WIDTH
    junk=spi(NRF_MISO,NRF_MOSI,NRF_CLK,NRF_ADDRESS(I),H,0,8)
  next I
  pin(NRF_CS)=1
end sub
  
sub test
  nrf.readpayload
  print "Button #";keyfobkey()
  NRF.clearRXDR
end sub

function NRF.status()
  temp=nrf.readreg(NRF_STATUS_RG)
  NRF.status=temp
  x$=bin$(temp)
  do
    x$="0"+x$
  loop until len(x$)=8
  NRF_TX_FULL=val(right$(x$,1))
  NRF_RX_P_NO=val("&B"+"mid$(x$,5,3))
  NRF_MAX_RT=val(mid$(x$,4,1))
  NRF_TX_DS=val(mid$(x$,3,1))
  NRF_RX_DR=val(mid$(x$,2,1))
  temp=nrf.readreg(NRF_FIFO_STATUS_REG)
  x$=bin$(temp)
  do
    x$="0"+x$
  loop until len(x$)=8
  NRF_TX_FULL=val(mid$(x$,3,1))
  NRF_TX_EMPTY=val(mid$(x$,4,1))
  NRF_RX_FULL=val(mid$(x$,7,1))
  NRF_RX_EMPTY=val(mid$(x$,8,1))
end function


sub NRF.readpayload
  local junk
  NRF.TXMODE
  do
    pin(NRF_CS)=0
    junk=spi(NRF_MISO,NRF_MOSI,NRF_CLK,&h61,H,0,8)
    for I=1 to NRF_PAYLOAD_WIDTH
      NRF.RX(I)=spi(NRF_MISO,NRF_MOSI,NRF_CLK,&h0,H,0,8)
    next I
    pin(NRF_CS)=1
  loop until nrf.readreg(23)=17
  NRF.RXMODE
  pause 200
end sub

sub NRF.sendpayload
  'NRF.TXMODE
  local junk
  pin(NRF_CS)=0
  junk=spi(NRF_MISO,NRF_MOSI,NRF_CLK,&hA0,H,0,8)
  for I= 1 to NRF_PAYLOAD_WIDTH
    junk=spi(NRF_MISO,NRF_MOSI,NRF_CLK,NRF.TX(I),H,0,8)
  next I
  pin(NRF_CS)=1
  nrf.rxmode
  pause 10
  nrf.txmode
end sub

sub NRF.clearRXDR
  nrf.writereg(NRF_STATUS_RG,64)
end sub
  
function NRF.readreg(reg)
  local junk, byte1
  pin(NRF_CS)=0
  junk=spi(NRF_MISO,NRF_MOSI,NRF_CLK,reg,H,0,8)
  byte1=spi(NRF_MISO,NRF_MOSI,NRF_CLK,&H0,H,0,8)
  pin(NRF_CS)=1
  NRF.readreg=byte1
end function

sub NRF.flushRX
  pin(NRF_CS)=0
  junk=spi(NRF_MISO,NRF_MOSI,NRF_CLK,&HE2,H,0,8)
  pin(NRF_CS)=1
end sub

sub NRF.flushTX
  pin(NRF_CS)=0
  junk=spi(NRF_MISO,NRF_MOSI,NRF_CLK,&HE1,H,0,8)
  pin(NRF_CS)=1
end sub

sub NRF.writereg(reg, byte)
  pin(NRF_CS)=0
  junk=spi(NRF_MISO,NRF_MOSI,NRF_CLK,reg+32,H,0,8)
  junk=spi(NRF_MISO,NRF_MOSI,NRF_CLK,byte,H,0,8)
  pin(NRF_CS)=1
end sub

sub NRF.RXMODE
  pin(NRF_CE)=1
end sub

sub NRF.TXMODE
  pin(NRF_CE)=0
end sub

function NRF.RX.avail()
  NRF.RX.avail=0
  x= NRF.readreg(NRF_FIFOSTATUS_RG)
  if x=16 or x=18 then NRF.RX.avail=1
end function

sub NRF.keyfobRX.setup
  pin(NRF_CE)=0
  nrf.writereg(NRF_ENAA_RG,0)
  nrf.writereg(NRF_ENRXADDR_RG,1)
  nrf.writereg(NRF_RFCH_RG,2)
  nrf.writereg(NRF_RXPWP0_RG,4)
  nrf.writereg(NRF_RFSETUP_RG,7)
  nrf.writereg(NRF_CONFIG_RG,&B00001011)
  pin(NRF_CE)=1
end sub

sub NRF.keyfobTX.setup
  pin(NRF_CE)=0
  nrf.writereg(NRF_ENAA_RG,0)
  nrf.writereg(NRF_ENRXADDR_RG,2)
  nrf.writereg(NRF_RFCH_RG,2)
  nrf.writereg(NRF_RXPWP0_RG,4)
  nrf.writereg(NRF_RFSETUP_RG,7)
  nrf.writereg(NRF_CONFIG_RG,&B00001010)
  pin(NRF_CE)=1
end sub

sub BLINKLED
pin(0)=0
pause 50
pin(0)=1
pause 50
pin(0)=0
pause 50
pin(0)=1
end sub

function keyfobkey()
  keyfobkey=0
  if nrf.rx(1)=30 then
    keyfobkey=1
    BLINKLED
  endif
  if nrf.rx(1)=23 then
    keyfobkey=2
    BLINKLED
  endif
  if nrf.rx(1)=29 then 
    keyfobkey=3
    BLINKLED
  ENDIF
  if nrf.rx(1)=27 then
    keyfobkey=4
    BLINKLED
  ENDIF
  if nrf.rx(1)=15 then
    keyfobfey=5
    BLINKLED
  ENDIF
end function

sub showRXaddress(x)
  temprg=&H0A+x
  pin(NRF_CS)=0
  junk=spi(NRF_MISO,NRF_MOSI,NRF_CLK,NRF_RXADDRP0_RG+x,H,0,8)
  for i=1 to 5
    byte=spi(NRF_MISO,NRF_MOSI,NRF_CLK,&H0,H,0,8)
    print byte;
  next i
  print ""
  pin(NRF_CS)=1
  NRF.readreg=byte1
end sub

sub showregs
  local junk,byte
  for I=0 to 23
    pin(NRF_CS)=0
    junk=spi(NRF_MISO,NRF_MOSI,NRF_CLK,I,H,0,8)
    byte=spi(NRF_MISO,NRF_MOSI,NRF_CLK,&h0,H,0,8)
    pin(NRF_CS)=1
    print "REG #"+str$(I)+" = "+str$(byte)
    pause 100
  next I
end sub

sub testtx
  'NRF.init
  'nrf.clearRXDR
  'nrf.flushRX
  'nrf.keyforRX.setup
  nrf.tx(1)=30
  nrf.tx(2)=0
  nrf.tx(3)=0
  nrf.tx(4)=0
  nrf.sendpayload 
  blinkled 
  pause 1000
  nrf.tx(1)=23
  nrf.sendpayload
  blinkled
  pause 1000
  nrf.tx(1)=29
  nrf.sendpayload
  blinkled
  pause 1000
  nrf.tx(1)=27
  nrf.sendpayload
  blinkled
  pause 1000
  nrf.tx(1)=15
  nrf.sendpayload
  blinkled
  pause 1000
end sub

'start
NRF.init
nrf.clearRXDR
nrf.flushrx
NRF.keyfobTX.setup
'setpin NRF_IRQ,7,test
'NRF.RXMODE
do
  testtx
loop                                                                          