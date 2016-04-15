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
	
	    
    DBMS_OUTPUT.PUT_LINE('Id 387 se le cambia la resolución de "Decreto adjudicación" a "Notificación decreto adjudicación al contrario" - R_TR_ADJ_DEC_ADJ_CON');
    V_MSQL := 'update '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION set dd_tr_descripcion = ''Notificación decreto adjudicación al contrario'', dd_tr_descripcion_larga = ''Notificación decreto adjudicación al contrario'', usuariomodificar = ''PRODUCTO-1047'', fechamodificar=sysdate where dd_tr_codigo = ''R_TR_ADJ_DEC_ADJ_CON''';
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('Id 346 se le cambia la resolución de "Diligencia de precinto" a "Documento realización efectiva precinto (Precinto)" - R_DLG_FCH_PRE');
    V_MSQL := 'update '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION set dd_tr_descripcion = ''Documento realización efectiva precinto (Precinto)'', dd_tr_descripcion_larga = ''Documento realización efectiva precinto (Precinto)'', usuariomodificar = ''PRODUCTO-1153'', fechamodificar=sysdate where dd_tr_codigo = ''R_DLG_FCH_PRE''';
    EXECUTE IMMEDIATE V_MSQL;
    
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
