--/*
--#########################################
--## AUTOR=Mª José Ponce
--## FECHA_CREACION=20200204
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-9344
--## PRODUCTO=NO
--## 
--## Finalidad:  Creación del SP SP_EXT_IN_MOV_LLAVE
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1-Oscar Diestre-Versión inicial REMVIP-4833 (20190718)
--##        0.2-Modificar parámetros SP HREOS-9064
--##        0.3-Modificar parámetros de fecha SP HREOS-9344
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE       SP_EXT_IN_MOV_LLAVE (
    ACT_NUM_ACTIVO    	      IN NUMBER,
	 LLV_NUM_LLAVE     	      IN VARCHAR2,
    DD_TTE_CODIGO_POSEEDOR    IN VARCHAR2,
    MLV_COD_TENEDOR_POSEEDOR  IN VARCHAR2,
    DD_TTE_CODIGO_PEDIDOR     IN VARCHAR2,
    MLV_COD_TENEDOR_PEDIDOR   IN VARCHAR2,
    MLV_ENVIO                 IN VARCHAR2,
    MLV_FECHA_ENVIO           IN VARCHAR2,
    MLV_FECHA_RECEPCION       IN VARCHAR2,
    MLV_OBSERVACIONES         IN VARCHAR2,
    MLV_ESTADO                IN VARCHAR2,	
      V_USUARIO         	   VARCHAR2 DEFAULT 'SP_EXT_IN_MOV_LLAVE',
      COD_RETORNO             OUT NUMBER
) AS

--v0.2

V_SQL VARCHAR2(32000 CHAR); 											-- Sentencia a ejecutar.
V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; 								-- Configuracion Esquema.
ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
V_ACT_ID NUMBER( 16 );
V_LLV_ID NUMBER( 16 );
V_MLV_COD_TENEDOR_POS_NO_PVE VARCHAR2(100 CHAR); --Vble. para rellenar registro de la tabla.
V_MLV_COD_TENEDOR_PED_NO_PVE VARCHAR2(100 CHAR); --Vble. para rellenar registro de la tabla.
V_MLV_COD_TENEDOR_POSEEDOR VARCHAR2(25 CHAR); --Vble. para rellenar registro de la tabla.
V_MLV_COD_TENEDOR_PEDIDOR VARCHAR2(25 CHAR); --Vble. para rellenar registro de la tabla.


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


	-- Existe el número de llave ??
   	V_SQL := 'SELECT COUNT( 1 ) FROM '||V_ESQUEMA||'.ACT_LLV_LLAVE 
		  WHERE ACT_ID = '|| V_ACT_ID ||' 
		  AND BORRADO = 0 
		  AND LLV_NUM_LLAVE = ''' || LLV_NUM_LLAVE || '''';

	EXECUTE IMMEDIATE V_SQL INTO V_LLV_ID;

	IF ( V_LLV_ID = 0 ) THEN

	 DBMS_OUTPUT.PUT_LINE('[INFO] No existe el número de llave '|| LLV_NUM_LLAVE ||' para el activo ' || ACT_NUM_ACTIVO || ' pasado por parámetros. El proceso finalizará.');
	 RETURN;

	END IF;

	-- Busca el id de la llave
   	V_SQL := 'SELECT COALESCE( MAX( LLV_ID ), 0 ) FROM '||V_ESQUEMA||'.ACT_LLV_LLAVE 
		  WHERE ACT_ID = '|| V_ACT_ID ||' 
		  AND BORRADO = 0 
		  AND LLV_NUM_LLAVE = ''' || LLV_NUM_LLAVE || '''';

	EXECUTE IMMEDIATE V_SQL INTO V_LLV_ID;
	DBMS_OUTPUT.PUT_LINE('[INFO] Existe la llave '|| LLV_NUM_LLAVE || ' para el activo ' || ACT_NUM_ACTIVO || ' pasado por parámetro.');


   IF (DD_TTE_CODIGO_POSEEDOR NOT IN('01', '02', '03', '04', '05', '06', '07')) THEN
   
    V_MLV_COD_TENEDOR_POS_NO_PVE := MLV_COD_TENEDOR_POSEEDOR;
    V_MLV_COD_TENEDOR_POSEEDOR := '';

   ELSE

    V_SQL := 'SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '||MLV_COD_TENEDOR_POSEEDOR||' AND BORRADO = 0';
   EXECUTE IMMEDIATE V_SQL INTO V_MLV_COD_TENEDOR_POSEEDOR;

   END IF;

   IF (DD_TTE_CODIGO_PEDIDOR NOT IN('01', '02', '03', '04', '05', '06', '07')) THEN
   
    V_MLV_COD_TENEDOR_PED_NO_PVE := MLV_COD_TENEDOR_PEDIDOR;
    V_MLV_COD_TENEDOR_PEDIDOR := '';

   ELSE

    V_SQL := 'SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '||MLV_COD_TENEDOR_PEDIDOR||' AND BORRADO = 0';
   EXECUTE IMMEDIATE V_SQL INTO V_MLV_COD_TENEDOR_PEDIDOR;

   END IF;  
--------------------------------------------------------------------------------

   -- Crea el registro en ACT_MLV_MOVIMIENTO_LLAVE: 

	V_SQL := ' INSERT INTO ' || V_ESQUEMA || '.ACT_MLV_MOVIMIENTO_LLAVE
               ( 
                 MLV_ID,
                 LLV_ID,
                 DD_TTE_ID_POSEEDOR,
                 MLV_COD_TENEDOR_POSEEDOR,
                 MLV_COD_TENEDOR_POS_NO_PVE,
                 DD_TTE_ID_PEDIDOR,
                 MLV_COD_TENEDOR_PEDIDOR,
                 MLV_COD_TENEDOR_PED_NO_PVE,
                 MLV_ENVIO,
                 MLV_FECHA_ENVIO,
                 MLV_FECHA_RECEPCION,
                 MLV_OBSERVACIONES,
                 MLV_ESTADO,                 
                 VERSION,
                 USUARIOCREAR,
                 FECHACREAR,
                 BORRADO
                )
                VALUES
                (
                 S_ACT_MLV_MOVIMIENTO_LLAVE.NEXTVAL,
		           ' || V_LLV_ID ||',
                  ( SELECT DD_TTE_ID FROM '  || V_ESQUEMA || '.DD_TTE_TIPO_TENEDOR WHERE DD_TTE_CODIGO = ''' || DD_TTE_CODIGO_POSEEDOR || ''' ),
                 ''' || V_MLV_COD_TENEDOR_POSEEDOR || ''',
                 ''' || V_MLV_COD_TENEDOR_POS_NO_PVE || ''',
                  (SELECT DD_TTE_ID FROM '  || V_ESQUEMA || '.DD_TTE_TIPO_TENEDOR WHERE DD_TTE_CODIGO = ''' || DD_TTE_CODIGO_PEDIDOR || ''' ),
                 ''' || V_MLV_COD_TENEDOR_PEDIDOR || ''',
                 ''' || V_MLV_COD_TENEDOR_PED_NO_PVE || ''',
                 ''' || MLV_ENVIO || ''',
                 TO_DATE(''' || MLV_FECHA_ENVIO || ''',''dd/mm/yyyy''),
                 TO_DATE(''' || MLV_FECHA_RECEPCION || ''',''dd/mm/yyyy''),
                 ''' || MLV_OBSERVACIONES || ''',
                 ( SELECT DD_TTE_ID FROM '  || V_ESQUEMA || '.DD_TTE_TIPO_ESTADO WHERE DD_TTE_CODIGO = ''' || MLV_ESTADO || ''' ),
                 0,
                 ''' || V_USUARIO || ''',
                 SYSDATE,
                 0
                 )';

        EXECUTE IMMEDIATE V_SQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] - Creado '||SQL%ROWCOUNT||' registro en ACT_MLU_MOVIMIENTO_LLAVE.');

   COMMIT;

       COD_RETORNO := 1;


EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ERR_NUM := SQLCODE;
      RAISE;
END SP_EXT_IN_MOV_LLAVE;
/
EXIT
