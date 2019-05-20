--/*
--######################################### 
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20180307
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
  
    DBMS_OUTPUT.PUT_LINE('[INICIO] 	Comienza el proceso');
    
    
    V_MSQL :=  'UPDATE REM01.MIG2_ACT_AHP_HIST_PUBLICACION SET VALIDACION = 9';
    EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] Se actualiza a 9 el valdiacion de '||SQL%ROWCOUNT||' registros');
    
    -- Verificar si la tabla existe
    V_MSQL :=  'INSERT INTO REM01.MIG2_ACT_AHP_HIST_PUBLICACION (AHP_CODIGO_ACTIVO, DD_TCO_COD, DD_EPV_COD, DD_TPU_V_CODIGO, DD_MTO_V_CODIGO, AHP_MOT_OCULTACION_MANUAL_V, AHP_CHECK_PUBLICAR_V, AHP_CHECK_OCULTAR_V, AHP_CHECK_OCULTAR_PRECIO_V, AHP_CHECK_PUB_SIN_PRECIO_V, AHP_FECHA_INI_VENTA, AHP_FECHA_FIN_VENTA, DD_EPA_COD, DD_TPU_A_CODIGO, DD_MTO_A_CODIGO, AHP_MOT_OCULTACION_MANUAL_A, AHP_CHECK_PUBLICAR_A, AHP_CHECK_OCULTAR_A, AHP_CHECK_OCULTAR_PRECIO_A, AHP_CHECK_PUB_SIN_PRECIO_A, AHP_FECHA_INI_ALQUILER, AHP_FECHA_FIN_ALQUILER)
				SELECT 
					   T1.ACT_NUMERO_ACTIVO                                                                                                 AS AHP_CODIGO_ACTIVO,
					   NVL(T2.ACT_COD_TIPO_COMERCIALIZACION,''01'')                                                                         AS DD_TCO_COD,
					   ''01''																												AS DD_EPV_COD,
					   CASE WHEN NVL(T2.ACT_COD_TIPO_COMERCIALIZACION,''01'') IN (''01'',''02'') THEN ''01''
							ELSE                                                                NULL                                    END AS DD_TPU_V_CODIGO,
					   NULL                                                                                                                 AS DD_MTO_V_CODIGO,
					   NULL                                                                                                                 AS AHP_MOT_OCULTACION_MANUAL_V,
					   CASE WHEN NVL(T2.ACT_COD_TIPO_COMERCIALIZACION,''01'') IN (''01'',''02'') THEN NVL(T3.AHP_CHECK_PUBLICAR_V,0)
							ELSE                                                                NULL                                    END AS AHP_CHECK_PUBLICAR_V,
					   CASE WHEN NVL(T2.ACT_COD_TIPO_COMERCIALIZACION,''01'') IN (''01'',''02'') THEN NVL(T3.AHP_CHECK_PUBLICAR_V,0)
							ELSE                                                                NULL                                    END AS AHP_CHECK_OCULTAR_V,
					   CASE WHEN NVL(T2.ACT_COD_TIPO_COMERCIALIZACION,''01'') IN (''01'',''02'') THEN NVL(T3.AHP_CHECK_OCULTAR_PRECIO_V,0)
							ELSE                                                                NULL                                    END AS AHP_CHECK_OCULTAR_PRECIO_V,
					   CASE WHEN NVL(T2.ACT_COD_TIPO_COMERCIALIZACION,''01'') IN (''01'',''02'') THEN NVL(T3.AHP_CHECK_PUB_SIN_PRECIO_V,0)
							ELSE                                                                NULL                                    END AS AHP_CHECK_PUB_SIN_PRECIO_V,
					   CASE WHEN NVL(T2.ACT_COD_TIPO_COMERCIALIZACION,''01'') IN (''01'',''02'') THEN SYSDATE
							ELSE                                                                NULL                                    END AS AHP_FECHA_INI_VENTA,
					   NULL                                                                                                                 AS AHP_FECHA_FIN_VENTA, 
					   ''01''																												AS DD_EPA_COD,                                                                               
					   CASE WHEN NVL(T2.ACT_COD_TIPO_COMERCIALIZACION,''01'') IN (''02'',''03'',''04'') THEN ''01''
							ELSE                                                                NULL                                    END AS DD_TPU_A_CODIGO,
					   NULL                                                                                                                 AS DD_MTO_A_CODIGO,
					   NULL                                                                                                                 AS AHP_MOT_OCULTACION_MANUAL_A,
					   CASE WHEN NVL(T2.ACT_COD_TIPO_COMERCIALIZACION,''01'') IN (''02'',''03'',''04'') THEN NVL(T3.AHP_CHECK_PUBLICAR_A,0)
							ELSE                                                                NULL                                    END AS AHP_CHECK_PUBLICAR_A,
					   CASE WHEN NVL(T2.ACT_COD_TIPO_COMERCIALIZACION,''01'') IN (''02'',''03'',''04'') THEN NVL(T3.AHP_CHECK_OCULTAR_A,0)
							ELSE                                                                NULL                                    END AS AHP_CHECK_OCULTAR_A,
					   CASE WHEN NVL(T2.ACT_COD_TIPO_COMERCIALIZACION,''01'') IN (''02'',''03'',''04'') THEN NVL(T3.AHP_CHECK_OCULTAR_PRECIO_A,0)
							ELSE                                                                NULL                                    END AS AHP_CHECK_OCULTAR_PRECIO_A,
					   CASE WHEN NVL(T2.ACT_COD_TIPO_COMERCIALIZACION,''01'') IN (''02'',''03'',''04'') THEN NVL(T3.AHP_CHECK_PUB_SIN_PRECIO_A,0)
							ELSE                                                                NULL                                    END AS AHP_CHECK_PUB_SIN_PRECIO_A,
					   CASE WHEN NVL(T2.ACT_COD_TIPO_COMERCIALIZACION,''01'') IN (''02'',''03'',''04'') THEN SYSDATE
							ELSE                                                                NULL                                    END AS AHP_FECHA_INI_ALQUILER,
					   NULL                                                                                                                 AS AHP_FECHA_FIN_ALQUILER
				FROM REM01.MIG_ACA_CABECERA                   T1
				LEFT JOIN REM01.MIG2_ACT_ACTIVO               T2 ON T1.ACT_NUMERO_ACTIVO = T2.ACT_NUMERO_ACTIVO
				LEFT JOIN (
						   SELECT * FROM (
								SELECT ROWID, ROW_NUMBER() OVER (PARTITION BY AHP_CODIGO_ACTIVO ORDER BY 1 ASC) AS RN, AA.*  
								FROM REM01.MIG2_ACT_AHP_HIST_PUBLICACION AA
						   )
						   WHERE RN = 1                     ) T3 ON T3.AHP_CODIGO_ACTIVO = T1.ACT_NUMERO_ACTIVO
    ';
    EXECUTE IMMEDIATE V_MSQL;  
    
    V_NUM_TABLAS := SQL%ROWCOUNT;

    EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.GUNSHOTS_MIGAPPLE_PFS (GUNSHOT_COD,GUNSHOT_DML,GUNSHOT_DESC,GUNSHOT_REGISTROS_ACTUALIZADOS,GUNSHOT_TIMESTAMP) VALUES (''GNS012'',''DML_012_REM01_INSERT_MIG2_ACT_AHP_HIST_PUBLICACION.sql'',''Para arreglar la interfaz del historico de publicaciones creando un registro por activo.''
    ,'||V_NUM_TABLAS||',SYSDATE)' ;

    DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] [GNS012] Se insertan '||V_NUM_TABLAS||' registros en la interfaz de publicaciones. (1 registro por activo)');  
    
    
    V_MSQL :=  'DELETE FROM REM01.MIG2_ACT_AHP_HIST_PUBLICACION WHERE VALIDACION = 9';
    EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] Se borran '||SQL%ROWCOUNT||' registros');
    
    
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
