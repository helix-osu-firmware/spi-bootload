;#!pblaze-cc source : spi_bootloader.c
;#!pblaze-cc create : Thu Jun 11 12:53:01 2020
;#!pblaze-cc modify : Thu Jun 11 12:53:01 2020
;------------------------------------------------------------
address 0x000
boot:
  call init

;------------------------------------------------------------
;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c
loop:
 L_308d974e25f2ae938b9e95cb0efd5c9d_154:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:74
  ;void loop ()

 L_308d974e25f2ae938b9e95cb0efd5c9d_155:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:75
      call check_command

 JOIN_27:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:74
  ;endfunc

_end_loop:
  jump loop


;------------------------------------------------------------
;soft_icap.h
ICAP_out4:
 L_71a81080701ac64314787f44a37f449e_0:
 ;soft_icap.h:72
  ;void ICAP_out4 ()

 L_71a81080701ac64314787f44a37f449e_1:
 ;soft_icap.h:73
      move sB, 32

 L_71a81080701ac64314787f44a37f449e_2:
 ;soft_icap.h:74
  memout4:

 L_71a81080701ac64314787f44a37f449e_3:
 ;soft_icap.h:75
      call memout2

 L_71a81080701ac64314787f44a37f449e_4:
 ;soft_icap.h:76
  memout2:

 L_71a81080701ac64314787f44a37f449e_5:
 ;soft_icap.h:77
      call memout1

 L_71a81080701ac64314787f44a37f449e_6:
 ;soft_icap.h:78
  memout1:

 L_71a81080701ac64314787f44a37f449e_7:
 ;soft_icap.h:79
      fetch sF, (sA)
 ;soft_icap.h:80
      output sF, (sB)
 ;soft_icap.h:81
      add sA, 1
 ;soft_icap.h:82
      add sB, 1

 JOIN_0:
 ;soft_icap.h:72
  ;endfunc

_end_ICAP_out4:
  return


;------------------------------------------------------------
;soft_spi_flash.h
SPI_Flash_tx_address:
 L_a3d055800f7a3cf0cebf61d3c47eb536_8:
 ;soft_spi_flash.h:105
  ;void SPI_Flash_tx_address ()

 L_a3d055800f7a3cf0cebf61d3c47eb536_9:
 ;soft_spi_flash.h:107
      call SPI_Flash_tx_stack

 L_a3d055800f7a3cf0cebf61d3c47eb536_10:
 ;soft_spi_flash.h:109
  SPI_Flash_tx_stack2:

 L_a3d055800f7a3cf0cebf61d3c47eb536_11:
 ;soft_spi_flash.h:111
      call SPI_Flash_tx_stack

 L_a3d055800f7a3cf0cebf61d3c47eb536_12:
 ;soft_spi_flash.h:113
  SPI_Flash_tx_stack:

 L_a3d055800f7a3cf0cebf61d3c47eb536_13:
 ;soft_spi_flash.h:115
      call pop1
 ;soft_spi_flash.h:117
      call SPI_tx_rx

 JOIN_1:
 ;soft_spi_flash.h:105
  ;endfunc

_end_SPI_Flash_tx_address:
  return


;------------------------------------------------------------
;soft_spi.h
SPI_tx_rx_twice:
 L_8954ef92e853e1c1eca1906c122ba060_14:
 ;soft_spi.h:88
  ;void SPI_tx_rx_twice ()

 L_8954ef92e853e1c1eca1906c122ba060_15:
 ;soft_spi.h:89
      call SPI_tx_rx

 L_8954ef92e853e1c1eca1906c122ba060_16:
 ;soft_spi.h:90
  SPI_tx_rx:

 L_8954ef92e853e1c1eca1906c122ba060_17:
 ;soft_spi.h:98
      move sB, 8
 ;soft_spi.h:99
      outputk 0, 1

 L_8954ef92e853e1c1eca1906c122ba060_18:
 ;soft_spi.h:101
      ;do

 L_8954ef92e853e1c1eca1906c122ba060_19:
 ;soft_spi.h:102
              output sA, 2
 ;soft_spi.h:103
              input sF, 0
 ;soft_spi.h:104
              test sF, 0x4
 ;soft_spi.h:105
              sla sA
 ;soft_spi.h:106
              outputk 1, 1
 ;soft_spi.h:107
              outputk 0, 1

 L_8954ef92e853e1c1eca1906c122ba060_20:
 ;soft_spi.h:108
      ;dowhile (sB -- 0), L_8954ef92e853e1c1eca1906c122ba060_18, JOIN_2
      sub sB, 1
      jump NZ, L_8954ef92e853e1c1eca1906c122ba060_18

 JOIN_2:
 ;soft_spi.h:88
  ;endfunc

_end_SPI_tx_rx_twice:
  return


;------------------------------------------------------------
;soft_spi_flash.h
SPI_Flash_read_begin:
 L_a3d055800f7a3cf0cebf61d3c47eb536_21:
 ;soft_spi_flash.h:123
  ;void SPI_Flash_read_begin ()

 L_a3d055800f7a3cf0cebf61d3c47eb536_22:
 ;soft_spi_flash.h:128
      outputk 2, 3
 ;soft_spi_flash.h:129
      call push3
 ;soft_spi_flash.h:130
      move sA, 3

 L_a3d055800f7a3cf0cebf61d3c47eb536_23:
 ;soft_spi_flash.h:132
      ;if (sD != 255), L_a3d055800f7a3cf0cebf61d3c47eb536_24, L_a3d055800f7a3cf0cebf61d3c47eb536_25
      compare sD, 255
      jump Z, L_a3d055800f7a3cf0cebf61d3c47eb536_25

 L_a3d055800f7a3cf0cebf61d3c47eb536_24:
 ;soft_spi_flash.h:132
              move sA, 19
 ;soft_spi_flash.h:133
              call SPI_tx_rx
 ;soft_spi_flash.h:134
              move sA, sD

 JOIN_28:
 ;soft_spi_flash.h:132
      ;endif of L_a3d055800f7a3cf0cebf61d3c47eb536_23

 L_a3d055800f7a3cf0cebf61d3c47eb536_25:
 ;soft_spi_flash.h:136
      call SPI_tx_rx
 ;soft_spi_flash.h:137
      call SPI_Flash_tx_address

 JOIN_3:
 ;soft_spi_flash.h:123
  ;endfunc

_end_SPI_Flash_read_begin:
  return


;------------------------------------------------------------
;soft_spi_flash.h
SPI_Flash_erase_nonvolatile_lock_bits:
 L_a3d055800f7a3cf0cebf61d3c47eb536_26:
 ;soft_spi_flash.h:256
  ;void SPI_Flash_erase_nonvolatile_lock_bits ()

 L_a3d055800f7a3cf0cebf61d3c47eb536_27:
 ;soft_spi_flash.h:257
      move sA, 6
 ;soft_spi_flash.h:258
      call SPI_Flash_single_command
 ;soft_spi_flash.h:258
      move sA, 228
 ;soft_spi_flash.h:259
      call SPI_Flash_single_command
 ;soft_spi_flash.h:260
      jump SPI_Flash_erase_sector_wait

 JOIN_4:
 ;soft_spi_flash.h:256
  ;endfunc

_end_SPI_Flash_erase_nonvolatile_lock_bits:



;------------------------------------------------------------
;soft_spi_flash.h
SPI_disable_and_return:
 L_a3d055800f7a3cf0cebf61d3c47eb536_28:
 ;soft_spi_flash.h:298
  ;void SPI_disable_and_return ()

 L_a3d055800f7a3cf0cebf61d3c47eb536_29:
 ;soft_spi_flash.h:299
      outputk 2, 3

 JOIN_5:
 ;soft_spi_flash.h:298
  ;endfunc

_end_SPI_disable_and_return:
  return


;------------------------------------------------------------
;soft_spi_flash.h
SPI_Flash_write_begin:
 L_a3d055800f7a3cf0cebf61d3c47eb536_30:
 ;soft_spi_flash.h:163
  ;void SPI_Flash_write_begin ()

 L_a3d055800f7a3cf0cebf61d3c47eb536_31:
 ;soft_spi_flash.h:165
      call push3
 ;soft_spi_flash.h:166
      move sA, 6
 ;soft_spi_flash.h:167
      call SPI_Flash_single_command
 ;soft_spi_flash.h:167
      move sA, 2

 L_a3d055800f7a3cf0cebf61d3c47eb536_32:
 ;soft_spi_flash.h:171
      ;if (sD != 255), L_a3d055800f7a3cf0cebf61d3c47eb536_33, L_a3d055800f7a3cf0cebf61d3c47eb536_34
      compare sD, 255
      jump Z, L_a3d055800f7a3cf0cebf61d3c47eb536_34

 L_a3d055800f7a3cf0cebf61d3c47eb536_33:
 ;soft_spi_flash.h:172
              move sA, 18
 ;soft_spi_flash.h:175
              call SPI_tx_rx
 ;soft_spi_flash.h:176
              move sA, sD

 JOIN_29:
 ;soft_spi_flash.h:171
      ;endif of L_a3d055800f7a3cf0cebf61d3c47eb536_32

 L_a3d055800f7a3cf0cebf61d3c47eb536_34:
 ;soft_spi_flash.h:178
      call SPI_tx_rx
 ;soft_spi_flash.h:179
      call SPI_Flash_tx_address

 JOIN_6:
 ;soft_spi_flash.h:163
  ;endfunc

_end_SPI_Flash_write_begin:
  return


;------------------------------------------------------------
;soft_spi_flash.h
SPI_Flash_write_nonvolatile_lock_bits:
 L_a3d055800f7a3cf0cebf61d3c47eb536_35:
 ;soft_spi_flash.h:268
  ;void SPI_Flash_write_nonvolatile_lock_bits ()

 L_a3d055800f7a3cf0cebf61d3c47eb536_36:
 ;soft_spi_flash.h:271
      add sD, 1

 L_a3d055800f7a3cf0cebf61d3c47eb536_37:
 ;soft_spi_flash.h:273
      ;if (Z == 0), L_a3d055800f7a3cf0cebf61d3c47eb536_38, L_a3d055800f7a3cf0cebf61d3c47eb536_39
    
      jump Z, L_a3d055800f7a3cf0cebf61d3c47eb536_39

 L_a3d055800f7a3cf0cebf61d3c47eb536_38:
 ;soft_spi_flash.h:275
              sub sD, 1

 JOIN_30:
 ;soft_spi_flash.h:273
      ;endif of L_a3d055800f7a3cf0cebf61d3c47eb536_37

 L_a3d055800f7a3cf0cebf61d3c47eb536_39:
 ;soft_spi_flash.h:273
      call push3
 ;soft_spi_flash.h:274
      move sA, 6
 ;soft_spi_flash.h:275
      call SPI_Flash_single_command
 ;soft_spi_flash.h:275
      move sA, 227
 ;soft_spi_flash.h:276
      call SPI_tx_rx
 ;soft_spi_flash.h:277
      move sA, sD
 ;soft_spi_flash.h:278
      call SPI_tx_rx
 ;soft_spi_flash.h:279
      call SPI_Flash_tx_address
 ;soft_spi_flash.h:281
      jump SPI_Flash_write_complete

 JOIN_7:
 ;soft_spi_flash.h:268
  ;endfunc

_end_SPI_Flash_write_nonvolatile_lock_bits:



;------------------------------------------------------------
;soft_spi_flash.h
SPI_Flash_single_command:
 L_a3d055800f7a3cf0cebf61d3c47eb536_40:
 ;soft_spi_flash.h:57
  ;void SPI_Flash_single_command ()

 L_a3d055800f7a3cf0cebf61d3c47eb536_41:
 ;soft_spi_flash.h:58
      outputk 2, 3
 ;soft_spi_flash.h:59
      call SPI_tx_rx
 ;soft_spi_flash.h:60
      jump SPI_disable_and_return

 JOIN_8:
 ;soft_spi_flash.h:57
  ;endfunc

_end_SPI_Flash_single_command:



;------------------------------------------------------------
;soft_spi_flash.h
SPI_Flash_read_SR:
 L_a3d055800f7a3cf0cebf61d3c47eb536_42:
 ;soft_spi_flash.h:223
  ;void SPI_Flash_read_SR ()

 L_a3d055800f7a3cf0cebf61d3c47eb536_43:
 ;soft_spi_flash.h:224
      outputk 2, 3
 ;soft_spi_flash.h:225
      move sA, 5
 ;soft_spi_flash.h:227
      call SPI_tx_rx_twice
 ;soft_spi_flash.h:228
      jump SPI_disable_and_return

 JOIN_9:
 ;soft_spi_flash.h:223
  ;endfunc

_end_SPI_Flash_read_SR:



;------------------------------------------------------------
;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c
init:
 L_308d974e25f2ae938b9e95cb0efd5c9d_44:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:65
  ;void init ()

 L_308d974e25f2ae938b9e95cb0efd5c9d_45:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:66
      move s9, 63
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:67
      move s0, 0
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:69
      store s0, 24
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:71
      call SPI_STARTUP_initialize

 JOIN_10:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:65
  ;endfunc

_end_init:
  return


;------------------------------------------------------------
;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c
get_arguments:
 L_308d974e25f2ae938b9e95cb0efd5c9d_46:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:250
  ;void get_arguments ()

 L_308d974e25f2ae938b9e95cb0efd5c9d_47:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:251
      input sD, 35
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:252
      input sA, 34
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:253
      input sB, 33
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:254
      input sC, 32

 JOIN_11:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:250
  ;endfunc

_end_get_arguments:
  return


;------------------------------------------------------------
;soft_spi_flash.h
SPI_Flash_erase_sector:
 L_a3d055800f7a3cf0cebf61d3c47eb536_48:
 ;soft_spi_flash.h:235
  ;void SPI_Flash_erase_sector ()

 L_a3d055800f7a3cf0cebf61d3c47eb536_49:
 ;soft_spi_flash.h:236
      call push3
 ;soft_spi_flash.h:237
      move sA, 6
 ;soft_spi_flash.h:238
      call SPI_Flash_single_command
 ;soft_spi_flash.h:238
      move sA, 216

 L_a3d055800f7a3cf0cebf61d3c47eb536_50:
 ;soft_spi_flash.h:240
      ;if (sD != 255), L_a3d055800f7a3cf0cebf61d3c47eb536_51, L_a3d055800f7a3cf0cebf61d3c47eb536_52
      compare sD, 255
      jump Z, L_a3d055800f7a3cf0cebf61d3c47eb536_52

 L_a3d055800f7a3cf0cebf61d3c47eb536_51:
 ;soft_spi_flash.h:240
              move sA, 220
 ;soft_spi_flash.h:241
              call SPI_tx_rx
 ;soft_spi_flash.h:242
              move sA, sD

 JOIN_31:
 ;soft_spi_flash.h:240
      ;endif of L_a3d055800f7a3cf0cebf61d3c47eb536_50

 L_a3d055800f7a3cf0cebf61d3c47eb536_52:
 ;soft_spi_flash.h:244
      call SPI_tx_rx
 ;soft_spi_flash.h:245
      call SPI_Flash_tx_address
 ;soft_spi_flash.h:246
      outputk 2, 3

 L_a3d055800f7a3cf0cebf61d3c47eb536_53:
 ;soft_spi_flash.h:247
  SPI_Flash_erase_sector_wait:

 L_a3d055800f7a3cf0cebf61d3c47eb536_54:
 ;soft_spi_flash.h:249
      move sA, 170
 ;soft_spi_flash.h:250
      jump SPI_Flash_wait_WIP

 JOIN_12:
 ;soft_spi_flash.h:235
  ;endfunc

_end_SPI_Flash_erase_sector:



;------------------------------------------------------------
;pb_stack.h
push3:
 L_8b0484302fca3739bcd2321fa1bde4dc_55:
 ;pb_stack.h:13
  ;void push3 ()

 L_8b0484302fca3739bcd2321fa1bde4dc_56:
 ;pb_stack.h:14
      store sC, (s9)
 ;pb_stack.h:15
      sub s9, 1

 L_8b0484302fca3739bcd2321fa1bde4dc_57:
 ;pb_stack.h:16
  push2:

 L_8b0484302fca3739bcd2321fa1bde4dc_58:
 ;pb_stack.h:17
      store sB, (s9)
 ;pb_stack.h:18
      sub s9, 1

 L_8b0484302fca3739bcd2321fa1bde4dc_59:
 ;pb_stack.h:19
  push1:

 L_8b0484302fca3739bcd2321fa1bde4dc_60:
 ;pb_stack.h:20
      store sA, (s9)
 ;pb_stack.h:21
      sub s9, 1

 JOIN_13:
 ;pb_stack.h:13
  ;endfunc

_end_push3:
  return


;------------------------------------------------------------
;soft_spi.h
SPI_STARTUP_initialize:
 L_8954ef92e853e1c1eca1906c122ba060_61:
 ;soft_spi.h:67
  ;void SPI_STARTUP_initialize ()

 L_8954ef92e853e1c1eca1906c122ba060_62:
 ;soft_spi.h:68
      outputk 2, 3
 ;soft_spi.h:69
      move sF, 8

 L_8954ef92e853e1c1eca1906c122ba060_63:
 ;soft_spi.h:71
      ;do

 L_8954ef92e853e1c1eca1906c122ba060_64:
 ;soft_spi.h:71
              outputk 3, 1
 ;soft_spi.h:72
              outputk 2, 1

 L_8954ef92e853e1c1eca1906c122ba060_65:
 ;soft_spi.h:74
      ;dowhile (sF -- 0), L_8954ef92e853e1c1eca1906c122ba060_63, JOIN_14
      sub sF, 1
      jump NZ, L_8954ef92e853e1c1eca1906c122ba060_63

 JOIN_14:
 ;soft_spi.h:67
  ;endfunc

_end_SPI_STARTUP_initialize:
  return


;------------------------------------------------------------
;soft_spi_flash.h
SPI_Flash_reset:
 L_a3d055800f7a3cf0cebf61d3c47eb536_66:
 ;soft_spi_flash.h:285
  ;void SPI_Flash_reset ()

 L_a3d055800f7a3cf0cebf61d3c47eb536_67:
 ;soft_spi_flash.h:286
      outputk 2, 3
 ;soft_spi_flash.h:289
      move sA, 102
 ;soft_spi_flash.h:290
      call SPI_Flash_single_command
 ;soft_spi_flash.h:291
      move sA, 240
 ;soft_spi_flash.h:292
      call SPI_Flash_single_command
 ;soft_spi_flash.h:293
      move sA, 153
 ;soft_spi_flash.h:295
      jump SPI_Flash_single_command

 JOIN_15:
 ;soft_spi_flash.h:285
  ;endfunc

_end_SPI_Flash_reset:



;------------------------------------------------------------
;pb_stack.h
pop3:
 L_8b0484302fca3739bcd2321fa1bde4dc_68:
 ;pb_stack.h:33
  ;void pop3 ()

 L_8b0484302fca3739bcd2321fa1bde4dc_69:
 ;pb_stack.h:34
      call pop2
 ;pb_stack.h:35
      add s9, 1
 ;pb_stack.h:36
      fetch sC, (s9)

 JOIN_16:
 ;pb_stack.h:33
  ;endfunc

_end_pop3:
  return


;------------------------------------------------------------
;pb_stack.h
pop2:
 L_8b0484302fca3739bcd2321fa1bde4dc_70:
 ;pb_stack.h:28
  ;void pop2 ()

 L_8b0484302fca3739bcd2321fa1bde4dc_71:
 ;pb_stack.h:29
      call pop1
 ;pb_stack.h:30
      add s9, 1
 ;pb_stack.h:31
      fetch sB, (s9)

 JOIN_17:
 ;pb_stack.h:28
  ;endfunc

_end_pop2:
  return


;------------------------------------------------------------
;pb_stack.h
pop1:
 L_8b0484302fca3739bcd2321fa1bde4dc_72:
 ;pb_stack.h:24
  ;void pop1 ()

 L_8b0484302fca3739bcd2321fa1bde4dc_73:
 ;pb_stack.h:25
      add s9, 1
 ;pb_stack.h:26
      fetch sA, (s9)

 JOIN_18:
 ;pb_stack.h:24
  ;endfunc

_end_pop1:
  return


;------------------------------------------------------------
;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c
command_complete_with_timeout:
 L_308d974e25f2ae938b9e95cb0efd5c9d_74:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:234
  ;void command_complete_with_timeout ()

 L_308d974e25f2ae938b9e95cb0efd5c9d_75:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:235
      move sF, 2

 L_308d974e25f2ae938b9e95cb0efd5c9d_76:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:237
      ;if (sA != 0), L_308d974e25f2ae938b9e95cb0efd5c9d_77, L_308d974e25f2ae938b9e95cb0efd5c9d_78
      compare sA, 0
      jump Z, L_308d974e25f2ae938b9e95cb0efd5c9d_78

 L_308d974e25f2ae938b9e95cb0efd5c9d_77:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:239
              or sF, 8

 JOIN_32:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:237
      ;endif of L_308d974e25f2ae938b9e95cb0efd5c9d_76

 L_308d974e25f2ae938b9e95cb0efd5c9d_78:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:237
  command_finish:

 L_308d974e25f2ae938b9e95cb0efd5c9d_79:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:240
      move sA, 0
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:241
      store sA, 24

 L_308d974e25f2ae938b9e95cb0efd5c9d_80:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:242
  command_finish_nolock:

 L_308d974e25f2ae938b9e95cb0efd5c9d_81:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:243
      output sF, 17
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:245
      output sF, 16

 JOIN_19:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:234
  ;endfunc

_end_command_complete_with_timeout:
  return


;------------------------------------------------------------
;soft_spi_flash.h
SPI_Flash_read_ID:
 L_a3d055800f7a3cf0cebf61d3c47eb536_82:
 ;soft_spi_flash.h:77
  ;void SPI_Flash_read_ID ()

 L_a3d055800f7a3cf0cebf61d3c47eb536_83:
 ;soft_spi_flash.h:78
      outputk 2, 3
 ;soft_spi_flash.h:79
      move sA, 159
 ;soft_spi_flash.h:81
      call SPI_tx_rx_twice
 ;soft_spi_flash.h:83
      call push1
 ;soft_spi_flash.h:84
      call SPI_tx_rx
 ;soft_spi_flash.h:86
      call push1
 ;soft_spi_flash.h:87
      call SPI_tx_rx
 ;soft_spi_flash.h:89
      call push1
 ;soft_spi_flash.h:93
      call pop3
 ;soft_spi_flash.h:94
      jump SPI_disable_and_return

 JOIN_20:
 ;soft_spi_flash.h:77
  ;endfunc

_end_SPI_Flash_read_ID:



;------------------------------------------------------------
;soft_icap.h
ICAP_reboot:
 L_71a81080701ac64314787f44a37f449e_84:
 ;soft_icap.h:29
  ;void ICAP_reboot ()

 L_71a81080701ac64314787f44a37f449e_85:
 ;soft_icap.h:30
      move sA, 255
 ;soft_icap.h:31
      move sB, 32

 L_71a81080701ac64314787f44a37f449e_86:
 ;soft_icap.h:33
      ;do

 L_71a81080701ac64314787f44a37f449e_87:
 ;soft_icap.h:33
              output sA, (sB)
 ;soft_icap.h:34
              add sB, 1

 L_71a81080701ac64314787f44a37f449e_88:
 ;soft_icap.h:36
      ;dowhile (sB != 36), L_71a81080701ac64314787f44a37f449e_86, L_71a81080701ac64314787f44a37f449e_89
      compare sB, 36
      jump NZ, L_71a81080701ac64314787f44a37f449e_86

 L_71a81080701ac64314787f44a37f449e_89:
 ;soft_icap.h:41
      move sA, 4
 ;soft_icap.h:42
      call ICAP_write_word
 ;soft_icap.h:43
      call ICAP_noop
 ;soft_icap.h:44
      move sA, 12
 ;soft_icap.h:45
      call ICAP_write_word
 ;soft_icap.h:46
      move sA, 20
 ;soft_icap.h:47
      call ICAP_write_word
 ;soft_icap.h:48
      move sA, 8
 ;soft_icap.h:49
      call ICAP_write_word
 ;soft_icap.h:50
      move sA, 16
 ;soft_icap.h:51
      call ICAP_write_word
 ;soft_icap.h:52
      call ICAP_noop

 JOIN_21:
 ;soft_icap.h:29
  ;endfunc

_end_ICAP_reboot:
  return


;------------------------------------------------------------
;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c
check_command:
 L_308d974e25f2ae938b9e95cb0efd5c9d_90:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:81
  ;void check_command ()

 L_308d974e25f2ae938b9e95cb0efd5c9d_91:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:85
      input s0, 16
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:88
      xor s0, 0xE
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:89
      and s0, 0xE
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:90
      return NZ
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:99
      move s0, 30
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:100
      move s1, 0

 L_308d974e25f2ae938b9e95cb0efd5c9d_92:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:102
      ;do

 L_308d974e25f2ae938b9e95cb0efd5c9d_93:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:103
              input sF, (s0)
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:105
              xor s1, sF
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:107
              add s0, 1

 L_308d974e25f2ae938b9e95cb0efd5c9d_94:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:109
      ;dowhile (s0 < 36), L_308d974e25f2ae938b9e95cb0efd5c9d_92, L_308d974e25f2ae938b9e95cb0efd5c9d_95
      compare s0, 36
      jump C, L_308d974e25f2ae938b9e95cb0efd5c9d_92

 L_308d974e25f2ae938b9e95cb0efd5c9d_95:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:110
      ;if (s1 != 0), L_308d974e25f2ae938b9e95cb0efd5c9d_96, L_308d974e25f2ae938b9e95cb0efd5c9d_97
      compare s1, 0
      jump Z, L_308d974e25f2ae938b9e95cb0efd5c9d_97

 L_308d974e25f2ae938b9e95cb0efd5c9d_96:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:111
              move sF, 6
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:112
              jump command_finish

 JOIN_33:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:110
      ;endif of L_308d974e25f2ae938b9e95cb0efd5c9d_95

 L_308d974e25f2ae938b9e95cb0efd5c9d_97:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:121
      input s0, 30
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:122
      move sF, s0
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:123
      and sF, 238

 L_308d974e25f2ae938b9e95cb0efd5c9d_98:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:125
      ;if (sF == 2), L_308d974e25f2ae938b9e95cb0efd5c9d_99, L_308d974e25f2ae938b9e95cb0efd5c9d_114
      compare sF, 2
      jump NZ, L_308d974e25f2ae938b9e95cb0efd5c9d_114

 L_308d974e25f2ae938b9e95cb0efd5c9d_99:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:127
              call get_arguments

 L_308d974e25f2ae938b9e95cb0efd5c9d_100:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:129
              ;if (s0 ^ 16), L_308d974e25f2ae938b9e95cb0efd5c9d_101, L_308d974e25f2ae938b9e95cb0efd5c9d_102
              test s0, 16
              jump NZ, L_308d974e25f2ae938b9e95cb0efd5c9d_102

 L_308d974e25f2ae938b9e95cb0efd5c9d_101:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:130
                      move sD, 255

 JOIN_35:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:129
              ;endif of L_308d974e25f2ae938b9e95cb0efd5c9d_100

 L_308d974e25f2ae938b9e95cb0efd5c9d_102:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:133
              and s0, 239

 L_308d974e25f2ae938b9e95cb0efd5c9d_103:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:135
              ;if (s0 == 2), L_308d974e25f2ae938b9e95cb0efd5c9d_104, L_308d974e25f2ae938b9e95cb0efd5c9d_109
              compare s0, 2
              jump NZ, L_308d974e25f2ae938b9e95cb0efd5c9d_109

 L_308d974e25f2ae938b9e95cb0efd5c9d_104:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:136
                      call SPI_Flash_write_begin
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:138
                      move s1, 255

 L_308d974e25f2ae938b9e95cb0efd5c9d_105:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:140
                      ;do

 L_308d974e25f2ae938b9e95cb0efd5c9d_106:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:140
                              input sA, 48
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:141
                              call SPI_tx_rx

 L_308d974e25f2ae938b9e95cb0efd5c9d_107:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:143
                      ;dowhile (s1 -- -1), L_308d974e25f2ae938b9e95cb0efd5c9d_105, L_308d974e25f2ae938b9e95cb0efd5c9d_108
                      sub s1, 1
                      jump NC, L_308d974e25f2ae938b9e95cb0efd5c9d_105

 L_308d974e25f2ae938b9e95cb0efd5c9d_108:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:143
                      call SPI_Flash_write_complete
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:144
                      jump command_complete_with_timeout

 JOIN_36:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:135
              ;endif of L_308d974e25f2ae938b9e95cb0efd5c9d_103

 L_308d974e25f2ae938b9e95cb0efd5c9d_109:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:147
              call SPI_Flash_read_begin
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:148
              move s1, 255

 L_308d974e25f2ae938b9e95cb0efd5c9d_110:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:150
              ;do

 L_308d974e25f2ae938b9e95cb0efd5c9d_111:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:150
                      call SPI_tx_rx
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:151
                      output sA, 48

 L_308d974e25f2ae938b9e95cb0efd5c9d_112:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:153
              ;dowhile (s1 -- -1), L_308d974e25f2ae938b9e95cb0efd5c9d_110, L_308d974e25f2ae938b9e95cb0efd5c9d_113
              sub s1, 1
              jump NC, L_308d974e25f2ae938b9e95cb0efd5c9d_110

 L_308d974e25f2ae938b9e95cb0efd5c9d_113:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:153
              outputk 2, 3
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:155
              move sF, 2
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:156
              jump command_finish

 JOIN_34:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:125
      ;endif of L_308d974e25f2ae938b9e95cb0efd5c9d_98

 L_308d974e25f2ae938b9e95cb0efd5c9d_114:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:159
      move sF, s0
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:160
      and sF, 253

 L_308d974e25f2ae938b9e95cb0efd5c9d_115:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:165
      ;if (sF == 220), L_308d974e25f2ae938b9e95cb0efd5c9d_116, L_308d974e25f2ae938b9e95cb0efd5c9d_120
      compare sF, 220
      jump NZ, L_308d974e25f2ae938b9e95cb0efd5c9d_120

 L_308d974e25f2ae938b9e95cb0efd5c9d_116:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:165
              call get_arguments

 L_308d974e25f2ae938b9e95cb0efd5c9d_117:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:171
              ;if (s0 & 2), L_308d974e25f2ae938b9e95cb0efd5c9d_118, L_308d974e25f2ae938b9e95cb0efd5c9d_119
              test s0, 2
              jump Z, L_308d974e25f2ae938b9e95cb0efd5c9d_119

 L_308d974e25f2ae938b9e95cb0efd5c9d_118:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:172
                      move sD, 255

 JOIN_38:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:171
              ;endif of L_308d974e25f2ae938b9e95cb0efd5c9d_117

 L_308d974e25f2ae938b9e95cb0efd5c9d_119:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:174
              call SPI_Flash_erase_sector
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:175
              jump command_complete_with_timeout

 JOIN_37:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:165
      ;endif of L_308d974e25f2ae938b9e95cb0efd5c9d_115

 L_308d974e25f2ae938b9e95cb0efd5c9d_120:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:179
      ;if (s0 == 158), L_308d974e25f2ae938b9e95cb0efd5c9d_121, L_308d974e25f2ae938b9e95cb0efd5c9d_122
      compare s0, 158
      jump NZ, L_308d974e25f2ae938b9e95cb0efd5c9d_122

 L_308d974e25f2ae938b9e95cb0efd5c9d_121:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:180
              call SPI_Flash_read_ID
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:182
              output sC, 34
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:183
              output sB, 33
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:184
              output sA, 32
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:185
              move sF, 2
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:186
              jump command_finish

 JOIN_39:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:179
      ;endif of L_308d974e25f2ae938b9e95cb0efd5c9d_120

 L_308d974e25f2ae938b9e95cb0efd5c9d_122:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:189
      ;if (s0 == 227), L_308d974e25f2ae938b9e95cb0efd5c9d_123, L_308d974e25f2ae938b9e95cb0efd5c9d_124
      compare s0, 227
      jump NZ, L_308d974e25f2ae938b9e95cb0efd5c9d_124

 L_308d974e25f2ae938b9e95cb0efd5c9d_123:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:189
              call get_arguments
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:190
              call SPI_Flash_write_nonvolatile_lock_bits
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:191
              jump command_complete_with_timeout

 JOIN_40:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:189
      ;endif of L_308d974e25f2ae938b9e95cb0efd5c9d_122

 L_308d974e25f2ae938b9e95cb0efd5c9d_124:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:194
      ;if (s0 == 228), L_308d974e25f2ae938b9e95cb0efd5c9d_125, L_308d974e25f2ae938b9e95cb0efd5c9d_126
      compare s0, 228
      jump NZ, L_308d974e25f2ae938b9e95cb0efd5c9d_126

 L_308d974e25f2ae938b9e95cb0efd5c9d_125:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:195
              call SPI_Flash_erase_nonvolatile_lock_bits
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:196
              jump command_complete_with_timeout

 JOIN_41:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:194
      ;endif of L_308d974e25f2ae938b9e95cb0efd5c9d_124

 L_308d974e25f2ae938b9e95cb0efd5c9d_126:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:199
      ;if (s0 == 254), L_308d974e25f2ae938b9e95cb0efd5c9d_127, L_308d974e25f2ae938b9e95cb0efd5c9d_131
      compare s0, 254
      jump NZ, L_308d974e25f2ae938b9e95cb0efd5c9d_131

 L_308d974e25f2ae938b9e95cb0efd5c9d_127:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:199
              call get_arguments

 L_308d974e25f2ae938b9e95cb0efd5c9d_128:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:202
              ;if (sD.sA.sB.sC == 1115252019), L_308d974e25f2ae938b9e95cb0efd5c9d_129, L_308d974e25f2ae938b9e95cb0efd5c9d_130
              compare sC, 51
              comparecy sB, 101
              comparecy sA, 121
              comparecy sD, 66
              jump NZ, L_308d974e25f2ae938b9e95cb0efd5c9d_130

 L_308d974e25f2ae938b9e95cb0efd5c9d_129:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:202
                      move sF, 1
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:203
                      store sF, 24
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:204
                      move sF, 2
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:205
                      jump command_finish_nolock

 JOIN_43:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:202
              ;endif of L_308d974e25f2ae938b9e95cb0efd5c9d_128

 L_308d974e25f2ae938b9e95cb0efd5c9d_130:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:207
              move sF, 6
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:208
              jump command_finish

 JOIN_42:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:199
      ;endif of L_308d974e25f2ae938b9e95cb0efd5c9d_126

 L_308d974e25f2ae938b9e95cb0efd5c9d_131:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:211
      ;if (s0 == 255), L_308d974e25f2ae938b9e95cb0efd5c9d_132, L_308d974e25f2ae938b9e95cb0efd5c9d_136
      compare s0, 255
      jump NZ, L_308d974e25f2ae938b9e95cb0efd5c9d_136

 L_308d974e25f2ae938b9e95cb0efd5c9d_132:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:212
              fetch sA, 24

 L_308d974e25f2ae938b9e95cb0efd5c9d_133:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:214
              ;if (sA == 0), L_308d974e25f2ae938b9e95cb0efd5c9d_134, L_308d974e25f2ae938b9e95cb0efd5c9d_135
              compare sA, 0
              jump NZ, L_308d974e25f2ae938b9e95cb0efd5c9d_135

 L_308d974e25f2ae938b9e95cb0efd5c9d_134:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:214
                      move sF, 6
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:215
                      jump command_finish

 JOIN_45:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:214
              ;endif of L_308d974e25f2ae938b9e95cb0efd5c9d_133

 L_308d974e25f2ae938b9e95cb0efd5c9d_135:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:217
              call get_arguments
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:219
              store sC, 20
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:220
              store sB, 21
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:221
              store sA, 22
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:222
              store sD, 23
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:223
              move sF, 2
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:224
              output sF, 17
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:225
              output sF, 16
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:226
              jump ICAP_reboot

 JOIN_44:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:211
      ;endif of L_308d974e25f2ae938b9e95cb0efd5c9d_131

 L_308d974e25f2ae938b9e95cb0efd5c9d_136:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:229
      move sF, 6
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:230
      jump command_finish

 JOIN_22:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:81
  ;endfunc

_end_check_command:



;------------------------------------------------------------
;soft_icap.h
ICAP_noop2:
 L_71a81080701ac64314787f44a37f449e_137:
 ;soft_icap.h:60
  ;void ICAP_noop2 ()

 L_71a81080701ac64314787f44a37f449e_138:
 ;soft_icap.h:61
      call ICAP_noop

 L_71a81080701ac64314787f44a37f449e_139:
 ;soft_icap.h:62
  ICAP_noop:

 L_71a81080701ac64314787f44a37f449e_140:
 ;soft_icap.h:63
      move sA, 0

 L_71a81080701ac64314787f44a37f449e_141:
 ;soft_icap.h:64
  ICAP_write_word:

 L_71a81080701ac64314787f44a37f449e_142:
 ;soft_icap.h:65
      call ICAP_out4
 ;soft_icap.h:66
      outputk 0, 4

 JOIN_23:
 ;soft_icap.h:60
  ;endfunc

_end_ICAP_noop2:
  return


;------------------------------------------------------------
;soft_spi_flash.h
SPI_Flash_write_complete:
 L_a3d055800f7a3cf0cebf61d3c47eb536_143:
 ;soft_spi_flash.h:186
  ;void SPI_Flash_write_complete ()

 L_a3d055800f7a3cf0cebf61d3c47eb536_144:
 ;soft_spi_flash.h:188
      outputk 2, 3
 ;soft_spi_flash.h:190
      move sA, 1
 ;soft_spi_flash.h:191
      call SPI_Flash_wait_WIP
 ;soft_spi_flash.h:193
      call push1
 ;soft_spi_flash.h:195
      move sA, 4
 ;soft_spi_flash.h:196
      call SPI_Flash_single_command
 ;soft_spi_flash.h:197
      call pop1

 JOIN_24:
 ;soft_spi_flash.h:186
  ;endfunc

_end_SPI_Flash_write_complete:
  return


;------------------------------------------------------------
;soft_spi_flash.h
SPI_Flash_wait_WIP:
 L_a3d055800f7a3cf0cebf61d3c47eb536_145:
 ;soft_spi_flash.h:205
  ;void SPI_Flash_wait_WIP ()

 L_a3d055800f7a3cf0cebf61d3c47eb536_146:
 ;soft_spi_flash.h:210
      move sD, sA
 ;soft_spi_flash.h:211
      sl0 sD
      sla sE
 ;soft_spi_flash.h:212
      sl0 sD
      sla sE
 ;soft_spi_flash.h:213
      sl0 sD
      sla sE
 ;soft_spi_flash.h:214
      move sC, 0

 L_a3d055800f7a3cf0cebf61d3c47eb536_147:
 ;soft_spi_flash.h:216
      ;do

 L_a3d055800f7a3cf0cebf61d3c47eb536_148:
 ;soft_spi_flash.h:216
              call SPI_Flash_read_SR
 ;soft_spi_flash.h:217
              and sA, 1

 L_a3d055800f7a3cf0cebf61d3c47eb536_149:
 ;soft_spi_flash.h:219
              ;if (Z != 0), L_a3d055800f7a3cf0cebf61d3c47eb536_150, L_a3d055800f7a3cf0cebf61d3c47eb536_151
            
              jump NZ, L_a3d055800f7a3cf0cebf61d3c47eb536_151

 L_a3d055800f7a3cf0cebf61d3c47eb536_150:
 ;soft_spi_flash.h:221
                      return

 JOIN_46:
 ;soft_spi_flash.h:219
              ;endif of L_a3d055800f7a3cf0cebf61d3c47eb536_149

 L_a3d055800f7a3cf0cebf61d3c47eb536_151:
 ;soft_spi_flash.h:220
      ;dowhile (sE.sD.sC -- -1), L_a3d055800f7a3cf0cebf61d3c47eb536_147, JOIN_25
      sub sC, 1
      subcy sD, 0
      subcy sE, 0
      jump NC, L_a3d055800f7a3cf0cebf61d3c47eb536_147

 JOIN_25:
 ;soft_spi_flash.h:205
  ;endfunc

_end_SPI_Flash_wait_WIP:
  return


;------------------------------------------------------------
;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c
spiisr:
 L_308d974e25f2ae938b9e95cb0efd5c9d_152:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:259
  ;bool_t spiisr (void)

 L_308d974e25f2ae938b9e95cb0efd5c9d_153:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:260
      call SPI_Flash_reset
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:261
      move sF, 1
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:263
      output sF, 8

 JOIN_26:
 ;/home/allison.122/repositories/github/tof_readout/spi/src/spi_bootloader.c:259
  ;endfunc

_end_spiisr:
  returni enable



;ISR
;IRQ0
address 0x1FF
jump    spiisr
