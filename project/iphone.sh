rm -rf "obj"
echo "compiling for armv6"
haxelib run hxcpp Build.xml -Diphoneos -debug
echo "compiling for armv7"
haxelib run hxcpp Build.xml -Diphoneos -DHXCPP_ARMV7 -debug
echo "compiling for simulator"
haxelib run hxcpp Build.xml -Diphonesim -debug