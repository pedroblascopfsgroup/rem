--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20191216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5901
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el propietario de un activo
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
    V_NUM_REGISTRO NUMBER(16); -- Vble. para validar la existencia de un registro. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
BEGIN	
	
      DBMS_OUTPUT.PUT_LINE('[INICIO] ');

      V_MSQL := '

UPDATE '|| V_ESQUEMA ||'.ACT_ASI_HAYA
SET ACT_NUM_ACTIVO = ( 
                       SELECT ACT_NUM_ACTIVO 
                       FROM '|| V_ESQUEMA ||'.ACT_ACTIVO 
                       WHERE ACT_ACTIVO.ACT_NUM_ACTIVO_UVEM = ACT_ASI_HAYA.ACT_NUM_ACTIVO_UVEM 
                       AND ACT_ACTIVO.BORRADO = 0 
                      ),
    USUARIOMODIFICAR = ''REMVIP-5901'',
    FECHAMODIFICAR   = SYSDATE
WHERE ACT_NUM_ACTIVO_UVEM IN
(

17681786,
20291938,
12819869,
18308070,
18308187,
18308439,
18308673,
18308790,
18312746,
28925601,
30105009,
30105612,
29193460

)
 ' ;
      EXECUTE IMMEDIATE V_MSQL;

     DBMS_OUTPUT.PUT_LINE('[FIN]: SE HAN ACTUALIZADO '||SQL%ROWCOUNT||' REGISTROS EN ACT_ASI_HAYA ');

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
