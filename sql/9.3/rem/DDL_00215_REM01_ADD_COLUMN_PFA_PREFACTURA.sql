--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20210325
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9323
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-9323'; -- USUARIOCREAR/USUARIOMODIFICAR.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                    --TABLA               CAMPO       TIPO                            COMENTARIO                        CAMPO_FK    TABLA_FK                      NOMBRE_FK
        T_TIPO_DATA('PFA_PREFACTURA'      ,'DD_DEG_ID', 'NUMBER(16,0)', 'Destinatario futuro del gasto', 'DD_DEG_ID', 'DD_DEG_DESTINATARIOS_GASTO', 'FK_PFA_DD_DEG_ID'),
        T_TIPO_DATA('PFA_PREFACTURA'      ,'DD_TEG_ID', 'NUMBER(16,0)', 'Emisor futuro del gasto', 'DD_TEG_ID', 'DD_TEG_TIPO_EMISOR_GLD', 'FK_PFA_DD_TEG_ID')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
  
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
  FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	
        V_SQL := 'SELECT COUNT(1) 
          FROM ALL_TAB_COLUMNS 
          WHERE COLUMN_NAME = '''||V_TMP_TIPO_DATA(2)||'''
            AND TABLE_NAME = '''||V_TMP_TIPO_DATA(1)||'''
            AND OWNER = '''||V_ESQUEMA||'''';
		    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		    IF V_NUM_TABLAS = 0 THEN
		
    			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_TIPO_DATA(1)||'
            ADD ('||V_TMP_TIPO_DATA(2)||' '||V_TMP_TIPO_DATA(3)||')';
          EXECUTE IMMEDIATE V_MSQL;

          V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TMP_TIPO_DATA(1)||'.'||V_TMP_TIPO_DATA(2)||' IS '''||V_TMP_TIPO_DATA(4)||'''';
          EXECUTE IMMEDIATE V_MSQL;

          DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDA '||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2));
		
        ELSE 
		
          DBMS_OUTPUT.PUT_LINE('[INFO] LA COLUMNA '||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||' YA EXISTE');
		
		    END IF;

        V_SQL := 'SELECT COUNT(1)
          FROM ALL_CONSTRAINTS CONS
          INNER JOIN ALL_CONS_COLUMNS COL ON COL.CONSTRAINT_NAME = CONS.CONSTRAINT_NAME
          WHERE CONS.OWNER = '''||V_ESQUEMA||''' 
            AND CONS.TABLE_NAME = '''||V_TMP_TIPO_DATA(1)||''' 
            AND CONS.CONSTRAINT_TYPE = ''R''
            AND COL.COLUMN_NAME = '''||V_TMP_TIPO_DATA(2)||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN

          DBMS_OUTPUT.PUT_LINE('  [INFO] La FK '||V_TMP_TIPO_DATA(7)||'... Ya existe.');                 

        ELSE
          
          DBMS_OUTPUT.PUT_LINE('  [INFO] Creando '||V_TMP_TIPO_DATA(7)||'...');           
            
          EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_TIPO_DATA(1)||'
            ADD (CONSTRAINT '||V_TMP_TIPO_DATA(7)||' FOREIGN KEY ('||V_TMP_TIPO_DATA(2)||') 
              REFERENCES '||V_ESQUEMA||'.'||V_TMP_TIPO_DATA(6)||' ('||V_TMP_TIPO_DATA(5)||') ON DELETE SET NULL)';

        END IF;
		
      END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');
	
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
