--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20170919
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2868
--## PRODUCTO=NO
--##
--## Finalidad: Se añade una constraint a la tabla tac_tareas_activos
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
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Se inicia el proceso de creacion de la nueva constraint.');
	
	--Comprobamos si existe la constraint
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''TAC_TAREAS_ACTIVOS'' AND OWNER = '''||V_ESQUEMA||''' AND CONSTRAINT_NAME = ''FK_TARACTIVO_TRATRAMITE''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
	IF V_NUM_TABLAS = 0 THEN
	
		DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobamos si existen datos que violen la nueva constraint');
		
		--Comprobamos si existen datos que violen la constraint antes de crearla
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC WHERE NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA WHERE TAC.TRA_ID = TRA.TRA_ID)';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		--Si existe lo actualizamos
		IF V_NUM_TABLAS > 0 THEN
		
			DBMS_OUTPUT.PUT_LINE('[INFO]: Iniciamos el borrado de las tareas sin tramite asociado');
			V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
					   WHERE NOT EXISTS (
					   SELECT 1 FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA WHERE TAC.TRA_ID = TRA.TRA_ID)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: Se han borrado '||SQL%ROWCOUNT||' registros de la tabla TAC_TAREAS_ACTIVOS');
		
		ELSE		
			DBMS_OUTPUT.PUT_LINE('[INFO]: No hay datos que violen la constraint');		
		END IF;	
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: Creamos la FK ''FK_TARACTIVO_TRATRAMITE'' en la tabla TAC_TAREAS_ACTIVOS');		
		V_MSQL := '
			ALTER TABLE REM01.TAC_TAREAS_ACTIVOS
			ADD CONSTRAINT FK_TARACTIVO_TRATRAMITE FOREIGN KEY (TRA_ID)
			REFERENCES REM01.ACT_TRA_TRAMITE (TRA_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO]: FK ''FK_TARACTIVO_TRATRAMITE'' creada correctamente en la tabla TAC_TAREAS_ACTIVOS');
	
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO]: Ya existela FK ''FK_TARACTIVO_TRATRAMITE'' en la tabla TAC_TAREAS_ACTIVOS. NO HACEMOS NADA');	
	END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: El proceso de creacion de la nueva constraint a finalizado correctamente.');
   

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
