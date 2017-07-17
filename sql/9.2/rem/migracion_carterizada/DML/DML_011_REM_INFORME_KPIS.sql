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

	V_VIC T_ARRAY_VIC := T_ARRAY_VIC(
  		T_VIC(1,'SELECT ''''ACTIVO. Total de registros. Número de registros.'''', ''''Activos totales'''', COUNT(1) FROM REM01.ACT_ACTIVO'),
		T_VIC(2,'SELECT ''''ACTIVO. Tipo de activo . Número de registros por valor(Según diccionario).'''', DD_TPA_DESCRIPCION, COUNT(1) FROM REM01.ACT_ACTIVO A JOIN REM01.DD_TPA_TIPO_ACTIVO T ON T.DD_TPA_ID = A.DD_TPA_ID GROUP BY T.DD_TPA_DESCRIPCION'),
		T_VIC(3,'SELECT ''''ACTIVO. Subtipo activo. Número de registros por valor(Según diccionario).'''', DD_SAC_DESCRIPCION, COUNT(1) FROM REM01.ACT_ACTIVO A JOIN REM01.DD_SAC_SUBTIPO_ACTIVO T ON T.DD_SAC_ID = A.DD_SAC_ID GROUP BY T.DD_SAC_DESCRIPCION'),
		T_VIC(4,'SELECT ''''ACTIVO. Catalogación del tipo de título del activo. Número de registros por valor(Según diccionario).'''', TIT.DD_TTA_DESCRIPCION, COUNT(1) FROM REM01.ACT_ACTIVO A JOIN REM01.DD_TTA_TIPO_TITULO_ACTIVO TIT ON A.DD_TTA_ID = TIT.DD_TTA_ID GROUP BY TIT.DD_TTA_DESCRIPCION'),
		T_VIC(5,'SELECT ''''ACTIVO. Situación comercial del activo. Número de registros por valor(Según diccionario).'''', TIT.DD_TTA_DESCRIPCION, COUNT(1) FROM REM01.ACT_ACTIVO A JOIN REM01.DD_TTA_TIPO_TITULO_ACTIVO TIT ON A.DD_TTA_ID = TIT.DD_TTA_ID GROUP BY TIT.DD_TTA_DESCRIPCION'),
		T_VIC(6,'SELECT ''''ACTIVO. Indicador de si el activo tiene cargas. Número de registros con estado =1.'''', ''''Activos con cargas'''', COUNT(1) FROM REM01.ACT_ACTIVO A WHERE NVL(ACT_CON_CARGAS,0) = 1'),
		T_VIC(7,'SELECT ''''ACTIVO. Indicador de si el activo es de vpo o no. Número de registros con estado =1.'''', ''''Activos VPO'''', COUNT(1) FROM REM01.ACT_ACTIVO A WHERE NVL(ACT_VPO,0) = 1'),
		T_VIC(8,'SELECT ''''ACTIVO. Estado de admisión departamento de Admisión. Número de registros con estado =1.'''', ''''Activos con estado de admisión departamente de Admisión'''', COUNT(1) FROM REM01.ACT_ACTIVO A WHERE NVL(ACT_ADMISION,0) = 1'),
		T_VIC(9,'SELECT ''''ACTIVO. Indicador estado calidad. Número de registros con estado =1.'''', ''''Activos con estado calidad'''', COUNT(1) FROM REM01.ACT_ACTIVO A WHERE NVL(ACT_SELLO_CALIDAD,0) = 1'),
		T_VIC(10,'SELECT ''''ACTIVO. Fecha de toma de posesión del activo. Número de registros con valor no vacío.'''', ''''Activos con fecha de toma de posesión'''', COUNT(1) FROM REM01.ACT_ACTIVO A JOIN REM01.ACT_SPS_SIT_POSESORIA S ON S.ACT_ID = A.ACT_ID WHERE S.SPS_FECHA_TOMA_POSESION IS NOT NULL'),
		T_VIC(11,'SELECT ''''ACTIVO. Indicador de si el activo está inscrito en división horizontal o no. Número de registros con estado =1.'''', ''''Activos inscritos en división horizontal'''', COUNT(1) FROM REM01.ACT_ACTIVO A WHERE NVL(A.ACT_DIVISION_HORIZONTAL,0) = 1'),
		T_VIC(12,'SELECT ''''ACTIVO. Codigo del municipio en el que se ubica el activo. Número de registros por valor(Según diccionario).'''', L.BIE_LOC_MUNICIPIO, COUNT(1) FROM REM01.ACT_ACTIVO A JOIN REM01.BIE_LOCALIZACION L ON L.BIE_ID = A.BIE_ID GROUP BY L.BIE_LOC_MUNICIPIO'),
		T_VIC(13,'SELECT ''''ACTIVO. Codigo del provincia en el que se ubica el activo. Número de registros por valor(Según diccionario).'''', L.BIE_LOC_PROVINCIA, COUNT(1) FROM REM01.ACT_ACTIVO A JOIN REM01.BIE_LOCALIZACION L ON L.BIE_ID = A.BIE_ID GROUP BY L.BIE_LOC_PROVINCIA'),
		T_VIC(14,'SELECT ''''ACTIVO. Importe de adjudicación del activo. Suma de importes.'''', A.ACT_NUM_ACTIVO, NVL(SUM(B.BIE_ADJ_IMPORTE_ADJUDICACION),0) IMPORTE_ADJUDICACION FROM REM01.ACT_ACTIVO A JOIN REM01.BIE_ADJ_ADJUDICACION B ON B.BIE_ID = A.BIE_ID GROUP BY A.ACT_NUM_ACTIVO'),
		T_VIC(15,'SELECT ''''AGRUPACION. Total de registros. Número de registros.'''', ''''Agrupaciones totales'''', COUNT(1) FROM REM01.ACT_AGR_AGRUPACION A'),
		T_VIC(16,'SELECT ''''AGRUPACION. Tipo de agrupación. Número de registros por valor(Según diccionario).'''', T.DD_TAG_DESCRIPCION, COUNT(1) FROM REM01.ACT_AGR_AGRUPACION A JOIN REM01.DD_TAG_TIPO_AGRUPACION T ON A.DD_TAG_ID = T.DD_TAG_ID GROUP BY T.DD_TAG_DESCRIPCION'),
		T_VIC(17,'SELECT ''''AGRUPACION. Fecha de baja de la agrupación. Número de registros con valor no vacío.'''', ''''Total de agrupaciones con fecha de baja'''', COUNT(1) FROM REM01.ACT_AGR_AGRUPACION A WHERE A.AGR_FECHA_BAJA IS NOT NULL'),
		T_VIC(18,'SELECT ''''AGRUPACION. Indicador de si la agrupación ha sido publicada en la web o no. Número de registros con estado =1.'''', ''''Agrupaciones publicadas en web'''', COUNT(1) FROM REM01.ACT_AGR_AGRUPACION A WHERE NVL(AGR_PUBLICADO,0) = 1'),
		T_VIC(19,'SELECT ''''TRABAJO. Total de registros. Número de registros.'''', ''''Trabajos totales'''', COUNT(1) FROM REM01.ACT_TBJ_TRABAJO A'),
		T_VIC(20,'SELECT ''''TRABAJO. Tipo de trabajo solicitado. Número de registros por valor(Según diccionario).'''', DD_TTR_DESCRIPCION, COUNT(1) FROM REM01.ACT_TBJ_TRABAJO A JOIN REM01.DD_TTR_TIPO_TRABAJO T ON A.DD_TTR_ID = T.DD_TTR_ID GROUP BY DD_TTR_DESCRIPCION'),
		T_VIC(21,'SELECT ''''TRABAJO. Subtipo de trabajo solicitado. Número de registros por valor(Según diccionario).'''', DD_STR_DESCRIPCION, COUNT(1) FROM REM01.ACT_TBJ_TRABAJO A JOIN REM01.DD_STR_SUBTIPO_TRABAJO T ON A.DD_STR_ID = T.DD_STR_ID GROUP BY DD_STR_DESCRIPCION'),
		T_VIC(22,'SELECT ''''TRABAJO. Estado trabajo solicitado. Número de registros por valor(Según diccionario).'''', DD_EST_DESCRIPCION, COUNT(1) FROM REM01.ACT_TBJ_TRABAJO A JOIN REM01.DD_EST_ESTADO_TRABAJO T ON A.DD_EST_ID = T.DD_EST_ID GROUP BY DD_EST_DESCRIPCION'),
		T_VIC(23,'SELECT ''''TRABAJO. Importe total del trabajo. Suma de importes.'''', TBJ_ID, NVL(SUM(TBJ_IMPORTE_TOTAL),0) IMPORTE_TOTAL FROM REM01.ACT_TBJ_TRABAJO A GROUP BY TBJ_ID'),
		T_VIC(24,'SELECT ''''OFERTA. Total de registros. Número de registros.'''', ''''Ofertas totales'''', COUNT(1) FROM REM01.OFR_OFERTAS O'),
		T_VIC(25,'SELECT ''''OFERTA. Importe oferta. Suma de importes.'''', O.OFR_NUM_OFERTA, NVL(SUM(O.OFR_IMPORTE),0) IMPORTE_OFERTA FROM REM01.OFR_OFERTAS O GROUP BY O.OFR_NUM_OFERTA'),
		T_VIC(26,'SELECT ''''OFERTA. Estado de la oferta. Número de registros por valor(Según diccionario).'''', DD.DD_EOF_DESCRIPCION, COUNT(1) FROM REM01.OFR_OFERTAS O JOIN REM01.DD_EOF_ESTADOS_OFERTA DD ON DD.DD_EOF_ID = O.DD_EOF_ID GROUP BY DD.DD_EOF_DESCRIPCION'),
		T_VIC(27,'SELECT ''''OFERTA. Tipo de Oferta. Número de registros por valor(Según diccionario).'''', DD.DD_TOF_DESCRIPCION, COUNT(1) FROM REM01.OFR_OFERTAS O JOIN REM01.DD_TOF_TIPOS_OFERTA DD ON DD.DD_TOF_ID = O.DD_TOF_ID GROUP BY DD.DD_TOF_DESCRIPCION'),
		T_VIC(28,'SELECT ''''PROVEEDOR. Total de registros. Número de registros.'''', ''''Proveedores totales'''', COUNT(1) FROM REM01.ACT_PVE_PROVEEDOR'),
		T_VIC(29,'SELECT ''''PROVEEDOR. Tipo de proveedor. Número de registros por valor(Según diccionario).'''', DD.DD_TPR_DESCRIPCION, COUNT(1) FROM REM01.ACT_PVE_PROVEEDOR P JOIN REM01.DD_TPR_TIPO_PROVEEDOR DD ON DD.DD_TPR_ID = P.DD_TPR_ID GROUP BY DD.DD_TPR_DESCRIPCION'),
		T_VIC(30,'SELECT ''''PROVEEDOR. Fecha de baja como proveedor. Número de registros con valor no vacío.'''', ''''Proveedores con fecha de baja'''', COUNT(1) FROM REM01.ACT_PVE_PROVEEDOR WHERE PVE_FECHA_BAJA IS NOT NULL'),
		T_VIC(31,'SELECT ''''PROVEEDOR. Estado del proveedor. Número de registros por valor(Según diccionario).'''', DD.DD_EPR_DESCRIPCION, COUNT(1) FROM REM01.ACT_PVE_PROVEEDOR P JOIN REM01.DD_EPR_ESTADO_PROVEEDOR DD ON DD.DD_EPR_ID = P.DD_EPR_ID GROUP BY DD.DD_EPR_DESCRIPCION'),
		T_VIC(32,'SELECT ''''GASTOS. Total de registros. Número de registros.'''', ''''Gastos totales'''', COUNT(1) FROM REM01.GPV_GASTOS_PROVEEDOR'),
		T_VIC(33,'SELECT ''''GASTOS. Tipo de gasto. Número de registros por valor(Según diccionario).'''', DD.DD_TGA_DESCRIPCION, COUNT(1) FROM REM01.GPV_GASTOS_PROVEEDOR G JOIN REM01.DD_TGA_TIPOS_GASTO DD ON DD.DD_TGA_ID = G.DD_TGA_ID GROUP BY DD.DD_TGA_DESCRIPCION'),
		T_VIC(34,'SELECT ''''GASTOS. Subtipo de gasto. Número de registros por valor(Según diccionario).'''', DD.DD_STG_DESCRIPCION, COUNT(1) FROM REM01.GPV_GASTOS_PROVEEDOR G JOIN REM01.DD_STG_SUBTIPOS_GASTO DD ON DD.DD_STG_ID = G.DD_STG_ID GROUP BY DD.DD_STG_DESCRIPCION'),
		T_VIC(35,'SELECT ''''GASTOS. Tipo de periocidad. Número de registros por valor(Según diccionario).'''', DD.DD_TPE_DESCRIPCION, COUNT(1) FROM REM01.GPV_GASTOS_PROVEEDOR G JOIN REM01.DD_TPE_TIPOS_PERIOCIDAD DD ON DD.DD_TPE_ID = G.DD_TPE_ID GROUP BY DD.DD_TPE_DESCRIPCION'),
		T_VIC(36,'SELECT ''''GASTOS. Estado autorización propietario. Número de registros por valor(Según diccionario).'''', DD.DD_EAP_DESCRIPCION, COUNT(1) FROM REM01.GPV_GASTOS_PROVEEDOR G JOIN REM01.GGE_GASTOS_GESTION GG ON GG.GPV_ID = G.GPV_ID JOIN REM01.DD_EAP_ESTADOS_AUTORIZ_PROP DD ON DD.DD_EAP_ID = GG.DD_EAP_ID GROUP BY DD.DD_EAP_DESCRIPCION'),
		T_VIC(37,'SELECT ''''GASTOS. Estado autorización Haya. Número de registros por valor(Según diccionario).'''', DD.DD_EAH_DESCRIPCION, COUNT(1) FROM REM01.GPV_GASTOS_PROVEEDOR G JOIN REM01.GGE_GASTOS_GESTION GG ON GG.GPV_ID = G.GPV_ID JOIN REM01.DD_EAH_ESTADOS_AUTORIZ_HAYA DD ON DD.DD_EAH_ID = GG.DD_EAH_ID GROUP BY DD.DD_EAH_DESCRIPCION'),
		T_VIC(38,'SELECT ''''GASTOS. Tipo de operación. Número de registros por valor(Según diccionario).'''', DD.DD_TOG_DESCRIPCION, COUNT(1) FROM REM01.GPV_GASTOS_PROVEEDOR G JOIN REM01.DD_TOG_TIPO_OPERACION_GASTO DD ON DD.DD_TOG_ID = G.DD_TOG_ID GROUP BY DD.DD_TOG_DESCRIPCION'),
		T_VIC(39,'SELECT ''''GASTOS. Importe total del gasto. Suma de importes.'''', GD.GPV_ID, NVL(SUM(GD.GDE_IMPORTE_TOTAL),0) IMPORTE_GASTO FROM REM01.GPV_GASTOS_PROVEEDOR G JOIN REM01.GDE_GASTOS_DETALLE_ECONOMICO GD ON GD.GPV_ID = G.GPV_ID GROUP BY GD.GPV_ID'),
		T_VIC(40,'SELECT ''''GASTOS. Estado. Número de registros por valor(Según diccionario).'''', DD.DD_EGA_DESCRIPCION, COUNT(1) FROM REM01.GPV_GASTOS_PROVEEDOR G JOIN REM01.DD_EGA_ESTADOS_GASTO DD ON DD.DD_EGA_ID = G.DD_EGA_ID GROUP BY DD.DD_EGA_DESCRIPCION'),
		T_VIC(41,'SELECT ''''USUARIOS. Total de usuarios creados. Número de registros.'''', ''''Usuarios creados'''', COUNT(1) FROM REMMASTER.USU_USUARIOS WHERE USUARIOCREAR = #USUARIO_MIGRACION#'),
		T_VIC(42,'SELECT ''''USUARIOS. Total de usuarios dados de baja. Número de registros.'''', ''''Usuarios cancelados'''', COUNT(1) FROM REMMASTER.USU_USUARIOS WHERE USUARIOBORRAR = #USUARIO_MIGRACION#')
	);
	V_TMP_VIC T_VIC;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');

    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO TABLE_COUNT;

    IF TABLE_COUNT = 1 THEN
        FOR I IN V_VIC.FIRST .. V_VIC.LAST
            LOOP
                V_TMP_VIC := V_VIC(I);
                V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE KPI_INDICADOR = '''||V_TMP_VIC(2)||''' ';
                EXECUTE IMMEDIATE V_MSQL INTO V_EXIST;
                
                IF V_EXIST = 1 THEN
                  DBMS_OUTPUT.PUT_LINE('Ya existe el indicador: '''||V_TMP_VIC(2)||''' ');
                ELSE                
                  DBMS_OUTPUT.PUT_LINE('Insertando el indicador: '''||V_TMP_VIC(2)||''' ');
                  V_MSQL := '
                  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
                    (ID,KPI_INDICADOR, BORRADO)
                  VALUES 
                    ('||V_TMP_VIC(1)||','''||V_TMP_VIC(2)||''',0)';
                  EXECUTE IMMEDIATE V_MSQL;
                END IF;
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
