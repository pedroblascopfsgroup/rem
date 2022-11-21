--/*
--#########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20221028
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## ARTEFACTO=batch
--## INCIDENCIA_LINK=HREOS-18888
--## PRODUCTO=NO
--## 
--## Finalidad:
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

V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-18888';
V_SQL VARCHAR2(2500 CHAR) := '';
V_NUM NUMBER(25);

V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_HREOS_18888';
V_TABLA VARCHAR2 (30 CHAR) := 'CVA_CUENTAS_VIRTUALES_ALQUILER';
V_SENTENCIA VARCHAR2(2600 CHAR);


BEGIN


	--INSERT EN CVA_CUENTAS_VIRTUALES_ALQUILER

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.CVA_CUENTAS_VIRTUALES_ALQUILER CVA
                using (
                        SELECT 					 
                                AUX.AUX_CVA_CUENTA_VIRTUAL AS CVA_CUENTA_VIRTUAL
                                ,(SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = AUX.AUX_DD_SCR_CODIGO) AS DD_SCR_ID		
                                
                        FROM '||V_ESQUEMA||'.AUX_HREOS_18888 AUX
                ) us ON (us.CVA_CUENTA_VIRTUAL = CVA.CVA_CUENTA_VIRTUAL AND us.DD_SCR_ID = CVA.DD_SCR_ID)
                        WHEN NOT MATCHED THEN
                        INSERT  (CVA_ID, 
                                CVA_CUENTA_VIRTUAL,
                                DD_SCR_ID,                                                                                                              
                                USUARIOCREAR,
                                FECHACREAR
                                )
                        VALUES ('||V_ESQUEMA||'.S_CVA_CUENTAS_VIRTUALES_ALQUILER.NEXTVAL,
                                us.CVA_CUENTA_VIRTUAL,
                                us.DD_SCR_ID,                                                                      
                                '''||V_USUARIO||''',
                                SYSDATE)';
      EXECUTE IMMEDIATE V_SQL;
			
  COMMIT;
 
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
