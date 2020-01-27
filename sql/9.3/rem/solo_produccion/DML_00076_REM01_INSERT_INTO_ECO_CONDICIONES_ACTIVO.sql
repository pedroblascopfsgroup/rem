--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20200115
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6143
--## PRODUCTO=NO
--##
--## Finalidad: Insertar registros en ECO_COND_CONDICIONES de un expediente
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	V_MSQL:= ' INSERT INTO '||V_ESQUEMA||'.ECO_COND_CONDICIONES_ACTIVO
			( COND_ID, DD_ETI_ID, COND_POSESION_INICIAL, DD_SIP_ID, ACT_ID, ECO_ID, VERSION, BORRADO, USUARIOCREAR, FECHACREAR )
		SELECT 	'||V_ESQUEMA||'.S_ECO_COND_CONDICIONES_ACTIVO.NEXTVAL AS COND_ID,
			( SELECT DD_ETI_ID FROM '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO WHERE DD_ETI_CODIGO = ''02'' ) AS DD_ETI_ID,
			1 AS COND_POSESION_INICIAL,
			( SELECT DD_SIP_ID FROM '||V_ESQUEMA||'.DD_SIP_SITUACION_POSESORIA WHERE DD_SIP_CODIGO = ''01'' ) AS DD_SIP_ID,
			ACT.ACT_ID,
			ECO.ECO_ID,
			0 AS VERSION,
			0 AS BORRADO,
			''REMVIP-6143'' AS USUARIOCREAR,
			SYSDATE AS FECHACREAR
			FROM REM01.ECO_EXPEDIENTE_COMERCIAL ECO,
			REM01.ACT_OFR,
			REM01.ACT_ACTIVO ACT
			WHERE 1 = 1
			AND ECO.OFR_ID = ACT_OFR.OFR_ID
			AND ACT.ACT_ID = ACT_OFR.ACT_ID
			AND ECO.ECO_NUM_EXPEDIENTE = ''190644''
			AND NOT EXISTS ( SELECT 1 FROM '||V_ESQUEMA||'.ECO_COND_CONDICIONES_ACTIVO CON
			                 WHERE CON.ACT_ID = ACT.ACT_ID
			                 AND CON.ECO_ID = ECO.ECO_ID
			                 AND CON.BORRADO = 0
			                )  ';
					
	   EXECUTE IMMEDIATE V_MSQL;


	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS CREADOS');
	   
   	
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] ');


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
