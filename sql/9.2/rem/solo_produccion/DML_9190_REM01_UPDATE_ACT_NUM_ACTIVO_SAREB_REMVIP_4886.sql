--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190723
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4886
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
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-4886';

	ACT_NUM_ACTIVO NUMBER(16);
	ACT_NUM_ACTIVO_SAREB VARCHAR2(55 CHAR);

    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		  T_JBV(7071163,4006942)
		, T_JBV(7071174,4006941)
		, T_JBV(7071175,4006940)
		, T_JBV(7071205,4006943)
	); 
	V_TMP_JBV T_JBV;
BEGIN

 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
 
 V_TMP_JBV := V_JBV(I);
  			  ACT_NUM_ACTIVO := TRIM(V_TMP_JBV(1));
 			  ACT_NUM_ACTIVO_SAREB := TRIM(V_TMP_JBV(2));
			
	

		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
					 ACT_NUM_ACTIVO_SAREB = '''||ACT_NUM_ACTIVO_SAREB||'''
				   , USUARIOMODIFICAR = '''||V_USUARIO||'''
				   , FECHAMODIFICAR = SYSDATE
				   WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||'
					';


				EXECUTE IMMEDIATE V_SQL;
			    DBMS_OUTPUT.PUT_LINE('Actualizado ACT_NUM_ACTIVO_SAREB A '||ACT_NUM_ACTIVO_SAREB||' EN EL ACTIVO CON ID_HAYA '||ACT_NUM_ACTIVO);
				V_COUNT_UPDATE := V_COUNT_UPDATE + 1;

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
