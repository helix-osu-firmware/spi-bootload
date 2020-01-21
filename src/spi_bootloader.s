;#!pblaze-cc source : spi_bootloader.c
;#!pblaze-cc create : Tue Jan 21 16:59:19 2020
;#!pblaze-cc modify : Tue Jan 21 16:59:19 2020
;------------------------------------------------------------
address 0x000
boot:
  call init

;------------------------------------------------------------
;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c
loop:
 L_7e1655971b3ce565c00cbcf34e59c140_157:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:74
  ;void loop ()

 L_7e1655971b3ce565c00cbcf34e59c140_158:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:75
      call check_command

 JOIN_27:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:74
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
;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c
init:
 L_7e1655971b3ce565c00cbcf34e59c140_44:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:65
  ;void init ()

 L_7e1655971b3ce565c00cbcf34e59c140_45:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:66
      move s9, 63
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:67
      move s0, 0
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:69
      store s0, 24
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:71
      call SPI_STARTUP_initialize

 JOIN_10:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:65
  ;endfunc

_end_init:
  return


;------------------------------------------------------------
;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c
get_arguments:
 L_7e1655971b3ce565c00cbcf34e59c140_46:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:249
  ;void get_arguments ()

 L_7e1655971b3ce565c00cbcf34e59c140_47:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:250
      input sD, 35
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:251
      input sA, 34
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:252
      input sB, 33
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:253
      input sC, 32

 JOIN_11:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:249
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
;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c
command_complete_with_timeout:
 L_7e1655971b3ce565c00cbcf34e59c140_74:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:233
  ;void command_complete_with_timeout ()

 L_7e1655971b3ce565c00cbcf34e59c140_75:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:234
      move sF, 2

 L_7e1655971b3ce565c00cbcf34e59c140_76:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:236
      ;if (sA != 0), L_7e1655971b3ce565c00cbcf34e59c140_77, L_7e1655971b3ce565c00cbcf34e59c140_78
      compare sA, 0
      jump Z, L_7e1655971b3ce565c00cbcf34e59c140_78

 L_7e1655971b3ce565c00cbcf34e59c140_77:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:238
              or sF, 8

 JOIN_32:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:236
      ;endif of L_7e1655971b3ce565c00cbcf34e59c140_76

 L_7e1655971b3ce565c00cbcf34e59c140_78:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:236
  command_finish:

 L_7e1655971b3ce565c00cbcf34e59c140_79:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:239
      move sA, 0
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:240
      store sA, 24

 L_7e1655971b3ce565c00cbcf34e59c140_80:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:241
  command_finish_nolock:

 L_7e1655971b3ce565c00cbcf34e59c140_81:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:242
      output sF, 17
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:244
      output sF, 16

 JOIN_19:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:233
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
;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c
check_command:
 L_7e1655971b3ce565c00cbcf34e59c140_90:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:81
  ;void check_command ()

 L_7e1655971b3ce565c00cbcf34e59c140_91:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:85
      input s0, 16

 L_7e1655971b3ce565c00cbcf34e59c140_92:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:89
      ;if (s0 ^ 14), L_7e1655971b3ce565c00cbcf34e59c140_93, L_7e1655971b3ce565c00cbcf34e59c140_94
      test s0, 14
      jump NZ, L_7e1655971b3ce565c00cbcf34e59c140_94

 L_7e1655971b3ce565c00cbcf34e59c140_93:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:90
              return

 JOIN_33:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:89
      ;endif of L_7e1655971b3ce565c00cbcf34e59c140_92

 L_7e1655971b3ce565c00cbcf34e59c140_94:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:98
      move s0, 30
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:99
      move s1, 0

 L_7e1655971b3ce565c00cbcf34e59c140_95:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:101
      ;do

 L_7e1655971b3ce565c00cbcf34e59c140_96:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:102
              input sF, (s0)
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:104
              xor s1, sF
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:106
              add s0, 1

 L_7e1655971b3ce565c00cbcf34e59c140_97:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:108
      ;dowhile (s0 < 36), L_7e1655971b3ce565c00cbcf34e59c140_95, L_7e1655971b3ce565c00cbcf34e59c140_98
      compare s0, 36
      jump C, L_7e1655971b3ce565c00cbcf34e59c140_95

 L_7e1655971b3ce565c00cbcf34e59c140_98:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:109
      ;if (s1 != 0), L_7e1655971b3ce565c00cbcf34e59c140_99, L_7e1655971b3ce565c00cbcf34e59c140_100
      compare s1, 0
      jump Z, L_7e1655971b3ce565c00cbcf34e59c140_100

 L_7e1655971b3ce565c00cbcf34e59c140_99:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:110
              move sF, 6
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:111
              jump command_finish

 JOIN_34:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:109
      ;endif of L_7e1655971b3ce565c00cbcf34e59c140_98

 L_7e1655971b3ce565c00cbcf34e59c140_100:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:120
      input s0, 30
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:121
      move sF, s0
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:122
      and sF, 238

 L_7e1655971b3ce565c00cbcf34e59c140_101:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:124
      ;if (sF == 2), L_7e1655971b3ce565c00cbcf34e59c140_102, L_7e1655971b3ce565c00cbcf34e59c140_117
      compare sF, 2
      jump NZ, L_7e1655971b3ce565c00cbcf34e59c140_117

 L_7e1655971b3ce565c00cbcf34e59c140_102:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:126
              call get_arguments

 L_7e1655971b3ce565c00cbcf34e59c140_103:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:128
              ;if (s0 ^ 16), L_7e1655971b3ce565c00cbcf34e59c140_104, L_7e1655971b3ce565c00cbcf34e59c140_105
              test s0, 16
              jump NZ, L_7e1655971b3ce565c00cbcf34e59c140_105

 L_7e1655971b3ce565c00cbcf34e59c140_104:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:129
                      move sD, 255

 JOIN_36:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:128
              ;endif of L_7e1655971b3ce565c00cbcf34e59c140_103

 L_7e1655971b3ce565c00cbcf34e59c140_105:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:132
              and s0, 239

 L_7e1655971b3ce565c00cbcf34e59c140_106:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:134
              ;if (s0 == 2), L_7e1655971b3ce565c00cbcf34e59c140_107, L_7e1655971b3ce565c00cbcf34e59c140_112
              compare s0, 2
              jump NZ, L_7e1655971b3ce565c00cbcf34e59c140_112

 L_7e1655971b3ce565c00cbcf34e59c140_107:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:135
                      call SPI_Flash_write_begin
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:137
                      move s1, 255

 L_7e1655971b3ce565c00cbcf34e59c140_108:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:139
                      ;do

 L_7e1655971b3ce565c00cbcf34e59c140_109:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:139
                              input sA, 48
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:140
                              call SPI_tx_rx

 L_7e1655971b3ce565c00cbcf34e59c140_110:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:142
                      ;dowhile (s1 -- -1), L_7e1655971b3ce565c00cbcf34e59c140_108, L_7e1655971b3ce565c00cbcf34e59c140_111
                      sub s1, 1
                      jump NC, L_7e1655971b3ce565c00cbcf34e59c140_108

 L_7e1655971b3ce565c00cbcf34e59c140_111:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:142
                      call SPI_Flash_write_complete
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:143
                      jump command_complete_with_timeout

 JOIN_37:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:134
              ;endif of L_7e1655971b3ce565c00cbcf34e59c140_106

 L_7e1655971b3ce565c00cbcf34e59c140_112:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:146
              call SPI_Flash_read_begin
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:147
              move s1, 255

 L_7e1655971b3ce565c00cbcf34e59c140_113:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:149
              ;do

 L_7e1655971b3ce565c00cbcf34e59c140_114:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:149
                      call SPI_tx_rx
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:150
                      output sA, 48

 L_7e1655971b3ce565c00cbcf34e59c140_115:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:152
              ;dowhile (s1 -- -1), L_7e1655971b3ce565c00cbcf34e59c140_113, L_7e1655971b3ce565c00cbcf34e59c140_116
              sub s1, 1
              jump NC, L_7e1655971b3ce565c00cbcf34e59c140_113

 L_7e1655971b3ce565c00cbcf34e59c140_116:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:152
              outputk 2, 3
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:154
              move sF, 2
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:155
              jump command_finish

 JOIN_35:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:124
      ;endif of L_7e1655971b3ce565c00cbcf34e59c140_101

 L_7e1655971b3ce565c00cbcf34e59c140_117:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:158
      move sF, s0
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:159
      and sF, 253

 L_7e1655971b3ce565c00cbcf34e59c140_118:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:164
      ;if (sF == 220), L_7e1655971b3ce565c00cbcf34e59c140_119, L_7e1655971b3ce565c00cbcf34e59c140_123
      compare sF, 220
      jump NZ, L_7e1655971b3ce565c00cbcf34e59c140_123

 L_7e1655971b3ce565c00cbcf34e59c140_119:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:164
              call get_arguments

 L_7e1655971b3ce565c00cbcf34e59c140_120:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:170
              ;if (s0 & 2), L_7e1655971b3ce565c00cbcf34e59c140_121, L_7e1655971b3ce565c00cbcf34e59c140_122
              test s0, 2
              jump Z, L_7e1655971b3ce565c00cbcf34e59c140_122

 L_7e1655971b3ce565c00cbcf34e59c140_121:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:171
                      move sD, 255

 JOIN_39:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:170
              ;endif of L_7e1655971b3ce565c00cbcf34e59c140_120

 L_7e1655971b3ce565c00cbcf34e59c140_122:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:173
              call SPI_Flash_erase_sector
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:174
              jump command_complete_with_timeout

 JOIN_38:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:164
      ;endif of L_7e1655971b3ce565c00cbcf34e59c140_118

 L_7e1655971b3ce565c00cbcf34e59c140_123:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:178
      ;if (s0 == 158), L_7e1655971b3ce565c00cbcf34e59c140_124, L_7e1655971b3ce565c00cbcf34e59c140_125
      compare s0, 158
      jump NZ, L_7e1655971b3ce565c00cbcf34e59c140_125

 L_7e1655971b3ce565c00cbcf34e59c140_124:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:179
              call SPI_Flash_read_ID
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:181
              output sC, 34
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:182
              output sB, 33
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:183
              output sA, 32
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:184
              move sF, 2
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:185
              jump command_finish

 JOIN_40:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:178
      ;endif of L_7e1655971b3ce565c00cbcf34e59c140_123

 L_7e1655971b3ce565c00cbcf34e59c140_125:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:188
      ;if (s0 == 227), L_7e1655971b3ce565c00cbcf34e59c140_126, L_7e1655971b3ce565c00cbcf34e59c140_127
      compare s0, 227
      jump NZ, L_7e1655971b3ce565c00cbcf34e59c140_127

 L_7e1655971b3ce565c00cbcf34e59c140_126:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:188
              call get_arguments
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:189
              call SPI_Flash_write_nonvolatile_lock_bits
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:190
              jump command_complete_with_timeout

 JOIN_41:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:188
      ;endif of L_7e1655971b3ce565c00cbcf34e59c140_125

 L_7e1655971b3ce565c00cbcf34e59c140_127:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:193
      ;if (s0 == 228), L_7e1655971b3ce565c00cbcf34e59c140_128, L_7e1655971b3ce565c00cbcf34e59c140_129
      compare s0, 228
      jump NZ, L_7e1655971b3ce565c00cbcf34e59c140_129

 L_7e1655971b3ce565c00cbcf34e59c140_128:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:194
              call SPI_Flash_erase_nonvolatile_lock_bits
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:195
              jump command_complete_with_timeout

 JOIN_42:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:193
      ;endif of L_7e1655971b3ce565c00cbcf34e59c140_127

 L_7e1655971b3ce565c00cbcf34e59c140_129:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:198
      ;if (s0 == 254), L_7e1655971b3ce565c00cbcf34e59c140_130, L_7e1655971b3ce565c00cbcf34e59c140_134
      compare s0, 254
      jump NZ, L_7e1655971b3ce565c00cbcf34e59c140_134

 L_7e1655971b3ce565c00cbcf34e59c140_130:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:198
              call get_arguments

 L_7e1655971b3ce565c00cbcf34e59c140_131:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:201
              ;if (sD.sA.sB.sC == 1115252019), L_7e1655971b3ce565c00cbcf34e59c140_132, L_7e1655971b3ce565c00cbcf34e59c140_133
              compare sC, 51
              comparecy sB, 101
              comparecy sA, 121
              comparecy sD, 66
              jump NZ, L_7e1655971b3ce565c00cbcf34e59c140_133

 L_7e1655971b3ce565c00cbcf34e59c140_132:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:201
                      move sF, 1
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:202
                      store sF, 24
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:203
                      move sF, 2
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:204
                      jump command_finish_nolock

 JOIN_44:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:201
              ;endif of L_7e1655971b3ce565c00cbcf34e59c140_131

 L_7e1655971b3ce565c00cbcf34e59c140_133:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:206
              move sF, 6
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:207
              jump command_finish

 JOIN_43:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:198
      ;endif of L_7e1655971b3ce565c00cbcf34e59c140_129

 L_7e1655971b3ce565c00cbcf34e59c140_134:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:210
      ;if (s0 == 255), L_7e1655971b3ce565c00cbcf34e59c140_135, L_7e1655971b3ce565c00cbcf34e59c140_139
      compare s0, 255
      jump NZ, L_7e1655971b3ce565c00cbcf34e59c140_139

 L_7e1655971b3ce565c00cbcf34e59c140_135:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:211
              fetch sA, 24

 L_7e1655971b3ce565c00cbcf34e59c140_136:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:213
              ;if (sA == 0), L_7e1655971b3ce565c00cbcf34e59c140_137, L_7e1655971b3ce565c00cbcf34e59c140_138
              compare sA, 0
              jump NZ, L_7e1655971b3ce565c00cbcf34e59c140_138

 L_7e1655971b3ce565c00cbcf34e59c140_137:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:213
                      move sF, 6
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:214
                      jump command_finish

 JOIN_46:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:213
              ;endif of L_7e1655971b3ce565c00cbcf34e59c140_136

 L_7e1655971b3ce565c00cbcf34e59c140_138:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:216
              call get_arguments
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:218
              store sC, 20
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:219
              store sB, 21
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:220
              store sA, 22
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:221
              store sD, 23
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:222
              move sF, 2
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:223
              output sF, 17
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:224
              output sF, 16
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:225
              jump ICAP_reboot

 JOIN_45:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:210
      ;endif of L_7e1655971b3ce565c00cbcf34e59c140_134

 L_7e1655971b3ce565c00cbcf34e59c140_139:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:228
      move sF, 6
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:229
      jump command_finish

 JOIN_22:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:81
  ;endfunc

_end_check_command:



;------------------------------------------------------------
;soft_icap.h
ICAP_noop2:
 L_71a81080701ac64314787f44a37f449e_140:
 ;soft_icap.h:60
  ;void ICAP_noop2 ()

 L_71a81080701ac64314787f44a37f449e_141:
 ;soft_icap.h:61
      call ICAP_noop

 L_71a81080701ac64314787f44a37f449e_142:
 ;soft_icap.h:62
  ICAP_noop:

 L_71a81080701ac64314787f44a37f449e_143:
 ;soft_icap.h:63
      move sA, 0

 L_71a81080701ac64314787f44a37f449e_144:
 ;soft_icap.h:64
  ICAP_write_word:

 L_71a81080701ac64314787f44a37f449e_145:
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
 L_a3d055800f7a3cf0cebf61d3c47eb536_146:
 ;soft_spi_flash.h:186
  ;void SPI_Flash_write_complete ()

 L_a3d055800f7a3cf0cebf61d3c47eb536_147:
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
 L_a3d055800f7a3cf0cebf61d3c47eb536_148:
 ;soft_spi_flash.h:205
  ;void SPI_Flash_wait_WIP ()

 L_a3d055800f7a3cf0cebf61d3c47eb536_149:
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

 L_a3d055800f7a3cf0cebf61d3c47eb536_150:
 ;soft_spi_flash.h:216
      ;do

 L_a3d055800f7a3cf0cebf61d3c47eb536_151:
 ;soft_spi_flash.h:216
              call SPI_Flash_read_SR
 ;soft_spi_flash.h:217
              and sA, 1

 L_a3d055800f7a3cf0cebf61d3c47eb536_152:
 ;soft_spi_flash.h:219
              ;if (Z != 0), L_a3d055800f7a3cf0cebf61d3c47eb536_153, L_a3d055800f7a3cf0cebf61d3c47eb536_154
            
              jump NZ, L_a3d055800f7a3cf0cebf61d3c47eb536_154

 L_a3d055800f7a3cf0cebf61d3c47eb536_153:
 ;soft_spi_flash.h:221
                      return

 JOIN_47:
 ;soft_spi_flash.h:219
              ;endif of L_a3d055800f7a3cf0cebf61d3c47eb536_152

 L_a3d055800f7a3cf0cebf61d3c47eb536_154:
 ;soft_spi_flash.h:220
      ;dowhile (sE.sD.sC -- -1), L_a3d055800f7a3cf0cebf61d3c47eb536_150, JOIN_25
      sub sC, 1
      subcy sD, 0
      subcy sE, 0
      jump NC, L_a3d055800f7a3cf0cebf61d3c47eb536_150

 JOIN_25:
 ;soft_spi_flash.h:205
  ;endfunc

_end_SPI_Flash_wait_WIP:
  return


;------------------------------------------------------------
;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c
spiisr:
 L_7e1655971b3ce565c00cbcf34e59c140_155:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:258
  ;bool_t spiisr (void)

 L_7e1655971b3ce565c00cbcf34e59c140_156:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:259
      call SPI_Flash_reset
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:260
      move sF, 1
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:262
      output sF, 8

 JOIN_26:
 ;/home/allison.122/repositories/github/spi_bootload/src/spi_bootloader.c:258
  ;endfunc

_end_spiisr:
  returni enable



;ISR
;IRQ0
address 0x1FF
jump    spiisr
