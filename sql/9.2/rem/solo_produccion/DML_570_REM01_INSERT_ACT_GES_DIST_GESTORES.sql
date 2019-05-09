--/*
--##########################################
--## AUTOR=IKER ADOT
--## FECHA_CREACION=20190426
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6274
--## PRODUCTO=NO
--##
--## Finalidad: Reconfiguraciones varias en gestores formalización Carteras, CJM y LBK
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
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_DD_PRV_CODIGO VARCHAR2(20 CHAR); -- Vble. aux para codigo de provincia
    V_USR VARCHAR2(30 CHAR) := 'HREOS-6274'; -- USUARIOCREAR/USUARIOMODIFICAR.    
    
BEGIN	
	  
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
    --Comprobamos el dato a insertar
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_DESCRIPCION= ''Almería''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: La provincia no existe: ''Almería''');
    
    ELSE       
		V_SQL := 'SELECT DD_PRV_CODIGO FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_DESCRIPCION= ''Almería''';
		EXECUTE IMMEDIATE V_SQL INTO V_DD_PRV_CODIGO;
		
		--DELETE ACT_GES_DIST_GESTORES: TIPO_GESTOR GFORM, PROVINCIAS Y CARTERA            
        V_MSQL := 'DELETE FROM '|| V_ESQUEMA ||'.ACT_GES_DIST_GESTORES ' ||
				  'WHERE TIPO_GESTOR = ''GIAFORM'' AND COD_CARTERA = ''1'' AND COD_PROVINCIA = '''||V_DD_PRV_CODIGO||'''';            
        EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO]: SE HAN BORRADO '|| SQL%ROWCOUNT);
		
		--X INSERT ACT_GES_DIST_GESTORES XXXXX por definir garsa03 por defecto hasta que este Hiposervi
               
        --1 INSERT
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_GES_DIST_GESTORES (' || 
				  'ID, TIPO_GESTOR, COD_CARTERA, COD_PROVINCIA, USERNAME, NOMBRE_USUARIO, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
				  'SELECT '|| V_ESQUEMA ||'.S_ACT_GES_DIST_GESTORES.NEXTVAL, ''GIAFORM'', ''1'', '''||V_DD_PRV_CODIGO||''', ''garsa03''
				  ,(SELECT USU_NOMBRE FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE BORRADO = 0 AND USU_USERNAME = ''garsa03'') , '''||V_USR||''', SYSDATE, 0 FROM DUAL'; 
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO]: SE HAN INSERTADO '|| SQL%ROWCOUNT);
    
    END IF;
    
    --ROLLBACK;
    COMMIT;  
    DBMS_OUTPUT.PUT_LINE('[FIN] ');

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

   
