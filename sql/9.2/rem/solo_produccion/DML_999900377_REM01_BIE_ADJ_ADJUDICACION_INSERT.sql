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
    V_TABLA VARCHAR2(25 CHAR):= 'BIE_ADJ_ADJUDICACION';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_KOUNT NUMBER(16); -- Vble. para kontar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2212';

	BIE_ID NUMBER(16);
	NUM_SECUENCIA_ADJ NUMBER(16);

    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
						T_JBV('273446'),
						T_JBV('344938'),
						T_JBV('265212'),
						T_JBV('344944'),
						T_JBV('344939'),
						T_JBV('272370'),
						T_JBV('265217'),
						T_JBV('265218'),
						T_JBV('344936'),
						T_JBV('271531'),
						T_JBV('273301'),
						T_JBV('272366'),
						T_JBV('344942'),
						T_JBV('344937'),
						T_JBV('272369'),
						T_JBV('271525'),
						T_JBV('265220'),
						T_JBV('272365'),
						T_JBV('344935'),
						T_JBV('265216'),
						T_JBV('271526'),
						T_JBV('344941'),
						T_JBV('265219'),
						T_JBV('272364'),
						T_JBV('344940'),
						T_JBV('272367'),
						T_JBV('333314'),
						T_JBV('333308'),
						T_JBV('344945'),
						T_JBV('333309'),
						T_JBV('268376'),
						T_JBV('273448'),
						T_JBV('272371'),
						T_JBV('344943'),
						T_JBV('271529'),
						T_JBV('271527'),
						T_JBV('265211'),
						T_JBV('333311'),
						T_JBV('271530'),
						T_JBV('271524'),
						T_JBV('271533'),
						T_JBV('265221'),
						T_JBV('333304'),
						T_JBV('265215'),
						T_JBV('265214'),
						T_JBV('268377'),
						T_JBV('333306'),
						T_JBV('333307'),
						T_JBV('265213'),
						T_JBV('272368'),
						T_JBV('271528'),
						T_JBV('333313'),
						T_JBV('273443'),
						T_JBV('272372'),
						T_JBV('271532'));
	V_TMP_JBV T_JBV;
	
BEGIN

	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	BIE_ID := TRIM(V_TMP_JBV(1));
  	
  	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE BIE_ID = '||BIE_ID INTO V_COUNT;
  			  
  	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE BIE_ID = '||BIE_ID INTO V_KOUNT;
  			  
	IF V_COUNT = 1 AND V_KOUNT = 0 THEN 
	
		EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_BIE_ADJ_ADJUDICACION.NEXTVAL FROM DUAL' INTO NUM_SECUENCIA_ADJ;

		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (BIE_ID, BIE_ADJ_ID, USUARIOCREAR, FECHACREAR, VERSION, BORRADO)
				  SELECT '''||BIE_ID||''', 
						 '''||NUM_SECUENCIA_ADJ||''',
						 '''||V_USUARIO||''',
						 SYSDATE,
						 0,
						 0
				  FROM DUAL';
		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('INSERTADO UN REGISTRO CON BIE_ID '||BIE_ID||' EN '||V_TABLA);
		
		V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
	
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] El registro con BIE_ID '||BIE_ID||' ya existe en '||V_TABLA||' o no existe en ACT_ACTIVO');
		
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
