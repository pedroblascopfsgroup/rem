--/*
--######################################### 
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20180305
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5588
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  
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
  
    DBMS_OUTPUT.PUT_LINE('[INICIO] Corregimos los valores mal mapeados por formato (DD_ODT_ID, CRG_OBSERVACIONES y CRG_CARGAS_PROPIAS) de las cargas (MIG_ACA_CARGAS_ACTIVO).');
    
    -- Verificar si la tabla existe
    V_MSQL := ' MERGE INTO '||V_ESQUEMA||'.MIG_ACA_CARGAS_ACTIVO T1
				USING (
					SELECT
						ROWID,
						''01''                                                                                       AS ORIGEN_DATO,
						SUBSTR(CRG_OBSERVACIONES,0,LENGTH(CRG_OBSERVACIONES)-2)             						 AS OBSERVACIONES,
						TO_NUMBER(SUBSTR(CRG_OBSERVACIONES,LENGTH(CRG_OBSERVACIONES)-1,LENGTH(CRG_OBSERVACIONES)))   AS CARGAS_PROPIAS
					FROM '||V_ESQUEMA||'.MIG_ACA_CARGAS_ACTIVO
				) T2
				ON (T1.ROWID = T2.ROWID)
				WHEN MATCHED THEN UPDATE SET
					T1.DD_ODT_ID = T2.ORIGEN_DATO,  
					T1.CRG_OBSERVACIONES = T2.OBSERVACIONES, 
					T1.CRG_CARGAS_PROPIAS = T2.CARGAS_PROPIAS
    ';
    EXECUTE IMMEDIATE V_MSQL;  
     
    V_NUM_TABLAS := SQL%ROWCOUNT;

    EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.GUNSHOTS_MIGAPPLE_PFS (GUNSHOT_COD,GUNSHOT_DML,GUNSHOT_DESC,GUNSHOT_REGISTROS_ACTUALIZADOS,GUNSHOT_TIMESTAMP) VALUES (''GNS009'',''DML_009_REM01_MERGE_MIG_ACA_CARGAS_ACTIVO_DD_ODT_ID.sql'',''Para arreglar "[DICCIONARIO] El campo MIG_ACA_CARGAS_ACTIVO.DD_ODT_ID no se corresponde a ningún valor del DD DD_ODT_ORIGEN_DATO.DD_ODT_CODIGO", asignamos el DD_ODT_ID correspondiente a REM.''
    ,'||V_NUM_TABLAS||',SYSDATE)' ;

    DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] [GNS009] Se actualiza el DD_ODT_ID (Origen del dato) de '||V_NUM_TABLAS||' cargas al valor correspondiente a REM.');  
    
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
