--/*
--######################################### 
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210804
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10283
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Cambiar propietarios de activos genéricos
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USU VARCHAR2(30 CHAR) := 'REMVIP-10283';
	V_COUNT NUMBER(16);
	V_PRO_VIEJO NUMBER(16);
	V_PRO_NUEVO NUMBER(16);
    
BEGIN

	V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = ''A93139053''';
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

	IF V_COUNT > 0 THEN

		V_MSQL := 'SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = ''A86201993''';
		EXECUTE IMMEDIATE V_MSQL INTO V_PRO_VIEJO;	

		V_MSQL := 'SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = ''A93139053''';
		EXECUTE IMMEDIATE V_MSQL INTO V_PRO_NUEVO;	

		V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_AGS_ACTIVO_GENERICO_STG SET 
					PRO_ID = '||V_PRO_NUEVO||',
					USUARIOMODIFICAR = '''||V_USU||''',
					FECHAMODIFICAR = SYSDATE
					WHERE PRO_ID = '||V_PRO_VIEJO||'';
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL NUEVO PROPIETARIO');

	END IF;

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