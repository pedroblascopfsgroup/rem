--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20170518
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1977
--## PRODUCTO=NO
--## Finalidad: Función para obtener el usuario que debe ser gestor de formalización (GFORM) de un expediente comercial dado un activo concreto.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.


BEGIN
DBMS_OUTPUT.PUT_LINE('[INFO] Función FUNCTION CALCULAR_USUARIO_GFORM: INICIANDO...');   	 
EXECUTE IMMEDIATE '
		
		CREATE OR REPLACE FUNCTION '||V_ESQUEMA||'.CALCULAR_USUARIO_GFORM (P_ACT_ID IN NUMBER) RETURN NUMBER AS
		
		
		ACTIVO NUMBER(16,2);
		USUARIO NUMBER(16,2);
		
		
		BEGIN
			
			SELECT USU_ID AS USUARIO, ACT_ID AS ACTIVO INTO USUARIO, ACTIVO 
			FROM (
				SELECT USU.USU_ID, ACT.ACT_ID FROM REM01.V_GESTORES_ACTIVO VISTA 
				JOIN REM01.ACT_ACTIVO ACT ON VISTA.ACT_ID = ACT.ACT_ID
				JOIN REMMASTER.USU_USUARIOS USU ON USU.USU_USERNAME = VISTA.USERNAME
				WHERE VISTA.ACT_ID = ACT.ACT_ID AND VISTA.TIPO_GESTOR = ''GFORM''
                    		ORDER BY  DBMS_RANDOM.VALUE
			) WHERE ROWNUM = 1 AND ACT_ID = P_ACT_ID;
			
			
			RETURN USUARIO;
			
			EXCEPTION
		         WHEN OTHERS THEN
		              DBMS_OUTPUT.put_line(''[ERROR] Se ha producido un error en la ejecución: ''||TO_CHAR(SQLCODE));
		 			  DBMS_OUTPUT.put_line(''-----------------------------------------------------------'');
		              DBMS_OUTPUT.put_line(SQLERRM);
		              RETURN NULL;
			
		END;
		';
  
DBMS_OUTPUT.PUT_LINE('[INFO] Proceso ejecutado CORRECTAMENTE. Function creada.');
	
COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
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
