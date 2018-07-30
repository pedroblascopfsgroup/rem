--/*
--##########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180725
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1427
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar BIE_LOCALIZACION
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1427';

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_COUNT NUMBER;

    V_MSQL_1 VARCHAR2(4000 CHAR);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	
	
	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.BIE_LOCALIZACION (
							BIE_LOC_ID,
							BIE_ID,
							BIE_LOC_NOMBRE_VIA,
							BIE_LOC_DIRECCION,
							BIE_LOC_NUMERO_DOMICILIO,
							BIE_LOC_ESCALERA,
							BIE_LOC_PISO,
							DD_TVI_ID,
							DD_PRV_ID,
							BIE_LOC_MUNICIPIO,
							--UPO_ID,
							BIE_LOC_PUERTA,
							BIE_LOC_COD_POST,
							DD_CIC_ID,
							BIE_LOC_PROVINCIA,
							USUARIOCREAR,
							FECHACREAR
							)


							WITH ACTIVOS_SIN_LOC AS (SELECT * FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
							JOIN '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR ON APR.ACT_NUMERO_UVEM  = ACT.ACT_NUM_ACTIVO_UVEM
							WHERE ACT.ACT_ID NOT IN (
								SELECT ACT2.ACT_ID FROM '||V_ESQUEMA||'.BIE_LOCALIZACION BIE
								JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT2 ON ACT2.BIE_ID = BIE.BIE_ID
								)
							OR ACT.ACT_ID NOT IN (
								SELECT LOC.ACT_ID FROM '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION LOC 
							)
							) 


							SELECT
							'||V_ESQUEMA||'.S_BIE_LOCALIZACION.NEXTVAL AS BIE_LOC_ID,
							ACT.BIE_ID AS BIE_ID,
							APR.NOMBRE_VIA AS BIE_LOC_NOMBRE_VIA,
							APR.DD_TVI.DD_TVI_DESCRIPCION || '' '' || APR.NOMBRE_VIA || '' '' || '' '' || APR.NUM_PUERTA AS BIE_LOC_DIRECCION,
							APR.PORTAL_PUNTO_KM AS BIE_LOC_NUMERO_DOMICILIO,
							APR.ESCALERA AS BIE_LOC_ESCALERA,
							APR.PISO AS BIE_LOC_PISO,
							DD_TVI.DD_TVI_ID AS DD_TVI_ID,
							PRV.DD_PRV_ID AS DD_PRV_ID,
							UPO.DD_UPO_CODIGO AS BIE_LOC_MUNICIPIO,
							--UPO.DD_UPO_ID AS UPO_ID,
							APR.NUM_PUERTA AS BIE_LOC_PUERTA,
							APR.COD_POSTAL AS BIE_LOC_COD_POST,
							(SELECT DD_CIC_ID FROM '||V_ESQUEMA_M||'.DD_CIC_CODIGO_ISO_CIRBE_BKP WHERE DD_CIC_CODIGO = ''011'') AS DD_CIC_ID,
							PRV.DD_PRV_CODIGO AS BIE_LOC_PROVINCIA,
							''REMVIP-1427'' AS USUARIOCREAR,
							SYSDATE AS FECHACREAR
							FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
								 JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT  ON ACT.ACT_NUM_ACTIVO_UVEM = APR.ACT_NUMERO_UVEM 

							LEFT JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BIE            ON BIE.BIE_ID            = ACT.BIE_ID
							LEFT JOIN '||V_ESQUEMA||'.APR_AUX_DD_PRV_PROVINCIA PRV          ON PRV.DD_PRV_CODIGO     = APR.COD_PROVINCIA
							LEFT JOIN '||V_ESQUEMA_M||'.DD_UPO_UNID_POBLACIONAL UPO ON UPO.DD_UPO_CODIGO     = APR.COD_MUNICIPIO_REGISTRO       
							LEFT JOIN '||V_ESQUEMA||'.DD_EQV_BANKIA_REM EQV                 ON EQV.DD_CODIGO_BANKIA  = LPAD(TO_CHAR(APR.TIPO_VIA),2,''0'') AND EQV.DD_NOMBRE_BANKIA = ''DD_TIPO_VIA''
							LEFT JOIN '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA DD_TVI      ON EQV.DD_CODIGO_REM     =  DD_TVI.DD_TVI_CODIGO
							WHERE ACT.ACT_ID IN (SELECT A.ACT_ID FROM ACTIVOS_SIN_LOC A)

							';
	
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la BIE_LOCALIZACION');
  
	
	
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: INSERCION DE LOCALIZACIONES REALIZADA CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;
/
EXIT;
