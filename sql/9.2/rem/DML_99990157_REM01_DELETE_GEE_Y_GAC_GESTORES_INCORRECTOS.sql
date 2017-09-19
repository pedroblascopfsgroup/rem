--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20170914
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2801
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
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
BEGIN
	DBMS_OUTPUT.PUT_LINE('******** GAC_GESTOR_ADD_ACTIVO ********'); 
    
      V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO T1 WHERE EXISTS (select 1 from '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO gac '||
      			' inner join '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD gee on gac.GEE_ID = gee.GEE_ID '||
      			' inner join '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR tge on gee.DD_TGE_ID = tge.DD_TGE_ID '||
      			' inner join '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO aba on gac.ACT_ID = aba.ACT_ID '||
      			' inner join '||V_ESQUEMA||'.DD_CLA_CLASE_ACTIVO cla on aba.DD_CLA_ID = cla.DD_CLA_ID '||
      			' where cla.DD_CLA_CODIGO = 01 and tge.DD_TGE_CODIGO NOT IN(''GPUBL'',''SPUBL'',''GCOM'',''SCOM'',''FVDNEG'',''FVDBACKOFR'',''FVDBACKVNT'',''SUPFVD'',''GFORM'',''SFORM'') '||
      			' and gee.USUARIOCREAR IN (''ALT_PRINEX'',''ALT_SAREB'') AND gac.GEE_ID = T1.GEE_ID)';
      			
      EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Borrado registro '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO');
      
      
       V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD T1 WHERE EXISTS (select 1 from '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO gac '||
      			' inner join '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD gee on gac.GEE_ID = gee.GEE_ID '||
      			' inner join '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR tge on gee.DD_TGE_ID = tge.DD_TGE_ID '||
      			' inner join '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO aba on gac.ACT_ID = aba.ACT_ID '||
      			' inner join '||V_ESQUEMA||'.DD_CLA_CLASE_ACTIVO cla on aba.DD_CLA_ID = cla.DD_CLA_ID '||
      			' where cla.DD_CLA_CODIGO = 01 and tge.DD_TGE_CODIGO NOT IN(''GPUBL'',''SPUBL'',''GCOM'',''SCOM'',''FVDNEG'',''FVDBACKOFR'',''FVDBACKVNT'',''SUPFVD'',''GFORM'',''SFORM'') '||
      			' and gee.USUARIOCREAR IN (''ALT_PRINEX'',''ALT_SAREB'') AND gac.GEE_ID = T1.GEE_ID)';
            
      EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Borrado registro '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD');
	
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
