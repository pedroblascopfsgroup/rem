--/*
--#########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180329
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=REMVIP-384
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_ACTIVO';
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-384';

	ACT_NUM_ACTIVO NUMBER(16);
	ACT_NUM_ACTIVO_UVEM NUMBER(16);

    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		  T_JBV(195113, 27502989)
		, T_JBV(194834, 24664047)
		, T_JBV(196897, 27503064)
		, T_JBV(188552, 27503298)
		, T_JBV(195114, 24664164)
		, T_JBV(195145, 24664281)
		, T_JBV(195146, 27503316)
		, T_JBV(195311, 27503433)
		, T_JBV(188551, 27503550)
		, T_JBV(195003, 27503667)
	V_TMP_JBV T_JBV;


BEGIN

EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
		   ACT_NUM_ACTIVO_SAREB = 882282
		   WHERE ACT_NUM_ACTIVO = 6774275
		   AND ACT_NUM_ACTIVO SAREB = 882283
    ';


EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
		   ACT_NUM_ACTIVO = 200077
		   ACT_NUM_ACTIVO_SAREB = 538466
		   WHERE ACT_NUM_ACTIVO = 6836951
		   AND ACT_NUM_ACTIVO_REM = 72866
    ';
 
 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
 
 V_TMP_JBV := V_JBV(I);
 			  ACT_NUM_ACTIVO	  := TRIM(V_TMP_JBV(1));
 			  ACT_NUM_ACTIVO_UVEM := TRIM(V_TMP_JBV(2));
 			  
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
				  BORRADO = 1 WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||'
				';


		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
				  ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||'
				  WHERE ACT_NUM_ACTIVO_UVEM = '||ACT_NUM_ACTIVO_UVEM||'
				  
				';

		EXECUTE IMMEDIATE V_SQL
			


 END LOOP;

    
	COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');

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
