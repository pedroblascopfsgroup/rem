--/*
--######################################### 
--## AUTOR=NOELIA LAPERA
--## FECHA_CREACION=20180808
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4375
--## PRODUCTO=NO
--## 
--## Finalidad: Alter tabla de DD_TCC_TIPO_CALCULO
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.    
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_TABLA VARCHAR2(50 CHAR):= 'DD_TCC_TIPO_CALCULO'; -- Nombre de la tabla a crear
    
  --Array que contiene los registros que se van a crear
  TYPE T_COL IS TABLE OF VARCHAR2(250);
  TYPE T_ARRAY_COL IS TABLE OF T_COL;
  V_COL T_ARRAY_COL := T_ARRAY_COL(

  	  T_COL(''||V_ESQUEMA||'', ''||V_TABLA||''        , 'DD_TOF_ID'     		, 'NUMBER(16,0)'  )
	
  );  
  V_TMP_COL T_COL;


--Array para crear las claves foraneas
  TYPE T_FK IS TABLE OF VARCHAR2(250);
  TYPE T_ARRAY_FK IS TABLE OF T_FK;
  V_FK T_ARRAY_FK := T_ARRAY_FK(
      ----  ESQUEMA_ORIGEN ------ TABLA_ORIGEN ----------- CAMPO_ORIGEN ---------------- ESQUEMA_DESTINO ----- TABLA_DESTINO ------------------ CAMPO_DESTINO ------- NOMBRE_F ----------------
      T_FK(''||V_ESQUEMA||'',  ''||V_TABLA||''            ,'DD_TOF_ID'  		,''||V_ESQUEMA||''   ,'DD_TOF_TIPOS_OFERTA'     	,'DD_TOF_ID'  	,'FK_DD_TOF_ID')
);     
  V_TMP_FK T_FK;
  
  
BEGIN
    	
  -----------------------
  ---     CAMPOS      ---
  -----------------------

  DBMS_OUTPUT.PUT_LINE('[INICIO CAMPOS]');  
--Comprobacion de la tabla
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
  IF V_NUM_TABLAS > 0 THEN  

    FOR I IN V_COL.FIRST .. V_COL.LAST
    LOOP
        V_TMP_COL := V_COL(I);
                             
            -- Verificar si el campo ya existe
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_TMP_COL(1)||''' AND TABLE_NAME = '''||V_TMP_COL(2)||''' AND COLUMN_NAME = '''||V_TMP_COL(3)||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
            
            IF V_NUM_TABLAS = 0 THEN
                DBMS_OUTPUT.PUT_LINE('  [INFO] Creando el campo '||V_TMP_COL(3)||'');  
                
                -- Añadimos el campo
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_TMP_COL(1)||'.'||V_TMP_COL(2)||' ADD '||V_TMP_COL(3)||' '||V_TMP_COL(4)||'';        
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TMP_COL(2)||'.'||V_TMP_COL(3)||'... Ya existe.');
            END IF;    
                 
    END LOOP;
    
  ELSE
      DBMS_OUTPUT.PUT_LINE(' [INFO] '''||V_TABLA||'''... No existe.');  
  END IF;
  DBMS_OUTPUT.PUT_LINE('[FIN CAMPOS]');
    
      
    
  DBMS_OUTPUT.PUT_LINE('[CREAR FKs]');
  EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_CONSTRAINTS CONS
          INNER JOIN ALL_CONS_COLUMNS COL ON COL.CONSTRAINT_NAME = CONS.CONSTRAINT_NAME
          WHERE CONS.OWNER = '''||V_ESQUEMA||''' 
          AND CONS.TABLE_NAME = '''||V_TABLA||''' 
          AND CONS.CONSTRAINT_TYPE = ''R''
          AND COL.COLUMN_NAME = ''DD_TOF_ID''
      ' INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
      DBMS_OUTPUT.PUT_LINE('  [INFO] La FK FK_DD_TOF_ID_FORM... Ya existe.');                 
  ELSE
      DBMS_OUTPUT.PUT('  [INFO] Crear FK_DD_TOF_ID_FORM...');           
      EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.DD_TCC_TIPO_CALCULO 
          ADD (CONSTRAINT FK_DD_TOF_ID FOREIGN KEY (DD_TOF_ID) 
          REFERENCES '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA (DD_TOF_ID) ON DELETE SET NULL)';
          DBMS_OUTPUT.PUT_LINE('OK');      
  END IF;
  DBMS_OUTPUT.PUT_LINE('[FIN CLAVES FORANEAS]');


COMMIT;

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    err_num := SQLCODE;
    err_msg := SQLERRM;
    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    
    ROLLBACK;
    RAISE;          

END;

/

EXIT;
