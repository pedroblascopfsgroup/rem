--/*
--##########################################
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20200226
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9584
--## PRODUCTO=NO
--##
--## Finalidad: Script para borrar registros de la DD_COS_COMITES_SANCION e insertar nuevos.
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TABLA VARCHAR2(30 CHAR) := 'DD_COS_COMITES_SANCION';  -- Tabla a modificar
    V_USR VARCHAR2(30 CHAR) := 'HREOS-9584'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN
  
  V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||''' ';

  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
  
  IF V_NUM_TABLAS = 1 THEN
  
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' COS WHERE COS.DD_COS_DESCRIPCION = ''Divarian'' AND COS.DD_COS_DESCRIPCION_LARGA = ''Divarian''
			AND COS.DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07'')
			AND COS.DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''151'')';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      
      IF V_NUM_TABLAS <= 0 THEN
        	EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (DD_COS_ID, DD_COS_CODIGO, DD_COS_DESCRIPCION, DD_COS_DESCRIPCION_LARGA, DD_CRA_ID, USUARIOCREAR, FECHACREAR, DD_SCR_ID)
					VALUES(S_'||V_TABLA||'.NEXTVAL, ''46'', ''Divarian'', ''Divarian'', (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07''), '''||V_USR||''', SYSDATE, (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''151''))';

      END IF;

    COMMIT;
    
  ELSE

    DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_ESQUEMA||'.'||V_TABLA||'... No existe.');

  END IF;   

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

