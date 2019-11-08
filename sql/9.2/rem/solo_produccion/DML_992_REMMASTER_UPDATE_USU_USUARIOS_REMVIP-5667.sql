--/*
--##########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20191107
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5667
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica el usuario de la incidencia.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error

    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_PERFIL IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;

BEGIN	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.USU_USUARIOS... Buscando datos en la tabla');
    
    V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_NOMBRE LIKE ''%CASER ASISTENCIA_ACIERTA%''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 1 THEN		
    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.USU_USUARIOS... usuario encontrado');
          
        V_SQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS 
											SET USU_NOMBRE = ''CASER ASISTENCIA_ACIERTA'',
											USUARIOMODIFICAR = ''REMVIP-5667'',
											FECHAMODIFICAR = SYSDATE
										WHERE USU_NOMBRE LIKE ''%CASER ASISTENCIA_ACIERTA%''';
        EXECUTE IMMEDIATE V_SQL;

	ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.USU_USUARIOS... usuario NO encontrado');

	END IF;

	DBMS_OUTPUT.PUT_LINE('[INFO] Datos modificados correctamente.');				
	COMMIT;

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
