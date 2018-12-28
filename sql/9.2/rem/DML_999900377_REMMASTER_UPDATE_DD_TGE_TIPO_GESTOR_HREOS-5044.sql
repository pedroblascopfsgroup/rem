--/*
--##########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=20181229
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5044
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar los gestores y supervisores del Trámite de GENCAT
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
    V_TABLA VARCHAR2(2400 CHAR):= 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU_MODIFICAR VARCHAR2(1024 CHAR):= 'HREOS-5044';
    
    
BEGIN

		DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de '||V_TABLA);

        DBMS_OUTPUT.PUT_LINE('[INFO] Comprobaciones previas.......');
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE TAP_CODIGO = ''T016_ProcesoAdecuacion'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS > 0 THEN

		    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
                        SET DD_TGE_ID = (SELECT DD_TGE_ID 
                                         FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR 
                                         WHERE DD_TGE_CODIGO = ''GACT''),
                        DD_TSUP_ID = (SELECT DD_TGE_ID
                                      FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR 
                                      WHERE DD_TGE_CODIGO = ''SUPACT''),
                        USUARIOMODIFICAR = '''||V_USU_MODIFICAR||''', 
                        FECHAMODIFICAR = SYSDATE 
                        WHERE TAP_CODIGO = ''T016_ProcesoAdecuacion'' ';

			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando tarea T016_ProcesoAdecuacion.......');
		    DBMS_OUTPUT.PUT_LINE(V_MSQL);
		    EXECUTE IMMEDIATE V_MSQL;
		
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] No se ha encontrado la tarea T016_ProcesoAdecuacion.......');

		END IF;


        DBMS_OUTPUT.PUT_LINE('[INFO] Comprobaciones previas.......');
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE TAP_CODIGO = ''T016_ComunicarGENCAT'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS > 0 THEN

		    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
                        SET DD_TGE_ID = (SELECT DD_TGE_ID 
                                         FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR 
                                         WHERE DD_TGE_CODIGO = ''GFORM''),
                        DD_TSUP_ID = (SELECT DD_TGE_ID
                                      FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR 
                                      WHERE DD_TGE_CODIGO = ''SFORM''),
                        USUARIOMODIFICAR = '''||V_USU_MODIFICAR||''', 
                        FECHAMODIFICAR = SYSDATE 
                        WHERE TAP_CODIGO = ''T016_ComunicarGENCAT'' ';

			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando tarea T016_ComunicarGENCAT.......');
		    DBMS_OUTPUT.PUT_LINE(V_MSQL);
		    EXECUTE IMMEDIATE V_MSQL;
		
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] No se ha encontrado la tarea T016_ComunicarGENCAT.......');

		END IF;
    
		
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