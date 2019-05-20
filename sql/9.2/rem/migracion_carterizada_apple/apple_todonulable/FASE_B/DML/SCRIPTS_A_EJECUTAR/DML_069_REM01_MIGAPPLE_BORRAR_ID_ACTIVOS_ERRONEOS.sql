--/*
--######################################### 
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20180321
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
  
    DBMS_OUTPUT.PUT_LINE('[INICIO] Insertamos en la tabla MIG_AAA_AGRUPACION_ACTIVO.');
    
    V_MSQL := '
				UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET 
					 ACT_NUM_ACTIVO_PRINEX 		= NULL
					,ACT_NUM_ACTIVO_SAREB 		= NULL
					,ACT_NUM_ACTIVO_UVEM 		= NULL
					,ACT_NUM_INMOVILIZADO_BNK 	= NULL 
				WHERE USUARIOCREAR = ''MIG_APPLE''
    ';
    
    EXECUTE IMMEDIATE V_MSQL;   
    
    V_NUM_TABLAS := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] Borramos los IDs erroneos en '||V_NUM_TABLAS||' registros.');    

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
