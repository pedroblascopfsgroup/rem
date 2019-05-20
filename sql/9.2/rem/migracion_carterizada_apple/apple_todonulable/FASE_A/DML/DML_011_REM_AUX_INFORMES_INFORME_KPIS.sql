--/*
--##########################################
--## AUTOR=DANIEL ALBERT PÉREZ
--## FECHA_CREACION=20170627
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.6
--## INCIDENCIA_LINK=HREOS-2310
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES:  Rellenar el array
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE
  
  TYPE T_VIC IS TABLE OF VARCHAR2(4000 CHAR);
  TYPE T_ARRAY_VIC IS TABLE OF T_VIC;
   
  V_ESQUEMA          VARCHAR2(25 CHAR):= 'REM01'; 	-- '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M   VARCHAR2(25 CHAR):= 'REMMASTER'; 	-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_TABLA   VARCHAR2(30 CHAR):= 'MIG2_COUNTS_INFORME_KPIS'; 
  TABLE_COUNT number(3); 											-- Vble. para validar la existencia de las Tablas.
  err_num NUMBER; 													-- Numero de errores
  err_msg VARCHAR2(2048); 											-- Mensaje de error
  V_MSQL VARCHAR2(4000 CHAR);
  V_EXIST NUMBER(10);

	V_VIC T_ARRAY_VIC := T_ARRAY_VIC
	(
  		--1er BLOQUE: ACTIVOS y AGRUPACIONES
  		T_VIC( 1,'SELECT ''''ACTIVO. Total de registros. Número de registros.'''', ''''Activos totales'''', COUNT(1) FROM REM01.MIG_ACA_CABECERA'),
		T_VIC( 2,'SELECT ''''ACTIVO. Tipo de activo. Número de registros por valor (Según diccionario).'''', DD_TPA_DESCRIPCION, COUNT(1) FROM REM01.MIG_ACA_CABECERA A JOIN REM01.DD_TPA_TIPO_ACTIVO T ON T.DD_TPA_CODIGO = A.TIPO_ACTIVO GROUP BY T.DD_TPA_DESCRIPCION'),
		T_VIC( 3,'SELECT ''''ACTIVO. Subtipo activo. Número de registros por valor (Según diccionario).'''', DD_SAC_DESCRIPCION, COUNT(1) FROM REM01.MIG_ACA_CABECERA A JOIN REM01.DD_SAC_SUBTIPO_ACTIVO T ON T.DD_SAC_CODIGO = A.SUBTIPO_ACTIVO GROUP BY T.DD_SAC_DESCRIPCION'),
		T_VIC( 4,'SELECT ''''ACTIVO. Catalogación del tipo de título del activo. Número de registros por valor (Según diccionario).'''', TIT.DD_TTA_DESCRIPCION, COUNT(1) FROM REM01.MIG_ACA_CABECERA A JOIN REM01.DD_TTA_TIPO_TITULO_ACTIVO TIT ON A.TIPO_TITULO = TIT.DD_TTA_CODIGO GROUP BY TIT.DD_TTA_DESCRIPCION'),
		T_VIC( 5,'SELECT ''''ACTIVO. Situación comercial del activo. Número de registros por valor (Según diccionario).'''', SCM.DD_SCM_DESCRIPCION, COUNT(1) FROM REM01.MIG_ACA_CABECERA A JOIN REM01.DD_SCM_SITUACION_COMERCIAL SCM ON A.SITUACION_COMERCIAL = SCM.DD_SCM_CODIGO GROUP BY SCM.DD_SCM_DESCRIPCION'),
		T_VIC( 6,'SELECT ''''ACTIVO. Indicador de si el activo tiene cargas.'''', ''''Activos con cargas'''', COUNT(1) FROM REM01.MIG_ACA_CABECERA A WHERE NVL(A.ACT_CON_CARGAS,0) = 1'),
		T_VIC( 7,'SELECT ''''ACTIVO. Indicador de si el activo es de VPO.'''', ''''Activos VPO'''', COUNT(1) FROM REM01.MIG_ACA_CABECERA A WHERE NVL(A.ACT_VPO,0) = 1'),
		T_VIC( 8,'SELECT ''''ACTIVO. Estado de admisión, departamento de Admisión.'''', ''''Activos con estado de admisión, departamento de Admisión'''', COUNT(1) FROM REM01.MIG_ACA_CABECERA A WHERE NVL(A.ESTADO_ADMISION,0) = 1'),
		T_VIC( 9,'SELECT ''''ACTIVO. Indicador estado calidad.'''', ''''Activos con estado calidad'''', COUNT(1) FROM REM01.MIG2_ACT_ACTIVO A WHERE NVL(A.SELLO_CALIDAD,0) = 1'),
		T_VIC(10,'SELECT ''''ACTIVO. Fecha de toma de posesión del activo. Número de registros con dicha fecha informada'''', ''''Activos con fecha de toma de posesión'''', COUNT(1) FROM REM01.MIG_ACA_CABECERA A JOIN REM01.MIG_ADA_DATOS_ADI S ON S.ACt_NUMERO_ACTIVO = A.ACt_NUMERO_ACTIVO WHERE S.SPS_FECHA_TOMA_POSESION IS NOT NULL'),
		T_VIC(11,'SELECT ''''ACTIVO. Indicador de si el activo está inscrito en división horizontal.'''', ''''Activos inscritos en división horizontal'''', COUNT(1) FROM REM01.MIG_ACA_CABECERA A WHERE NVL(A.ACT_DIVISION_HORIZONTAL,0) = 1'),
		T_VIC(12,'SELECT ''''ACTIVO. Codigo del municipio en el que se ubica el activo. Número de registros por valor (Según diccionario).'''', L.MUNICIPIO, COUNT(1) FROM REM01.MIG_ACA_CABECERA A JOIN REM01.MIG_ADA_DATOS_ADI L ON L.ACT_NUMERO_ACTIVO = A.ACT_NUMERO_ACTIVO GROUP BY L.MUNICIPIO'),
		T_VIC(13,'SELECT ''''ACTIVO. Codigo de la provincia en el que se ubica el activo. Número de registros por valor (Según diccionario).'''', L.PROVINCIA, COUNT(1) FROM REM01.MIG_ACA_CABECERA A JOIN REM01.MIG_ADA_DATOS_ADI L ON L.ACT_NUMERO_ACTIVO = A.ACT_NUMERO_ACTIVO GROUP BY L.PROVINCIA'),
		T_VIC(14,'SELECT ''''ACTIVO. Importe de adjudicación de los activos. Importe total.'''', ''''Importe de adjudicación'''', NVL(SUM(B.ADJ_IMPORTE),0) IMPORTE_ADJUDICACION FROM REM01.MIG_ACA_CABECERA A JOIN REM01.MIG_ADJ_JUDICIAL B ON B.ACT_NUMERO_ACTIVO = A.ACT_NUMERO_ACTIVO'),
		T_VIC(15,'SELECT ''''AGRUPACION. Total de registros. Número de registros.'''', ''''Agrupaciones totales'''', COUNT(1) FROM REM01.MIG_AAG_AGRUPACIONES A'),	
		T_VIC(16,'SELECT ''''AGRUPACION. Tipo de agrupación. Número de registros por valor (Según diccionario).'''', T.DD_TAG_DESCRIPCION, COUNT(1) FROM REM01.MIG_AAG_AGRUPACIONES A JOIN REM01.DD_TAG_TIPO_AGRUPACION T ON A.TIPO_AGRUPACION = T.DD_TAG_CODIGO GROUP BY T.DD_TAG_DESCRIPCION'),
		T_VIC(17,'SELECT ''''AGRUPACION. Fecha de baja de la agrupación. Número de registros con dicha fecha informada.'''', ''''Total de agrupaciones con fecha de baja'''', COUNT(1) FROM REM01.MIG_AAG_AGRUPACIONES A WHERE A.AGR_FECHA_BAJA IS NOT NULL'),
		T_VIC(18,'SELECT ''''AGRUPACION. Indicador de si la agrupación ha sido publicada en la web.'''', ''''Agrupaciones publicadas en web'''', COUNT(1) FROM REM01.MIG_AAG_AGRUPACIONES A WHERE NVL(AGR_PUBLICADO,0) = 1')
		/*
		T_VIC(19,'SELECT ''''TRABAJO. Total de registros. Número de registros.'''', ''''Trabajos totales'''', COUNT(1) FROM REM01.MIG_ATR_TRABAJO A'),
		T_VIC(20,'SELECT ''''TRABAJO. Tipo de trabajo solicitado. Número de registros por valor (Según diccionario).'''', DD_TTR_DESCRIPCION, COUNT(1) FROM REM01.MIG_ATR_TRABAJO A JOIN REM01.DD_TTR_TIPO_TRABAJO T ON A.TIPO_TRABAJO = T.DD_TTR_CODIGO GROUP BY DD_TTR_DESCRIPCION'),
		T_VIC(21,'SELECT ''''TRABAJO. Subtipo de trabajo solicitado. Número de registros por valor (Según diccionario).'''', DD_STR_DESCRIPCION, COUNT(1) FROM REM01.MIG_ATR_TRABAJO A JOIN REM01.DD_STR_SUBTIPO_TRABAJO T ON A.SUBTIPO_TRABAJO = T.DD_STR_CODIGO GROUP BY DD_STR_DESCRIPCION'),
		T_VIC(22,'SELECT ''''TRABAJO. Estado trabajo solicitado. Número de registros por valor(Según diccionario).'''', DD_EST_DESCRIPCION, COUNT(1) FROM REM01.MIG_ATR_TRABAJO A JOIN REM01.DD_EST_ESTADO_TRABAJO T ON A.ESTADO_TRABAJO = T.DD_EST_CODIGO GROUP BY DD_EST_DESCRIPCION'),
		T_VIC(23,'SELECT ''''TRABAJO. Importe total de los trabajos. Suma de importes.'''', ''''Importe total de los trabajos'''', NVL(SUM(TBJ_IMPORTE_TOTAL),0) IMPORTE_TOTAL FROM REM01.MIG_ATR_TRABAJO A'),
		T_VIC(24,'SELECT ''''OFERTA. Total de registros. Número de registros.'''', ''''Ofertas totales'''', COUNT(1) FROM REM01.MIG2_OFR_OFERTAS O'),
		T_VIC(25,'SELECT ''''OFERTA. Importe total de las ofertas. Suma de importes.'''', ''''Importe total de las ofertas'''', NVL(SUM(O.OFR_IMPORTE),0) IMPORTE_OFERTA FROM REM01.MIG2_OFR_OFERTAS O'),
		T_VIC(26,'SELECT ''''OFERTA. Estado de la oferta. Número de registros por valor(Según diccionario).'''', DD.DD_EOF_DESCRIPCION, COUNT(1) FROM REM01.MIG2_OFR_OFERTAS O JOIN REM01.DD_EOF_ESTADOS_OFERTA DD ON DD.DD_EOF_CODIGO = O.OFR_COD_ESTADO_OFERTA GROUP BY DD.DD_EOF_DESCRIPCION'),
		T_VIC(27,'SELECT ''''OFERTA. Tipo de Oferta. Número de registros por valor(Según diccionario).'''', DD.DD_TOF_DESCRIPCION, COUNT(1) FROM REM01.MIG2_OFR_OFERTAS O JOIN REM01.DD_TOF_TIPOS_OFERTA DD ON DD.DD_TOF_CODIGO = O.OFR_COD_TIPO_OFERTA GROUP BY DD.DD_TOF_DESCRIPCION'),
		T_VIC(28,'SELECT ''''PROVEEDOR. Total de registros. Número de registros.'''', ''''Proveedores totales'''', COUNT(1) FROM REM01.MIG2_PVE_PROVEEDORES'),
		T_VIC(29,'SELECT ''''PROVEEDOR. Tipo de proveedor. Número de registros por valor (Según diccionario).'''', DD.DD_TPR_DESCRIPCION, COUNT(1) FROM REM01.MIG2_PVE_PROVEEDORES P JOIN REM01.DD_TPR_TIPO_PROVEEDOR DD ON DD.DD_TPR_CODIGO = P.PVE_COD_TIPO_PROVEEDOR GROUP BY DD.DD_TPR_DESCRIPCION'),
		T_VIC(30,'SELECT ''''PROVEEDOR. Fecha de baja como proveedor. Número de registros con dicha fecha informada.'''', ''''Proveedores con fecha de baja'''', COUNT(1) FROM REM01.MIG2_PVE_PROVEEDORES WHERE PVE_FECHA_BAJA IS NOT NULL'),
		T_VIC(31,'SELECT ''''PROVEEDOR. Estado del proveedor. Número de registros por valor(Según diccionario).'''', DD.DD_EPR_DESCRIPCION, COUNT(1) FROM REM01.MIG2_PVE_PROVEEDORES P JOIN REM01.DD_EPR_ESTADO_PROVEEDOR DD ON DD.DD_EPR_CODIGO = P.PVE_COD_ESTADO GROUP BY DD.DD_EPR_DESCRIPCION'),
		T_VIC(32,'SELECT ''''GASTOS. Total de registros. Número de registros.'''', ''''Gastos totales'''', COUNT(1) FROM REM01.MIG2_GPV_GASTOS_PROVEEDORES'),
		T_VIC(33,'SELECT ''''GASTOS. Tipo de gasto. Número de registros por valor (Según diccionario).'''', DD.DD_TGA_DESCRIPCION, COUNT(1) FROM REM01.MIG2_GPV_GASTOS_PROVEEDORES G JOIN REM01.DD_TGA_TIPOS_GASTO DD ON DD.DD_TGA_CODIGO = G.GPV_COD_TIPO_GASTO GROUP BY DD.DD_TGA_DESCRIPCION'),
		T_VIC(34,'SELECT ''''GASTOS. Subtipo de gasto. Número de registros por valor(Según diccionario).'''', DD.DD_STG_DESCRIPCION, COUNT(1) FROM REM01.MIG2_GPV_GASTOS_PROVEEDORES G JOIN REM01.DD_STG_SUBTIPOS_GASTO DD ON DD.DD_STG_CODIGO = G.GPV_COD_SUBTIPO_GASTO GROUP BY DD.DD_STG_DESCRIPCION'),
		T_VIC(35,'SELECT ''''GASTOS. Tipo de periocidad. Número de registros por valor(Según diccionario).'''', DD.DD_TPE_DESCRIPCION, COUNT(1) FROM REM01.MIG2_GPV_GASTOS_PROVEEDORES G JOIN REM01.DD_TPE_TIPOS_PERIOCIDAD DD ON DD.DD_TPE_CODIGO = G.GPV_COD_PERIODICIDAD GROUP BY DD.DD_TPE_DESCRIPCION'),
		T_VIC(36,'SELECT ''''GASTOS. Estado autorización propietario. Número de registros por valor(Según diccionario).'''', DD.DD_EAP_DESCRIPCION, COUNT(1) FROM REM01.MIG2_GPV_GASTOS_PROVEEDORES G JOIN REM01.MIG2_GGE_GASTOS_GESTION GG ON GG.GGE_GPV_ID = G.GPV_ID JOIN REM01.DD_EAP_ESTADOS_AUTORIZ_PROP DD ON DD.DD_EAP_CODIGO = GG.GGE_COD_EST_AUTORIZ_PROP GROUP BY DD.DD_EAP_DESCRIPCION'),
		T_VIC(37,'SELECT ''''GASTOS. Estado autorización Haya. Número de registros por valor(Según diccionario).'''', DD.DD_EAH_DESCRIPCION, COUNT(1) FROM REM01.MIG2_GPV_GASTOS_PROVEEDORES G JOIN REM01.MIG2_GGE_GASTOS_GESTION GG ON GG.GGE_GPV_ID = G.GPV_ID JOIN REM01.DD_EAH_ESTADOS_AUTORIZ_HAYA DD ON DD.DD_EAH_CODIGO = GG.GGE_COD_EST_AUTORIZ_HAYA GROUP BY DD.DD_EAH_DESCRIPCION'),
		T_VIC(38,'SELECT ''''GASTOS. Tipo de operación. Número de registros por valor(Según diccionario).'''', DD.DD_TOG_DESCRIPCION, COUNT(1) FROM REM01.MIG2_GPV_GASTOS_PROVEEDORES G JOIN REM01.DD_TOG_TIPO_OPERACION_GASTO DD ON DD.DD_TOG_CODIGO = G.GPV_COD_TIPO_OPERACION GROUP BY DD.DD_TOG_DESCRIPCION'),
		T_VIC(39,'SELECT ''''GASTOS. Importe total del gasto. Suma de importes.'''', ''''Importe total de los gastos'''', NVL(SUM(GD.GDE_IMPORTE_TOTAL),0) IMPORTE_GASTO FROM REM01.MIG2_GPV_GASTOS_PROVEEDORES G JOIN REM01.MIG2_GDE_GASTOS_DET_ECONOMICO GD ON GD.GDE_GPV_ID = G.GPV_ID'),
		T_VIC(40,'SELECT ''''GASTOS. Estado. Número de registros por valor(Según diccionario).'''', DD.DD_EGA_DESCRIPCION, COUNT(1) FROM REM01.GPV_GASTOS_PROVEEDOR G JOIN REM01.MIG2_GPV_GASTOS_PROVEEDORES AUX ON G.GPV_NUM_GASTO_HAYA = AUX.GPV_ID JOIN REM01.DD_EGA_ESTADOS_GASTO DD ON DD.DD_EGA_CODIGO = G.DD_EGA_ID GROUP BY DD.DD_EGA_DESCRIPCION'),
		T_VIC(41,'SELECT ''''USUARIOS. Total de usuarios creados. Número de registros.'''', ''''Usuarios creados'''', COUNT(1) FROM REM01.MIG2_USU_USUARIOS MIG JOIN REMMASTER.USU_USUARIOS USU ON MIG.USU_USERNAME = USU.USU_USERNAME'),
		T_VIC(42,'SELECT ''''USUARIOS. Total de usuarios dados de baja. Número de registros.'''', ''''Usuarios cancelados'''', COUNT(1) FROM REM01.MIG2_USU_USUARIOS MIG JOIN REMMASTER.USU_USUARIOS USU ON MIG.USU_USERNAME = USU.USU_USERNAME AND TRUNC(USU.USU_FECHA_VIGENCIA_PASS) < TRUNC(SYSDATE)')
	    */
	);
	V_TMP_VIC T_VIC;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');

    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO TABLE_COUNT;

    IF TABLE_COUNT = 1 THEN
    	EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA;
        FOR I IN V_VIC.FIRST .. V_VIC.LAST
            LOOP
                V_TMP_VIC := V_VIC(I);
                             
	              DBMS_OUTPUT.PUT_LINE('Insertando el indicador: '''||V_TMP_VIC(1)||''' '''||V_TMP_VIC(2)||''' ');
	              V_MSQL := '
	              INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
	                (ID,KPI_INDICADOR, BORRADO)
	              VALUES 
	                ('||V_TMP_VIC(1)||','''||V_TMP_VIC(2)||''',0)';
	              EXECUTE IMMEDIATE V_MSQL;

            END LOOP;
        END IF;

        V_TMP_VIC := NULL;

        COMMIT;
        
        DBMS_OUTPUT.PUT_LINE('[FIN] Indicadores insertados.');

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(SQLERRM);
    ROLLBACK;
    RAISE;

END;
/
EXIT
