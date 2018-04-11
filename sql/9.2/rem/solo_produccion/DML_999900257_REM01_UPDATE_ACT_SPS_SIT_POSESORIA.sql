--/*
--##########################################
--## AUTOR=SIMEON SHOPOV 
--## FECHA_CREACION=20180227
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-172
--## PRODUCTO=NO
--##
--## Finalidad: Poner las fechas de posesión a null y que han sido editadas a 1 para que no se autocalcule en la web
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
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_SPS_SIT_POSESORIA';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-172';
    
    ACT_NUM_ACTIVO NUMBER(16);
    
    TYPE T_JBV IS TABLE OF VARCHAR2(4000);
 	TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 

 	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		  T_JBV(6823384)
		, T_JBV(6135292)
		, T_JBV(6080699)
		
	 	);   
    V_TMP_JBV T_JBV;
    
 BEGIN
 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
    V_TMP_JBV := V_JBV(I);
    
    ACT_NUM_ACTIVO := V_TMP_JBV(1);
    
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION SET
    				  BIE_ADJ_F_REA_POSESION = NULL
    				, USUARIOMODIFICAR 		 = '''||V_USUARIO||'''
    				, FECHAMODIFICAR 		 = SYSDATE
    				WHERE BIE_ID = (SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO
    				WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||')
    				';
    				
      EXECUTE IMMEDIATE V_SQL;
      
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
		 			  SPS_EDITA_FECHA_TOMA_POSESION = 1
		 			, SPS_FECHA_TOMA_POSESION		= NULL
		 			, USUARIOMODIFICAR 	     		= '''||V_USUARIO||'''
		 			, FECHAMODIFICAR         		= SYSDATE
					WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO
					WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||') 
				  ';
				  
  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] Se ha borrado la fecha de toma de posesión del activo '||ACT_NUM_ACTIVO);
  
  V_COUNT_INSERT := V_COUNT_INSERT + 1;
  
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('[INFO] Se han borrado '||V_COUNT_INSERT||' fechas de toma de posesión en la tabla '||V_TABLA);
  
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
