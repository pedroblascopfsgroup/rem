--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20151103
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.10-hy-rc01
--## INCIDENCIA_LINK=HR-1272
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar campo "borrado" de la tabla DIC_DICCIONARIOS_EDITABLES
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);
   
BEGIN

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.DIC_DICCIONARIOS_EDITABLES' ||
			  ' SET BORRADO = 1' ||
			  ' WHERE DIC_CODIGO IN (''OC'',''TIN'',''SEC'',''SSC'',''APO'',''TPB'',''TRE'',''SIR'',''48'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando campo borrado de DIC_DICCIONARIOS_EDITABLES');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualización completada.');
    
   COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]');
	
EXCEPTION
     
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT; 
