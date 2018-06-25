--/*
--##########################################
--## AUTOR=Salva Puertes
--## FECHA_CREACION=20180619
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=HREOS-4196
--## PRODUCTO=NO
--##
--## Finalidad: Insertar los nuevos gestores de liberbank a la tabal GEE_GESTOR_ENTIDAD
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
  V_TABLA VARCHAR2(30 CHAR) := 'GEE_GESTOR_ENTIDAD';  -- Tabla a modificar
  V_TABLA_SEQ VARCHAR2(30 CHAR) := 'S_GEE_GESTOR_ENTIDAD';  -- Tabla a modificar  
  V_USR VARCHAR2(30 CHAR) := 'HREOS-4196'; -- USUARIOCREAR/USUARIOMODIFICAR
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.

  --Array que contiene los registros que se van a actualizar
 TYPE T_CDC is table of VARCHAR2(250); 
  TYPE T_ARRAY_CDC IS TABLE OF T_CDC;
  V_CDC T_ARRAY_CDC := T_ARRAY_CDC(
    T_CDC('GCODI', 'grucodi'),
    T_CDC('GCOINM', 'grucoinm'),
    T_CDC('GCOIN', 'grucoinv')
  );
  V_TMP_CDC T_CDC;

BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INICIO]');
  DBMS_OUTPUT.PUT_LINE('  [INFO] Comienza el proceso de insercion de registros en la tabla '||V_ESQUEMA||'.'||V_TABLA||'...');
  DBMS_OUTPUT.PUT_LINE('  [INFO] Comprobaciones previas...');

  FOR I IN V_CDC.FIRST .. V_CDC.LAST 
    LOOP
      V_TMP_CDC := V_CDC(I);  

	  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' GEE JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_ID = GEE.USU_ID
    JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID  
     WHERE TGE.DD_TGE_CODIGO = '''||V_TMP_CDC(1)||''' AND USU.USU_USERNAME = '''||V_TMP_CDC(2)||''' AND USU.BORRADO = 0 AND TGE.BORRADO = 0 AND GEE.BORRADO = 0';


	  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      IF V_NUM_TABLAS = 0 THEN
      
		  DBMS_OUTPUT.PUT_LINE('  [INFO] Insertando estado gestor '||V_TMP_CDC(2)||'...');
		  V_SQL := '
		  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
			 GEE_ID
			,USU_ID
			,DD_TGE_ID
			,VERSION
			,USUARIOCREAR
			,FECHACREAR
			,BORRADO)
         
			VALUES('||V_ESQUEMA||'.'||V_TABLA_SEQ||'.NEXTVAL
			  , (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME='''||V_TMP_CDC(2)||''' AND BORRADO = 0)
			  , (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO='''||V_TMP_CDC(1)||''' AND BORRADO = 0)
			  , 0
			  , '''||V_USR||'''
			  , SYSDATE
		  , 0)
		';

    EXECUTE IMMEDIATE V_SQL;
    
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