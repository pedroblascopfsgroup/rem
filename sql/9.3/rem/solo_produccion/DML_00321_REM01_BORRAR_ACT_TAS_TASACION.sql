--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200602
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-7387
--## PRODUCTO=NO
--##
--## Finalidad: Borrar tasaciones
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
    V_USUARIOMODIFICAR VARCHAR2(25 CHAR):= 'REMVIP-7387'; -- Configuracion Esquema

BEGIN	        

    DBMS_OUTPUT.PUT_LINE('[INICIO] ');


    DBMS_OUTPUT.PUT_LINE('[INFO]: Borrar tasaciones incorrectas' );

                V_MSQL := ' 	
			UPDATE '||V_ESQUEMA||'.ACT_TAS_TASACION
			SET BORRADO = 1,
			USUARIOBORRAR = '''||V_USUARIOMODIFICAR|| ''',
			FECHABORRAR = SYSDATE
			WHERE TAS_ID IN
			(
			874236,
			874230,
			874821,
			875056,
			874843,
			874744,
			874235,
			874302,
			874306,
			874317,
			874323,
			874785,
			874640,
			874718,
			874969,
			874782,
			875089,
			874854,
			874983,
			874303,
			874315,
			874308,
			874326,
			874798,
			875020,
			875096,
			874318,
			874327,
			875190,
			875042,
			874322,
			874320,
			874314,
			874325,
			874304,
			874301,
			874305
			)';

	EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: Borrados ' || SQL%ROWCOUNT || ' registros de ACT_TAS_TASACION ' );

--*******************************************************************************************************************************

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: PEF_PERFILES ACTUALIZADO CORRECTAMENTE ');


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
