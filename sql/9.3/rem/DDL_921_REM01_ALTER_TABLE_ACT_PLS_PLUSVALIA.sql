--/*
--##########################################
--## AUTOR= Lara Pablo
--## FECHA_CREACION=20191119
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-8703
--## PRODUCTO=NO
--##
--## Finalidad: DDL Cambiar los campos nullables en la tabla ACT_PLS_PLUSVALIA
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_TABLA VARCHAR2(150 CHAR):= 'ACT_PLS_PLUSVALIA'; -- Vble. con el nombre de la tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
     V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
     
        T_TIPO_DATA('ACT_PLS_FECHA_RECEPCION_PLUSVALIA', 'DATE','N', 'DATE NULL'),
        T_TIPO_DATA('ACT_PLS_FECHA_PRESENTACION_PLUSVALIA', 'DATE','N', 'DATE NULL'),
        T_TIPO_DATA('ACT_PLS_FECHA_PRESENTACION_RECURSO', 'DATE','N', 'DATE NULL'),
        T_TIPO_DATA('ACT_PLS_FECHA_RESPUESTA_RECURSO', 'DATE','N', 'DATE NULL'),
        
        T_TIPO_DATA('ACT_PLS_APERTURA_Y_SEGUIMIENTO_EXP', 'NUMBER','N', 'NUMBER(16,0) NULL'),
        T_TIPO_DATA('ACT_PLS_IMPORTE_PAGADO', 'NUMBER','N', 'NUMBER(16,2) NULL'),
        T_TIPO_DATA('ACT_PLS_EXENTO', 'NUMBER','N', 'NUMBER(16,0) NULL'),
        T_TIPO_DATA('ACT_PLS_AUTOLIQUIDACION', 'NUMBER','N', 'NUMBER(16,0) NULL'),
        T_TIPO_DATA('ACT_PLS_MINUSVALIA', 'NUMBER','N', 'NUMBER(16,0) NULL'),
        
        
        -- Poner la auditoria no nullable
       T_TIPO_DATA('VERSION', 'NUMBER','Y', 'NUMBER(16,0) NOT NULL'),
       T_TIPO_DATA('USUARIOCREAR', 'VARCHAR2','Y', 'VARCHAR2(50 CHAR) NOT NULL'),
       T_TIPO_DATA('FECHACREAR', 'TIMESTAMP','Y', 'TIMESTAMP(6) NOT NULL')
              
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

    -- ******** ACT_PLS_PLUSVALIA *******
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Creacion Tabla ACT_PLS_PLUSVALIA
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Tabla NO EXISTE');    
    ELSE  
		FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST    
    	LOOP      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
		    
        	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||TRIM(V_TMP_TIPO_DATA(1))||''' and DATA_TYPE = '''||TRIM(V_TMP_TIPO_DATA(2))||''' and NULLABLE ='''||TRIM(V_TMP_TIPO_DATA(3))||'''
				 and TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
			
        	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    
			 IF V_NUM_TABLAS = 1 THEN
			 
			 	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' MODIFY ('||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(4)||')';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.'||V_TMP_TIPO_DATA(1)||'... Modificada'); 
			 
			 ELSE
			 	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.'||V_TMP_TIPO_DATA(1)||'... NO Modificada'); 
			 END IF;
			 
		END LOOP;
		
		
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
