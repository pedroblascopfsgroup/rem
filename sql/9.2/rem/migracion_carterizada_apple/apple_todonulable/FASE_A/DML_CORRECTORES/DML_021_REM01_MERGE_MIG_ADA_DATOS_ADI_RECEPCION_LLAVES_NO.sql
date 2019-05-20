--/*
--######################################### 
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20180305
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5773
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
  
    DBMS_OUTPUT.PUT_LINE('[INICIO] Ponemos sin llaves todos los activos. Arregla la validación funcional [ACT_017].');
    
    V_MSQL := '
    MERGE INTO '||V_ESQUEMA||'.MIG_ADA_DATOS_ADI T1
	USING (
		SELECT DISTINCT AUX.ACT_NUMERO_ACTIVO, ADA.ACT_LLV_FECHA_RECEPCION, ADA.ACT_LLV_LLAVES_HRE
		FROM '||V_ESQUEMA||'.MIG_ACA_CABECERA AUX 
		INNER JOIN '||V_ESQUEMA||'.MIG_ADA_DATOS_ADI ADA ON ADA.ACT_NUMERO_ACTIVO = AUX.ACT_NUMERO_ACTIVO 
	) T2
	ON (T1.ACT_NUMERO_ACTIVO = T2.ACT_NUMERO_ACTIVO)
	WHEN MATCHED THEN UPDATE SET
	   T1.ACT_LLV_FECHA_RECEPCION = NULL,
	   T1.ACT_LLV_LLAVES_HRE = 0
    ';
    EXECUTE IMMEDIATE V_MSQL;   
    
    V_NUM_TABLAS := SQL%ROWCOUNT;

    EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.GUNSHOTS_MIGAPPLE_PFS (GUNSHOT_COD,GUNSHOT_DML,GUNSHOT_DESC,GUNSHOT_REGISTROS_ACTUALIZADOS,GUNSHOT_TIMESTAMP) VALUES (''GNS022'',''DML_021_REM01_MERGE_MIG_ADA_DATOS_ADI_RECEPCION_LLAVES_NO.sql'',''Ponemos sin llaves todos los activos. Arregla la validación funcional [ACT_017]''
    ,'||V_NUM_TABLAS||',SYSDATE)' ;

    DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] [GNS022] Ponemos sin llaves el indicador de los '||V_NUM_TABLAS||' activos.');    
    
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
