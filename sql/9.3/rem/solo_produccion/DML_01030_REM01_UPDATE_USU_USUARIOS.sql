--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210903
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10402
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-10402'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    V_COUNT NUMBER(16);

BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    --Comprobamos la existencia del usuario
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''ext.lgarrido''';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

    IF V_COUNT = 1 THEN

        --Actualizamos el dato
        V_MSQL:= 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS SET           
        USU_MAIL = ''ext.lgarrido@externos.haya.es'',
        USUARIOMODIFICAR = '''||V_USUARIO||''',
        FECHAMODIFICAR = SYSDATE               
        WHERE USU_USERNAME = ''ext.lgarrido''';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] USUARIO ext.lgarrido ACTUALIZADO');
        
    ELSE 

        DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL USUARIO ext.lgarrido');

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