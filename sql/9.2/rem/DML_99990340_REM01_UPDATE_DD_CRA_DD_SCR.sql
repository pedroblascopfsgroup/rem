--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20180608
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1005
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar datos de cartera y subcartera
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_EXISTS NUMBER(1);


BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] BORRADO LOGICO DE CARTERAS');
    --COMPROBAMOS EXISTENCIA TABLA
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = ''DD_CRA_CARTERA''';
    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
    
    IF V_EXISTS = 1 THEN
        --COMPROBAMOS EXISTENCIA COLUMNA       
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_CRA_CARTERA CRA
					SET
					  CRA.BORRADO = 1,
					  CRA.USUARIOBORRAR = ''REMVIP-1005'',
					  CRA.FECHABORRAR = SYSDATE
					WHERE CRA.DD_CRA_CODIGO IN (''09'',''13'') AND CRA.BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL;       
        DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan '||SQL%ROWCOUNT||' registros en DD_CRA_CARTERA');    
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] No existe la tabla DD_CRA_CARTERA');
    END IF;
    
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] BORRADO LOGICO DE SUBCARTERAS');
    --COMPROBAMOS EXISTENCIA TABLA
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = ''DD_SCR_SUBCARTERA''';
    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
    
    IF V_EXISTS = 1 THEN
        --COMPROBAMOS EXISTENCIA COLUMNA       
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR
					SET
					  SCR.BORRADO = 1,
					  SCR.USUARIOBORRAR = ''REMVIP-1005'',
					  SCR.FECHABORRAR = SYSDATE
					WHERE EXISTS (
					  SELECT 1
					  FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA
					  WHERE CRA.DD_CRA_CODIGO IN (''09'',''13'')
					  AND CRA.DD_CRA_ID = SCR.DD_CRA_ID
					  )
					AND SCR.BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL;       
        DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan '||SQL%ROWCOUNT||' registros en DD_SCR_SUBCARTERA'); 
        
        --COMPROBAMOS EXISTENCIA TABLA
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR WHERE SCR.DD_SCR_CODIGO = ''37''';
		EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
		
		IF V_EXISTS = 0 THEN
			--INSERTAMOS LA SUBCARTERA - Jaipur - Inmobiliario
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_SCR_SUBCARTERA(DD_SCR_ID,DD_CRA_ID,DD_SCR_CODIGO,DD_SCR_DESCRIPCION,DD_SCR_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)
			VALUES 
			(
			'||V_ESQUEMA||'.S_DD_SCR_SUBCARTERA.NEXTVAL,
			(SELECT DD_CRA_ID FROM REM01.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07''),
			''37'',
			''Jaipur - Inmobiliario'',
			''Jaipur - Inmobiliario'',
			0,
			''REMVIP-1005'',
			SYSDATE,
			0
			)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Se inserta correctamente la subcartera ''Jaipur - Inmobiliario'' en DD_SCR_SUBCARTERA'); 
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la subcartera ''Jaipur - Inmobiliario'' en DD_SCR_SUBCARTERA');
		END IF;

		--COMPROBAMOS EXISTENCIA TABLA
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR WHERE SCR.DD_SCR_CODIGO = ''38''';
		EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
		
		IF V_EXISTS = 0 THEN
			--INSERTAMOS LA SUBCARTERA - Jaipur - Financiero
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_SCR_SUBCARTERA(DD_SCR_ID,DD_CRA_ID,DD_SCR_CODIGO,DD_SCR_DESCRIPCION,DD_SCR_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)
			VALUES 
			(
			'||V_ESQUEMA||'.S_DD_SCR_SUBCARTERA.NEXTVAL,
			(SELECT DD_CRA_ID FROM REM01.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07''),
			''38'',
			''Jaipur - Financiero'',
			''Jaipur - Financiero'',
			0,
			''REMVIP-1005'',
			SYSDATE,
			0
			)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Se inserta correctamente la subcartera ''Jaipur - Financiero'' en DD_SCR_SUBCARTERA'); 
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la subcartera ''Jaipur - Financiero'' en DD_SCR_SUBCARTERA');
		END IF;

		--COMPROBAMOS EXISTENCIA TABLA
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR WHERE SCR.DD_SCR_CODIGO = ''39''';
		EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
		
		IF V_EXISTS = 0 THEN
			--INSERTAMOS LA SUBCARTERA - Egeo
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_SCR_SUBCARTERA(DD_SCR_ID,DD_CRA_ID,DD_SCR_CODIGO,DD_SCR_DESCRIPCION,DD_SCR_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)
			VALUES 
			(
			'||V_ESQUEMA||'.S_DD_SCR_SUBCARTERA.NEXTVAL,
			(SELECT DD_CRA_ID FROM REM01.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''7''),
			''39'',
			''Egeo'',
			''Egeo'',
			0,
			''REMVIP-1005'',
			SYSDATE,
			0
			)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Se inserta correctamente la subcartera ''Egeo'' en DD_SCR_SUBCARTERA'); 
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la subcartera ''Egeo'' en DD_SCR_SUBCARTERA');
		END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] No existe la tabla DD_SCR_SUBCARTERA');
    END IF;
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('KO no modificada');
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);
        ROLLBACK;
        RAISE;          
END;
/
EXIT
