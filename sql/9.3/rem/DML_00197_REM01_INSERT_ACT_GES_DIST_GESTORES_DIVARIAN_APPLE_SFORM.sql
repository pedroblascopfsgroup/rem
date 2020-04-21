--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200413
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6956
--## PRODUCTO=NO
--##
--## Finalidad: Insertar SFORM Divarian
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_COUNT NUMBER(16):= 0;
    V_ID NUMBER(16);
    V_DD_PRV_CODIGO VARCHAR2(20 CHAR); -- Vble. aux para codigo de provincia
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-6956'; -- USUARIOCREAR/USUARIOMODIFICAR.
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	--DELETE ACT_GES_DIST_GESTORES: TIPO_GESTOR SFORM, PROVINCIAS Y CARTERA            
	V_MSQL := 'DELETE FROM '|| V_ESQUEMA ||'.ACT_GES_DIST_GESTORES ' ||
	  'WHERE TIPO_GESTOR = ''SFORM'' AND COD_CARTERA = ''7'' AND COD_SUBCARTERA IN (''151'', ''152'', ''138'')';            
	EXECUTE IMMEDIATE V_MSQL;           

	--1 INSERT ACT_GES_DIST_GESTORES
	V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_GES_DIST_GESTORES (' || 
	  'ID, TIPO_GESTOR, COD_CARTERA, USERNAME, NOMBRE_USUARIO, USUARIOCREAR, FECHACREAR, BORRADO, COD_SUBCARTERA) ' ||
	  'SELECT '|| V_ESQUEMA ||'.S_ACT_GES_DIST_GESTORES.NEXTVAL, ''SFORM'', ''7'', ''nesteban''
	  ,(SELECT USU_NOMBRE FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = ''nesteban'') , '''||V_USR||''', SYSDATE, 0, ''151'' FROM DUAL'; 
	EXECUTE IMMEDIATE V_MSQL;

	--1 INSERT ACT_GES_DIST_GESTORES
	V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_GES_DIST_GESTORES (' || 
	  'ID, TIPO_GESTOR, COD_CARTERA, USERNAME, NOMBRE_USUARIO, USUARIOCREAR, FECHACREAR, BORRADO, COD_SUBCARTERA) ' ||
	  'SELECT '|| V_ESQUEMA ||'.S_ACT_GES_DIST_GESTORES.NEXTVAL, ''SFORM'', ''7'', ''nesteban''
	  ,(SELECT USU_NOMBRE FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = ''nesteban'') , '''||V_USR||''', SYSDATE, 0, ''152'' FROM DUAL'; 
	EXECUTE IMMEDIATE V_MSQL;
	
	--1 INSERT ACT_GES_DIST_GESTORES
	V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_GES_DIST_GESTORES (' || 
	  'ID, TIPO_GESTOR, COD_CARTERA, USERNAME, NOMBRE_USUARIO, USUARIOCREAR, FECHACREAR, BORRADO, COD_SUBCARTERA) ' ||
	  'SELECT '|| V_ESQUEMA ||'.S_ACT_GES_DIST_GESTORES.NEXTVAL, ''SFORM'', ''7'', ''nesteban''
	  ,(SELECT USU_NOMBRE FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = ''nesteban'') , '''||V_USR||''', SYSDATE, 0, ''138'' FROM DUAL'; 
	EXECUTE IMMEDIATE V_MSQL;
	
	V_COUNT := V_COUNT + 3;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: SE HAN INSERTADO '|| V_COUNT ||' REGISTROS');
    
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
EXIT;