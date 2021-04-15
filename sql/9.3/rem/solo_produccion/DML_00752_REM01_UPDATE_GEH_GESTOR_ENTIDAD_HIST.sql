--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210311
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9176
--## PRODUCTO=NO
--##
--## Finalidad: Script	cambia gestor de publicaciones
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
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'GEH_GESTOR_ENTIDAD_HIST'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9176'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_USU_ID NUMBER(16);
	V_TGE_ID NUMBER(16);

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR GESTOR DE PUBLICACIONES EN '||V_TEXT_TABLA);

	V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''ext.lsanchis''';
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

	IF V_COUNT = 1 THEN

		V_MSQL:='SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''ext.lsanchis''';
		EXECUTE IMMEDIATE V_MSQL INTO V_USU_ID;

		V_MSQL:='SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GPUBL''';
		EXECUTE IMMEDIATE V_MSQL INTO V_TGE_ID;

		V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1 USING(
					SELECT GEH.GEH_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU
					INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON USU.USU_ID = GEH.USU_ID
					WHERE USU.USU_USERNAME = ''lsanchis'' AND GEH.DD_TGE_ID = '||V_TGE_ID||'
					) T2
				ON (T1.GEH_ID = T2.GEH_ID)
				WHEN MATCHED THEN UPDATE SET 
				T1.USU_ID = '||V_USU_ID||',
				T1.USUARIOMODIFICAR = '''||V_USU||''',
				T1.FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS');
	
	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL USUARIO ''ext.lsanchis''');

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