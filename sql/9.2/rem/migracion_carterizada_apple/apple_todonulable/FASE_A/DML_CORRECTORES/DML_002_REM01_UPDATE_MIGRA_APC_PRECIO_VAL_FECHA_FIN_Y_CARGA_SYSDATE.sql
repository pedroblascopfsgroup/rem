--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20180306
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5588
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Seteamos SYSDATE como VAL_FECHA_INICIO y VAL_FECHA_CARGA en MIG_APC_PRECIO.
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
  
    DBMS_OUTPUT.PUT_LINE('[INICIO] Seteamos SYSDATE como VAL_FECHA_INICIO y VAL_FECHA_CARGA en MIG_APC_PRECIO.');
    
    -- Verificar si la tabla existe
    V_MSQL := '
    UPDATE '||V_ESQUEMA||'.MIG_APC_PRECIO 
    SET 
    VAL_FECHA_INICIO = SYSDATE,
    VAL_FECHA_CARGA = SYSDATE
    ';
    EXECUTE IMMEDIATE V_MSQL;   
    
    V_NUM_TABLAS := SQL%ROWCOUNT;

    EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.GUNSHOTS_MIGAPPLE_PFS (GUNSHOT_COD,GUNSHOT_DML,GUNSHOT_DESC,GUNSHOT_REGISTROS_ACTUALIZADOS,GUNSHOT_TIMESTAMP) VALUES (''GNS002'',''DML_002_REM_UPDATE_MIGRA_APC_PRECIO_VAL_FECHA_INICIO_Y_CARGA_SYSDATE.sql'',''Para arreglar "[VALOR POR DEFECTO] Valor por defecto en campo VAL_FECHA_CARGA incorrecto. Debería ser SYSDATE" y "[VALOR POR DEFECTO] Valor por defecto en campo VAL_FECHA_INICIO incorrecto. Debería ser SYSDATE". Seteamos SYSDATE como VAL_FECHA_INICIO y VAL_FECHA_CARGA en MIG_APC_PRECIO.''
    ,'||V_NUM_TABLAS||',SYSDATE)' ;

    DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] [GNS002] Se actualiza el VAL_FECHA_INICIO y VAL_FECHA_CARGA de '||V_NUM_TABLAS||' registros para que sean SYSDATE.');    
    
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
