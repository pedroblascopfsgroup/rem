--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20180308
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5588
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Nos deshacemos de los duplicados en MIG_APC_PRECIO. Priorizamos VAL_FECHA_APROBACION mas alta, VAL_IMPORTE mas alto.
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
  
    DBMS_OUTPUT.PUT_LINE('[INICIO] Nos deshacemos de los duplicados en MIG_APC_PRECIO. Priorizamos VAL_FECHA_APROBACION mas alta, VAL_IMPORTE mas alto.');
    
    V_MSQL := '
    UPDATE '||V_ESQUEMA||'.MIG_APC_PRECIO 
    SET 
    VALIDACION = ''0''
    ';
    EXECUTE IMMEDIATE V_MSQL;   
    COMMIT;

    V_MSQL := '
    INSERT INTO '||V_ESQUEMA||'.MIG_APC_PRECIO 
    SELECT * FROM (
        SELECT
        ACT_NUMERO_ACTIVO,
        TIPO_PRECIO,
        VAL_IMPORTE,
        VAL_FECHA_INICIO,
        VAL_FECHA_FIN,
        VAL_FECHA_APROBACION,
        VAL_FECHA_CARGA,
        USUARIO,
        VAL_OBSERVACIONES,
        row_number() over (partition by act_numero_activo,tipo_precio order by act_numero_activo desc, VAL_FECHA_APROBACION desc nulls last, VAL_IMPORTE desc nulls last) as VALIDACION
        from '||V_ESQUEMA||'.MIG_APC_PRECIO  mig
        order by act_numero_activo desc, VALIDACION asc
    )
    WHERE VALIDACION = 1
    ';
    EXECUTE IMMEDIATE V_MSQL;   
    
    V_NUM_TABLAS := SQL%ROWCOUNT;

    V_MSQL := '
    DELETE FROM '||V_ESQUEMA||'.MIG_APC_PRECIO 
    WHERE 
    VALIDACION = ''0''
    ';
    EXECUTE IMMEDIATE V_MSQL;   

    V_MSQL := '
    UPDATE '||V_ESQUEMA||'.MIG_APC_PRECIO 
    SET 
    VALIDACION = ''0''
    ';
    EXECUTE IMMEDIATE V_MSQL;   
    COMMIT;

    EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.GUNSHOTS_MIGAPPLE_PFS (GUNSHOT_COD,GUNSHOT_DML,GUNSHOT_DESC,GUNSHOT_REGISTROS_ACTUALIZADOS,GUNSHOT_TIMESTAMP) VALUES (''GNS015'',''DML_015_REM01_RECARGA_MIG_APC_PRECIO_DUPLICADOS.sql'',''Nos deshacemos de los duplicados en MIG_APC_PRECIO. Priorizamos VAL_FECHA_APROBACION mas alta, VAL_IMPORTE mas alto.''
    ,'||V_NUM_TABLAS||',SYSDATE)' ;

    DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] [GNS015] Nos deshacemos de los duplicados en MIG_APC_PRECIO. Priorizamos VAL_FECHA_APROBACION mas alta, VAL_IMPORTE mas alto. Total de registros finalmente en MIG_APC_PRECIO > '||V_NUM_TABLAS||'.');    
    
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
