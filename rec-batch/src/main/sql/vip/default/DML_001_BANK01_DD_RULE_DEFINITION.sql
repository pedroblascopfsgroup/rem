--/*
--##########################################
--## AUTOR=LUIS RUIZ
--## FECHA_CREACION=20150514
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.10.13
--## INCIDENCIA_LINK=BCFI-613
--## PRODUCTO=SI
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
    
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN    

    --** Tipo CNAE
    v_num_tablas:=0;
    v_msql:='Select count(1) From '||V_ESQUEMA||'.DD_RULE_DEFINITION Where rd_title like ''Tipo CNAE''';
    execute immediate v_msql into v_num_tablas;
    If V_NUM_TABLAS > 0
     Then 
       DBMS_OUTPUT.put_line('[INFO] Varible ''Tipo CNAE'' ya existe.');
     Else
       DBMS_OUTPUT.put_line('[INFO] Varible ''Tipo CNAE'' no existe.');
       v_msql:='Insert into '||V_ESQUEMA||'.DD_RULE_DEFINITION (rd_id, rd_title, rd_column, rd_type, rd_value_format, rd_bo_values, rd_tab, usuariocrear, fechacrear, borrado)
                Values ('||V_ESQUEMA||'.S_DD_RULE_DEFINITION.nextval, ''Tipo CNAE'', ''dd_tcn_id'', ''dictionary'', ''number'', ''DDTipoCnae'', ''Persona'', ''PFS'', sysdate, 0)';
       execute immediate v_msql;
       DBMS_OUTPUT.put_line('[INFO] Varible ''Tipo CNAE'' insertada correctamente.');
     End If;
     

    --** Marca Refinanciación
    v_num_tablas:=0;
    v_msql:='Select count(1) From '||V_ESQUEMA||'.DD_RULE_DEFINITION Where rd_title like ''Marca Refinanciacion''';
    execute immediate v_msql into v_num_tablas;
    If V_NUM_TABLAS > 0
     Then 
       DBMS_OUTPUT.put_line('[INFO] Varible ''Marca Refinanciación ya existe.''');
     Else
       DBMS_OUTPUT.put_line('[INFO] Varible ''Marca Refinanciación no existe.''');       
       v_msql:='Insert into '||V_ESQUEMA||'.DD_RULE_DEFINITION (rd_id, rd_title, rd_column, rd_type, rd_value_format, rd_bo_values, rd_tab, usuariocrear, fechacrear, borrado)
                Values ('||V_ESQUEMA||'.S_DD_RULE_DEFINITION.nextval, ''Marca Refinanciacion'', ''dd_mrf_id'', ''dictionary'', ''number'', ''DDMarcaRefinanciacion'', ''Contrato'', ''PFS'', sysdate, 0)';
       execute immediate v_msql;
       DBMS_OUTPUT.put_line('[INFO] Varible ''Marca Refinanciación'' insertada correctamente.');
     End If;
     

    --** Indicador Servicio Nómina o Pensión
    v_num_tablas:=0;
    v_msql:='Select count(1) From '||V_ESQUEMA||'.DD_RULE_DEFINITION Where rd_title like ''Indicador Nomina''';
    execute immediate v_msql into v_num_tablas;
    If V_NUM_TABLAS > 0
     Then 
       DBMS_OUTPUT.put_line('[INFO] Varible ''Indicador Servicio Nómina o Pensión'' ya existe.');
     Else
       DBMS_OUTPUT.put_line('[INFO] Varible ''Indicador Servicio Nómina o Pensión'' no existe.');       
       v_msql:='Insert into '||V_ESQUEMA||'.DD_RULE_DEFINITION (rd_id, rd_title, rd_column, rd_type, rd_value_format, rd_bo_values, rd_tab, usuariocrear, fechacrear, borrado)
                Values ('||V_ESQUEMA||'.S_DD_RULE_DEFINITION.nextval, ''Indicador Nomina'', ''dd_idn_id'', ''dictionary'', ''number'', ''DDIndicadorNomina'', ''Contrato'', ''PFS'', sysdate, 0)';
       execute immediate v_msql;
       DBMS_OUTPUT.put_line('[INFO] Varible ''Indicador Servicio Nómina o Pensión'' insertada correctamente.');
     End If;
     
     
     --** Confirmamos
     Commit;
    
    
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