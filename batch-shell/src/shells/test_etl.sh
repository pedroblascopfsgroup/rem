filename=$(basename $0)
extension="${filename##*.}"
name="${filename%.*}"

echo $filename
echo $extension
echo $name
