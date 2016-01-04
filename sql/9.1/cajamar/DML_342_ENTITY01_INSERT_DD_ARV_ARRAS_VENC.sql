--/*
--##########################################
--## AUTOR=RUBEN ROVIRA
--## FECHA_CREACION=20151217
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-1216
--## PRODUCTO=NO
--## Finalidad: DML
--##           
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
    ITABLE_SPACE   VARCHAR(25) := '#TABLESPACE_INDEX#';
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla. 
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
BEGIN
    
    ---------------------------
    --   DD_ARV_ARRAS_VENC   --
    --------------------------- 
     --** Comprobamos si existe la tabla   
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_ARV_ARRAS_VENC'' and owner = '''||v_esquema||'''';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    IF V_NUM_TABLAS = 1 THEN 
    V_MSQL := 'INSERT INTO '||v_esquema||'.DD_ARV_ARRAS_VENC 
    (
     DD_ARV_ID				
    ,DD_ARV_CODIGO			
    ,DD_ARV_DESCRIPCION		
    ,DD_ARV_DESCRIPCION_LARGA		
    ,VERSION					
    ,USUARIOCREAR			
    ,FECHACREAR									
    )
    VALUES ('||V_ESQUEMA||'.S_DD_ARV_ARRAS_VENC.nextval,''S'',''SI'',''SI'',0,''DD'',SYSDATE)';
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'INSERT INTO '||v_esquema||'.DD_ARV_ARRAS_VENC 
    (
     DD_ARV_ID				
    ,DD_ARV_CODIGO			
    ,DD_ARV_DESCRIPCION		
    ,DD_ARV_DESCRIPCION_LARGA		
    ,VERSION					
    ,USUARIOCREAR			
    ,FECHACREAR									
    )
    VALUES ('||V_ESQUEMA||'.S_DD_ARV_ARRAS_VENC.nextval,''N'',''NO'',''NO'',0,''DD'',SYSDATE)';
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'INSERT INTO '||v_esquema||'.DD_ARV_ARRAS_VENC 
    (
     DD_ARV_ID				
    ,DD_ARV_CODIGO			
    ,DD_ARV_DESCRIPCION		
    ,DD_ARV_DESCRIPCION_LARGA		
    ,VERSION					
    ,USUARIOCREAR			
    ,FECHACREAR									
    )
    VALUES ('||V_ESQUEMA||'.S_DD_ARV_ARRAS_VENC.nextval,''D'',''Arrastre por una operacion en dudoso'',''Arrastre por una operacion en dudoso'',0,''DD'',SYSDATE)';
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'INSERT INTO '||v_esquema||'.DD_ARV_ARRAS_VENC 
    (
     DD_ARV_ID				
    ,DD_ARV_CODIGO			
    ,DD_ARV_DESCRIPCION		
    ,DD_ARV_DESCRIPCION_LARGA		
    ,VERSION					
    ,USUARIOCREAR			
    ,FECHACREAR									
    )
    VALUES ('||V_ESQUEMA||'.S_DD_ARV_ARRAS_VENC.nextval,''X'',''Operacion ya no arrastrada'',''Operacion ya no arrastrada'',0,''DD'',SYSDATE)';
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'INSERT INTO '||v_esquema||'.DD_ARV_ARRAS_VENC 
    (
     DD_ARV_ID				
    ,DD_ARV_CODIGO			
    ,DD_ARV_DESCRIPCION		
    ,DD_ARV_DESCRIPCION_LARGA		
    ,VERSION					
    ,USUARIOCREAR			
    ,FECHACREAR									
    )
    VALUES ('||V_ESQUEMA||'.S_DD_ARV_ARRAS_VENC.nextval,''F'',''Cliente en concurso o tiene una orden o la operación tiene una orden'',''Cliente en concurso o tiene una orden o la operación tiene una orden'',0,''DD'',SYSDATE)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.DD_ARV_ARRAS_VENC... Insert table FIN'); 
    END IF;   
     
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_VEN_VENCIDOS_ARRASTRE'' and owner = '''||v_esquema||'''';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    IF V_NUM_TABLAS = 1 THEN 
    --** Cargamos los nuevos valores en ven_vencidos
	V_MSQL := 'MERGE INTO '||v_esquema||'.VEN_VENCIDOS ven
    USING (SELECT a.VEN_ID,dd.DD_ARV_ID as VEN_ARRASTRE FROM '||v_esquema||'.TMP_VEN_VENCIDOS_ARRASTRE a JOIN '||v_esquema||'.DD_ARV_ARRAS_VENC dd ON A.VEN_ARRASTRE=dd.DD_ARV_CODIGO) tmp
    ON (ven.ven_id=tmp.ven_id)
    WHEN MATCHED THEN UPDATE SET ven.VEN_ARRASTRE=tmp.VEN_ARRASTRE';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.VEN_VENCIDOS nuevo valor campo ven_arrastre cargado...'); 
    END IF;  
 
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
