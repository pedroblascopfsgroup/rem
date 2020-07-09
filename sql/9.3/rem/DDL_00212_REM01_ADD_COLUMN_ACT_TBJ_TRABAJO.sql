--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20200707
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10440
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
    V_USR VARCHAR2(30 CHAR) := 'HREOS-10440'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'ACT_TBJ_TRABAJO'; -- USUARIOCREAR/USUARIOMODIFICAR.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('TBJ_GESTOR_ALTA', 'NUMBER(16,0)', 'Gestor de admisión que da de alta el trabajo'),
        T_TIPO_DATA('TBJ_ID_TAREA', 'NUMBER(16,0)', 'Campo para informar la tarea del buzón. Se validará con el wsCodigoTareas'),
        T_TIPO_DATA('TBJ_APLICA_COMITE', 'NUMBER(1,0)', 'Flag que indica si aplica comité'),
        T_TIPO_DATA('DD_ACO_ID', 'NUMBER(16,0)', 'Estado de la resolución del comité'),
        T_TIPO_DATA('TBJ_FECHA_RES_COMITE', 'DATE', 'Fecha en la que se resuelve el comité'),
        T_TIPO_DATA('TBJ_RES_COMITE_ID', 'VARCHAR2(50 CHAR)', 'Referencia de la resolución del cliente'),
        T_TIPO_DATA('TBJ_IMPORTE_PRESUPUESTO', 'NUMBER(16,0)', 'Importe del presupuesto aportado por el proveedor'),
        T_TIPO_DATA('TBJ_REF_IMPORTE_PRESUPUESTO', 'VARCHAR2(50 CHAR)', 'Número de referencia del presupuesto aportado por el proveedor'),
        T_TIPO_DATA('TBJ_SINIESTRO', 'NUMBER(1,0)', 'Flag que indica siniestro')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
    
    --Array para crear las claves foraneas
    TYPE T_FK IS TABLE OF VARCHAR2(250);
    TYPE T_ARRAY_FK IS TABLE OF T_FK;
    V_FK T_ARRAY_FK := T_ARRAY_FK(
    ------ 	 (ESQUEMA_ORIGEN, TABLA_ORIGEN, CAMPO_ORIGEN, ESQUEMA_DESTINO, TABLA_DESTINO, CAMPO_DESTINO, NOMBRE_F)
   		 T_FK(''||V_ESQUEMA||'', ''||V_TEXT_TABLA||'','TBJ_GESTOR_ALTA', ''||V_ESQUEMA_M||'', 'USU_USUARIOS', 'USU_ID', 'FK_TBJ_GES_USU_ID'),
   		 T_FK(''||V_ESQUEMA||'', ''||V_TEXT_TABLA||'','DD_ACO_ID', ''||V_ESQUEMA||'', 'DD_ACO_APROBACION_COMITE', 'DD_ACO_ID', 'FK_TBJ_DD_ACO_ID')
  );      
  V_TMP_FK T_FK;
  
  
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	
		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_TMP_TIPO_DATA(1)||''' 
														 and TABLE_NAME = ''ACT_TBJ_TRABAJO'' 
														 and OWNER = '''||V_ESQUEMA||'''';
		
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 0 THEN
		
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO
					   ADD ('||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||')';
					   
			EXECUTE IMMEDIATE V_MSQL;

			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.'||V_TMP_TIPO_DATA(1)||' IS '''||V_TMP_TIPO_DATA(3)||'''';

			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDA '||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2));
		
		ELSE 
		
			DBMS_OUTPUT.PUT_LINE('[INFO] LA COLUMNA '||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||' YA EXISTE');
		
		END IF;
		
	END LOOP;
	
	FOR J IN V_FK.FIRST .. V_FK.LAST
    LOOP
        V_TMP_FK := V_FK(J);
        
     
         V_SQL := ' SELECT COUNT(1)
          FROM ALL_CONSTRAINTS CONS
            INNER JOIN ALL_CONS_COLUMNS COL ON COL.CONSTRAINT_NAME = CONS.CONSTRAINT_NAME
         	WHERE CONS.OWNER = '''||V_TMP_FK(1)||''' 
            AND CONS.TABLE_NAME = '''||V_TMP_FK(2)||''' 
            AND CONS.CONSTRAINT_TYPE = ''R''
            AND COL.COLUMN_NAME = '''||V_TMP_FK(3)||'''
        ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       
        
        
        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('  [INFO] La FK '||V_TMP_FK(7)||'... Ya existe.');                 
        ELSE
            DBMS_OUTPUT.PUT_LINE('  [INFO] Creando '||V_TMP_FK(7)||'...');           
            
            EXECUTE IMMEDIATE 'ALTER TABLE '||V_TMP_FK(1)||'.'||V_TMP_FK(2)||' 
                ADD (CONSTRAINT '||V_TMP_FK(7)||' FOREIGN KEY ('||V_TMP_FK(3)||') 
                REFERENCES '||V_TMP_FK(4)||'.'||V_TMP_FK(5)||' ('||V_TMP_FK(6)||') ON DELETE SET NULL)
            '
            ;               
        END IF;
    
    END LOOP; 
	
	DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADA ACT_TBJ_TRABAJO');
	
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
