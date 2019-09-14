 Trinamic SPI configurer
 ========
 ![Gui](./Trinamic_spi.png "MK Trinamic_SPI")
 
 Online Mksocfpga enabled configs:
 https://github.com/machinekit/mksocfpga/blob/master/HW/hm2/config/DExx_Nano_xxx_Cramps/PIN_3x24_cap_enc_bspi.vhd
 or
 https://github.com/machinekit/mksocfpga/blob/master/HW/hm2/config/DExx_Nano_xxx_Cramps/PIN_3x24_cap_enc_dbspi.vhd
 
 
    git clone  https://github.com/the-snowwhite/Hm2-soc_FDM.git
    cd Hm2-soc_FDM/projects/Trinamic/20-bit_Comp
    sudo comp --install trinamic_dbspi.comp
    cd ..
    mklauncher .

Then run MachinekitClient on PC

Usable Trinamic 26x(x) BOB mounting pcb's
https://github.com/the-snowwhite/socfpga-kicad/tree/master/Trinamic
