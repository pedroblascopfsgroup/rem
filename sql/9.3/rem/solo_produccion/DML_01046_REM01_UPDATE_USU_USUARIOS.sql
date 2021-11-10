--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20210925
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10490
--## PRODUCTO=NO
--##
--## Finalidad: Script modificar usuarios
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
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'USU_USUARIOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10490'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL:= 'MERGE INTO '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' T1 USING(
				SELECT
					 AUX.USERNAME_JUP AS USERNAME_JUP
					,AUX.USU_APELLIDO1_JUP AS USU_NOMBRE_JUP
					,AUX.USU_APELLIDO2_JUP AS USU_APELLIDO1_JUP
					,AUX.USU_MAIL_JUP AS USU_APELLIDO2_JUP
					,AUX.DISTINTO_NOMBRE AS USU_MAIL_JUP
				FROM '||V_ESQUEMA||'.AUX_REMVIP_10490 AUX         
			)T2 ON (T1.USU_USERNAME = T2.USERNAME_JUP AND (T2.USU_NOMBRE_JUP<>T1.USU_NOMBRE
															OR T2.USU_APELLIDO1_JUP<>T1.USU_APELLIDO1
															OR T2.USU_APELLIDO2_JUP<>T1.USU_APELLIDO2
															OR T2.USU_MAIL_JUP<>T1.USU_MAIL) )
			WHEN MATCHED THEN 
			UPDATE SET T1.USU_NOMBRE = T2.USU_NOMBRE_JUP,
					T1.USU_APELLIDO1 = T2.USU_APELLIDO1_JUP,
					T1.USU_APELLIDO2 = T2.USU_APELLIDO2_JUP,
					T1.USU_MAIL = T2.USU_MAIL_JUP,
					T1.USUARIOMODIFICAR = '''||V_USU||''',
					T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '||SQL%ROWCOUNT||' LOS USUARIOS');
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