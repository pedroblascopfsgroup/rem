--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20160403
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Procedimiento para desparalizar las tareas paralizadas
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN
    
--##CREACION DE TABLA, PK y FK de tabla

  DBMS_OUTPUT.PUT('[INFO] Procedure PROCEDURE SP_DESPARALIZAR_TAREAS: CREADA...');	     	 
	EXECUTE IMMEDIATE 'CREATE OR REPLACE PROCEDURE '||V_ESQUEMA||'.SP_DESPARALIZAR_TAREAS AS
		BEGIN

		MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR USING '||V_ESQUEMA||'.V_TAREAS_PARALIZADAS_ADMISION VPAR 
		ON (TAR.TAR_ID = VPAR.TAR_ID) 
		WHEN MATCHED THEN UPDATE 
		SET TAR.BORRADO = 0;

		MERGE INTO '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX USING '||V_ESQUEMA||'.V_TAREAS_PARALIZADAS_ADMISION VPAR 
		ON (TEX.TEX_ID = VPAR.TEX_ID) 
		WHEN MATCHED THEN UPDATE 
			SET TEX.TEX_DETENIDA = 0;

		MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR USING '||V_ESQUEMA||'.V_TAREAS_PARALIZADAS_ADMISION VPAR 
		ON (TAR.TAR_ID = VPAR.TAR_ID) 
		WHEN MATCHED THEN UPDATE 
			SET TAR.TAR_FECHA_VENC = (SELECT SYSDATE +15 FROM DUAL);

		END SP_DESPARALIZAR_TAREAS;';
  
	DBMS_OUTPUT.PUT('[INFO] Procedure PROCEDURE SP_DESPARALIZAR_TAREAS: CREADO...OK');
	
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