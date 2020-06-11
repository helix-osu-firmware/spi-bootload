/*
 * == pblaze-cc ==
 * source : spi_bootloader.c
 * create : Thu Jun 11 11:49:31 2020
 * modify : Thu Jun 11 11:49:31 2020
 */
`timescale 1 ps / 1ps

/* 
 * == pblaze-as ==
 * source : spi_bootloader.s
 * create : Thu Jun 11 11:49:41 2020
 * modify : Thu Jun 11 11:49:41 2020
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
         273 : dbg_instr = "ICAP_noop2                                     ";
         274 : dbg_instr = "ICAP_noop                                      ";
         275 : dbg_instr = "ICAP_write_word                                ";
         276 : dbg_instr = "ICAP_write_word+0x001                          ";
         277 : dbg_instr = "ICAP_write_word+0x002                          ";
         278 : dbg_instr = "SPI_Flash_write_complete                       ";
         279 : dbg_instr = "SPI_Flash_write_complete+0x001                 ";
         280 : dbg_instr = "SPI_Flash_write_complete+0x002                 ";
         281 : dbg_instr = "SPI_Flash_write_complete+0x003                 ";
         282 : dbg_instr = "SPI_Flash_write_complete+0x004                 ";
         283 : dbg_instr = "SPI_Flash_write_complete+0x005                 ";
         284 : dbg_instr = "SPI_Flash_write_complete+0x006                 ";
         285 : dbg_instr = "SPI_Flash_write_complete+0x007                 ";
         286 : dbg_instr = "SPI_Flash_wait_WIP                             ";
         287 : dbg_instr = "SPI_Flash_wait_WIP+0x001                       ";
         288 : dbg_instr = "SPI_Flash_wait_WIP+0x002                       ";
         289 : dbg_instr = "SPI_Flash_wait_WIP+0x003                       ";
         290 : dbg_instr = "SPI_Flash_wait_WIP+0x004                       ";
         291 : dbg_instr = "SPI_Flash_wait_WIP+0x005                       ";
         292 : dbg_instr = "SPI_Flash_wait_WIP+0x006                       ";
         293 : dbg_instr = "SPI_Flash_wait_WIP+0x007                       ";
         294 : dbg_instr = "SPI_Flash_wait_WIP+0x008                       ";
         295 : dbg_instr = "SPI_Flash_wait_WIP+0x009                       ";
         296 : dbg_instr = "SPI_Flash_wait_WIP+0x00a                       ";
         297 : dbg_instr = "SPI_Flash_wait_WIP+0x00b                       ";
         298 : dbg_instr = "SPI_Flash_wait_WIP+0x00c                       ";
         299 : dbg_instr = "SPI_Flash_wait_WIP+0x00d                       ";
         300 : dbg_instr = "SPI_Flash_wait_WIP+0x00e                       ";
         301 : dbg_instr = "SPI_Flash_wait_WIP+0x00f                       ";
         302 : dbg_instr = "SPI_Flash_wait_WIP+0x010                       ";
         303 : dbg_instr = "spiisr                                         ";
         304 : dbg_instr = "spiisr+0x001                                   ";
         305 : dbg_instr = "spiisr+0x002                                   ";
         306 : dbg_instr = "spiisr+0x003                                   ";
         307 : dbg_instr = "spiisr+0x004                                   ";
         308 : dbg_instr = "spiisr+0x005                                   ";
         309 : dbg_instr = "spiisr+0x006                                   ";
         310 : dbg_instr = "spiisr+0x007                                   ";
         311 : dbg_instr = "spiisr+0x008                                   ";
         312 : dbg_instr = "spiisr+0x009                                   ";
         313 : dbg_instr = "spiisr+0x00a                                   ";
         314 : dbg_instr = "spiisr+0x00b                                   ";
         315 : dbg_instr = "spiisr+0x00c                                   ";
         316 : dbg_instr = "spiisr+0x00d                                   ";
         317 : dbg_instr = "spiisr+0x00e                                   ";
         318 : dbg_instr = "spiisr+0x00f                                   ";
         319 : dbg_instr = "spiisr+0x010                                   ";
         320 : dbg_instr = "spiisr+0x011                                   ";
         321 : dbg_instr = "spiisr+0x012                                   ";
         322 : dbg_instr = "spiisr+0x013                                   ";
         323 : dbg_instr = "spiisr+0x014                                   ";
         324 : dbg_instr = "spiisr+0x015                                   ";
         325 : dbg_instr = "spiisr+0x016                                   ";
         326 : dbg_instr = "spiisr+0x017                                   ";
         327 : dbg_instr = "spiisr+0x018                                   ";
         328 : dbg_instr = "spiisr+0x019                                   ";
         329 : dbg_instr = "spiisr+0x01a                                   ";
         330 : dbg_instr = "spiisr+0x01b                                   ";
         331 : dbg_instr = "spiisr+0x01c                                   ";
         332 : dbg_instr = "spiisr+0x01d                                   ";
         333 : dbg_instr = "spiisr+0x01e                                   ";
         334 : dbg_instr = "spiisr+0x01f                                   ";
         335 : dbg_instr = "spiisr+0x020                                   ";
         336 : dbg_instr = "spiisr+0x021                                   ";
         337 : dbg_instr = "spiisr+0x022                                   ";
         338 : dbg_instr = "spiisr+0x023                                   ";
         339 : dbg_instr = "spiisr+0x024                                   ";
         340 : dbg_instr = "spiisr+0x025                                   ";
         341 : dbg_instr = "spiisr+0x026                                   ";
         342 : dbg_instr = "spiisr+0x027                                   ";
         343 : dbg_instr = "spiisr+0x028                                   ";
         344 : dbg_instr = "spiisr+0x029                                   ";
         345 : dbg_instr = "spiisr+0x02a                                   ";
         346 : dbg_instr = "spiisr+0x02b                                   ";
         347 : dbg_instr = "spiisr+0x02c                                   ";
         348 : dbg_instr = "spiisr+0x02d                                   ";
         349 : dbg_instr = "spiisr+0x02e                                   ";
         350 : dbg_instr = "spiisr+0x02f                                   ";
         351 : dbg_instr = "spiisr+0x030                                   ";
         352 : dbg_instr = "spiisr+0x031                                   ";
         353 : dbg_instr = "spiisr+0x032                                   ";
         354 : dbg_instr = "spiisr+0x033                                   ";
         355 : dbg_instr = "spiisr+0x034                                   ";
         356 : dbg_instr = "spiisr+0x035                                   ";
         357 : dbg_instr = "spiisr+0x036                                   ";
         358 : dbg_instr = "spiisr+0x037                                   ";
         359 : dbg_instr = "spiisr+0x038                                   ";
         360 : dbg_instr = "spiisr+0x039                                   ";
         361 : dbg_instr = "spiisr+0x03a                                   ";
         362 : dbg_instr = "spiisr+0x03b                                   ";
         363 : dbg_instr = "spiisr+0x03c                                   ";
         364 : dbg_instr = "spiisr+0x03d                                   ";
         365 : dbg_instr = "spiisr+0x03e                                   ";
         366 : dbg_instr = "spiisr+0x03f                                   ";
         367 : dbg_instr = "spiisr+0x040                                   ";
         368 : dbg_instr = "spiisr+0x041                                   ";
         369 : dbg_instr = "spiisr+0x042                                   ";
         370 : dbg_instr = "spiisr+0x043                                   ";
         371 : dbg_instr = "spiisr+0x044                                   ";
         372 : dbg_instr = "spiisr+0x045                                   ";
         373 : dbg_instr = "spiisr+0x046                                   ";
         374 : dbg_instr = "spiisr+0x047                                   ";
         375 : dbg_instr = "spiisr+0x048                                   ";
         376 : dbg_instr = "spiisr+0x049                                   ";
         377 : dbg_instr = "spiisr+0x04a                                   ";
         378 : dbg_instr = "spiisr+0x04b                                   ";
         379 : dbg_instr = "spiisr+0x04c                                   ";
         380 : dbg_instr = "spiisr+0x04d                                   ";
         381 : dbg_instr = "spiisr+0x04e                                   ";
         382 : dbg_instr = "spiisr+0x04f                                   ";
         383 : dbg_instr = "spiisr+0x050                                   ";
         384 : dbg_instr = "spiisr+0x051                                   ";
         385 : dbg_instr = "spiisr+0x052                                   ";
         386 : dbg_instr = "spiisr+0x053                                   ";
         387 : dbg_instr = "spiisr+0x054                                   ";
         388 : dbg_instr = "spiisr+0x055                                   ";
         389 : dbg_instr = "spiisr+0x056                                   ";
         390 : dbg_instr = "spiisr+0x057                                   ";
         391 : dbg_instr = "spiisr+0x058                                   ";
         392 : dbg_instr = "spiisr+0x059                                   ";
         393 : dbg_instr = "spiisr+0x05a                                   ";
         394 : dbg_instr = "spiisr+0x05b                                   ";
         395 : dbg_instr = "spiisr+0x05c                                   ";
         396 : dbg_instr = "spiisr+0x05d                                   ";
         397 : dbg_instr = "spiisr+0x05e                                   ";
         398 : dbg_instr = "spiisr+0x05f                                   ";
         399 : dbg_instr = "spiisr+0x060                                   ";
         400 : dbg_instr = "spiisr+0x061                                   ";
         401 : dbg_instr = "spiisr+0x062                                   ";
         402 : dbg_instr = "spiisr+0x063                                   ";
         403 : dbg_instr = "spiisr+0x064                                   ";
         404 : dbg_instr = "spiisr+0x065                                   ";
         405 : dbg_instr = "spiisr+0x066                                   ";
         406 : dbg_instr = "spiisr+0x067                                   ";
         407 : dbg_instr = "spiisr+0x068                                   ";
         408 : dbg_instr = "spiisr+0x069                                   ";
         409 : dbg_instr = "spiisr+0x06a                                   ";
         410 : dbg_instr = "spiisr+0x06b                                   ";
         411 : dbg_instr = "spiisr+0x06c                                   ";
         412 : dbg_instr = "spiisr+0x06d                                   ";
         413 : dbg_instr = "spiisr+0x06e                                   ";
         414 : dbg_instr = "spiisr+0x06f                                   ";
         415 : dbg_instr = "spiisr+0x070                                   ";
         416 : dbg_instr = "spiisr+0x071                                   ";
         417 : dbg_instr = "spiisr+0x072                                   ";
         418 : dbg_instr = "spiisr+0x073                                   ";
         419 : dbg_instr = "spiisr+0x074                                   ";
         420 : dbg_instr = "spiisr+0x075                                   ";
         421 : dbg_instr = "spiisr+0x076                                   ";
         422 : dbg_instr = "spiisr+0x077                                   ";
         423 : dbg_instr = "spiisr+0x078                                   ";
         424 : dbg_instr = "spiisr+0x079                                   ";
         425 : dbg_instr = "spiisr+0x07a                                   ";
         426 : dbg_instr = "spiisr+0x07b                                   ";
         427 : dbg_instr = "spiisr+0x07c                                   ";
         428 : dbg_instr = "spiisr+0x07d                                   ";
         429 : dbg_instr = "spiisr+0x07e                                   ";
         430 : dbg_instr = "spiisr+0x07f                                   ";
         431 : dbg_instr = "spiisr+0x080                                   ";
         432 : dbg_instr = "spiisr+0x081                                   ";
         433 : dbg_instr = "spiisr+0x082                                   ";
         434 : dbg_instr = "spiisr+0x083                                   ";
         435 : dbg_instr = "spiisr+0x084                                   ";
         436 : dbg_instr = "spiisr+0x085                                   ";
         437 : dbg_instr = "spiisr+0x086                                   ";
         438 : dbg_instr = "spiisr+0x087                                   ";
         439 : dbg_instr = "spiisr+0x088                                   ";
         440 : dbg_instr = "spiisr+0x089                                   ";
         441 : dbg_instr = "spiisr+0x08a                                   ";
         442 : dbg_instr = "spiisr+0x08b                                   ";
         443 : dbg_instr = "spiisr+0x08c                                   ";
         444 : dbg_instr = "spiisr+0x08d                                   ";
         445 : dbg_instr = "spiisr+0x08e                                   ";
         446 : dbg_instr = "spiisr+0x08f                                   ";
         447 : dbg_instr = "spiisr+0x090                                   ";
         448 : dbg_instr = "spiisr+0x091                                   ";
         449 : dbg_instr = "spiisr+0x092                                   ";
         450 : dbg_instr = "spiisr+0x093                                   ";
         451 : dbg_instr = "spiisr+0x094                                   ";
         452 : dbg_instr = "spiisr+0x095                                   ";
         453 : dbg_instr = "spiisr+0x096                                   ";
         454 : dbg_instr = "spiisr+0x097                                   ";
         455 : dbg_instr = "spiisr+0x098                                   ";
         456 : dbg_instr = "spiisr+0x099                                   ";
         457 : dbg_instr = "spiisr+0x09a                                   ";
         458 : dbg_instr = "spiisr+0x09b                                   ";
         459 : dbg_instr = "spiisr+0x09c                                   ";
         460 : dbg_instr = "spiisr+0x09d                                   ";
         461 : dbg_instr = "spiisr+0x09e                                   ";
         462 : dbg_instr = "spiisr+0x09f                                   ";
         463 : dbg_instr = "spiisr+0x0a0                                   ";
         464 : dbg_instr = "spiisr+0x0a1                                   ";
         465 : dbg_instr = "spiisr+0x0a2                                   ";
         466 : dbg_instr = "spiisr+0x0a3                                   ";
         467 : dbg_instr = "spiisr+0x0a4                                   ";
         468 : dbg_instr = "spiisr+0x0a5                                   ";
         469 : dbg_instr = "spiisr+0x0a6                                   ";
         470 : dbg_instr = "spiisr+0x0a7                                   ";
         471 : dbg_instr = "spiisr+0x0a8                                   ";
         472 : dbg_instr = "spiisr+0x0a9                                   ";
         473 : dbg_instr = "spiisr+0x0aa                                   ";
         474 : dbg_instr = "spiisr+0x0ab                                   ";
         475 : dbg_instr = "spiisr+0x0ac                                   ";
         476 : dbg_instr = "spiisr+0x0ad                                   ";
         477 : dbg_instr = "spiisr+0x0ae                                   ";
         478 : dbg_instr = "spiisr+0x0af                                   ";
         479 : dbg_instr = "spiisr+0x0b0                                   ";
         480 : dbg_instr = "spiisr+0x0b1                                   ";
         481 : dbg_instr = "spiisr+0x0b2                                   ";
         482 : dbg_instr = "spiisr+0x0b3                                   ";
         483 : dbg_instr = "spiisr+0x0b4                                   ";
         484 : dbg_instr = "spiisr+0x0b5                                   ";
         485 : dbg_instr = "spiisr+0x0b6                                   ";
         486 : dbg_instr = "spiisr+0x0b7                                   ";
         487 : dbg_instr = "spiisr+0x0b8                                   ";
         488 : dbg_instr = "spiisr+0x0b9                                   ";
         489 : dbg_instr = "spiisr+0x0ba                                   ";
         490 : dbg_instr = "spiisr+0x0bb                                   ";
         491 : dbg_instr = "spiisr+0x0bc                                   ";
         492 : dbg_instr = "spiisr+0x0bd                                   ";
         493 : dbg_instr = "spiisr+0x0be                                   ";
         494 : dbg_instr = "spiisr+0x0bf                                   ";
         495 : dbg_instr = "spiisr+0x0c0                                   ";
         496 : dbg_instr = "spiisr+0x0c1                                   ";
         497 : dbg_instr = "spiisr+0x0c2                                   ";
         498 : dbg_instr = "spiisr+0x0c3                                   ";
         499 : dbg_instr = "spiisr+0x0c4                                   ";
         500 : dbg_instr = "spiisr+0x0c5                                   ";
         501 : dbg_instr = "spiisr+0x0c6                                   ";
         502 : dbg_instr = "spiisr+0x0c7                                   ";
         503 : dbg_instr = "spiisr+0x0c8                                   ";
         504 : dbg_instr = "spiisr+0x0c9                                   ";
         505 : dbg_instr = "spiisr+0x0ca                                   ";
         506 : dbg_instr = "spiisr+0x0cb                                   ";
         507 : dbg_instr = "spiisr+0x0cc                                   ";
         508 : dbg_instr = "spiisr+0x0cd                                   ";
         509 : dbg_instr = "spiisr+0x0ce                                   ";
         510 : dbg_instr = "spiisr+0x0cf                                   ";
         511 : dbg_instr = "spiisr+0x0d0                                   ";
         512 : dbg_instr = "spiisr+0x0d1                                   ";
         513 : dbg_instr = "spiisr+0x0d2                                   ";
         514 : dbg_instr = "spiisr+0x0d3                                   ";
         515 : dbg_instr = "spiisr+0x0d4                                   ";
         516 : dbg_instr = "spiisr+0x0d5                                   ";
         517 : dbg_instr = "spiisr+0x0d6                                   ";
         518 : dbg_instr = "spiisr+0x0d7                                   ";
         519 : dbg_instr = "spiisr+0x0d8                                   ";
         520 : dbg_instr = "spiisr+0x0d9                                   ";
         521 : dbg_instr = "spiisr+0x0da                                   ";
         522 : dbg_instr = "spiisr+0x0db                                   ";
         523 : dbg_instr = "spiisr+0x0dc                                   ";
         524 : dbg_instr = "spiisr+0x0dd                                   ";
         525 : dbg_instr = "spiisr+0x0de                                   ";
         526 : dbg_instr = "spiisr+0x0df                                   ";
         527 : dbg_instr = "spiisr+0x0e0                                   ";
         528 : dbg_instr = "spiisr+0x0e1                                   ";
         529 : dbg_instr = "spiisr+0x0e2                                   ";
         530 : dbg_instr = "spiisr+0x0e3                                   ";
         531 : dbg_instr = "spiisr+0x0e4                                   ";
         532 : dbg_instr = "spiisr+0x0e5                                   ";
         533 : dbg_instr = "spiisr+0x0e6                                   ";
         534 : dbg_instr = "spiisr+0x0e7                                   ";
         535 : dbg_instr = "spiisr+0x0e8                                   ";
         536 : dbg_instr = "spiisr+0x0e9                                   ";
         537 : dbg_instr = "spiisr+0x0ea                                   ";
         538 : dbg_instr = "spiisr+0x0eb                                   ";
         539 : dbg_instr = "spiisr+0x0ec                                   ";
         540 : dbg_instr = "spiisr+0x0ed                                   ";
         541 : dbg_instr = "spiisr+0x0ee                                   ";
         542 : dbg_instr = "spiisr+0x0ef                                   ";
         543 : dbg_instr = "spiisr+0x0f0                                   ";
         544 : dbg_instr = "spiisr+0x0f1                                   ";
         545 : dbg_instr = "spiisr+0x0f2                                   ";
         546 : dbg_instr = "spiisr+0x0f3                                   ";
         547 : dbg_instr = "spiisr+0x0f4                                   ";
         548 : dbg_instr = "spiisr+0x0f5                                   ";
         549 : dbg_instr = "spiisr+0x0f6                                   ";
         550 : dbg_instr = "spiisr+0x0f7                                   ";
         551 : dbg_instr = "spiisr+0x0f8                                   ";
         552 : dbg_instr = "spiisr+0x0f9                                   ";
         553 : dbg_instr = "spiisr+0x0fa                                   ";
         554 : dbg_instr = "spiisr+0x0fb                                   ";
         555 : dbg_instr = "spiisr+0x0fc                                   ";
         556 : dbg_instr = "spiisr+0x0fd                                   ";
         557 : dbg_instr = "spiisr+0x0fe                                   ";
         558 : dbg_instr = "spiisr+0x0ff                                   ";
         559 : dbg_instr = "spiisr+0x100                                   ";
         560 : dbg_instr = "spiisr+0x101                                   ";
         561 : dbg_instr = "spiisr+0x102                                   ";
         562 : dbg_instr = "spiisr+0x103                                   ";
         563 : dbg_instr = "spiisr+0x104                                   ";
         564 : dbg_instr = "spiisr+0x105                                   ";
         565 : dbg_instr = "spiisr+0x106                                   ";
         566 : dbg_instr = "spiisr+0x107                                   ";
         567 : dbg_instr = "spiisr+0x108                                   ";
         568 : dbg_instr = "spiisr+0x109                                   ";
         569 : dbg_instr = "spiisr+0x10a                                   ";
         570 : dbg_instr = "spiisr+0x10b                                   ";
         571 : dbg_instr = "spiisr+0x10c                                   ";
         572 : dbg_instr = "spiisr+0x10d                                   ";
         573 : dbg_instr = "spiisr+0x10e                                   ";
         574 : dbg_instr = "spiisr+0x10f                                   ";
         575 : dbg_instr = "spiisr+0x110                                   ";
         576 : dbg_instr = "spiisr+0x111                                   ";
         577 : dbg_instr = "spiisr+0x112                                   ";
         578 : dbg_instr = "spiisr+0x113                                   ";
         579 : dbg_instr = "spiisr+0x114                                   ";
         580 : dbg_instr = "spiisr+0x115                                   ";
         581 : dbg_instr = "spiisr+0x116                                   ";
         582 : dbg_instr = "spiisr+0x117                                   ";
         583 : dbg_instr = "spiisr+0x118                                   ";
         584 : dbg_instr = "spiisr+0x119                                   ";
         585 : dbg_instr = "spiisr+0x11a                                   ";
         586 : dbg_instr = "spiisr+0x11b                                   ";
         587 : dbg_instr = "spiisr+0x11c                                   ";
         588 : dbg_instr = "spiisr+0x11d                                   ";
         589 : dbg_instr = "spiisr+0x11e                                   ";
         590 : dbg_instr = "spiisr+0x11f                                   ";
         591 : dbg_instr = "spiisr+0x120                                   ";
         592 : dbg_instr = "spiisr+0x121                                   ";
         593 : dbg_instr = "spiisr+0x122                                   ";
         594 : dbg_instr = "spiisr+0x123                                   ";
         595 : dbg_instr = "spiisr+0x124                                   ";
         596 : dbg_instr = "spiisr+0x125                                   ";
         597 : dbg_instr = "spiisr+0x126                                   ";
         598 : dbg_instr = "spiisr+0x127                                   ";
         599 : dbg_instr = "spiisr+0x128                                   ";
         600 : dbg_instr = "spiisr+0x129                                   ";
         601 : dbg_instr = "spiisr+0x12a                                   ";
         602 : dbg_instr = "spiisr+0x12b                                   ";
         603 : dbg_instr = "spiisr+0x12c                                   ";
         604 : dbg_instr = "spiisr+0x12d                                   ";
         605 : dbg_instr = "spiisr+0x12e                                   ";
         606 : dbg_instr = "spiisr+0x12f                                   ";
         607 : dbg_instr = "spiisr+0x130                                   ";
         608 : dbg_instr = "spiisr+0x131                                   ";
         609 : dbg_instr = "spiisr+0x132                                   ";
         610 : dbg_instr = "spiisr+0x133                                   ";
         611 : dbg_instr = "spiisr+0x134                                   ";
         612 : dbg_instr = "spiisr+0x135                                   ";
         613 : dbg_instr = "spiisr+0x136                                   ";
         614 : dbg_instr = "spiisr+0x137                                   ";
         615 : dbg_instr = "spiisr+0x138                                   ";
         616 : dbg_instr = "spiisr+0x139                                   ";
         617 : dbg_instr = "spiisr+0x13a                                   ";
         618 : dbg_instr = "spiisr+0x13b                                   ";
         619 : dbg_instr = "spiisr+0x13c                                   ";
         620 : dbg_instr = "spiisr+0x13d                                   ";
         621 : dbg_instr = "spiisr+0x13e                                   ";
         622 : dbg_instr = "spiisr+0x13f                                   ";
         623 : dbg_instr = "spiisr+0x140                                   ";
         624 : dbg_instr = "spiisr+0x141                                   ";
         625 : dbg_instr = "spiisr+0x142                                   ";
         626 : dbg_instr = "spiisr+0x143                                   ";
         627 : dbg_instr = "spiisr+0x144                                   ";
         628 : dbg_instr = "spiisr+0x145                                   ";
         629 : dbg_instr = "spiisr+0x146                                   ";
         630 : dbg_instr = "spiisr+0x147                                   ";
         631 : dbg_instr = "spiisr+0x148                                   ";
         632 : dbg_instr = "spiisr+0x149                                   ";
         633 : dbg_instr = "spiisr+0x14a                                   ";
         634 : dbg_instr = "spiisr+0x14b                                   ";
         635 : dbg_instr = "spiisr+0x14c                                   ";
         636 : dbg_instr = "spiisr+0x14d                                   ";
         637 : dbg_instr = "spiisr+0x14e                                   ";
         638 : dbg_instr = "spiisr+0x14f                                   ";
         639 : dbg_instr = "spiisr+0x150                                   ";
         640 : dbg_instr = "spiisr+0x151                                   ";
         641 : dbg_instr = "spiisr+0x152                                   ";
         642 : dbg_instr = "spiisr+0x153                                   ";
         643 : dbg_instr = "spiisr+0x154                                   ";
         644 : dbg_instr = "spiisr+0x155                                   ";
         645 : dbg_instr = "spiisr+0x156                                   ";
         646 : dbg_instr = "spiisr+0x157                                   ";
         647 : dbg_instr = "spiisr+0x158                                   ";
         648 : dbg_instr = "spiisr+0x159                                   ";
         649 : dbg_instr = "spiisr+0x15a                                   ";
         650 : dbg_instr = "spiisr+0x15b                                   ";
         651 : dbg_instr = "spiisr+0x15c                                   ";
         652 : dbg_instr = "spiisr+0x15d                                   ";
         653 : dbg_instr = "spiisr+0x15e                                   ";
         654 : dbg_instr = "spiisr+0x15f                                   ";
         655 : dbg_instr = "spiisr+0x160                                   ";
         656 : dbg_instr = "spiisr+0x161                                   ";
         657 : dbg_instr = "spiisr+0x162                                   ";
         658 : dbg_instr = "spiisr+0x163                                   ";
         659 : dbg_instr = "spiisr+0x164                                   ";
         660 : dbg_instr = "spiisr+0x165                                   ";
         661 : dbg_instr = "spiisr+0x166                                   ";
         662 : dbg_instr = "spiisr+0x167                                   ";
         663 : dbg_instr = "spiisr+0x168                                   ";
         664 : dbg_instr = "spiisr+0x169                                   ";
         665 : dbg_instr = "spiisr+0x16a                                   ";
         666 : dbg_instr = "spiisr+0x16b                                   ";
         667 : dbg_instr = "spiisr+0x16c                                   ";
         668 : dbg_instr = "spiisr+0x16d                                   ";
         669 : dbg_instr = "spiisr+0x16e                                   ";
         670 : dbg_instr = "spiisr+0x16f                                   ";
         671 : dbg_instr = "spiisr+0x170                                   ";
         672 : dbg_instr = "spiisr+0x171                                   ";
         673 : dbg_instr = "spiisr+0x172                                   ";
         674 : dbg_instr = "spiisr+0x173                                   ";
         675 : dbg_instr = "spiisr+0x174                                   ";
         676 : dbg_instr = "spiisr+0x175                                   ";
         677 : dbg_instr = "spiisr+0x176                                   ";
         678 : dbg_instr = "spiisr+0x177                                   ";
         679 : dbg_instr = "spiisr+0x178                                   ";
         680 : dbg_instr = "spiisr+0x179                                   ";
         681 : dbg_instr = "spiisr+0x17a                                   ";
         682 : dbg_instr = "spiisr+0x17b                                   ";
         683 : dbg_instr = "spiisr+0x17c                                   ";
         684 : dbg_instr = "spiisr+0x17d                                   ";
         685 : dbg_instr = "spiisr+0x17e                                   ";
         686 : dbg_instr = "spiisr+0x17f                                   ";
         687 : dbg_instr = "spiisr+0x180                                   ";
         688 : dbg_instr = "spiisr+0x181                                   ";
         689 : dbg_instr = "spiisr+0x182                                   ";
         690 : dbg_instr = "spiisr+0x183                                   ";
         691 : dbg_instr = "spiisr+0x184                                   ";
         692 : dbg_instr = "spiisr+0x185                                   ";
         693 : dbg_instr = "spiisr+0x186                                   ";
         694 : dbg_instr = "spiisr+0x187                                   ";
         695 : dbg_instr = "spiisr+0x188                                   ";
         696 : dbg_instr = "spiisr+0x189                                   ";
         697 : dbg_instr = "spiisr+0x18a                                   ";
         698 : dbg_instr = "spiisr+0x18b                                   ";
         699 : dbg_instr = "spiisr+0x18c                                   ";
         700 : dbg_instr = "spiisr+0x18d                                   ";
         701 : dbg_instr = "spiisr+0x18e                                   ";
         702 : dbg_instr = "spiisr+0x18f                                   ";
         703 : dbg_instr = "spiisr+0x190                                   ";
         704 : dbg_instr = "spiisr+0x191                                   ";
         705 : dbg_instr = "spiisr+0x192                                   ";
         706 : dbg_instr = "spiisr+0x193                                   ";
         707 : dbg_instr = "spiisr+0x194                                   ";
         708 : dbg_instr = "spiisr+0x195                                   ";
         709 : dbg_instr = "spiisr+0x196                                   ";
         710 : dbg_instr = "spiisr+0x197                                   ";
         711 : dbg_instr = "spiisr+0x198                                   ";
         712 : dbg_instr = "spiisr+0x199                                   ";
         713 : dbg_instr = "spiisr+0x19a                                   ";
         714 : dbg_instr = "spiisr+0x19b                                   ";
         715 : dbg_instr = "spiisr+0x19c                                   ";
         716 : dbg_instr = "spiisr+0x19d                                   ";
         717 : dbg_instr = "spiisr+0x19e                                   ";
         718 : dbg_instr = "spiisr+0x19f                                   ";
         719 : dbg_instr = "spiisr+0x1a0                                   ";
         720 : dbg_instr = "spiisr+0x1a1                                   ";
         721 : dbg_instr = "spiisr+0x1a2                                   ";
         722 : dbg_instr = "spiisr+0x1a3                                   ";
         723 : dbg_instr = "spiisr+0x1a4                                   ";
         724 : dbg_instr = "spiisr+0x1a5                                   ";
         725 : dbg_instr = "spiisr+0x1a6                                   ";
         726 : dbg_instr = "spiisr+0x1a7                                   ";
         727 : dbg_instr = "spiisr+0x1a8                                   ";
         728 : dbg_instr = "spiisr+0x1a9                                   ";
         729 : dbg_instr = "spiisr+0x1aa                                   ";
         730 : dbg_instr = "spiisr+0x1ab                                   ";
         731 : dbg_instr = "spiisr+0x1ac                                   ";
         732 : dbg_instr = "spiisr+0x1ad                                   ";
         733 : dbg_instr = "spiisr+0x1ae                                   ";
         734 : dbg_instr = "spiisr+0x1af                                   ";
         735 : dbg_instr = "spiisr+0x1b0                                   ";
         736 : dbg_instr = "spiisr+0x1b1                                   ";
         737 : dbg_instr = "spiisr+0x1b2                                   ";
         738 : dbg_instr = "spiisr+0x1b3                                   ";
         739 : dbg_instr = "spiisr+0x1b4                                   ";
         740 : dbg_instr = "spiisr+0x1b5                                   ";
         741 : dbg_instr = "spiisr+0x1b6                                   ";
         742 : dbg_instr = "spiisr+0x1b7                                   ";
         743 : dbg_instr = "spiisr+0x1b8                                   ";
         744 : dbg_instr = "spiisr+0x1b9                                   ";
         745 : dbg_instr = "spiisr+0x1ba                                   ";
         746 : dbg_instr = "spiisr+0x1bb                                   ";
         747 : dbg_instr = "spiisr+0x1bc                                   ";
         748 : dbg_instr = "spiisr+0x1bd                                   ";
         749 : dbg_instr = "spiisr+0x1be                                   ";
         750 : dbg_instr = "spiisr+0x1bf                                   ";
         751 : dbg_instr = "spiisr+0x1c0                                   ";
         752 : dbg_instr = "spiisr+0x1c1                                   ";
         753 : dbg_instr = "spiisr+0x1c2                                   ";
         754 : dbg_instr = "spiisr+0x1c3                                   ";
         755 : dbg_instr = "spiisr+0x1c4                                   ";
         756 : dbg_instr = "spiisr+0x1c5                                   ";
         757 : dbg_instr = "spiisr+0x1c6                                   ";
         758 : dbg_instr = "spiisr+0x1c7                                   ";
         759 : dbg_instr = "spiisr+0x1c8                                   ";
         760 : dbg_instr = "spiisr+0x1c9                                   ";
         761 : dbg_instr = "spiisr+0x1ca                                   ";
         762 : dbg_instr = "spiisr+0x1cb                                   ";
         763 : dbg_instr = "spiisr+0x1cc                                   ";
         764 : dbg_instr = "spiisr+0x1cd                                   ";
         765 : dbg_instr = "spiisr+0x1ce                                   ";
         766 : dbg_instr = "spiisr+0x1cf                                   ";
         767 : dbg_instr = "spiisr+0x1d0                                   ";
         768 : dbg_instr = "spiisr+0x1d1                                   ";
         769 : dbg_instr = "spiisr+0x1d2                                   ";
         770 : dbg_instr = "spiisr+0x1d3                                   ";
         771 : dbg_instr = "spiisr+0x1d4                                   ";
         772 : dbg_instr = "spiisr+0x1d5                                   ";
         773 : dbg_instr = "spiisr+0x1d6                                   ";
         774 : dbg_instr = "spiisr+0x1d7                                   ";
         775 : dbg_instr = "spiisr+0x1d8                                   ";
         776 : dbg_instr = "spiisr+0x1d9                                   ";
         777 : dbg_instr = "spiisr+0x1da                                   ";
         778 : dbg_instr = "spiisr+0x1db                                   ";
         779 : dbg_instr = "spiisr+0x1dc                                   ";
         780 : dbg_instr = "spiisr+0x1dd                                   ";
         781 : dbg_instr = "spiisr+0x1de                                   ";
         782 : dbg_instr = "spiisr+0x1df                                   ";
         783 : dbg_instr = "spiisr+0x1e0                                   ";
         784 : dbg_instr = "spiisr+0x1e1                                   ";
         785 : dbg_instr = "spiisr+0x1e2                                   ";
         786 : dbg_instr = "spiisr+0x1e3                                   ";
         787 : dbg_instr = "spiisr+0x1e4                                   ";
         788 : dbg_instr = "spiisr+0x1e5                                   ";
         789 : dbg_instr = "spiisr+0x1e6                                   ";
         790 : dbg_instr = "spiisr+0x1e7                                   ";
         791 : dbg_instr = "spiisr+0x1e8                                   ";
         792 : dbg_instr = "spiisr+0x1e9                                   ";
         793 : dbg_instr = "spiisr+0x1ea                                   ";
         794 : dbg_instr = "spiisr+0x1eb                                   ";
         795 : dbg_instr = "spiisr+0x1ec                                   ";
         796 : dbg_instr = "spiisr+0x1ed                                   ";
         797 : dbg_instr = "spiisr+0x1ee                                   ";
         798 : dbg_instr = "spiisr+0x1ef                                   ";
         799 : dbg_instr = "spiisr+0x1f0                                   ";
         800 : dbg_instr = "spiisr+0x1f1                                   ";
         801 : dbg_instr = "spiisr+0x1f2                                   ";
         802 : dbg_instr = "spiisr+0x1f3                                   ";
         803 : dbg_instr = "spiisr+0x1f4                                   ";
         804 : dbg_instr = "spiisr+0x1f5                                   ";
         805 : dbg_instr = "spiisr+0x1f6                                   ";
         806 : dbg_instr = "spiisr+0x1f7                                   ";
         807 : dbg_instr = "spiisr+0x1f8                                   ";
         808 : dbg_instr = "spiisr+0x1f9                                   ";
         809 : dbg_instr = "spiisr+0x1fa                                   ";
         810 : dbg_instr = "spiisr+0x1fb                                   ";
         811 : dbg_instr = "spiisr+0x1fc                                   ";
         812 : dbg_instr = "spiisr+0x1fd                                   ";
         813 : dbg_instr = "spiisr+0x1fe                                   ";
         814 : dbg_instr = "spiisr+0x1ff                                   ";
         815 : dbg_instr = "spiisr+0x200                                   ";
         816 : dbg_instr = "spiisr+0x201                                   ";
         817 : dbg_instr = "spiisr+0x202                                   ";
         818 : dbg_instr = "spiisr+0x203                                   ";
         819 : dbg_instr = "spiisr+0x204                                   ";
         820 : dbg_instr = "spiisr+0x205                                   ";
         821 : dbg_instr = "spiisr+0x206                                   ";
         822 : dbg_instr = "spiisr+0x207                                   ";
         823 : dbg_instr = "spiisr+0x208                                   ";
         824 : dbg_instr = "spiisr+0x209                                   ";
         825 : dbg_instr = "spiisr+0x20a                                   ";
         826 : dbg_instr = "spiisr+0x20b                                   ";
         827 : dbg_instr = "spiisr+0x20c                                   ";
         828 : dbg_instr = "spiisr+0x20d                                   ";
         829 : dbg_instr = "spiisr+0x20e                                   ";
         830 : dbg_instr = "spiisr+0x20f                                   ";
         831 : dbg_instr = "spiisr+0x210                                   ";
         832 : dbg_instr = "spiisr+0x211                                   ";
         833 : dbg_instr = "spiisr+0x212                                   ";
         834 : dbg_instr = "spiisr+0x213                                   ";
         835 : dbg_instr = "spiisr+0x214                                   ";
         836 : dbg_instr = "spiisr+0x215                                   ";
         837 : dbg_instr = "spiisr+0x216                                   ";
         838 : dbg_instr = "spiisr+0x217                                   ";
         839 : dbg_instr = "spiisr+0x218                                   ";
         840 : dbg_instr = "spiisr+0x219                                   ";
         841 : dbg_instr = "spiisr+0x21a                                   ";
         842 : dbg_instr = "spiisr+0x21b                                   ";
         843 : dbg_instr = "spiisr+0x21c                                   ";
         844 : dbg_instr = "spiisr+0x21d                                   ";
         845 : dbg_instr = "spiisr+0x21e                                   ";
         846 : dbg_instr = "spiisr+0x21f                                   ";
         847 : dbg_instr = "spiisr+0x220                                   ";
         848 : dbg_instr = "spiisr+0x221                                   ";
         849 : dbg_instr = "spiisr+0x222                                   ";
         850 : dbg_instr = "spiisr+0x223                                   ";
         851 : dbg_instr = "spiisr+0x224                                   ";
         852 : dbg_instr = "spiisr+0x225                                   ";
         853 : dbg_instr = "spiisr+0x226                                   ";
         854 : dbg_instr = "spiisr+0x227                                   ";
         855 : dbg_instr = "spiisr+0x228                                   ";
         856 : dbg_instr = "spiisr+0x229                                   ";
         857 : dbg_instr = "spiisr+0x22a                                   ";
         858 : dbg_instr = "spiisr+0x22b                                   ";
         859 : dbg_instr = "spiisr+0x22c                                   ";
         860 : dbg_instr = "spiisr+0x22d                                   ";
         861 : dbg_instr = "spiisr+0x22e                                   ";
         862 : dbg_instr = "spiisr+0x22f                                   ";
         863 : dbg_instr = "spiisr+0x230                                   ";
         864 : dbg_instr = "spiisr+0x231                                   ";
         865 : dbg_instr = "spiisr+0x232                                   ";
         866 : dbg_instr = "spiisr+0x233                                   ";
         867 : dbg_instr = "spiisr+0x234                                   ";
         868 : dbg_instr = "spiisr+0x235                                   ";
         869 : dbg_instr = "spiisr+0x236                                   ";
         870 : dbg_instr = "spiisr+0x237                                   ";
         871 : dbg_instr = "spiisr+0x238                                   ";
         872 : dbg_instr = "spiisr+0x239                                   ";
         873 : dbg_instr = "spiisr+0x23a                                   ";
         874 : dbg_instr = "spiisr+0x23b                                   ";
         875 : dbg_instr = "spiisr+0x23c                                   ";
         876 : dbg_instr = "spiisr+0x23d                                   ";
         877 : dbg_instr = "spiisr+0x23e                                   ";
         878 : dbg_instr = "spiisr+0x23f                                   ";
         879 : dbg_instr = "spiisr+0x240                                   ";
         880 : dbg_instr = "spiisr+0x241                                   ";
         881 : dbg_instr = "spiisr+0x242                                   ";
         882 : dbg_instr = "spiisr+0x243                                   ";
         883 : dbg_instr = "spiisr+0x244                                   ";
         884 : dbg_instr = "spiisr+0x245                                   ";
         885 : dbg_instr = "spiisr+0x246                                   ";
         886 : dbg_instr = "spiisr+0x247                                   ";
         887 : dbg_instr = "spiisr+0x248                                   ";
         888 : dbg_instr = "spiisr+0x249                                   ";
         889 : dbg_instr = "spiisr+0x24a                                   ";
         890 : dbg_instr = "spiisr+0x24b                                   ";
         891 : dbg_instr = "spiisr+0x24c                                   ";
         892 : dbg_instr = "spiisr+0x24d                                   ";
         893 : dbg_instr = "spiisr+0x24e                                   ";
         894 : dbg_instr = "spiisr+0x24f                                   ";
         895 : dbg_instr = "spiisr+0x250                                   ";
         896 : dbg_instr = "spiisr+0x251                                   ";
         897 : dbg_instr = "spiisr+0x252                                   ";
         898 : dbg_instr = "spiisr+0x253                                   ";
         899 : dbg_instr = "spiisr+0x254                                   ";
         900 : dbg_instr = "spiisr+0x255                                   ";
         901 : dbg_instr = "spiisr+0x256                                   ";
         902 : dbg_instr = "spiisr+0x257                                   ";
         903 : dbg_instr = "spiisr+0x258                                   ";
         904 : dbg_instr = "spiisr+0x259                                   ";
         905 : dbg_instr = "spiisr+0x25a                                   ";
         906 : dbg_instr = "spiisr+0x25b                                   ";
         907 : dbg_instr = "spiisr+0x25c                                   ";
         908 : dbg_instr = "spiisr+0x25d                                   ";
         909 : dbg_instr = "spiisr+0x25e                                   ";
         910 : dbg_instr = "spiisr+0x25f                                   ";
         911 : dbg_instr = "spiisr+0x260                                   ";
         912 : dbg_instr = "spiisr+0x261                                   ";
         913 : dbg_instr = "spiisr+0x262                                   ";
         914 : dbg_instr = "spiisr+0x263                                   ";
         915 : dbg_instr = "spiisr+0x264                                   ";
         916 : dbg_instr = "spiisr+0x265                                   ";
         917 : dbg_instr = "spiisr+0x266                                   ";
         918 : dbg_instr = "spiisr+0x267                                   ";
         919 : dbg_instr = "spiisr+0x268                                   ";
         920 : dbg_instr = "spiisr+0x269                                   ";
         921 : dbg_instr = "spiisr+0x26a                                   ";
         922 : dbg_instr = "spiisr+0x26b                                   ";
         923 : dbg_instr = "spiisr+0x26c                                   ";
         924 : dbg_instr = "spiisr+0x26d                                   ";
         925 : dbg_instr = "spiisr+0x26e                                   ";
         926 : dbg_instr = "spiisr+0x26f                                   ";
         927 : dbg_instr = "spiisr+0x270                                   ";
         928 : dbg_instr = "spiisr+0x271                                   ";
         929 : dbg_instr = "spiisr+0x272                                   ";
         930 : dbg_instr = "spiisr+0x273                                   ";
         931 : dbg_instr = "spiisr+0x274                                   ";
         932 : dbg_instr = "spiisr+0x275                                   ";
         933 : dbg_instr = "spiisr+0x276                                   ";
         934 : dbg_instr = "spiisr+0x277                                   ";
         935 : dbg_instr = "spiisr+0x278                                   ";
         936 : dbg_instr = "spiisr+0x279                                   ";
         937 : dbg_instr = "spiisr+0x27a                                   ";
         938 : dbg_instr = "spiisr+0x27b                                   ";
         939 : dbg_instr = "spiisr+0x27c                                   ";
         940 : dbg_instr = "spiisr+0x27d                                   ";
         941 : dbg_instr = "spiisr+0x27e                                   ";
         942 : dbg_instr = "spiisr+0x27f                                   ";
         943 : dbg_instr = "spiisr+0x280                                   ";
         944 : dbg_instr = "spiisr+0x281                                   ";
         945 : dbg_instr = "spiisr+0x282                                   ";
         946 : dbg_instr = "spiisr+0x283                                   ";
         947 : dbg_instr = "spiisr+0x284                                   ";
         948 : dbg_instr = "spiisr+0x285                                   ";
         949 : dbg_instr = "spiisr+0x286                                   ";
         950 : dbg_instr = "spiisr+0x287                                   ";
         951 : dbg_instr = "spiisr+0x288                                   ";
         952 : dbg_instr = "spiisr+0x289                                   ";
         953 : dbg_instr = "spiisr+0x28a                                   ";
         954 : dbg_instr = "spiisr+0x28b                                   ";
         955 : dbg_instr = "spiisr+0x28c                                   ";
         956 : dbg_instr = "spiisr+0x28d                                   ";
         957 : dbg_instr = "spiisr+0x28e                                   ";
         958 : dbg_instr = "spiisr+0x28f                                   ";
         959 : dbg_instr = "spiisr+0x290                                   ";
         960 : dbg_instr = "spiisr+0x291                                   ";
         961 : dbg_instr = "spiisr+0x292                                   ";
         962 : dbg_instr = "spiisr+0x293                                   ";
         963 : dbg_instr = "spiisr+0x294                                   ";
         964 : dbg_instr = "spiisr+0x295                                   ";
         965 : dbg_instr = "spiisr+0x296                                   ";
         966 : dbg_instr = "spiisr+0x297                                   ";
         967 : dbg_instr = "spiisr+0x298                                   ";
         968 : dbg_instr = "spiisr+0x299                                   ";
         969 : dbg_instr = "spiisr+0x29a                                   ";
         970 : dbg_instr = "spiisr+0x29b                                   ";
         971 : dbg_instr = "spiisr+0x29c                                   ";
         972 : dbg_instr = "spiisr+0x29d                                   ";
         973 : dbg_instr = "spiisr+0x29e                                   ";
         974 : dbg_instr = "spiisr+0x29f                                   ";
         975 : dbg_instr = "spiisr+0x2a0                                   ";
         976 : dbg_instr = "spiisr+0x2a1                                   ";
         977 : dbg_instr = "spiisr+0x2a2                                   ";
         978 : dbg_instr = "spiisr+0x2a3                                   ";
         979 : dbg_instr = "spiisr+0x2a4                                   ";
         980 : dbg_instr = "spiisr+0x2a5                                   ";
         981 : dbg_instr = "spiisr+0x2a6                                   ";
         982 : dbg_instr = "spiisr+0x2a7                                   ";
         983 : dbg_instr = "spiisr+0x2a8                                   ";
         984 : dbg_instr = "spiisr+0x2a9                                   ";
         985 : dbg_instr = "spiisr+0x2aa                                   ";
         986 : dbg_instr = "spiisr+0x2ab                                   ";
         987 : dbg_instr = "spiisr+0x2ac                                   ";
         988 : dbg_instr = "spiisr+0x2ad                                   ";
         989 : dbg_instr = "spiisr+0x2ae                                   ";
         990 : dbg_instr = "spiisr+0x2af                                   ";
         991 : dbg_instr = "spiisr+0x2b0                                   ";
         992 : dbg_instr = "spiisr+0x2b1                                   ";
         993 : dbg_instr = "spiisr+0x2b2                                   ";
         994 : dbg_instr = "spiisr+0x2b3                                   ";
         995 : dbg_instr = "spiisr+0x2b4                                   ";
         996 : dbg_instr = "spiisr+0x2b5                                   ";
         997 : dbg_instr = "spiisr+0x2b6                                   ";
         998 : dbg_instr = "spiisr+0x2b7                                   ";
         999 : dbg_instr = "spiisr+0x2b8                                   ";
         1000 : dbg_instr = "spiisr+0x2b9                                   ";
         1001 : dbg_instr = "spiisr+0x2ba                                   ";
         1002 : dbg_instr = "spiisr+0x2bb                                   ";
         1003 : dbg_instr = "spiisr+0x2bc                                   ";
         1004 : dbg_instr = "spiisr+0x2bd                                   ";
         1005 : dbg_instr = "spiisr+0x2be                                   ";
         1006 : dbg_instr = "spiisr+0x2bf                                   ";
         1007 : dbg_instr = "spiisr+0x2c0                                   ";
         1008 : dbg_instr = "spiisr+0x2c1                                   ";
         1009 : dbg_instr = "spiisr+0x2c2                                   ";
         1010 : dbg_instr = "spiisr+0x2c3                                   ";
         1011 : dbg_instr = "spiisr+0x2c4                                   ";
         1012 : dbg_instr = "spiisr+0x2c5                                   ";
         1013 : dbg_instr = "spiisr+0x2c6                                   ";
         1014 : dbg_instr = "spiisr+0x2c7                                   ";
         1015 : dbg_instr = "spiisr+0x2c8                                   ";
         1016 : dbg_instr = "spiisr+0x2c9                                   ";
         1017 : dbg_instr = "spiisr+0x2ca                                   ";
         1018 : dbg_instr = "spiisr+0x2cb                                   ";
         1019 : dbg_instr = "spiisr+0x2cc                                   ";
         1020 : dbg_instr = "spiisr+0x2cd                                   ";
         1021 : dbg_instr = "spiisr+0x2ce                                   ";
         1022 : dbg_instr = "spiisr+0x2cf                                   ";
         1023 : dbg_instr = "spiisr+0x2d0                                   ";
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
    .INIT_04(256'hF0181000193F202C00101A05B023202C0011B0232116000B00110AD000111AE3),
    .INIT_05(256'h0AD000111ADC2060DDFF1AD800461A06006550009C209B219A229D235000006C),
    .INIT_06(256'hB021B0311F08B02350009901EA909901EB909901EC90211E1AAAB023000B0011),
    .INIT_07(256'h190100825000AC901901007E20461A9900461AF000461A66B0235000606E9F01),
    .INIT_08(256'h1A9FB0235000DF10DF11FA181A005F082089DA001F025000AA9019015000AB90),
    .INIT_09(256'h01131A04609ADB241B01CAB01B201AFF202C007A006900110069001100690010),
    .INIT_0A(256'h1100101E5000700E90105000011201131A1001131A0801131A1401131A0C0112),
    .INIT_0B(256'hD010005260D6DF023FEE0F00901E20891F0620B9D100A0B0D024100161F08F00),
    .INIT_0C(256'h001111FF001C20850116E0C7910100119A3011FF002E60CDD00230EF1DFF60C2),
    .INIT_0D(256'h208500571DFF20DED002005260E0DFDC3FFD0F0020891F02B023E0CF9101DA30),
    .INIT_0E(256'h002760F1D0E42085003A005260EDD0E320891F02DA20DB21DC22008E60E8D09E),
    .INIT_0F(256'hD0FF20891F06208B1F02FF181F0160FDFD42FA79FB65DC33005260FFD0FE2085),

    // Address 256 to 511
    .INIT_10(256'h1F062098DF10DF111F02FD17FA16FB15FC14005220891F066106DA00BA18610F),
    .INIT_11(256'h4D060DA05000008200461A040069011E1A01B0235000B00400031A0001122089),
    .INIT_12(256'h00735000E126BE00BD009C015000612A3A0100491C004E004D064E004D064E00),
    .INIT_13(256'h10001000100010001000100010001000100010001000100010009001DF081F01),
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
    .INIT_1F(256'h212F100010001000100010001000100010001000100010001000100010001000),

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
    .INITP_01(256'h622355B6B6AD8AADA32D08B68AB60B432D0237500C2A22228D60AAAA2AA0D218),

    // Address 256 to 511
    .INITP_02(256'h0000000000000000000000000000000000000028AD5B21554A8A2A8A2A2AA8D3),
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
