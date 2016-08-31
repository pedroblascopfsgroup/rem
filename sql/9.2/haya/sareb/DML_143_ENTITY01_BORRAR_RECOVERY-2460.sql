--/*
--##########################################
--## AUTOR=RUBEN ROVIRA
--## FECHA_CREACION=20160714
--## ARTEFACTO=BATCH
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-2460
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar
     
BEGIN
    
    ----------------------------------
    --  DD_DFI_DECISION_FINALIZAR   --
    ----------------------------------
    
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR (DD_DFI_ID,DD_DFI_CODIGO,DD_DFI_DESCRIPCION,DD_DFI_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) 
		select S_DD_DFI_DECISION_FINALIZAR.NEXTVAL,''CONEX'',''Concurso exprés'',''Concurso exprés'',0,''RECOVERY-2460'',sysdate,0 from dual 
		where (select count(1) from '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR where DD_DFI_CODIGO =''CONEX'')=0';
        EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR (DD_DFI_ID,DD_DFI_CODIGO,DD_DFI_DESCRIPCION,DD_DFI_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) 
		select S_DD_DFI_DECISION_FINALIZAR.NEXTVAL,''DECCON'',''Declaración concurso'',''Declaración concurso'',0,''RECOVERY-2460'',sysdate,0 from dual 
		where (select count(1) from '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR where DD_DFI_CODIGO =''DECCON'')=0';
         EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR (DD_DFI_ID,DD_DFI_CODIGO,DD_DFI_DESCRIPCION,DD_DFI_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) 
		select S_DD_DFI_DECISION_FINALIZAR.NEXTVAL,''INACC'',''Inacción'',''Inacción'',0,''RECOVERY-2460'',sysdate,0 from dual 
		where (select count(1) from '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR where DD_DFI_CODIGO =''INACC'')=0';
        EXECUTE IMMEDIATE V_MSQL;
   
    commit;

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
