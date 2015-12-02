--/*
--##########################################
--## AUTOR=GONZALO ESTELLES
--## FECHA_CREACION=20151115
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.11-hcj
--## INCIDENCIA_LINK=VARIAS
--## PRODUCTO=NO
--##
--## Finalidad: Corrección de scripts previos
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
	
    V_CUENTA NUMBER(10);
    V_TAREA VARCHAR(50 CHAR);
    V_DD_TAC_ID		DD_TAC_TIPO_ACTUACION.DD_TAC_ID%TYPE;
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] Mueve procedimiento');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.Dd_Tpo_Tipo_Procedimiento' ||
		' SET DD_TAC_ID=(select DD_TAC_ID from '||V_ESQUEMA||'.Dd_Tac_Tipo_Actuacion where dd_tac_codigo=''TR'') WHERE DD_TPO_CODIGO IN (''HCJ003'')';
	DBMS_OUTPUT.PUT_LINE('[INICIO] procedimiento reubicado!');

COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;