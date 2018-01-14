import qbs

MachinekitApplication {
    name: "Replicookie"
    halFiles: ["Replicookie.hal",
               "velocity-extruding.hal"]
    configFiles: ["Replicookie.ini"]
    otherFiles: ["tool.tbl", "subroutines"]
    compFiles: ["thermistor_check.comp"]
    linuxcncIni: "Replicookie.ini"
    //display: "xwing.local:0.0"
}
