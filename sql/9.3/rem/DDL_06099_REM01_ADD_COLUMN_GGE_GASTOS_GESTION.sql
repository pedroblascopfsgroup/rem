--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220525
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11349
--## PRODUCTO=NO
--##
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-11349'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_COLUMNA VARCHAR2(100 CHAR):='GGE_MOTIVO_RECHAZO_HAYA';
    V_TABLA VARCHAR2(100 CHAR):='GGE_GASTOS_GESTION';
    V_MOTIVO_RECHAZO VARCHAR2(100 CHAR):='Motivo rechazo en caso de marcar otros en MRH';
    
BEGIN		
	V_SQL := 'SELECT COUNT(*)
				FROM USER_TAB_COLS
				WHERE COLUMN_NAME = '''||V_COLUMNA||'''
				AND TABLE_NAME = '''||V_TABLA||'''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[INICIO] ADD COLUMN '||V_COLUMNA||'');
		
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD '||V_COLUMNA||' VARCHAR2(512 CHAR)';
	    EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[FIN] COLUMNA AÑADIDA');
    
        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_COLUMNA||' IS '''||V_MOTIVO_RECHAZO||'''';
        EXECUTE IMMEDIATE V_MSQL;
		
	ELSE
		 DBMS_OUTPUT.PUT_LINE('[FIN] COLUMNA '||V_TABLA||'.'||V_COLUMNA||' YA EXISTE');		
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