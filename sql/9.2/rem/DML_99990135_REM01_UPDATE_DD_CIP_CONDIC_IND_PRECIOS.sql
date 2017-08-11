--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170807
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2633
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_CIP_CONDIC_IND_PRECIOS los datos añadidos en T_ARRAY_DATA
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
	  
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_CIP_CONDIC_IND_PRECIOS';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('01','Fecha inscripción requerida','Fecha inscripción requerida','INNER JOIN REM01.act_reg_info_registral act_reg  ON act_reg.act_id = act.act_id
						JOIN REM01.bie_datos_registrales bdr ON bdr.bie_dreg_id = act_reg.bie_dreg_id
						AND bdr.bie_dreg_fecha_inscripcion is not null'),
		T_TIPO_DATA('02','Fecha posesión inicial requerida','Fecha posesión inicial requerida','INNER JOIN REM01.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID AND SPS.SPS_FECHA_TOMA_POSESION IS NOT NULL AND SPS.BORRADO = 0'),
		T_TIPO_DATA('12','Mediador asignado o sin mediador si es subtipo suelo','Mediador asignado o sin mediador si es subtipo suelo','                INNER JOIN
					                (SELECT act.act_id
					                   FROM act_activo act INNER JOIN rem01.act_ico_info_comercial ico2 ON ico2.act_id = act.act_id AND ico2.borrado = 0
					                        INNER JOIN rem01.act_pve_proveedor pve2
					                        ON (    ico2.ico_mediador_id = pve2.pve_id
					                            AND pve2.borrado = 0
					                            AND pve2.dd_tpr_id = (SELECT dd_tpr2.dd_tpr_id
					                                                    FROM rem01.dd_tpr_tipo_proveedor dd_tpr2
					                                                   WHERE dd_tpr2.dd_tpr_id = pve2.dd_tpr_id AND dd_tpr2.dd_tpr_codigo = ''''04'''' AND dd_tpr2.borrado = 0)
					                           )
					                 UNION ALL
					                 SELECT act.act_id
					                   FROM act_activo act INNER JOIN rem01.act_ico_info_comercial ico2
					                        ON ico2.act_id = act.act_id AND ico2.borrado = 0 AND act.dd_tpa_id = (SELECT dd_tpa.dd_tpa_id
					                                                                                                FROM rem01.dd_tpa_tipo_activo dd_tpa
					                                                                                               WHERE dd_tpa.dd_tpa_id = act.dd_tpa_id AND dd_tpa.dd_tpa_codigo = ''''01'''' AND dd_tpa.borrado = 0)
					                        ) pv ON pv.act_id = act.act_id'),
		T_TIPO_DATA('16','Sin precio mínimo','Sin precio mínimo','                INNER JOIN
					                (SELECT act.act_id
					                   FROM rem01.act_activo act LEFT JOIN rem01.act_val_valoraciones val ON val.act_id = act.act_id AND val.borrado = 0
					                  WHERE val.act_id IS NULL
					                 UNION ALL
					                 SELECT act.act_id
					                   FROM rem01.act_activo act JOIN rem01.act_val_valoraciones val
					                        ON val.act_id = act.act_id AND val.borrado = 0 AND NOT EXISTS (SELECT 1
					                                                                                         FROM rem01.act_val_valoraciones val2 JOIN rem01.dd_tpc_tipo_precio tpc ON val2.dd_tpc_id = tpc.dd_tpc_id
					                                                                                        WHERE val2.act_id = act.act_id AND val2.borrado = 0 AND dd_tpc_codigo = ''''04'''')
					                        ) v ON v.act_id = act.act_id'),
		T_TIPO_DATA('51','Con al menos un precio existente (Vigente o histórico)','Con al menos un precio existente (Vigente o histórico)','INNER JOIN rem01.act_val_valoraciones val31 
					                ON val31.act_id = act.act_id AND val31.borrado = 0 AND val31.dd_tpc_id IN (SELECT dd_tpc31.dd_tpc_id 
					                                                                                             FROM rem01.dd_tpc_tipo_precio dd_tpc31 
					                                                                                            WHERE dd_tpc31.dd_tpc_codigo IN (''''02'''', ''''03'''', ''''04'''') AND dd_tpc31.borrado = 0)'),
		T_TIPO_DATA('52','Con fecha de vencimiento anterior a X días','Con fecha de vencimiento anterior a X días','INNER JOIN rem01.act_val_valoraciones val40 
                ON val40.act_id = act.act_id 
              AND val40.borrado = 0 
              AND val40.dd_tpc_id = (SELECT dd_tpc40.dd_tpc_id 
                                       FROM rem01.dd_tpc_tipo_precio dd_tpc40 
                                      WHERE dd_tpc40.dd_tpc_id = val40.dd_tpc_id AND dd_tpc40.dd_tpc_codigo IN (''''02'''', ''''03'''', ''''04'''') AND dd_tpc40.borrado = 0) 
              AND val40.val_fecha_inicio < SYSDATE 
              AND (val40.val_fecha_fin - :igual_a <= SYSDATE)'),
		T_TIPO_DATA('53','Sin vencimiento, X días desde fecha de carga','Sin vencimiento, X días desde fecha de carga','INNER JOIN rem01.act_val_valoraciones val40 
		                ON val40.act_id = act.act_id 
		              AND val40.borrado = 0 
		              AND val40.dd_tpc_id = (SELECT dd_tpc40.dd_tpc_id 
		                                       FROM rem01.dd_tpc_tipo_precio dd_tpc40 
		                                      WHERE dd_tpc40.dd_tpc_id = val40.dd_tpc_id AND dd_tpc40.dd_tpc_codigo IN (''''02'''', ''''03'''', ''''04'''') AND dd_tpc40.borrado = 0) 
		              AND (   (val40.val_fecha_fin IS NULL AND val40.val_fecha_aprobacion + :igual_a <= SYSDATE) 
		                   OR (val40.val_fecha_fin IS NULL AND val40.val_fecha_aprobacion IS NULL AND val40.val_fecha_inicio + :igual_a <= SYSDATE) 
		                  )'),		
		T_TIPO_DATA('54','F.venc<30 días||Sin venc, F.carga>XX días','F.venc<30 días||Sin venc, F.carga>XX días','                INNER JOIN 
					                (SELECT act.act_id 
					                   FROM act_activo act INNER JOIN rem01.act_val_valoraciones val40 
					                        ON val40.act_id = act.act_id 
					                      AND val40.borrado = 0 
					                      AND val40.dd_tpc_id IN (SELECT dd_tpc40.dd_tpc_id 
					                                                FROM rem01.dd_tpc_tipo_precio dd_tpc40 
					                                               WHERE dd_tpc40.dd_tpc_codigo IN (''''02'''', ''''03'''', ''''04'''') AND dd_tpc40.borrado = 0) 
					                      AND val40.val_fecha_inicio < SYSDATE 
					                      AND (val40.val_fecha_fin - 30) <= SYSDATE 
					                 UNION ALL 
					                 SELECT act.act_id 
					                   FROM act_activo act INNER JOIN rem01.act_val_valoraciones val40 
					                        ON val40.act_id = act.act_id 
					                      AND val40.borrado = 0 
					                      AND val40.dd_tpc_id IN (SELECT dd_tpc40.dd_tpc_id 
					                                                FROM rem01.dd_tpc_tipo_precio dd_tpc40 
					                                               WHERE dd_tpc40.dd_tpc_codigo IN (''''02'''', ''''03'''', ''''04'''') AND dd_tpc40.borrado = 0) 
					                      AND (   (val40.val_fecha_fin IS NULL AND val40.val_fecha_aprobacion + :igual_a <= SYSDATE) 
					                           OR (val40.val_fecha_fin IS NULL AND val40.val_fecha_aprobacion IS NULL AND val40.val_fecha_inicio + :igual_a <= SYSDATE) 
					                          ) 
					                        ) val22 ON val22.act_id = act.act_id'),
		T_TIPO_DATA('55','Excluir activos vendidos o traspasados','Excluir activos vendidos o traspasados','INNER JOIN rem01.dd_scm_situacion_comercial dd_scm ON dd_scm.dd_scm_id = act.dd_scm_id AND dd_scm.dd_scm_codigo NOT IN (''''05'''', ''''06'''')'),
		T_TIPO_DATA('56','Sin propuesta de precios en curso','Sin propuesta de precios en curso','INNER JOIN
					                (SELECT act.act_id
					                   FROM rem01.act_activo act LEFT JOIN rem01.act_prp aprp ON aprp.act_id = act.act_id
						LEFT JOIN rem01.prp_propuestas_precios prp ON prp.prp_id = aprp.prp_id 
					                  WHERE aprp.act_id IS NULL
					                 UNION ALL
					                 SELECT act.act_id
					                   FROM rem01.act_activo act JOIN rem01.act_prp aprp
					                        ON aprp.act_id = act.act_id AND NOT EXISTS (SELECT 1
					                                                                                         FROM rem01.act_prp aprp2 JOIN rem01.prp_propuestas_precios prp2 ON prp2.prp_id = aprp2.prp_id
									JOIN rem01.dd_epp_estado_prop_precio epp ON epp.dd_epp_id = prp2.dd_epp_id
									WHERE epp.dd_epp_codigo in (''''01'''', ''''02'''') AND aprp2.act_id = act.act_id)
					                        ) v ON v.act_id = act.act_id'),
		T_TIPO_DATA('57','Sin propuesta de precios en curso (Repreciar)','Sin propuesta de precios en curso (Repreciar)','INNER JOIN
		                (SELECT act.act_id
		                   FROM rem01.act_activo act LEFT JOIN rem01.act_prp aprp ON aprp.act_id = act.act_id
			LEFT JOIN rem01.prp_propuestas_precios prp ON prp.prp_id = aprp.prp_id 
		                  WHERE aprp.act_id IS NULL
		                 UNION ALL
		                 SELECT act.act_id
		                   FROM rem01.act_activo act JOIN rem01.act_prp aprp
		                        ON aprp.act_id = act.act_id AND NOT EXISTS (SELECT 1
		                                                                                         FROM rem01.act_prp aprp2 JOIN rem01.prp_propuestas_precios prp2 ON prp2.prp_id = aprp2.prp_id
						JOIN rem01.dd_epp_estado_prop_precio epp ON epp.dd_epp_id = prp2.dd_epp_id
						WHERE epp.dd_epp_codigo in (''''01'''', ''''02'''') AND aprp2.act_id = act.act_id)
		                        ) v ON v.act_id = act.act_id')


        
        
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	-- Truncamos los datos primero --------------------------------------------------------------------------------------------------
	V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' SET USUARIOBORRAR = ''HREOS-2633'', FECHABORRAR = SYSDATE, BORRADO = 1';
	EXECUTE IMMEDIATE V_MSQL;
	 
    -- LOOP para insertar los valores en DD_EPU_ESTADO_PUBLICACION -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_CIP_CODIGO  = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    'SET DD_CIP_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_CIP_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', USUARIOMODIFICAR = ''HREOS-2633'' , FECHAMODIFICAR = SYSDATE '||
					', USUARIOBORRAR = NULL, FECHABORRAR = NULL, BORRADO = 0 '||
          			', DD_CIP_TEXTO = '''||TRIM(V_TMP_TIPO_DATA(4))||''''|| 
					'WHERE DD_CIP_CODIGO  = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      'DD_CIP_ID, DD_CIP_CODIGO , DD_CIP_DESCRIPCION, DD_CIP_DESCRIPCION_LARGA, DD_CIP_TEXTO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''', 0, ''HREOS-2633'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   

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