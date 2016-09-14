--/*
--##########################################
--## AUTOR=CLV
--## FECHA_CREACION=20160907
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en '||V_TEXT_TABLA||' los datos añadidos en T_ARRAY_DATA
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
        T_TIPO_DATA('01'	,'Fecha inscripción requerida'						,'Fecha inscripción requerida','INNER JOIN REM01.ACT_TIT_TITULO TIT	ON TIT.ACT_ID = ACT.ACT_ID AND TIT.TIT_FECHA_INSC_REG IS NOT NULL AND TIT.BORRADO = 0'),
        T_TIPO_DATA('02'	,'Fecha posesión inicial requerida'					,'Fecha posesión inicial requerida','INNER JOIN REM01.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID AND SPS.SPS_FECHA_TOMA_POSESION IS NOT NULL AND SPS.BORRADO = 0'),
        T_TIPO_DATA('03'	,'Fecha saneamiento concluido requerida'			,'Fecha saneamiento concluido requerida',''),
        T_TIPO_DATA('04'	,'Checking de información concluido'				,'Checking de información concluido','INNER JOIN REM01.ACT_LOC_LOCALIZACION LOC ON LOC.ACT_ID = ACT.ACT_ID
																													  INNER JOIN REM01.BIE_LOCALIZACION BIE ON BIE.BIE_LOC_ID = LOC.BIE_LOC_ID 
																														 AND BIE.BIE_LOC_NOMBRE_VIA IS NOT NULL 
																														 AND BIE.BIE_LOC_COD_POST IS NOT NULL
																														 AND BIE.BIE_LOC_POBLACION IS NOT NULL
																														 AND BIE.DD_TVI_ID IS NOT NULL
																														 AND BIE.DD_LOC_ID IS NOT NULL
																														 AND BIE.DD_CIC_ID IS NOT NULL
																													  INNER JOIN REM01.ACT_REG_INFO_REGISTRAL REG ON REG.ACT_ID = ACT.ACT_ID  AND REG.BORRADO = 0
																													  INNER JOIN REM01.BIE_DATOS_REGISTRALES DAT ON DAT.BIE_DREG_ID = REG.BIE_DREG_ID AND DAT.BORRADO = 0
																														 AND DAT.BIE_DREG_NUM_REGISTRO IS NOT NULL
																														 AND DAT.BIE_DREG_NUM_FINCA IS NOT NULL   
																														 AND DAT.DD_LOC_ID IS NOT NULL
																													  INNER JOIN REM01.ACT_PAC_PROPIETARIO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
																														 AND PAC.PRO_ID IS NOT NULL  
																														 AND PAC.DD_TGP_ID IS NOT NULL  
																														 AND PAC.PAC_PORC_PROPIEDAD IS NOT NULL  
																													  INNER JOIN REM01.ACT_CAT_CATASTRO CAT ON CAT.ACT_ID = ACT.ACT_ID AND CAT.BORRADO = 0
																														 AND CAT.CAT_REF_CATASTRAL IS NOT NULL
																													  INNER JOIN REM01.BIE_BIEN BIEN ON BIEN.BIE_ID = ACT.BIE_ID AND BIEN.BORRADO = 0  
																														 AND BIEN.DD_ORIGEN_ID IS NOT NULL
																														 AND ACT.ACT_DIVISION_HORIZONTAL IS NOT NULL   
																														 AND ACT.ACT_GESTION_HRE IS NOT NULL   
																														 AND ACT.ACT_VPO IS NOT NULL
																														 AND ACT.BORRADO = 0'),
        T_TIPO_DATA('05'	,'Con checking de documentación concluido'			,'Con checking de documentación concluido','INNER JOIN REM01.V_ADMISION_DOCUMENTOS ADM ON ADM.ACT_ID = ACT.ACT_ID AND ADM.ADO_FECHA_OBTENCION IS NOT NULL AND ADM.FLAG_APLICA = 1'),
        T_TIPO_DATA('06'	,'Con tasación realizada'							,'Con tasación realizada','INNER JOIN REM01.ACT_TAS_TASACION TAS ON TAS.ACT_ID = ACT.ACT_ID AND TAS.BORRADO = 0'),
        T_TIPO_DATA('07'	,'Con tasación realizada por'						,'Con tasación realizada por','INNER JOIN REM01.ACT_TAS_TASACION TASN ON TASN.ACT_ID = ACT.ACT_ID AND TASN.TAS_NOMBRE_TASADOR = :igual_a AND TAS.BORRADO = 0'),
        T_TIPO_DATA('08'	,'Con importe de tasación'							,'Con importe de tasación','INNER JOIN REM01.ACT_TAS_TASACION TASI ON TASI.ACT_ID = ACT.ACT_ID AND TASI.TAS_IMPORTE_TAS_FIN > :mayor_que AND TASI.TAS_IMPORTE_TAS_FIN < :menor_que AND TASI.BORRADO = 0'),
        T_TIPO_DATA('09'	,'Con antigüedad de tasación'						,'Con antigüedad de tasación','INNER JOIN REM01.ACT_TAS_TASACION TASF ON TASF.ACT_ID = ACT.ACT_ID AND TASF.TAS_FECHA_RECEPCION_TASACION < add_months(sysdate,-:menor_que*12) AND TASF.BORRADO = 0'),
        T_TIPO_DATA('10'	,'Con valor de tasación de venta rápida'			,'Con valor de tasación de venta rápida',''),
        T_TIPO_DATA('11'	,'Mediador asignado'								,'Mediador asignado','INNER JOIN REM01.ACT_ICO_INFO_COMERCIAL ICO1 ON ICO1.ACT_ID = ACT.ACT_ID AND ICO1.BORRADO = 0
																									  INNER JOIN REM01.ACT_PVE_PROVEEDOR PVE1 ON ICO1.ICO_MEDIADOR_ID = PVE1.PVE_ID AND PVE1.BORRADO = 0
																									  INNER JOIN REM01.DD_TPR_TIPO_PROVEEDOR DD_TPR1 ON DD_TPR1.DD_TPR_ID = PVE1.DD_TPR_ID AND DD_TPR1.DD_TPR_CODIGO = ''''04'''' AND DD_TPR1.BORRADO = 0 '),
        T_TIPO_DATA('12'	,'Mediador asignado o sin mediador si es subtipo suelo' ,'Mediador asignado o sin mediador si es subtipo suelo','INNER JOIN REM01.ACT_ICO_INFO_COMERCIAL ICO2 ON ICO2.ACT_ID = ACT.ACT_ID AND ICO2.BORRADO = 0
																																			 INNER JOIN REM01.ACT_PVE_PROVEEDOR PVE2 ON ICO2.ICO_MEDIADOR_ID = PVE2.PVE_ID AND PVE2.BORRADO = 0
																																			 INNER JOIN REM01.DD_TPR_TIPO_PROVEEDOR DD_TPR2 ON DD_TPR2.DD_TPR_ID = PVE2.DD_TPR_ID AND DD_TPR2.DD_TPR_CODIGO IN (''''01'''',''''04'''') AND DD_TPR2.BORRADO = 0 '),
        T_TIPO_DATA('13'	,'Sin ofertas vigentes'								,'Sin ofertas vigentes','INNER JOIN REM01.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID AND AGA.BORRADO = 0
																											AND NOT EXISTS (SELECT 1 FROM REM01.OFR_OFERTAS OFR WHERE OFR.AGR_ID = AGA.AGR_ID 
																											AND OFR.BORRADO = 0 AND OFR.DD_EOF_ID = (SELECT EOF.DD_EOF_ID FROM REM01.DD_EOF_ESTADOS_OFERTA EOF WHERE EOF.DD_EOF_CODIGO IN (''''01'''',''''04'''') AND OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 ))'),
        T_TIPO_DATA('14'	,'Activo disponible para venta'						,'Activo disponible para venta','INNER JOIN REM01.DD_SCM_SITUACION_COMERCIAL DD_SCM ON DD_SCM.DD_SCM_ID = ACT.DD_SCM_ID AND DD_SCM.DD_SCM_CODIGO = ''''02'''' '),
        T_TIPO_DATA('15'	,'Activo incluído en perímetro alquilable'			,'Activo incluído en perímetro alquilable',''),
        T_TIPO_DATA('16'	,'Sin precio mínimo'								,'Sin precio mínimo','INNER JOIN REM01.ACT_VAL_VALORACIONES VAL ON VAL.ACT_ID = ACT.ACT_ID AND VAL.BORRADO = 0 AND NOT EXISTS (SELECT 1 FROM REM01.DD_TPC_TIPO_PRECIO DD_TPC WHERE VAL.DD_TPC_ID =DD_TPC.DD_TPC_ID AND DD_TPC.BORRADO = 0 AND DD_TPC.DD_TPC_CODIGO = ''''04'''')'),
        T_TIPO_DATA('17'	,'Sin precio mínimo o con precio mínimo anterior'	,'Sin precio mínimo o con precio mínimo anterior','INNER JOIN REM01.ACT_VAL_VALORACIONES VALA ON VALA.ACT_ID = ACT.ACT_ID AND VALA.BORRADO = 0
																																	   AND (NOT EXISTS (SELECT 1 FROM REM01.DD_TPC_TIPO_PRECIO DD_TPC WHERE VALA.DD_TPC_ID =DD_TPC.DD_TPC_ID AND DD_TPC.DD_TPC_CODIGO = ''''04'''' AND DD_TPC.BORRADO = 0)
																																		 OR (TO_CHAR(VALA.VAL_FECHA_INICIO,''''YYYY'''') < :menor_que /*TO_CHAR(SYSDATE,''''YYYY'''')*/
																																			   AND (VALA.VAL_FECHA_FIN IS NULL OR VALA.VAL_FECHA_FIN <= SYSDATE)))'),
        T_TIPO_DATA('18'	,'Sin propuesta de precios en curso'				,'Sin propuesta de precios en curso','AND NOT EXISTS (SELECT 1 FROM REM01.ACT_PRP	PRP WHERE PRP.ACT_ID = ACT.ACT_ID)'),
        T_TIPO_DATA('31'	,'Con al menos 1 precio existente [minimo autorizado o aprobado venta o aprobado renta]'				,'Con al menos 1 precio existente [minimo autorizado o aprobado venta o aprobado renta]','INNER JOIN REM01.ACT_VAL_VALORACIONES VAL31 ON VAL31.ACT_ID = ACT.ACT_ID AND VAL31.BORRADO = 0 AND VAL31.DD_TPC_ID = (SELECT DD_TPC31.DD_TPC_ID FROM REM01.DD_TPC_TIPO_PRECIO DD_TPC31 WHERE DD_TPC31.DD_TPC_ID = VAL31.DD_TPC_ID  AND DD_TPC31.DD_TPC_CODIGO IN (''''02'''',''''03'''',''''04'''') AND DD_TPC31.BORRADO = 0) 
																																																								AND (TO_CHAR(VAL31.VAL_FECHA_INICIO,''''YYYY'''') < TO_CHAR(SYSDATE,''''YYYY'''') 
																																																								AND (VAL31.VAL_FECHA_FIN IS NULL OR VAL31.VAL_FECHA_FIN <= SYSDATE))'),
        T_TIPO_DATA('32'	,'Si hay valor FSV || F. valor FSV > F. tasación > F. precio existente'				,'Si hay valor FSV || F. valor FSV > F. tasación > F. precio existente','INNER JOIN REM01.ACT_VAL_VALORACIONES VAL32 ON VAL32.ACT_ID = ACT.ACT_ID 
																																																  AND VAL32.BORRADO = 0 
																																																  AND VAL32.DD_TPC_ID = (SELECT DD_TPC32.DD_TPC_ID FROM REM01.DD_TPC_TIPO_PRECIO DD_TPC32 WHERE DD_TPC32.DD_TPC_ID = VAL32.DD_TPC_ID  AND DD_TPC32.DD_TPC_CODIGO IN (''''19'''',''''20'''') AND DD_TPC32.BORRADO = 0)
																																																  AND VAL32.VAL_FECHA_INICIO < SYSDATE
																																																  AND (VAL32.VAL_FECHA_FIN IS NOT NULL OR VAL32.VAL_FECHA_FIN <= SYSDATE)
																																														INNER JOIN REM01.ACT_TAS_TASACION TAS32 ON TAS32.ACT_ID = VAL32.ACT_ID
																																																  AND VAL32.VAL_FECHA_INICIO > TAS32.TAS_FECHA_RECEPCION_TASACION
																																																  AND TAS32.BORRADO = 0      
																																														INNER JOIN REM01.ACT_VAL_VALORACIONES VAL32_AUX ON VAL32_AUX.ACT_ID = ACT.ACT_ID 
																																																  AND VAL32_AUX.DD_TPC_ID = (SELECT DD_TPC31.DD_TPC_ID FROM REM01.DD_TPC_TIPO_PRECIO DD_TPC31 WHERE DD_TPC31.DD_TPC_ID = VAL32_AUX.DD_TPC_ID  AND DD_TPC31.DD_TPC_CODIGO IN (''''02'''',''''03'''',''''04'''') AND DD_TPC31.BORRADO = 0)
																																																  AND VAL32_AUX.VAL_FECHA_INICIO < SYSDATE
																																																  AND (VAL32_AUX.VAL_FECHA_FIN IS NULL OR VAL32_AUX.VAL_FECHA_FIN <= SYSDATE)
																																																  AND TAS32.TAS_FECHA_RECEPCION_TASACION >VAL32_AUX.VAL_FECHA_INICIO'),
        T_TIPO_DATA('33'	,'Si hay valor JLL || F. valor JLL > F. tasación > F. precio existente'				,'Si hay valor JLL || F. valor JLL > F. tasación > F. precio existente','INNER JOIN REM01.ACT_VAL_VALORACIONES VAL32 ON VAL32.ACT_ID = ACT.ACT_ID 
																																																  AND VAL32.BORRADO = 0 
																																																  AND VAL32.DD_TPC_ID = (SELECT DD_TPC32.DD_TPC_ID FROM REM01.DD_TPC_TIPO_PRECIO DD_TPC32 WHERE DD_TPC32.DD_TPC_ID = VAL32.DD_TPC_ID  AND DD_TPC32.DD_TPC_CODIGO IN (''''16'''') AND DD_TPC32.BORRADO = 0)
																																																  AND VAL32.VAL_FECHA_INICIO < SYSDATE
																																																  AND (VAL32.VAL_FECHA_FIN IS NOT NULL OR VAL32.VAL_FECHA_FIN <= SYSDATE)
																																														INNER JOIN REM01.ACT_TAS_TASACION TAS32 ON TAS32.ACT_ID = VAL32.ACT_ID
																																																  AND VAL32.VAL_FECHA_INICIO > TAS32.TAS_FECHA_RECEPCION_TASACION
																																																  AND TAS32.BORRADO = 0      
																																														INNER JOIN REM01.ACT_VAL_VALORACIONES VAL32_AUX ON VAL32_AUX.ACT_ID = ACT.ACT_ID 
																																																  AND VAL32_AUX.DD_TPC_ID = (SELECT DD_TPC31.DD_TPC_ID FROM REM01.DD_TPC_TIPO_PRECIO DD_TPC31 WHERE DD_TPC31.DD_TPC_ID = VAL32_AUX.DD_TPC_ID  AND DD_TPC31.DD_TPC_CODIGO IN (''''02'''',''''03'''',''''04'''') AND DD_TPC31.BORRADO = 0)
																																																  AND VAL32_AUX.VAL_FECHA_INICIO < SYSDATE
																																																  AND (VAL32_AUX.VAL_FECHA_FIN IS NULL OR VAL32_AUX.VAL_FECHA_FIN <= SY'),
        T_TIPO_DATA('34'	,'Sin FSV ni JLL || F. valor Neto Contable >= F. tasacion > F. precio existente'				,'Sin FSV ni JLL || F. valor Neto Contable >= F. tasacion > F. precio existente','INNER JOIN REM01.ACT_VAL_VALORACIONES VAL34 ON VAL34.ACT_ID = ACT.ACT_ID 
																																																						  AND VAL34.BORRADO = 0 
																																																						  AND VAL34.DD_TPC_ID = (SELECT DD_TPC34.DD_TPC_ID FROM REM01.DD_TPC_TIPO_PRECIO DD_TPC34 WHERE DD_TPC34.DD_TPC_ID = VAL34.DD_TPC_ID  AND DD_TPC34.DD_TPC_CODIGO NOT IN (''''16'''',''''19'''',''''20'''') AND DD_TPC34.BORRADO = 0)
																																																						  AND VAL34.DD_TPC_ID = (SELECT DD_TPC34.DD_TPC_ID FROM REM01.DD_TPC_TIPO_PRECIO DD_TPC34 WHERE DD_TPC34.DD_TPC_ID = VAL34.DD_TPC_ID  AND DD_TPC34.DD_TPC_CODIGO = (''''01'''') AND DD_TPC34.BORRADO = 0)
																																																						  AND VAL34.VAL_FECHA_INICIO < SYSDATE
																																																						  AND (VAL34.VAL_FECHA_FIN IS NOT NULL OR VAL34.VAL_FECHA_FIN > SYSDATE)
																																																				INNER JOIN REM01.ACT_TAS_TASACION TAS34 ON TAS34.ACT_ID = VAL34.ACT_ID
																																																						  AND TAS34.BORRADO = 0     
																																																						  AND VAL34.VAL_FECHA_INICIO > TAS34.TAS_FECHA_RECEPCION_TASACION
																																																				INNER JOIN REM01.ACT_VAL_VALORACIONES VAL34_AUX ON VAL34_AUX.ACT_ID = ACT.ACT_ID 
																																																						  AND VAL34_AUX.DD_TPC_ID = (SELECT DD_TPC34.DD_TPC_ID FROM REM01.DD_TPC_TIPO_PRECIO DD_TPC34 WHERE DD_TPC34.DD_TPC_ID = VAL34_AUX.DD_TPC_ID  AND DD_TPC34.DD_TPC_CODIGO IN (''''02'''',''''03'''',''''04'''') AND DD_TPC34.BORRADO = 0)
																																																						  AND VAL34_AUX.VAL_FECHA_INICIO < SYSDATE
																																																						  AND (VAL34_AUX.VAL_FECHA_FIN IS NULL OR VAL34_AUX.VAL_FECHA_FIN <= SYSDATE)
																																																						  AND TAS34.TAS_FECHA_RECEPCION_TASACION >VAL34_AUX.VAL_FECHA_INICIO'),
        T_TIPO_DATA('35'	,'Con Valor Neto Contable > Precio existente'				,'Con Valor Neto Contable > Precio existente','INNER JOIN REM01.ACT_VAL_VALORACIONES VAL35 ON VAL35.ACT_ID = ACT.ACT_ID 
																																				  AND VAL35.BORRADO = 0 
																																				  AND VAL35.DD_TPC_ID = (SELECT DD_TPC35.DD_TPC_ID FROM REM01.DD_TPC_TIPO_PRECIO DD_TPC35 WHERE DD_TPC35.DD_TPC_ID = VAL35.DD_TPC_ID  AND DD_TPC35.DD_TPC_CODIGO IN (''''01'''') AND DD_TPC35.BORRADO = 0)
																																				  AND VAL35.VAL_FECHA_INICIO < SYSDATE
																																				  AND (VAL35.VAL_FECHA_FIN IS NOT NULL OR VAL35.VAL_FECHA_FIN > SYSDATE)
																																		INNER JOIN REM01.ACT_TAS_TASACION TAS35 ON TAS35.ACT_ID = VAL35.ACT_ID
																																				  AND TAS35.BORRADO = 0      
																																		INNER JOIN REM01.ACT_VAL_VALORACIONES VAL35_AUX ON VAL35_AUX.ACT_ID = ACT.ACT_ID 
																																				  AND VAL35_AUX.DD_TPC_ID = (SELECT DD_TPC35.DD_TPC_ID FROM REM01.DD_TPC_TIPO_PRECIO DD_TPC35 WHERE DD_TPC35.DD_TPC_ID = VAL35_AUX.DD_TPC_ID  AND DD_TPC35.DD_TPC_CODIGO IN (''''02'''',''''03'''',''''04'''') AND DD_TPC35.BORRADO = 0)
																																				  AND VAL35_AUX.VAL_FECHA_INICIO < SYSDATE
																																				  AND (VAL35_AUX.VAL_FECHA_FIN IS NULL OR VAL35_AUX.VAL_FECHA_FIN <= SYSDATE)
																																				  AND TAS35.TAS_FECHA_RECEPCION_TASACION >VAL35_AUX.VAL_FECHA_INICIO'),
        T_TIPO_DATA('36'	,'Tasación realizada por proveedor xx'				,'Tasación realizada por proveedor xx','INNER JOIN REM01.ACT_TAS_TASACION TAS36 ON TAS36.ACT_ID = TAS36.ACT_ID AND TAS36.TAS_NOMBRE_TASADOR	 = :igual_a '),
        T_TIPO_DATA('37'	,'F. tasación > F. precio existente'				,'F. tasación > F. precio existente','INNER JOIN REM01.ACT_VAL_VALORACIONES VAL37 ON VAL37.ACT_ID = ACT.ACT_ID 
																																  AND VAL37.BORRADO = 0 
																																  AND VAL37.VAL_FECHA_INICIO < SYSDATE
																																  AND (VAL37.VAL_FECHA_FIN IS NOT NULL OR VAL37.VAL_FECHA_FIN > SYSDATE)
																														INNER JOIN REM01.ACT_TAS_TASACION TAS37 ON TAS37.ACT_ID = VAL37.ACT_ID
																																  AND TAS37.BORRADO = 0      
																														INNER JOIN REM01.ACT_VAL_VALORACIONES VAL37_AUX ON VAL37_AUX.ACT_ID = ACT.ACT_ID 
																																  AND VAL37_AUX.DD_TPC_ID = (SELECT DD_TPC37.DD_TPC_ID FROM REM01.DD_TPC_TIPO_PRECIO DD_TPC37 WHERE DD_TPC37.DD_TPC_ID = VAL37_AUX.DD_TPC_ID  AND DD_TPC37.DD_TPC_CODIGO IN (''''02'''',''''03'''',''''04'''') AND DD_TPC37.BORRADO = 0)
																																  AND VAL37_AUX.VAL_FECHA_INICIO < SYSDATE
																																  AND (VAL37_AUX.VAL_FECHA_FIN IS NULL OR VAL37_AUX.VAL_FECHA_FIN <= SYSDATE)
																																  AND TAS37.TAS_FECHA_RECEPCION_TASACION >VAL37_AUX.VAL_FECHA_INICIO'),
        T_TIPO_DATA('38'	,'Con propuesta de precios que modifica aprobado venta'				,'Con propuesta de precios que modifica aprobado venta',''),
        T_TIPO_DATA('39'	,'Con periodo vigencia a F. venc || Con F. venc Precio existente y F. vencimiento - xx dias >= hoy'				,'Con periodo vigencia a F. aprobación || Sin F. vencimiento Precio existente y F. aprobación + xx días =< hoy','INNER JOIN REM01.ACT_VAL_VALORACIONES VAL40 ON VAL40.ACT_ID = ACT.ACT_ID 
																																																																		   AND VAL40.BORRADO = 0 
																																																																		   AND VAL40.DD_TPC_ID = (SELECT DD_TPC40.DD_TPC_ID FROM REM01.DD_TPC_TIPO_PRECIO DD_TPC40 WHERE DD_TPC40.DD_TPC_ID = VAL31.DD_TPC_ID  AND DD_TPC40.DD_TPC_CODIGO IN (''''02'''',''''03'''',''''04'''') AND DD_TPC40.BORRADO = 0)
																																																																		   AND VAL40.VAL_FECHA_INICIO < SYSDATE 
																																																																		   AND (VAL40.VAL_FECHA_FIN IS NULL OR VAL40.VAL_FECHA_FIN - :igual_a <= SYSDATE)'),
        T_TIPO_DATA('40'	,'Con periodo vigencia a F. venc || Con F. venc Precio existente y F. vencimiento - xx dias >= hoy'				,'Con periodo vigencia a F. vencimiento || Con F. vencimiento Precio existente y F. vencimiento - xx dias >= hoy','INNER JOIN REM01.ACT_VAL_VALORACIONES VAL40 ON VAL40.ACT_ID = ACT.ACT_ID 
																																																																						  AND VAL40.BORRADO = 0 
																																																																						  AND VAL40.DD_TPC_ID = (SELECT DD_TPC40.DD_TPC_ID FROM REM01.DD_TPC_TIPO_PRECIO DD_TPC40 WHERE DD_TPC40.DD_TPC_ID = VAL31.DD_TPC_ID  AND DD_TPC40.DD_TPC_CODIGO IN (''''02'''',''''03'''',''''04'''') AND DD_TPC40.BORRADO = 0)
																																																																						  AND VAL40.VAL_FECHA_INICIO < SYSDATE 
																																																																						  AND (VAL40.VAL_FECHA_FIN IS NULL OR VAL40.VAL_FECHA_FIN - :igual_a > SYSDATE)')
        
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
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
					', USUARIOMODIFICAR = ''HREOS_758'' , FECHAMODIFICAR = SYSDATE '||
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
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''', 0, ''HREOS_758'',SYSDATE,0 FROM DUAL';
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
