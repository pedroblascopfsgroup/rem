--/*
--##########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180726
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1427
--## PRODUCTO=NO
--##
--## Finalidad: Insertar en ACT_LOC_LOCALIZACION
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
	
	
	
	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION (
								LOC_ID,
								ACT_ID,
								BIE_LOC_ID,
								LOC_LATITUD,
								LOC_LONGITUD,
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
								'||V_ESQUEMA||'.S_ACT_LOC_LOCALIZACION.NEXTVAL AS LOC_ID,
								ACT.ACT_ID AS ACT_ID,
								LOC.BIE_LOC_ID,
								CASE
									WHEN APR.SIGNO_LATITUD = ''-'' THEN cast(''-''||to_number(apr.latitud)/1000000000000000 as number(21,15))
									WHEN APR.SIGNO_LATITUD = ''+'' THEN cast(to_number(apr.latitud)/1000000000000000 as number(21,15))
								END AS LOC_LATITUD,
								CASE
									WHEN APR.SIGNO_LONGITUD = ''-'' THEN cast(''-''||to_number(apr.LONGITUD)/1000000000000000 as number(21,15))
									WHEN APR.SIGNO_LONGITUD = ''+'' THEN cast(to_number(apr.LONGITUD)/1000000000000000 as number(21,15))
								END AS LOC_LONGITUD,
								''REMVIP-1427'' AS USUARIOCREAR,
								SYSDATE AS FECHACREAR
								FROM '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM APR
								INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
								  ON APR.ACT_NUMERO_UVEM = ACT.ACT_NUM_ACTIVO_UVEM
								INNER JOIN '||V_ESQUEMA||'.BIE_BIEN BIE
								  ON BIE.BIE_ID = ACT.BIE_ID
								INNER JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION LOC				
								  ON LOC.BIE_ID = BIE.BIE_ID
								WHERE ACT.ACT_ID IN (SELECT B.ACT_ID FROM ACTIVOS_SIN_LOC B)
							';
	
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la ACT_LOC_LOCALIZACION');
  
	
	
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
