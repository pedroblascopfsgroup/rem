/*
--##########################################
--## AUTOR=Sergio Belenguer Gadea
--## FECHA_CREACION=20171127
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2.32
--## INCIDENCIA_LINK=HRNIVDOS-7126
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master

    V_SQL VARCHAR2(6000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_REG NUMBER;
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_BIE_ENTIDAD_ID NUMBER(16):= 87989;
    V_BIE_ID NUMBER(16):= 1000000000221503;
    
    
    V_SQL_UPDATE_2 VARCHAR2(6000 CHAR):= 'UPDATE '||V_ESQUEMA||'.BIE_BIEN SET BIE_ENTIDAD_ID = '||V_BIE_ENTIDAD_ID||', USUARIOMODIFICAR =''GC-3893'', FECHAMODIFICAR = SYSDATE WHERE BIE_ID = '||V_BIE_ID||'';
      
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] ... UPDATE ACT_ACTIVO');
    
	V_SQL := 'SELECT COUNT(ACT_NUM_ACTIVO) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO_UVEM = 29667517';
        
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REG;
        
	IF V_NUM_REG = 1 THEN 
		V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO 
			SET ACT_NUM_ACTIVO = 929667517, USUARIOMODIFICAR =  ''HRNIVDOS-7126'', FECHAMODIFICAR = SYSDATE WHERE ACT_NUM_ACTIVO_UVEM = 29667517';
	
            	EXECUTE IMMEDIATE V_SQL;
                
        ELSE
		DBMS_OUTPUT.PUT_LINE('No existe ningún activo con ACT_NUM_ACTIVO_UVEM: 29667517');   
	END IF;    

	V_SQL := 'SELECT COUNT(ACT_NUM_ACTIVO) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO_UVEM = 26414703';
        
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REG;
        
	IF V_NUM_REG = 1 THEN 
		V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO 
			SET ACT_NUM_ACTIVO = 951184, USUARIOMODIFICAR =  ''HRNIVDOS-7126'', FECHAMODIFICAR = SYSDATE WHERE ACT_NUM_ACTIVO_UVEM = 26414703';
	
            	EXECUTE IMMEDIATE V_SQL;
                
        ELSE
		DBMS_OUTPUT.PUT_LINE('No existe ningún activo con ACT_NUM_ACTIVO_UVEM: 26414703');   
	END IF;

	
    
        DBMS_OUTPUT.PUT_LINE('[FIN] ... UPDATE BIE_BIEN');
    
    --ROLLBACK;
    COMMIT;	
    
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/

EXIT;
