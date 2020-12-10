--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8448
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-8448'; -- USUARIOCREAR/USUARIOMODIFICAR.
    
BEGIN		
	V_SQL := 'SELECT COUNT(*)
				FROM USER_TAB_COLS
				WHERE COLUMN_NAME = ''ICO_ADMITE_MASCOTAS''
				AND TABLE_NAME = ''ACT_ICO_INFO_COMERCIAL''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[INICIO] ADD COLUMN ICO_ADMITE_MASCOTAS');
		
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ADD ICO_ADMITE_MASCOTAS NUMBER(16)';
	    EXECUTE IMMEDIATE V_MSQL;
    
        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.ICO_ADMITE_MASCOTAS IS ''DD_SINI_SINOINDIFERENTE Indica si la vivienda admite mascotas''';
        EXECUTE IMMEDIATE V_MSQL;

        V_MSQL :='ALTER TABLE '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ADD CONSTRAINT FK_DD_SINI FOREIGN KEY (ICO_ADMITE_MASCOTAS) REFERENCES '||V_ESQUEMA||'.DD_SINI_SINOINDIFERENTE (DD_SINI_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		
        DBMS_OUTPUT.PUT_LINE('[FIN] COLUMNA AÑADIDA');
		
	ELSE
		 DBMS_OUTPUT.PUT_LINE('[FIN] COLUMNA YA EXISTE');		
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