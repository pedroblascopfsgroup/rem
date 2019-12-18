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

      V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO
		 SET PRO_ID = ( SELECT PRO_ID FROM '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = ''A05168646'' AND BORRADO = 0 )
		 WHERE 1 = 1
		 AND ACT_ID = (
				SELECT ACT.ACT_ID
				FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
				WHERE 1 = 1
				AND ACT_NUM_ACTIVO = ''5969608''
			      ) ' ;
      EXECUTE IMMEDIATE V_MSQL;

     DBMS_OUTPUT.PUT_LINE('[FIN]: SE HAN ACTUALIZADO '||SQL%ROWCOUNT||' REGISTROS EN ACT_PAC_PROPIETARIO_ACTIVO ');

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
