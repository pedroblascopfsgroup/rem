--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20201301
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-6157
--## PRODUCTO=NO
--## 
--## Finalidad: Borrado superficie parcela
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-6157'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TABLA_AUX VARCHAR( 100 CHAR ) := 'AUX_REMVIP_6157';


    
BEGIN		
        ---------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO ACT_REG_INFO_REGISTRAL ');	
	

	V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.ACT_REG_INFO_REGISTRAL REG
		    USING( 
			   SELECT ACT.ACT_ID
			   FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,
				'||V_ESQUEMA||'.AUX_REMVIP_6157 AUX
			   WHERE 1 = 1
			   AND AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
			   AND ACT.BORRADO = 0 
			) AUX
		    ON ( AUX.ACT_ID = REG.ACT_ID )
		    WHEN MATCHED THEN UPDATE SET
		    REG_SUPERFICIE_PARCELA = 0,
		    FECHAMODIFICAR = SYSDATE,
		    USUARIOMODIFICAR = ''' || V_USR || '''' ;	
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan '||SQL%ROWCOUNT||' registros de ACT_REG_INFO_REGISTRAL'); 	
        ---------------------------------------------------------------------------------
   
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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
