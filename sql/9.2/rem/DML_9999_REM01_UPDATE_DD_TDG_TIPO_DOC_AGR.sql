--/*
--##########################################
--## AUTOR=Sergio Salt
--## FECHA_CREACION=20191106
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-8196
--## PRODUCTO=NO
--##
--## Finalidad: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NOMBRE_TABLA VARCHAR2(1024 CHAR):= 'DD_TDG_TIPO_DOC_AGR';  --Vble para el nombre de la tabla
    V_NOMBRE_COLUMNA VARCHAR2(1024 CHAR):= 'DD_TDG_MATRICULA_GD';
    V_HREOS VARCHAR2(100 CHAR) := '''HREOS-8196''';
    REGEX VARCHAR2(100 CHAR) := '''(\w*)-(\w*)-(\w*)-(\w*)''';
BEGIN	

  -- Verificar si la tabla ya existe
  V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_NOMBRE_TABLA||''' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 

IF V_NUM_TABLAS > 0 THEN
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_NOMBRE_TABLA||'
   SET '||V_NOMBRE_COLUMNA||' = REGEXP_SUBSTR('||V_NOMBRE_COLUMNA||','||REGEX||'), USUARIOMODIFICAR ='|| V_HREOS ||' ,FECHAMODIFICAR = SYSDATE';
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_NOMBRE_TABLA||' COLUMNA '||V_NOMBRE_COLUMNA||' ACTUALIZADA CORRECTAMENTE ');
ELSE 
  DBMS_OUTPUT.PUT_LINE('NO EXISTE LA TABLA ' || V_NOMBRE_TABLA);
END IF;

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
