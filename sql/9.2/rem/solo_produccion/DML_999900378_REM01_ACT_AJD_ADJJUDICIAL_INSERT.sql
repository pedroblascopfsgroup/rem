--/*
--#########################################
--## AUTOR=JINLI HU
--## FECHA_CREACION=20181021
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2207
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_AJD_ADJJUDICIAL';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_KOUNT NUMBER(16); -- Vble. para kontar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2212';

	ACT_ID NUMBER(16);
	BIE_ID NUMBER(16);
	BIE_ADJ_ID NUMBER(16);
	NUM_SECUENCIA_AJD NUMBER(16);

    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
							T_JBV('272566'),
							T_JBV('344058'),
							T_JBV('264332'),
							T_JBV('344064'),
							T_JBV('344059'),
							T_JBV('271490'),
							T_JBV('264337'),
							T_JBV('264338'),
							T_JBV('344056'),
							T_JBV('270651'),
							T_JBV('272421'),
							T_JBV('271486'),
							T_JBV('344062'),
							T_JBV('344057'),
							T_JBV('271489'),
							T_JBV('270645'),
							T_JBV('264340'),
							T_JBV('271485'),
							T_JBV('344055'),
							T_JBV('264336'),
							T_JBV('270646'),
							T_JBV('344061'),
							T_JBV('264339'),
							T_JBV('271484'),
							T_JBV('344060'),
							T_JBV('271487'),
							T_JBV('332434'),
							T_JBV('332428'),
							T_JBV('344065'),
							T_JBV('332429'),
							T_JBV('267496'),
							T_JBV('272568'),
							T_JBV('271491'),
							T_JBV('344063'),
							T_JBV('270649'),
							T_JBV('270647'),
							T_JBV('264331'),
							T_JBV('332431'),
							T_JBV('270650'),
							T_JBV('270644'),
							T_JBV('270653'),
							T_JBV('264341'),
							T_JBV('332424'),
							T_JBV('264335'),
							T_JBV('264334'),
							T_JBV('267497'),
							T_JBV('332426'),
							T_JBV('332427'),
							T_JBV('264333'),
							T_JBV('271488'),
							T_JBV('270648'),
							T_JBV('332433'),
							T_JBV('272563'),
							T_JBV('271492'),
							T_JBV('270652'));
	V_TMP_JBV T_JBV;
	
BEGIN

	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	ACT_ID := TRIM(V_TMP_JBV(1));
  	
  	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_ID = '||ACT_ID INTO V_COUNT;
  			  
  	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_ID = '||ACT_ID INTO V_KOUNT;
  			  
	IF V_COUNT = 1 AND V_KOUNT = 0 THEN 
	
		EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_ACT_AJD_ADJJUDICIAL.NEXTVAL FROM DUAL' INTO NUM_SECUENCIA_AJD;
		EXECUTE IMMEDIATE 'SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_ID = '||ACT_ID INTO BIE_ID;
		EXECUTE IMMEDIATE 'SELECT BIE_ADJ_ID FROM '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION WHERE BIE_ID = '||BIE_ID INTO BIE_ADJ_ID;

		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (ACT_ID, AJD_ID, BIE_ADJ_ID, USUARIOCREAR, FECHACREAR, VERSION, BORRADO)
				  SELECT '''||ACT_ID||''', 
						 '''||NUM_SECUENCIA_AJD||''',
						 '''||BIE_ADJ_ID||''',
						 '''||V_USUARIO||''',
						 SYSDATE,
						 0,
						 0
				  FROM DUAL';
		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('INSERTADO UN REGISTRO CON ACT_ID '||ACT_ID||' EN '||V_TABLA);
		
		V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
	
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] El registro con ACT_ID '||ACT_ID||' ya existe en '||V_TABLA||' o no existe en ACT_ACTIVO');
		
	END IF;
	
	END LOOP;			    
    
	COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado en total '||V_COUNT_UPDATE||' registros en la tabla '||V_TABLA);

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
