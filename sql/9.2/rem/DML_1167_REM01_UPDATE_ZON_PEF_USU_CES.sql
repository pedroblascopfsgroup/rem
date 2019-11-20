--/*
--##########################################
--## AUTOR=Vicente Martinez
--## FECHA_CREACION=20190801
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7253
--## PRODUCTO=NO
--##
--## Finalidad: Quita usuario consulta 
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_ID_USUARIO VARCHAR2(4000 CHAR); -- Vble. para consulta del usuario al que quitarle el perfil
    V_ID_PERFIL NUMBER(16); -- Vble. para buscar e id del perfil a remover
    V_NUM_PERFILES NUMBER(16); -- Vble. para buscar si el usuario tiene el perfil 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;
    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    				--USUARIO
		T_TFI('ext.gcalnan'),
		T_TFI('ext.crenilla'),
		T_TFI('ext.ibastosmendes'),
		T_TFI('ext.jperezb'),
		T_TFI('ext.drubio'),
		T_TFI('ext.bcunningham'),
		T_TFI('ext.mkelly')

		);
    V_TMP_T_TFI T_TFI;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Iniciamos borrado de perfiles');

	V_MSQL := 'SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYACONSU''';
	--DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_MSQL INTO V_ID_PERFIL;

	-- Bucle INSERT tfi_tareas_form_items
	FOR I IN V_TFI.FIRST .. V_TFI.LAST
	LOOP

		V_TMP_T_TFI := V_TFI(I);

		V_MSQL := 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_T_TFI(1)||'''';

		EXECUTE IMMEDIATE V_MSQL INTO V_ID_USUARIO;

		V_MSQL := 'SELECT COUNT(1) FROM ZON_PEF_USU WHERE USU_ID = '||V_ID_USUARIO||' AND PEF_ID = '||V_ID_PERFIL||'';

		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_PERFILES;

		IF V_NUM_PERFILES > 0 THEN

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ZON_PEF_USU SET
						    USUARIOBORRAR = ''HREOS-7253''
						    ,FECHABORRAR = SYSDATE
						    ,BORRADO = 1
						WHERE USU_ID = '||V_ID_USUARIO||' AND PEF_ID = '||V_ID_PERFIL||'';

			EXECUTE IMMEDIATE V_MSQL;

		END IF;
		
		EXECUTE IMMEDIATE V_MSQL;
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('[COMMIT] Commit realizado');
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Filas borradas correctamente.');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;