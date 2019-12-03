--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20191202
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8607
--## PRODUCTO=NO
--##
--## Finalidad: Inserta datos en la ACT_AHT_HIST_TRAM_TITULO
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_AHT_HIST_TRAM_TITULO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_USU VARCHAR2(2400 CHAR) := 'HREOS-8607';

 

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT * 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''01'' and 
					    not EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_can_calificacion_neg can where can.borrado = 0 and can.act_id = tit.act_id)
				) T2
				ON (T1.TIT_ID = T2.TIT_ID)
				 WHEN NOT MATCHED THEN INSERT (  AHT_ID, 
												 TIT_ID, 
												 AHT_FECHA_PRES_REGISTRO, 
				                                 DD_ESP_ID,
				                                 AHT_OBSERVACIONES,
												 VERSION, 
												 USUARIOCREAR, 
												 FECHACREAR,  
												 BORRADO)
				
				VALUES (S_'||V_TEXT_TABLA||'.NEXTVAL,
					T2.tit_id, 
					T2.TIT_FECHA_PRESENT1_REG,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''01''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS TRAMITACIÓN CASO 1 ');

	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				     SELECT * 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''01'' and 
					    not EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_can_calificacion_neg can where can.borrado = 0 and can.act_id = tit.act_id)
   
				) T2
				ON (T1.TIT_ID = T2.TIT_ID)
				 WHEN NOT MATCHED THEN INSERT (  AHT_ID, 
												 TIT_ID, 
												 AHT_FECHA_PRES_REGISTRO, 
												 AHT_FECHA_CALIFICACION,
				                                 DD_ESP_ID,
				                                 AHT_OBSERVACIONES,
												 VERSION, 
												 USUARIOCREAR, 
												 FECHACREAR, 
												 BORRADO)
				
				VALUES (S_'||V_TEXT_TABLA||'.NEXTVAL,
					T2.tit_id, 
					T2.TIT_FECHA_PRESENT1_REG,
					T2.tit_fecha_envio_auto,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE, 
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS TRAMITACIÓN CASO 2.1 ');
	   
	   	V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (AHT_ID, 
                                         TIT_ID, 
                                         AHT_FECHA_PRES_REGISTRO, 
                                         DD_ESP_ID,
                                         AHT_OBSERVACIONES,
                                         VERSION, 
                                         USUARIOCREAR, 
                                         FECHACREAR, 
                                         BORRADO)
											SELECT 
											S_'||V_TEXT_TABLA||'.NEXTVAL,
											tit.tit_id, 
											tit.TIT_FECHA_PRESENT2_REG,
											(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''01''),
											NULL,
											0, 
											'''||V_USU||''', 
											SYSDATE, 
											0
											FROM '||V_ESQUEMA||'.act_tit_titulo tit
											left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''01'' and 
											not EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_can_calificacion_neg can where can.borrado = 0 and can.act_id = tit.act_id)
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS TRAMITACIÓN CASO 2.2 ');
	   
	    	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				     SELECT *    
						FROM '||V_ESQUEMA||'.act_tit_titulo tit
						    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
						    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''06'' and 
						    not EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_can_calificacion_neg can where can.borrado = 0 and can.act_id = tit.act_id)
				) T2
				ON (T1.TIT_ID = T2.TIT_ID)
				 WHEN NOT MATCHED THEN INSERT (  AHT_ID, 
												 TIT_ID, 
												 AHT_FECHA_PRES_REGISTRO,
												 AHT_FECHA_CALIFICACION,
				                                 DD_ESP_ID,
				                                 AHT_OBSERVACIONES,
												 VERSION, 
												 USUARIOCREAR, 
												 FECHACREAR, 
												 BORRADO)
				
				VALUES (S_'||V_TEXT_TABLA||'.NEXTVAL,
					T2.tit_id, 
					T2.TIT_FECHA_PRESENT1_REG,
					T2.tit_fecha_envio_auto,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE, 
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS SUBSANAR CASO 1 ');
	  
	   
	   V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT * 
                        FROM '||V_ESQUEMA||'.act_tit_titulo tit
                        left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
                        where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''06'' and 
                        not EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_can_calificacion_neg can where can.borrado = 0 and can.act_id = tit.act_id)
				) T2
				ON (T1.TIT_ID = T2.TIT_ID)
				 WHEN NOT MATCHED THEN INSERT (  AHT_ID, 
												 TIT_ID, 
												 AHT_FECHA_PRES_REGISTRO,
												 AHT_FECHA_CALIFICACION, 
				                                 DD_ESP_ID,
				                                 AHT_OBSERVACIONES,
												 VERSION, 
												 USUARIOCREAR, 
												 FECHACREAR, 
												 BORRADO)
				
				VALUES (S_'||V_TEXT_TABLA||'.NEXTVAL,
					T2.tit_id, 
					T2.TIT_FECHA_PRESENT1_REG,
					T2.tit_fecha_envio_auto,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''',  
					SYSDATE, 
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS SUBSANAR CASO 2.1 '); 

	   	V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (AHT_ID, 
                                         TIT_ID, 
                                         AHT_FECHA_PRES_REGISTRO, 
										 AHT_FECHA_CALIFICACION,
                                         DD_ESP_ID,
                                         AHT_OBSERVACIONES,
                                         VERSION, 
                                         USUARIOCREAR, 
                                         FECHACREAR, 
                                         BORRADO)
											SELECT 
											S_'||V_TEXT_TABLA||'.NEXTVAL,
											tit.tit_id, 
											tit.TIT_FECHA_PRESENT2_REG,
											tit.tit_fecha_envio_auto,
											(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
											NULL,
											0, 
											'''||V_USU||''', 
											SYSDATE, 
											0
											FROM '||V_ESQUEMA||'.act_tit_titulo tit
											left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''06'' and 
											not EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_can_calificacion_neg can where can.borrado = 0 and can.act_id = tit.act_id)
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS SUBSANAR CASO 2.2 '); 
	   -- No correcto pero se puede tratar usando solo la segunda fecha de presentación
	   
	     V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				     SELECT * 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is null and eti.dd_eti_codigo = ''02'' and tit.TIT_FECHA_INSC_REG is not null and
					    not EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_can_calificacion_neg can where can.borrado = 0 and can.act_id = tit.act_id)
   			) T2
				ON (T1.TIT_ID = T2.TIT_ID)
				 WHEN NOT MATCHED THEN INSERT (  AHT_ID, 
												 TIT_ID, 
												 AHT_FECHA_PRES_REGISTRO, 
				                                 AHT_FECHA_INSCRIPCION,
				                                 DD_ESP_ID,
				                                 AHT_OBSERVACIONES,
												 VERSION, 
												 USUARIOCREAR, 
												 FECHACREAR, 
												 BORRADO)
				
				VALUES (S_'||V_TEXT_TABLA||'.NEXTVAL,
					T2.tit_id, 
					T2.TIT_FECHA_PRESENT1_REG,
					T2.TIT_FECHA_INSC_REG, 
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''03''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE, 
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS INSCRITO CASO 1 '); 

	   	    V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				     SELECT * 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''02''
						and tit.TIT_FECHA_INSC_REG is not null and
					    not EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_can_calificacion_neg can where can.borrado = 0 and can.act_id = tit.act_id)
   
   			) T2
				ON (T1.TIT_ID = T2.TIT_ID)
				 WHEN NOT MATCHED THEN INSERT (  AHT_ID, 
												 TIT_ID, 
												 AHT_FECHA_PRES_REGISTRO, 
				                                 AHT_FECHA_CALIFICACION,
				                                 DD_ESP_ID,
				                                 AHT_OBSERVACIONES,
												 VERSION, 
												 USUARIOCREAR, 
												 FECHACREAR, 
												 BORRADO)
				
				VALUES (S_'||V_TEXT_TABLA||'.NEXTVAL,
					T2.tit_id, 
					T2.TIT_FECHA_PRESENT1_REG,
					T2.tit_fecha_envio_auto,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE, 
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS INSCRITO CASO 2.1 '); 
	   
	   
	   	V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (AHT_ID, 
                                         TIT_ID, 
                                         AHT_FECHA_PRES_REGISTRO, 
                                         AHT_FECHA_INSCRIPCION,
                                         DD_ESP_ID,
                                         AHT_OBSERVACIONES,
                                         VERSION, 
                                         USUARIOCREAR, 
                                         FECHACREAR, 
                                         BORRADO)
											SELECT 
											S_'||V_TEXT_TABLA||'.NEXTVAL,
											tit.tit_id, 
											tit.TIT_FECHA_PRESENT2_REG,
											tit.TIT_FECHA_INSC_REG, 
											(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''03''),
											NULL,
											0, 
											'''||V_USU||''', 
											SYSDATE, 
											0
											FROM '||V_ESQUEMA||'.act_tit_titulo tit
											left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''02'' and 
											not EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_can_calificacion_neg can where can.borrado = 0 and can.act_id = tit.act_id)
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS INSCRITO CASO 2.2 '); 
	   -- No correcto pero se puede tratar usando solo la segunda fecha de presentación
	   
	   
	   
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
   	
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