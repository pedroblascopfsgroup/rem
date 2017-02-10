#!/bin/bash

echo "SE INICIA EL PROCESO DE RENOMBRADO DE LOS FICHEROS F1 Y F2"

echo "Descomprimiendo ficheros"
unrar e Ficheros_FaseI_*.rar
unrar e Ficheros_FaseII_*.rar


echo "Organizando, renombrando y distribuyendo ficheros"
cat Fich_Trabajo1.dat > Fich_Trabajo.dat
cat Fich_Trabajo2.dat >> Fich_Trabajo.dat

rm -r Fich_Trabajo1.dat
rm -r Fich_Trabajo2.dat

mv Fich_Activo_Cabecera.dat 											../fase1/migracion_BNK/CTLs_DATs/DATs/ACTIVO_CABECERA.dat
mv Fich_Activo_DatosAdicionales.dat 									../fase1/migracion_BNK/CTLs_DATs/DATs/ACTIVO_DATOSADICIONALES.dat
mv Fich_Activo_Titulo.dat 												../fase1/migracion_BNK/CTLs_DATs/DATs/ACTIVO_TITULO.dat
mv Fich_Activo_PlanDinVentas.dat 										../fase1/migracion_BNK/CTLs_DATs/DATs/ACTIVO_PLANDINVENTAS.dat
mv Fich_Activo_Adj_Judicial.dat 										../fase1/migracion_BNK/CTLs_DATs/DATs/ACTIVO_ADJ_JUDICIAL.dat
mv Fich_Activo_Adj_No_Judicial.dat 										../fase1/migracion_BNK/CTLs_DATs/DATs/ACTIVO_ADJ_NO_JUDICIAL.dat
mv Fich_Com_Propietarios_Cabecera.dat 									../fase1/migracion_BNK/CTLs_DATs/DATs/COM_PROPIETARIOS_CABECERA.dat
mv Fich_Propietarios_Activo.dat 										../fase1/migracion_BNK/CTLs_DATs/DATs/PROPIETARIOS_ACTIVO.dat
mv Fich_Cargas_Activo.dat 												../fase1/migracion_BNK/CTLs_DATs/DATs/CARGAS_ACTIVO.dat
mv Fich_Llaves_Activo.dat 												../fase1/migracion_BNK/CTLs_DATs/DATs/LLAVES_ACTIVO.dat
mv Fich_Tasaciones_Activo.dat 											../fase1/migracion_BNK/CTLs_DATs/DATs/TASACIONES_ACTIVO.dat
mv Fich_Infocomercial_Activo.dat 										../fase1/migracion_BNK/CTLs_DATs/DATs/INFOCOMERCIAL_ACTIVO.dat
mv Fich_Calidades_Activo.dat 											../fase1/migracion_BNK/CTLs_DATs/DATs/CALIDADES_ACTIVO.dat
mv Fich_Agrupaciones_Activo1.dat 										../fase1/migracion_BNK/CTLs_DATs/DATs/AGRUPACIONES_ACTIVO.dat
mv Fich_Agrupaciones.dat 												../fase1/migracion_BNK/CTLs_DATs/DATs/AGRUPACIONES.dat
mv Fich_Activo_Precios.dat 												../fase1/migracion_BNK/CTLs_DATs/DATs/ACTIVO_PRECIO.dat
mv Fich_Catastro_Activo.dat 											../fase1/migracion_BNK/CTLs_DATs/DATs/CATASTRO_ACTIVO.dat
mv Fich_Infocomercial_Distribucion.dat 									../fase1/migracion_BNK/CTLs_DATs/DATs/INFOCOMERCIAL_DISTRIBUCION.dat
mv Fich_Observaciones_Agrupacion.dat 									../fase1/migracion_BNK/CTLs_DATs/DATs/OBSERVACIONES_AGRUPACION.dat
mv Fich_Presupuesto_Trabajo.dat 										../fase1/migracion_BNK/CTLs_DATs/DATs/PRESUPUESTO_TRABAJO.dat
mv Fich_Movimientos_Llave.dat 											../fase1/migracion_BNK/CTLs_DATs/DATs/MOVIMIENTOS_LLAVE.dat
mv Fich_Propietarios_Cabecera.dat 										../fase1/migracion_BNK/CTLs_DATs/DATs/PROPIETARIOS_CABECERA.dat
mv Fich_Proveedor_Contacto.dat 											../fase1/migracion_BNK/CTLs_DATs/DATs/PROVEEDOR_CONTACTO.dat
mv Fich_Proveedores.dat 												../fase1/migracion_BNK/CTLs_DATs/DATs/PROVEEDORES.dat
mv Fich_Trabajo.dat 													../fase1/migracion_BNK/CTLs_DATs/DATs/TRABAJO.dat
mv Fich_Propietarios.dat 												../fase1/migracion_BNK/CTLs_DATs/DATs/PROPIETARIOS.dat
mv Fich_Proveedor_Direccion.dat 										../fase1/migracion_BNK/CTLs_DATs/DATs/PROVEEDORES_DIRECCIONES.dat
mv Fich_Admision_Documento.dat											../fase1/migracion_BNK/CTLs_DATs/DATs/ADMISION_DOCUMENTOS.dat
mv Fich_Entidad_Proveedor.dat											../fase1/migracion_BNK/CTLs_DATs/DATs/ENTIDAD_PROVEEDOR.dat
mv Fich_Subdivisiones_Agrupacion.dat									../fase1/migracion_BNK/CTLs_DATs/DATs/SUBDIVISIONES_AGRUPACION.dat

#echo "Cambiando nombre a los DATs de migración de FASE 2"

mv Fich_Act_Activo.dat 													../rem_fase2/migracion_fase2/CTLs_DATs/DATs/ACTIVOS.dat
mv Fich_Activo_Propuestas.dat 											../rem_fase2/migracion_fase2/CTLs_DATs/DATs/ACTIVO_PROPUESTAS.dat
mv Fich_Activos_Hito.dat 												../rem_fase2/migracion_fase2/CTLs_DATs/DATs/ACTIVOS_ESTADOS.dat
mv Fich_Agr_Agrupaciones.dat 											../rem_fase2/migracion_fase2/CTLs_DATs/DATs/AGRUPACIONES.dat
mv Fich_Clientes_Comerciales.dat 										../rem_fase2/migracion_fase2/CTLs_DATs/DATs/CLIENTES_COMERCIALES.dat
mv Fich_Historico_Publicacion.dat 										../rem_fase2/migracion_fase2/CTLs_DATs/DATs/HIST_ESTADOS_PUBLICACIONES.dat
mv Fich_Ofertas.dat 													../rem_fase2/migracion_fase2/CTLs_DATs/DATs/OFERTAS.dat
mv Fich_Ofertas_Alquiler.dat 											../rem_fase2/migracion_fase2/CTLs_DATs/DATs/ACTIVOS_DATOS_ALQUILERES.dat
mv Fich_Perimetro_Activo.dat 											../rem_fase2/migracion_fase2/CTLs_DATs/DATs/PERIMETRO_ACTIVOS.dat
mv Fich_Propuestas_Precio.dat 											../rem_fase2/migracion_fase2/CTLs_DATs/DATs/PROPUESTAS_PRECIOS.dat
mv Fich_Visitas.dat 													../rem_fase2/migracion_fase2/CTLs_DATs/DATs/VISITAS.dat
mv Fich_Observaciones_Oferta.dat 										../rem_fase2/migracion_fase2/CTLs_DATs/DATs/OFERTAS_OBSERVACIONES.dat
mv Fich_Ofertas_Activo.dat 												../rem_fase2/migracion_fase2/CTLs_DATs/DATs/OFERTAS_ACTIVO.dat
mv Fich_Posicionamiento.dat 											../rem_fase2/migracion_fase2/CTLs_DATs/DATs/POSICIONAMIENTOS.dat
mv Fich_Reservas.dat 													../rem_fase2/migracion_fase2/CTLs_DATs/DATs/RESERVAS.dat
mv Fich_Titulares_Adicionales.dat 										../rem_fase2/migracion_fase2/CTLs_DATs/DATs/TITULARES_ADICIONALES_OFERTA.dat
mv Fich_Historico_Valoraciones.dat										../rem_fase2/migracion_fase2/CTLs_DATs/DATs/HIST_ACTIVOS_PRECIOS.dat
mv Fich_Gastos_Proveedores_Activos.dat									../rem_fase2/migracion_fase2/CTLs_DATs/DATs/GASTOS_PROVEEDORES_ACT_TBJ.dat	
mv Fich_Gastos_Proveedores.dat											../rem_fase2/migracion_fase2/CTLs_DATs/DATs/GASTOS_PROVEEDORES.dat
mv Fich_Gastos_Info_Contabilidad.dat									../rem_fase2/migracion_fase2/CTLs_DATs/DATs/GASTOS_INFORMACION_CONTABILIDAD.dat
mv Fich_Gastos_Gestion.dat												../rem_fase2/migracion_fase2/CTLs_DATs/DATs/GESTION_GASTOS.dat
mv Fich_Gastos_Expediente.dat											../rem_fase2/migracion_fase2/CTLs_DATs/DATs/COMISIONES_GASTOS.dat
mv Fich_Comprador_Expediente.dat										../rem_fase2/migracion_fase2/CTLs_DATs/DATs/COMPRADOR_EXPEDIENTE.dat
mv Fich_Compradores.dat													../rem_fase2/migracion_fase2/CTLs_DATs/DATs/COMPRADORES.dat
mv Fich_Condiciones_Especificas.dat										../rem_fase2/migracion_fase2/CTLs_DATs/DATs/COND_ESPEC_ACTIVOS_PUBLICADOS.dat
mv Fich_Condiciones_Oferta_Aceptada.dat									../rem_fase2/migracion_fase2/CTLs_DATs/DATs/CONDICIONANTE_OFERTA_ACEPTADA.dat
mv Fich_Formalizaciones.dat												../rem_fase2/migracion_fase2/CTLs_DATs/DATs/FORMALIZACIONES.dat
mv Fich_Gastos_Detalle_Economico.dat									../rem_fase2/migracion_fase2/CTLs_DATs/DATs/DETALLE_ECONOMICO_GASTOS.dat
mv Fich_Gastos_Provision.dat											../rem_fase2/migracion_fase2/CTLs_DATs/DATs/GASTOS_PROVISIONES.dat
mv Fich_Subsanaciones.dat												../rem_fase2/migracion_fase2/CTLs_DATs/DATs/SUBSANACIONES.dat
mv Fich_Propietarios_Historico.dat										../rem_fase2/migracion_fase2/CTLs_DATs/DATs/PROPIETARIOS_HISTORICO.dat

echo "Nombres cambiados, verificar cambios"

