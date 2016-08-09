#Find all files that contain 'thumb' and delete
sudo find . -name "*thumb*" -delete

#Divide Acquisitions
f_short=NWG0026A_40G_60R_P2_
for f in NWG0026A_40G_60R_P2_*; do
size=${#f_short}
let size+=2
echo ${f:0:($size)}
t=${f:0:($size)}
mkdir -p "${t}"
mv -v "$f" "${t}/"
done

#Divide Positions
f_short=_s
for f in *_s*; do
prefix=${f%%_s*}
size=${#prefix}
t=${f:$size:3}
mkdir -p "${t}"
mv "$f" "${t}/"
done

#Move all files up one directory
for f in *.TIF; do
mv $f/* .
rmdir $f
done
