--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190402
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0
--## INCIDENCIA_LINK=HREOS-5915
--## PRODUCTO=NO
--## 
--## Finalidad:  Se cambia el propietario de los activos indicados a la sociedad Global Licata.
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

  V_ESQUEMA VARCHAR2(30 CHAR):= 'REM01'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(30 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  USUARIO_MIGRACION VARCHAR2(50 CHAR):= 'MIG_APPLE';

BEGIN
      
      DBMS_OUTPUT.PUT_LINE('[INICIO] Cambiamos el propietario de 49 activos de APPLE a Global Licata');

      -------------------------------------------------
      --MERGE EN ACT_PAC_PROPIETARIO_ACTIVO--
      -------------------------------------------------   
      DBMS_OUTPUT.PUT_LINE('	[INFO] MERGE EN ACT_PAC_PROPIETARIO_ACTIVO');

      
      V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO T1
				USING (
					SELECT ACT.ACT_NUM_ACTIVO,
						   ACT.ACT_ID,
						   PAC.PAC_ID,
						   ACT.USUARIOCREAR, 
						   PRO.PRO_ID
					FROM '||V_ESQUEMA||'.ACT_ACTIVO           			ACT
					JOIN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO 	PAC ON PAC.ACT_ID = ACT.ACT_ID
					JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO        	PRO ON PRO.PRO_CODIGO_UVEM = ''101010'' AND PRO.PRO_DOCIDENTIF = ''A88203542''
					WHERE ACT_NUM_ACTIVO IN 
					(
						7053307,
						7053304,
						7053303,
						7053302,
						7053297,
						7040694,
						7040691,
						7040689,
						7040686,
						7040684,
						7040681,
						7040670,
						7040667,
						7040662,
						7040659,
						7040658,
						7040656,
						7040649,
						7040640,
						7040638,
						7040621,
						7040620,
						7040608,
						7040585,
						7040584,
						7040582,
						7040581,
						7040579,
						7040576,
						7040566,
						7040561,
						7040556,
						7040552,
						7040550,
						7040548,
						7040545,
						7040544,
						7040543,
						7040541,
						7040540,
						7040537,
						7040535,
						7040532,
						7040531,
						7040528,
						7040527,
						7036928,
						7036897,
						7035907
					)		
				) T2
				ON (T1.PAC_ID = T2.PAC_ID AND T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.PRO_ID = T2.PRO_ID,
					T1.USUARIOMODIFICAR = ''MIG_APPLE_POST'',
					T1.FECHAMODIFICAR = SYSDATE
      ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] Se marca el check de SUBROGADO de '||V_NUM_TABLAS||' activos de alquiler de APPLE.');  
    
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('[FIN]');   
       
EXCEPTION
      WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
            DBMS_OUTPUT.put_line('-----------------------------------------------------------');
            DBMS_OUTPUT.put_line(SQLERRM);
            ROLLBACK;
            RAISE;
END;
/
EXIT;
