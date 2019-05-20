--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20180307
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5588
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Seteamos en el campo AGR_ACT_PRINCIPAL de MIG_AAG_AGRUPACIONES un activo existente (Sacado de su relacion)
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
  
    DBMS_OUTPUT.PUT_LINE('[INICIO] Seteamos en el campo AGR_ACT_PRINCIPAL de MIG_AAG_AGRUPACIONES un activo existente (Sacado de su relacion).');
    
    -- Verificar si la tabla existe
    V_MSQL := ' MERGE INTO '||V_ESQUEMA||'.MIG_AAG_AGRUPACIONES T1
				USING (
					SELECT AAG.AGR_EXTERNO, MAX(AAA.ACT_NUMERO_ACTIVO) as ACT_NUMERO_ACTIVO
                        FROM '||V_ESQUEMA||'.MIG_AAG_AGRUPACIONES AAG
                        INNER JOIN '||V_ESQUEMA||'.MIG_AAA_AGRUPACION_ACTIVO AAA
                        ON AAA.AGR_EXTERNO = AAG.AGR_EXTERNO
                        WHERE NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.MIG_ACA_CABECERA CAB WHERE CAB.ACT_NUMERO_ACTIVO = AAG.AGR_ACT_PRINCIPAL)
                        GROUP BY AAG.AGR_EXTERNO
                        ORDER BY 1 DESC
				) T2
				ON (T1.AGR_EXTERNO = T2.AGR_EXTERNO)
				WHEN MATCHED THEN UPDATE SET
					T1.AGR_ACT_PRINCIPAL = T2.ACT_NUMERO_ACTIVO
    ';
    EXECUTE IMMEDIATE V_MSQL;  
     
    V_NUM_TABLAS := SQL%ROWCOUNT;

    EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.GUNSHOTS_MIGAPPLE_PFS (GUNSHOT_COD,GUNSHOT_DML,GUNSHOT_DESC,GUNSHOT_REGISTROS_ACTUALIZADOS,GUNSHOT_TIMESTAMP) VALUES (''GNS011'',''DML_011_REM01_MERGE_MIG_AAG_AGRUPACIONES_AGR_ACT_PRINCIPAL.sql'',''Para arreglar "[DEPENDENCIA] El registro del que depende no está. El campo MIG_AAG_AGRUPACIONES.AGR_ACT_PRINCIPAL no se encuentra en el campo MIG_ACA_CABECERA.ACT_NUMERO_ACTIVO". Seteamos en el campo AGR_ACT_PRINCIPAL de MIG_AAG_AGRUPACIONES un activo existente (Sacado de su relacion).''
    ,'||V_NUM_TABLAS||',SYSDATE)' ;

    DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] [GNS011] Se actualiza el AGR_ACT_PRINCIPAL de '||V_NUM_TABLAS||' agrupaciones por un activo de su relacion que si existe en cabecera.');  
    
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
