--/*
--##########################################
--## AUTOR=JAVIER RUIZ
--## FECHA_CREACION=20-11-2015
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-468
--## PRODUCTO=NO
--## Finalidad: DML Agrega validación Riesgo Operacional al BPM Cajamar en procedimiento PCO_RevisarExpedientePreparar
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
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage

    BEGIN

    DBMS_OUTPUT.PUT_LINE('[INFO] Comprobaciones previas...'); 
    
    -- Comprobamos si existe el registro a modificar   
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''PCO_RevisarExpedientePreparar'' '||
    			'AND TAP.DD_TPO_ID = (SELECT TPO.DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO WHERE TPO.DD_TPO_CODIGO = ''PCO'' AND TPO.BORRADO = 0)';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si NO existe el registro no hacemos nada
    IF V_NUM_TABLAS = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] NO Existe un registro para actualizar');
	ELSE
    	DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado registro para actualizar...');    
		 --Actualizamos el registro
		 V_MSQL := q'[UPDATE ]'||V_ESQUEMA||q'[.TAP_TAREA_PROCEDIMIENTO TAP SET TAP.TAP_SCRIPT_VALIDACION = 'compruebaRiesgoOperacional() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para completar esta tarea todos los contratos del asunto deben tener asignado un Riego Operacional.</div>''' WHERE TAP.TAP_CODIGO = 'PCO_RevisarExpedientePreparar' AND TAP.DD_TPO_ID = (SELECT TPO.DD_TPO_ID FROM ]'||V_ESQUEMA||q'[.DD_TPO_TIPO_PROCEDIMIENTO TPO WHERE TPO.DD_TPO_CODIGO = 'PCO' AND TPO.BORRADO = 0)]';
		 DBMS_OUTPUT.PUT_LINE(V_MSQL);

		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado el procedimiento PCO_RevisarExpedientePreparar');
	END IF;
	
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
