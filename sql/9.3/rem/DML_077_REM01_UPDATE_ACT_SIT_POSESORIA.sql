--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20191211
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5818
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

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_SQL VARCHAR2(32000 CHAR);
	V_COUNT NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    -- EDITAR: NÚMERO DE ITEM
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-5818'; -- USUARIOCREAR/USUARIOMODIFICAR.

    

BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS 
				INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = SPS.ACT_ID
				WHERE ACT.ACT_NUM_ACTIVO = 6840256 AND SPS.DD_SIJ_ID IS NOT NULL';
				
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT > 0 THEN
		V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SET DD_SIJ_ID = NULL, USUARIOMODIFICAR = '''||V_USR||''', FECHAMODIFICAR = SYSDATE 
					WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = 6840256)';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] SITUACION POSESORIA ACTUALIZADA!');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] NADA QUE MODIFICAR!');
	END IF;
	
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