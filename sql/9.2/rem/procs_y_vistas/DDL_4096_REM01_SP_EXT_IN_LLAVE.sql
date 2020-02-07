--/*
--#########################################
--## AUTOR=Mª José Ponce
--## FECHA_CREACION=20200205
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-9359
--## PRODUCTO=NO
--## 
--## Finalidad:  Creación del SP SP_EXT_IN_LLAVE
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1-Oscar Diestre-Versión inicial REMVIP-4833(20190718)
--##        0.2-Modificar parámetros SP HREOS-9065
--##        0.3-Modificar parámetros de fecha SP HREOS-9344
--##        0.4-Añadir lógica al SP HREOS-9359
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
    LLV_FECHA_ANILLADO        IN VARCHAR2,
    LLV_FECHA_RECEPCION       IN VARCHAR2,
    LLV_CODE                  IN VARCHAR2,
    LLV_COMPLETO              IN VARCHAR2,
    LLV_OBSERVACIONES         IN VARCHAR2,
      V_USUARIO         	  VARCHAR2 DEFAULT 'SP_EXT_IN_LLAVE',
      COD_RETORNO            OUT NUMBER
) AS

--v0.4

V_SQL VARCHAR2(32000 CHAR); 											-- Sentencia a ejecutar.
V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; 								-- Configuracion Esquema.
V_LLV_COD_TENEDOR_NO_PVE VARCHAR2(25 CHAR); --Vble. para rellenar registro de la tabla.
V_LLV_COD_TENEDOR_POSEEDOR VARCHAR2(25 CHAR); --Vble. para rellenar registro de la tabla.  
ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
V_ACT NUMBER( 16 ); -- Vble. auxiliar para comprobar si existen activos.
V_LLV NUMBER( 16 ); -- Vble. auxiliar para comprobar si existen llaves.
V_ACT_ID NUMBER( 16 ); -- Vble. auxiliar para rellenar registro de la tabla.
V_LLV_ID NUMBER( 16 ); -- Vble. auxiliar para rellenar registro de la tabla.
V_ACT_EXIST NUMBER (16,0);
V_LLV_EXIST NUMBER (16,0);


BEGIN

   COD_RETORNO := 0;
   
	-- Existe el activo ??
   IF (ACT_NUM_ACTIVO IS NOT NULL) THEN
   	V_SQL := 'SELECT COUNT( 1 ) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '|| ACT_NUM_ACTIVO ||' AND BORRADO = 0';

	EXECUTE IMMEDIATE V_SQL INTO V_ACT;

   END IF;

	IF ( V_ACT = 0 ) THEN
    V_ACT_EXIST := 0; -- No existe el activo

   ELSIF (V_ACT IS NOT NULL) THEN
    V_ACT_EXIST := 1; --El activo existe
    -- Busca el id del activo
    V_SQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '|| ACT_NUM_ACTIVO ||' AND BORRADO = 0';

   EXECUTE IMMEDIATE V_SQL INTO V_ACT_ID;
   DBMS_OUTPUT.PUT_LINE('[INFO] Existe el activo '|| ACT_NUM_ACTIVO ||' pasado por parámetro.');

   END IF;

   --Existe la llave ??    
     V_SQL := 'SELECT COUNT( 1 ) FROM '||V_ESQUEMA||'.ACT_LLV_LLAVE WHERE LLV_NUM_LLAVE='''||LLV_NUM_LLAVE||''' AND BORRADO = 0';

    EXECUTE IMMEDIATE V_SQL INTO  V_LLV;

   IF ( V_LLV = 0 ) THEN
    V_LLV_EXIST := 0; --No existe la llave

   ELSE
    V_LLV_EXIST := 1; --La llave existe
    V_SQL := 'SELECT LLV_ID FROM '||V_ESQUEMA||'.ACT_LLV_LLAVE WHERE LLV_NUM_LLAVE='''||LLV_NUM_LLAVE||''' AND BORRADO = 0';

   EXECUTE IMMEDIATE V_SQL INTO V_LLV_ID;
   DBMS_OUTPUT.PUT_LINE('[INFO] Existe la llave '|| LLV_NUM_LLAVE ||' pasada por parámetro.');

	  -- DBMS_OUTPUT.PUT_LINE('[INFO] No existe el Activo '|| ACT_NUM_ACTIVO ||' pasado por parámetros. El proceso finalizará.');
	
	END IF;

	
   IF (DD_TTE_CODIGO_POSEEDOR NOT IN('01', '02', '03', '04', '05', '06', '07')) THEN
   
    V_LLV_COD_TENEDOR_NO_PVE := LLV_COD_TENEDOR_POSEEDOR;
    V_LLV_COD_TENEDOR_POSEEDOR := '';

   ELSE

    V_SQL := 'SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '||LLV_COD_TENEDOR_POSEEDOR||' AND BORRADO = 0';
   EXECUTE IMMEDIATE V_SQL INTO V_LLV_COD_TENEDOR_POSEEDOR;

   END IF;

--------------------------------------------------------------------------------
   --Si no existe llave ni activo -> el proceso finaliza
   IF ( V_LLV_EXIST = 0 AND V_ACT_EXIST = 0 ) THEN

   DBMS_OUTPUT.PUT_LINE('[INFO] No existe el Activo '|| ACT_NUM_ACTIVO ||' ni la llave '||LLV_NUM_LLAVE||' pasados por parámetros. El proceso finalizará.');

   RETURN;

   END IF;

   --Si no existe la llave y existe el activo -> hacemos el insert
   IF (V_LLV_EXIST=0 AND V_ACT_EXIST=1) THEN

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
                 '  || V_ESQUEMA || '.S_ACT_LLV_LLAVE.NEXTVAL,
                 ' || V_ACT_ID ||',
                 ''' || LLV_NUM_LLAVE|| ''',
                  ( SELECT DD_TTE_ID FROM '  || V_ESQUEMA || '.DD_TTE_TIPO_TENEDOR WHERE DD_TTE_CODIGO = ''' || DD_TTE_CODIGO_POSEEDOR || ''' ),
                 ''' || V_LLV_COD_TENEDOR_POSEEDOR || ''',
                 ''' || V_LLV_COD_TENEDOR_NO_PVE || ''',
                 TO_DATE('''|| LLV_FECHA_ANILLADO||''',''dd/mm/yyyy''),
                 TO_DATE('''|| LLV_FECHA_RECEPCION|| ''',''dd/mm/yyyy''),
                 ''' || LLV_CODE|| ''',
                  ( SELECT DD_TIC_ID FROM '  || V_ESQUEMA || '.DD_TIC_TIPO_COMPLETO WHERE DD_TIC_CODIGO = ''' || LLV_COMPLETO || ''' ),                   
                 ''' || LLV_OBSERVACIONES|| ''',
                 0,
                 ''' || V_USUARIO || ''',
                 SYSDATE,
                 0
                 )';

   EXECUTE IMMEDIATE V_SQL;

   DBMS_OUTPUT.PUT_LINE('[INFO] - Creado '||SQL%ROWCOUNT||' registro en ACT_LLV_LLAVE.');

   RETURN;
   END IF;

   --Si existe la llave y no existe el activo en ACT_ACTIVO
   IF ( V_LLV_EXIST = 1 AND V_ACT_EXIST = 0) THEN

   DBMS_OUTPUT.PUT_LINE('[INFO] No existe el Activo '|| ACT_NUM_ACTIVO ||' pasado por parámetros. El proceso finalizará.');

   RETURN;
   END IF;

   --Si existe la llave y no viene con activo -> hacemos borrado lógico
  
   IF ( V_LLV_EXIST = 1 AND ACT_NUM_ACTIVO IS NULL ) THEN

   V_SQL := 'UPDATE '|| V_ESQUEMA || '.ACT_LLV_LLAVE SET
                USUARIOBORRAR = ''' || V_USUARIO || '''
               ,FECHABORRAR = SYSDATE 
               ,BORRADO = 1
            WHERE LLV_ID = '||V_LLV_ID||' AND BORRADO = 0';

   EXECUTE IMMEDIATE V_SQL;

   DBMS_OUTPUT.PUT_LINE('[INFO] - Borrado lógico en '||SQL%ROWCOUNT||' registro en ACT_LLV_LLAVE.');

   RETURN;
   END IF;  

   --Si existe la llave y el activo -> hacemos un Update
   IF ( V_LLV_EXIST = 1 AND V_ACT_EXIST= 1) THEN

   V_SQL := 'UPDATE ' || V_ESQUEMA || '.ACT_LLV_LLAVE SET                
                ACT_ID = '||V_ACT_ID||'
               ,LLV_NUM_LLAVE = '''||LLV_NUM_LLAVE||'''
               ,DD_TTE_ID_POSEEDOR = ( SELECT DD_TTE_ID FROM '  || V_ESQUEMA || '.DD_TTE_TIPO_TENEDOR WHERE DD_TTE_CODIGO = ''' || DD_TTE_CODIGO_POSEEDOR || ''' )
               ,LLV_COD_TENEDOR_POSEEDOR = ''' || V_LLV_COD_TENEDOR_POSEEDOR || '''
               ,LLV_COD_TENEDOR_NO_PVE = ''' || V_LLV_COD_TENEDOR_NO_PVE || '''
               ,LLV_FECHA_ANILLADO = TO_DATE('''|| LLV_FECHA_ANILLADO||''',''dd/mm/yyyy'')
               ,LLV_FECHA_RECEPCION = TO_DATE('''|| LLV_FECHA_RECEPCION|| ''',''dd/mm/yyyy'')
               ,LLV_CODE = ''' || LLV_CODE|| '''
               ,LLV_COMPLETO = ( SELECT DD_TIC_ID FROM '  || V_ESQUEMA || '.DD_TIC_TIPO_COMPLETO WHERE DD_TIC_CODIGO = ''' || LLV_COMPLETO || ''' )
               ,LLV_OBSERVACIONES = ''' || LLV_OBSERVACIONES|| '''               
               ,USUARIOMODIFICAR = ''' || V_USUARIO || '''
               ,FECHAMODIFICAR = SYSDATE
            WHERE LLV_ID = '||V_LLV_ID||' AND BORRADO = 0';

      EXECUTE IMMEDIATE V_SQL;

   DBMS_OUTPUT.PUT_LINE('[INFO] - Modificado '||SQL%ROWCOUNT||' registro en ACT_LLV_LLAVE.');

   RETURN;
   END IF;    

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
