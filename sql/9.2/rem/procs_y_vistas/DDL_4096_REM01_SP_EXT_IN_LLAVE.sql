--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190718
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4833
--## PRODUCTO=NO
--## 
--## Finalidad:  Creación del SP SP_EXT_IN_LLAVE
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1-Oscar Diestre-Versión inicial (20190718)
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE       SP_EXT_IN_LLAVE (
         ACT_NUM_ACTIVO    	IN NUMBER,
	 LLV_NUM_LLAVE     	IN VARCHAR2,
	 LLV_COD_CENTRO    	IN VARCHAR2,
	 LLV_NOMBRE_CENTRO 	IN VARCHAR2,
	 LLV_ARCHIVO1	   	IN VARCHAR2,
	 LLV_ARCHIVO2	   	IN VARCHAR2,
	 LLV_ARCHIVO3 	   	IN VARCHAR2,
	 LLV_COMPLETO	       	IN NUMBER,
	 LLV_MOTIVO_INCOMPLETO 	IN VARCHAR2,
         V_USUARIO         	  VARCHAR2 DEFAULT 'SP_EXT_IN_LLAVE',
         COD_RETORNO    OUT NUMBER
) AS

--

V_SQL VARCHAR2(32000 CHAR); 											-- Sentencia a ejecutar.
V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; 								-- Configuracion Esquema.
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

   -- Crea el registro en ACT_LLV_LLAVE: 

	V_SQL := ' INSERT INTO ' || V_ESQUEMA || '.ACT_LLV_LLAVE
               ( 
                 LLV_ID,
                 ACT_ID,
                 LLV_COD_CENTRO,
                 LLV_NOMBRE_CENTRO,
                 LLV_ARCHIVO1,
                 LLV_ARCHIVO2,
                 LLV_ARCHIVO3,
                 LLV_COMPLETO,
                 LLV_MOTIVO_INCOMPLETO,
                 LLV_NUM_LLAVE,
                 VERSION,
                 USUARIOCREAR,
                 FECHACREAR,
                 BORRADO
                )
                VALUES
                (
                 S_ACT_LLV_LLAVE.NEXTVAL,
                 ' || V_ACT_ID ||',
                 ''' || LLV_COD_CENTRO         || ''',
                 ''' || LLV_NOMBRE_CENTRO      || ''',
                 ''' || LLV_ARCHIVO1           || ''',
                 ''' || LLV_ARCHIVO2           || ''',
                 ''' || LLV_ARCHIVO3           || ''',
                   ' || LLV_COMPLETO           ||   ',
                 ''' || LLV_MOTIVO_INCOMPLETO  || ''',
                 ''' || LLV_NUM_LLAVE          || ''',
                 0,
                 ''' || V_USUARIO || ''',
                 SYSDATE,
                 0
                 )';

        EXECUTE IMMEDIATE V_SQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] - Creado '||SQL%ROWCOUNT||' registro en ACT_LLV_LLAVE.');

   COMMIT;

       COD_RETORNO := 1;


EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ERR_NUM := SQLCODE;
      RAISE;
END SP_EXT_IN_LLAVE;
/
EXIT
