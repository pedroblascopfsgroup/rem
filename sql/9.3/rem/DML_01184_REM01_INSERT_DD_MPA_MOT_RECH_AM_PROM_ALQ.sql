--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220921
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18765
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica en DD_MPA_MOT_RECH_AM_PROM_ALQ los datos añadidos de T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-18765] - Alejandra García
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
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      	  /*T_TIPO_DATA('F01' ,'El activo entra en concurrencia, y tiene ofertas vivas' , '1', 'JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0 JOIN '||V_ESQUEMA||'.ACT_OFR ACTOFR ON ACTOFR.ACT_ID = ACT.ACT_ID JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ACTOFR.OFR_ID AND OFR.BORRADO = 0 JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID AND EOF.BORRADO = 0 LEFT JOIN '||V_ESQUEMA||'.CON_CONCURRENCIA CON ON CON.ACT_ID = ACT.ACT_ID AND CON.BORRADO = 0 WHERE EOF.DD_EOF_CODIGO NOT IN (''''02'''',''''06'''') AND (CON.CON_ID IS NULL OR TRUNC(TO_DATE(AUX.FEC_INICIO_CONCURENCIA, ''''yyyymmdd'''')) <> TRUNC(CON.CON_FECHA_INI)) AND AUX.FEC_INICIO_CONCURENCIA IS NOT NULL AND AUX.FEC_FIN_CONCURENCIA IS NOT NULL' )

?????     T_TIPO_DATA('F01' ,'El activo no está incluido en el perímetro de alquiler' , '1', '' )
?????   ,*/ T_TIPO_DATA('F02' ,'El activo no está dentro del perímetro HAYA' , '1', 'JOIN '||V_ESQUEMA||'.AUX_NUM_UNIDAD_AM AM ON AM.NUM_UNIDAD = AUX.NUM_UNIDAD JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = AM.ACT_ID AND PAC.BORRADO = 0 WHERE PAC.PAC_INCLUIDO = 1 AND AM.NOMBRE_FICHERO = ''''"+context.nombreFichero+"'''' ' )
        , T_TIPO_DATA('F03' ,'El activo tiene una situación comercial igual a vendido' , '1', 'JOIN '||V_ESQUEMA||'.AUX_NUM_UNIDAD_AM AM ON AM.NUM_UNIDAD = AUX.NUM_UNIDAD JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AM.ACT_ID AND ACT.BORRADO = 0 JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.BORRADO = 0 WHERE SCM.DD_SCM_CODIGO = ''''05'''' AND AM.NOMBRE_FICHERO = ''''"+context.nombreFichero+"'''' ' )
        , T_TIPO_DATA('F04' ,'El activo tiene el tipo de título igual a unidad alquilable' , '1', 'JOIN '||V_ESQUEMA||'.AUX_NUM_UNIDAD_AM AM ON AM.NUM_UNIDAD = AUX.NUM_UNIDAD JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AM.ACT_ID AND ACT.BORRADO = 0 JOIN '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO TTA ON TTA.DD_TTA_ID = ACT.DD_TTA_ID AND TTA.BORRADO = 0 WHERE TTA.DD_TTA_CODIGO = ''''05'''' AND AM.NOMBRE_FICHERO = ''''"+context.nombreFichero+"''''' )
        , T_TIPO_DATA('F05' ,'El activo no tiene patrimonio' , '1', 'JOIN '||V_ESQUEMA||'.AUX_NUM_UNIDAD_AM AM ON AM.NUM_UNIDAD = AUX.NUM_UNIDAD WHERE NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA WHERE PTA.ACT_ID = AM.ACT_ID AND PTA.BORRADO = 0 ) AND AM.NOMBRE_FICHERO = ''''"+context.nombreFichero+"'''' ' )
        , T_TIPO_DATA('F06' ,'El activo tiene ofertas vivas' , '1', 'JOIN '||V_ESQUEMA||'.AUX_NUM_UNIDAD_AM AM ON AM.NUM_UNIDAD = AUX.NUM_UNIDAD JOIN ACT_OFR ACTOF ON ACT.ACT_ID = ACTOF.ACT_ID JOIN OFR_OFERTAS OFR ON ACTOF.OFR_ID = OFR.OFR_ID AND OFR.BORRADO = 0 JOIN DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 JOIN ECO_EXPEDIENTE_COMERCIAL ECO ON OFR.OFR_ID = ECO.OFR_ID AND ECO.BORRADO = 0 JOIN DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID AND EEC.BORRADO = 0 WHERE EOF.DD_EOF_CODIGO = ''''01'''' AND EEC.DD_EEC_CODIGO NOT IN (''''02'''',''''08'''',''''03'''') AND AM.NOMBRE_FICHERO = ''''"+context.nombreFichero+"'''' ' )
        , T_TIPO_DATA('F07' ,'El activo tiene un estado de alquiler distinto de libre' , '1', 'JOIN '||V_ESQUEMA||'.AUX_NUM_UNIDAD_AM AM ON AM.NUM_UNIDAD = AUX.NUM_UNIDAD JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA ON PTA.ACT_ID = AM.ACT_ID AND PTA.BORRADO = 0 JOIN '||V_ESQUEMA||'.DD_EAL_ESTADO_ALQUILER EAL ON EAL.DD_EAL_ID = PTA.DD_EAL_ID AND EAL.BORRADO = 0 WHERE EAL.DD_EAL_CODIGO <> ''''01'''' AND AM.NOMBRE_FICHERO = ''''"+context.nombreFichero+"'''' ' )
        , T_TIPO_DATA('F08' ,'El activo no tiene ni el supervisor comercial alquiler ni el gestor comercial alquiler' , '1', 'JOIN '||V_ESQUEMA||'.AUX_NUM_UNIDAD_AM AM ON AM.NUM_UNIDAD = AUX.NUM_UNIDAD JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = AM.ACT_ID JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID AND GEE.BORRADO = 0 JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.BORRADO = 0 WHERE TGE.DD_TGE_CODIGO NOT IN (''''GESTCOMALQ'''',''''SUPCOMALQ'''') AND AM.NOMBRE_FICHERO = ''''"+context.nombreFichero+"'''' ' )
        , T_TIPO_DATA('F09' ,'El activo pertenece a otra promoción alquiler' , '1', 'JOIN '||V_ESQUEMA||'.AUX_NUM_UNIDAD_AM AM ON AM.NUM_UNIDAD = AUX.NUM_UNIDAD JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = AM.ACT_ID AND AGA.BORRADO = 0 JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0 JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0 WHERE TAG.DD_TAG_CODIGO = ''''16'''' AND AGR.AGR_FECHA_BAJA IS NULL AND AM.NOMBRE_FICHERO = ''''"+context.nombreFichero+"'''' ' )
        , T_TIPO_DATA('F10' ,'El activo pertenece a otra agrupación restringida (alquiler, venta u OB-REM) o a una comercial (venta o alquiler)' , '1', 'JOIN '||V_ESQUEMA||'.AUX_NUM_UNIDAD_AM AM ON AM.NUM_UNIDAD = AUX.NUM_UNIDAD JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = AM.ACT_ID AND AGA.BORRADO = 0 JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0 JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0 WHERE TAG.DD_TAG_CODIGO IN (''''02'''',''''17'''',''''18'''',''''14'''',''''15'''') AND AGR.AGR_FECHA_BAJA IS NULL AND AM.NOMBRE_FICHERO = ''''"+context.nombreFichero+"'''' ' )
        
		);
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_MPA_MOT_RECH_AM_PROM_ALQ -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_MPA_MOT_RECH_AM_PROM_ALQ] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_MPA_MOT_RECH_AM_PROM_ALQ WHERE DD_MPA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_MPA_MOT_RECH_AM_PROM_ALQ '||
                    'SET DD_MPA_DESCRIPCION = '''||SUBSTR(TRIM(V_TMP_TIPO_DATA(2)),0,100)||''''|| 
					', DD_MPA_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
					', PROCESO_VALIDAR = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', QUERY_ITER = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', USUARIOMODIFICAR = ''HREOS-18765'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_MPA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_MPA_MOT_RECH_AM_PROM_ALQ.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_MPA_MOT_RECH_AM_PROM_ALQ (' ||
                      'DD_MPA_ID, DD_MPA_CODIGO, DD_MPA_DESCRIPCION, DD_MPA_DESCRIPCION_LARGA, PROCESO_VALIDAR, QUERY_ITER, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||SUBSTR(TRIM(V_TMP_TIPO_DATA(2)),0,100)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''', '''||TRIM(V_TMP_TIPO_DATA(3))||''', '''||TRIM(V_TMP_TIPO_DATA(4))||''', 0, ''HREOS-18765'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_MPA_MOT_RECH_AM_PROM_ALQ ACTUALIZADO CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          DBMS_OUTPUT.put_line(V_MSQL);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
