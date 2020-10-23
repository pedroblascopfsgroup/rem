--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20201014
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8153
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-8153'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_FK_NOMBRE VARCHAR2(100 CHAR) := 'FK_MEDIADOR_RELACIONADO';
    
BEGIN		
	V_SQL := 'SELECT COUNT(*)
				FROM USER_TAB_COLS
				WHERE COLUMN_NAME = ''PVE_ID_MEDIADOR_REL''
				AND TABLE_NAME = ''ACT_PVE_PROVEEDOR''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[INICIO] ADD COLUMN PVE_ID_MEDIADOR_REL');
		
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR ADD PVE_ID_MEDIADOR_REL NUMBER(16)';
	    EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[FIN] COLUMNA AÑADIDA');

        V_MSQL :='SELECT COUNT(1) FROM SYS.ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = '''||V_FK_NOMBRE||''' ';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 0 THEN
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR
					   ADD CONSTRAINT '||V_FK_NOMBRE||' FOREIGN KEY (PVE_ID_MEDIADOR_REL)
                       REFERENCES '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR (PVE_ID)';
					   
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDA RELACION '''||V_FK_NOMBRE||''' ');
        ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] La Foreign key con nombre '''||V_FK_NOMBRE||''' ya existe ');
        END IF;
    
        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.PVE_ID_MEDIADOR_REL IS ''Mediador relacionado, relacionado con el PVE_ID''';
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