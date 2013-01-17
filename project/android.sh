rm -rf "obj"
rm ../ndll/Android/libhypertouch.so
echo "Compiling for armv6"
haxelib run hxcpp Build.xml -Dandroid -Dfulldebug