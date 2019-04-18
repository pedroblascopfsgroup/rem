--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190402
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3654
--## PRODUCTO=NO
--##
--## Finalidad: Actualización de ACT_ACTIVO.ACT_RECOVERY_ID
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
	
           
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN ACT_ACTIVO] ');
         

    V_MSQL := ' UPDATE '||V_ESQUEMA||'.ACT_ACTIVO
		SET ACT_RECOVERY_ID = ACT_RECOVERY_ID * (-1),
		USUARIOMODIFICAR = ''REMVIP-3654'',
		FECHAMODIFICAR = SYSDATE
		WHERE ACT_NUM_ACTIVO IN 
		(

			99990010,
			99985847,
			99990053,
			99997779,
			99992957,
			99990009,
			99998228,
			99993362,
			99989967,
			99989966,
			99985846,
			99992958,
			99993609,
			99990272,
			99993270,
			99993269,
			99997677,
			99997678,
			99993271,
			99989968,
			99990054,
			99992956

		)';

	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('ACTUALIZADOS '||sql%rowcount||' ACTIVOS ');
          
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_ESQUEMA||'.ACT_ACTIVO ');   

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


