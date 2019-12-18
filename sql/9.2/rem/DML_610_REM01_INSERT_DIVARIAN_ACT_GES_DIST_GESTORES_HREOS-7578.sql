--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20190919
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7578
--## PRODUCTO=NO
--##
--## Finalidad: Script que replica los valores de la cartera Apple para la cartera Divarian en la tabla ACT_GES_DIST_GESTORES.
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
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

BEGIN   
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
           
    DBMS_OUTPUT.PUT_LINE('[INFO]: COMIENZA PROCESO DE REPLICAR DATOS DE APPLE PARA DIVARIAN EN LA TABLA: ' ||V_TEXT_TABLA);
 
    V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES (ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO,
			 COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO,
 			 VERSION, USUARIOCREAR, FECHACREAR, BORRADO, COD_SUBCARTERA)
 			 SELECT '||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL, DIST.TIPO_GESTOR, DIST.COD_CARTERA, DIST.COD_ESTADO_ACTIVO,
 			 DIST.COD_TIPO_COMERZIALZACION, DIST.COD_PROVINCIA, DIST.COD_MUNICIPIO, DIST.COD_POSTAL, DIST.USERNAME, DIST.NOMBRE_USUARIO,
			 0, ''HREOS-7578'', SYSDATE, 0, ''150'' FROM '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES DIST WHERE DIST.COD_SUBCARTERA = ''138'' AND DIST.BORRADO = 0';
    
	EXECUTE IMMEDIATE V_SQL;
			 
	DBMS_OUTPUT.PUT_LINE('[FIN] FINALIZADO EL PROCESO DE REPLICA DE GESTORES DE APPLE PARA DIVARIAN');
    COMMIT;
   

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
