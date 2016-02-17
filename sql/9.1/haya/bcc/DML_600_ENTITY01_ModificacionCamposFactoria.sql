/*
--##########################################
--## AUTOR=Oscar Dorado
--## FECHA_CREACION=20160216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-766
--## PRODUCTO=NO
--##
--## Finalidad: BPM - Trámite de envío de demanda
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
  
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('De 306 a 433 - R_ATO_REQ_PGS');
    V_MSQL := 'update '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION set dd_tr_id = ''433'', usuariomodificar = ''PRODUCTO-766'', fechamodificar=sysdate where dd_tr_codigo = ''R_ATO_REQ_PGS''';
    
    DBMS_OUTPUT.PUT_LINE('De 292 a 434 - R_SOL_NOT_EMB');
    V_MSQL := 'update '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION set dd_tr_id = ''434'', usuariomodificar = ''PRODUCTO-784'', fechamodificar=sysdate where dd_tr_codigo = ''R_SOL_NOT_EMB''';

    DBMS_OUTPUT.PUT_LINE('De 293 a 435 - R_RSP_EMP_EMB');
    V_MSQL := 'update '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION set dd_tr_id = ''435'', usuariomodificar = ''PRODUCTO-784'', fechamodificar=sysdate where dd_tr_codigo = ''R_RSP_EMP_EMB''';
    
    DBMS_OUTPUT.PUT_LINE('De 294 a 436 - R_ACU_ENT_CNT');
    V_MSQL := 'update '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION set dd_tr_id = ''436'', usuariomodificar = ''PRODUCTO-784'', fechamodificar=sysdate where dd_tr_codigo = ''R_ACU_ENT_CNT''';
    
	
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campos');

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
