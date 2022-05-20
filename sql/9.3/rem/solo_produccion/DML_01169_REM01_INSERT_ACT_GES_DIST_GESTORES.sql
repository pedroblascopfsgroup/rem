--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20220520
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11672
--## PRODUCTO=NO
--##
--## Finalidad: Insertar gestor
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
    V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-11672'; -- Usuario modificar
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

  	V_MSQL := '  INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (ID,TIPO_GESTOR,COD_CARTERA,USERNAME,USUARIOCREAR,FECHACREAR)

                VALUES(
                '||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL,
                ''SFORM'',
                1,         
                ''jleandro'',              
                '''||V_USUARIO||''',
                SYSDATE)
                ';
  	
	EXECUTE IMMEDIATE V_MSQL;  

    DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS '|| SQL%ROWCOUNT ||' REGISTROS PARA BFA EN '||V_TEXT_TABLA);

   

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
