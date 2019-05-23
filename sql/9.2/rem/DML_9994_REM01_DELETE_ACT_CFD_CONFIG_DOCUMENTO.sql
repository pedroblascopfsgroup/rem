--/*
--#########################################
--## AUTOR=Adrián Molina Garrido	
--## FECHA_CREACION=20190523
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4320
--## PRODUCTO=NO
--## 
--## Finalidad: Borrar de la tabla ACT_CFD_CONFIG_CONFIG_DOCUMENTO 
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-4320';

BEGIN

--BUSCA Y ACTUALIZA DD_TPN_TIPO_INMUEBLE
			
				
			V_SQL := 'DELETE FROM REM01.ACT_CFD_CONFIG_DOCUMENTO
				WHERE CFD_ID IN  (SELECT CFD_ID FROM    ( 
                                       SELECT CFD.CFD_ID , ROW_NUMBER() OVER (PARTITION BY  CFD.DD_TPA_ID, CFD.DD_TPD_ID  order by CFD.DD_TPD_ID desc) AS ORDEN 
                                       from REM01.ACT_CFD_CONFIG_DOCUMENTO CFD
                                       LEFT JOIN REM01.ACT_ADO_ADMISION_DOCUMENTO ADO ON CFD.CFD_ID = ADO.CFD_ID
                                       WHERE ADO.CFD_ID IS NULL  
                                  )
				WHERE ORDEN > 1)';
		
				EXECUTE IMMEDIATE V_SQL;
				
				
				DBMS_OUTPUT.PUT_LINE('[INFO] Se ha borrado el registro en la tabla ACT_CFD_CONFIG_DOCUMENTO');
				
				COMMIT;
			
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya se han borrado todos los registros repetidos');



EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
