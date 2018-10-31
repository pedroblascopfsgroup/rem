--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181026
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2384
--## PRODUCTO=NO
--## 
--## Finalidad: Borrado logico de activos, agrupacion y la relacion agrupacion-activos
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
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_KOUNT NUMBER(16); -- Vble. para kontar.
    V_COUNT_BORRADO NUMBER(16):= 0; -- Vble. para contar borrados lógicos
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2384';
    
    ACT_NUM_ACTIVO NUMBER(16);
    ACT_NUM_ACTIVO_REM NUMBER(16);
    ACT_RECOVERY_ID NUMBER(16);
    
    TYPE T_JBV IS TABLE OF VARCHAR2(4000);
 	TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 

 	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
 	  	  T_JBV(6747264)
		, T_JBV(6747270)
		, T_JBV(6747262)
		, T_JBV(6747263)
		, T_JBV(6747272)
		, T_JBV(6747265)
		, T_JBV(6747268)
		, T_JBV(6747267)
		, T_JBV(6747269)
		, T_JBV(6747266)
		, T_JBV(6747271)
		, T_JBV(6747274)
		, T_JBV(6747275)
		, T_JBV(6747273)
		, T_JBV(6747276)
		, T_JBV(6747277)
	 	);   
    V_TMP_JBV T_JBV;
    
    
 BEGIN
 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
    V_TMP_JBV := V_JBV(I);
    
    ACT_NUM_ACTIVO 	   := V_TMP_JBV(1);

    --verificamos que no tienen ofertas o trabajos 
    
    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_OFR AO
    					JOIN '||V_ESQUEMA||'.'||V_TABLA||' ACT ON ACT.ACT_ID = AO.ACT_ID 
    					WHERE ACT.ACT_NUM_ACTIVO   = '||ACT_NUM_ACTIVO||'
    					' INTO V_COUNT;
    					
    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_TBJ AT
    					JOIN '||V_ESQUEMA||'.'||V_TABLA||' ACT ON ACT.ACT_ID = AT.ACT_ID 
    					WHERE ACT.ACT_NUM_ACTIVO   = '||ACT_NUM_ACTIVO||'
    					' INTO V_KOUNT;
	
	IF V_COUNT = 0 AND V_KOUNT = 0 THEN
	
		EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
							  BORRADO = 1 
							, FECHABORRAR = SYSDATE 
							, USUARIOBORRAR = '''||V_USUARIO||''' 
							WHERE ACT_NUM_ACTIVO   = '||ACT_NUM_ACTIVO||' 
							';

		V_COUNT_BORRADO := V_COUNT_BORRADO + 1;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] El activo duplicado con ACT_NUM_ACTIVO '||ACT_NUM_ACTIVO||' se ha borrado');
	ELSE
  		DBMS_OUTPUT.PUT_LINE('[INFO] El activo con ACT_NUM_ACTIVO '||ACT_NUM_ACTIVO||' tiene oferatas o trabajos, no se va a eliminar');	
	END IF;
  
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('[INFO] Se han eliminado en total '||V_COUNT_BORRADO||' registros en la tabla '||V_TABLA);

		EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO SET 
							  BORRADO = 1 
							, FECHABORRAR = SYSDATE 
							, USUARIOBORRAR = '''||V_USUARIO||''' 
							WHERE AGR_ID   = (SELECT AGR_ID FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION  WHERE AGR_NUM_AGRUP_REM = ''1000006801'') 
							';

  DBMS_OUTPUT.PUT_LINE('[INFO] Se han puesto a borrado a 1 las relaciones de los activos y la agrupacion ');

		EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ACT_AGR_AGRUPACION SET 
							  BORRADO = 1 
							, FECHABORRAR = SYSDATE 
							, USUARIOBORRAR = '''||V_USUARIO||''' 
							WHERE AGR_NUM_AGRUP_REM = ''1000006801'' 
							';

  DBMS_OUTPUT.PUT_LINE('[INFO] Se han puesto a borrado a 1 la agrupacion 1000006801');

  
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
