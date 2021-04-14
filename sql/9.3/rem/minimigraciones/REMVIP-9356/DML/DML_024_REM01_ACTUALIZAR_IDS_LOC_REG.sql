--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210331
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9356
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUALIZAR IDS TABLAS ACT_LOC_LOCALIZACION Y ACT_REG_INFO_REGISTRAL
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

    -- Esquemas
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    -- Errores
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    -- Usuario
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9356';
    -- Tablas
    V_TABLA_ACTIVO VARCHAR2(100 CHAR):= 'ACT_ACTIVO';
    V_TABLA_LOC  VARCHAR2(100 CHAR):= 'ACT_LOC_LOCALIZACION';
    V_TABLA_REG  VARCHAR2(100 CHAR):= 'ACT_REG_INFO_REGISTRAL';
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');	


       DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR IDS ACT_REG_INFO_REGISTRAL');
  	
  	 V_MSQL :='MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_REG ||' T1 USING 
			(SELECT ACT.ACT_ID,ACT.BIE_ID, ACT_REG.REG_ID, BIE_REG.BIE_DREG_ID
			FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
			INNER JOIN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES BIE_REG ON ACT.BIE_ID = BIE_REG.BIE_ID
			INNER JOIN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL ACT_REG ON ACT.ACT_ID = ACT_REG.ACT_ID
			WHERE BIE_REG.USUARIOCREAR = '''||V_USUARIO||''') T2
		ON (T1.ACT_ID = T2.ACT_ID AND T1.USUARIOCREAR = '''||V_USUARIO||''')
		WHEN MATCHED THEN UPDATE SET 
		T1.BIE_DREG_ID = T2.BIE_DREG_ID,
		T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
		T1.FECHAMODIFICAR = SYSDATE';

  	EXECUTE IMMEDIATE V_MSQL;

  	DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL ACTUALIZADOS. '||SQL%ROWCOUNT||' Filas.');
  	
  	 DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR IDS ACT_LOC_LOCALIZACION');
  	
  	 V_MSQL :='MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_LOC ||' T1 USING 
			(SELECT ACT.ACT_ID,ACT.BIE_ID, ACT_LOC.LOC_ID, BIE_LOC.BIE_LOC_ID
			FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
			INNER JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BIE_LOC ON ACT.BIE_ID = BIE_LOC.BIE_ID
			INNER JOIN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION ACT_LOC ON ACT.ACT_ID = ACT_LOC.ACT_ID
			WHERE BIE_LOC.USUARIOCREAR = '''||V_USUARIO||''') T2
		ON (T1.ACT_ID = T2.ACT_ID AND T1.USUARIOCREAR = '''||V_USUARIO||''')
		WHEN MATCHED THEN UPDATE SET 
		T1.BIE_LOC_ID = T2.BIE_LOC_ID,
		T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
		T1.FECHAMODIFICAR = SYSDATE';

  	EXECUTE IMMEDIATE V_MSQL;

  	DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION ACTUALIZADOS. '||SQL%ROWCOUNT||' Filas.');

        
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: IDS MODIFICADOS con éxito');

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
