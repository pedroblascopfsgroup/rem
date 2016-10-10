#! /bin/bash

clear

echo ".########..########.##.....##.......########....###.....######..########........#######.."
echo ".##.....##.##.......###...###.......##.........##.##...##....##.##.............##.....##."
echo ".##.....##.##.......####.####.......##........##...##..##.......##....................##."
echo ".########..######...##.###.##.......######...##.....##..######..######..........#######.."
echo ".##...##...##.......##.....##.......##.......#########.......##.##.............##........"
echo ".##....##..##.......##.....##.......##.......##.....##.##....##.##.............##........"
echo ".##.....##.########.##.....##.......##.......##.....##..######..########.......#########."

# [1/4] Lanzando script ./000_Preparacion_migracion.sh

./000_Preparacion_migracion.sh

# [2/4] Lanzando script ./001_Creacion_de_tablas.sh...

./001_Creacion_de_tablas.sh $1

# [3/4] Lanzando script ./002_Carga_de_tablas_de_migracion.sh...

./003_Comprobacion_de_diccionarios.sh $1

# [4/4] Lanzando script ./003_Migrar.sh...

./004_Migrar.sh $1

echo "[INFO] Proceso de migración finalizado."
