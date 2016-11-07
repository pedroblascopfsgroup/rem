#!/bin/bash

echo "Cambiando nombre a los DATs de migración"

mv Fich_Act_Activo.dat ACTIVOS.dat
mv Fich_Activo_Propuestas.dat ACTIVO_PROPUESTAS.dat
mv Fich_Activos_Hito.dat ACTIVOS_ESTADOS.dat
mv Fich_Agr_Agrupaciones.dat AGRUPACIONES.dat
mv Fich_Clientes_Comerciales.dat CLIENTES_COMERCIALES.dat
mv Fich_Historico_Publicacion.dat HIST_ESTADOS_PUBLICACIONES.dat
mv Fich_Ofertas.dat OFERTAS.dat
mv Fich_Ofertas_Alquiler.dat ACTIVOS_DATOS_ALQUILER.dat
mv Fich_Perimetro_Activo.dat PERIMETRO_ACTIVOS.dat
mv Fich_Propietarios.dat PROPIETARIOS.dat
mv Fich_Propuestas_Precio.dat PROPUESTAS_PRECIOS.dat
mv Fich_Proveedor_Direccion.dat PROVEEDORES_DIRECCIONES.dat
mv Fich_Visitas.dat VISITAS.dat


echo "Nombres cambiados, verificar cambios"

