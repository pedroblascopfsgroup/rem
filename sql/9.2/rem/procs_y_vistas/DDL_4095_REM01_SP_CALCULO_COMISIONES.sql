--/*
--##########################################
--## AUTOR=ALBERT PASTOR
--## FECHA_CREACION=20190912
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2 
--## INCIDENCIA_LINK=HREOS-6985
--## PRODUCTO=NO
--## 
--## FINALIDAD: CALCULAR LAS COMISIONES DE LOS ACTIVOS          
--## VERSIONES:
--##           0.1 [HREOS-6985] (ALBERT PASTOR) - Version inicial
--##           0.2 [HREOS-7140] (ALBERT PASTOR) - Mejora de rendimiento
--##		       0.3 [HREOS-7140] (ALBERT PASTOR) - Mapeamos los activos de Alquiler con todos los tipos de comercializaciOn
--##           0.4 [HREOS-7140] (ALBERT PASTOR) - Borrado de reglas no contempladas.
--##		   0.5 [HREOS-7239] (ALBERT PASTOR) - Cambiamos el literal PRESCRIPCION por PRESCRIPCION
--##		   0.6 [HREOS-7623] (Oscar Diestre) - Añadir campo CLASSTYPE
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE SP_CALCULO_COMISIONES (P_TEXTO OUT VARCHAR2) AUTHID CURRENT_USER AS
  err_num NUMBER;
  err_msg VARCHAR2(4000 CHAR);
  result NUMBER;
  msg VARCHAR2(4000 CHAR);

  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(32000 CHAR);
  
BEGIN
--v0.4

#ESQUEMA#.OPERACION_DDL.DDL_TABLE('TRUNCATE', 'TMP_OTC_OFERTA_TRAMO_COMISION');
#ESQUEMA#.OPERACION_DDL.DDL_TABLE('TRUNCATE', 'TMP_OTT_ORIGEN_TIPO_TRAMO');
#ESQUEMA#.OPERACION_DDL.DDL_TABLE('TRUNCATE', 'TMP_COMISIONES_ACTIVOS');

#ESQUEMA#.OPERACION_DDL.DDL_TABLE('TRUNCATE', 'AUX_HASH_COMISION_ORIGEN');
#ESQUEMA#.OPERACION_DDL.DDL_TABLE('TRUNCATE', 'AUX_HASH_COMISION_DESTINO');

COMMIT;


/*RESIDENCIAL -> DD_TCR_CODIGO = 02 */
--PRESCRIPCION -> DD_ACC_CODIGO = '04'
V_SQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_OTC_OFERTA_TRAMO_COMISION(
SELECT '||V_ESQUEMA||'.S_TMP_OTC_OFERTA_TRAMO_COMISION.NEXTVAL, DD_TOF_ID, DD_TCR_ID, DD_ACC_ID, TMP_TRC_ID FROM '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA, '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS, '||V_ESQUEMA||'.DD_TCR_TIPO_COMERCIALIZAR
CROSS JOIN  '||V_ESQUEMA||'.TMP_TRC_TRAMO_COMISION
WHERE DD_TOF_CODIGO = ''01'' AND DD_ACC_CODIGO = ''04'' AND TMP_TRC_CODIGO IN (''T01'',''T02'',''T03'',''T05'') AND DD_TCR_CODIGO = ''02''
)';
EXECUTE IMMEDIATE V_SQL;


--CUSTODIA -> DD_ACC_CODIGO = 05
V_SQL:='INSERT INTO '||V_ESQUEMA||'.TMP_OTC_OFERTA_TRAMO_COMISION(
SELECT '||V_ESQUEMA||'.S_TMP_OTC_OFERTA_TRAMO_COMISION.NEXTVAL, DD_TOF_ID, DD_TCR_ID, DD_ACC_ID, TMP_TRC_ID FROM '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA, '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS, '||V_ESQUEMA||'.DD_TCR_TIPO_COMERCIALIZAR
CROSS JOIN  '||V_ESQUEMA||'.TMP_TRC_TRAMO_COMISION
WHERE DD_TOF_CODIGO = ''01'' AND DD_ACC_CODIGO = ''05'' AND TMP_TRC_CODIGO IN (''T01'',''T02'',''T03'',''T05'') AND DD_TCR_CODIGO = ''02''
)';
EXECUTE IMMEDIATE V_SQL;

/*SINGULAR -> DD_TCR_CODIGO = 01*/
--PRESCRIPCION -> DD_ACC_CODIGO = '04'
V_SQL:='INSERT INTO '||V_ESQUEMA||'.TMP_OTC_OFERTA_TRAMO_COMISION(
SELECT '||V_ESQUEMA||'.S_TMP_OTC_OFERTA_TRAMO_COMISION.NEXTVAL, DD_TOF_ID,DD_TCR_ID,DD_ACC_ID, TMP_TRC_ID FROM '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA, '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS, '||V_ESQUEMA||'.DD_TCR_TIPO_COMERCIALIZAR
CROSS JOIN  '||V_ESQUEMA||'.TMP_TRC_TRAMO_COMISION
WHERE DD_TOF_CODIGO = ''01'' AND DD_ACC_CODIGO = ''04'' AND TMP_TRC_CODIGO IN (''T01'',''T02'',''T03'',''T05'') AND DD_TCR_CODIGO = ''01''
)';
EXECUTE IMMEDIATE V_SQL;

--CUSTODIA -> DD_ACC_CODIGO = '05'
V_SQL:='INSERT INTO '||V_ESQUEMA||'.TMP_OTC_OFERTA_TRAMO_COMISION(
SELECT '||V_ESQUEMA||'.S_TMP_OTC_OFERTA_TRAMO_COMISION.NEXTVAL, DD_TOF_ID, DD_TCR_ID, DD_ACC_ID, TMP_TRC_ID FROM '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA, '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS, '||V_ESQUEMA||'.DD_TCR_TIPO_COMERCIALIZAR
CROSS JOIN  '||V_ESQUEMA||'.TMP_TRC_TRAMO_COMISION
WHERE DD_TOF_CODIGO = ''01'' AND DD_ACC_CODIGO = ''05'' AND TMP_TRC_CODIGO IN (''T01'',''T02'', ''T04'') AND DD_TCR_CODIGO = ''01''
)';
EXECUTE IMMEDIATE V_SQL;

/*ALQUILERES*/

--CUSTODIA -> DD_ACC_CODIGO = '05 & PRESCRIPCION -> DD_ACC_CODIGO = '04'
V_SQL:='INSERT INTO '||V_ESQUEMA||'.TMP_OTC_OFERTA_TRAMO_COMISION(
SELECT '||V_ESQUEMA||'.S_TMP_OTC_OFERTA_TRAMO_COMISION.NEXTVAL, DD_TOF_ID,TCR.DD_TCR_ID,DD_ACC_ID, TMP_TRC_ID FROM '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA, '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS
CROSS JOIN  '||V_ESQUEMA||'.TMP_TRC_TRAMO_COMISION
CROSS JOIN '||V_ESQUEMA||'.DD_TCR_TIPO_COMERCIALIZAR TCR
WHERE DD_TOF_CODIGO = ''02''  AND DD_ACC_CODIGO <> ''06'' AND TMP_TRC_CODIGO IN (''T02'')
)';
EXECUTE IMMEDIATE V_SQL;

COMMIT;
----------------------------------------------------

/*RESIDENCIAL -> DD_TCR_CODIGO = 02 */
--PRESCRIPCION -> DD_ACC_CODIGO = '04'
V_SQL:='INSERT INTO '||V_ESQUEMA||'.TMP_OTT_ORIGEN_TIPO_TRAMO(
SELECT DD_TOF_ID,DD_TCR_ID,DD_ACC_ID, DD_ORC_ID FROM '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA, '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS, '||V_ESQUEMA||'.DD_TCR_TIPO_COMERCIALIZAR
CROSS JOIN  '||V_ESQUEMA||'.DD_ORC_ORIGEN_COMPRADOR
WHERE DD_TOF_CODIGO = ''01'' AND DD_ACC_CODIGO = ''04'' AND DD_TCR_CODIGO = ''02'' AND DD_ORC_CODIGO NOT IN (''03'', ''05'')
)';
EXECUTE IMMEDIATE V_SQL;


-- CUSTODIA -> DD_ACC_CODIGO = '05'
V_SQL:='INSERT INTO '||V_ESQUEMA||'.TMP_OTT_ORIGEN_TIPO_TRAMO(
SELECT DD_TOF_ID, DD_TCR_ID, DD_ACC_ID, DD_ORC_ID FROM '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA, '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS, '||V_ESQUEMA||'.DD_TCR_TIPO_COMERCIALIZAR
CROSS JOIN  '||V_ESQUEMA||'.DD_ORC_ORIGEN_COMPRADOR
WHERE DD_TOF_CODIGO = ''01'' AND DD_ACC_CODIGO = ''05'' AND DD_TCR_CODIGO = ''02''
)';
EXECUTE IMMEDIATE V_SQL;

/*SINGULAR -> DD_TCR_CODIGO = 01*/
--PRESCRIPCION -> DD_ACC_CODIGO = '04'
V_SQL:='INSERT INTO '||V_ESQUEMA||'.TMP_OTT_ORIGEN_TIPO_TRAMO(
SELECT DD_TOF_ID,DD_TCR_ID,DD_ACC_ID, DD_ORC_ID FROM '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA, '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS, '||V_ESQUEMA||'.DD_TCR_TIPO_COMERCIALIZAR
CROSS JOIN  '||V_ESQUEMA||'.DD_ORC_ORIGEN_COMPRADOR
WHERE DD_TOF_CODIGO = ''01'' AND DD_ACC_CODIGO = ''04'' AND DD_TCR_CODIGO = ''01'' AND DD_ORC_CODIGO NOT IN (''03'',''05'')
)';
EXECUTE IMMEDIATE V_SQL;

--CUSTODIA -> DD_ACC_CODIGO = '05'
V_SQL:='INSERT INTO '||V_ESQUEMA||'.TMP_OTT_ORIGEN_TIPO_TRAMO(
SELECT DD_TOF_ID, DD_TCR_ID, DD_ACC_ID, DD_ORC_ID FROM '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA, '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS, '||V_ESQUEMA||'.DD_TCR_TIPO_COMERCIALIZAR
CROSS JOIN '||V_ESQUEMA||'.DD_ORC_ORIGEN_COMPRADOR
WHERE DD_TOF_CODIGO = ''01'' AND DD_ACC_CODIGO = ''05'' AND DD_TCR_CODIGO = ''01'' 
)';
EXECUTE IMMEDIATE V_SQL;
 
-------------------------------------------- 
 
/*ALQUILERES*/

--PRESCRIPCION -> DD_ACC_CODIGO = '04' && CUSTODIA -> DD_ACC_CODIGO = '05'
V_SQL:='INSERT INTO '||V_ESQUEMA||'.TMP_OTT_ORIGEN_TIPO_TRAMO(
SELECT UNIQUE DD_TOF_ID, TCR.DD_TCR_ID, DD_ACC_ID, DD_ORC_ID FROM '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA, '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS, '||V_ESQUEMA||'.DD_TCR_TIPO_COMERCIALIZAR
CROSS JOIN '||V_ESQUEMA||'.DD_ORC_ORIGEN_COMPRADOR
CROSS JOIN '||V_ESQUEMA||'.DD_TCR_TIPO_COMERCIALIZAR TCR
WHERE DD_TOF_CODIGO = ''02'' AND DD_ACC_CODIGO  <> ''06'' AND DD_ORC_CODIGO IN (''01'',''02'',''05'')
)';
EXECUTE IMMEDIATE V_SQL;


COMMIT;
--------------------------------------------
/*TABLA FINAL*/

/*INSERT*/
V_SQL:='INSERT INTO '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS (
COMISION_ID
,CARTERA
,SUBCARTERA
,LEADORIGIN
,ASSETTYPE
,ASSETSUBTYPE
,OFFERTYPE
,COMISSIONTYPE
,COMERCIALTYPE
,STRECHMIN
,STRECHMAX
,COMISSIONPERCENTAGE
,MAXCOMISSIONAMMOUNT
,MINCOMISSIONAMOUNT 
,CREATEDATE
,CREATEUSER
,MODIFYDATE
,MODIFYUSER
,TRAMO
,CLASSTYPE
)
SELECT 
ROWNUM
,CARTERA
,SUBCARTERA
,LEADORIGIN
,ASSETTYPE
,ASSETSUBTYPE
,OFFERTYPE
,COMISSIONTYPE
,COMERCIALTYPE
,STRECHMIN
,STRECHMAX
,COMISSIONPERCENTAGE
,MAXCOMISSIONAMMOUNT
,MINCOMISSIONAMOUNT 
,CREATEDATE
,CREATEUSER
,MODIFYDATE
,MODIFYUSER
,TRAMO
,CLASSTYPE
 FROM (
SELECT UNIQUE DD_CRA_CODIGO AS CARTERA
,DD_SCR_CODIGO AS SUBCARTERA
,DD_ORC_CODIGO AS LEADORIGIN
,DD_TPA_CODIGO AS ASSETTYPE 
,DD_SAC_CODIGO AS  ASSETSUBTYPE 
,DD_TOF_CODIGO AS OFFERTYPE
,TIPO_COMISION AS  COMISSIONTYPE
,TIPO_COMERCIALIZAR AS COMERCIALTYPE
,TRAMO_MIN AS STRECHMIN
,TRAMO_MAX AS STRECHMAX 
,0 AS COMISSIONPERCENTAGE 
,NULL AS MAXCOMISSIONAMMOUNT 
,DECODE(DD_TOF_CODIGO, ''02'', 100, ''01'', 0) AS MINCOMISSIONAMOUNT
,SYSDATE AS CREATEDATE
,''HREOS-6985'' AS CREATEUSER
,NULL AS MODIFYDATE
,NULL AS MODIFYUSER
,TRAMO_CODIGO AS TRAMO
,DD_CLA_CODIGO AS CLASSTYPE
FROM (SELECT DD_TOF_CODIGO,DD_TCR_CODIGO AS TIPO_COMERCIALIZAR, 
      DECODE(DD_ACC_CODIGO,''04'',''PRESCRIPCION'',''05'',''CUSTODIA'') AS TIPO_COMISION, 
      DD_ORC_CODIGO, 
      TRAMO_MIN,
      TRAMO_MAX,
      TRAMO_CODIGO
      FROM (SELECT UNIQUE TOF.DD_TOF_CODIGO, 
                TCR.DD_TCR_CODIGO, 
                ACC.DD_ACC_CODIGO, 
                ORC.DD_ORC_CODIGO, 
                TMP_TRC.TMP_TRC_MIN AS TRAMO_MIN, 
                TMP_TRC.TMP_TRC_MAX AS TRAMO_MAX,
                TMP_TRC.TMP_TRC_CODIGO AS TRAMO_CODIGO 
                FROM '||V_ESQUEMA||'.TMP_OTT_ORIGEN_TIPO_TRAMO OTT
                JOIN '||V_ESQUEMA||'.TMP_OTC_OFERTA_TRAMO_COMISION OTC ON OTT.DD_ACC_ID = OTC.DD_ACC_ID AND OTT.DD_TCR_ID = OTC.DD_TCR_ID AND OTT.DD_TOF_ID = OTC.DD_TOF_ID
                JOIN '||V_ESQUEMA||'.TMP_TRC_TRAMO_COMISION TMP_TRC ON TMP_TRC.TMP_TRC_ID = OTC.TMP_TRC_ID
                JOIN '||V_ESQUEMA||'.DD_ORC_ORIGEN_COMPRADOR ORC ON ORC.DD_ORC_ID = OTT.DD_ORC_ID
                JOIN '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA TOF ON TOF.DD_TOF_ID = OTT.DD_TOF_ID
                JOIN '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS ACC ON OTT.DD_ACC_ID = ACC.DD_ACC_ID
                JOIN '||V_ESQUEMA||'.DD_TCR_TIPO_COMERCIALIZAR TCR ON OTT.DD_TCR_ID = TCR.DD_TCR_ID 
                WHERE ORC.BORRADO = 0
                AND TOF.BORRADO = 0
                AND TCR.BORRADO = 0
          MINUS 
          SELECT UNIQUE TOF.DD_TOF_CODIGO, 
                TCR.DD_TCR_CODIGO, 
                ACC.DD_ACC_CODIGO, 
                ORC.DD_ORC_CODIGO, 
                TMP_TRC.TMP_TRC_MIN AS TRAMO_MIN,
                TMP_TRC.TMP_TRC_MAX AS TRAMO_MAX,
                TMP_TRC.TMP_TRC_CODIGO AS TRAMO_CODIGO  
                FROM '||V_ESQUEMA||'.TMP_OTT_ORIGEN_TIPO_TRAMO OTT
                JOIN '||V_ESQUEMA||'.TMP_OTC_OFERTA_TRAMO_COMISION OTC ON OTT.DD_ACC_ID = OTC.DD_ACC_ID AND OTT.DD_TCR_ID = OTC.DD_TCR_ID AND OTT.DD_TOF_ID = OTC.DD_TOF_ID
                JOIN '||V_ESQUEMA||'.TMP_TRC_TRAMO_COMISION TMP_TRC ON TMP_TRC.TMP_TRC_ID = OTC.TMP_TRC_ID
                JOIN '||V_ESQUEMA||'.DD_ORC_ORIGEN_COMPRADOR ORC ON ORC.DD_ORC_ID = OTT.DD_ORC_ID
                JOIN '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA TOF ON TOF.DD_TOF_ID = OTT.DD_TOF_ID
                JOIN '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS ACC ON OTT.DD_ACC_ID = ACC.DD_ACC_ID
                JOIN '||V_ESQUEMA||'.DD_TCR_TIPO_COMERCIALIZAR TCR ON OTT.DD_TCR_ID = TCR.DD_TCR_ID 
                WHERE TMP_TRC.TMP_TRC_CODIGO = ''T02'' AND ORC.DD_ORC_DESCRIPCION <> ''FDV''  
                AND ORC.BORRADO = 0
                AND TOF.BORRADO = 0
                AND TCR.BORRADO = 0
            UNION --ALQUILER
            SELECT UNIQUE TOF.DD_TOF_CODIGO, 
                TCR.DD_TCR_CODIGO, 
                ACC.DD_ACC_CODIGO, 
                ORC.DD_ORC_CODIGO, 
                TMP_TRC.TMP_TRC_MIN AS TRAMO_MIN,
                TMP_TRC.TMP_TRC_MAX AS TRAMO_MAX,
                TMP_TRC.TMP_TRC_CODIGO AS TRAMO_CODIGO  
                FROM '||V_ESQUEMA||'.TMP_OTT_ORIGEN_TIPO_TRAMO OTT
                JOIN '||V_ESQUEMA||'.TMP_OTC_OFERTA_TRAMO_COMISION OTC ON OTT.DD_ACC_ID = OTC.DD_ACC_ID AND OTT.DD_TCR_ID = OTC.DD_TCR_ID AND OTT.DD_TOF_ID = OTC.DD_TOF_ID
                JOIN '||V_ESQUEMA||'.TMP_TRC_TRAMO_COMISION TMP_TRC ON TMP_TRC.TMP_TRC_ID = OTC.TMP_TRC_ID
                JOIN '||V_ESQUEMA||'.DD_ORC_ORIGEN_COMPRADOR ORC ON ORC.DD_ORC_ID = OTT.DD_ORC_ID
                JOIN '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA TOF ON TOF.DD_TOF_ID = OTT.DD_TOF_ID
                JOIN '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS ACC ON OTT.DD_ACC_ID = ACC.DD_ACC_ID
                JOIN '||V_ESQUEMA||'.DD_TCR_TIPO_COMERCIALIZAR TCR ON OTT.DD_TCR_ID = TCR.DD_TCR_ID
                WHERE TOF.DD_TOF_CODIGO=''02''
                AND ORC.BORRADO = 0
                AND TOF.BORRADO = 0
          )
  )
CROSS JOIN (
    SELECT TAP.DD_TPA_CODIGO, SAC.DD_SAC_CODIGO FROM '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC
    JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TAP ON TAP.DD_TPA_ID = SAC.DD_TPA_ID
    WHERE SAC.BORRADO = 0
    AND TAP.BORRADO = 0
)
CROSS JOIN (
    SELECT CRA.DD_CRA_CODIGO, SCR.DD_SCR_CODIGO FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR
    JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = SCR.DD_CRA_ID
    WHERE CRA.BORRADO = 0
    AND SCR.BORRADO = 0
    )
CROSS JOIN (
    SELECT CLA.DD_CLA_CODIGO FROM '||V_ESQUEMA||'.DD_CLA_CLASE_ACTIVO CLA
    WHERE CLA.BORRADO = 0
    )
)';
EXECUTE IMMEDIATE V_SQL;
COMMIT;

/*ACTUALIZAMOS LA TABLA CON PORCENTAJES e IMPORTES MÁXIMOS*/
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=2.25 , MAXCOMISSIONAMMOUNT=22500 WHERE LEADORIGIN=''02'' AND OFFERTYPE=''01'' AND COMISSIONTYPE=''PRESCRIPCION'' AND TRAMO = ''T01'' AND CLASSTYPE = ''02'' ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=2.25 , MAXCOMISSIONAMMOUNT=30000  WHERE LEADORIGIN=''02'' AND OFFERTYPE=''01'' AND COMISSIONTYPE=''PRESCRIPCION'' AND COMERCIALTYPE=''02'' AND TRAMO = ''T03'' AND CLASSTYPE = ''02'' ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=1.5 , MAXCOMISSIONAMMOUNT=40000  WHERE LEADORIGIN=''02'' AND OFFERTYPE=''01'' AND COMISSIONTYPE=''PRESCRIPCION'' AND TRAMO = ''T05'' AND CLASSTYPE = ''02'' ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=0.9 , MAXCOMISSIONAMMOUNT=9000  WHERE LEADORIGIN=''01'' AND OFFERTYPE=''01'' AND COMISSIONTYPE=''PRESCRIPCION'' AND COMERCIALTYPE=''02'' AND TRAMO = ''T01'' AND CLASSTYPE = ''02'' ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=0.9 , MAXCOMISSIONAMMOUNT=18000  WHERE LEADORIGIN=''01'' AND OFFERTYPE=''01'' AND COMISSIONTYPE=''PRESCRIPCION'' AND TRAMO = ''T03'' AND CLASSTYPE = ''02'' ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=0.9 , MAXCOMISSIONAMMOUNT=22000  WHERE LEADORIGIN=''01'' AND OFFERTYPE=''01'' AND COMISSIONTYPE=''PRESCRIPCION''  AND TRAMO = ''T05'' AND CLASSTYPE = ''02'' ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=1.25 , MAXCOMISSIONAMMOUNT=STRECHMAX WHERE LEADORIGIN=''04'' AND OFFERTYPE=''01'' AND COMISSIONTYPE=''PRESCRIPCION'' AND TRAMO = ''T02''  AND CLASSTYPE = ''02''  ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=0.6 , MAXCOMISSIONAMMOUNT=6000  WHERE OFFERTYPE=''01'' AND COMISSIONTYPE=''CUSTODIA'' AND COMERCIALTYPE=''02'' AND TRAMO = ''T01'' AND CLASSTYPE = ''02'' ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=0.6 , MAXCOMISSIONAMMOUNT=7500  WHERE OFFERTYPE=''01'' AND COMISSIONTYPE=''CUSTODIA'' AND COMERCIALTYPE=''02'' AND TRAMO = ''T03''  AND CLASSTYPE = ''02''  ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=0.6 , MAXCOMISSIONAMMOUNT=10000  WHERE OFFERTYPE=''01'' AND COMISSIONTYPE=''CUSTODIA'' AND COMERCIALTYPE=''02'' AND TRAMO = ''T05''  AND CLASSTYPE = ''02''  ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=0.9 , MAXCOMISSIONAMMOUNT=9500  WHERE LEADORIGIN=''01'' AND OFFERTYPE=''01'' AND COMISSIONTYPE=''PRESCRIPCION'' AND COMERCIALTYPE=''01'' AND TRAMO = ''T01'' AND CLASSTYPE = ''02'' ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=1.5 , MAXCOMISSIONAMMOUNT=30000  WHERE LEADORIGIN=''02'' AND OFFERTYPE=''01'' AND COMISSIONTYPE=''PRESCRIPCION'' AND COMERCIALTYPE=''01'' AND TRAMO = ''T03'' AND CLASSTYPE = ''02'' ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=0.25 , MAXCOMISSIONAMMOUNT=500  WHERE OFFERTYPE=''01'' AND COMISSIONTYPE=''CUSTODIA'' AND COMERCIALTYPE=''01'' AND TRAMO = ''T01'' AND CLASSTYPE = ''02'' ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=0.25 , MAXCOMISSIONAMMOUNT=1000 WHERE OFFERTYPE=''01'' AND COMISSIONTYPE=''CUSTODIA'' AND COMERCIALTYPE=''01'' AND TRAMO = ''T04'' AND CLASSTYPE = ''02'' ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=0.6 , MAXCOMISSIONAMMOUNT=5000 WHERE ASSETTYPE in (''03'',''04'') AND OFFERTYPE=''01'' AND COMISSIONTYPE=''CUSTODIA'' AND COMERCIALTYPE=''01'' AND TRAMO = ''T01'' AND CLASSTYPE = ''02'' ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=0.5 , MAXCOMISSIONAMMOUNT=5000 WHERE ASSETTYPE in (''03'',''04'') AND OFFERTYPE=''01'' AND COMISSIONTYPE=''CUSTODIA'' AND COMERCIALTYPE=''01'' AND TRAMO = ''T04'' AND CLASSTYPE = ''02'' ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=0, MAXCOMISSIONAMMOUNT=STRECHMAX   WHERE LEADORIGIN=''01'' AND OFFERTYPE=''02'' AND COMISSIONTYPE=''PRESCRIPCION'' AND TRAMO = ''T02'' AND CLASSTYPE = ''02'' ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=8.3, MAXCOMISSIONAMMOUNT=STRECHMAX   WHERE LEADORIGIN=''02'' AND OFFERTYPE=''02'' AND COMISSIONTYPE=''PRESCRIPCION'' AND TRAMO = ''T02'' AND CLASSTYPE = ''02'' ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=10, MAXCOMISSIONAMMOUNT=STRECHMAX WHERE LEADORIGIN=''05'' AND OFFERTYPE=''02'' AND COMISSIONTYPE=''PRESCRIPCION'' AND TRAMO = ''T02'' AND CLASSTYPE = ''02'' ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=4, MAXCOMISSIONAMMOUNT=STRECHMAX   WHERE LEADORIGIN=''01'' AND OFFERTYPE=''02'' AND COMISSIONTYPE=''CUSTODIA'' AND TRAMO = ''T02'' AND CLASSTYPE = ''02'' ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=4, MAXCOMISSIONAMMOUNT=STRECHMAX   WHERE LEADORIGIN=''02'' AND OFFERTYPE=''02'' AND COMISSIONTYPE=''CUSTODIA'' AND TRAMO = ''T02'' AND CLASSTYPE = ''02'' ';
EXECUTE IMMEDIATE V_SQL;
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=0, MAXCOMISSIONAMMOUNT=STRECHMAX   WHERE LEADORIGIN=''05'' AND OFFERTYPE=''02'' AND COMISSIONTYPE=''CUSTODIA'' AND TRAMO = ''T02'' AND CLASSTYPE = ''02'' ';
EXECUTE IMMEDIATE V_SQL;

COMMIT;

/*Borrado de casos de financieros y de alquiler*/

V_SQL:='DELETE FROM '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS WHERE CLASSTYPE = ''01'' AND OFFERTYPE = ''02'' ';
EXECUTE IMMEDIATE V_SQL;


/* Actualiza los financieros */
V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=1.75 WHERE COMISSIONTYPE=''PRESCRIPCION'' AND CLASSTYPE = ''01'' ';
EXECUTE IMMEDIATE V_SQL;

V_SQL:= 'UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET COMISSIONPERCENTAGE=0.5 WHERE COMISSIONTYPE=''CUSTODIA'' AND CLASSTYPE = ''01'' ';
EXECUTE IMMEDIATE V_SQL;
COMMIT;

/*CONFIGURACION ESPECÍFICA DE REGLAS */
--YUBAI

V_SQL:='DELETE FROM '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS WHERE LEADORIGIN = ''05'' AND SUBCARTERA = ''139'' AND CARTERA = ''11'' ';
EXECUTE IMMEDIATE V_SQL;

V_SQL:='DELETE FROM '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS  WHERE  LEADORIGIN = ''04'' AND SUBCARTERA = ''139'' AND CARTERA = ''11'' AND TRAMO <> ''T02'' AND  OFFERTYPE=''01'' ';
EXECUTE IMMEDIATE V_SQL;

V_SQL:='UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET  comissionpercentage = 0.25, MAXCOMISSIONAMMOUNT=STRECHMAX WHERE  COMISSIONTYPE=''CUSTODIA'' AND LEADORIGIN = ''04'' AND SUBCARTERA = ''139'' AND CARTERA = ''11'' AND TRAMO = ''T02'' AND  OFFERTYPE=''01'' ';
EXECUTE IMMEDIATE V_SQL;

V_SQL:='UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET  comissionpercentage = 1.15, MAXCOMISSIONAMMOUNT=STRECHMAX WHERE  COMISSIONTYPE=''PRESCRIPCION'' AND LEADORIGIN = ''04'' AND SUBCARTERA = ''139'' AND CARTERA = ''11'' AND TRAMO = ''T02'' AND  OFFERTYPE=''01'' ';
EXECUTE IMMEDIATE V_SQL;

V_SQL:='UPDATE '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS SET  comissionpercentage = 1.75, MAXCOMISSIONAMMOUNT=STRECHMAX WHERE SUBCARTERA = ''139'' AND CARTERA = ''11'' AND  COMISSIONTYPE=''PRESCRIPCION''AND LEADORIGIN NOT IN (''04'',''05'') AND  OFFERTYPE=''01'' ';
EXECUTE IMMEDIATE V_SQL;

COMMIT;


/*BORRADO DE LOS REGISTROS NO ACTUALIZADOS - REGLAS NO CONTEMPLADAS*/
V_SQL:='DELETE FROM '||V_ESQUEMA||'.TMP_COMISIONES_ACTIVOS  WHERE comissionpercentage = 0 AND offertype = ''01'' ';
EXECUTE IMMEDIATE V_SQL;
COMMIT;


/*PASO A TABLA FINAL*/

--Mapeo de HASH
V_SQL:='insert into '||V_ESQUEMA||'.AUX_HASH_COMISION_ORIGEN (comision_id,hash_com)
SELECT UNIQUE comision_id, standard_hash(CARTERA
||''|''||SUBCARTERA
||''|''||LEADORIGIN
||''|''||ASSETTYPE
||''|''||ASSETSUBTYPE
||''|''||OFFERTYPE
||''|''||COMISSIONTYPE
||''|''||COMERCIALTYPE
||''|''||STRECHMIN
||''|''||STRECHMAX
||''|''||CLASSTYPE
, ''MD5'')
            from '||V_ESQUEMA||'.tmp_comisiones_activos';
EXECUTE IMMEDIATE V_SQL;
COMMIT;

#ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','AUX_HASH_COMISION_ORIGEN');
COMMIT;

            
V_SQL:='insert into '||V_ESQUEMA||'.AUX_HASH_COMISION_DESTINO (comision_id,hash_com)
SELECT UNIQUE comision_id, standard_hash(CARTERA
||''|''||SUBCARTERA
||''|''||LEADORIGIN
||''|''||ASSETTYPE
||''|''||ASSETSUBTYPE
||''|''||OFFERTYPE
||''|''||COMISSIONTYPE
||''|''||COMERCIALTYPE
||''|''||STRECHMIN
||''|''||STRECHMAX
||''|''||CLASSTYPE
, ''MD5'')
from '||V_ESQUEMA||'.cca_comisiones_calc_activos';
EXECUTE IMMEDIATE V_SQL;            
COMMIT;           
      
#ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','AUX_HASH_COMISION_DESTINO');
COMMIT;


-- INSERT cca_comisiones_calc_activos
V_SQL:='INSERT INTO '||V_ESQUEMA||'.CCA_COMISIONES_CALC_ACTIVOS (
COMISION_ID
,CARTERA
,SUBCARTERA
,LEADORIGIN
,ASSETTYPE
,ASSETSUBTYPE
,OFFERTYPE
,COMISSIONTYPE
,COMERCIALTYPE
,STRECHMIN
,STRECHMAX
,COMISSIONPERCENTAGE
,MAXCOMISSIONAMMOUNT
,MINCOMISSIONAMOUNT 
,CREATEDATE
,CREATEUSER
,CLASSTYPE
)
with comision_origen_insertar as(
select unique comision_id 
    from '||V_ESQUEMA||'.AUX_HASH_COMISION_ORIGEN ori
   where not exists (select 1 from '||V_ESQUEMA||'.AUX_HASH_COMISION_DESTINO des 
                        where ori.hash_com = des.hash_com) 
    )
select generate_uuid()
,tmp.CARTERA
,tmp.SUBCARTERA
,tmp.LEADORIGIN
,tmp.ASSETTYPE
,tmp.ASSETSUBTYPE
,tmp.OFFERTYPE
,tmp.COMISSIONTYPE
,tmp.COMERCIALTYPE
,tmp.STRECHMIN
,tmp.STRECHMAX
,tmp.COMISSIONPERCENTAGE
,tmp.MAXCOMISSIONAMMOUNT
,tmp.MINCOMISSIONAMOUNT 
,tmp.CREATEDATE
,tmp.CREATEUSER
,tmp.CLASSTYPE 
FROM '||V_ESQUEMA||'.tmp_comisiones_activos tmp
JOIN comision_origen_insertar aux ON aux.comision_id=tmp.comision_id'
    ;

EXECUTE IMMEDIATE V_SQL;    
COMMIT;
#ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','CCA_COMISIONES_CALC_ACTIVOS');
COMMIT;


--UPDATE cca_comisiones_calc_activos
V_SQL:='MERGE INTO '||V_ESQUEMA||'.CCA_COMISIONES_CALC_ACTIVOS cca
    USING (select unique ori.comision_id as id_ori, ori.hash_com as has_ori, des.comision_id as id_des, des.hash_com as hash_des, tmp.*
    from '||V_ESQUEMA||'.AUX_HASH_COMISION_ORIGEN ori 
    join '||V_ESQUEMA||'.AUX_HASH_COMISION_DESTINO des on ori.hash_com = des.hash_com
    join '||V_ESQUEMA||'.tmp_comisiones_activos tmp on tmp.comision_id = ori.comision_id) h 
    ON (cca.comision_id = h.id_des)
  WHEN MATCHED THEN
    UPDATE SET 
    CARTERA = h.CARTERA
,SUBCARTERA=h.SUBCARTERA
,LEADORIGIN=h.LEADORIGIN
,ASSETTYPE=h.ASSETTYPE
,ASSETSUBTYPE=h.ASSETSUBTYPE
,OFFERTYPE=h.OFFERTYPE
,COMISSIONTYPE=h.COMISSIONTYPE
,COMERCIALTYPE=h.COMERCIALTYPE
,STRECHMIN=h.STRECHMIN
,STRECHMAX=h.STRECHMAX
,COMISSIONPERCENTAGE=h.COMISSIONPERCENTAGE
,MAXCOMISSIONAMMOUNT=h.MAXCOMISSIONAMMOUNT
,MINCOMISSIONAMOUNT=h.MINCOMISSIONAMOUNT  
,MODIFYDATE=SYSDATE
,MODIFYUSER=''MODIF_COMISSION''
,CLASSTYPE = h.CLASSTYPE '
;

EXECUTE IMMEDIATE V_SQL;
COMMIT;
#ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','CCA_COMISIONES_CALC_ACTIVOS');
COMMIT;


    DBMS_OUTPUT.PUT_LINE('[FIN] Comisiones calculadas.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciOn:'||TO_CHAR(V_SQL));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(err_msg);
    ROLLBACK;
    RAISE;

END;
/
EXIT;
