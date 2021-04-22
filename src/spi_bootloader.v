/*
 * == pblaze-cc ==
 * source : spi_bootloader.c
 * create : Thu Apr  8 15:12:00 2021
 * modify : Thu Apr  8 15:12:00 2021
 */
`timescale 1 ps / 1ps

/* 
 * == pblaze-as ==
 * source : spi_bootloader.s
 * create : Thu Apr 22 10:23:49 2021
 * modify : Thu Apr 22 10:23:49 2021
 */
/* 
 * == pblaze-ld ==
 * target : kcpsm3
 */

module spi_bootloader (address, instruction, enable, clk, bram_adr_i, bram_dat_o, bram_dat_i, bram_en_i, bram_we_i, bram_rd_i);
parameter BRAM_PORT_WIDTH = 9;
localparam BRAM_ADR_WIDTH = (BRAM_PORT_WIDTH == 18) ? 10 : 11;
localparam BRAM_WE_WIDTH = (BRAM_PORT_WIDTH == 18) ? 2 : 1;
input [9:0] address;
input clk;
input enable;
output [17:0] instruction;
input [BRAM_ADR_WIDTH-1:0] bram_adr_i;
output [BRAM_PORT_WIDTH-1:0] bram_dat_o;
input [BRAM_PORT_WIDTH-1:0] bram_dat_i;
input bram_we_i;
input bram_en_i;
input bram_rd_i;

// Debugging symbols. Note that they're
// only 48 characters long max.
// synthesis translate_off

// allocate a bunch of space for the text
   reg [8*48-1:0] dbg_instr;
   always @(*) begin
     case(address)
         0 : dbg_instr = "boot                                           ";
         1 : dbg_instr = "loop                                           ";
         2 : dbg_instr = "loop+0x001                                     ";
         3 : dbg_instr = "ICAP_out4                                      ";
         4 : dbg_instr = "memout4                                        ";
         5 : dbg_instr = "memout2                                        ";
         6 : dbg_instr = "memout1                                        ";
         7 : dbg_instr = "memout1+0x001                                  ";
         8 : dbg_instr = "memout1+0x002                                  ";
         9 : dbg_instr = "memout1+0x003                                  ";
         10 : dbg_instr = "memout1+0x004                                  ";
         11 : dbg_instr = "SPI_Flash_tx_address                           ";
         12 : dbg_instr = "SPI_Flash_tx_stack2                            ";
         13 : dbg_instr = "SPI_Flash_tx_stack                             ";
         14 : dbg_instr = "SPI_Flash_tx_stack+0x001                       ";
         15 : dbg_instr = "SPI_Flash_tx_stack+0x002                       ";
         16 : dbg_instr = "SPI_tx_rx_twice                                ";
         17 : dbg_instr = "SPI_tx_rx                                      ";
         18 : dbg_instr = "SPI_tx_rx+0x001                                ";
         19 : dbg_instr = "SPI_tx_rx+0x002                                ";
         20 : dbg_instr = "SPI_tx_rx+0x003                                ";
         21 : dbg_instr = "SPI_tx_rx+0x004                                ";
         22 : dbg_instr = "SPI_tx_rx+0x005                                ";
         23 : dbg_instr = "SPI_tx_rx+0x006                                ";
         24 : dbg_instr = "SPI_tx_rx+0x007                                ";
         25 : dbg_instr = "SPI_tx_rx+0x008                                ";
         26 : dbg_instr = "SPI_tx_rx+0x009                                ";
         27 : dbg_instr = "SPI_tx_rx+0x00a                                ";
         28 : dbg_instr = "SPI_Flash_read_begin                           ";
         29 : dbg_instr = "SPI_Flash_read_begin+0x001                     ";
         30 : dbg_instr = "SPI_Flash_read_begin+0x002                     ";
         31 : dbg_instr = "SPI_Flash_read_begin+0x003                     ";
         32 : dbg_instr = "SPI_Flash_read_begin+0x004                     ";
         33 : dbg_instr = "SPI_Flash_read_begin+0x005                     ";
         34 : dbg_instr = "SPI_Flash_read_begin+0x006                     ";
         35 : dbg_instr = "SPI_Flash_read_begin+0x007                     ";
         36 : dbg_instr = "SPI_Flash_read_begin+0x008                     ";
         37 : dbg_instr = "SPI_Flash_read_begin+0x009                     ";
         38 : dbg_instr = "SPI_Flash_read_begin+0x00a                     ";
         39 : dbg_instr = "SPI_Flash_erase_nonvolatile_lock_bits          ";
         40 : dbg_instr = "SPI_Flash_erase_nonvolatile_lock_bits+0x001    ";
         41 : dbg_instr = "SPI_Flash_erase_nonvolatile_lock_bits+0x002    ";
         42 : dbg_instr = "SPI_Flash_erase_nonvolatile_lock_bits+0x003    ";
         43 : dbg_instr = "SPI_Flash_erase_nonvolatile_lock_bits+0x004    ";
         44 : dbg_instr = "SPI_disable_and_return                         ";
         45 : dbg_instr = "SPI_disable_and_return+0x001                   ";
         46 : dbg_instr = "SPI_Flash_write_begin                          ";
         47 : dbg_instr = "SPI_Flash_write_begin+0x001                    ";
         48 : dbg_instr = "SPI_Flash_write_begin+0x002                    ";
         49 : dbg_instr = "SPI_Flash_write_begin+0x003                    ";
         50 : dbg_instr = "SPI_Flash_write_begin+0x004                    ";
         51 : dbg_instr = "SPI_Flash_write_begin+0x005                    ";
         52 : dbg_instr = "SPI_Flash_write_begin+0x006                    ";
         53 : dbg_instr = "SPI_Flash_write_begin+0x007                    ";
         54 : dbg_instr = "SPI_Flash_write_begin+0x008                    ";
         55 : dbg_instr = "SPI_Flash_write_begin+0x009                    ";
         56 : dbg_instr = "SPI_Flash_write_begin+0x00a                    ";
         57 : dbg_instr = "SPI_Flash_write_begin+0x00b                    ";
         58 : dbg_instr = "SPI_Flash_write_nonvolatile_lock_bits          ";
         59 : dbg_instr = "SPI_Flash_write_nonvolatile_lock_bits+0x001    ";
         60 : dbg_instr = "SPI_Flash_write_nonvolatile_lock_bits+0x002    ";
         61 : dbg_instr = "SPI_Flash_write_nonvolatile_lock_bits+0x003    ";
         62 : dbg_instr = "SPI_Flash_write_nonvolatile_lock_bits+0x004    ";
         63 : dbg_instr = "SPI_Flash_write_nonvolatile_lock_bits+0x005    ";
         64 : dbg_instr = "SPI_Flash_write_nonvolatile_lock_bits+0x006    ";
         65 : dbg_instr = "SPI_Flash_write_nonvolatile_lock_bits+0x007    ";
         66 : dbg_instr = "SPI_Flash_write_nonvolatile_lock_bits+0x008    ";
         67 : dbg_instr = "SPI_Flash_write_nonvolatile_lock_bits+0x009    ";
         68 : dbg_instr = "SPI_Flash_write_nonvolatile_lock_bits+0x00a    ";
         69 : dbg_instr = "SPI_Flash_write_nonvolatile_lock_bits+0x00b    ";
         70 : dbg_instr = "SPI_Flash_single_command                       ";
         71 : dbg_instr = "SPI_Flash_single_command+0x001                 ";
         72 : dbg_instr = "SPI_Flash_single_command+0x002                 ";
         73 : dbg_instr = "SPI_Flash_read_SR                              ";
         74 : dbg_instr = "SPI_Flash_read_SR+0x001                        ";
         75 : dbg_instr = "SPI_Flash_read_SR+0x002                        ";
         76 : dbg_instr = "SPI_Flash_read_SR+0x003                        ";
         77 : dbg_instr = "init                                           ";
         78 : dbg_instr = "init+0x001                                     ";
         79 : dbg_instr = "init+0x002                                     ";
         80 : dbg_instr = "init+0x003                                     ";
         81 : dbg_instr = "init+0x004                                     ";
         82 : dbg_instr = "get_arguments                                  ";
         83 : dbg_instr = "get_arguments+0x001                            ";
         84 : dbg_instr = "get_arguments+0x002                            ";
         85 : dbg_instr = "get_arguments+0x003                            ";
         86 : dbg_instr = "get_arguments+0x004                            ";
         87 : dbg_instr = "SPI_Flash_erase_sector                         ";
         88 : dbg_instr = "SPI_Flash_erase_sector+0x001                   ";
         89 : dbg_instr = "SPI_Flash_erase_sector+0x002                   ";
         90 : dbg_instr = "SPI_Flash_erase_sector+0x003                   ";
         91 : dbg_instr = "SPI_Flash_erase_sector+0x004                   ";
         92 : dbg_instr = "SPI_Flash_erase_sector+0x005                   ";
         93 : dbg_instr = "SPI_Flash_erase_sector+0x006                   ";
         94 : dbg_instr = "SPI_Flash_erase_sector+0x007                   ";
         95 : dbg_instr = "SPI_Flash_erase_sector+0x008                   ";
         96 : dbg_instr = "SPI_Flash_erase_sector+0x009                   ";
         97 : dbg_instr = "SPI_Flash_erase_sector+0x00a                   ";
         98 : dbg_instr = "SPI_Flash_erase_sector+0x00b                   ";
         99 : dbg_instr = "SPI_Flash_erase_sector_wait                    ";
         100 : dbg_instr = "SPI_Flash_erase_sector_wait+0x001              ";
         101 : dbg_instr = "SPI_Flash_erase_sector_wait+0x002              ";
         102 : dbg_instr = "SPI_Flash_erase_sector_wait+0x003              ";
         103 : dbg_instr = "SPI_Flash_erase_sector_wait+0x004              ";
         104 : dbg_instr = "push3                                          ";
         105 : dbg_instr = "push3+0x001                                    ";
         106 : dbg_instr = "push2                                          ";
         107 : dbg_instr = "push2+0x001                                    ";
         108 : dbg_instr = "push1                                          ";
         109 : dbg_instr = "push1+0x001                                    ";
         110 : dbg_instr = "push1+0x002                                    ";
         111 : dbg_instr = "SPI_STARTUP_initialize                         ";
         112 : dbg_instr = "SPI_STARTUP_initialize+0x001                   ";
         113 : dbg_instr = "SPI_STARTUP_initialize+0x002                   ";
         114 : dbg_instr = "SPI_STARTUP_initialize+0x003                   ";
         115 : dbg_instr = "SPI_STARTUP_initialize+0x004                   ";
         116 : dbg_instr = "SPI_STARTUP_initialize+0x005                   ";
         117 : dbg_instr = "SPI_STARTUP_initialize+0x006                   ";
         118 : dbg_instr = "SPI_Flash_reset                                ";
         119 : dbg_instr = "SPI_Flash_reset+0x001                          ";
         120 : dbg_instr = "SPI_Flash_reset+0x002                          ";
         121 : dbg_instr = "SPI_Flash_reset+0x003                          ";
         122 : dbg_instr = "SPI_Flash_reset+0x004                          ";
         123 : dbg_instr = "SPI_Flash_reset+0x005                          ";
         124 : dbg_instr = "SPI_Flash_reset+0x006                          ";
         125 : dbg_instr = "pop3                                           ";
         126 : dbg_instr = "pop3+0x001                                     ";
         127 : dbg_instr = "pop3+0x002                                     ";
         128 : dbg_instr = "pop3+0x003                                     ";
         129 : dbg_instr = "pop2                                           ";
         130 : dbg_instr = "pop2+0x001                                     ";
         131 : dbg_instr = "pop2+0x002                                     ";
         132 : dbg_instr = "pop2+0x003                                     ";
         133 : dbg_instr = "pop1                                           ";
         134 : dbg_instr = "pop1+0x001                                     ";
         135 : dbg_instr = "pop1+0x002                                     ";
         136 : dbg_instr = "command_complete_with_timeout                  ";
         137 : dbg_instr = "command_complete_with_timeout+0x001            ";
         138 : dbg_instr = "command_complete_with_timeout+0x002            ";
         139 : dbg_instr = "command_complete_with_timeout+0x003            ";
         140 : dbg_instr = "command_finish                                 ";
         141 : dbg_instr = "command_finish+0x001                           ";
         142 : dbg_instr = "command_finish_nolock                          ";
         143 : dbg_instr = "command_finish_nolock+0x001                    ";
         144 : dbg_instr = "command_finish_nolock+0x002                    ";
         145 : dbg_instr = "SPI_Flash_read_ID                              ";
         146 : dbg_instr = "SPI_Flash_read_ID+0x001                        ";
         147 : dbg_instr = "SPI_Flash_read_ID+0x002                        ";
         148 : dbg_instr = "SPI_Flash_read_ID+0x003                        ";
         149 : dbg_instr = "SPI_Flash_read_ID+0x004                        ";
         150 : dbg_instr = "SPI_Flash_read_ID+0x005                        ";
         151 : dbg_instr = "SPI_Flash_read_ID+0x006                        ";
         152 : dbg_instr = "SPI_Flash_read_ID+0x007                        ";
         153 : dbg_instr = "SPI_Flash_read_ID+0x008                        ";
         154 : dbg_instr = "SPI_Flash_read_ID+0x009                        ";
         155 : dbg_instr = "ICAP_reboot                                    ";
         156 : dbg_instr = "ICAP_reboot+0x001                              ";
         157 : dbg_instr = "ICAP_reboot+0x002                              ";
         158 : dbg_instr = "ICAP_reboot+0x003                              ";
         159 : dbg_instr = "ICAP_reboot+0x004                              ";
         160 : dbg_instr = "ICAP_reboot+0x005                              ";
         161 : dbg_instr = "ICAP_reboot+0x006                              ";
         162 : dbg_instr = "ICAP_reboot+0x007                              ";
         163 : dbg_instr = "ICAP_reboot+0x008                              ";
         164 : dbg_instr = "ICAP_reboot+0x009                              ";
         165 : dbg_instr = "ICAP_reboot+0x00a                              ";
         166 : dbg_instr = "ICAP_reboot+0x00b                              ";
         167 : dbg_instr = "ICAP_reboot+0x00c                              ";
         168 : dbg_instr = "ICAP_reboot+0x00d                              ";
         169 : dbg_instr = "ICAP_reboot+0x00e                              ";
         170 : dbg_instr = "ICAP_reboot+0x00f                              ";
         171 : dbg_instr = "ICAP_reboot+0x010                              ";
         172 : dbg_instr = "ICAP_reboot+0x011                              ";
         173 : dbg_instr = "ICAP_reboot+0x012                              ";
         174 : dbg_instr = "check_command                                  ";
         175 : dbg_instr = "check_command+0x001                            ";
         176 : dbg_instr = "check_command+0x002                            ";
         177 : dbg_instr = "check_command+0x003                            ";
         178 : dbg_instr = "check_command+0x004                            ";
         179 : dbg_instr = "check_command+0x005                            ";
         180 : dbg_instr = "check_command+0x006                            ";
         181 : dbg_instr = "check_command+0x007                            ";
         182 : dbg_instr = "check_command+0x008                            ";
         183 : dbg_instr = "check_command+0x009                            ";
         184 : dbg_instr = "check_command+0x00a                            ";
         185 : dbg_instr = "check_command+0x00b                            ";
         186 : dbg_instr = "check_command+0x00c                            ";
         187 : dbg_instr = "check_command+0x00d                            ";
         188 : dbg_instr = "check_command+0x00e                            ";
         189 : dbg_instr = "check_command+0x00f                            ";
         190 : dbg_instr = "check_command+0x010                            ";
         191 : dbg_instr = "check_command+0x011                            ";
         192 : dbg_instr = "check_command+0x012                            ";
         193 : dbg_instr = "check_command+0x013                            ";
         194 : dbg_instr = "check_command+0x014                            ";
         195 : dbg_instr = "check_command+0x015                            ";
         196 : dbg_instr = "check_command+0x016                            ";
         197 : dbg_instr = "check_command+0x017                            ";
         198 : dbg_instr = "check_command+0x018                            ";
         199 : dbg_instr = "check_command+0x019                            ";
         200 : dbg_instr = "check_command+0x01a                            ";
         201 : dbg_instr = "check_command+0x01b                            ";
         202 : dbg_instr = "check_command+0x01c                            ";
         203 : dbg_instr = "check_command+0x01d                            ";
         204 : dbg_instr = "check_command+0x01e                            ";
         205 : dbg_instr = "check_command+0x01f                            ";
         206 : dbg_instr = "check_command+0x020                            ";
         207 : dbg_instr = "check_command+0x021                            ";
         208 : dbg_instr = "check_command+0x022                            ";
         209 : dbg_instr = "check_command+0x023                            ";
         210 : dbg_instr = "check_command+0x024                            ";
         211 : dbg_instr = "check_command+0x025                            ";
         212 : dbg_instr = "check_command+0x026                            ";
         213 : dbg_instr = "check_command+0x027                            ";
         214 : dbg_instr = "check_command+0x028                            ";
         215 : dbg_instr = "check_command+0x029                            ";
         216 : dbg_instr = "check_command+0x02a                            ";
         217 : dbg_instr = "check_command+0x02b                            ";
         218 : dbg_instr = "check_command+0x02c                            ";
         219 : dbg_instr = "check_command+0x02d                            ";
         220 : dbg_instr = "check_command+0x02e                            ";
         221 : dbg_instr = "check_command+0x02f                            ";
         222 : dbg_instr = "check_command+0x030                            ";
         223 : dbg_instr = "check_command+0x031                            ";
         224 : dbg_instr = "check_command+0x032                            ";
         225 : dbg_instr = "check_command+0x033                            ";
         226 : dbg_instr = "check_command+0x034                            ";
         227 : dbg_instr = "check_command+0x035                            ";
         228 : dbg_instr = "check_command+0x036                            ";
         229 : dbg_instr = "check_command+0x037                            ";
         230 : dbg_instr = "check_command+0x038                            ";
         231 : dbg_instr = "check_command+0x039                            ";
         232 : dbg_instr = "check_command+0x03a                            ";
         233 : dbg_instr = "check_command+0x03b                            ";
         234 : dbg_instr = "check_command+0x03c                            ";
         235 : dbg_instr = "check_command+0x03d                            ";
         236 : dbg_instr = "check_command+0x03e                            ";
         237 : dbg_instr = "check_command+0x03f                            ";
         238 : dbg_instr = "check_command+0x040                            ";
         239 : dbg_instr = "check_command+0x041                            ";
         240 : dbg_instr = "check_command+0x042                            ";
         241 : dbg_instr = "check_command+0x043                            ";
         242 : dbg_instr = "check_command+0x044                            ";
         243 : dbg_instr = "check_command+0x045                            ";
         244 : dbg_instr = "check_command+0x046                            ";
         245 : dbg_instr = "check_command+0x047                            ";
         246 : dbg_instr = "check_command+0x048                            ";
         247 : dbg_instr = "check_command+0x049                            ";
         248 : dbg_instr = "check_command+0x04a                            ";
         249 : dbg_instr = "check_command+0x04b                            ";
         250 : dbg_instr = "check_command+0x04c                            ";
         251 : dbg_instr = "check_command+0x04d                            ";
         252 : dbg_instr = "check_command+0x04e                            ";
         253 : dbg_instr = "check_command+0x04f                            ";
         254 : dbg_instr = "check_command+0x050                            ";
         255 : dbg_instr = "check_command+0x051                            ";
         256 : dbg_instr = "check_command+0x052                            ";
         257 : dbg_instr = "check_command+0x053                            ";
         258 : dbg_instr = "check_command+0x054                            ";
         259 : dbg_instr = "check_command+0x055                            ";
         260 : dbg_instr = "check_command+0x056                            ";
         261 : dbg_instr = "check_command+0x057                            ";
         262 : dbg_instr = "check_command+0x058                            ";
         263 : dbg_instr = "check_command+0x059                            ";
         264 : dbg_instr = "check_command+0x05a                            ";
         265 : dbg_instr = "check_command+0x05b                            ";
         266 : dbg_instr = "check_command+0x05c                            ";
         267 : dbg_instr = "check_command+0x05d                            ";
         268 : dbg_instr = "check_command+0x05e                            ";
         269 : dbg_instr = "check_command+0x05f                            ";
         270 : dbg_instr = "check_command+0x060                            ";
         271 : dbg_instr = "check_command+0x061                            ";
         272 : dbg_instr = "check_command+0x062                            ";
         273 : dbg_instr = "check_command+0x063                            ";
         274 : dbg_instr = "check_command+0x064                            ";
         275 : dbg_instr = "check_command+0x065                            ";
         276 : dbg_instr = "check_command+0x066                            ";
         277 : dbg_instr = "ICAP_noop2                                     ";
         278 : dbg_instr = "ICAP_noop                                      ";
         279 : dbg_instr = "ICAP_write_word                                ";
         280 : dbg_instr = "ICAP_write_word+0x001                          ";
         281 : dbg_instr = "ICAP_write_word+0x002                          ";
         282 : dbg_instr = "SPI_Flash_write_complete                       ";
         283 : dbg_instr = "SPI_Flash_write_complete+0x001                 ";
         284 : dbg_instr = "SPI_Flash_write_complete+0x002                 ";
         285 : dbg_instr = "SPI_Flash_write_complete+0x003                 ";
         286 : dbg_instr = "SPI_Flash_write_complete+0x004                 ";
         287 : dbg_instr = "SPI_Flash_write_complete+0x005                 ";
         288 : dbg_instr = "SPI_Flash_write_complete+0x006                 ";
         289 : dbg_instr = "SPI_Flash_write_complete+0x007                 ";
         290 : dbg_instr = "SPI_Flash_wait_WIP                             ";
         291 : dbg_instr = "SPI_Flash_wait_WIP+0x001                       ";
         292 : dbg_instr = "SPI_Flash_wait_WIP+0x002                       ";
         293 : dbg_instr = "SPI_Flash_wait_WIP+0x003                       ";
         294 : dbg_instr = "SPI_Flash_wait_WIP+0x004                       ";
         295 : dbg_instr = "SPI_Flash_wait_WIP+0x005                       ";
         296 : dbg_instr = "SPI_Flash_wait_WIP+0x006                       ";
         297 : dbg_instr = "SPI_Flash_wait_WIP+0x007                       ";
         298 : dbg_instr = "SPI_Flash_wait_WIP+0x008                       ";
         299 : dbg_instr = "SPI_Flash_wait_WIP+0x009                       ";
         300 : dbg_instr = "SPI_Flash_wait_WIP+0x00a                       ";
         301 : dbg_instr = "SPI_Flash_wait_WIP+0x00b                       ";
         302 : dbg_instr = "SPI_Flash_wait_WIP+0x00c                       ";
         303 : dbg_instr = "SPI_Flash_wait_WIP+0x00d                       ";
         304 : dbg_instr = "SPI_Flash_wait_WIP+0x00e                       ";
         305 : dbg_instr = "SPI_Flash_wait_WIP+0x00f                       ";
         306 : dbg_instr = "spiisr                                         ";
         307 : dbg_instr = "spiisr+0x001                                   ";
         308 : dbg_instr = "spiisr+0x002                                   ";
         309 : dbg_instr = "spiisr+0x003                                   ";
         310 : dbg_instr = "spiisr+0x004                                   ";
         311 : dbg_instr = "spiisr+0x005                                   ";
         312 : dbg_instr = "spiisr+0x006                                   ";
         313 : dbg_instr = "spiisr+0x007                                   ";
         314 : dbg_instr = "spiisr+0x008                                   ";
         315 : dbg_instr = "spiisr+0x009                                   ";
         316 : dbg_instr = "spiisr+0x00a                                   ";
         317 : dbg_instr = "spiisr+0x00b                                   ";
         318 : dbg_instr = "spiisr+0x00c                                   ";
         319 : dbg_instr = "spiisr+0x00d                                   ";
         320 : dbg_instr = "spiisr+0x00e                                   ";
         321 : dbg_instr = "spiisr+0x00f                                   ";
         322 : dbg_instr = "spiisr+0x010                                   ";
         323 : dbg_instr = "spiisr+0x011                                   ";
         324 : dbg_instr = "spiisr+0x012                                   ";
         325 : dbg_instr = "spiisr+0x013                                   ";
         326 : dbg_instr = "spiisr+0x014                                   ";
         327 : dbg_instr = "spiisr+0x015                                   ";
         328 : dbg_instr = "spiisr+0x016                                   ";
         329 : dbg_instr = "spiisr+0x017                                   ";
         330 : dbg_instr = "spiisr+0x018                                   ";
         331 : dbg_instr = "spiisr+0x019                                   ";
         332 : dbg_instr = "spiisr+0x01a                                   ";
         333 : dbg_instr = "spiisr+0x01b                                   ";
         334 : dbg_instr = "spiisr+0x01c                                   ";
         335 : dbg_instr = "spiisr+0x01d                                   ";
         336 : dbg_instr = "spiisr+0x01e                                   ";
         337 : dbg_instr = "spiisr+0x01f                                   ";
         338 : dbg_instr = "spiisr+0x020                                   ";
         339 : dbg_instr = "spiisr+0x021                                   ";
         340 : dbg_instr = "spiisr+0x022                                   ";
         341 : dbg_instr = "spiisr+0x023                                   ";
         342 : dbg_instr = "spiisr+0x024                                   ";
         343 : dbg_instr = "spiisr+0x025                                   ";
         344 : dbg_instr = "spiisr+0x026                                   ";
         345 : dbg_instr = "spiisr+0x027                                   ";
         346 : dbg_instr = "spiisr+0x028                                   ";
         347 : dbg_instr = "spiisr+0x029                                   ";
         348 : dbg_instr = "spiisr+0x02a                                   ";
         349 : dbg_instr = "spiisr+0x02b                                   ";
         350 : dbg_instr = "spiisr+0x02c                                   ";
         351 : dbg_instr = "spiisr+0x02d                                   ";
         352 : dbg_instr = "spiisr+0x02e                                   ";
         353 : dbg_instr = "spiisr+0x02f                                   ";
         354 : dbg_instr = "spiisr+0x030                                   ";
         355 : dbg_instr = "spiisr+0x031                                   ";
         356 : dbg_instr = "spiisr+0x032                                   ";
         357 : dbg_instr = "spiisr+0x033                                   ";
         358 : dbg_instr = "spiisr+0x034                                   ";
         359 : dbg_instr = "spiisr+0x035                                   ";
         360 : dbg_instr = "spiisr+0x036                                   ";
         361 : dbg_instr = "spiisr+0x037                                   ";
         362 : dbg_instr = "spiisr+0x038                                   ";
         363 : dbg_instr = "spiisr+0x039                                   ";
         364 : dbg_instr = "spiisr+0x03a                                   ";
         365 : dbg_instr = "spiisr+0x03b                                   ";
         366 : dbg_instr = "spiisr+0x03c                                   ";
         367 : dbg_instr = "spiisr+0x03d                                   ";
         368 : dbg_instr = "spiisr+0x03e                                   ";
         369 : dbg_instr = "spiisr+0x03f                                   ";
         370 : dbg_instr = "spiisr+0x040                                   ";
         371 : dbg_instr = "spiisr+0x041                                   ";
         372 : dbg_instr = "spiisr+0x042                                   ";
         373 : dbg_instr = "spiisr+0x043                                   ";
         374 : dbg_instr = "spiisr+0x044                                   ";
         375 : dbg_instr = "spiisr+0x045                                   ";
         376 : dbg_instr = "spiisr+0x046                                   ";
         377 : dbg_instr = "spiisr+0x047                                   ";
         378 : dbg_instr = "spiisr+0x048                                   ";
         379 : dbg_instr = "spiisr+0x049                                   ";
         380 : dbg_instr = "spiisr+0x04a                                   ";
         381 : dbg_instr = "spiisr+0x04b                                   ";
         382 : dbg_instr = "spiisr+0x04c                                   ";
         383 : dbg_instr = "spiisr+0x04d                                   ";
         384 : dbg_instr = "spiisr+0x04e                                   ";
         385 : dbg_instr = "spiisr+0x04f                                   ";
         386 : dbg_instr = "spiisr+0x050                                   ";
         387 : dbg_instr = "spiisr+0x051                                   ";
         388 : dbg_instr = "spiisr+0x052                                   ";
         389 : dbg_instr = "spiisr+0x053                                   ";
         390 : dbg_instr = "spiisr+0x054                                   ";
         391 : dbg_instr = "spiisr+0x055                                   ";
         392 : dbg_instr = "spiisr+0x056                                   ";
         393 : dbg_instr = "spiisr+0x057                                   ";
         394 : dbg_instr = "spiisr+0x058                                   ";
         395 : dbg_instr = "spiisr+0x059                                   ";
         396 : dbg_instr = "spiisr+0x05a                                   ";
         397 : dbg_instr = "spiisr+0x05b                                   ";
         398 : dbg_instr = "spiisr+0x05c                                   ";
         399 : dbg_instr = "spiisr+0x05d                                   ";
         400 : dbg_instr = "spiisr+0x05e                                   ";
         401 : dbg_instr = "spiisr+0x05f                                   ";
         402 : dbg_instr = "spiisr+0x060                                   ";
         403 : dbg_instr = "spiisr+0x061                                   ";
         404 : dbg_instr = "spiisr+0x062                                   ";
         405 : dbg_instr = "spiisr+0x063                                   ";
         406 : dbg_instr = "spiisr+0x064                                   ";
         407 : dbg_instr = "spiisr+0x065                                   ";
         408 : dbg_instr = "spiisr+0x066                                   ";
         409 : dbg_instr = "spiisr+0x067                                   ";
         410 : dbg_instr = "spiisr+0x068                                   ";
         411 : dbg_instr = "spiisr+0x069                                   ";
         412 : dbg_instr = "spiisr+0x06a                                   ";
         413 : dbg_instr = "spiisr+0x06b                                   ";
         414 : dbg_instr = "spiisr+0x06c                                   ";
         415 : dbg_instr = "spiisr+0x06d                                   ";
         416 : dbg_instr = "spiisr+0x06e                                   ";
         417 : dbg_instr = "spiisr+0x06f                                   ";
         418 : dbg_instr = "spiisr+0x070                                   ";
         419 : dbg_instr = "spiisr+0x071                                   ";
         420 : dbg_instr = "spiisr+0x072                                   ";
         421 : dbg_instr = "spiisr+0x073                                   ";
         422 : dbg_instr = "spiisr+0x074                                   ";
         423 : dbg_instr = "spiisr+0x075                                   ";
         424 : dbg_instr = "spiisr+0x076                                   ";
         425 : dbg_instr = "spiisr+0x077                                   ";
         426 : dbg_instr = "spiisr+0x078                                   ";
         427 : dbg_instr = "spiisr+0x079                                   ";
         428 : dbg_instr = "spiisr+0x07a                                   ";
         429 : dbg_instr = "spiisr+0x07b                                   ";
         430 : dbg_instr = "spiisr+0x07c                                   ";
         431 : dbg_instr = "spiisr+0x07d                                   ";
         432 : dbg_instr = "spiisr+0x07e                                   ";
         433 : dbg_instr = "spiisr+0x07f                                   ";
         434 : dbg_instr = "spiisr+0x080                                   ";
         435 : dbg_instr = "spiisr+0x081                                   ";
         436 : dbg_instr = "spiisr+0x082                                   ";
         437 : dbg_instr = "spiisr+0x083                                   ";
         438 : dbg_instr = "spiisr+0x084                                   ";
         439 : dbg_instr = "spiisr+0x085                                   ";
         440 : dbg_instr = "spiisr+0x086                                   ";
         441 : dbg_instr = "spiisr+0x087                                   ";
         442 : dbg_instr = "spiisr+0x088                                   ";
         443 : dbg_instr = "spiisr+0x089                                   ";
         444 : dbg_instr = "spiisr+0x08a                                   ";
         445 : dbg_instr = "spiisr+0x08b                                   ";
         446 : dbg_instr = "spiisr+0x08c                                   ";
         447 : dbg_instr = "spiisr+0x08d                                   ";
         448 : dbg_instr = "spiisr+0x08e                                   ";
         449 : dbg_instr = "spiisr+0x08f                                   ";
         450 : dbg_instr = "spiisr+0x090                                   ";
         451 : dbg_instr = "spiisr+0x091                                   ";
         452 : dbg_instr = "spiisr+0x092                                   ";
         453 : dbg_instr = "spiisr+0x093                                   ";
         454 : dbg_instr = "spiisr+0x094                                   ";
         455 : dbg_instr = "spiisr+0x095                                   ";
         456 : dbg_instr = "spiisr+0x096                                   ";
         457 : dbg_instr = "spiisr+0x097                                   ";
         458 : dbg_instr = "spiisr+0x098                                   ";
         459 : dbg_instr = "spiisr+0x099                                   ";
         460 : dbg_instr = "spiisr+0x09a                                   ";
         461 : dbg_instr = "spiisr+0x09b                                   ";
         462 : dbg_instr = "spiisr+0x09c                                   ";
         463 : dbg_instr = "spiisr+0x09d                                   ";
         464 : dbg_instr = "spiisr+0x09e                                   ";
         465 : dbg_instr = "spiisr+0x09f                                   ";
         466 : dbg_instr = "spiisr+0x0a0                                   ";
         467 : dbg_instr = "spiisr+0x0a1                                   ";
         468 : dbg_instr = "spiisr+0x0a2                                   ";
         469 : dbg_instr = "spiisr+0x0a3                                   ";
         470 : dbg_instr = "spiisr+0x0a4                                   ";
         471 : dbg_instr = "spiisr+0x0a5                                   ";
         472 : dbg_instr = "spiisr+0x0a6                                   ";
         473 : dbg_instr = "spiisr+0x0a7                                   ";
         474 : dbg_instr = "spiisr+0x0a8                                   ";
         475 : dbg_instr = "spiisr+0x0a9                                   ";
         476 : dbg_instr = "spiisr+0x0aa                                   ";
         477 : dbg_instr = "spiisr+0x0ab                                   ";
         478 : dbg_instr = "spiisr+0x0ac                                   ";
         479 : dbg_instr = "spiisr+0x0ad                                   ";
         480 : dbg_instr = "spiisr+0x0ae                                   ";
         481 : dbg_instr = "spiisr+0x0af                                   ";
         482 : dbg_instr = "spiisr+0x0b0                                   ";
         483 : dbg_instr = "spiisr+0x0b1                                   ";
         484 : dbg_instr = "spiisr+0x0b2                                   ";
         485 : dbg_instr = "spiisr+0x0b3                                   ";
         486 : dbg_instr = "spiisr+0x0b4                                   ";
         487 : dbg_instr = "spiisr+0x0b5                                   ";
         488 : dbg_instr = "spiisr+0x0b6                                   ";
         489 : dbg_instr = "spiisr+0x0b7                                   ";
         490 : dbg_instr = "spiisr+0x0b8                                   ";
         491 : dbg_instr = "spiisr+0x0b9                                   ";
         492 : dbg_instr = "spiisr+0x0ba                                   ";
         493 : dbg_instr = "spiisr+0x0bb                                   ";
         494 : dbg_instr = "spiisr+0x0bc                                   ";
         495 : dbg_instr = "spiisr+0x0bd                                   ";
         496 : dbg_instr = "spiisr+0x0be                                   ";
         497 : dbg_instr = "spiisr+0x0bf                                   ";
         498 : dbg_instr = "spiisr+0x0c0                                   ";
         499 : dbg_instr = "spiisr+0x0c1                                   ";
         500 : dbg_instr = "spiisr+0x0c2                                   ";
         501 : dbg_instr = "spiisr+0x0c3                                   ";
         502 : dbg_instr = "spiisr+0x0c4                                   ";
         503 : dbg_instr = "spiisr+0x0c5                                   ";
         504 : dbg_instr = "spiisr+0x0c6                                   ";
         505 : dbg_instr = "spiisr+0x0c7                                   ";
         506 : dbg_instr = "spiisr+0x0c8                                   ";
         507 : dbg_instr = "spiisr+0x0c9                                   ";
         508 : dbg_instr = "spiisr+0x0ca                                   ";
         509 : dbg_instr = "spiisr+0x0cb                                   ";
         510 : dbg_instr = "spiisr+0x0cc                                   ";
         511 : dbg_instr = "spiisr+0x0cd                                   ";
         512 : dbg_instr = "spiisr+0x0ce                                   ";
         513 : dbg_instr = "spiisr+0x0cf                                   ";
         514 : dbg_instr = "spiisr+0x0d0                                   ";
         515 : dbg_instr = "spiisr+0x0d1                                   ";
         516 : dbg_instr = "spiisr+0x0d2                                   ";
         517 : dbg_instr = "spiisr+0x0d3                                   ";
         518 : dbg_instr = "spiisr+0x0d4                                   ";
         519 : dbg_instr = "spiisr+0x0d5                                   ";
         520 : dbg_instr = "spiisr+0x0d6                                   ";
         521 : dbg_instr = "spiisr+0x0d7                                   ";
         522 : dbg_instr = "spiisr+0x0d8                                   ";
         523 : dbg_instr = "spiisr+0x0d9                                   ";
         524 : dbg_instr = "spiisr+0x0da                                   ";
         525 : dbg_instr = "spiisr+0x0db                                   ";
         526 : dbg_instr = "spiisr+0x0dc                                   ";
         527 : dbg_instr = "spiisr+0x0dd                                   ";
         528 : dbg_instr = "spiisr+0x0de                                   ";
         529 : dbg_instr = "spiisr+0x0df                                   ";
         530 : dbg_instr = "spiisr+0x0e0                                   ";
         531 : dbg_instr = "spiisr+0x0e1                                   ";
         532 : dbg_instr = "spiisr+0x0e2                                   ";
         533 : dbg_instr = "spiisr+0x0e3                                   ";
         534 : dbg_instr = "spiisr+0x0e4                                   ";
         535 : dbg_instr = "spiisr+0x0e5                                   ";
         536 : dbg_instr = "spiisr+0x0e6                                   ";
         537 : dbg_instr = "spiisr+0x0e7                                   ";
         538 : dbg_instr = "spiisr+0x0e8                                   ";
         539 : dbg_instr = "spiisr+0x0e9                                   ";
         540 : dbg_instr = "spiisr+0x0ea                                   ";
         541 : dbg_instr = "spiisr+0x0eb                                   ";
         542 : dbg_instr = "spiisr+0x0ec                                   ";
         543 : dbg_instr = "spiisr+0x0ed                                   ";
         544 : dbg_instr = "spiisr+0x0ee                                   ";
         545 : dbg_instr = "spiisr+0x0ef                                   ";
         546 : dbg_instr = "spiisr+0x0f0                                   ";
         547 : dbg_instr = "spiisr+0x0f1                                   ";
         548 : dbg_instr = "spiisr+0x0f2                                   ";
         549 : dbg_instr = "spiisr+0x0f3                                   ";
         550 : dbg_instr = "spiisr+0x0f4                                   ";
         551 : dbg_instr = "spiisr+0x0f5                                   ";
         552 : dbg_instr = "spiisr+0x0f6                                   ";
         553 : dbg_instr = "spiisr+0x0f7                                   ";
         554 : dbg_instr = "spiisr+0x0f8                                   ";
         555 : dbg_instr = "spiisr+0x0f9                                   ";
         556 : dbg_instr = "spiisr+0x0fa                                   ";
         557 : dbg_instr = "spiisr+0x0fb                                   ";
         558 : dbg_instr = "spiisr+0x0fc                                   ";
         559 : dbg_instr = "spiisr+0x0fd                                   ";
         560 : dbg_instr = "spiisr+0x0fe                                   ";
         561 : dbg_instr = "spiisr+0x0ff                                   ";
         562 : dbg_instr = "spiisr+0x100                                   ";
         563 : dbg_instr = "spiisr+0x101                                   ";
         564 : dbg_instr = "spiisr+0x102                                   ";
         565 : dbg_instr = "spiisr+0x103                                   ";
         566 : dbg_instr = "spiisr+0x104                                   ";
         567 : dbg_instr = "spiisr+0x105                                   ";
         568 : dbg_instr = "spiisr+0x106                                   ";
         569 : dbg_instr = "spiisr+0x107                                   ";
         570 : dbg_instr = "spiisr+0x108                                   ";
         571 : dbg_instr = "spiisr+0x109                                   ";
         572 : dbg_instr = "spiisr+0x10a                                   ";
         573 : dbg_instr = "spiisr+0x10b                                   ";
         574 : dbg_instr = "spiisr+0x10c                                   ";
         575 : dbg_instr = "spiisr+0x10d                                   ";
         576 : dbg_instr = "spiisr+0x10e                                   ";
         577 : dbg_instr = "spiisr+0x10f                                   ";
         578 : dbg_instr = "spiisr+0x110                                   ";
         579 : dbg_instr = "spiisr+0x111                                   ";
         580 : dbg_instr = "spiisr+0x112                                   ";
         581 : dbg_instr = "spiisr+0x113                                   ";
         582 : dbg_instr = "spiisr+0x114                                   ";
         583 : dbg_instr = "spiisr+0x115                                   ";
         584 : dbg_instr = "spiisr+0x116                                   ";
         585 : dbg_instr = "spiisr+0x117                                   ";
         586 : dbg_instr = "spiisr+0x118                                   ";
         587 : dbg_instr = "spiisr+0x119                                   ";
         588 : dbg_instr = "spiisr+0x11a                                   ";
         589 : dbg_instr = "spiisr+0x11b                                   ";
         590 : dbg_instr = "spiisr+0x11c                                   ";
         591 : dbg_instr = "spiisr+0x11d                                   ";
         592 : dbg_instr = "spiisr+0x11e                                   ";
         593 : dbg_instr = "spiisr+0x11f                                   ";
         594 : dbg_instr = "spiisr+0x120                                   ";
         595 : dbg_instr = "spiisr+0x121                                   ";
         596 : dbg_instr = "spiisr+0x122                                   ";
         597 : dbg_instr = "spiisr+0x123                                   ";
         598 : dbg_instr = "spiisr+0x124                                   ";
         599 : dbg_instr = "spiisr+0x125                                   ";
         600 : dbg_instr = "spiisr+0x126                                   ";
         601 : dbg_instr = "spiisr+0x127                                   ";
         602 : dbg_instr = "spiisr+0x128                                   ";
         603 : dbg_instr = "spiisr+0x129                                   ";
         604 : dbg_instr = "spiisr+0x12a                                   ";
         605 : dbg_instr = "spiisr+0x12b                                   ";
         606 : dbg_instr = "spiisr+0x12c                                   ";
         607 : dbg_instr = "spiisr+0x12d                                   ";
         608 : dbg_instr = "spiisr+0x12e                                   ";
         609 : dbg_instr = "spiisr+0x12f                                   ";
         610 : dbg_instr = "spiisr+0x130                                   ";
         611 : dbg_instr = "spiisr+0x131                                   ";
         612 : dbg_instr = "spiisr+0x132                                   ";
         613 : dbg_instr = "spiisr+0x133                                   ";
         614 : dbg_instr = "spiisr+0x134                                   ";
         615 : dbg_instr = "spiisr+0x135                                   ";
         616 : dbg_instr = "spiisr+0x136                                   ";
         617 : dbg_instr = "spiisr+0x137                                   ";
         618 : dbg_instr = "spiisr+0x138                                   ";
         619 : dbg_instr = "spiisr+0x139                                   ";
         620 : dbg_instr = "spiisr+0x13a                                   ";
         621 : dbg_instr = "spiisr+0x13b                                   ";
         622 : dbg_instr = "spiisr+0x13c                                   ";
         623 : dbg_instr = "spiisr+0x13d                                   ";
         624 : dbg_instr = "spiisr+0x13e                                   ";
         625 : dbg_instr = "spiisr+0x13f                                   ";
         626 : dbg_instr = "spiisr+0x140                                   ";
         627 : dbg_instr = "spiisr+0x141                                   ";
         628 : dbg_instr = "spiisr+0x142                                   ";
         629 : dbg_instr = "spiisr+0x143                                   ";
         630 : dbg_instr = "spiisr+0x144                                   ";
         631 : dbg_instr = "spiisr+0x145                                   ";
         632 : dbg_instr = "spiisr+0x146                                   ";
         633 : dbg_instr = "spiisr+0x147                                   ";
         634 : dbg_instr = "spiisr+0x148                                   ";
         635 : dbg_instr = "spiisr+0x149                                   ";
         636 : dbg_instr = "spiisr+0x14a                                   ";
         637 : dbg_instr = "spiisr+0x14b                                   ";
         638 : dbg_instr = "spiisr+0x14c                                   ";
         639 : dbg_instr = "spiisr+0x14d                                   ";
         640 : dbg_instr = "spiisr+0x14e                                   ";
         641 : dbg_instr = "spiisr+0x14f                                   ";
         642 : dbg_instr = "spiisr+0x150                                   ";
         643 : dbg_instr = "spiisr+0x151                                   ";
         644 : dbg_instr = "spiisr+0x152                                   ";
         645 : dbg_instr = "spiisr+0x153                                   ";
         646 : dbg_instr = "spiisr+0x154                                   ";
         647 : dbg_instr = "spiisr+0x155                                   ";
         648 : dbg_instr = "spiisr+0x156                                   ";
         649 : dbg_instr = "spiisr+0x157                                   ";
         650 : dbg_instr = "spiisr+0x158                                   ";
         651 : dbg_instr = "spiisr+0x159                                   ";
         652 : dbg_instr = "spiisr+0x15a                                   ";
         653 : dbg_instr = "spiisr+0x15b                                   ";
         654 : dbg_instr = "spiisr+0x15c                                   ";
         655 : dbg_instr = "spiisr+0x15d                                   ";
         656 : dbg_instr = "spiisr+0x15e                                   ";
         657 : dbg_instr = "spiisr+0x15f                                   ";
         658 : dbg_instr = "spiisr+0x160                                   ";
         659 : dbg_instr = "spiisr+0x161                                   ";
         660 : dbg_instr = "spiisr+0x162                                   ";
         661 : dbg_instr = "spiisr+0x163                                   ";
         662 : dbg_instr = "spiisr+0x164                                   ";
         663 : dbg_instr = "spiisr+0x165                                   ";
         664 : dbg_instr = "spiisr+0x166                                   ";
         665 : dbg_instr = "spiisr+0x167                                   ";
         666 : dbg_instr = "spiisr+0x168                                   ";
         667 : dbg_instr = "spiisr+0x169                                   ";
         668 : dbg_instr = "spiisr+0x16a                                   ";
         669 : dbg_instr = "spiisr+0x16b                                   ";
         670 : dbg_instr = "spiisr+0x16c                                   ";
         671 : dbg_instr = "spiisr+0x16d                                   ";
         672 : dbg_instr = "spiisr+0x16e                                   ";
         673 : dbg_instr = "spiisr+0x16f                                   ";
         674 : dbg_instr = "spiisr+0x170                                   ";
         675 : dbg_instr = "spiisr+0x171                                   ";
         676 : dbg_instr = "spiisr+0x172                                   ";
         677 : dbg_instr = "spiisr+0x173                                   ";
         678 : dbg_instr = "spiisr+0x174                                   ";
         679 : dbg_instr = "spiisr+0x175                                   ";
         680 : dbg_instr = "spiisr+0x176                                   ";
         681 : dbg_instr = "spiisr+0x177                                   ";
         682 : dbg_instr = "spiisr+0x178                                   ";
         683 : dbg_instr = "spiisr+0x179                                   ";
         684 : dbg_instr = "spiisr+0x17a                                   ";
         685 : dbg_instr = "spiisr+0x17b                                   ";
         686 : dbg_instr = "spiisr+0x17c                                   ";
         687 : dbg_instr = "spiisr+0x17d                                   ";
         688 : dbg_instr = "spiisr+0x17e                                   ";
         689 : dbg_instr = "spiisr+0x17f                                   ";
         690 : dbg_instr = "spiisr+0x180                                   ";
         691 : dbg_instr = "spiisr+0x181                                   ";
         692 : dbg_instr = "spiisr+0x182                                   ";
         693 : dbg_instr = "spiisr+0x183                                   ";
         694 : dbg_instr = "spiisr+0x184                                   ";
         695 : dbg_instr = "spiisr+0x185                                   ";
         696 : dbg_instr = "spiisr+0x186                                   ";
         697 : dbg_instr = "spiisr+0x187                                   ";
         698 : dbg_instr = "spiisr+0x188                                   ";
         699 : dbg_instr = "spiisr+0x189                                   ";
         700 : dbg_instr = "spiisr+0x18a                                   ";
         701 : dbg_instr = "spiisr+0x18b                                   ";
         702 : dbg_instr = "spiisr+0x18c                                   ";
         703 : dbg_instr = "spiisr+0x18d                                   ";
         704 : dbg_instr = "spiisr+0x18e                                   ";
         705 : dbg_instr = "spiisr+0x18f                                   ";
         706 : dbg_instr = "spiisr+0x190                                   ";
         707 : dbg_instr = "spiisr+0x191                                   ";
         708 : dbg_instr = "spiisr+0x192                                   ";
         709 : dbg_instr = "spiisr+0x193                                   ";
         710 : dbg_instr = "spiisr+0x194                                   ";
         711 : dbg_instr = "spiisr+0x195                                   ";
         712 : dbg_instr = "spiisr+0x196                                   ";
         713 : dbg_instr = "spiisr+0x197                                   ";
         714 : dbg_instr = "spiisr+0x198                                   ";
         715 : dbg_instr = "spiisr+0x199                                   ";
         716 : dbg_instr = "spiisr+0x19a                                   ";
         717 : dbg_instr = "spiisr+0x19b                                   ";
         718 : dbg_instr = "spiisr+0x19c                                   ";
         719 : dbg_instr = "spiisr+0x19d                                   ";
         720 : dbg_instr = "spiisr+0x19e                                   ";
         721 : dbg_instr = "spiisr+0x19f                                   ";
         722 : dbg_instr = "spiisr+0x1a0                                   ";
         723 : dbg_instr = "spiisr+0x1a1                                   ";
         724 : dbg_instr = "spiisr+0x1a2                                   ";
         725 : dbg_instr = "spiisr+0x1a3                                   ";
         726 : dbg_instr = "spiisr+0x1a4                                   ";
         727 : dbg_instr = "spiisr+0x1a5                                   ";
         728 : dbg_instr = "spiisr+0x1a6                                   ";
         729 : dbg_instr = "spiisr+0x1a7                                   ";
         730 : dbg_instr = "spiisr+0x1a8                                   ";
         731 : dbg_instr = "spiisr+0x1a9                                   ";
         732 : dbg_instr = "spiisr+0x1aa                                   ";
         733 : dbg_instr = "spiisr+0x1ab                                   ";
         734 : dbg_instr = "spiisr+0x1ac                                   ";
         735 : dbg_instr = "spiisr+0x1ad                                   ";
         736 : dbg_instr = "spiisr+0x1ae                                   ";
         737 : dbg_instr = "spiisr+0x1af                                   ";
         738 : dbg_instr = "spiisr+0x1b0                                   ";
         739 : dbg_instr = "spiisr+0x1b1                                   ";
         740 : dbg_instr = "spiisr+0x1b2                                   ";
         741 : dbg_instr = "spiisr+0x1b3                                   ";
         742 : dbg_instr = "spiisr+0x1b4                                   ";
         743 : dbg_instr = "spiisr+0x1b5                                   ";
         744 : dbg_instr = "spiisr+0x1b6                                   ";
         745 : dbg_instr = "spiisr+0x1b7                                   ";
         746 : dbg_instr = "spiisr+0x1b8                                   ";
         747 : dbg_instr = "spiisr+0x1b9                                   ";
         748 : dbg_instr = "spiisr+0x1ba                                   ";
         749 : dbg_instr = "spiisr+0x1bb                                   ";
         750 : dbg_instr = "spiisr+0x1bc                                   ";
         751 : dbg_instr = "spiisr+0x1bd                                   ";
         752 : dbg_instr = "spiisr+0x1be                                   ";
         753 : dbg_instr = "spiisr+0x1bf                                   ";
         754 : dbg_instr = "spiisr+0x1c0                                   ";
         755 : dbg_instr = "spiisr+0x1c1                                   ";
         756 : dbg_instr = "spiisr+0x1c2                                   ";
         757 : dbg_instr = "spiisr+0x1c3                                   ";
         758 : dbg_instr = "spiisr+0x1c4                                   ";
         759 : dbg_instr = "spiisr+0x1c5                                   ";
         760 : dbg_instr = "spiisr+0x1c6                                   ";
         761 : dbg_instr = "spiisr+0x1c7                                   ";
         762 : dbg_instr = "spiisr+0x1c8                                   ";
         763 : dbg_instr = "spiisr+0x1c9                                   ";
         764 : dbg_instr = "spiisr+0x1ca                                   ";
         765 : dbg_instr = "spiisr+0x1cb                                   ";
         766 : dbg_instr = "spiisr+0x1cc                                   ";
         767 : dbg_instr = "spiisr+0x1cd                                   ";
         768 : dbg_instr = "spiisr+0x1ce                                   ";
         769 : dbg_instr = "spiisr+0x1cf                                   ";
         770 : dbg_instr = "spiisr+0x1d0                                   ";
         771 : dbg_instr = "spiisr+0x1d1                                   ";
         772 : dbg_instr = "spiisr+0x1d2                                   ";
         773 : dbg_instr = "spiisr+0x1d3                                   ";
         774 : dbg_instr = "spiisr+0x1d4                                   ";
         775 : dbg_instr = "spiisr+0x1d5                                   ";
         776 : dbg_instr = "spiisr+0x1d6                                   ";
         777 : dbg_instr = "spiisr+0x1d7                                   ";
         778 : dbg_instr = "spiisr+0x1d8                                   ";
         779 : dbg_instr = "spiisr+0x1d9                                   ";
         780 : dbg_instr = "spiisr+0x1da                                   ";
         781 : dbg_instr = "spiisr+0x1db                                   ";
         782 : dbg_instr = "spiisr+0x1dc                                   ";
         783 : dbg_instr = "spiisr+0x1dd                                   ";
         784 : dbg_instr = "spiisr+0x1de                                   ";
         785 : dbg_instr = "spiisr+0x1df                                   ";
         786 : dbg_instr = "spiisr+0x1e0                                   ";
         787 : dbg_instr = "spiisr+0x1e1                                   ";
         788 : dbg_instr = "spiisr+0x1e2                                   ";
         789 : dbg_instr = "spiisr+0x1e3                                   ";
         790 : dbg_instr = "spiisr+0x1e4                                   ";
         791 : dbg_instr = "spiisr+0x1e5                                   ";
         792 : dbg_instr = "spiisr+0x1e6                                   ";
         793 : dbg_instr = "spiisr+0x1e7                                   ";
         794 : dbg_instr = "spiisr+0x1e8                                   ";
         795 : dbg_instr = "spiisr+0x1e9                                   ";
         796 : dbg_instr = "spiisr+0x1ea                                   ";
         797 : dbg_instr = "spiisr+0x1eb                                   ";
         798 : dbg_instr = "spiisr+0x1ec                                   ";
         799 : dbg_instr = "spiisr+0x1ed                                   ";
         800 : dbg_instr = "spiisr+0x1ee                                   ";
         801 : dbg_instr = "spiisr+0x1ef                                   ";
         802 : dbg_instr = "spiisr+0x1f0                                   ";
         803 : dbg_instr = "spiisr+0x1f1                                   ";
         804 : dbg_instr = "spiisr+0x1f2                                   ";
         805 : dbg_instr = "spiisr+0x1f3                                   ";
         806 : dbg_instr = "spiisr+0x1f4                                   ";
         807 : dbg_instr = "spiisr+0x1f5                                   ";
         808 : dbg_instr = "spiisr+0x1f6                                   ";
         809 : dbg_instr = "spiisr+0x1f7                                   ";
         810 : dbg_instr = "spiisr+0x1f8                                   ";
         811 : dbg_instr = "spiisr+0x1f9                                   ";
         812 : dbg_instr = "spiisr+0x1fa                                   ";
         813 : dbg_instr = "spiisr+0x1fb                                   ";
         814 : dbg_instr = "spiisr+0x1fc                                   ";
         815 : dbg_instr = "spiisr+0x1fd                                   ";
         816 : dbg_instr = "spiisr+0x1fe                                   ";
         817 : dbg_instr = "spiisr+0x1ff                                   ";
         818 : dbg_instr = "spiisr+0x200                                   ";
         819 : dbg_instr = "spiisr+0x201                                   ";
         820 : dbg_instr = "spiisr+0x202                                   ";
         821 : dbg_instr = "spiisr+0x203                                   ";
         822 : dbg_instr = "spiisr+0x204                                   ";
         823 : dbg_instr = "spiisr+0x205                                   ";
         824 : dbg_instr = "spiisr+0x206                                   ";
         825 : dbg_instr = "spiisr+0x207                                   ";
         826 : dbg_instr = "spiisr+0x208                                   ";
         827 : dbg_instr = "spiisr+0x209                                   ";
         828 : dbg_instr = "spiisr+0x20a                                   ";
         829 : dbg_instr = "spiisr+0x20b                                   ";
         830 : dbg_instr = "spiisr+0x20c                                   ";
         831 : dbg_instr = "spiisr+0x20d                                   ";
         832 : dbg_instr = "spiisr+0x20e                                   ";
         833 : dbg_instr = "spiisr+0x20f                                   ";
         834 : dbg_instr = "spiisr+0x210                                   ";
         835 : dbg_instr = "spiisr+0x211                                   ";
         836 : dbg_instr = "spiisr+0x212                                   ";
         837 : dbg_instr = "spiisr+0x213                                   ";
         838 : dbg_instr = "spiisr+0x214                                   ";
         839 : dbg_instr = "spiisr+0x215                                   ";
         840 : dbg_instr = "spiisr+0x216                                   ";
         841 : dbg_instr = "spiisr+0x217                                   ";
         842 : dbg_instr = "spiisr+0x218                                   ";
         843 : dbg_instr = "spiisr+0x219                                   ";
         844 : dbg_instr = "spiisr+0x21a                                   ";
         845 : dbg_instr = "spiisr+0x21b                                   ";
         846 : dbg_instr = "spiisr+0x21c                                   ";
         847 : dbg_instr = "spiisr+0x21d                                   ";
         848 : dbg_instr = "spiisr+0x21e                                   ";
         849 : dbg_instr = "spiisr+0x21f                                   ";
         850 : dbg_instr = "spiisr+0x220                                   ";
         851 : dbg_instr = "spiisr+0x221                                   ";
         852 : dbg_instr = "spiisr+0x222                                   ";
         853 : dbg_instr = "spiisr+0x223                                   ";
         854 : dbg_instr = "spiisr+0x224                                   ";
         855 : dbg_instr = "spiisr+0x225                                   ";
         856 : dbg_instr = "spiisr+0x226                                   ";
         857 : dbg_instr = "spiisr+0x227                                   ";
         858 : dbg_instr = "spiisr+0x228                                   ";
         859 : dbg_instr = "spiisr+0x229                                   ";
         860 : dbg_instr = "spiisr+0x22a                                   ";
         861 : dbg_instr = "spiisr+0x22b                                   ";
         862 : dbg_instr = "spiisr+0x22c                                   ";
         863 : dbg_instr = "spiisr+0x22d                                   ";
         864 : dbg_instr = "spiisr+0x22e                                   ";
         865 : dbg_instr = "spiisr+0x22f                                   ";
         866 : dbg_instr = "spiisr+0x230                                   ";
         867 : dbg_instr = "spiisr+0x231                                   ";
         868 : dbg_instr = "spiisr+0x232                                   ";
         869 : dbg_instr = "spiisr+0x233                                   ";
         870 : dbg_instr = "spiisr+0x234                                   ";
         871 : dbg_instr = "spiisr+0x235                                   ";
         872 : dbg_instr = "spiisr+0x236                                   ";
         873 : dbg_instr = "spiisr+0x237                                   ";
         874 : dbg_instr = "spiisr+0x238                                   ";
         875 : dbg_instr = "spiisr+0x239                                   ";
         876 : dbg_instr = "spiisr+0x23a                                   ";
         877 : dbg_instr = "spiisr+0x23b                                   ";
         878 : dbg_instr = "spiisr+0x23c                                   ";
         879 : dbg_instr = "spiisr+0x23d                                   ";
         880 : dbg_instr = "spiisr+0x23e                                   ";
         881 : dbg_instr = "spiisr+0x23f                                   ";
         882 : dbg_instr = "spiisr+0x240                                   ";
         883 : dbg_instr = "spiisr+0x241                                   ";
         884 : dbg_instr = "spiisr+0x242                                   ";
         885 : dbg_instr = "spiisr+0x243                                   ";
         886 : dbg_instr = "spiisr+0x244                                   ";
         887 : dbg_instr = "spiisr+0x245                                   ";
         888 : dbg_instr = "spiisr+0x246                                   ";
         889 : dbg_instr = "spiisr+0x247                                   ";
         890 : dbg_instr = "spiisr+0x248                                   ";
         891 : dbg_instr = "spiisr+0x249                                   ";
         892 : dbg_instr = "spiisr+0x24a                                   ";
         893 : dbg_instr = "spiisr+0x24b                                   ";
         894 : dbg_instr = "spiisr+0x24c                                   ";
         895 : dbg_instr = "spiisr+0x24d                                   ";
         896 : dbg_instr = "spiisr+0x24e                                   ";
         897 : dbg_instr = "spiisr+0x24f                                   ";
         898 : dbg_instr = "spiisr+0x250                                   ";
         899 : dbg_instr = "spiisr+0x251                                   ";
         900 : dbg_instr = "spiisr+0x252                                   ";
         901 : dbg_instr = "spiisr+0x253                                   ";
         902 : dbg_instr = "spiisr+0x254                                   ";
         903 : dbg_instr = "spiisr+0x255                                   ";
         904 : dbg_instr = "spiisr+0x256                                   ";
         905 : dbg_instr = "spiisr+0x257                                   ";
         906 : dbg_instr = "spiisr+0x258                                   ";
         907 : dbg_instr = "spiisr+0x259                                   ";
         908 : dbg_instr = "spiisr+0x25a                                   ";
         909 : dbg_instr = "spiisr+0x25b                                   ";
         910 : dbg_instr = "spiisr+0x25c                                   ";
         911 : dbg_instr = "spiisr+0x25d                                   ";
         912 : dbg_instr = "spiisr+0x25e                                   ";
         913 : dbg_instr = "spiisr+0x25f                                   ";
         914 : dbg_instr = "spiisr+0x260                                   ";
         915 : dbg_instr = "spiisr+0x261                                   ";
         916 : dbg_instr = "spiisr+0x262                                   ";
         917 : dbg_instr = "spiisr+0x263                                   ";
         918 : dbg_instr = "spiisr+0x264                                   ";
         919 : dbg_instr = "spiisr+0x265                                   ";
         920 : dbg_instr = "spiisr+0x266                                   ";
         921 : dbg_instr = "spiisr+0x267                                   ";
         922 : dbg_instr = "spiisr+0x268                                   ";
         923 : dbg_instr = "spiisr+0x269                                   ";
         924 : dbg_instr = "spiisr+0x26a                                   ";
         925 : dbg_instr = "spiisr+0x26b                                   ";
         926 : dbg_instr = "spiisr+0x26c                                   ";
         927 : dbg_instr = "spiisr+0x26d                                   ";
         928 : dbg_instr = "spiisr+0x26e                                   ";
         929 : dbg_instr = "spiisr+0x26f                                   ";
         930 : dbg_instr = "spiisr+0x270                                   ";
         931 : dbg_instr = "spiisr+0x271                                   ";
         932 : dbg_instr = "spiisr+0x272                                   ";
         933 : dbg_instr = "spiisr+0x273                                   ";
         934 : dbg_instr = "spiisr+0x274                                   ";
         935 : dbg_instr = "spiisr+0x275                                   ";
         936 : dbg_instr = "spiisr+0x276                                   ";
         937 : dbg_instr = "spiisr+0x277                                   ";
         938 : dbg_instr = "spiisr+0x278                                   ";
         939 : dbg_instr = "spiisr+0x279                                   ";
         940 : dbg_instr = "spiisr+0x27a                                   ";
         941 : dbg_instr = "spiisr+0x27b                                   ";
         942 : dbg_instr = "spiisr+0x27c                                   ";
         943 : dbg_instr = "spiisr+0x27d                                   ";
         944 : dbg_instr = "spiisr+0x27e                                   ";
         945 : dbg_instr = "spiisr+0x27f                                   ";
         946 : dbg_instr = "spiisr+0x280                                   ";
         947 : dbg_instr = "spiisr+0x281                                   ";
         948 : dbg_instr = "spiisr+0x282                                   ";
         949 : dbg_instr = "spiisr+0x283                                   ";
         950 : dbg_instr = "spiisr+0x284                                   ";
         951 : dbg_instr = "spiisr+0x285                                   ";
         952 : dbg_instr = "spiisr+0x286                                   ";
         953 : dbg_instr = "spiisr+0x287                                   ";
         954 : dbg_instr = "spiisr+0x288                                   ";
         955 : dbg_instr = "spiisr+0x289                                   ";
         956 : dbg_instr = "spiisr+0x28a                                   ";
         957 : dbg_instr = "spiisr+0x28b                                   ";
         958 : dbg_instr = "spiisr+0x28c                                   ";
         959 : dbg_instr = "spiisr+0x28d                                   ";
         960 : dbg_instr = "spiisr+0x28e                                   ";
         961 : dbg_instr = "spiisr+0x28f                                   ";
         962 : dbg_instr = "spiisr+0x290                                   ";
         963 : dbg_instr = "spiisr+0x291                                   ";
         964 : dbg_instr = "spiisr+0x292                                   ";
         965 : dbg_instr = "spiisr+0x293                                   ";
         966 : dbg_instr = "spiisr+0x294                                   ";
         967 : dbg_instr = "spiisr+0x295                                   ";
         968 : dbg_instr = "spiisr+0x296                                   ";
         969 : dbg_instr = "spiisr+0x297                                   ";
         970 : dbg_instr = "spiisr+0x298                                   ";
         971 : dbg_instr = "spiisr+0x299                                   ";
         972 : dbg_instr = "spiisr+0x29a                                   ";
         973 : dbg_instr = "spiisr+0x29b                                   ";
         974 : dbg_instr = "spiisr+0x29c                                   ";
         975 : dbg_instr = "spiisr+0x29d                                   ";
         976 : dbg_instr = "spiisr+0x29e                                   ";
         977 : dbg_instr = "spiisr+0x29f                                   ";
         978 : dbg_instr = "spiisr+0x2a0                                   ";
         979 : dbg_instr = "spiisr+0x2a1                                   ";
         980 : dbg_instr = "spiisr+0x2a2                                   ";
         981 : dbg_instr = "spiisr+0x2a3                                   ";
         982 : dbg_instr = "spiisr+0x2a4                                   ";
         983 : dbg_instr = "spiisr+0x2a5                                   ";
         984 : dbg_instr = "spiisr+0x2a6                                   ";
         985 : dbg_instr = "spiisr+0x2a7                                   ";
         986 : dbg_instr = "spiisr+0x2a8                                   ";
         987 : dbg_instr = "spiisr+0x2a9                                   ";
         988 : dbg_instr = "spiisr+0x2aa                                   ";
         989 : dbg_instr = "spiisr+0x2ab                                   ";
         990 : dbg_instr = "spiisr+0x2ac                                   ";
         991 : dbg_instr = "spiisr+0x2ad                                   ";
         992 : dbg_instr = "spiisr+0x2ae                                   ";
         993 : dbg_instr = "spiisr+0x2af                                   ";
         994 : dbg_instr = "spiisr+0x2b0                                   ";
         995 : dbg_instr = "spiisr+0x2b1                                   ";
         996 : dbg_instr = "spiisr+0x2b2                                   ";
         997 : dbg_instr = "spiisr+0x2b3                                   ";
         998 : dbg_instr = "spiisr+0x2b4                                   ";
         999 : dbg_instr = "spiisr+0x2b5                                   ";
         1000 : dbg_instr = "spiisr+0x2b6                                   ";
         1001 : dbg_instr = "spiisr+0x2b7                                   ";
         1002 : dbg_instr = "spiisr+0x2b8                                   ";
         1003 : dbg_instr = "spiisr+0x2b9                                   ";
         1004 : dbg_instr = "spiisr+0x2ba                                   ";
         1005 : dbg_instr = "spiisr+0x2bb                                   ";
         1006 : dbg_instr = "spiisr+0x2bc                                   ";
         1007 : dbg_instr = "spiisr+0x2bd                                   ";
         1008 : dbg_instr = "spiisr+0x2be                                   ";
         1009 : dbg_instr = "spiisr+0x2bf                                   ";
         1010 : dbg_instr = "spiisr+0x2c0                                   ";
         1011 : dbg_instr = "spiisr+0x2c1                                   ";
         1012 : dbg_instr = "spiisr+0x2c2                                   ";
         1013 : dbg_instr = "spiisr+0x2c3                                   ";
         1014 : dbg_instr = "spiisr+0x2c4                                   ";
         1015 : dbg_instr = "spiisr+0x2c5                                   ";
         1016 : dbg_instr = "spiisr+0x2c6                                   ";
         1017 : dbg_instr = "spiisr+0x2c7                                   ";
         1018 : dbg_instr = "spiisr+0x2c8                                   ";
         1019 : dbg_instr = "spiisr+0x2c9                                   ";
         1020 : dbg_instr = "spiisr+0x2ca                                   ";
         1021 : dbg_instr = "spiisr+0x2cb                                   ";
         1022 : dbg_instr = "spiisr+0x2cc                                   ";
         1023 : dbg_instr = "spiisr+0x2cd                                   ";
     endcase
   end
// synthesis translate_on


BRAM_TDP_MACRO #(
    .BRAM_SIZE("18Kb"),
    .DOA_REG(0),
    .DOB_REG(0),
    .INIT_A(18'h00000),
    .INIT_B(18'h00000),
    .READ_WIDTH_A(18),
    .WRITE_WIDTH_A(18),
    .READ_WIDTH_B(BRAM_PORT_WIDTH),
    .WRITE_WIDTH_B(BRAM_PORT_WIDTH),
    .SIM_COLLISION_CHECK("ALL"),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    // The following INIT_xx declarations specify the initial contents of the RAM
    // Address 0 to 255
    .INIT_00(256'h500000110085000D000D50001B011A01CFB0AFA0000600051B20200100AE004D),
    .INIT_01(256'hDDFF1A030068B023500060139B01B001B0114A00DF049F00DA02B0011B080011),
    .INIT_02(256'h1A0600685000B023206300461AE400461A065000000B00110AD000111A132024),
    .INIT_03(256'h00461A0600689D01203D1D015000000B00110AD000111A122037DDFF1A020046),
    .INIT_04(256'hF0181000193F202C00101A05B023202C0011B023211A000B00110AD000111AE3),
    .INIT_05(256'h0AD000111ADC2060DDFF1AD800461A06006850009C209B219A229D235000006F),
    .INIT_06(256'hB02350009901EA909901EB909901EC9021221ADC6067DD001A16B023000B0011),
    .INIT_07(256'hAC901901008120461A9900461AF000461A66B023500060719F01B021B0311F08),
    .INIT_08(256'hDF10DF11FA181A005F08208CDA001F025000AA9019015000AB90190100855000),
    .INIT_09(256'hDB241B01CAB01B201AFF202C007D006C0011006C0011006C00101A9FB0235000),
    .INIT_0A(256'h700E90105000011601171A1001171A0801171A1401171A0C011601171A04609D),
    .INIT_0B(256'h3FEE0F00901E208C1F0620BDD100A0B4D024100161F08F001100101E5000300E),
    .INIT_0C(256'h011AE0CB910100119A3011FF002E60D1D00230EF1DFF60C6D010005260DADF02),
    .INIT_0D(256'hD004005260E4DFD83FFB0F00208C1F02B023E0D39101DA30001111FF001C2088),
    .INIT_0E(256'h003A005260F1D0E3208C1F02DA20DB21DC22009160ECD09E208800571DFF60E2),
    .INIT_0F(256'h1F02FF181F016101FD42FA79FB65DC3300526103D0FE2088002760F5D0E42088),

    // Address 256 to 511
    .INIT_10(256'h1F02FD17FA16FB15FC140052208C1F06610ADA00BA186113D0FF208C1F06208E),
    .INIT_11(256'h00461A04006C01221A00B0235000B00400031A000116208C1F06209BDF10DF11),
    .INIT_12(256'hBE00BD009C015000612D3A0100491C005D084E084D0E4E084D0E0EA050000085),
    .INIT_13(256'h10001000100010001000100010001000100010009001DF081F0100765000E129),
    .INIT_14(256'h1000100010001000100010001000100010001000100010001000100010001000),
    .INIT_15(256'h1000100010001000100010001000100010001000100010001000100010001000),
    .INIT_16(256'h1000100010001000100010001000100010001000100010001000100010001000),
    .INIT_17(256'h1000100010001000100010001000100010001000100010001000100010001000),
    .INIT_18(256'h1000100010001000100010001000100010001000100010001000100010001000),
    .INIT_19(256'h1000100010001000100010001000100010001000100010001000100010001000),
    .INIT_1A(256'h1000100010001000100010001000100010001000100010001000100010001000),
    .INIT_1B(256'h1000100010001000100010001000100010001000100010001000100010001000),
    .INIT_1C(256'h1000100010001000100010001000100010001000100010001000100010001000),
    .INIT_1D(256'h1000100010001000100010001000100010001000100010001000100010001000),
    .INIT_1E(256'h1000100010001000100010001000100010001000100010001000100010001000),
    .INIT_1F(256'h2132100010001000100010001000100010001000100010001000100010001000),

    // Address 512 to 767
    .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),

    // Address 768 to 1023
    .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),

    // The next set of INITP_xx are for the parity bits
    // Address 0 to 255
    .INITP_00(256'h1A222B68A6668D2A2348A00A828AAA8889DA88D22AA22A234AB690A2AAA58A2A),
    .INITP_01(256'h2355B6B6AD8AADA32D08B68AB60B432D0237500C0A8888A3582AAA8AA834861A),

    // Address 256 to 511
    .INITP_02(256'h0000000000000000000000000000000000000A2B56C8154A8A2A8A2A2AA8D362),
    .INITP_03(256'h8000000000000000000000000000000000000000000000000000000000000000),

    // Address 512 to 767
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),

    // Address 768 to 1023
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),

    // Output value upon SSR assertion
    .SRVAL_A(18'h000000),
    .SRVAL_B({BRAM_PORT_WIDTH{1'b0}})
) ramdp_1024_x_18(
    .DIA (18'h00000),
    .ENA (enable),
    .WEA ({BRAM_WE_WIDTH{1'b0}}),
    .RSTA(1'b0),
    .CLKA (clk),
    .ADDRA (address),
    // swizzle the parity bits into their proper place
    .DOA ({instruction[17],instruction[15:8],instruction[16],instruction[7:0]}),
    .DIB (bram_dat_i),
    // it's your OWN damn job to deswizzle outside this module
    .DOB (bram_dat_o),
    .ENB (bram_en_i),
    .WEB ({BRAM_WE_WIDTH{bram_we_i}}),
    .RSTB(1'b0),
    .CLKB (clk),
    .ADDRB(bram_adr_i)
);

endmodule
