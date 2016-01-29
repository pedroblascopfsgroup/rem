--/*
--##########################################
--## AUTOR=Carlos Perez
--## FECHA_CREACION=20151110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.4-cj-rc14
--## INCIDENCIA_LINK=--
--## PRODUCTO=NO
--##
--## Finalidad: Quitar el borrado lógico de dos campos de la rule definition
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE

	/*
    * CONFIGURACION: ESQUEMAS
    *---------------------------------------------------------------------
    */
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[START] QUITAR BORRADO LOGICO CAMPOS SCORING - DD_RULE_DEFINITION');
	
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_RULE_DEFINITION SET BORRADO = 0, USUARIOBORRAR = NULL, FECHABORRAR=NULL WHERE RD_COLUMN = ''pto_intervalo''';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_RULE_DEFINITION SET BORRADO = 0, USUARIOBORRAR = NULL, FECHABORRAR=NULL WHERE RD_COLUMN = ''pto_puntuacion''';
	    
   COMMIT;
    DBMS_OUTPUT.PUT_LINE('[COMMIT ALL]...............................................');
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');
	
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
