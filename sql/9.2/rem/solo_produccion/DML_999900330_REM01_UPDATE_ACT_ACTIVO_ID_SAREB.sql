--/*
--##########################################
--## AUTOR=PIER GOTTA 
--## FECHA_CREACION=20180919
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1944
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar el ACT_NUM_ACTIVO_SAREB erróneos
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_ACTIVO';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-1944';
    
    ACT_NUM_ACTIVO NUMBER(16);
    ACT_RECOVERY_ID_MALO NUMBER(16);
    ACT_RECOVERY_ID_BUENO NUMBER(16);
    
    TYPE T_JBV IS TABLE OF VARCHAR2(4000);
 	TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 

 	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		  T_JBV(150868,1149748,1000000000208750)
		, T_JBV(188747,1054544,1000000000215541)
	 	);   
    V_TMP_JBV T_JBV;
    
    
 BEGIN
 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
    V_TMP_JBV := V_JBV(I);
    
    ACT_NUM_ACTIVO 	      := V_TMP_JBV(1);
    ACT_RECOVERY_ID_MALO := V_TMP_JBV(2);
    ACT_RECOVERY_ID_BUENO := V_TMP_JBV(3);
    
    IF ACT_RECOVERY_ID_MALO IS NOT NULL THEN
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
		 			  ACT_RECOVERY_ID   = '||ACT_RECOVERY_ID_BUENO||'
		 			, USUARIOMODIFICAR 	     = '''||V_USUARIO||'''
		 			, FECHAMODIFICAR         = SYSDATE
					WHERE ACT_NUM_ACTIVO 	 = '||ACT_NUM_ACTIVO||' 
					AND ACT_RECOVERY_ID = '||ACT_RECOVERY_ID_MALO||'
				  ';
	ELSE
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
		 			  ACT_RECOVERY_ID   = '||ACT_RECOVERY_ID_BUENO||'
		 			, USUARIOMODIFICAR 	     = '''||V_USUARIO||'''
		 			, FECHAMODIFICAR         = SYSDATE
					WHERE ACT_NUM_ACTIVO 	 = '||ACT_NUM_ACTIVO||' 
				  ';
	END IF;	  
	
  EXECUTE IMMEDIATE V_SQL;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] Se ha cambiado el activo '||ACT_NUM_ACTIVO||' su ACT_RECOVERY_ID_BUENO por '||ACT_RECOVERY_ID_BUENO);
  
  V_COUNT_INSERT := V_COUNT_INSERT + 1;
  
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('[INFO] Se han cambiado en total '||V_COUNT_INSERT||' registros en la tabla '||V_TABLA);
  
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
