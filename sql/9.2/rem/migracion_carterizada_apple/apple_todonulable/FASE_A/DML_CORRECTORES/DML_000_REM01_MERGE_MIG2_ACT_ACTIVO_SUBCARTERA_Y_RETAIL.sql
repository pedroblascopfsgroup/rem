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
  
    DBMS_OUTPUT.PUT_LINE('[INICIO] Ponemos subcartera Apple y Tipo comercializacion RETAIL a todos los activos. Si no están en la MIG2 creamos registro.');
    
    /*EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.GUNSHOTS_MIGAPPLE_PFS WHERE GUNSHOT_COD = ''GNS000''';
    COMMIT;*/
    
    -- Verificar si la tabla existe
   /* V_MSQL := '
    MERGE INTO '||V_ESQUEMA||'.MIG2_ACT_ACTIVO T1 
	USING (
		SELECT DISTINCT ACA.ACT_NUMERO_ACTIVO AS ACTIVO,
						ACT.ACT_NUMERO_ACTIVO AS ACTIVO2
		FROM '||V_ESQUEMA||'.MIG_ACA_CABECERA     ACA
		LEFT JOIN '||V_ESQUEMA||'.MIG2_ACT_ACTIVO ACT ON ACA.ACT_NUMERO_ACTIVO = ACT.ACT_NUMERO_ACTIVO
	) T2
	ON (T1.ACT_NUMERO_ACTIVO = T2.ACTIVO2)
	WHEN MATCHED THEN 
	   UPDATE SET  
			   T1.ACT_COD_SUBCARTERA = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO IN (''138''))
	WHEN NOT MATCHED THEN 
	   INSERT (T1.ACT_NUMERO_ACTIVO, T1.ACT_COD_SUBCARTERA, T1.VALIDACION) 
	   VALUES (T2.ACTIVO, 
			   (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO IN (''138'')),	  
			   0)
	';
	*/
	
	V_MSQL := '
    MERGE INTO '||V_ESQUEMA||'.MIG2_ACT_ACTIVO T1 
	USING (
		SELECT DISTINCT ACA.ACT_NUMERO_ACTIVO AS ACTIVO,
			   ACT.ACT_NUMERO_ACTIVO AS ACTIVO2
		FROM '||V_ESQUEMA||'.MIG_ACA_CABECERA     ACA
		LEFT JOIN '||V_ESQUEMA||'.MIG2_ACT_ACTIVO ACT ON ACA.ACT_NUMERO_ACTIVO = ACT.ACT_NUMERO_ACTIVO
	) T2
	ON (T1.ACT_NUMERO_ACTIVO = T2.ACTIVO2)
	WHEN MATCHED THEN 
	   UPDATE SET  
			   T1.ACT_COD_SUBCARTERA = (SELECT DD_SCR_CODIGO FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO IN (''138'')),
			   T1.DD_TCR_ID = (SELECT DD_TCR_CODIGO FROM '||V_ESQUEMA||'.DD_TCR_TIPO_COMERCIALIZAR WHERE DD_TCR_CODIGO IN (''02''))
	WHEN NOT MATCHED THEN 
	   INSERT (T1.ACT_NUMERO_ACTIVO, T1.ACT_COD_SUBCARTERA, T1.DD_TCR_ID, T1.VALIDACION) 
	   VALUES (T2.ACTIVO, 
			   (SELECT DD_SCR_CODIGO FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO IN (''138'')),
			   (SELECT DD_TCR_CODIGO FROM '||V_ESQUEMA||'.DD_TCR_TIPO_COMERCIALIZAR WHERE DD_TCR_CODIGO IN (''02'')),
			   0)
	';
	
    EXECUTE IMMEDIATE V_MSQL;   
    
    V_NUM_TABLAS := SQL%ROWCOUNT;

    EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.GUNSHOTS_MIGAPPLE_PFS (GUNSHOT_COD,GUNSHOT_DML,GUNSHOT_DESC,GUNSHOT_REGISTROS_ACTUALIZADOS,GUNSHOT_TIMESTAMP) VALUES (''GNS00'',''DML_000_REM01_MERGE_MIG2_ACT_ACTIVO_SUBCARTERA_Y_RETAIL.sql'',''Ponemos subcartera Apple y Tipo comercializacion RETAIL a todos los activos. Si no están en la MIG2 creamos registro.''
    ,'||V_NUM_TABLAS||',SYSDATE)' ;

    DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] [GNS00] pone la subcartera apple y el tipo de comercializacion RETAIL en '||V_NUM_TABLAS||' activos.');    
    
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
