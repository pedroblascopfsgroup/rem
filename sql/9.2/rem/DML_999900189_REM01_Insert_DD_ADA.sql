--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20180312
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=HREOS-3890
--## PRODUCTO=NO
--##
--## Finalidad: Insertar nuevos datos en nueva tabla DD_ADA_ADECUACION_ALQUILER
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
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
  V_NUM_COLUMNAS NUMBER(16); -- Vble. para validar la existencia de una columna.     
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_TABLA VARCHAR2(30 CHAR) := 'DD_ADA_ADECUACION_ALQUILER';  -- Tabla a modificar
  V_TABLA_SEQ VARCHAR2(30 CHAR) := 'S_DD_ADA_ADECUACION_ALQUILER';  -- Tabla a modificar  
  V_USR VARCHAR2(30 CHAR) := 'HREOS-3890'; -- USUARIOCREAR/USUARIOMODIFICAR
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.

  --Array que contiene los registros que se van a actualizar
  TYPE T_CDC is table of VARCHAR2(250); 
  TYPE T_ARRAY_CDC IS TABLE OF T_CDC;
  V_CDC T_ARRAY_CDC := T_ARRAY_CDC(
    T_CDC('01', 'Si','Si'),
    T_CDC('02', 'No','No'),
    T_CDC('03', 'N/A','No aplica')
  );
  V_TMP_CDC T_CDC;

BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INICIO]');
  DBMS_OUTPUT.PUT_LINE('  [INFO] Comienza el proceso de insercion de registros en la tabla '||V_ESQUEMA||'.'||V_TABLA||'...');
  DBMS_OUTPUT.PUT_LINE('  [INFO] Comprobaciones previas...');


    FOR I IN V_CDC.FIRST .. V_CDC.LAST 
    LOOP
      V_TMP_CDC := V_CDC(I);  

	  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_ADA_CODIGO = '''||TRIM(V_TMP_CDC(1))||''' AND BORRADO = 0';
	  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
     
      IF V_NUM_TABLAS = 0 THEN
      
		  DBMS_OUTPUT.PUT_LINE('  [INFO] Insertando estado '||V_TMP_CDC(2)||'...');
		  EXECUTE IMMEDIATE '
		  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
			 DD_ADA_ID
			,DD_ADA_CODIGO
			,DD_ADA_DESCRIPCION
			,DD_ADA_DESCRIPCION_LARGA
			,VERSION
			,USUARIOCREAR
			,FECHACREAR
			,BORRADO
			)   
			SELECT
			  '||V_ESQUEMA||'.'||V_TABLA_SEQ||'.NEXTVAL
			  , '''||V_TMP_CDC(1)||'''
			  , '''||V_TMP_CDC(2)||'''
			  , '''||V_TMP_CDC(3)||'''
			  , 0
			  , '''||V_USR||'''
			  , SYSDATE
		  	  , 0
			FROM DUAL
		'
		;
	END IF;	
  END LOOP;
        
  COMMIT;
      
  DBMS_OUTPUT.PUT_LINE('[FIN]');    

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT


