--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200708
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7739
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);
	V_ID NUMBER;
    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error

    -- EDITAR NÚMERO DE ITEM
    V_ITEM VARCHAR2(20) := 'REMVIP-7739';
    
    V_COUNT NUMBER;
   
BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO    
				SET PRO_NOMBRE = ''DIVARIAN DESARROLLOS INMOBILIARIOS, S.L.U.'',
				    USUARIOMODIFICAR = '''||V_ITEM||''',
				    FECHAMODIFICAR = SYSDATE
				WHERE PRO_NOMBRE = ''Divarian Desarrollos Inmobiliarios''';
	EXECUTE IMMEDIATE V_MSQL;
	
	V_COUNT := SQL%ROWCOUNT;
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO    
				SET PRO_NOMBRE = ''DIVARIAN PROPIEDAD, S.A.U.'',
				    USUARIOMODIFICAR = '''||V_ITEM||''',
				    FECHAMODIFICAR = SYSDATE
				WHERE PRO_NOMBRE = ''Divarian Propiedad''';
	EXECUTE IMMEDIATE V_MSQL;
	
	V_COUNT := SQL%ROWCOUNT + V_COUNT;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_COUNT||' registros actualizados en ACT_PRO_PROPIETARIO');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
