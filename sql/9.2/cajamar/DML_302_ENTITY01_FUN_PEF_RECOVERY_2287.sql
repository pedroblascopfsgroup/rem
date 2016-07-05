--/*
--##########################################
--## AUTOR=RUBEN ROVIRA
--## FECHA_CREACION=20160705
--## ARTEFACTO=BATCH
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-2287
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
    
    ----------------
    --  FUN_PEF   --
    ----------------
    

    V_MSQL := 'insert into '||V_ESQUEMA||'.fun_pef (fun_id,pef_id,fp_id,version,usuariocrear,fechacrear)select 61,pef.pef_id,'||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL,0,''DD'',sysdate from '||V_ESQUEMA||'.pef_perfiles pef left join '||V_ESQUEMA||'.fun_pef fp on pef.pef_id=fp.pef_id and fp.fun_id=61 where pef_codigo =''GES_RIESGOS'' and fp.fp_id is null';
    EXECUTE IMMEDIATE V_MSQL;
    V_MSQL := 'insert into '||V_ESQUEMA||'.fun_pef (fun_id,pef_id,fp_id,version,usuariocrear,fechacrear)select 61,pef.pef_id,'||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL,0,''DD'',sysdate from '||V_ESQUEMA||'.pef_perfiles pef left join '||V_ESQUEMA||'.fun_pef fp on pef.pef_id=fp.pef_id and fp.fun_id=61 where pef_codigo =''SUP_SSCC'' and fp.fp_id is null';
    EXECUTE IMMEDIATE V_MSQL;
    V_MSQL := 'insert into '||V_ESQUEMA||'.fun_pef (fun_id,pef_id,fp_id,version,usuariocrear,fechacrear)select 61,pef.pef_id,'||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL,0,''DD'',sysdate from '||V_ESQUEMA||'.pef_perfiles pef left join '||V_ESQUEMA||'.fun_pef fp on pef.pef_id=fp.pef_id and fp.fun_id=61 where pef_codigo =''DIR_TERRITORIAL'' and fp.fp_id is null';
    EXECUTE IMMEDIATE V_MSQL;
    V_MSQL := 'insert into '||V_ESQUEMA||'.fun_pef (fun_id,pef_id,fp_id,version,usuariocrear,fechacrear)select 61,pef.pef_id,'||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL,0,''DD'',sysdate from '||V_ESQUEMA||'.pef_perfiles pef left join '||V_ESQUEMA||'.fun_pef fp on pef.pef_id=fp.pef_id and fp.fun_id=61 where pef_codigo =''DIR_TERRITORIAL_RIESGOS'' and fp.fp_id is null';
    EXECUTE IMMEDIATE V_MSQL;
    V_MSQL := 'insert into '||V_ESQUEMA||'.fun_pef (fun_id,pef_id,fp_id,version,usuariocrear,fechacrear)select 61,pef.pef_id,'||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL,0,''DD'',sysdate from '||V_ESQUEMA||'.pef_perfiles pef left join '||V_ESQUEMA||'.fun_pef fp on pef.pef_id=fp.pef_id and fp.fun_id=61 where pef_codigo =''SER_CENTRALES'' and fp.fp_id is null';
    EXECUTE IMMEDIATE V_MSQL;
    V_MSQL := 'insert into '||V_ESQUEMA||'.fun_pef (fun_id,pef_id,fp_id,version,usuariocrear,fechacrear)select 61,pef.pef_id,'||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL,0,''DD'',sysdate from '||V_ESQUEMA||'.pef_perfiles pef left join '||V_ESQUEMA||'.fun_pef fp on pef.pef_id=fp.pef_id and fp.fun_id=61 where pef_codigo =''DIR_SEGUIMIENTO'' and fp.fp_id is null';
    EXECUTE IMMEDIATE V_MSQL;
    V_MSQL := 'insert into '||V_ESQUEMA||'.fun_pef (fun_id,pef_id,fp_id,version,usuariocrear,fechacrear)select 61,pef.pef_id,'||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL,0,''DD'',sysdate from '||V_ESQUEMA||'.pef_perfiles pef left join '||V_ESQUEMA||'.fun_pef fp on pef.pef_id=fp.pef_id and fp.fun_id=61 where pef_codigo =''OFI_OFICINA'' and fp.fp_id is null';
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
