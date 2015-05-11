#ª/bin/bash




echo "Instalando en local el Procedimientos Plugin"
cd recovery-procedimientos-plugin
./copy.sh $*

cd ..

echo "Instalando en local el Procedimientos BPM"
cd recovery-procedimientos-bpm
./copy.sh $*
