--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20160211
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.16-hr-rc04
--## INCIDENCIA_LINK=HR-1920
--## PRODUCTO=NO
--##
--## Finalidad: Se borran registros duplicados en BIE_ADJ_ADJUDICACION
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
SET LINESIZE 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TABLENAME1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN	

    V_TABLENAME1 := V_ESQUEMA || '.BIE_ADJ_ADJUDICACION';
    DBMS_OUTPUT.PUT_LINE('[INICIO] Borrado físico en '||V_TABLENAME1 || '.');

	V_MSQL := 'DELETE ' || V_TABLENAME1 || ' WHERE BIE_ADJ_ID IN (
		SELECT BIE_ADJ_ID FROM (
          SELECT BIE_ADJ_ID, ROW_NUMBER() OVER (PARTITION BY BIE_ID ORDER BY BIE_ADJ_ID DESC) ORD
          FROM ' || V_TABLENAME1 || '
        ) WHERE ORD > 1)';
	EXECUTE IMMEDIATE V_MSQL; 
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_MSQL, 1, 60), 60, ' ') || '... registros afectados: ' || sql%rowcount);
    DBMS_OUTPUT.PUT_LINE('[FIN] Borrado físico en '||V_TABLENAME1 || '.');

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
EXIT
