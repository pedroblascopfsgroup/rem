--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20170329
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS
--## PRODUCTO=NO
--## Finalidad: Indices necesarios para optimizar las búsquedas
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_INDEX NUMBER(3); -- Vble. auxiliar para la numeración de índices

 
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	-- 			TABLA							COLUMNAS																													NOMBRE_INDICE
		T_TIPO_DATA('ACT_LOC_LOCALIZACION' 			,'LOC_ID,ACT_ID,BIE_LOC_ID,LOC_LATITUD,LOC_LONGITUD'																		,'ACT_LOC_IDX'	),
		T_TIPO_DATA('DD_TPA_TIPO_ACTIVO' 			,'DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION'																				,'DD_TPA_IDX'	),
		T_TIPO_DATA('DD_SAC_SUBTIPO_ACTIVO' 		,'DD_SAC_ID,DD_SAC_CODIGO,DD_SAC_DESCRIPCION'																				,'DD_SAC_IDX'	),
		T_TIPO_DATA('ACT_REG_INFO_REGISTRAL' 		,'REG_ID,ACT_ID,BIE_DREG_ID,REG_SUPERFICIE_UTIL,REG_SUPERFICIE_PARCELA'														,'ACT_REG_INFO_IDX'	),
		T_TIPO_DATA('BIE_DATOS_REGISTRALES' 		,'BIE_DREG_ID,DD_LOC_ID,BIE_DREG_NUM_FINCA,BIE_DREG_NUM_REGISTRO,BIE_DREG_SUPERFICIE_CONSTRUIDA,BIE_DREG_SUPERFICIE'		,'BIE_DATOS_REG_IDX'	),
		T_TIPO_DATA('ACT_EDI_EDIFICIO' 				,'ICO_ID,EDI_ID,EDI_ASCENSOR,EDI_DESCRIPCION'																				,'ACT_EDI_IDX'	),
		T_TIPO_DATA('DD_TPH_TIPO_HABITACULO' 		,'DD_TPH_ID,DD_TPH_CODIGO'																									,'DD_TPH_IDX'	),
		T_TIPO_DATA('ACT_DIS_DISTRIBUCION' 			,'ICO_ID,DD_TPH_ID,DIS_CANTIDAD,DIS_ID'																						,'ACT_DIS_IDX'	),
		T_TIPO_DATA('DD_TCO_TIPO_COMERCIALIZACION' 	,'DD_TCO_ID,DD_TCO_CODIGO'																									,'DD_TCO_IDX'	),
		T_TIPO_DATA('DD_EAC_ESTADO_ACTIVO' 			,'DD_EAC_ID,DD_EAC_CODIGO'																									,'DD_EAC_IDX'	),
		T_TIPO_DATA('DD_SCM_SITUACION_COMERCIAL' 	,'DD_SCM_ID,DD_SCM_CODIGO'																									,'DD_SCM_IDX'	),
		T_TIPO_DATA('DD_ECT_ESTADO_CONSTRUCCION' 	,'DD_ECT_ID,DD_ECT_CODIGO'																									,'DD_ECT_IDX'	),
		T_TIPO_DATA('DD_EPU_ESTADO_PUBLICACION' 	,'DD_EPU_ID,DD_EPU_CODIGO'																									,'DD_EPU_IDX'	),
		T_TIPO_DATA('ACT_VIV_VIVIENDA' 				,'ICO_ID,VIV_REFORMA_CARP_INT,VIV_REFORMA_CARP_EXT,VIV_REFORMA_COCINA,VIV_REFORMA_BANYO,VIV_REFORMA_SUELO,VIV_REFORMA_PINTURA,VIV_REFORMA_INTEGRAL,VIV_REFORMA_OTRO'		,'ACT_VIV_IDX'	),
		T_TIPO_DATA('ACT_ADM_INF_ADMINISTRATIVA' 	,'ACT_ID,ADM_ID,DD_TVP_ID'																									,'ACT_ADM_IDX'	),
		T_TIPO_DATA('DD_TVP_TIPO_VPO' 				,'DD_TVP_ID,DD_TVP_CODIGO'																									,'DD_TVP_IDX'	),
		T_TIPO_DATA('DD_RTG_RATING_ACTIVO' 			,'DD_RTG_ID,DD_RTG_CODIGO'																									,'DD_RTG_IDX'	),
		T_TIPO_DATA('DD_CRA_CARTERA' 				,'DD_CRA_ID,DD_CRA_CODIGO'																									,'DD_CRA_IDX'	),
		T_TIPO_DATA('ACT_SPS_SIT_POSESORIA' 		,'ACT_ID,SPS_ID,SPS_RIESGO_OCUPACION,SPS_FECHA_TOMA_POSESION,SPS_FECHA_TITULO,SPS_FECHA_VENC_TITULO,SPS_RENTA_MENSUAL'		,'ACT_SPS_IDX'	),
		T_TIPO_DATA('ACT_ZCO_ZONA_COMUN' 			,'ICO_ID,ZCO_ID,ZCO_PISCINA'																								,'ACT_ZCO_IDX'	),
		T_TIPO_DATA('ACT_ICO_INFO_COMERCIAL' 		,'ACT_ID,ICO_ID,ICO_FECHA_ACEPTACION'																						,'ACT_ICO_IDX'	),
		T_TIPO_DATA('ACT_VIV_VIVIENDA' 				,'ICO_ID,VIV_NUM_PLANTAS_INTERIOR'																							,'ACT_VID_IDX'	),
		T_TIPO_DATA('ACT_PAC_PROPIETARIO_ACTIVO'	,'ACT_ID,PAC_ID,PAC_PORC_PROPIEDAD'																							,'ACT_PAC_IDX0'	),
		T_TIPO_DATA('DD_TAG_TIPO_AGRUPACION' 		,'DD_TAG_ID,DD_TAG_CODIGO'																									,'DD_TAG_IDX'	),
		T_TIPO_DATA('ACT_AGR_AGRUPACION' 			,'AGR_ID,DD_TAG_ID,BORRADO,AGR_FECHA_BAJA,AGR_NUM_AGRUP_REM,AGR_ACT_PRINCIPAL'												,'ACT_AGR_IDX'	),
		T_TIPO_DATA('DD_TPC_TIPO_PRECIO' 			,'DD_TPC_ID,DD_TPC_CODIGO'																									,'DD_TPC_IDX'	),
		T_TIPO_DATA('ACT_HVA_HIST_VALORACIONES' 	,'ACT_ID,HVA_ID,DD_TPC_ID,HVA_IMPORTE,HVA_FECHA_INICIO'																		,'ACT_HVA_IDX'	),
		T_TIPO_DATA('ACT_VAL_VALORACIONES' 			,'ACT_ID,VAL_ID,DD_TPC_ID,VAL_IMPORTE,VAL_FECHA_INICIO,VAL_FECHA_FIN'														,'ACT_VAL_IDX'	),
		T_TIPO_DATA('DD_TCE_TIPO_CALIF_ENERGETICA' 	,'DD_TCE_ID,DD_TCE_CODIGO'																									,'DD_TCE_IDX'	),
		T_TIPO_DATA('ACT_ADO_ADMISION_DOCUMENTO' 	,'ACT_ID,ADO_ID,DD_TCE_ID'																									,'ACT_ADO_IDX'	),
		T_TIPO_DATA('ACT_REG_INFO_REGISTRAL' 		,'ACT_ID,REG_ID,DD_EON_ID,REG_DIV_HOR_INSCRITO'																				,'ACT_REG_IDX'	),
		T_TIPO_DATA('BIE_DATOS_REGISTRALES' 		,'BIE_ID,BIE_DREG_ID,BIE_DREG_FECHA_INSCRIPCION'																			,'BIE_REG_IDX'	),
		T_TIPO_DATA('ACT_ACTIVO' 					,'ACT_ID,BIE_ID,DD_EAC_ID,ACT_CON_CARGAS'																					,'ACT_ACTIVO_IDX'	),
		T_TIPO_DATA('ACT_SPS_SIT_POSESORIA' 		,'ACT_ID,SPS_OCUPADO,SPS_CON_TITULO,SPS_ACC_TAPIADO,SPS_OTRO,SPS_FECHA_TOMA_POSESION'										,'ACT_SPS_IDX'	),
		T_TIPO_DATA('COM_COMPRADOR' 				,'COM_DOCUMENTO'																											,'UN_COM_DOC'	),
		T_TIPO_DATA('BIE_LOCALIZACION' 				,'BIE_ID,DD_TVI_ID,BIE_LOC_NOMBRE_VIA,BIE_LOC_NUMERO_DOMICILIO,BIE_LOC_PUERTA'												,'BIE_LOC_IDX'	),
		T_TIPO_DATA('ACT_PAC_PERIMETRO_ACTIVO' 		,'PAC_ID,ACT_ID,BORRADO,PAC_CHECK_COMERCIALIZAR'																			,'ACT_PAC_IDX'	),
		T_TIPO_DATA('ACT_VAL_VALORACIONES' 			,'ACT_ID,VAL_ID,DD_TPC_ID,VAL_IMPORTE,VAL_FECHA_INICIO,VAL_FECHA_FIN,BORRADO'												,'ACT_VAL_IDX'	),
		T_TIPO_DATA('ACT_ACTIVO' 					,'ACT_ID,DD_CRA_ID,DD_SCR_ID,DD_EAC_ID,ACT_FECHA_IND_PRECIAR,ACT_FECHA_IND_REPRECIAR,ACT_BLOQUEO_PRECIO_FECHA_INI'			,'ACT_ACTIVO_IDX'	)
	);
    V_TMP_TIPO_DATA T_TIPO_DATA;
	
BEGIN
	
	 -- LOOP para AÑADIR LAS COLUMNAS DE V_TIPO_DATA-----------------------------------------------------------------
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	
			-- Creamos indice V_TMP_TIPO_DATA(3) para las columnas V_TMP_TIPO_DATA(2)
			V_NUM_INDEX := 1;
			WHILE V_NUM_INDEX > 0 
			LOOP
				-- Comprobamos que no haya ningún índice con el mismo nombre
				V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = '''||TRIM(V_TMP_TIPO_DATA(3))||''||TO_CHAR(V_NUM_INDEX)||''' ';
				EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
				IF V_NUM_TABLAS = 0 THEN
					
					--Comprobamos si ya existe un indice para las columnas de la tabla
					V_MSQL := '
						SELECT COUNT(1) 
							FROM( SELECT index_name, listagg(column_name,'','') within group (order by column_position) columnas
							FROM ALL_IND_COLUMNS
							WHERE table_name = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
							AND index_owner='''||V_ESQUEMA||'''
							GROUP BY index_name
							) sqli
							WHERE sqli.columnas = UPPER('''||TRIM(V_TMP_TIPO_DATA(2))||''')
					';
					EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
					
					IF V_NUM_TABLAS = 0 THEN
						V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||TRIM(V_TMP_TIPO_DATA(3))||''||TO_CHAR(V_NUM_INDEX)||' ON '||V_ESQUEMA||'.'||TRIM(V_TMP_TIPO_DATA(1))||' ('||UPPER(TRIM(V_TMP_TIPO_DATA(2)))||') TABLESPACE '||V_TABLESPACE_IDX;		
						EXECUTE IMMEDIATE V_MSQL;
						DBMS_OUTPUT.PUT_LINE('[INFO] Indice '||TRIM(V_TMP_TIPO_DATA(3))||''||TO_CHAR(V_NUM_INDEX)||' - ('||TRIM(V_TMP_TIPO_DATA(2))||')  - creado.');
					ELSE
						DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe un indice en '||TRIM(V_TMP_TIPO_DATA(1))||' para las columnas '''||TRIM(V_TMP_TIPO_DATA(2))||'''');
					END IF;
					
					V_NUM_INDEX := 0;
				ELSE
					DBMS_OUTPUT.PUT_LINE('[INFO] Indice '||TRIM(V_TMP_TIPO_DATA(3))||''||TO_CHAR(V_NUM_INDEX)||' - Ya existe índice con este nombre - probamos con nombre con la numeración siguiente');
					V_NUM_INDEX := V_NUM_INDEX + 1;
				END IF;
			END LOOP;
	  END LOOP;	
	
	COMMIT;



EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
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