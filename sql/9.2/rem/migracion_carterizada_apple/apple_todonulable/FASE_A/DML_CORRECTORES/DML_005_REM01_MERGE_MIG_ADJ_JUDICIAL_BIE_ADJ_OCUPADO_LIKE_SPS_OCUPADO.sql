--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20180306
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5588
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Seteamos BIE_ADJ_OCUPADO igual que MIG_ADA_DATOS_ADI.SPS_OCUPADO en MIG_ADJ_JUDICIAL.
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); --Vble .aux para almacenar el valor de la sequencia
    V_NUM_MAXID NUMBER(16); --Vble .aux para almacenar el valor maximo de 
    
BEGIN
  
    DBMS_OUTPUT.PUT_LINE('[INICIO] Seteamos BIE_ADJ_OCUPADO igual que MIG_ADA_DATOS_ADI.SPS_OCUPADO en MIG_ADJ_JUDICIAL.');
    
    -- Verificar si la tabla existe
    V_MSQL := '
    MERGE INTO '||V_ESQUEMA||'.MIG_ADJ_JUDICIAL ADJ USING (
        SELECT SPS_OCUPADO, ACT_NUMERO_ACTIVO FROM '||V_ESQUEMA||'.MIG_ADA_DATOS_ADI
    ) TMP 
    ON (TMP.ACT_NUMERO_ACTIVO = ADJ.ACT_NUMERO_ACTIVO)
    WHEN MATCHED THEN UPDATE SET
    BIE_ADJ_OCUPADO = TMP.SPS_OCUPADO
    ';
    EXECUTE IMMEDIATE V_MSQL;   
    
    V_NUM_TABLAS := SQL%ROWCOUNT;

    EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.GUNSHOTS_MIGAPPLE_PFS (GUNSHOT_COD,GUNSHOT_DML,GUNSHOT_DESC,GUNSHOT_REGISTROS_ACTUALIZADOS,GUNSHOT_TIMESTAMP) VALUES (''GNS005'',''DML_005_REM_MERGE_MIG_ADJ_JUDICIAL_BIE_ADJ_OCUPADO_LIKE_SPS_OCUPADO.sql'',''Para arreglar "[VALOR POR DEFECTO] Valor por defecto en campo BIE_ADJ_OCUPADO incorrecto. Debería igual al correspondiente en DATOS_ADICIONALES.SPS_OCUPADO.". Seteamos BIE_ADJ_OCUPADO igual que MIG_ADA_DATOS_ADI.SPS_OCUPADO en MIG_ADJ_JUDICIAL.''
    ,'||V_NUM_TABLAS||',SYSDATE)' ;

    DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] [GNS005] Se actualiza el BIE_ADJ_OCUPADO de '||V_NUM_TABLAS||' activos para que sea NULL.');    
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');    

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    err_num := SQLCODE;
    err_msg := SQLERRM;
    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    
    ROLLBACK;
    RAISE;          

END;

/

EXIT;
