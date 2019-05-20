--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20180301
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5588
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Para arreglar "[OBLIGATORIEDAD] Agrupación restringida sin ningún activo principal (Flag AGA_PRINCIPAL).", asignamos el ACT_ID mas alto para la agrupacion en cuestion
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
  
    DBMS_OUTPUT.PUT_LINE('[INICIO] Asignamos ACT_ID mas alto para cada agrupacion que tenga AGR_ACT_PRINCIPAL a NULL.');
    
    /*EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.GUNSHOTS_MIGAPPLE_PFS WHERE GUNSHOT_COD = ''GNS000''';
    COMMIT;*/
    
    -- Verificar si la tabla existe
    V_MSQL := '
    MERGE INTO '||V_ESQUEMA||'.MIG_AAG_AGRUPACIONES AGR USING (
    SELECT AGR.AGR_EXTERNO, MAX(AAA.ACT_NUMERO_ACTIVO) AS ACTIVO
    FROM '||V_ESQUEMA||'.MIG_AAG_AGRUPACIONES AGR
    INNER JOIN '||V_ESQUEMA||'.MIG_AAA_AGRUPACION_ACTIVO AAA
        ON AAA.AGR_EXTERNO = AGR.AGR_EXTERNO
    WHERE AGR.TIPO_AGRUPACION = ''02''
    AND AGR.AGR_ACT_PRINCIPAL IS NULL
    GROUP BY AGR.AGR_EXTERNO
    ) TMP
    ON (TMP.AGR_EXTERNO = AGR.AGR_EXTERNO)
    WHEN MATCHED THEN UPDATE SET
    AGR.AGR_ACT_PRINCIPAL = TMP.ACTIVO
    WHERE AGR.AGR_ACT_PRINCIPAL IS NULL
    ';
    EXECUTE IMMEDIATE V_MSQL;   
    
    V_NUM_TABLAS := SQL%ROWCOUNT;

    EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.GUNSHOTS_MIGAPPLE_PFS (GUNSHOT_COD,GUNSHOT_DML,GUNSHOT_DESC,GUNSHOT_REGISTROS_ACTUALIZADOS,GUNSHOT_TIMESTAMP) VALUES (''GNS000'',''DML_000_REM_MERGE_MIGRA_AGR_ACT_PRINCIPAL_ACT_ID_MAS_ALTO.sql'',''Para arreglar "[OBLIGATORIEDAD] Agrupación restringida sin ningún activo principal (Flag AGA_PRINCIPAL).", asignamos el ACT_ID mas alto para la agrupacion en cuestion.''
    ,'||V_NUM_TABLAS||',SYSDATE)' ;

    DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] [GNS000] Se actualiza el AGR_ACT_PRINCIPAL de '||V_NUM_TABLAS||' agrupaciones.');    
    
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
