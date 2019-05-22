--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20180307
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5588
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Seteamos 06 en el campo ACT_COD_ESTADO_PUBLICACION "No publicado" en MIG2_ACT_ACTIVO.
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
  
    DBMS_OUTPUT.PUT_LINE('[INICIO] Seteamos 06 en el campo ACT_COD_ESTADO_PUBLICACION "No publicado" en MIG2_ACT_ACTIVO.');
    
    -- Verificar si la tabla existe
    V_MSQL := '
    UPDATE '||V_ESQUEMA||'.MIG2_ACT_ACTIVO 
    SET 
    ACT_COD_ESTADO_PUBLICACION = ''06''
    ';
    EXECUTE IMMEDIATE V_MSQL;   
    
    V_NUM_TABLAS := SQL%ROWCOUNT;

    EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.GUNSHOTS_MIGAPPLE_PFS (GUNSHOT_COD,GUNSHOT_DML,GUNSHOT_DESC,GUNSHOT_REGISTROS_ACTUALIZADOS,GUNSHOT_TIMESTAMP) VALUES (''GNS008'',''DML_008_REM_UPDATE_MIG2_ACT_ACTIVO_ACT_COD_ESTADO_PUBLICACION_06.sql'',''Para arreglar "[FUNCIONAL] [CRITICAL] - [ACT_043] - Activos en el que el estado de publicación es "Publicado" y no tienen fecha aceptación del informe del mediador", "[FUNCIONAL] [CRITICAL] - [ACT_048] - Activos publicados sin histórico de publicación en el mismo estado" y "[FUNCIONAL] [WARNING] - [ACT_042] - Activos en el que el estado de publicación es "Publicado" y no tienen OK de admisión y gestión". Seteamos 06 en el campo ACT_COD_ESTADO_PUBLICACION "No publicado" en MIG2_ACT_ACTIVO.''
    ,'||V_NUM_TABLAS||',SYSDATE)' ;

    DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] [GNS008] Se actualiza el ACT_COD_ESTADO_PUBLICACION de '||V_NUM_TABLAS||' activos para que sea 06 No publicado.');    
    
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
