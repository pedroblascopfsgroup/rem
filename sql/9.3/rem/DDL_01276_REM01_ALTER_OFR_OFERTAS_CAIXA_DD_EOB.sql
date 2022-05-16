--/*
--##########################################
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20220510
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17804
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
    V_USR VARCHAR2(30 CHAR) := 'HREOS-17804'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_FK_NOMBRE VARCHAR2(100 CHAR) := 'FK_DD_EOB_ID';
    
BEGIN		
	V_SQL := 'SELECT COUNT(*)
				FROM USER_TAB_COLS
				WHERE COLUMN_NAME = ''DD_EOB_ID''
				AND TABLE_NAME = ''OFR_OFERTAS_CAIXA''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[INICIO] ADD COLUMN DD_EOB_ID');
		
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.OFR_OFERTAS_CAIXA ADD DD_EOB_ID NUMBER(16)';
	    EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[FIN] COLUMNA AÑADIDA');

        V_MSQL :='SELECT COUNT(1) FROM SYS.ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = '''||V_FK_NOMBRE||''' ';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 0 THEN
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.OFR_OFERTAS_CAIXA
					   ADD CONSTRAINT '||V_FK_NOMBRE||' FOREIGN KEY (DD_EOB_ID)
                       REFERENCES '||V_ESQUEMA||'.DD_EOB_ESTADO_OFERTA_BC (DD_EOB_ID)';
					   
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDA RELACION '''||V_FK_NOMBRE||''' ');
        ELSE
        	DBMS_OUTPUT.PUT_LINE('[INFO] La Foreign key con nombre '''||V_FK_NOMBRE||''' ya existe ');
        END IF;
    
        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.OFR_OFERTAS_CAIXA.DD_EOB_ID IS ''Diccionario de estado oferta BC''';
        EXECUTE IMMEDIATE V_MSQL;
		
        
		
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
