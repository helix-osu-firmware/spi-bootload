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
 * create : Thu Apr  8 15:12:26 2021
 * modify : Thu Apr  8 15:12:26 2021
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
         101 : dbg_instr = "push3                                          ";
         102 : dbg_instr = "push3+0x001                                    ";
         103 : dbg_instr = "push2                                          ";
         104 : dbg_instr = "push2+0x001                                    ";
         105 : dbg_instr = "push1                                          ";
         106 : dbg_instr = "push1+0x001                                    ";
         107 : dbg_instr = "push1+0x002                                    ";
         108 : dbg_instr = "SPI_STARTUP_initialize                         ";
         109 : dbg_instr = "SPI_STARTUP_initialize+0x001                   ";
         110 : dbg_instr = "SPI_STARTUP_initialize+0x002                   ";
         111 : dbg_instr = "SPI_STARTUP_initialize+0x003                   ";
         112 : dbg_instr = "SPI_STARTUP_initialize+0x004                   ";
         113 : dbg_instr = "SPI_STARTUP_initialize+0x005                   ";
         114 : dbg_instr = "SPI_STARTUP_initialize+0x006                   ";
         115 : dbg_instr = "SPI_Flash_reset                                ";
         116 : dbg_instr = "SPI_Flash_reset+0x001                          ";
         117 : dbg_instr = "SPI_Flash_reset+0x002                          ";
         118 : dbg_instr = "SPI_Flash_reset+0x003                          ";
         119 : dbg_instr = "SPI_Flash_reset+0x004                          ";
         120 : dbg_instr = "SPI_Flash_reset+0x005                          ";
         121 : dbg_instr = "SPI_Flash_reset+0x006                          ";
         122 : dbg_instr = "pop3                                           ";
         123 : dbg_instr = "pop3+0x001                                     ";
         124 : dbg_instr = "pop3+0x002                                     ";
         125 : dbg_instr = "pop3+0x003                                     ";
         126 : dbg_instr = "pop2                                           ";
         127 : dbg_instr = "pop2+0x001                                     ";
         128 : dbg_instr = "pop2+0x002                                     ";
         129 : dbg_instr = "pop2+0x003                                     ";
         130 : dbg_instr = "pop1                                           ";
         131 : dbg_instr = "pop1+0x001                                     ";
         132 : dbg_instr = "pop1+0x002                                     ";
         133 : dbg_instr = "command_complete_with_timeout                  ";
         134 : dbg_instr = "command_complete_with_timeout+0x001            ";
         135 : dbg_instr = "command_complete_with_timeout+0x002            ";
         136 : dbg_instr = "command_complete_with_timeout+0x003            ";
         137 : dbg_instr = "command_finish                                 ";
         138 : dbg_instr = "command_finish+0x001                           ";
         139 : dbg_instr = "command_finish_nolock                          ";
         140 : dbg_instr = "command_finish_nolock+0x001                    ";
         141 : dbg_instr = "command_finish_nolock+0x002                    ";
         142 : dbg_instr = "SPI_Flash_read_ID                              ";
         143 : dbg_instr = "SPI_Flash_read_ID+0x001                        ";
         144 : dbg_instr = "SPI_Flash_read_ID+0x002                        ";
         145 : dbg_instr = "SPI_Flash_read_ID+0x003                        ";
         146 : dbg_instr = "SPI_Flash_read_ID+0x004                        ";
         147 : dbg_instr = "SPI_Flash_read_ID+0x005                        ";
         148 : dbg_instr = "SPI_Flash_read_ID+0x006                        ";
         149 : dbg_instr = "SPI_Flash_read_ID+0x007                        ";
         150 : dbg_instr = "SPI_Flash_read_ID+0x008                        ";
         151 : dbg_instr = "SPI_Flash_read_ID+0x009                        ";
         152 : dbg_instr = "ICAP_reboot                                    ";
         153 : dbg_instr = "ICAP_reboot+0x001                              ";
         154 : dbg_instr = "ICAP_reboot+0x002                              ";
         155 : dbg_instr = "ICAP_reboot+0x003                              ";
         156 : dbg_instr = "ICAP_reboot+0x004                              ";
         157 : dbg_instr = "ICAP_reboot+0x005                              ";
         158 : dbg_instr = "ICAP_reboot+0x006                              ";
         159 : dbg_instr = "ICAP_reboot+0x007                              ";
         160 : dbg_instr = "ICAP_reboot+0x008                              ";
         161 : dbg_instr = "ICAP_reboot+0x009                              ";
         162 : dbg_instr = "ICAP_reboot+0x00a                              ";
         163 : dbg_instr = "ICAP_reboot+0x00b                              ";
         164 : dbg_instr = "ICAP_reboot+0x00c                              ";
         165 : dbg_instr = "ICAP_reboot+0x00d                              ";
         166 : dbg_instr = "ICAP_reboot+0x00e                              ";
         167 : dbg_instr = "ICAP_reboot+0x00f                              ";
         168 : dbg_instr = "ICAP_reboot+0x010                              ";
         169 : dbg_instr = "ICAP_reboot+0x011                              ";
         170 : dbg_instr = "ICAP_reboot+0x012                              ";
         171 : dbg_instr = "check_command                                  ";
         172 : dbg_instr = "check_command+0x001                            ";
         173 : dbg_instr = "check_command+0x002                            ";
         174 : dbg_instr = "check_command+0x003                            ";
         175 : dbg_instr = "check_command+0x004                            ";
         176 : dbg_instr = "check_command+0x005                            ";
         177 : dbg_instr = "check_command+0x006                            ";
         178 : dbg_instr = "check_command+0x007                            ";
         179 : dbg_instr = "check_command+0x008                            ";
         180 : dbg_instr = "check_command+0x009                            ";
         181 : dbg_instr = "check_command+0x00a                            ";
         182 : dbg_instr = "check_command+0x00b                            ";
         183 : dbg_instr = "check_command+0x00c                            ";
         184 : dbg_instr = "check_command+0x00d                            ";
         185 : dbg_instr = "check_command+0x00e                            ";
         186 : dbg_instr = "check_command+0x00f                            ";
         187 : dbg_instr = "check_command+0x010                            ";
         188 : dbg_instr = "check_command+0x011                            ";
         189 : dbg_instr = "check_command+0x012                            ";
         190 : dbg_instr = "check_command+0x013                            ";
         191 : dbg_instr = "check_command+0x014                            ";
         192 : dbg_instr = "check_command+0x015                            ";
         193 : dbg_instr = "check_command+0x016                            ";
         194 : dbg_instr = "check_command+0x017                            ";
         195 : dbg_instr = "check_command+0x018                            ";
         196 : dbg_instr = "check_command+0x019                            ";
         197 : dbg_instr = "check_command+0x01a                            ";
         198 : dbg_instr = "check_command+0x01b                            ";
         199 : dbg_instr = "check_command+0x01c                            ";
         200 : dbg_instr = "check_command+0x01d                            ";
         201 : dbg_instr = "check_command+0x01e                            ";
         202 : dbg_instr = "check_command+0x01f                            ";
         203 : dbg_instr = "check_command+0x020                            ";
         204 : dbg_instr = "check_command+0x021                            ";
         205 : dbg_instr = "check_command+0x022                            ";
         206 : dbg_instr = "check_command+0x023                            ";
         207 : dbg_instr = "check_command+0x024                            ";
         208 : dbg_instr = "check_command+0x025                            ";
         209 : dbg_instr = "check_command+0x026                            ";
         210 : dbg_instr = "check_command+0x027                            ";
         211 : dbg_instr = "check_command+0x028                            ";
         212 : dbg_instr = "check_command+0x029                            ";
         213 : dbg_instr = "check_command+0x02a                            ";
         214 : dbg_instr = "check_command+0x02b                            ";
         215 : dbg_instr = "check_command+0x02c                            ";
         216 : dbg_instr = "check_command+0x02d                            ";
         217 : dbg_instr = "check_command+0x02e                            ";
         218 : dbg_instr = "check_command+0x02f                            ";
         219 : dbg_instr = "check_command+0x030                            ";
         220 : dbg_instr = "check_command+0x031                            ";
         221 : dbg_instr = "check_command+0x032                            ";
         222 : dbg_instr = "check_command+0x033                            ";
         223 : dbg_instr = "check_command+0x034                            ";
         224 : dbg_instr = "check_command+0x035                            ";
         225 : dbg_instr = "check_command+0x036                            ";
         226 : dbg_instr = "check_command+0x037                            ";
         227 : dbg_instr = "check_command+0x038                            ";
         228 : dbg_instr = "check_command+0x039                            ";
         229 : dbg_instr = "check_command+0x03a                            ";
         230 : dbg_instr = "check_command+0x03b                            ";
         231 : dbg_instr = "check_command+0x03c                            ";
         232 : dbg_instr = "check_command+0x03d                            ";
         233 : dbg_instr = "check_command+0x03e                            ";
         234 : dbg_instr = "check_command+0x03f                            ";
         235 : dbg_instr = "check_command+0x040                            ";
         236 : dbg_instr = "check_command+0x041                            ";
         237 : dbg_instr = "check_command+0x042                            ";
         238 : dbg_instr = "check_command+0x043                            ";
         239 : dbg_instr = "check_command+0x044                            ";
         240 : dbg_instr = "check_command+0x045                            ";
         241 : dbg_instr = "check_command+0x046                            ";
         242 : dbg_instr = "check_command+0x047                            ";
         243 : dbg_instr = "check_command+0x048                            ";
         244 : dbg_instr = "check_command+0x049                            ";
         245 : dbg_instr = "check_command+0x04a                            ";
         246 : dbg_instr = "check_command+0x04b                            ";
         247 : dbg_instr = "check_command+0x04c                            ";
         248 : dbg_instr = "check_command+0x04d                            ";
         249 : dbg_instr = "check_command+0x04e                            ";
         250 : dbg_instr = "check_command+0x04f                            ";
         251 : dbg_instr = "check_command+0x050                            ";
         252 : dbg_instr = "check_command+0x051                            ";
         253 : dbg_instr = "check_command+0x052                            ";
         254 : dbg_instr = "check_command+0x053                            ";
         255 : dbg_instr = "check_command+0x054                            ";
         256 : dbg_instr = "check_command+0x055                            ";
         257 : dbg_instr = "check_command+0x056                            ";
         258 : dbg_instr = "check_command+0x057                            ";
         259 : dbg_instr = "check_command+0x058                            ";
         260 : dbg_instr = "check_command+0x059                            ";
         261 : dbg_instr = "check_command+0x05a                            ";
         262 : dbg_instr = "check_command+0x05b                            ";
         263 : dbg_instr = "check_command+0x05c                            ";
         264 : dbg_instr = "check_command+0x05d                            ";
         265 : dbg_instr = "check_command+0x05e                            ";
         266 : dbg_instr = "check_command+0x05f                            ";
         267 : dbg_instr = "check_command+0x060                            ";
         268 : dbg_instr = "check_command+0x061                            ";
         269 : dbg_instr = "check_command+0x062                            ";
         270 : dbg_instr = "check_command+0x063                            ";
         271 : dbg_instr = "check_command+0x064                            ";
         272 : dbg_instr = "check_command+0x065                            ";
         273 : dbg_instr = "check_command+0x066                            ";
         274 : dbg_instr = "ICAP_noop2                                     ";
         275 : dbg_instr = "ICAP_noop                                      ";
         276 : dbg_instr = "ICAP_write_word                                ";
         277 : dbg_instr = "ICAP_write_word+0x001                          ";
         278 : dbg_instr = "ICAP_write_word+0x002                          ";
         279 : dbg_instr = "SPI_Flash_write_complete                       ";
         280 : dbg_instr = "SPI_Flash_write_complete+0x001                 ";
         281 : dbg_instr = "SPI_Flash_write_complete+0x002                 ";
         282 : dbg_instr = "SPI_Flash_write_complete+0x003                 ";
         283 : dbg_instr = "SPI_Flash_write_complete+0x004                 ";
         284 : dbg_instr = "SPI_Flash_write_complete+0x005                 ";
         285 : dbg_instr = "SPI_Flash_write_complete+0x006                 ";
         286 : dbg_instr = "SPI_Flash_write_complete+0x007                 ";
         287 : dbg_instr = "SPI_Flash_wait_WIP                             ";
         288 : dbg_instr = "SPI_Flash_wait_WIP+0x001                       ";
         289 : dbg_instr = "SPI_Flash_wait_WIP+0x002                       ";
         290 : dbg_instr = "SPI_Flash_wait_WIP+0x003                       ";
         291 : dbg_instr = "SPI_Flash_wait_WIP+0x004                       ";
         292 : dbg_instr = "SPI_Flash_wait_WIP+0x005                       ";
         293 : dbg_instr = "SPI_Flash_wait_WIP+0x006                       ";
         294 : dbg_instr = "SPI_Flash_wait_WIP+0x007                       ";
         295 : dbg_instr = "SPI_Flash_wait_WIP+0x008                       ";
         296 : dbg_instr = "SPI_Flash_wait_WIP+0x009                       ";
         297 : dbg_instr = "SPI_Flash_wait_WIP+0x00a                       ";
         298 : dbg_instr = "SPI_Flash_wait_WIP+0x00b                       ";
         299 : dbg_instr = "SPI_Flash_wait_WIP+0x00c                       ";
         300 : dbg_instr = "SPI_Flash_wait_WIP+0x00d                       ";
         301 : dbg_instr = "SPI_Flash_wait_WIP+0x00e                       ";
         302 : dbg_instr = "SPI_Flash_wait_WIP+0x00f                       ";
         303 : dbg_instr = "SPI_Flash_wait_WIP+0x010                       ";
         304 : dbg_instr = "spiisr                                         ";
         305 : dbg_instr = "spiisr+0x001                                   ";
         306 : dbg_instr = "spiisr+0x002                                   ";
         307 : dbg_instr = "spiisr+0x003                                   ";
         308 : dbg_instr = "spiisr+0x004                                   ";
         309 : dbg_instr = "spiisr+0x005                                   ";
         310 : dbg_instr = "spiisr+0x006                                   ";
         311 : dbg_instr = "spiisr+0x007                                   ";
         312 : dbg_instr = "spiisr+0x008                                   ";
         313 : dbg_instr = "spiisr+0x009                                   ";
         314 : dbg_instr = "spiisr+0x00a                                   ";
         315 : dbg_instr = "spiisr+0x00b                                   ";
         316 : dbg_instr = "spiisr+0x00c                                   ";
         317 : dbg_instr = "spiisr+0x00d                                   ";
         318 : dbg_instr = "spiisr+0x00e                                   ";
         319 : dbg_instr = "spiisr+0x00f                                   ";
         320 : dbg_instr = "spiisr+0x010                                   ";
         321 : dbg_instr = "spiisr+0x011                                   ";
         322 : dbg_instr = "spiisr+0x012                                   ";
         323 : dbg_instr = "spiisr+0x013                                   ";
         324 : dbg_instr = "spiisr+0x014                                   ";
         325 : dbg_instr = "spiisr+0x015                                   ";
         326 : dbg_instr = "spiisr+0x016                                   ";
         327 : dbg_instr = "spiisr+0x017                                   ";
         328 : dbg_instr = "spiisr+0x018                                   ";
         329 : dbg_instr = "spiisr+0x019                                   ";
         330 : dbg_instr = "spiisr+0x01a                                   ";
         331 : dbg_instr = "spiisr+0x01b                                   ";
         332 : dbg_instr = "spiisr+0x01c                                   ";
         333 : dbg_instr = "spiisr+0x01d                                   ";
         334 : dbg_instr = "spiisr+0x01e                                   ";
         335 : dbg_instr = "spiisr+0x01f                                   ";
         336 : dbg_instr = "spiisr+0x020                                   ";
         337 : dbg_instr = "spiisr+0x021                                   ";
         338 : dbg_instr = "spiisr+0x022                                   ";
         339 : dbg_instr = "spiisr+0x023                                   ";
         340 : dbg_instr = "spiisr+0x024                                   ";
         341 : dbg_instr = "spiisr+0x025                                   ";
         342 : dbg_instr = "spiisr+0x026                                   ";
         343 : dbg_instr = "spiisr+0x027                                   ";
         344 : dbg_instr = "spiisr+0x028                                   ";
         345 : dbg_instr = "spiisr+0x029                                   ";
         346 : dbg_instr = "spiisr+0x02a                                   ";
         347 : dbg_instr = "spiisr+0x02b                                   ";
         348 : dbg_instr = "spiisr+0x02c                                   ";
         349 : dbg_instr = "spiisr+0x02d                                   ";
         350 : dbg_instr = "spiisr+0x02e                                   ";
         351 : dbg_instr = "spiisr+0x02f                                   ";
         352 : dbg_instr = "spiisr+0x030                                   ";
         353 : dbg_instr = "spiisr+0x031                                   ";
         354 : dbg_instr = "spiisr+0x032                                   ";
         355 : dbg_instr = "spiisr+0x033                                   ";
         356 : dbg_instr = "spiisr+0x034                                   ";
         357 : dbg_instr = "spiisr+0x035                                   ";
         358 : dbg_instr = "spiisr+0x036                                   ";
         359 : dbg_instr = "spiisr+0x037                                   ";
         360 : dbg_instr = "spiisr+0x038                                   ";
         361 : dbg_instr = "spiisr+0x039                                   ";
         362 : dbg_instr = "spiisr+0x03a                                   ";
         363 : dbg_instr = "spiisr+0x03b                                   ";
         364 : dbg_instr = "spiisr+0x03c                                   ";
         365 : dbg_instr = "spiisr+0x03d                                   ";
         366 : dbg_instr = "spiisr+0x03e                                   ";
         367 : dbg_instr = "spiisr+0x03f                                   ";
         368 : dbg_instr = "spiisr+0x040                                   ";
         369 : dbg_instr = "spiisr+0x041                                   ";
         370 : dbg_instr = "spiisr+0x042                                   ";
         371 : dbg_instr = "spiisr+0x043                                   ";
         372 : dbg_instr = "spiisr+0x044                                   ";
         373 : dbg_instr = "spiisr+0x045                                   ";
         374 : dbg_instr = "spiisr+0x046                                   ";
         375 : dbg_instr = "spiisr+0x047                                   ";
         376 : dbg_instr = "spiisr+0x048                                   ";
         377 : dbg_instr = "spiisr+0x049                                   ";
         378 : dbg_instr = "spiisr+0x04a                                   ";
         379 : dbg_instr = "spiisr+0x04b                                   ";
         380 : dbg_instr = "spiisr+0x04c                                   ";
         381 : dbg_instr = "spiisr+0x04d                                   ";
         382 : dbg_instr = "spiisr+0x04e                                   ";
         383 : dbg_instr = "spiisr+0x04f                                   ";
         384 : dbg_instr = "spiisr+0x050                                   ";
         385 : dbg_instr = "spiisr+0x051                                   ";
         386 : dbg_instr = "spiisr+0x052                                   ";
         387 : dbg_instr = "spiisr+0x053                                   ";
         388 : dbg_instr = "spiisr+0x054                                   ";
         389 : dbg_instr = "spiisr+0x055                                   ";
         390 : dbg_instr = "spiisr+0x056                                   ";
         391 : dbg_instr = "spiisr+0x057                                   ";
         392 : dbg_instr = "spiisr+0x058                                   ";
         393 : dbg_instr = "spiisr+0x059                                   ";
         394 : dbg_instr = "spiisr+0x05a                                   ";
         395 : dbg_instr = "spiisr+0x05b                                   ";
         396 : dbg_instr = "spiisr+0x05c                                   ";
         397 : dbg_instr = "spiisr+0x05d                                   ";
         398 : dbg_instr = "spiisr+0x05e                                   ";
         399 : dbg_instr = "spiisr+0x05f                                   ";
         400 : dbg_instr = "spiisr+0x060                                   ";
         401 : dbg_instr = "spiisr+0x061                                   ";
         402 : dbg_instr = "spiisr+0x062                                   ";
         403 : dbg_instr = "spiisr+0x063                                   ";
         404 : dbg_instr = "spiisr+0x064                                   ";
         405 : dbg_instr = "spiisr+0x065                                   ";
         406 : dbg_instr = "spiisr+0x066                                   ";
         407 : dbg_instr = "spiisr+0x067                                   ";
         408 : dbg_instr = "spiisr+0x068                                   ";
         409 : dbg_instr = "spiisr+0x069                                   ";
         410 : dbg_instr = "spiisr+0x06a                                   ";
         411 : dbg_instr = "spiisr+0x06b                                   ";
         412 : dbg_instr = "spiisr+0x06c                                   ";
         413 : dbg_instr = "spiisr+0x06d                                   ";
         414 : dbg_instr = "spiisr+0x06e                                   ";
         415 : dbg_instr = "spiisr+0x06f                                   ";
         416 : dbg_instr = "spiisr+0x070                                   ";
         417 : dbg_instr = "spiisr+0x071                                   ";
         418 : dbg_instr = "spiisr+0x072                                   ";
         419 : dbg_instr = "spiisr+0x073                                   ";
         420 : dbg_instr = "spiisr+0x074                                   ";
         421 : dbg_instr = "spiisr+0x075                                   ";
         422 : dbg_instr = "spiisr+0x076                                   ";
         423 : dbg_instr = "spiisr+0x077                                   ";
         424 : dbg_instr = "spiisr+0x078                                   ";
         425 : dbg_instr = "spiisr+0x079                                   ";
         426 : dbg_instr = "spiisr+0x07a                                   ";
         427 : dbg_instr = "spiisr+0x07b                                   ";
         428 : dbg_instr = "spiisr+0x07c                                   ";
         429 : dbg_instr = "spiisr+0x07d                                   ";
         430 : dbg_instr = "spiisr+0x07e                                   ";
         431 : dbg_instr = "spiisr+0x07f                                   ";
         432 : dbg_instr = "spiisr+0x080                                   ";
         433 : dbg_instr = "spiisr+0x081                                   ";
         434 : dbg_instr = "spiisr+0x082                                   ";
         435 : dbg_instr = "spiisr+0x083                                   ";
         436 : dbg_instr = "spiisr+0x084                                   ";
         437 : dbg_instr = "spiisr+0x085                                   ";
         438 : dbg_instr = "spiisr+0x086                                   ";
         439 : dbg_instr = "spiisr+0x087                                   ";
         440 : dbg_instr = "spiisr+0x088                                   ";
         441 : dbg_instr = "spiisr+0x089                                   ";
         442 : dbg_instr = "spiisr+0x08a                                   ";
         443 : dbg_instr = "spiisr+0x08b                                   ";
         444 : dbg_instr = "spiisr+0x08c                                   ";
         445 : dbg_instr = "spiisr+0x08d                                   ";
         446 : dbg_instr = "spiisr+0x08e                                   ";
         447 : dbg_instr = "spiisr+0x08f                                   ";
         448 : dbg_instr = "spiisr+0x090                                   ";
         449 : dbg_instr = "spiisr+0x091                                   ";
         450 : dbg_instr = "spiisr+0x092                                   ";
         451 : dbg_instr = "spiisr+0x093                                   ";
         452 : dbg_instr = "spiisr+0x094                                   ";
         453 : dbg_instr = "spiisr+0x095                                   ";
         454 : dbg_instr = "spiisr+0x096                                   ";
         455 : dbg_instr = "spiisr+0x097                                   ";
         456 : dbg_instr = "spiisr+0x098                                   ";
         457 : dbg_instr = "spiisr+0x099                                   ";
         458 : dbg_instr = "spiisr+0x09a                                   ";
         459 : dbg_instr = "spiisr+0x09b                                   ";
         460 : dbg_instr = "spiisr+0x09c                                   ";
         461 : dbg_instr = "spiisr+0x09d                                   ";
         462 : dbg_instr = "spiisr+0x09e                                   ";
         463 : dbg_instr = "spiisr+0x09f                                   ";
         464 : dbg_instr = "spiisr+0x0a0                                   ";
         465 : dbg_instr = "spiisr+0x0a1                                   ";
         466 : dbg_instr = "spiisr+0x0a2                                   ";
         467 : dbg_instr = "spiisr+0x0a3                                   ";
         468 : dbg_instr = "spiisr+0x0a4                                   ";
         469 : dbg_instr = "spiisr+0x0a5                                   ";
         470 : dbg_instr = "spiisr+0x0a6                                   ";
         471 : dbg_instr = "spiisr+0x0a7                                   ";
         472 : dbg_instr = "spiisr+0x0a8                                   ";
         473 : dbg_instr = "spiisr+0x0a9                                   ";
         474 : dbg_instr = "spiisr+0x0aa                                   ";
         475 : dbg_instr = "spiisr+0x0ab                                   ";
         476 : dbg_instr = "spiisr+0x0ac                                   ";
         477 : dbg_instr = "spiisr+0x0ad                                   ";
         478 : dbg_instr = "spiisr+0x0ae                                   ";
         479 : dbg_instr = "spiisr+0x0af                                   ";
         480 : dbg_instr = "spiisr+0x0b0                                   ";
         481 : dbg_instr = "spiisr+0x0b1                                   ";
         482 : dbg_instr = "spiisr+0x0b2                                   ";
         483 : dbg_instr = "spiisr+0x0b3                                   ";
         484 : dbg_instr = "spiisr+0x0b4                                   ";
         485 : dbg_instr = "spiisr+0x0b5                                   ";
         486 : dbg_instr = "spiisr+0x0b6                                   ";
         487 : dbg_instr = "spiisr+0x0b7                                   ";
         488 : dbg_instr = "spiisr+0x0b8                                   ";
         489 : dbg_instr = "spiisr+0x0b9                                   ";
         490 : dbg_instr = "spiisr+0x0ba                                   ";
         491 : dbg_instr = "spiisr+0x0bb                                   ";
         492 : dbg_instr = "spiisr+0x0bc                                   ";
         493 : dbg_instr = "spiisr+0x0bd                                   ";
         494 : dbg_instr = "spiisr+0x0be                                   ";
         495 : dbg_instr = "spiisr+0x0bf                                   ";
         496 : dbg_instr = "spiisr+0x0c0                                   ";
         497 : dbg_instr = "spiisr+0x0c1                                   ";
         498 : dbg_instr = "spiisr+0x0c2                                   ";
         499 : dbg_instr = "spiisr+0x0c3                                   ";
         500 : dbg_instr = "spiisr+0x0c4                                   ";
         501 : dbg_instr = "spiisr+0x0c5                                   ";
         502 : dbg_instr = "spiisr+0x0c6                                   ";
         503 : dbg_instr = "spiisr+0x0c7                                   ";
         504 : dbg_instr = "spiisr+0x0c8                                   ";
         505 : dbg_instr = "spiisr+0x0c9                                   ";
         506 : dbg_instr = "spiisr+0x0ca                                   ";
         507 : dbg_instr = "spiisr+0x0cb                                   ";
         508 : dbg_instr = "spiisr+0x0cc                                   ";
         509 : dbg_instr = "spiisr+0x0cd                                   ";
         510 : dbg_instr = "spiisr+0x0ce                                   ";
         511 : dbg_instr = "spiisr+0x0cf                                   ";
         512 : dbg_instr = "spiisr+0x0d0                                   ";
         513 : dbg_instr = "spiisr+0x0d1                                   ";
         514 : dbg_instr = "spiisr+0x0d2                                   ";
         515 : dbg_instr = "spiisr+0x0d3                                   ";
         516 : dbg_instr = "spiisr+0x0d4                                   ";
         517 : dbg_instr = "spiisr+0x0d5                                   ";
         518 : dbg_instr = "spiisr+0x0d6                                   ";
         519 : dbg_instr = "spiisr+0x0d7                                   ";
         520 : dbg_instr = "spiisr+0x0d8                                   ";
         521 : dbg_instr = "spiisr+0x0d9                                   ";
         522 : dbg_instr = "spiisr+0x0da                                   ";
         523 : dbg_instr = "spiisr+0x0db                                   ";
         524 : dbg_instr = "spiisr+0x0dc                                   ";
         525 : dbg_instr = "spiisr+0x0dd                                   ";
         526 : dbg_instr = "spiisr+0x0de                                   ";
         527 : dbg_instr = "spiisr+0x0df                                   ";
         528 : dbg_instr = "spiisr+0x0e0                                   ";
         529 : dbg_instr = "spiisr+0x0e1                                   ";
         530 : dbg_instr = "spiisr+0x0e2                                   ";
         531 : dbg_instr = "spiisr+0x0e3                                   ";
         532 : dbg_instr = "spiisr+0x0e4                                   ";
         533 : dbg_instr = "spiisr+0x0e5                                   ";
         534 : dbg_instr = "spiisr+0x0e6                                   ";
         535 : dbg_instr = "spiisr+0x0e7                                   ";
         536 : dbg_instr = "spiisr+0x0e8                                   ";
         537 : dbg_instr = "spiisr+0x0e9                                   ";
         538 : dbg_instr = "spiisr+0x0ea                                   ";
         539 : dbg_instr = "spiisr+0x0eb                                   ";
         540 : dbg_instr = "spiisr+0x0ec                                   ";
         541 : dbg_instr = "spiisr+0x0ed                                   ";
         542 : dbg_instr = "spiisr+0x0ee                                   ";
         543 : dbg_instr = "spiisr+0x0ef                                   ";
         544 : dbg_instr = "spiisr+0x0f0                                   ";
         545 : dbg_instr = "spiisr+0x0f1                                   ";
         546 : dbg_instr = "spiisr+0x0f2                                   ";
         547 : dbg_instr = "spiisr+0x0f3                                   ";
         548 : dbg_instr = "spiisr+0x0f4                                   ";
         549 : dbg_instr = "spiisr+0x0f5                                   ";
         550 : dbg_instr = "spiisr+0x0f6                                   ";
         551 : dbg_instr = "spiisr+0x0f7                                   ";
         552 : dbg_instr = "spiisr+0x0f8                                   ";
         553 : dbg_instr = "spiisr+0x0f9                                   ";
         554 : dbg_instr = "spiisr+0x0fa                                   ";
         555 : dbg_instr = "spiisr+0x0fb                                   ";
         556 : dbg_instr = "spiisr+0x0fc                                   ";
         557 : dbg_instr = "spiisr+0x0fd                                   ";
         558 : dbg_instr = "spiisr+0x0fe                                   ";
         559 : dbg_instr = "spiisr+0x0ff                                   ";
         560 : dbg_instr = "spiisr+0x100                                   ";
         561 : dbg_instr = "spiisr+0x101                                   ";
         562 : dbg_instr = "spiisr+0x102                                   ";
         563 : dbg_instr = "spiisr+0x103                                   ";
         564 : dbg_instr = "spiisr+0x104                                   ";
         565 : dbg_instr = "spiisr+0x105                                   ";
         566 : dbg_instr = "spiisr+0x106                                   ";
         567 : dbg_instr = "spiisr+0x107                                   ";
         568 : dbg_instr = "spiisr+0x108                                   ";
         569 : dbg_instr = "spiisr+0x109                                   ";
         570 : dbg_instr = "spiisr+0x10a                                   ";
         571 : dbg_instr = "spiisr+0x10b                                   ";
         572 : dbg_instr = "spiisr+0x10c                                   ";
         573 : dbg_instr = "spiisr+0x10d                                   ";
         574 : dbg_instr = "spiisr+0x10e                                   ";
         575 : dbg_instr = "spiisr+0x10f                                   ";
         576 : dbg_instr = "spiisr+0x110                                   ";
         577 : dbg_instr = "spiisr+0x111                                   ";
         578 : dbg_instr = "spiisr+0x112                                   ";
         579 : dbg_instr = "spiisr+0x113                                   ";
         580 : dbg_instr = "spiisr+0x114                                   ";
         581 : dbg_instr = "spiisr+0x115                                   ";
         582 : dbg_instr = "spiisr+0x116                                   ";
         583 : dbg_instr = "spiisr+0x117                                   ";
         584 : dbg_instr = "spiisr+0x118                                   ";
         585 : dbg_instr = "spiisr+0x119                                   ";
         586 : dbg_instr = "spiisr+0x11a                                   ";
         587 : dbg_instr = "spiisr+0x11b                                   ";
         588 : dbg_instr = "spiisr+0x11c                                   ";
         589 : dbg_instr = "spiisr+0x11d                                   ";
         590 : dbg_instr = "spiisr+0x11e                                   ";
         591 : dbg_instr = "spiisr+0x11f                                   ";
         592 : dbg_instr = "spiisr+0x120                                   ";
         593 : dbg_instr = "spiisr+0x121                                   ";
         594 : dbg_instr = "spiisr+0x122                                   ";
         595 : dbg_instr = "spiisr+0x123                                   ";
         596 : dbg_instr = "spiisr+0x124                                   ";
         597 : dbg_instr = "spiisr+0x125                                   ";
         598 : dbg_instr = "spiisr+0x126                                   ";
         599 : dbg_instr = "spiisr+0x127                                   ";
         600 : dbg_instr = "spiisr+0x128                                   ";
         601 : dbg_instr = "spiisr+0x129                                   ";
         602 : dbg_instr = "spiisr+0x12a                                   ";
         603 : dbg_instr = "spiisr+0x12b                                   ";
         604 : dbg_instr = "spiisr+0x12c                                   ";
         605 : dbg_instr = "spiisr+0x12d                                   ";
         606 : dbg_instr = "spiisr+0x12e                                   ";
         607 : dbg_instr = "spiisr+0x12f                                   ";
         608 : dbg_instr = "spiisr+0x130                                   ";
         609 : dbg_instr = "spiisr+0x131                                   ";
         610 : dbg_instr = "spiisr+0x132                                   ";
         611 : dbg_instr = "spiisr+0x133                                   ";
         612 : dbg_instr = "spiisr+0x134                                   ";
         613 : dbg_instr = "spiisr+0x135                                   ";
         614 : dbg_instr = "spiisr+0x136                                   ";
         615 : dbg_instr = "spiisr+0x137                                   ";
         616 : dbg_instr = "spiisr+0x138                                   ";
         617 : dbg_instr = "spiisr+0x139                                   ";
         618 : dbg_instr = "spiisr+0x13a                                   ";
         619 : dbg_instr = "spiisr+0x13b                                   ";
         620 : dbg_instr = "spiisr+0x13c                                   ";
         621 : dbg_instr = "spiisr+0x13d                                   ";
         622 : dbg_instr = "spiisr+0x13e                                   ";
         623 : dbg_instr = "spiisr+0x13f                                   ";
         624 : dbg_instr = "spiisr+0x140                                   ";
         625 : dbg_instr = "spiisr+0x141                                   ";
         626 : dbg_instr = "spiisr+0x142                                   ";
         627 : dbg_instr = "spiisr+0x143                                   ";
         628 : dbg_instr = "spiisr+0x144                                   ";
         629 : dbg_instr = "spiisr+0x145                                   ";
         630 : dbg_instr = "spiisr+0x146                                   ";
         631 : dbg_instr = "spiisr+0x147                                   ";
         632 : dbg_instr = "spiisr+0x148                                   ";
         633 : dbg_instr = "spiisr+0x149                                   ";
         634 : dbg_instr = "spiisr+0x14a                                   ";
         635 : dbg_instr = "spiisr+0x14b                                   ";
         636 : dbg_instr = "spiisr+0x14c                                   ";
         637 : dbg_instr = "spiisr+0x14d                                   ";
         638 : dbg_instr = "spiisr+0x14e                                   ";
         639 : dbg_instr = "spiisr+0x14f                                   ";
         640 : dbg_instr = "spiisr+0x150                                   ";
         641 : dbg_instr = "spiisr+0x151                                   ";
         642 : dbg_instr = "spiisr+0x152                                   ";
         643 : dbg_instr = "spiisr+0x153                                   ";
         644 : dbg_instr = "spiisr+0x154                                   ";
         645 : dbg_instr = "spiisr+0x155                                   ";
         646 : dbg_instr = "spiisr+0x156                                   ";
         647 : dbg_instr = "spiisr+0x157                                   ";
         648 : dbg_instr = "spiisr+0x158                                   ";
         649 : dbg_instr = "spiisr+0x159                                   ";
         650 : dbg_instr = "spiisr+0x15a                                   ";
         651 : dbg_instr = "spiisr+0x15b                                   ";
         652 : dbg_instr = "spiisr+0x15c                                   ";
         653 : dbg_instr = "spiisr+0x15d                                   ";
         654 : dbg_instr = "spiisr+0x15e                                   ";
         655 : dbg_instr = "spiisr+0x15f                                   ";
         656 : dbg_instr = "spiisr+0x160                                   ";
         657 : dbg_instr = "spiisr+0x161                                   ";
         658 : dbg_instr = "spiisr+0x162                                   ";
         659 : dbg_instr = "spiisr+0x163                                   ";
         660 : dbg_instr = "spiisr+0x164                                   ";
         661 : dbg_instr = "spiisr+0x165                                   ";
         662 : dbg_instr = "spiisr+0x166                                   ";
         663 : dbg_instr = "spiisr+0x167                                   ";
         664 : dbg_instr = "spiisr+0x168                                   ";
         665 : dbg_instr = "spiisr+0x169                                   ";
         666 : dbg_instr = "spiisr+0x16a                                   ";
         667 : dbg_instr = "spiisr+0x16b                                   ";
         668 : dbg_instr = "spiisr+0x16c                                   ";
         669 : dbg_instr = "spiisr+0x16d                                   ";
         670 : dbg_instr = "spiisr+0x16e                                   ";
         671 : dbg_instr = "spiisr+0x16f                                   ";
         672 : dbg_instr = "spiisr+0x170                                   ";
         673 : dbg_instr = "spiisr+0x171                                   ";
         674 : dbg_instr = "spiisr+0x172                                   ";
         675 : dbg_instr = "spiisr+0x173                                   ";
         676 : dbg_instr = "spiisr+0x174                                   ";
         677 : dbg_instr = "spiisr+0x175                                   ";
         678 : dbg_instr = "spiisr+0x176                                   ";
         679 : dbg_instr = "spiisr+0x177                                   ";
         680 : dbg_instr = "spiisr+0x178                                   ";
         681 : dbg_instr = "spiisr+0x179                                   ";
         682 : dbg_instr = "spiisr+0x17a                                   ";
         683 : dbg_instr = "spiisr+0x17b                                   ";
         684 : dbg_instr = "spiisr+0x17c                                   ";
         685 : dbg_instr = "spiisr+0x17d                                   ";
         686 : dbg_instr = "spiisr+0x17e                                   ";
         687 : dbg_instr = "spiisr+0x17f                                   ";
         688 : dbg_instr = "spiisr+0x180                                   ";
         689 : dbg_instr = "spiisr+0x181                                   ";
         690 : dbg_instr = "spiisr+0x182                                   ";
         691 : dbg_instr = "spiisr+0x183                                   ";
         692 : dbg_instr = "spiisr+0x184                                   ";
         693 : dbg_instr = "spiisr+0x185                                   ";
         694 : dbg_instr = "spiisr+0x186                                   ";
         695 : dbg_instr = "spiisr+0x187                                   ";
         696 : dbg_instr = "spiisr+0x188                                   ";
         697 : dbg_instr = "spiisr+0x189                                   ";
         698 : dbg_instr = "spiisr+0x18a                                   ";
         699 : dbg_instr = "spiisr+0x18b                                   ";
         700 : dbg_instr = "spiisr+0x18c                                   ";
         701 : dbg_instr = "spiisr+0x18d                                   ";
         702 : dbg_instr = "spiisr+0x18e                                   ";
         703 : dbg_instr = "spiisr+0x18f                                   ";
         704 : dbg_instr = "spiisr+0x190                                   ";
         705 : dbg_instr = "spiisr+0x191                                   ";
         706 : dbg_instr = "spiisr+0x192                                   ";
         707 : dbg_instr = "spiisr+0x193                                   ";
         708 : dbg_instr = "spiisr+0x194                                   ";
         709 : dbg_instr = "spiisr+0x195                                   ";
         710 : dbg_instr = "spiisr+0x196                                   ";
         711 : dbg_instr = "spiisr+0x197                                   ";
         712 : dbg_instr = "spiisr+0x198                                   ";
         713 : dbg_instr = "spiisr+0x199                                   ";
         714 : dbg_instr = "spiisr+0x19a                                   ";
         715 : dbg_instr = "spiisr+0x19b                                   ";
         716 : dbg_instr = "spiisr+0x19c                                   ";
         717 : dbg_instr = "spiisr+0x19d                                   ";
         718 : dbg_instr = "spiisr+0x19e                                   ";
         719 : dbg_instr = "spiisr+0x19f                                   ";
         720 : dbg_instr = "spiisr+0x1a0                                   ";
         721 : dbg_instr = "spiisr+0x1a1                                   ";
         722 : dbg_instr = "spiisr+0x1a2                                   ";
         723 : dbg_instr = "spiisr+0x1a3                                   ";
         724 : dbg_instr = "spiisr+0x1a4                                   ";
         725 : dbg_instr = "spiisr+0x1a5                                   ";
         726 : dbg_instr = "spiisr+0x1a6                                   ";
         727 : dbg_instr = "spiisr+0x1a7                                   ";
         728 : dbg_instr = "spiisr+0x1a8                                   ";
         729 : dbg_instr = "spiisr+0x1a9                                   ";
         730 : dbg_instr = "spiisr+0x1aa                                   ";
         731 : dbg_instr = "spiisr+0x1ab                                   ";
         732 : dbg_instr = "spiisr+0x1ac                                   ";
         733 : dbg_instr = "spiisr+0x1ad                                   ";
         734 : dbg_instr = "spiisr+0x1ae                                   ";
         735 : dbg_instr = "spiisr+0x1af                                   ";
         736 : dbg_instr = "spiisr+0x1b0                                   ";
         737 : dbg_instr = "spiisr+0x1b1                                   ";
         738 : dbg_instr = "spiisr+0x1b2                                   ";
         739 : dbg_instr = "spiisr+0x1b3                                   ";
         740 : dbg_instr = "spiisr+0x1b4                                   ";
         741 : dbg_instr = "spiisr+0x1b5                                   ";
         742 : dbg_instr = "spiisr+0x1b6                                   ";
         743 : dbg_instr = "spiisr+0x1b7                                   ";
         744 : dbg_instr = "spiisr+0x1b8                                   ";
         745 : dbg_instr = "spiisr+0x1b9                                   ";
         746 : dbg_instr = "spiisr+0x1ba                                   ";
         747 : dbg_instr = "spiisr+0x1bb                                   ";
         748 : dbg_instr = "spiisr+0x1bc                                   ";
         749 : dbg_instr = "spiisr+0x1bd                                   ";
         750 : dbg_instr = "spiisr+0x1be                                   ";
         751 : dbg_instr = "spiisr+0x1bf                                   ";
         752 : dbg_instr = "spiisr+0x1c0                                   ";
         753 : dbg_instr = "spiisr+0x1c1                                   ";
         754 : dbg_instr = "spiisr+0x1c2                                   ";
         755 : dbg_instr = "spiisr+0x1c3                                   ";
         756 : dbg_instr = "spiisr+0x1c4                                   ";
         757 : dbg_instr = "spiisr+0x1c5                                   ";
         758 : dbg_instr = "spiisr+0x1c6                                   ";
         759 : dbg_instr = "spiisr+0x1c7                                   ";
         760 : dbg_instr = "spiisr+0x1c8                                   ";
         761 : dbg_instr = "spiisr+0x1c9                                   ";
         762 : dbg_instr = "spiisr+0x1ca                                   ";
         763 : dbg_instr = "spiisr+0x1cb                                   ";
         764 : dbg_instr = "spiisr+0x1cc                                   ";
         765 : dbg_instr = "spiisr+0x1cd                                   ";
         766 : dbg_instr = "spiisr+0x1ce                                   ";
         767 : dbg_instr = "spiisr+0x1cf                                   ";
         768 : dbg_instr = "spiisr+0x1d0                                   ";
         769 : dbg_instr = "spiisr+0x1d1                                   ";
         770 : dbg_instr = "spiisr+0x1d2                                   ";
         771 : dbg_instr = "spiisr+0x1d3                                   ";
         772 : dbg_instr = "spiisr+0x1d4                                   ";
         773 : dbg_instr = "spiisr+0x1d5                                   ";
         774 : dbg_instr = "spiisr+0x1d6                                   ";
         775 : dbg_instr = "spiisr+0x1d7                                   ";
         776 : dbg_instr = "spiisr+0x1d8                                   ";
         777 : dbg_instr = "spiisr+0x1d9                                   ";
         778 : dbg_instr = "spiisr+0x1da                                   ";
         779 : dbg_instr = "spiisr+0x1db                                   ";
         780 : dbg_instr = "spiisr+0x1dc                                   ";
         781 : dbg_instr = "spiisr+0x1dd                                   ";
         782 : dbg_instr = "spiisr+0x1de                                   ";
         783 : dbg_instr = "spiisr+0x1df                                   ";
         784 : dbg_instr = "spiisr+0x1e0                                   ";
         785 : dbg_instr = "spiisr+0x1e1                                   ";
         786 : dbg_instr = "spiisr+0x1e2                                   ";
         787 : dbg_instr = "spiisr+0x1e3                                   ";
         788 : dbg_instr = "spiisr+0x1e4                                   ";
         789 : dbg_instr = "spiisr+0x1e5                                   ";
         790 : dbg_instr = "spiisr+0x1e6                                   ";
         791 : dbg_instr = "spiisr+0x1e7                                   ";
         792 : dbg_instr = "spiisr+0x1e8                                   ";
         793 : dbg_instr = "spiisr+0x1e9                                   ";
         794 : dbg_instr = "spiisr+0x1ea                                   ";
         795 : dbg_instr = "spiisr+0x1eb                                   ";
         796 : dbg_instr = "spiisr+0x1ec                                   ";
         797 : dbg_instr = "spiisr+0x1ed                                   ";
         798 : dbg_instr = "spiisr+0x1ee                                   ";
         799 : dbg_instr = "spiisr+0x1ef                                   ";
         800 : dbg_instr = "spiisr+0x1f0                                   ";
         801 : dbg_instr = "spiisr+0x1f1                                   ";
         802 : dbg_instr = "spiisr+0x1f2                                   ";
         803 : dbg_instr = "spiisr+0x1f3                                   ";
         804 : dbg_instr = "spiisr+0x1f4                                   ";
         805 : dbg_instr = "spiisr+0x1f5                                   ";
         806 : dbg_instr = "spiisr+0x1f6                                   ";
         807 : dbg_instr = "spiisr+0x1f7                                   ";
         808 : dbg_instr = "spiisr+0x1f8                                   ";
         809 : dbg_instr = "spiisr+0x1f9                                   ";
         810 : dbg_instr = "spiisr+0x1fa                                   ";
         811 : dbg_instr = "spiisr+0x1fb                                   ";
         812 : dbg_instr = "spiisr+0x1fc                                   ";
         813 : dbg_instr = "spiisr+0x1fd                                   ";
         814 : dbg_instr = "spiisr+0x1fe                                   ";
         815 : dbg_instr = "spiisr+0x1ff                                   ";
         816 : dbg_instr = "spiisr+0x200                                   ";
         817 : dbg_instr = "spiisr+0x201                                   ";
         818 : dbg_instr = "spiisr+0x202                                   ";
         819 : dbg_instr = "spiisr+0x203                                   ";
         820 : dbg_instr = "spiisr+0x204                                   ";
         821 : dbg_instr = "spiisr+0x205                                   ";
         822 : dbg_instr = "spiisr+0x206                                   ";
         823 : dbg_instr = "spiisr+0x207                                   ";
         824 : dbg_instr = "spiisr+0x208                                   ";
         825 : dbg_instr = "spiisr+0x209                                   ";
         826 : dbg_instr = "spiisr+0x20a                                   ";
         827 : dbg_instr = "spiisr+0x20b                                   ";
         828 : dbg_instr = "spiisr+0x20c                                   ";
         829 : dbg_instr = "spiisr+0x20d                                   ";
         830 : dbg_instr = "spiisr+0x20e                                   ";
         831 : dbg_instr = "spiisr+0x20f                                   ";
         832 : dbg_instr = "spiisr+0x210                                   ";
         833 : dbg_instr = "spiisr+0x211                                   ";
         834 : dbg_instr = "spiisr+0x212                                   ";
         835 : dbg_instr = "spiisr+0x213                                   ";
         836 : dbg_instr = "spiisr+0x214                                   ";
         837 : dbg_instr = "spiisr+0x215                                   ";
         838 : dbg_instr = "spiisr+0x216                                   ";
         839 : dbg_instr = "spiisr+0x217                                   ";
         840 : dbg_instr = "spiisr+0x218                                   ";
         841 : dbg_instr = "spiisr+0x219                                   ";
         842 : dbg_instr = "spiisr+0x21a                                   ";
         843 : dbg_instr = "spiisr+0x21b                                   ";
         844 : dbg_instr = "spiisr+0x21c                                   ";
         845 : dbg_instr = "spiisr+0x21d                                   ";
         846 : dbg_instr = "spiisr+0x21e                                   ";
         847 : dbg_instr = "spiisr+0x21f                                   ";
         848 : dbg_instr = "spiisr+0x220                                   ";
         849 : dbg_instr = "spiisr+0x221                                   ";
         850 : dbg_instr = "spiisr+0x222                                   ";
         851 : dbg_instr = "spiisr+0x223                                   ";
         852 : dbg_instr = "spiisr+0x224                                   ";
         853 : dbg_instr = "spiisr+0x225                                   ";
         854 : dbg_instr = "spiisr+0x226                                   ";
         855 : dbg_instr = "spiisr+0x227                                   ";
         856 : dbg_instr = "spiisr+0x228                                   ";
         857 : dbg_instr = "spiisr+0x229                                   ";
         858 : dbg_instr = "spiisr+0x22a                                   ";
         859 : dbg_instr = "spiisr+0x22b                                   ";
         860 : dbg_instr = "spiisr+0x22c                                   ";
         861 : dbg_instr = "spiisr+0x22d                                   ";
         862 : dbg_instr = "spiisr+0x22e                                   ";
         863 : dbg_instr = "spiisr+0x22f                                   ";
         864 : dbg_instr = "spiisr+0x230                                   ";
         865 : dbg_instr = "spiisr+0x231                                   ";
         866 : dbg_instr = "spiisr+0x232                                   ";
         867 : dbg_instr = "spiisr+0x233                                   ";
         868 : dbg_instr = "spiisr+0x234                                   ";
         869 : dbg_instr = "spiisr+0x235                                   ";
         870 : dbg_instr = "spiisr+0x236                                   ";
         871 : dbg_instr = "spiisr+0x237                                   ";
         872 : dbg_instr = "spiisr+0x238                                   ";
         873 : dbg_instr = "spiisr+0x239                                   ";
         874 : dbg_instr = "spiisr+0x23a                                   ";
         875 : dbg_instr = "spiisr+0x23b                                   ";
         876 : dbg_instr = "spiisr+0x23c                                   ";
         877 : dbg_instr = "spiisr+0x23d                                   ";
         878 : dbg_instr = "spiisr+0x23e                                   ";
         879 : dbg_instr = "spiisr+0x23f                                   ";
         880 : dbg_instr = "spiisr+0x240                                   ";
         881 : dbg_instr = "spiisr+0x241                                   ";
         882 : dbg_instr = "spiisr+0x242                                   ";
         883 : dbg_instr = "spiisr+0x243                                   ";
         884 : dbg_instr = "spiisr+0x244                                   ";
         885 : dbg_instr = "spiisr+0x245                                   ";
         886 : dbg_instr = "spiisr+0x246                                   ";
         887 : dbg_instr = "spiisr+0x247                                   ";
         888 : dbg_instr = "spiisr+0x248                                   ";
         889 : dbg_instr = "spiisr+0x249                                   ";
         890 : dbg_instr = "spiisr+0x24a                                   ";
         891 : dbg_instr = "spiisr+0x24b                                   ";
         892 : dbg_instr = "spiisr+0x24c                                   ";
         893 : dbg_instr = "spiisr+0x24d                                   ";
         894 : dbg_instr = "spiisr+0x24e                                   ";
         895 : dbg_instr = "spiisr+0x24f                                   ";
         896 : dbg_instr = "spiisr+0x250                                   ";
         897 : dbg_instr = "spiisr+0x251                                   ";
         898 : dbg_instr = "spiisr+0x252                                   ";
         899 : dbg_instr = "spiisr+0x253                                   ";
         900 : dbg_instr = "spiisr+0x254                                   ";
         901 : dbg_instr = "spiisr+0x255                                   ";
         902 : dbg_instr = "spiisr+0x256                                   ";
         903 : dbg_instr = "spiisr+0x257                                   ";
         904 : dbg_instr = "spiisr+0x258                                   ";
         905 : dbg_instr = "spiisr+0x259                                   ";
         906 : dbg_instr = "spiisr+0x25a                                   ";
         907 : dbg_instr = "spiisr+0x25b                                   ";
         908 : dbg_instr = "spiisr+0x25c                                   ";
         909 : dbg_instr = "spiisr+0x25d                                   ";
         910 : dbg_instr = "spiisr+0x25e                                   ";
         911 : dbg_instr = "spiisr+0x25f                                   ";
         912 : dbg_instr = "spiisr+0x260                                   ";
         913 : dbg_instr = "spiisr+0x261                                   ";
         914 : dbg_instr = "spiisr+0x262                                   ";
         915 : dbg_instr = "spiisr+0x263                                   ";
         916 : dbg_instr = "spiisr+0x264                                   ";
         917 : dbg_instr = "spiisr+0x265                                   ";
         918 : dbg_instr = "spiisr+0x266                                   ";
         919 : dbg_instr = "spiisr+0x267                                   ";
         920 : dbg_instr = "spiisr+0x268                                   ";
         921 : dbg_instr = "spiisr+0x269                                   ";
         922 : dbg_instr = "spiisr+0x26a                                   ";
         923 : dbg_instr = "spiisr+0x26b                                   ";
         924 : dbg_instr = "spiisr+0x26c                                   ";
         925 : dbg_instr = "spiisr+0x26d                                   ";
         926 : dbg_instr = "spiisr+0x26e                                   ";
         927 : dbg_instr = "spiisr+0x26f                                   ";
         928 : dbg_instr = "spiisr+0x270                                   ";
         929 : dbg_instr = "spiisr+0x271                                   ";
         930 : dbg_instr = "spiisr+0x272                                   ";
         931 : dbg_instr = "spiisr+0x273                                   ";
         932 : dbg_instr = "spiisr+0x274                                   ";
         933 : dbg_instr = "spiisr+0x275                                   ";
         934 : dbg_instr = "spiisr+0x276                                   ";
         935 : dbg_instr = "spiisr+0x277                                   ";
         936 : dbg_instr = "spiisr+0x278                                   ";
         937 : dbg_instr = "spiisr+0x279                                   ";
         938 : dbg_instr = "spiisr+0x27a                                   ";
         939 : dbg_instr = "spiisr+0x27b                                   ";
         940 : dbg_instr = "spiisr+0x27c                                   ";
         941 : dbg_instr = "spiisr+0x27d                                   ";
         942 : dbg_instr = "spiisr+0x27e                                   ";
         943 : dbg_instr = "spiisr+0x27f                                   ";
         944 : dbg_instr = "spiisr+0x280                                   ";
         945 : dbg_instr = "spiisr+0x281                                   ";
         946 : dbg_instr = "spiisr+0x282                                   ";
         947 : dbg_instr = "spiisr+0x283                                   ";
         948 : dbg_instr = "spiisr+0x284                                   ";
         949 : dbg_instr = "spiisr+0x285                                   ";
         950 : dbg_instr = "spiisr+0x286                                   ";
         951 : dbg_instr = "spiisr+0x287                                   ";
         952 : dbg_instr = "spiisr+0x288                                   ";
         953 : dbg_instr = "spiisr+0x289                                   ";
         954 : dbg_instr = "spiisr+0x28a                                   ";
         955 : dbg_instr = "spiisr+0x28b                                   ";
         956 : dbg_instr = "spiisr+0x28c                                   ";
         957 : dbg_instr = "spiisr+0x28d                                   ";
         958 : dbg_instr = "spiisr+0x28e                                   ";
         959 : dbg_instr = "spiisr+0x28f                                   ";
         960 : dbg_instr = "spiisr+0x290                                   ";
         961 : dbg_instr = "spiisr+0x291                                   ";
         962 : dbg_instr = "spiisr+0x292                                   ";
         963 : dbg_instr = "spiisr+0x293                                   ";
         964 : dbg_instr = "spiisr+0x294                                   ";
         965 : dbg_instr = "spiisr+0x295                                   ";
         966 : dbg_instr = "spiisr+0x296                                   ";
         967 : dbg_instr = "spiisr+0x297                                   ";
         968 : dbg_instr = "spiisr+0x298                                   ";
         969 : dbg_instr = "spiisr+0x299                                   ";
         970 : dbg_instr = "spiisr+0x29a                                   ";
         971 : dbg_instr = "spiisr+0x29b                                   ";
         972 : dbg_instr = "spiisr+0x29c                                   ";
         973 : dbg_instr = "spiisr+0x29d                                   ";
         974 : dbg_instr = "spiisr+0x29e                                   ";
         975 : dbg_instr = "spiisr+0x29f                                   ";
         976 : dbg_instr = "spiisr+0x2a0                                   ";
         977 : dbg_instr = "spiisr+0x2a1                                   ";
         978 : dbg_instr = "spiisr+0x2a2                                   ";
         979 : dbg_instr = "spiisr+0x2a3                                   ";
         980 : dbg_instr = "spiisr+0x2a4                                   ";
         981 : dbg_instr = "spiisr+0x2a5                                   ";
         982 : dbg_instr = "spiisr+0x2a6                                   ";
         983 : dbg_instr = "spiisr+0x2a7                                   ";
         984 : dbg_instr = "spiisr+0x2a8                                   ";
         985 : dbg_instr = "spiisr+0x2a9                                   ";
         986 : dbg_instr = "spiisr+0x2aa                                   ";
         987 : dbg_instr = "spiisr+0x2ab                                   ";
         988 : dbg_instr = "spiisr+0x2ac                                   ";
         989 : dbg_instr = "spiisr+0x2ad                                   ";
         990 : dbg_instr = "spiisr+0x2ae                                   ";
         991 : dbg_instr = "spiisr+0x2af                                   ";
         992 : dbg_instr = "spiisr+0x2b0                                   ";
         993 : dbg_instr = "spiisr+0x2b1                                   ";
         994 : dbg_instr = "spiisr+0x2b2                                   ";
         995 : dbg_instr = "spiisr+0x2b3                                   ";
         996 : dbg_instr = "spiisr+0x2b4                                   ";
         997 : dbg_instr = "spiisr+0x2b5                                   ";
         998 : dbg_instr = "spiisr+0x2b6                                   ";
         999 : dbg_instr = "spiisr+0x2b7                                   ";
         1000 : dbg_instr = "spiisr+0x2b8                                   ";
         1001 : dbg_instr = "spiisr+0x2b9                                   ";
         1002 : dbg_instr = "spiisr+0x2ba                                   ";
         1003 : dbg_instr = "spiisr+0x2bb                                   ";
         1004 : dbg_instr = "spiisr+0x2bc                                   ";
         1005 : dbg_instr = "spiisr+0x2bd                                   ";
         1006 : dbg_instr = "spiisr+0x2be                                   ";
         1007 : dbg_instr = "spiisr+0x2bf                                   ";
         1008 : dbg_instr = "spiisr+0x2c0                                   ";
         1009 : dbg_instr = "spiisr+0x2c1                                   ";
         1010 : dbg_instr = "spiisr+0x2c2                                   ";
         1011 : dbg_instr = "spiisr+0x2c3                                   ";
         1012 : dbg_instr = "spiisr+0x2c4                                   ";
         1013 : dbg_instr = "spiisr+0x2c5                                   ";
         1014 : dbg_instr = "spiisr+0x2c6                                   ";
         1015 : dbg_instr = "spiisr+0x2c7                                   ";
         1016 : dbg_instr = "spiisr+0x2c8                                   ";
         1017 : dbg_instr = "spiisr+0x2c9                                   ";
         1018 : dbg_instr = "spiisr+0x2ca                                   ";
         1019 : dbg_instr = "spiisr+0x2cb                                   ";
         1020 : dbg_instr = "spiisr+0x2cc                                   ";
         1021 : dbg_instr = "spiisr+0x2cd                                   ";
         1022 : dbg_instr = "spiisr+0x2ce                                   ";
         1023 : dbg_instr = "spiisr+0x2cf                                   ";
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
    .INIT_00(256'h500000110082000D000D50001B011A01CFB0AFA0000600051B20200100AB004D),
    .INIT_01(256'hDDFF1A030065B023500060139B01B001B0114A00DF049F00DA02B0011B080011),
    .INIT_02(256'h1A0600655000B023206300461AE400461A065000000B00110AD000111A132024),
    .INIT_03(256'h00461A0600659D01203D1D015000000B00110AD000111A122037DDFF1A020046),
    .INIT_04(256'hF0181000193F202C00101A05B023202C0011B0232117000B00110AD000111AE3),
    .INIT_05(256'h0AD000111ADC2060DDFF1AD800461A06006550009C209B219A229D235000006C),
    .INIT_06(256'hB021B0311F08B02350009901EA909901EB909901EC90211F1AAAB023000B0011),
    .INIT_07(256'h190100825000AC901901007E20461A9900461AF000461A66B0235000606E9F01),
    .INIT_08(256'h1A9FB0235000DF10DF11FA181A005F082089DA001F025000AA9019015000AB90),
    .INIT_09(256'h01141A04609ADB241B01CAB01B201AFF202C007A006900110069001100690010),
    .INIT_0A(256'h101E5000300E700E90105000011301141A1001141A0801141A1401141A0C0113),
    .INIT_0B(256'h005260D7DF023FEE0F00901E20891F0620BAD100A0B1D024100161F08F001100),
    .INIT_0C(256'h11FF001C20850117E0C8910100119A3011FF002E60CED00230EF1DFF60C3D010),
    .INIT_0D(256'h00571DFF60DFD004005260E1DFD83FFB0F0020891F02B023E0D09101DA300011),
    .INIT_0E(256'h60F2D0E42085003A005260EED0E320891F02DA20DB21DC22008E60E9D09E2085),
    .INIT_0F(256'h20891F06208B1F02FF181F0160FEFD42FA79FB65DC3300526100D0FE20850027),

    // Address 256 to 511
    .INIT_10(256'h2098DF10DF111F02FD17FA16FB15FC14005220891F066107DA00BA186110D0FF),
    .INIT_11(256'h0DA05000008200461A040069011F1A01B0235000B00400031A00011320891F06),
    .INIT_12(256'h5000E127BE00BD009C015000612B3A0100491C004E004D064E004D064E004D06),
    .INIT_13(256'h1000100010001000100010001000100010001000100010009001DF081F010073),
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
    .INIT_1F(256'h2130100010001000100010001000100010001000100010001000100010001000),

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
    .INITP_00(256'h686888ADA2999A2A2348A00A828AAA8889DA88D22AA22A234AB690A2AAA58A2A),
    .INITP_01(256'h888D56DADAB62AB68CB422DA2AD82D0CB408DD40302A22228D60AAAA2AA0D218),

    // Address 256 to 511
    .INITP_02(256'h00000000000000000000000000000000000000A2B56C85552A28AA28A8AAA34D),
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
