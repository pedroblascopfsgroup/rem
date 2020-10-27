--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201027
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8242
--## PRODUCTO=NO
--##
--## Finalidad: DDL Añadir campos en la tabla ACT_PLS_PLUSVALIA
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_TABLA VARCHAR2(150 CHAR):= 'ACT_PLS_PLUSVALIA'; -- Vble. con el nombre de la tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
     V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
       T_TIPO_DATA('NUM_EXPEDIENTE', 'NUMBER (16,0)'),
       T_TIPO_DATA('DD_MOE_ID', 'NUMBER(16,0)'),
       T_TIPO_DATA('DD_RES_ID', 'NUMBER(16,0)')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

    -- ******** ACT_PLS_PLUSVALIA *******
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Creacion Tabla ACT_PLS_PLUSVALIA
    
    -- Comprobamos si existe la tabla   
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Tabla NO EXISTE');    
    ELSE  
		FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST    
    	LOOP      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
		    
        	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||TRIM(V_TMP_TIPO_DATA(1))||''' and TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
			
        	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    
          IF V_NUM_TABLAS = 1 THEN
            
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.'||V_TMP_TIPO_DATA(1)||'... YA EXISTE'); 
          
          ELSE
          
            V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD '||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||'';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.'||V_TMP_TIPO_DATA(1)||'... CAMPO AÑADIDO'); 

          END IF;
			 
      END LOOP;

    V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME= ''FK_DD_MOE_ID'' and TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''
                  AND R_CONSTRAINT_NAME = ''DD_MOE_MOTIVO_EXENTO_PK''';
			
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS = 1 THEN
            
        DBMS_OUTPUT.PUT_LINE('[INFO] CONSTRAINT EN '||V_ESQUEMA||'.'||V_TABLA||' FK_DD_MOE_ID... YA EXISTE'); 
          
    ELSE

      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' DROP CONSTRAINT FK_DD_MOE_ID';
      EXECUTE IMMEDIATE V_MSQL;
      
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD CONSTRAINT FK_DD_MOE_ID FOREIGN KEY (DD_MOE_ID)
              REFERENCES '||V_ESQUEMA||'.DD_MOE_MOTIVO_EXENTO(DD_MOE_ID) ON DELETE SET NULL ENABLE';
      EXECUTE IMMEDIATE V_MSQL;

    END IF;

    V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME= ''FK_DD_RES_ID'' and TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
			
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS = 1 THEN
            
        DBMS_OUTPUT.PUT_LINE('[INFO] CONSTRAINT EN '||V_ESQUEMA||'.'||V_TABLA||' FK_DD_RES_ID... YA EXISTE'); 
          
    ELSE

      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD CONSTRAINT FK_DD_RES_ID FOREIGN KEY (DD_RES_ID)
              REFERENCES '||V_ESQUEMA||'.DD_RES_RESULTADO_SOLICITUD(DD_RES_ID) ON DELETE SET NULL ENABLE';
      EXECUTE IMMEDIATE V_MSQL;

    END IF;

      DBMS_OUTPUT.PUT_LINE('CONSTRAINT FKS CREADAS EN '||V_TABLA||''); 

      V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.NUM_EXPEDIENTE IS ''Numero de expediente''';
      EXECUTE IMMEDIATE V_MSQL;

      V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_MOE_ID IS ''FK refenciada ID motivo exento''';
      EXECUTE IMMEDIATE V_MSQL;

      V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_RES_ID IS ''FK refenciada ID resultado solicitud''';
      EXECUTE IMMEDIATE V_MSQL;

      DBMS_OUTPUT.PUT_LINE('COMENTARIOS AÑADIDOS EN NUEVOS CAMPOS DE '||V_TABLA||'');

    END IF;
   
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]:  ACTUALIZADO CORRECTAMENTE ');
    
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
