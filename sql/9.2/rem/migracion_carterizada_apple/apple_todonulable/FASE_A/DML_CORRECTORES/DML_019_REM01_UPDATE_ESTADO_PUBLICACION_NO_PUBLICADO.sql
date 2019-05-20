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
  
    DBMS_OUTPUT.PUT_LINE('[INICIO] Ponemos a No publicado todos los activos que no tuvieran ese estado de publicación.');
    
    -- Verificar si la tabla existe
    V_MSQL := ' MERGE INTO REM01.ACT_ACTIVO T1
				USING (
					SELECT DISTINCT ACT.ACT_ID 
					FROM REM01.MIG_ACA_CABECERA                 MIG
					JOIN REM01.ACT_ACTIVO                       ACT ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
					LEFT JOIN REM01.DD_EPU_ESTADO_PUBLICACION   EPU ON EPU.DD_EPU_ID = ACT.DD_EPU_ID
					WHERE EPU.DD_EPU_ID IS NULL 
					   OR EPU.DD_EPU_CODIGO NOT IN (''06'')
				) T2
				ON (T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET
				  T1.DD_EPU_ID = (SELECT DD_EPU_ID FROM REM01.DD_EPU_ESTADO_PUBLICACION WHERE DD_EPU_CODIGO = ''06'')
    ';
    EXECUTE IMMEDIATE V_MSQL;  
     
    V_NUM_TABLAS := SQL%ROWCOUNT;

    EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.GUNSHOTS_MIGAPPLE_PFS (GUNSHOT_COD,GUNSHOT_DML,GUNSHOT_DESC,GUNSHOT_REGISTROS_ACTUALIZADOS,GUNSHOT_TIMESTAMP) VALUES (''GNS020'',''DML_019_REM01_UPDATE_ESTADO_PUBLICACION_NO_PUBLICADO.sql'',''Para poner todos los activos como no publicados.''
    ,'||V_NUM_TABLAS||',SYSDATE)' ;

    DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] [GNS020] Se actualiza el estado de publicación de '||V_NUM_TABLAS||' activos de la migración a No publicado.');  
    
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
