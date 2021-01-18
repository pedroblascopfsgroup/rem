--/*
--#########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20200224
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-6471
--## PRODUCTO=NO
--## 
--## Finalidad:  Creación del SP SP_EXT_IN_DET_LLAVE
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1-Oscar Diestre-Versión inicial (20190718)
--##        0.2 - Juan Beltrán - Formatear fecha (20200224)
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE       SP_EXT_IN_DET_LLAVE (
         ACT_NUM_ACTIVO    	IN NUMBER,
	 ACT_LLAVES_FECHA_RECEP IN VARCHAR2,
	 ACT_LLAVES_HRE		IN NUMBER,
	 ACT_LLAVES_NECESARIAS	IN NUMBER,
	 ACT_LLAVES_NUM_JUEGOS  IN NUMBER,
         V_USUARIO         	  VARCHAR2 DEFAULT 'SP_EXT_IN_DET_LLAVE',
         COD_RETORNO    OUT NUMBER
) AS

--

V_SQL VARCHAR2(32000 CHAR); 											-- Sentencia a ejecutar.
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';		-- Configuracion Esquema.
ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
V_ACT_ID NUMBER( 16 );

BEGIN

   COD_RETORNO := 0;

	-- Existe el activo ??
   	V_SQL := 'SELECT COUNT( 1 ) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '|| ACT_NUM_ACTIVO ||' AND BORRADO = 0';

	EXECUTE IMMEDIATE V_SQL INTO V_ACT_ID;

	IF ( V_ACT_ID = 0 ) THEN

	 DBMS_OUTPUT.PUT_LINE('[INFO] No existe el Activo '|| ACT_NUM_ACTIVO ||' pasado por parámetros. El proceso finalizará.');
	 RETURN;

	END IF;

	-- Busca el id del activo
   	V_SQL := 'SELECT COALESCE( ACT_ID, 0 ) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '|| ACT_NUM_ACTIVO ||' AND BORRADO = 0';

	EXECUTE IMMEDIATE V_SQL INTO V_ACT_ID;
	DBMS_OUTPUT.PUT_LINE('[INFO] Existe el activo '|| ACT_NUM_ACTIVO ||' pasado por parámetro.');

--------------------------------------------------------------------------------


   -- Actualiza el registro en ACT_ACTIVO: 

	V_SQL := ' 
		UPDATE ' || V_ESQUEMA || '.ACT_ACTIVO
		SET ACT_LLAVES_FECHA_RECEP = TO_DATE('''|| ACT_LLAVES_FECHA_RECEP ||''',''dd/mm/yyyy'')  , 
		    ACT_LLAVES_HRE	   =   ' || ACT_LLAVES_HRE || '  ,	
		    ACT_LLAVES_NECESARIAS  =   ' || ACT_LLAVES_NECESARIAS || '  ,
		    ACT_LLAVES_NUM_JUEGOS  =   ' || ACT_LLAVES_NUM_JUEGOS || '  ,		
		    USUARIOMODIFICAR       = ''' || V_USUARIO || ''', 
			FECHAMODIFICAR         =  SYSDATE
	   WHERE ACT_ID = ' || V_ACT_ID ;

        EXECUTE IMMEDIATE V_SQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] - Actualizado '||SQL%ROWCOUNT||' registro en ACT_ACTIVO.');

   COMMIT;

       COD_RETORNO := 1;


EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ERR_NUM := SQLCODE;
      RAISE;
END SP_EXT_IN_DET_LLAVE;
/
EXIT
