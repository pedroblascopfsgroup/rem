--/*
--##########################################
--## AUTOR=Alfonso Rodriguez
--## FECHA_CREACION=20191108
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-8258
--## PRODUCTO=NO
--##
--## Finalidad: Insertar nuevos datos en nueva tabla DD_TDG_TIPO_DOC_AGR
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
  V_TABLA VARCHAR2(30 CHAR) := 'DD_TDG_TIPO_DOC_AGR';  -- Tabla a modificar
  V_TABLA_SEQ VARCHAR2(30 CHAR) := 'S_DD_TDG_TIPO_DOC_AGR';  -- Tabla a modificar  
  V_USR VARCHAR2(30 CHAR) := 'HREOS-8258'; -- USUARIOCREAR/USUARIOMODIFICAR
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.


BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INICIO]');
  DBMS_OUTPUT.PUT_LINE('  [INFO] Comienza el proceso de insercion de registros en la tabla '||V_ESQUEMA||'.'||V_TABLA||'...');
  DBMS_OUTPUT.PUT_LINE('  [INFO] Comprobaciones previas...');
 

	  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner ='''||V_ESQUEMA||'''';

	  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

      IF V_NUM_TABLAS = 1 THEN
      	--Si no existe se inserta
		  DBMS_OUTPUT.PUT_LINE('  [INFO] Insertando datos...');
		  V_MSQL:= '
		  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
			 DD_TDG_ID
			,DD_TDG_CODIGO
			,DD_TDG_DESCRIPCION
			,DD_TDG_DESCRIPCION_LARGA
			,VERSION
			,USUARIOCREAR
			,FECHACREAR
			,BORRADO
			,USUARIOBORRAR
			,FECHABORRAR
			,DD_TDG_MATRICULA_GD
			)   
			SELECT
			  '||V_ESQUEMA||'.'||V_TABLA_SEQ||'.NEXTVAL as DD_TDG_ID
			  , TDP.DD_TDP_CODIGO AS DD_TDG_CODIGO
			  , TDP.DD_TDP_DESCRIPCION AS DD_TDG_DESCRIPCION
			  , TDP.DD_TDP_DESCRIPCION_LARGA AS DD_TDG_DESCRIPCION_LARGA
			  , 0
			  , '''||V_USR||'''
			  , SYSDATE
		  	  , TDP.BORRADO
		  	  , CASE WHEN TDP.BORRADO = 1 THEN TDP.USUARIOBORRAR END USUARIOBORRAR
		  	  , CASE WHEN TDP.BORRADO = 1 THEN TDP.FECHABORRAR END FECHABORRAR
		  	  , TDP.DD_TDP_MATRICULA_GD AS DD_TDG_MATRICULA_GD
			FROM '||V_ESQUEMA||'.DD_TDP_TIPO_DOC_PRO TDP
			WHERE NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA||' AGR WHERE AGR.DD_TDG_MATRICULA_GD = TDP.DD_TDP_MATRICULA_GD)';
			DBMS_OUTPUT.PUT_LINE(V_MSQL);
			EXECUTE IMMEDIATE V_MSQL;
	END IF;	
        
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


