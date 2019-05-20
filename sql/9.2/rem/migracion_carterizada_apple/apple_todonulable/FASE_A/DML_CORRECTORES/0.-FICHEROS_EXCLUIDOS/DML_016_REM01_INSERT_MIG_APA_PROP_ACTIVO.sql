--/*
--#########################################
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20190312
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.6
--## INCIDENCIA_LINK=HREOS-5773
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Asignamos propietarios a los Activos a migrar.
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
  
    DBMS_OUTPUT.PUT_LINE('[INICIO] Asignamos propietarios a los Activos a migrar.');

    V_MSQL := '
    UPDATE '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO SET PRO_CODIGO_UVEM = 101010 WHERE PRO_DOCIDENTIF = ''A88203542''
    ';
    EXECUTE IMMEDIATE V_MSQL;   
    COMMIT;

    V_MSQL := '
    UPDATE '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO SET PRO_CODIGO_UVEM = 10101010 WHERE PRO_DOCIDENTIF = ''A88203534''
    ';
    EXECUTE IMMEDIATE V_MSQL;   
    COMMIT;
    
    V_MSQL := '
    DELETE FROM '||V_ESQUEMA||'.MIG_APA_PROP_ACTIVO
    ';
    EXECUTE IMMEDIATE V_MSQL;   
    COMMIT;

    V_MSQL := '
    DELETE FROM '||V_ESQUEMA||'.MIG_APC_PROP_CABECERA
    ';
    EXECUTE IMMEDIATE V_MSQL;   
    COMMIT;

    V_MSQL := '
    INSERT INTO '||V_ESQUEMA||'.MIG_APA_PROP_ACTIVO  --ACT_NUMERO_ACTIVO,PRO_CODIGO,GRADO_PROPIEDAD,PORCENTAJE,VALIDACION
    SELECT DISTINCT
    ACT_NUMERO_ACTIVO,
    case round(dbms_random.value(0,1)) when 1 then 101010
        else 10101010
    end as PRO_CODIGO,
    ''01'',
    100,
    0
    FROM '||V_ESQUEMA||'.MIG_ACA_CABECERA
    ';
    EXECUTE IMMEDIATE V_MSQL;   
    
    V_NUM_TABLAS := SQL%ROWCOUNT;

    EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.GUNSHOTS_MIGAPPLE_PFS (GUNSHOT_COD,GUNSHOT_DML,GUNSHOT_DESC,GUNSHOT_REGISTROS_ACTUALIZADOS,GUNSHOT_TIMESTAMP) VALUES (''GNS016'',''DML_016_REM01_INSERT_MIG_APA_PROP_ACTIVO.sql'',''Asignamos propietarios a los Activos a migrar.''
    ,'||V_NUM_TABLAS||',SYSDATE)' ;

    DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] [GNS016] Se insertan '||V_NUM_TABLAS||' registros en MIG_APA_PROP_ACTIVO.');    
    
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
