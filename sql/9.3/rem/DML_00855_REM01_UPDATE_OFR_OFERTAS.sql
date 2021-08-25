--/*
--######################################### 
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210825
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14968
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES: Modificar OFR_OFERTAS boolean a valores diccionario
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejECVtar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_TABLA VARCHAR2(50 CHAR):= 'OFR_OFERTAS'; --Nombre de la tabla
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USU VARCHAR2(30 CHAR) := 'HREOS-14968';
    V_COL_OLD VARCHAR2(50 CHAR) := 'OFR_NECESITA_FINANCIACION';
    
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN '||V_TABLA||'');

	V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
				'||V_COL_OLD||' = (SELECT DD_SNS_ID FROM '||V_ESQUEMA||'.DD_SNS_SINONOSABE WHERE DD_SNS_CODIGO = ''01''),
				USUARIOMODIFICAR = '''||V_USU||''',FECHAMODIFICAR = SYSDATE
				WHERE '||V_COL_OLD||' = 1';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '||SQL%ROWCOUNT||' VALORES DE 1 A VALOR SI');

	V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
				'||V_COL_OLD||' = (SELECT DD_SNS_ID FROM '||V_ESQUEMA||'.DD_SNS_SINONOSABE WHERE DD_SNS_CODIGO = ''02''),
				USUARIOMODIFICAR = '''||V_USU||''',FECHAMODIFICAR = SYSDATE
				WHERE '||V_COL_OLD||' = 0';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '||SQL%ROWCOUNT||' VALORES DE 0 A VALOR NO');

    --La FK se crea despues de la migracion de datos porque si no da error de datos
    --DDL_00319_REM01_ALTER_TABLE_OFR_OFERTAS.sql
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.'||V_TABLA||' ADD 
                CONSTRAINT FK_DD_SNS FOREIGN KEY ('||V_COL_OLD||') 
                REFERENCES '||V_ESQUEMA||'.DD_SNS_SINONOSABE (DD_SNS_ID) ON DELETE SET NULL';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Añadida FK '||V_COL_OLD||' sobre DD_SNS_SINONOSABE');
        
    COMMIT;

EXCEPTION
     WHEN OTHERS THEN 
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejECVción:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT;