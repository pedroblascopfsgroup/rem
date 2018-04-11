--/*
--##########################################
--## AUTOR=SIMEON SHOPOV 
--## FECHA_CREACION=20180228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-124
--## PRODUCTO=NO
--##
--## Finalidad: Descongelar Ofertas
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'OFR_OFERTAS';
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-124';
    
    ACT_NUM_ACTIVO NUMBER(16):= '6077839';
    
 BEGIN
 
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
		 			  DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''04'')
		 			, USUARIOMODIFICAR 	     = '''||V_USUARIO||'''
		 			, FECHAMODIFICAR         = SYSDATE
		 			WHERE OFR_ID IN (SELECT OFR.OFR_ID
									 FROM REM01.OFR_OFERTAS OFR
									JOIN REM01.ACT_OFR AO ON AO.OFR_ID = OFR.OFR_ID
									JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID AND ACT.ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||' 
									JOIN REM01.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.DD_EOF_CODIGO = ''02''
									)
				  ';
	
  EXECUTE IMMEDIATE V_SQL;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] Se han descongelado '||SQL%ROWCOUNT||' ofertas del activo '||ACT_NUM_ACTIVO);
  
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
