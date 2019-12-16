--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20191213
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-7617
--## PRODUCTO=NO
--##
--## Finalidad: Inserta relación en la ACT_CAN_CALIFICACION_NEG en la ACT_AHT_HIST_TRAM_TITULO
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CAN_CALIFICACION_NEG'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_USU VARCHAR2(2400 CHAR) := 'HREOS-7617';

 

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					WITH AHT AS (
						SELECT AHT.AHT_ID, AHT.TIT_ID, AHT.AHT_FECHA_PRES_REGISTRO, AHT.AHT_FECHA_CALIFICACION, AHT.AHT_FECHA_INSCRIPCION, ESP.DD_ESP_CODIGO, ESP.DD_ESP_DESCRIPCION, row_number() over (partition by  AHT.TIT_ID order by AHT.AHT_ID desc) as rn
						FROM '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO AHT
						LEFT JOIN '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION ESP ON AHT.DD_ESP_ID = ESP.DD_ESP_ID
						WHERE AHT.BORRADO = 0
					)
					SELECT can.act_can_id, tit.act_id, tit.tit_id , aht.aht_id, can.act_fecha_subsanacion, aht.aht_fecha_pres_registro, aht.aht_fecha_calificacion
					FROM '||V_ESQUEMA||'.act_can_calificacion_neg can
					join '||V_ESQUEMA||'.act_tit_titulo tit on can.act_id = tit.act_id
					join aht on aht.tit_id = tit.tit_id and aht.rn = 2
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where can.borrado = 0 and tit.borrado = 0
					and tit.tit_fecha_envio_auto >= tit.tit_fecha_present1_reg and tit.tit_fecha_envio_auto <= tit.tit_fecha_present2_reg
				) T2
				ON (T1.act_can_id = T2.act_can_id)
				 WHEN MATCHED THEN UPDATE SET
					T1.AHT_ID = T2.AHT_ID
					, T1.USUARIOMODIFICAR = '''||V_USU||'''
					, T1.FECHAMODIFICAR = SYSDATE';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO ENTRE PRESENTACIONES');

	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					WITH AHT AS (
						SELECT AHT.AHT_ID, AHT.TIT_ID, AHT.AHT_FECHA_PRES_REGISTRO, AHT.AHT_FECHA_CALIFICACION, AHT.AHT_FECHA_INSCRIPCION, ESP.DD_ESP_CODIGO, ESP.DD_ESP_DESCRIPCION, row_number() over (partition by  AHT.TIT_ID order by AHT.AHT_ID desc) as rn
						FROM '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO AHT
						LEFT JOIN '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION ESP ON AHT.DD_ESP_ID = ESP.DD_ESP_ID
						WHERE AHT.BORRADO = 0
					)
					SELECT can.act_can_id, tit.act_id, tit.tit_id , aht.aht_id, can.act_fecha_subsanacion, aht.aht_fecha_pres_registro, aht.aht_fecha_calificacion
					FROM '||V_ESQUEMA||'.act_can_calificacion_neg can
					join '||V_ESQUEMA||'.act_tit_titulo tit on can.act_id = tit.act_id
					join aht on aht.tit_id = tit.tit_id and aht.rn = 1
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where can.borrado = 0 and tit.borrado = 0
					and tit.tit_fecha_envio_auto > tit.tit_fecha_present2_reg
				) T2
				ON (T1.act_can_id = T2.act_can_id)
				 WHEN MATCHED THEN UPDATE SET
					T1.AHT_ID = T2.AHT_ID
					, T1.USUARIOMODIFICAR = '''||V_USU||'''
					, T1.FECHAMODIFICAR = SYSDATE';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO DESPUÉS DE 2ª PRESENTACIÓN');

	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					WITH AHT AS (
						SELECT AHT.AHT_ID, AHT.TIT_ID, AHT.AHT_FECHA_PRES_REGISTRO, AHT.AHT_FECHA_CALIFICACION, AHT.AHT_FECHA_INSCRIPCION, ESP.DD_ESP_CODIGO, ESP.DD_ESP_DESCRIPCION, row_number() over (partition by  AHT.TIT_ID order by AHT.AHT_ID desc) as rn
						FROM '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO AHT
						LEFT JOIN '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION ESP ON AHT.DD_ESP_ID = ESP.DD_ESP_ID
						WHERE AHT.BORRADO = 0
					)
					SELECT can.act_can_id, tit.act_id, tit.tit_id , aht.aht_id, can.act_fecha_subsanacion, aht.aht_fecha_pres_registro, aht.aht_fecha_calificacion
					FROM '||V_ESQUEMA||'.act_can_calificacion_neg can
					join '||V_ESQUEMA||'.act_tit_titulo tit on can.act_id = tit.act_id
					join aht on aht.tit_id = tit.tit_id
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where can.borrado = 0 and tit.borrado = 0
					and tit.tit_fecha_envio_auto >= tit.tit_fecha_present1_reg and tit.tit_fecha_present2_reg is null and AHT.AHT_FECHA_CALIFICACION is not null
					and (can.act_fecha_subsanacion is null or can.act_fecha_subsanacion > tit.tit_fecha_present1_reg)
				) T2
				ON (T1.act_can_id = T2.act_can_id)
				 WHEN MATCHED THEN UPDATE SET
					T1.AHT_ID = T2.AHT_ID
					, T1.USUARIOMODIFICAR = '''||V_USU||'''
					, T1.FECHAMODIFICAR = SYSDATE';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 2ª PRESENTACIÓN NULA Y CON ALGÚN REGISTRO CON CALIFICACIÓN NEGATIVA');

	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					WITH AHT AS (
						SELECT AHT.AHT_ID, AHT.TIT_ID, AHT.AHT_FECHA_PRES_REGISTRO, AHT.AHT_FECHA_CALIFICACION, AHT.AHT_FECHA_INSCRIPCION, ESP.DD_ESP_CODIGO, ESP.DD_ESP_DESCRIPCION, row_number() over (partition by  AHT.TIT_ID order by AHT.AHT_ID desc) as rn
						FROM '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO AHT
						LEFT JOIN '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION ESP ON AHT.DD_ESP_ID = ESP.DD_ESP_ID
						WHERE AHT.BORRADO = 0
					)
					SELECT can.act_can_id, tit.act_id, tit.tit_id , aht.aht_id, can.act_fecha_subsanacion, aht.aht_fecha_pres_registro, aht.aht_fecha_calificacion
					FROM '||V_ESQUEMA||'.act_can_calificacion_neg can
					join '||V_ESQUEMA||'.act_tit_titulo tit on can.act_id = tit.act_id
					join aht on aht.tit_id = tit.tit_id
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where can.borrado = 0 and tit.borrado = 0
					and can.aht_id is null and tit.tit_fecha_envio_auto >= tit.tit_fecha_present1_reg and tit.tit_fecha_present2_reg is null and aht.dd_esp_codigo = ''02''
					union
					SELECT can.act_can_id, tit.act_id, tit.tit_id , aht.aht_id, can.act_fecha_subsanacion, aht.aht_fecha_pres_registro, aht.aht_fecha_calificacion
					FROM '||V_ESQUEMA||'.act_can_calificacion_neg can
					join '||V_ESQUEMA||'.act_tit_titulo tit on can.act_id = tit.act_id
					join aht on aht.tit_id = tit.tit_id
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where can.borrado = 0 and tit.borrado = 0
					and can.aht_id is null and tit.tit_fecha_envio_auto >= tit.tit_fecha_present1_reg and tit.tit_fecha_present2_reg is null and aht.dd_esp_codigo = ''03''
				) T2
				ON (T1.act_can_id = T2.act_can_id)
				 WHEN MATCHED THEN UPDATE SET
					T1.AHT_ID = T2.AHT_ID
					, T1.USUARIOMODIFICAR = '''||V_USU||'''
					, T1.FECHAMODIFICAR = SYSDATE';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 2ª PRESENTACIÓN NULA Y CON ALGÚN REGISTRO SIN CALIFICACIÓN NEGATIVA');
   	
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