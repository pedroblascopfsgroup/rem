--/*
--###########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20181019
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2138
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar estado de trabajos.
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.BIE_LOCALIZACION
						SET
							BIE_LOC_COD_POST = ''46520'',
							DD_LOC_ID = 7184,
							DD_UPO_ID = (
								SELECT
									DD_UPO_ID
								FROM
									REMMASTER.DD_UPO_UNID_POBLACIONAL
								WHERE
									DD_UPO_CODIGO = ''462200000''
							),
							USUARIOMODIFICAR = ''REMVIP-2138'',
							FECHAMODIFICAR = SYSDATE
					WHERE
						BIE_LOC_ID IN (
							SELECT
								BILO.DD_LOC_ID
							FROM
								'||V_ESQUEMA||'.ACT_ACTIVO ACT
								INNER JOIN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION LOC ON ACT.ACT_ID = LOC.ACT_ID
								INNER JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BILO ON BILO.BIE_ID = ACT.BIE_ID
								INNER JOIN REMMASTER.DD_LOC_LOCALIDAD LOCA ON BILO.DD_LOC_ID = LOCA.DD_LOC_ID
							WHERE
								ACT.ACT_NUM_ACTIVO IN (
									109009,111336
								)
						)';
	
	EXECUTE IMMEDIATE V_MSQL;
    
	COMMIT;
   
	DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO FINALIZADO CORRECTAMENTE ');
 

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

EXIT
