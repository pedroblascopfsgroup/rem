--/*
--#########################################
--## AUTOR=Pablo Meseguer 
--## FECHA_CREACION=20160621
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-637
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar el campo AGR_NUM_AGRUP_REM en los registros de ACT_AGR_AGRUPACION que sean posteriores a migración.
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  V_NUM_UPDATES NUMBER(16) := 0; -- Vble. para almacenar los updates realizados.
  V_SEC NUMBER(16);     
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_AGR_AGRUPACION');
    
    V_SQL :='
		MERGE INTO '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR
		USING
		(
			   SELECT AGR_NUM_AGRUP_REM, AGR_ID FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION
			   WHERE USUARIOCREAR != ''MIG''
		)TMP
		ON (AGR.AGR_ID = TMP.AGR_ID)
		WHEN MATCHED THEN UPDATE 
		SET 
		AGR.AGR_NUM_AGRUP_REM = TMP.AGR_NUM_AGRUP_REM+1000,
		AGR.USUARIOMODIFICAR = ''HREOS-637'',
		AGR.FECHAMODIFICAR = SYSDATE
		'
		;
		
    EXECUTE IMMEDIATE V_SQL;     
    
    V_NUM_UPDATES := sql%rowcount;
    
	--AVANZAMOS LA SECUENCIA S_AGR_NUM_AGRUP_REM 
	
	EXECUTE IMMEDIATE '
	SELECT '||V_ESQUEMA||'.S_AGR_NUM_AGRUP_REM.NEXTVAL FROM DUAL
	'
	INTO V_SEC
	;
		
	WHILE V_SEC < 1200
	LOOP 
	
		EXECUTE IMMEDIATE '
		SELECT '||V_ESQUEMA||'.S_AGR_NUM_AGRUP_REM.NEXTVAL FROM DUAL
		'
		INTO V_SEC
		;
	
	END LOOP;
	
        
    COMMIT;
  
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.ACT_AGR_AGRUPACION COMPUTE STATISTICS');
  
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_AGR_AGRUPACION ANALIZADA.');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN ACTUALIZADO '||V_NUM_UPDATES||' REGISTROS EN ACT_AGR_AGRUPACION.');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] EL ULTIMO NUMERO DE SECUENCIA DE AGR_NUM_AGRUP_REM ES '||V_SEC||'.');
      
    DBMS_OUTPUT.PUT_LINE('[FIN] LA TABLA ACT_AGR_AGRUPACION SE HA ACTUALIZADO CORRECTAMENTE Y LA SECUENCIA SE HA REESTABLECIDO CORRECTAMENTE');
 
 
EXCEPTION

   WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);

        ROLLBACK;
        RAISE;          

END;

/

EXIT
