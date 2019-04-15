--/*
--##########################################
--## AUTOR=Dean Ibañez
--## FECHA_CREACION=#YYYYMMDD#
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=#VERSION_ARTEFACTO#
--## INCIDENCIA_LINK=RECOVERY-13474
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar los procedimientos solicitados a su última versión
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET TIMING ON
SET LINESIZE 2000
SET VERIFY OFF
SET TIMING ON
SET FEEDBACK ON


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_CODIGO_BPM VARCHAR2(4000 CHAR):= '#CODIGO_BPM#';
    CODIGO_TPO VARCHAR2(4000 CHAR);

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ... LLamada Tramite_a_ultima_version');

	V_SQL:= 'select dd_tpo_codigo from '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO where dd_tpo_xml_jbpm='''||V_CODIGO_BPM||'''';
	EXECUTE IMMEDIATE V_SQL INTO CODIGO_TPO;

	DBMS_OUTPUT.PUT_LINE('Ejecución del trámite a última versión ');

	V_MSQL := 'call '||V_ESQUEMA||'.tramite_a_ultima_version('''||CODIGO_TPO||''')';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[FIN] '|| sql%rowcount ||' registros actualizados'); 

	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'todos los DATOS actualizados');
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
