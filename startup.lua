print("Select program to start")
print("\t1: BloodMagic - Slates")
print("\t2: EnderIO - Grains of Infinity")
Program = tonumber(read())
if (Program == 1) then
    shell.run("BloodMagic/SlateAutomation")
elseif (Program == 2) then
    shell.run("EnderIO/grainsofinfinity")
end