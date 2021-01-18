--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20170518
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1977
--## PRODUCTO=NO
--## Finalidad: Función para obtener el usuario que debe ser gestoría de formalización (GIAFORM) de un expediente comercial dado un activo concreto.
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
DBMS_OUTPUT.PUT_LINE('[INFO] Función FUNCTION CALCULAR_USUARIO_GIAFORM: INICIANDO...');   	 
EXECUTE IMMEDIATE '
		
		CREATE OR REPLACE FUNCTION '||V_ESQUEMA||'.CALCULAR_USUARIO_GIAFORM (P_ACT_ID IN NUMBER) RETURN NUMBER AS
		
		
		ACTIVO NUMBER(16,2);
		USUARIO NUMBER(16,2);
		
		
		BEGIN
			
			SELECT USU_ID AS USUARIO, ACT_ID AS ACTIVO INTO USUARIO, ACTIVO 
			FROM (
				SELECT USU_ID, ACT_ID, SUM(NUMOFERTAS) AS NUMOFERTAS 
				FROM (
					SELECT USU.USU_ID, ACT.ACT_ID, 0 AS NUMOFERTAS FROM '||V_ESQUEMA||'.V_GESTORES_ACTIVO VISTA
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON VISTA.ACT_ID = ACT.ACT_ID
					JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = VISTA.USERNAME
					WHERE VISTA.ACT_ID = ACT.ACT_ID AND VISTA.TIPO_GESTOR = ''GIAFORM''
					UNION ALL
					SELECT USU.USU_ID, ACT.ACT_ID, COUNT(*) AS NUMOFERTAS 
					FROM '||V_ESQUEMA||'.V_GESTORES_ACTIVO VISTA
					JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = VISTA.USERNAME
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON VISTA.ACT_ID = ACT.ACT_ID
					JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.USU_ID = USU.USU_ID
					JOIN '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO GCO ON GCO.GEE_ID = GEE.GEE_ID
					JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = GCO.ECO_ID
					JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID AND EEC.DD_EEC_CODIGO IN (''11'',''05'',''06'',''14'')
					WHERE VISTA.ACT_ID = ACT.ACT_ID AND VISTA.TIPO_GESTOR = ''GIAFORM''
					GROUP BY(USU.USU_ID, ACT.ACT_ID)
				)
				GROUP BY(USU_ID, ACT_ID)
				ORDER BY NUMOFERTAS ASC
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