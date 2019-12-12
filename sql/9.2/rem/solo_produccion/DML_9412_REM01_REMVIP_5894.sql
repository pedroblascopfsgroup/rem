--/*
--#########################################
--## AUTOR=Oscar Diestre Pérez
--## FECHA_CREACION=20191204
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5894
--## PRODUCTO=NO
--## 
--## Finalidad: Carga masiva de aprobación del informe comercial
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-5894'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TABLA_AUX VARCHAR( 100 CHAR ) := 'AUX_REMVIP_5894';
    V_COUNT NUMBER(16);	
    V_ID NUMBER(16);	


    
BEGIN		
        ---------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] BORRANDO REFERENCIAS CATASTRALES ACTUALES ');	
	

	V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.ACT_CAT_CATASTRO CAT
		    USING( 

			   SELECT DISTINCT ACT.ACT_ID
			   FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,
				'||V_ESQUEMA||'.AUX_REMVIP_5894 AUX
			   WHERE 1 = 1
			   AND AUX.ACT_NUM_ACTIVO_UVEM = ACT.ACT_NUM_ACTIVO_UVEM
			   AND ACT.BORRADO = 0 

			) AUX
		    ON ( AUX.ACT_ID = CAT.ACT_ID )
		    WHEN MATCHED THEN UPDATE SET
		    BORRADO = 1,
		    FECHABORRAR = SYSDATE,
		    USUARIOBORRAR = ''' || V_USR || '''
		    WHERE BORRADO = 0			
' ;	
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se borran '||SQL%ROWCOUNT||' registros de ACT_CAT_CATASTRO'); 	

        ---------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Creando las referencias nuevas en ACT_CAT_CATASTRO ');	
	
	V_MSQL := ' INSERT INTO '|| V_ESQUEMA ||'.ACT_CAT_CATASTRO 
		    ( 
			CAT_ID,
			ACT_ID,
			CAT_REF_CATASTRAL,
			VERSION,
			BORRADO,
			USUARIOCREAR,
			FECHACREAR
		    )
	    		SELECT     
		        '|| V_ESQUEMA ||'.S_ACT_CAT_CATASTRO.NEXTVAL,
			ACT.ACT_ID,
			AUX.CAT_REF_CATASTRAL,
			0,
			0,
			''' || V_USR || ''',
			SYSDATE
			FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT,
		             '|| V_ESQUEMA ||'.AUX_REMVIP_5894 AUX
			WHERE 1 = 1			   
			AND AUX.ACT_NUM_ACTIVO_UVEM = ACT.ACT_NUM_ACTIVO_UVEM
			AND ACT.BORRADO = 0 ' ;


	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se crean '||SQL%ROWCOUNT||' registros de ACT_CAT_CATASTRO'' '); 

   
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
