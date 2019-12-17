--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20191213
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-7617
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar estado en la ACT_TIT_TITULO de los inscritos en ACT_AHT_HIST_TRAM_TITULO
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_TIT_TITULO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_USU VARCHAR2(2400 CHAR) := 'HREOS-7617';

 

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT 
					tit.tit_id
					, (SELECT eti_aux.dd_eti_id FROM '||V_ESQUEMA||'.dd_eti_estado_titulo eti_aux where eti_aux.dd_eti_codigo = ''02'') dd_eti_id
					FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo AHT
					JOIN '||V_ESQUEMA||'.act_tit_titulo TIT ON TIT.TIT_ID = AHT.TIT_ID
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					LEFT JOIN '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION ESP ON AHT.DD_ESP_ID = ESP.DD_ESP_ID
					where eti.dd_eti_codigo <> ''02'' and esp.dd_esp_codigo = ''03''
				) T2
				ON (T1.tit_id = T2.tit_id)
				 WHEN MATCHED THEN UPDATE SET
					T1.dd_eti_id = T2.dd_eti_id
					, T1.USUARIOMODIFICAR = '''||V_USU||'''
					, T1.FECHAMODIFICAR = SYSDATE';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS');
	   
   	
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');


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