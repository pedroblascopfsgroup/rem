--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20211202
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMNIVDOS-5447
--## PRODUCTO=NO
--## 
--## Finalidad: 
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

	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_SEQUENCE VARCHAR2(2000 CHAR);

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
 
	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_OFR_NUM_OFERTA.NEXTVAL FROM DUAL';
	EXECUTE IMMEDIATE V_MSQL INTO V_SEQUENCE;

	DBMS_OUTPUT.PUT_LINE('	[INFO] SECUENCIA INICIAL: ' || V_SEQUENCE);

	V_MSQL := 'ALTER SEQUENCE REM01.S_OFR_NUM_OFERTA INCREMENT BY 1000';
   	EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'SELECT REM01.S_OFR_NUM_OFERTA.NEXTVAL FROM DUAL';
   	EXECUTE IMMEDIATE V_MSQL INTO V_SEQUENCE;

	DBMS_OUTPUT.PUT_LINE('	[INFO] SECUENCIA FINAL: ' || V_SEQUENCE);

    V_MSQL := 'ALTER SEQUENCE REM01.S_OFR_NUM_OFERTA INCREMENT BY 1';
   	EXECUTE IMMEDIATE V_MSQL;

  	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          ROLLBACK;
          RAISE;          
END;
/
EXIT
