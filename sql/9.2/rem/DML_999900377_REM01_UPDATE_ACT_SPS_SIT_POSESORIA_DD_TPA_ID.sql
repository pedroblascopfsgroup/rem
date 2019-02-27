--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20180107
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5129
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'HREOS-5129'; -- USUARIOCREAR/USUARIOMODIFICAR.
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION ACT_SPS_SIT_POSESORIA');
	
 V_SQL := 'SELECT COUNT(1)
                FROM ALL_TAB_COLUMNS
                WHERE OWNER = '''||V_ESQUEMA||'''
                AND TABLE_NAME = ''ACT_SPS_SIT_POSESORIA''
                AND COLUMN_NAME = ''DD_TPA_ID''
             ';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN

	V_MSQL := 'MERGE INTO ACT_SPS_SIT_POSESORIA SPS
                USING (SELECT SPS_ID
            , CASE WHEN SPS_OCUPADO = 0 THEN NULL
                   WHEN SPS_OCUPADO = 1 AND SPS_CON_TITULO = 0 AND (SPS_FECHA_TOMA_POSESION IS NOT NULL OR SPS_FECHA_REVISION_ESTADO IS NOT NULL) THEN (SELECT DD_TPA_ID FROM '|| V_ESQUEMA ||'.DD_TPA_TIPO_TITULO_ACT WHERE DD_TPA_CODIGO = ''02'')         
                   WHEN SPS_OCUPADO = 1 AND SPS_CON_TITULO = 0 AND (SPS_FECHA_TOMA_POSESION IS NULL AND SPS_FECHA_REVISION_ESTADO IS NULL) THEN (SELECT DD_TPA_ID FROM '|| V_ESQUEMA ||'.DD_TPA_TIPO_TITULO_ACT WHERE DD_TPA_CODIGO = ''03'')
                   WHEN SPS_OCUPADO = 1 AND SPS_CON_TITULO = 1 THEN (SELECT DD_TPA_ID FROM '|| V_ESQUEMA ||'.DD_TPA_TIPO_TITULO_ACT WHERE DD_TPA_CODIGO = ''01'')
                   ELSE NULL 
                   END AS DD_TPA_ID
                   FROM '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA WHERE SPS_CON_TITULO IS NOT NULL OR (SPS_OCUPADO = 0 AND DD_TPA_ID IS NOT NULL)) TMP
                ON (SPS.SPS_ID = TMP.SPS_ID)
                WHEN MATCHED THEN UPDATE SET
                    SPS.DD_TPA_ID = TMP.DD_TPA_ID
                    , SPS.USUARIOMODIFICAR = '''|| V_USR ||'''
                    , SPS.FECHAMODIFICAR =  SYSDATE
                    , SPS.VERSION = SPS.VERSION  + 1
    ';
    EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[FIN] Merge realizado correctamente');
	
	ELSE 
	
	DBMS_OUTPUT.PUT_LINE('[FIN] La columna no existe');
	
	END IF;
	
	COMMIT;
 
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
