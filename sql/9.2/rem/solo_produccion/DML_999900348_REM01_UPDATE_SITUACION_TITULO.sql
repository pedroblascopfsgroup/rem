--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20181009
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1520
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
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_TIT_TITULO';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_KOUNT NUMBER(16); -- Vble. para kontar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-1520';

	ACT_NUM_ACTIVO NUMBER(16);
	ACT_ID VARCHAR2(55 CHAR);

    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		       	   T_JBV(7014664)
			 , T_JBV(6945281)
			 , T_JBV(6945283)
			 , T_JBV(6945284)
			 , T_JBV(6945290)
			 , T_JBV(6945291)
			 , T_JBV(6945293)
			 , T_JBV(6945295)
			 , T_JBV(6945296)
			 , T_JBV(6945297)
			 , T_JBV(6945300)
			 , T_JBV(6945309)
			 , T_JBV(6945317)
			 , T_JBV(6945320)
			 , T_JBV(6945321)
			 , T_JBV(6945323)
			 , T_JBV(6945324)
			 , T_JBV(6945325)
			 , T_JBV(6945327)
			 , T_JBV(6945328)
			 , T_JBV(6945331)
			 , T_JBV(6945334)
			 , T_JBV(6945336)
			 , T_JBV(6945338)
			 , T_JBV(6945339)
			 , T_JBV(6945340)
			 , T_JBV(6945341)
			 , T_JBV(6945342)
			 , T_JBV(6945343)
			 , T_JBV(6945344)
			 , T_JBV(6945346)
			 , T_JBV(6945354)
			 , T_JBV(6945350)
			 , T_JBV(6945355)
			 , T_JBV(6945357)
			 , T_JBV(6945359)
			 , T_JBV(6945360)
			 , T_JBV(6945364)
			 , T_JBV(6945365)
			 
	); 
	V_TMP_JBV T_JBV;
BEGIN


 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
 
 V_TMP_JBV := V_JBV(I);
  			  ACT_NUM_ACTIVO := TRIM(V_TMP_JBV(1));
  			  
  			  EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO INTO V_KOUNT;
  			  
  			  IF V_KOUNT > 0 THEN 
 			  EXECUTE IMMEDIATE 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO INTO ACT_ID;


		EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_ID = '||ACT_ID INTO V_COUNT;

		IF V_COUNT > 0 THEN
			V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
					     DD_ETI_ID = 1
					   , USUARIOMODIFICAR = '''||V_USUARIO||'''
					   , FECHAMODIFICAR = SYSDATE
					   WHERE ACT_ID = '||ACT_ID||'
						';
			EXECUTE IMMEDIATE V_SQL;
			DBMS_OUTPUT.PUT_LINE('aCTUALIZADO EL '||ACT_NUM_ACTIVO);
		END IF;

				V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
END IF;
 END LOOP;			    
    
	COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han updateado en total '||V_COUNT_UPDATE||' registros');

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
