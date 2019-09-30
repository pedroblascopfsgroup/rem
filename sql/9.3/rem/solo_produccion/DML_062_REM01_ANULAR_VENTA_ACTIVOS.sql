--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190930
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5342
--## PRODUCTO=NO
--##
--## Finalidad:  
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-5342';
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio de la anulación de venta');

	V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL
				SET DD_EEC_ID = 2
					,ECO_FECHA_CONT_PROPIETARIO = NULL
					,ECO_FECHA_VENTA = NULL
					,ECO_FECHA_ANULACION = SYSDATE
					,USUARIOMODIFICAR = '''||V_USUARIO||'''
					,FECHAMODIFICAR = SYSDATE
				WHERE ECO_NUM_EXPEDIENTE IN (
					124331
				)';
	EXECUTE IMMEDIATE V_SQL;

	V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO 
				SET PAC_CHECK_FORMALIZAR = 1
		        	,PAC_CHECK_COMERCIALIZAR = 1
				    ,FECHAMODIFICAR = SYSDATE
				    ,USUARIOMODIFICAR = '''||V_USUARIO||'''
		        WHERE ACT_ID IN (
					SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO IN (6825922)
				)';
	EXECUTE IMMEDIATE V_SQL;

	V_SQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS
				SET DD_EOF_ID = 2
					,USUARIOMODIFICAR = '''||V_USUARIO||'''
					,FECHAMODIFICAR = SYSDATE
				WHERE OFR_NUM_OFERTA IN (
					14535
				)';
	EXECUTE IMMEDIATE V_SQL;

	V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET DD_SCM_ID = NULL WHERE ACT_NUM_ACTIVO IN (6825922)';
	EXECUTE IMMEDIATE V_SQL;

	V_SQL := 'CALL '||V_ESQUEMA||'.SP_ASC_ACT_SIT_COM_VACIOS_V2 (0)';
	EXECUTE IMMEDIATE V_SQL;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN] El proceso ha finalizado correctamente');
 
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

