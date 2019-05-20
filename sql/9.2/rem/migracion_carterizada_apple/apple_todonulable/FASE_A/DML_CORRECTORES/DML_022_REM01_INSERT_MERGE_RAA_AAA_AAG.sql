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
				INSERT INTO '||V_ESQUEMA||'.MIG2_RAA_REL_AGRUPACION_ACTIVO (AGR_NUM_AGRUPACION,AGR_EXTERNO,AGR_ACTIVO)
					SELECT concat(''6666'',AAG.AGR_EXTERNO),AAG.AGR_EXTERNO,AAA.ACT_NUMERO_ACTIVO
					FROM '||V_ESQUEMA||'.MIG_AAA_AGRUPACION_ACTIVO AAA
					LEFT JOIN '||V_ESQUEMA||'.MIG2_ACT_ACTIVO ACT on AAA.ACT_NUMERO_ACTIVO = ACT.ACT_NUMERO_ACTIVO
					LEFT JOIN '||V_ESQUEMA||'.MIG_AAG_AGRUPACIONES AAG on AAG.AGR_EXTERNO = AAA.AGR_EXTERNO
					GROUP BY AAA.ACT_NUMERO_ACTIVO,AAG.AGR_EXTERNO,AAA.AGA_PRINCIPAL,AAA.AGA_FECHA_INCLUSION ORDER BY AAG.AGR_EXTERNO
    ';
    
    EXECUTE IMMEDIATE V_MSQL;   
    
    V_NUM_TABLAS := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] Insertamos en la tabla MIG_AAA_AGRUPACION_ACTIVO '||V_NUM_TABLAS||' registros.');    
    
    
    
    
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizamos en la tabla MIG_AAG_AGRUPACIONES.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.MIG_AAG_AGRUPACIONES AAG
					SET AAG.AGR_EXTERNO = (SELECT UNIQUE RAA.AGR_NUM_AGRUPACION
										   FROM '||V_ESQUEMA||'.MIG2_RAA_REL_AGRUPACION_ACTIVO RAA
										   WHERE AAG.AGR_EXTERNO = RAA.AGR_EXTERNO
										   )
					WHERE EXISTS (
					   SELECT *
					   FROM '||V_ESQUEMA||'.MIG2_RAA_REL_AGRUPACION_ACTIVO RAA
					   WHERE AAG.AGR_EXTERNO = RAA.AGR_EXTERNO
					   )';
    
    EXECUTE IMMEDIATE V_MSQL;   
    
    V_NUM_TABLAS := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] Se actualizan en la tabla MIG_AAG_AGRUPACIONES '||V_NUM_TABLAS||' registros.');    
    
    
    
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizamos en la tabla MIG_AAA_AGRUPACION_ACTIVO.');
    
    V_MSQL := ' UPDATE '||V_ESQUEMA||'.MIG_AAA_AGRUPACION_ACTIVO SET AGR_EXTERNO = TO_NUMBER(''6666''||AGR_EXTERNO)';
    
    EXECUTE IMMEDIATE V_MSQL;   
    
    V_NUM_TABLAS := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] Se actualizan en la tabla MIG_AAA_AGRUPACION_ACTIVO '||V_NUM_TABLAS||' registros.');    
    
    
    
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
