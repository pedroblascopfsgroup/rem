delete from ACT_GES_DISTRIBUCION;
delete from ACT_PVE_PROVEEDOR where USUARIOCREAR like '%MIG%';
delete from ACT_TAS_TASACION;
delete from ACT_CRG_CARGAS;
delete from ACT_ADA_ADJUNTO_ACTIVO;
delete from ACT_TIT_TITULO;
delete from ACT_PDV_PLAN_DIN_VENTAS;
commit;
delete from ACT_SDV_SUBDIVISION_ACTIVO;
delete from ACT_AJD_ADJJUDICIAL;
delete from ACT_ADN_ADJNOJUDICIAL;
delete from ACT_ADM_INF_ADMINISTRATIVA;
delete from ACT_SPS_SIT_POSESORIA;
delete from ACT_REG_INFO_REGISTRAL;
commit;
delete from ACT_LOC_LOCALIZACION;
delete from ACT_CPR_COM_PROPIETARIOS;
delete from ACT_MLV_MOVIMIENTO_LLAVE;
delete from ACT_PAC_PROPIETARIO_ACTIVO;
delete from ACT_PRO_PROPIETARIO;
commit;
delete from ACT_TBJ;
delete from ACT_TBJ_TRABAJO;
delete from ACT_CAT_CATASTRO;
delete from ACT_LLV_LLAVE;
delete from ACT_VAL_VALORACIONES;
delete from ACT_EDI_EDIFICIO;
commit;
delete from ACT_LCO_LOCAL_COMERCIAL;
delete from ACT_APR_PLAZA_APARCAMIENTO;
delete from ACT_CRI_CARPINTERIA_INT;
delete from ACT_CRE_CARPINTERIA_EXT;
delete from ACT_PRV_PARAMENTO_VERTICAL;
commit;
delete from GAH_GESTOR_ACTIVO_HISTORICO;
delete from GAC_GESTOR_ADD_ACTIVO;
delete from GEE_GESTOR_ENTIDAD;
delete from GEH_GESTOR_ENTIDAD_HIST;
commit;
delete from ACT_SOL_SOLADO;
delete from ACT_INF_INFRAESTRUCTURA;
delete from ACT_ZCO_ZONA_COMUN;
delete from ACT_INS_INSTALACION;
delete from ACT_BNY_BANYO;
commit;
delete from ACT_COC_COCINA;
delete from ACT_DIS_DISTRIBUCION;
delete from ACT_AGA_AGRUPACION_ACTIVO;
delete from ACT_ONV_OBRA_NUEVA;
commit;
delete from ACT_RES_RESTRINGIDA;
delete from ACT_AGR_AGRUPACION;
delete from ACT_VIV_VIVIENDA;
delete from ACT_ICO_INFO_COMERCIAL;
commit;
delete from ACT_ACTIVO;

COMMIT;


delete from bie_car_cargas;
commit;

delete from bie_adicional;
commit;

delete from bie_adj_adjudicacion;
commit;

delete from bie_anc_analisis_contratos;
commit;

delete from bie_bien_entidad;
commit;


delete from bie_datos_registrales;
commit;

delete from bie_localizacion;
commit;

delete from bie_sui_subasta_instrucciones;
commit;


delete from bie_valoraciones;
commit;

delete from lob_lote_bien;
delete from emp_nmbembargos_procedimientos;
commit;

delete from bie_bien;
commit;

--delete from RSR_REGISTRO_SQLS;
--commit;
