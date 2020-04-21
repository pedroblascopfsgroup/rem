--/*
--##########################################
--## AUTOR=José Antonio Gigante Pamplona
--## FECHA_CREACION=20200402
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6848
--## PRODUCTO=NO
--##
--## Finalidad: Update de registros en ECO_COND_CONDICIONES de un expediente
--## INSTRUCCIONES: 
--##	Dado un expediente comercial cambia las condiciones del activo actualizando la situación del activo
--##    comunicada al comprador con los datos de asituación real del activo.
--##	Actualmente Situación del título, Con Posesión inicial y Situación posesoria. 
--##	Cambiando V_NUM_OFERTA podemos modificar los activos de otra oferta,
--##	insertando en ECO_COND_CONDICIONES los activos que no se encuentran en 
--##	la tabla y que están vinculados a la oferta.
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
	V_TABLA VARCHAR(50 CHAR):='ECO_COND_CONDICIONES_ACTIVO';

	V_USUARIO VARCHAR(50):='REMVIP-6848';
    V_NUM_OFERTA NUMBER(25):= 90248353;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	V_MSQL:= ' MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
			USING
			(	SELECT
				ACT.ACT_ID,
				ECO.ECO_ID,
				TIT.DD_ETI_ID AS DD_ETI_ID,
				(CASE WHEN SPS.SPS_FECHA_TOMA_POSESION IS NULL  THEN 0
				ELSE 1
				END) COND_POSESION_INICIAL,
				(CASE SPS.SPS_OCUPADO WHEN 0 THEN 
    				(SELECT DD_SIP_ID FROM '||V_ESQUEMA||'.DD_SIP_SITUACION_POSESORIA WHERE DD_SIP_CODIGO = ''01'') -- SIN OCUPAR
				ELSE -- OCUPADO
    				CASE SPS.SPS_CON_TITULO WHEN 1 THEN 
    					(SELECT DD_SIP_ID FROM '||V_ESQUEMA||'.DD_SIP_SITUACION_POSESORIA WHERE DD_SIP_CODIGO = ''02'') -- OCUPADO CON TITULO
    				WHEN 0 THEN 
    					(SELECT DD_SIP_ID FROM '||V_ESQUEMA||'.DD_SIP_SITUACION_POSESORIA WHERE DD_SIP_CODIGO = ''03'') -- OCUPADO SIN TITULO
    				END
				END) DD_SIP_ID
				FROM OFR_OFERTAS OFR
				JOIN '||V_ESQUEMA||'.ACT_OFR AOF ON AOF.OFR_ID = OFR.OFR_ID
				JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AOF.ACT_ID AND ACT.BORRADO = 0
				JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO TIT ON TIT.ACT_ID = ACT.ACT_ID AND TIT.BORRADO = 0
				JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID AND SPS.BORRADO = 0
				JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
				WHERE OFR.OFR_NUM_OFERTA = '||V_NUM_OFERTA||'
			
			) T2
			ON (T1.ECO_ID = T2.ECO_ID AND T1.ACT_ID = T2.ACT_ID)
			WHEN MATCHED THEN UPDATE
			SET
				T1.DD_ETI_ID = T2.DD_ETI_ID,
				T1.COND_POSESION_INICIAL = T2.COND_POSESION_INICIAL,
				T1.DD_SIP_ID = T2.DD_SIP_ID,
				T1.FECHAMODIFICAR = SYSDATE,
				T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
				T1.VERSION = T1.VERSION + 1
			WHEN NOT MATCHED THEN INSERT 
			( COND_ID, DD_ETI_ID, COND_POSESION_INICIAL, DD_SIP_ID, ACT_ID, ECO_ID, VERSION, BORRADO, USUARIOCREAR, FECHACREAR )
			VALUES
			(S_'||V_TABLA||'.NEXTVAL, T2.DD_ETI_ID, T2.COND_POSESION_INICIAL, T2.DD_SIP_ID, T2.ACT_ID, T2.ECO_ID, 0, 0, '''||V_USUARIO||''', SYSDATE)
			';
		
	   	EXECUTE IMMEDIATE V_MSQL;
	   	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS PROCESADOS');
		
	   	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOMODIFICAR = '''||V_USUARIO||'''
		   AND TO_CHAR(FECHAMODIFICAR, ''DD/MM/YYYY HH24:MI'') = TO_CHAR(SYSDATE, ''DD/MM/YYYY HH24:MI'')';
	   	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	   	IF V_NUM_TABLAS > 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO]: '||V_NUM_TABLAS||' REGISTROS ACTUALIZADOS');
		END IF;
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = '''||V_USUARIO||'''
		AND TO_CHAR(FECHAMODIFICAR, ''DD/MM/YYYY HH24:MI'') = TO_CHAR(SYSDATE, ''DD/MM/YYYY HH24:MI'')';
	   	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	   	IF V_NUM_TABLAS > 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO]: '||V_NUM_TABLAS||' REGISTROS CREADOS');
		END IF;

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
