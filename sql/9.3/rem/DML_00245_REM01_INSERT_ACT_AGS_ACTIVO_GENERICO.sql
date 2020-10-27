--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20201022
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11830
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar instrucciones
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_AGS_ACTIVO_GENERICO_STG'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ITEM VARCHAR2(30 CHAR) := 'HREOS-11830';
    
    V_PROPIETARIO VARCHAR2(4000 CHAR);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('A86201993','9006',''),
		T_TIPO_DATA('B84921758','9001',''),
		T_TIPO_DATA('B10488328','1625','')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
    
	DBMS_OUTPUT.PUT_LINE('[INICIO] Iniciamos la inserción de activos genéricos... ');

  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_TDI_TIPO_DIARIO (
    TDI_ID
    , TIPO_INMUEBLE
    , DD_TBE_ID
    , TIPO_DIARIO
    , TIPO_DIARIO_DESCRIPCION
    , USUARIOCREAR
    , FECHACREAR
    )
    SELECT
      '||V_ESQUEMA||'.S_ACT_TDI_TIPO_DIARIO.NEXTVAL
      , ''GENERICO''
      , TBE.DD_TBE_ID
      , ''20''
      , ''Diario 20, IVA Prorrateado''
      , '''||V_ITEM||'''
      , SYSDATE
    FROM '||V_ESQUEMA||'.DD_TBE_TIPO_ACTIVO_BDE TBE
    WHERE TBE.BORRADO = 0
      AND TBE.DD_TBE_CODIGO = ''99''
      AND NOT EXISTS (
        SELECT 1
        FROM '||V_ESQUEMA||'.ACT_TDI_TIPO_DIARIO AUX
        WHERE AUX.DD_TBE_ID = TBE.DD_TBE_ID
          AND AUX.TIPO_DIARIO = ''20''
          AND AUX.TIPO_INMUEBLE = ''GENERICO''
          AND AUX.BORRADO = 0
      )';
  EXECUTE IMMEDIATE V_MSQL;

  IF SQL%ROWCOUNT = 1 THEN 
      DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado 1 registro en la tabla ACT_TDI_TIPO_DIARIO.');
  ELSIF SQL%ROWCOUNT > 1 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO]: Se han insertado '||SQL%ROWCOUNT||' registros en la tabla ACT_TDI_TIPO_DIARIO.');
  ELSE
      DBMS_OUTPUT.PUT_LINE('[INFO]: No se insertó ningún registro en la tabla ACT_TDI_TIPO_DIARIO.');
  END IF;

	-- LOOP para insertar los valores --
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);

	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO]: No existe la tabla');
	ELSE
		FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
            DBMS_OUTPUT.put_line('[INFO]: Insertando fila '||I||'.'); 
--T_TIPO_DATA('PROPIETARIO'1,'ACTIVO GENERICO'2,'AÑO'3)
                
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
  				AGS_ID
  				, DD_STG_ID
  				, USUARIOCREAR
  				, FECHACREAR
  				, PRO_ID
  				, AGS_ACTIVO_GENERICO
  				) 
  				SELECT 
  					'||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL
  					, STG.DD_STG_ID
  					, '''||V_ITEM||'''
  					, SYSDATE
  					, PRO.PRO_ID
  					, '||TRIM(V_TMP_TIPO_DATA(2))||'
  				FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO
          JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON 1 = 1
          	AND STG.BORRADO = 0 
  				WHERE PRO.BORRADO = 0 
  					AND PRO.PRO_DOCIDENTIF IN ('''||TRIM(V_TMP_TIPO_DATA(1))||''')
            AND NOT EXISTS (
              SELECT 1
              FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AUX
              WHERE AUX.PRO_ID = PRO.PRO_ID
                AND AUX.DD_STG_ID = STG.DD_STG_ID
                AND AUX.AGS_ACTIVO_GENERICO = '||TRIM(V_TMP_TIPO_DATA(2))||'
                AND AUX.BORRADO = 0
            )';                          
				EXECUTE IMMEDIATE V_MSQL;
                
        IF SQL%ROWCOUNT = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado 1 registro para la fila '||I||' en la tabla '||V_TEXT_TABLA||'.');
        ELSIF SQL%ROWCOUNT > 1 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se han insertado '||SQL%ROWCOUNT||' registros para la fila '||I||' en la tabla '||V_TEXT_TABLA||'.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: No se insertó ningún registro para la fila '||I||' en la tabla '||V_TEXT_TABLA||'.');
        END IF;

        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_ETD_ENT_TDI (
          ETD_ID
          , ENT_ID
          , TDI_ID
          , DD_ENT_ID
          , USUARIOCREAR
          , FECHACREAR
          )
          SELECT
            '||V_ESQUEMA||'.S_ACT_ETD_ENT_TDI.NEXTVAL
            , AGS.AGS_ID
            , TDI.TDI_ID
            , ENT.DD_ENT_ID
            , '''||V_ITEM||'''
            , SYSDATE
          FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AGS
          JOIN '||V_ESQUEMA||'.ACT_TDI_TIPO_DIARIO TDI ON TDI.TIPO_INMUEBLE = ''GENERICO''
            AND TDI.BORRADO = 0
          JOIN '||V_ESQUEMA||'.DD_TBE_TIPO_ACTIVO_BDE TBE ON TBE.DD_TBE_ID = TDI.DD_TBE_ID
            AND TBE.BORRADO = 0
          JOIN '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO ENT ON ENT.DD_ENT_CODIGO = ''GEN''
            AND ENT.BORRADO = 0
          JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = AGS.PRO_ID
            AND PRO.BORRADO = 0
          WHERE AGS.BORRADO = 0
            AND PRO.PRO_DOCIDENTIF = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
            AND TBE.DD_TBE_CODIGO = ''99''
            AND NOT EXISTS (
              SELECT 1
              FROM '||V_ESQUEMA||'.ACT_ETD_ENT_TDI AUX
              WHERE AUX.ENT_ID = AGS.AGS_ID
                AND AUX.TDI_ID = TDI.TDI_ID
                AND AUX.DD_ENT_ID = ENT.DD_ENT_ID
                AND AUX.BORRADO = 0
            )';
        EXECUTE IMMEDIATE V_MSQL;

        IF SQL%ROWCOUNT = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado 1 registro para la fila '||I||' en la tabla ACT_ETD_ENT_TDI.');
        ELSIF SQL%ROWCOUNT > 1 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se han insertado '||SQL%ROWCOUNT||' registros para la fila '||I||' en la tabla ACT_ETD_ENT_TDI.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: No se insertó ningún registro para la fila '||I||' en la tabla ACT_ETD_ENT_TDI.');
        END IF;
                
		END LOOP;
	END IF;

  COMMIT;  

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(V_MSQL); 
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
