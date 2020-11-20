--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20201111
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8193
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-8193'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TABLA_AUX VARCHAR( 100 CHAR ) := 'AUX_REMVIP_8193';
    V_COUNT NUMBER(16);	
    V_ID NUMBER(16);	


    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZAR REFERENCIAS CATASTRALES QUE TIENEN SOLO UN REGISTRO Y REFERENCIAS IGUALES');	
	

	V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.ACT_CAT_CATASTRO T1
		    USING( 
			SELECT  CAT.CAT_ID, ACT.ACT_ID,AUX.ACT_NUM_ACTIVO_UVEM,AUX.REF_CATASTRAL,CAT.CAT_REF_CATASTRAL, CAT.CAT_IND_INTERFAZ_BANKIA 
			FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
			INNER JOIN '|| V_ESQUEMA ||'.ACT_CAT_CATASTRO CAT ON ACT.ACT_ID = CAT.ACT_ID 
			INNER JOIN '|| V_ESQUEMA ||'.AUX_REMVIP_8193 AUX ON AUX.ACT_NUM_ACTIVO_UVEM = ACT.ACT_NUM_ACTIVO_UVEM AND AUX.REF_CATASTRAL = CAT.CAT_REF_CATASTRAL
			WHERE CAT.BORRADO = 0 
			AND ACT.ACT_ID IN (SELECT  ACT.ACT_ID
					    FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
					    INNER JOIN '|| V_ESQUEMA ||'.ACT_CAT_CATASTRO CAT ON ACT.ACT_ID = CAT.ACT_ID 
					    INNER JOIN '|| V_ESQUEMA ||'.AUX_REMVIP_8193 AUX ON AUX.ACT_NUM_ACTIVO_UVEM = ACT.ACT_NUM_ACTIVO_UVEM 
					    WHERE CAT.BORRADO = 0 
					    GROUP BY ACT.ACT_ID
					    HAVING COUNT (*)= 1)
			) T2
		    ON ( T1.CAT_ID = T2.CAT_ID )
		    WHEN MATCHED THEN UPDATE SET
		    T1.CAT_IND_INTERFAZ_BANKIA = 1,
		    T1.FECHAMODIFICAR = SYSDATE,
		    T1.USUARIOMODIFICAR = ''REMVIP-8193_1''' ;	
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se ACTUALIZAN '||SQL%ROWCOUNT||' registros de ACT_CAT_CATASTRO'); 
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZAR REFERENCIAS CATASTRALES QUE TIENEN SOLO UN REGISTRO Y REFERENCIAS DIFERENTES');	
	

	V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.ACT_CAT_CATASTRO T1
		    USING( 
			SELECT  CAT.CAT_ID, ACT.ACT_ID,AUX.ACT_NUM_ACTIVO_UVEM,AUX.REF_CATASTRAL,CAT.CAT_REF_CATASTRAL, CAT.CAT_IND_INTERFAZ_BANKIA 
			FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
			INNER JOIN '|| V_ESQUEMA ||'.ACT_CAT_CATASTRO CAT ON ACT.ACT_ID = CAT.ACT_ID 
			INNER JOIN '|| V_ESQUEMA ||'.AUX_REMVIP_8193 AUX ON AUX.ACT_NUM_ACTIVO_UVEM = ACT.ACT_NUM_ACTIVO_UVEM AND AUX.REF_CATASTRAL <> CAT.CAT_REF_CATASTRAL
			WHERE CAT.BORRADO = 0 
			AND ACT.ACT_ID IN (SELECT  ACT.ACT_ID
					    FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
					    INNER JOIN '|| V_ESQUEMA ||'.ACT_CAT_CATASTRO CAT ON ACT.ACT_ID = CAT.ACT_ID 
					    INNER JOIN '|| V_ESQUEMA ||'.AUX_REMVIP_8193 AUX ON AUX.ACT_NUM_ACTIVO_UVEM = ACT.ACT_NUM_ACTIVO_UVEM 
					    WHERE CAT.BORRADO = 0 
					    GROUP BY ACT.ACT_ID
					    HAVING COUNT (*)= 1)
			) T2
		    ON ( T1.CAT_ID = T2.CAT_ID )
		    WHEN MATCHED THEN UPDATE SET
		    T1.CAT_IND_INTERFAZ_BANKIA = 1,
		    T1.CAT_REF_CATASTRAL = T2.REF_CATASTRAL,
		    T1.FECHAMODIFICAR = SYSDATE,
		    T1.USUARIOMODIFICAR = ''REMVIP-8193_2''' ;	
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se ACTUALIZAN '||SQL%ROWCOUNT||' registros de ACT_CAT_CATASTRO'); 
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZAR REFERENCIAS CATASTRALES QUE TIENEN MAS DE UN REGISTRO Y REFERENCIAS DIFERENTES');	
	
	V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.ACT_CAT_CATASTRO T1
		    USING( 
			SELECT  CAT.CAT_ID, ACT.ACT_ID,AUX.ACT_NUM_ACTIVO_UVEM,AUX.REF_CATASTRAL,CAT.CAT_REF_CATASTRAL, CAT.CAT_IND_INTERFAZ_BANKIA 
			FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
			INNER JOIN '|| V_ESQUEMA ||'.ACT_CAT_CATASTRO CAT ON ACT.ACT_ID = CAT.ACT_ID 
			INNER JOIN '|| V_ESQUEMA ||'.AUX_REMVIP_8193 AUX ON AUX.ACT_NUM_ACTIVO_UVEM = ACT.ACT_NUM_ACTIVO_UVEM AND AUX.REF_CATASTRAL <> CAT.CAT_REF_CATASTRAL
			WHERE CAT.BORRADO = 0 AND CAT_IND_INTERFAZ_BANKIA = 1
			AND ACT.ACT_ID IN (SELECT  ACT.ACT_ID
					    FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
					    INNER JOIN '|| V_ESQUEMA ||'.ACT_CAT_CATASTRO CAT ON ACT.ACT_ID = CAT.ACT_ID 
					    INNER JOIN '|| V_ESQUEMA ||'.AUX_REMVIP_8193 AUX ON AUX.ACT_NUM_ACTIVO_UVEM = ACT.ACT_NUM_ACTIVO_UVEM 
					    WHERE CAT.BORRADO = 0 
					    GROUP BY ACT.ACT_ID
					    HAVING COUNT (*)> 1)
			) T2
		    ON ( T1.CAT_ID = T2.CAT_ID )
		    WHEN MATCHED THEN UPDATE SET
		    T1.CAT_IND_INTERFAZ_BANKIA = 0,
		    T1.FECHAMODIFICAR = SYSDATE,
		    T1.USUARIOMODIFICAR = ''REMVIP-8193_3''' ;	
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se ACTUALIZAN '||SQL%ROWCOUNT||' registros de ACT_CAT_CATASTRO'); 
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZAR REFERENCIAS CATASTRALES QUE TIENEN MAS DE UN REGISTRO Y REFERENCIAS IGUALES');	
	
	V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.ACT_CAT_CATASTRO T1
		    USING( 
			SELECT  CAT.CAT_ID, ACT.ACT_ID,AUX.ACT_NUM_ACTIVO_UVEM,AUX.REF_CATASTRAL,CAT.CAT_REF_CATASTRAL, CAT.CAT_IND_INTERFAZ_BANKIA 
			FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
			INNER JOIN '|| V_ESQUEMA ||'.ACT_CAT_CATASTRO CAT ON ACT.ACT_ID = CAT.ACT_ID 
			INNER JOIN '|| V_ESQUEMA ||'.AUX_REMVIP_8193 AUX ON AUX.ACT_NUM_ACTIVO_UVEM = ACT.ACT_NUM_ACTIVO_UVEM AND AUX.REF_CATASTRAL = CAT.CAT_REF_CATASTRAL
			WHERE CAT.BORRADO = 0 AND CAT_IND_INTERFAZ_BANKIA = 0
			AND ACT.ACT_ID IN (SELECT  ACT.ACT_ID
					    FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
					    INNER JOIN '|| V_ESQUEMA ||'.ACT_CAT_CATASTRO CAT ON ACT.ACT_ID = CAT.ACT_ID 
					    INNER JOIN '|| V_ESQUEMA ||'.AUX_REMVIP_8193 AUX ON AUX.ACT_NUM_ACTIVO_UVEM = ACT.ACT_NUM_ACTIVO_UVEM 
					    WHERE CAT.BORRADO = 0 
					    GROUP BY ACT.ACT_ID
					    HAVING COUNT (*)> 1)
			) T2
		    ON ( T1.CAT_ID = T2.CAT_ID )
		    WHEN MATCHED THEN UPDATE SET
		    T1.CAT_IND_INTERFAZ_BANKIA = 1,
		    T1.FECHAMODIFICAR = SYSDATE,
		    T1.USUARIOMODIFICAR = ''REMVIP-8193_4''' ;	
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se ACTUALIZAN '||SQL%ROWCOUNT||' registros de ACT_CAT_CATASTRO'); 

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
