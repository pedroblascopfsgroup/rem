--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170802
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2592
--## PRODUCTO=NO
--## Finalidad: DML inserta documentos de activos de los documentos de expediente vinculables
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_MSQL VARCHAR2(4000 CHAR);
    V_MAX_TPD_ID NUMBER(16,0);
    V_MAX_TPD_CODIGO VARCHAR2(20 CHAR);
    V_TABLA_SELECT VARCHAR2(50 CHAR) := 'DD_TPD_TIPO_DOCUMENTO';
    V_TABLA_INSERT VARCHAR2(50 CHAR) := 'DD_SDE_SUBTIPO_DOC_EXP';

    
BEGIN
	
  DBMS_OUTPUT.put_line('[INFO] Ejecutando inserción de Documentos activo...........');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_INSERT||' SDE
				   SET (SDE.DD_SDE_TPD_ID) = (SELECT TPD.DD_TPD_ID
				                         FROM '||V_ESQUEMA||'.'||V_TABLA_SELECT||' TPD
				                        WHERE SDE.DD_SDE_MATRICULA_GD = TPD.DD_TPD_MATRICULA_GD AND TPD.BORRADO = 0 AND SDE.DD_SDE_VINCULABLE = 1)
				 WHERE EXISTS (
				    SELECT 1
				      FROM '||V_ESQUEMA||'.'||V_TABLA_SELECT||' TPD
				     WHERE SDE.DD_SDE_MATRICULA_GD = TPD.DD_TPD_MATRICULA_GD AND TPD.BORRADO = 0)';
				     
	EXECUTE IMMEDIATE V_MSQL;
  
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