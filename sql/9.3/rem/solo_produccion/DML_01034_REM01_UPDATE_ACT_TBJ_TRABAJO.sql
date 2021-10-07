--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210909
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10393
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-10393'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    V_COUNT NUMBER(16);

BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    --Comprobamos la existencia del usuario
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE TBJ_NUM_TRABAJO = 9000282438 AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

    IF V_COUNT = 1 THEN

        --Actualizamos el dato
        V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO SET           
        USUARIOBORRAR = '''||V_USUARIO||''',
        FECHABORRAR = SYSDATE,
        BORRADO = 1               
        WHERE TBJ_NUM_TRABAJO = 9000282438';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] TRABAJO 9000282438 BORRADO');
        
    ELSE 

        DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL TRABAJO 9000282438 O YA SE ENCUENTRA BORRADO');

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