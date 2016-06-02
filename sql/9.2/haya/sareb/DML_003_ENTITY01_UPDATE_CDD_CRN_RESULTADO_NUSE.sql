--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20160224
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.1
--## INCIDENCIA_LINK=BKREC-1814
--## PRODUCTO=NO
--##
--## Finalidad: Se updatea correctamente la fecha de extracción y de resultado de NUSE
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION CDD_CRN_RESULTADO_NUSE');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.CDD_CRN_RESULTADO_NUSE
		SET CRN_FECHA_EXTRACCION   = add_months(CRN_FECHA_EXTRACCION, ((TO_CHAR(CRN_FECHA_EXTRACCION, ''YY'') - TO_CHAR(CRN_FECHA_EXTRACCION, ''hh24''))*(-12))),
  			CRN_FECHA_RESULT         = add_months(CRN_FECHA_RESULT, ((TO_CHAR(CRN_FECHA_RESULT, ''YY'')         - TO_CHAR(CRN_FECHA_RESULT, ''hh24''))*(-12))),
  			USUARIOMODIFICAR         = ''BKREC-1814'',
  			FECHAMODIFICAR           = SYSDATE
			WHERE CRN_FECHA_EXTRACCION > SYSDATE';
	
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[FIN] CDD_CRN_RESULTADO_NUSE  actualizado');
	
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