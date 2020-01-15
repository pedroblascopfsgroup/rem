--/*
--#########################################
--## AUTOR=Mª José Ponce
--## FECHA_CREACION=20200113
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-9065
--## PRODUCTO=NO
--## 
--## Finalidad:  Creación del SP SP_EXT_IN_LLAVE
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1-Oscar Diestre-Versión inicial REMVIP-4833(20190718)
--##        0.2-Modificar parámetros SP HREOS-9065
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE       SP_EXT_IN_LLAVE (
    ACT_NUM_ACTIVO    	      IN NUMBER,
	 LLV_NUM_LLAVE     	      IN VARCHAR2,
    DD_TTE_CODIGO_POSEEDOR    IN VARCHAR2,
    LLV_COD_TENEDOR_POSEEDOR  IN VARCHAR2,
    LLV_FECHA_ANILLADO        IN DATE,
    LLV_FECHA_RECEPCION       IN DATE,
    LLV_CODE                  IN VARCHAR2,
    LLV_COMPLETO              IN VARCHAR2,
    LLV_OBSERVACIONES         IN VARCHAR2,
      V_USUARIO         	  VARCHAR2 DEFAULT 'SP_EXT_IN_LLAVE',
      COD_RETORNO            OUT NUMBER
) AS

--v0.2

V_SQL VARCHAR2(32000 CHAR); 											-- Sentencia a ejecutar.
V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; 								-- Configuracion Esquema.
V_LLV_COD_TENEDOR_NO_PVE VARCHAR2(25 CHAR); --Vble. para rellenar registro de la tabla.
V_LLV_COD_TENEDOR_POSEEDOR VARCHAR2(25 CHAR); --Vble. para rellenar registro de la tabla.  
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

   IF (DD_TTE_CODIGO_POSEEDOR NOT IN('01', '02', '03', '04', '05', '06', '07')) THEN
   
    V_LLV_COD_TENEDOR_NO_PVE := LLV_COD_TENEDOR_POSEEDOR;
    V_LLV_COD_TENEDOR_POSEEDOR := '';

   ELSE

    V_SQL := 'SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '||LLV_COD_TENEDOR_POSEEDOR||' AND BORRADO = 0';
   EXECUTE IMMEDIATE V_SQL INTO V_LLV_COD_TENEDOR_POSEEDOR;

   END IF;

--------------------------------------------------------------------------------

   -- Crea el registro en ACT_LLV_LLAVE: 

	V_SQL := ' INSERT INTO ' || V_ESQUEMA || '.ACT_LLV_LLAVE
               ( 
                 LLV_ID,
                 ACT_ID,
                 LLV_NUM_LLAVE,
                 DD_TTE_ID_POSEEDOR,
                 LLV_COD_TENEDOR_POSEEDOR,
                 LLV_COD_TENEDOR_NO_PVE,
                 LLV_FECHA_ANILLADO,
                 LLV_FECHA_RECEPCION,
                 LLV_CODE,
                 LLV_COMPLETO,
                 LLV_OBSERVACIONES,
                 VERSION,
                 USUARIOCREAR,
                 FECHACREAR,
                 BORRADO
                )
                VALUES
                (
                 S_ACT_LLV_LLAVE.NEXTVAL,
                 ' || V_ACT_ID ||',
                 ''' || LLV_NUM_LLAVE         || ''',
                  ( SELECT DD_TTE_ID FROM '  || V_ESQUEMA || '.DD_TTE_TIPO_TENEDOR WHERE DD_TTE_CODIGO = ''' || DD_TTE_CODIGO_POSEEDOR || ''' ),
                 ''' || V_LLV_COD_TENEDOR_POSEEDOR || ''',
                 ''' || V_LLV_COD_TENEDOR_NO_PVE || ''',
                 ''' || LLV_FECHA_ANILLADO        || ''',
                 ''' || LLV_FECHA_RECEPCION           || ''',
                 ''' || LLV_CODE           || ''',
                  ( SELECT DD_TIC_ID FROM '  || V_ESQUEMA || '.DD_TIC_TIPO_COMPLETO WHERE DD_TIC_CODIGO = ''' || LLV_COMPLETO || ''' ),                   
                 ''' || LLV_OBSERVACIONES  || ''',
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
