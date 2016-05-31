--/*
--##########################################
--## AUTOR=RUBEN ROVIRA
--## FECHA_CREACION=20160308
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-2381
--## PRODUCTO=NO
--## Finalidad: DML
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

    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_COLUMN   NUMBER(16); -- Vble. para validar la existencia de una columna. 
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_VIEW     NUMBER(16); -- Vble. para validar la existencia de una vista.
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN
    
    -----------------------
    --   DD_ESTADO_CNT   --
    -----------------------   
    
    --** Cambiamos Diccionario estado contrato 

			--** Modificamos la tabla
			V_MSQL := 'UPDATE '||v_esquema_m||'.dd_esc_estado_cnt set dd_esc_descripcion=''Activo'' , dd_esc_descripcion_larga=''Activo'', USUARIOMODIFICAR=''DD'',FECHAMODIFICAR=SYSDATE where dd_esc_codigo=''0''';
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||v_esquema_m||'.dd_esc_estado_cnt set dd_esc_descripcion=''Cancelado'', dd_esc_descripcion_larga=''Cancelado'' , USUARIOMODIFICAR=''DD'',FECHAMODIFICAR=SYSDATE where dd_esc_codigo=''7''';
			EXECUTE IMMEDIATE V_MSQL;
			V_SQL := 'SELECT COUNT(1) FROM  '||v_esquema_m||'.dd_esc_estado_cnt where dd_esc_codigo=''6''';
			EXECUTE IMMEDIATE v_sql INTO v_num_column;	
				IF V_NUM_COLUMN = 0	THEN	
					V_MSQL := 'insert into '||v_esquema_m||'.dd_esc_estado_cnt (DD_ESC_ID,DD_ESC_CODIGO,DD_ESC_DESCRIPCION,DD_ESC_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES (''4'',''6'',''No recibido'',''No recibido'',''INICIAL'',SYSDATE)';
					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('[INFO] Insertamos dd_esc_codigo 6');
				END IF;	
			V_MSQL := 'UPDATE '||v_esquema||'.CNT_CONTRATOS SET DD_ESC_ID=(select dd_esc_id from '||v_esquema_m||'.dd_esc_estado_cnt where dd_esc_codigo=''6'') WHERE DD_ESC_ID=(select dd_esc_id from '||v_esquema_m||'.dd_esc_estado_cnt where dd_esc_codigo=''8'')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Cambiamos estado 8 por 6');
			V_MSQL := 'DELETE FROM '||v_esquema_m||'.dd_esc_estado_cnt where dd_esc_codigo=''8''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Eliminamos estado 8');
			COMMIT;
            DBMS_OUTPUT.PUT_LINE('[INFO] DML FIN');  
    
     
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
