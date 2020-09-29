--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200922
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11217
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar instrucciones
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONFIG_PTDAS_PREP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');


	-- LOOP para insertar los valores --
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);

	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO]: No exista la tabla');
	ELSE

				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
							CPP_PTDAS_ID
							, CPP_PARTIDA_PRESUPUESTARIA
							, DD_TGA_ID
							, DD_STG_ID
							, DD_CRA_ID
							, PRO_ID
							, EJE_ID
							, CPP_ARRENDAMIENTO
							, USUARIOCREAR
							, FECHACREAR
							, CPP_PRINCIPAL
							, DD_TBE_ID
							, CPP_APARTADO
							, CPP_CAPITULO
							, CPP_ACTIVABLE
							, CPP_PLAN_VISITAS
							, DD_TCH_ID
							) 
							SELECT 
								'||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL CPP_PTDAS_ID
								, CPP.CPP_PARTIDA_PRESUPUESTARIA
								, CPP.DD_TGA_ID
								, CPP.DD_STG_ID
								, CPP.DD_CRA_ID
								, CPP.PRO_ID
								, CPP.EJE_ID
								, 1 CPP_ARRENDAMIENTO
								, ''HREOS-11217'' USUARIOCREAR
								, SYSDATE FECHACREAR
								, CPP.CPP_PRINCIPAL
								, CPP.DD_TBE_ID
								, CPP.CPP_APARTADO
								, CPP.CPP_CAPITULO
								, CPP.CPP_ACTIVABLE
								, CPP.CPP_PLAN_VISITAS
								, CPP.DD_TCH_ID
							FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CPP
								WHERE CPP.USUARIOCREAR = ''HREOS-11217''';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado '|| SQL%ROWCOUNT);
	END IF;
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

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
