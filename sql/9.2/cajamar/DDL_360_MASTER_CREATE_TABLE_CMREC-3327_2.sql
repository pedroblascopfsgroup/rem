--/*
--##########################################
--## AUTOR=CARLOS LOPEZ VIDAL
--## FECHA_CREACION=20160513
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-3327
--## PRODUCTO=NO
--## Finalidad: DDL Creación de la tabla MNC_MTO_CORRECTIVO
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

BEGIN

    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MNC_MTO_CORRECTIVO'' and owner = '''||V_ESQUEMA_M||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        -- Si existe la tabla no hacemos nada
        IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.MNC_MTO_CORRECTIVO... Tabla YA EXISTE');
	ELSE
    
		 --Creamos la tabla
		 V_MSQL := 'CREATE TABLE '||V_ESQUEMA_M||'.MNC_MTO_CORRECTIVO (
					  MNC_PROPIETARIO VARCHAR(15 char) NOT NULL
                                        , DD_MNC_CODIGO	VARCHAR(10 char) NOT NULL
					, MNC_ORDEN NUMBER(16) NOT NULL
					, MNC_QUERY VARCHAR2(4000 char) NOT NULL
					, MNC_RESPONSABLE VARCHAR2(50 char) NOT NULL
					, MNC_FECHA_INICIO DATE NOT NULL
					, MNC_FECHA_FIN DATE NOT NULL 
					, MNC_RAZON VARCHAR2(1000 char)	NOT NULL 
					, BORRADO NUMBER(1) NOT NULL

	               )';


		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.MNC_MTO_CORRECTIVO... Tabla creada');
		

	END IF;


    --** Comprobamos si existe la tabla PK
    V_SQL := 'select count(1) from ALL_CONSTRAINTS where constraint_name = ''PK_MNC_MTO_CORRECTIVO'' and owner = upper('''||V_ESQUEMA_M||''')';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    IF V_NUM_TABLAS = 1 THEN 
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA_M||'.MNC_MTO_CORRECTIVO DROP CONSTRAINT PK_MNC_MTO_CORRECTIVO';        
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.PK_MNC_MTO_CORRECTIVO PK BORRADO...');
    END IF;
	
    
    --** Comprobamos si existe la tabla PK
    V_SQL := 'select count(1) from ALL_indexes where index_name = ''PK_MNC_MTO_CORRECTIVO''  and owner = upper('''||V_ESQUEMA_M||''')';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    
    IF V_NUM_TABLAS = 1 THEN 
      V_MSQL := 'DROP index '||V_ESQUEMA_M||'.PK_MNC_MTO_CORRECTIVO';        
      EXECUTE IMMEDIATE V_MSQL;

      DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema_m||'.MNC_MTO_CORRECTIVO INDICE PK BORRADO...');
    END IF;
	
    
    V_MSQL := 'ALTER TABLE '||V_ESQUEMA_M||'.MNC_MTO_CORRECTIVO
	         ADD CONSTRAINT PK_MNC_MTO_CORRECTIVO PRIMARY KEY (
	                    MNC_PROPIETARIO,
			    DD_MNC_CODIGO,
			    MNC_ORDEN)';        
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.MNC_MTO_CORRECTIVO NUEVA PK CREADA...');


    --** Comprobamos si existe la tabla FK
    V_SQL := 'select count(1) from ALL_CONSTRAINTS where constraint_name = ''FK_MNC_MTO_CORRECTIVO'' and owner = upper('''||V_ESQUEMA_M||''')';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    IF V_NUM_TABLAS = 1 THEN 
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA_M||'.MNC_MTO_CORRECTIVO DROP CONSTRAINT FK_MNC_MTO_CORRECTIVO';        
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.FK_MNC_MTO_CORRECTIVO PK BORRADO...');
    END IF;
    
    V_MSQL := 'ALTER TABLE '||V_ESQUEMA_M||'.MNC_MTO_CORRECTIVO
	         ADD CONSTRAINT FK_MNC_MTO_CORRECTIVO FOREIGN KEY (DD_MNC_CODIGO) REFERENCES '||V_ESQUEMA_M||'.DD_MNC_MTO_CORRECTIVO (DD_MNC_CODIGO) ';        
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.MNC_MTO_CORRECTIVO NUEVA FK CREADA...');    
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
