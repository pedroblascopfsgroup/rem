--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20191209
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
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo is null
						and tit.tit_fecha_envio_auto is null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 4 ');

	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				     SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo is null 
						and tit.tit_fecha_envio_auto is null
   
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE, 
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 5-6 CALIFICACIÓN NEGATIVA ');
	   
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
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo is null 
											and tit.tit_fecha_envio_auto is null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 5-6 ');
	   
	    	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo is null
					and tit.tit_fecha_envio_auto is not null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 7-8 CALIFICACIÓN NEGATIVA');
	  
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
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo is null 
											and tit.tit_fecha_envio_auto is not null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 7-8 ');
	   
	   	    	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo is null
					and tit.tit_fecha_envio_auto is not null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 9-10 CALIFICACIÓN NEGATIVA');
	  
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
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo is null 
											and tit.tit_fecha_envio_auto is not null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 9-10 ');

	   	   	    	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo is null
					and tit.tit_fecha_envio_auto is null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE, 
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 11-12 CALIFICACIÓN NEGATIVA');
	  
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
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo is null 
											and tit.tit_fecha_envio_auto is null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 11-12 ');

	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo is null
						and tit.tit_fecha_envio_auto is null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 13 ');

	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo is null
						and tit.tit_fecha_envio_auto is null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 14 ');
	   
	   /*	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT * 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''01''
						and tit.tit_fecha_envio_auto is null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 15 ');*/

	   		   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''02''
						and tit.tit_fecha_envio_auto is null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 16 ');

	   	   		   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo IN (''04'',''05'',''07'')
						and tit.tit_fecha_envio_auto is null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 17 ');

	   	   	   		   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''06''
						and tit.tit_fecha_envio_auto is null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 18 ');

	   	   	   	   		   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''03''
						and tit.tit_fecha_envio_auto is null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 19 ');

	   /*	   	   	    	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT *     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo is null
					and tit.tit_fecha_envio_auto is null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 20-21 CALIFICACIÓN NEGATIVA');
	  
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
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo is null 
											and tit.tit_fecha_envio_auto is null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 20-21 ');*/

	   	   	   	    	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo IN (''04'',''05'',''07'')
					and tit.tit_fecha_envio_auto is null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE, 
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 22-23 CALIFICACIÓN NEGATIVA');
	  
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
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo IN (''04'',''05'',''07'') 
											and tit.tit_fecha_envio_auto is null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 22-23 ');

	   	   	   	   	    	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''06''
					and tit.tit_fecha_envio_auto is null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE, 
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 24-25 CALIFICACIÓN NEGATIVA');
	  
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
											TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
											(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
											NULL,
											0, 
											'''||V_USU||''', 
											SYSDATE, 
											0
											FROM '||V_ESQUEMA||'.act_tit_titulo tit
											left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''06''
											and tit.tit_fecha_envio_auto is null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 24-25 ');

	   	   	   	   	   	    	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''02''
					and tit.tit_fecha_envio_auto is null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE, 
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 26-27 CALIFICACIÓN NEGATIVA');
	  
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
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''02''
											and tit.tit_fecha_envio_auto is null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 26-27 ');

	   	   	   	   	   		   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo is null
						and tit.tit_fecha_envio_auto is null
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
					T2.TIT_FECHA_PRESENT2_REG,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''01''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 28 ');

	   	   	   	   	   	   		   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo is null
						and tit.tit_fecha_envio_auto is not null
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
					T2.TIT_FECHA_PRESENT2_REG,
					T2.TIT_FECHA_ENVIO_AUTO,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 29 ');

	   		   	   	   	   	   	    	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo is null
					and tit.tit_fecha_envio_auto is not null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 30-31 CALIFICACIÓN NEGATIVA');
	  
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
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo is null
											and tit.tit_fecha_envio_auto is not null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 30-31 ');

	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''01''
						and tit.tit_fecha_envio_auto is null
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
					T2.TIT_FECHA_PRESENT2_REG,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''01''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 32 ');

	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''02''
						and tit.tit_fecha_envio_auto is null
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
					T2.TIT_FECHA_PRESENT2_REG,
					T2.TIT_FECHA_INSC_REG,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''03''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 33 ');

	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo IN (''04'',''05'',''07'')
						and tit.tit_fecha_envio_auto is null
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
					T2.TIT_FECHA_PRESENT2_REG,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''01''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 34 ');

	   	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''06''
						and tit.tit_fecha_envio_auto is null
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
					T2.TIT_FECHA_PRESENT2_REG,
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 35 ');

	   	   	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''03''
						and tit.tit_fecha_envio_auto is null
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
					T2.TIT_FECHA_PRESENT2_REG,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 36 ');

	   	   	   	   	   		   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo is null
						and tit.tit_fecha_envio_auto is not null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					T2.TIT_FECHA_ENVIO_AUTO,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 37 ');

	   	   		   	   	   	   	   	    	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo is null
					and tit.tit_fecha_envio_auto is not null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 38-39 CALIFICACIÓN NEGATIVA');
	  
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
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo is null
											and tit.tit_fecha_envio_auto is not null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 38-39 ');

	   	   	   	   	   	   		   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo is null
						and tit.tit_fecha_envio_auto is null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					T2.TIT_FECHA_INSC_REG,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''03''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 40 ');

	   	   	   	   	   	   	   		   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''01''
						and tit.tit_fecha_envio_auto is null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''01''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 41 ');

	   	   	   	   	   	   	   		   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''02''
						and tit.tit_fecha_envio_auto is null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					T2.TIT_FECHA_INSC_REG,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''03''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 42 ');

	   	   	   	   	   	   	   	   		   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo  IN (''04'',''05'',''07'')
						and tit.tit_fecha_envio_auto is null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''01''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 43 ');

	   	   	   	   	   	   	   	   	   		   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''06''
						and tit.tit_fecha_envio_auto is null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 44 ');

	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''02''
						and tit.tit_fecha_envio_auto is null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					T2.TIT_FECHA_INSC_REG,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''03''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 45 ');

	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''01''
						and tit.tit_fecha_envio_auto is not null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					T2.TIT_FECHA_ENVIO_AUTO,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 46 ');

	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo != ''02''
						and tit.tit_fecha_envio_auto is null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					T2.TIT_FECHA_INSC_REG,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''03''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 47, 48, 49 ');

	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''04''
					and tit.tit_fecha_envio_auto is not null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 50-51 CALIFICACIÓN NEGATIVA');
	  
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
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''04''
											and tit.tit_fecha_envio_auto is not null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 50-51 ');

	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''04''
					and tit.tit_fecha_envio_auto is not null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 52-53 CALIFICACIÓN NEGATIVA');
	  
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
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''04''
											and tit.tit_fecha_envio_auto is not null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 52-53 ');

	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''04''
						and tit.tit_fecha_envio_auto is not null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 54 ');

	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''01''
					and tit.tit_fecha_envio_auto is not null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					T2.tit_fecha_envio_auto,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE, 
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 55-56 CALIFICACIÓN NEGATIVA');
	  
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
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''01''
											and tit.tit_fecha_envio_auto is not null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 55-56 ');

	   	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''01''
						and tit.tit_fecha_envio_auto is null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 57 ');

	   	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''01''
					and tit.tit_fecha_envio_auto is not null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 58-59 CALIFICACIÓN NEGATIVA');
	  
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
											TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
											tit.TIT_FECHA_INSC_REG,
											(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''03''),
											NULL,
											0, 
											'''||V_USU||''', 
											SYSDATE, 
											0
											FROM '||V_ESQUEMA||'.act_tit_titulo tit
											left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''01''
											and tit.tit_fecha_envio_auto is not null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 58-59 ');

	   	   	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''01''
					and tit.tit_fecha_envio_auto is not null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 60-61 CALIFICACIÓN NEGATIVA');
	  
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
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''01''
											and tit.tit_fecha_envio_auto is not null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 60-61 ');

	   	   	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''03''
						and tit.tit_fecha_envio_auto is null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 62 ');

	   	   	   	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''02''
						and tit.tit_fecha_envio_auto is not null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 63 ');

	   	   	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''02''
					and tit.tit_fecha_envio_auto is not null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					T2.tit_fecha_envio_auto,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE, 
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 64-65 CALIFICACIÓN NEGATIVA');
	  
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
											TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
											tit.TIT_FECHA_INSC_REG,
											(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''03''),
											NULL,
											0, 
											'''||V_USU||''', 
											SYSDATE, 
											0
											FROM '||V_ESQUEMA||'.act_tit_titulo tit
											left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''02''
											and tit.tit_fecha_envio_auto is not null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 64-65 ');

	   	   	   	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''02''
					and tit.tit_fecha_envio_auto is not null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 66-67 CALIFICACIÓN NEGATIVA');
	  
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
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''02''
											and tit.tit_fecha_envio_auto is not null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 66-67 ');

	   	   	   	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''02''
					and tit.tit_fecha_envio_auto is not null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					T2.tit_fecha_envio_auto,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE, 
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 68-69 CALIFICACIÓN NEGATIVA');
	  
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
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''02''
											and tit.tit_fecha_envio_auto is not null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 68-69 ');

	   	   	   	   	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''02''
						and tit.tit_fecha_envio_auto is null
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
					T2.TIT_FECHA_PRESENT2_REG,
					T2.TIT_FECHA_INSC_REG,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''03''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 70 ');

	   	   	   	   	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''06''
					and tit.tit_fecha_envio_auto is not null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 71-72 CALIFICACIÓN NEGATIVA');
	  
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
											TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
											tit.TIT_FECHA_INSC_REG,
											(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''03''),
											NULL,
											0, 
											'''||V_USU||''', 
											SYSDATE, 
											0
											FROM '||V_ESQUEMA||'.act_tit_titulo tit
											left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''06''
											and tit.tit_fecha_envio_auto is not null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 71-72 ');

	   	   	   	   	   	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''06''
					and tit.tit_fecha_envio_auto is null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE, 
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 73-74 CALIFICACIÓN NEGATIVA');
	  
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
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''06''
											and tit.tit_fecha_envio_auto is null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 73-74 ');

	   	   	   	   	   	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''06''
						and tit.tit_fecha_envio_auto is null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 75 ');

	   	   	   	   	   	   	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''06''
						and tit.tit_fecha_envio_auto is not null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					T2.tit_fecha_envio_auto,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE,  
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 76 ');

	   	   	   	   	   	   	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''06''
					and tit.tit_fecha_envio_auto is not null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 77-78 CALIFICACIÓN NEGATIVA');
	  
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
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''06''
											and tit.tit_fecha_envio_auto is not null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 77-78 ');

	   	   	   	   	   	   	   	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
					SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto     
					FROM '||V_ESQUEMA||'.act_tit_titulo tit
					left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''06''
					and tit.tit_fecha_envio_auto is not null
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					T2.tit_fecha_envio_auto,
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE, 
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 79-80 CALIFICACIÓN NEGATIVA');
	  
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
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''06''
											and tit.tit_fecha_envio_auto is not null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 79-80 ');

	   	   	   	   	   	   	   	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				      SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo is null
						and tit.tit_fecha_envio_auto is not null
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
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS CASO 81 ');

	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				     SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''01'' 
						and tit.tit_fecha_envio_auto is null
   
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE, 
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS TRAMITACIÓN 2ª PRESENTACIÓN CALIFICACIÓN NEGATIVA NULA ');
	   
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
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is null and eti.dd_eti_codigo = ''01'' 
											and tit.tit_fecha_envio_auto is null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS TRAMITACIÓN 2ª PRESENTACIÓN NO NULA ');	  

	   	   	   	   	V_MSQL:= '	MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING(
				     SELECT tit.tit_id, tit.tit_fecha_present1_reg, tit.tit_fecha_present2_reg, tit.TIT_FECHA_INSC_REG, tit.tit_fecha_envio_auto 
					    FROM '||V_ESQUEMA||'.act_tit_titulo tit
					    left join '||V_ESQUEMA||'.dd_eti_estado_titulo eti on tit.dd_eti_id = eti.dd_eti_id
					    where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''02'' 
						and tit.tit_fecha_envio_auto is null
   
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
					TO_DATE(''01/01/1900'',''DD/MM/YYYY''),
					(select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02''),
					NULL,
					0, 
					'''||V_USU||''', 
					SYSDATE, 
					0)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS INSCRITOS 2ª PRESENTACIÓN CALIFICACIÓN NEGATIVA NULA ');
	   
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
											where tit.borrado = 0 and tit.tit_fecha_present1_reg is not null and tit.tit_fecha_present2_reg is not null and tit.TIT_FECHA_INSC_REG is not null and eti.dd_eti_codigo = ''02'' 
											and tit.tit_fecha_envio_auto is null
											and EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.act_aht_hist_tram_titulo aht where aht.borrado = 0 
											and aht.dd_esp_id = (select DD_esp_id from '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION where dd_esp_codigo = ''02'') and aht.tit_id = tit.tit_id)';
					
	   EXECUTE IMMEDIATE V_MSQL;
	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS INSCRITOS 2ª PRESENTACIÓN NO NULA ');	  

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