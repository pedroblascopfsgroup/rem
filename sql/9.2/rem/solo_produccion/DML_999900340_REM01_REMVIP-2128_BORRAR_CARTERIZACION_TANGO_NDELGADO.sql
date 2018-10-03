--/*
--##########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20181002
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2128
--## PRODUCTO=NO
--##
--## Finalidad: Quitar la carterizacion de Tango a la usuario 'ndelgado'
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(30 CHAR) := 'UCA_USUARIO_CARTERA';  -- Tabla a modificar
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-2128'; -- USUARIOCREAR/USUARIOMODIFICAR
       
 
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
	 
    V_SQL :=   'DELETE FROM REM01.UCA_USUARIO_CARTERA UCA
				WHERE EXISTS (
								SELECT 1
								FROM REM01.UCA_USUARIO_CARTERA UCA2
								JOIN REMMASTER.USU_USUARIOS    USU
								  ON USU.USU_ID = UCA2.USU_ID
								JOIN REM01.DD_CRA_CARTERA      CRA
								  ON CRA.DD_CRA_ID = UCA2.DD_CRA_ID
								WHERE USU.USU_USERNAME = ''ndelgado''
								  AND CRA.DD_CRA_CODIGO = ''10''
								  AND UCA.UCA_ID = UCA2.UCA_ID
				)
	';
    EXECUTE IMMEDIATE V_SQL;  
    DBMS_OUTPUT.PUT_LINE('[INFO]: Se borran '||SQL%ROWCOUNT||' registros de la REM01.UCA_USUARIO_CARTERA');
    
	
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');
   

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
