--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20211026
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16043
--## PRODUCTO=NO
--##
--## Finalidad: Insertar gestores a la cartera Titulizadas
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-16043'; -- Usuario modificar

    V_TGE VARCHAR2(25 CHAR):= 'GCOM'; -- Usuario modificar
    V_USERNAME VARCHAR2(25 CHAR):= 'msanchezf'; -- Usuario modificar

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

  	V_MSQL := '  INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
      (ID,TIPO_GESTOR,COD_CARTERA,COD_ESTADO_ACTIVO,COD_TIPO_COMERZIALZACION,COD_PROVINCIA,
        COD_MUNICIPIO,COD_POSTAL,USERNAME,NOMBRE_USUARIO,COD_SUBCARTERA,TIPO_ACTIVO,SUBTIPO_ACTIVO,
        TIPO_ALQUILER,USUARIOCREAR,FECHACREAR)
                SELECT '||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL as ID,
                ges1.TIPO_GESTOR,
                18 as COD_CARTERA,
                ges1.COD_ESTADO_ACTIVO,
                ges1.COD_TIPO_COMERZIALZACION,
                ges1.COD_PROVINCIA,
                ges1.COD_MUNICIPIO,
                ges1.COD_POSTAL,
                ges1.USERNAME,
                ges1.NOMBRE_USUARIO,
                NULL as COD_SUBCARTERA, 
                ges1.TIPO_ACTIVO,
                ges1.SUBTIPO_ACTIVO,
                ges1.TIPO_ALQUILER,
                '''||V_USUARIO||''' as USUARIOCREAR,
                SYSDATE as FECHACREAR
                FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ges1
                WHERE COD_CARTERA = 3 AND (COD_SUBCARTERA IS NULL OR COD_SUBCARTERA = 9)
                AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ges2
                WHERE ges2.TIPO_GESTOR = ges1.TIPO_GESTOR
					AND ges2.COD_CARTERA = 18                  
					AND ges2.USERNAME = ges1.USERNAME)';
  	
	EXECUTE IMMEDIATE V_MSQL; 

    DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS '|| SQL%ROWCOUNT ||' REGISTROS PARA Titulizada EN '||V_TEXT_TABLA);

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET 
                USERNAME = '''||V_USERNAME||''',
                NOMBRE_USUARIO = (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 
                FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||V_USERNAME||''')
                WHERE TIPO_GESTOR = '''||V_TGE||''' AND COD_CARTERA = 18 AND BORRADO = 0';
  	
	EXECUTE IMMEDIATE V_MSQL; 

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS PARA Titulizada '''||V_TGE||''' - '''||V_USERNAME||''' EN '||V_TEXT_TABLA);

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
