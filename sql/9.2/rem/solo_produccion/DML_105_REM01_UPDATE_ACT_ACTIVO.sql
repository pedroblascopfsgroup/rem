--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20190304
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3433
--## PRODUCTO=NO
--##
--## Finalidad: Actualización  ACTIVO
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


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
           
BEGIN	
	
       DBMS_OUTPUT.PUT_LINE('[INICIO] ');

       DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE ACT_ACTIVO] ');
         
    
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO ACT
				  SET ACT_NUM_ACTIVO = ''144839'', 
                     		  ACT_NUM_ACTIVO_SAREB = ''568870'',
                     		  ACT_RECOVERY_ID = ''1000000000180356'', 
                     		  USUARIOMODIFICAR = ''REMVIP-3511'', 
                    		  FECHAMODIFICAR = SYSDATE 
                    		  WHERE ACT_NUM_ACTIVO = 999183797 
                    		  AND ACT_NUM_ACTIVO_SAREB = 1069320
				';

	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' ACTIVO ACTUALIZADO');
          
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_ESQUEMA||'.ACT_ACTIVO ACTUALIZADA CORRECTAMENTE');   

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
