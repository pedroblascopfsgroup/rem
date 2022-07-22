--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220711
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18259
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica en DD_MRC_MOTIVO_RECHAZO_CONCURRENCIA los datos añadidos de T_ARRAY_DATA
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
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      	  T_TIPO_DATA('F01' ,'El activo al cual han enviado un periodo de concurrencia, tiene ofertas vivas' , '1', 'WHERE AUX.FLAG_OFERTA_VIVA = 1 AND AUX.FEC_INICIO_CONCURENCIA IS NOT NULL AND AUX.FEC_FIN_CONCURENCIA IS NOT NULL' )
        , T_TIPO_DATA('F02' ,'El activo está en un periodo de concurrencia vivo y tiene una fecha inicio diferente a la recibida en el stock' , '1', 'JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0 JOIN '||V_ESQUEMA||'.CON_CONCURRENCIA CON ON CON.ACT_ID = ACT.ACT_ID AND CON.BORRADO = 0 WHERE SYSDATE BETWEEN CON.CON_FECHA_INI AND CON.CON_FECHA_FIN AND CON.CON_FECHA_INI <> TO_DATE(AUX.FEC_INICIO_CONCURENCIA, ''''dd/mm/yy'''')' )
        , T_TIPO_DATA('F03' ,'El activo está en un periodo de concurrencia vivo y tiene la misma fecha inicio que la recibida en el stock, pero la fecha fin recibida es menor a la que tiene y es diferente a la de hoy' , '1', 'JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0 JOIN '||V_ESQUEMA||'.CON_CONCURRENCIA CON ON CON.ACT_ID = ACT.ACT_ID AND CON.BORRADO = 0 WHERE SYSDATE BETWEEN CON.CON_FECHA_INI AND CON.CON_FECHA_FIN AND CON.CON_FECHA_INI = TO_DATE(AUX.FEC_INICIO_CONCURENCIA, ''''dd/mm/yy'''') AND TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''''dd/mm/yy'''') < CON.CON_FECHA_FIN AND TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''''dd/mm/yy'''') <> TRUNC(SYSDATE)' )
      	, T_TIPO_DATA('F04' ,'El activo es de alquiler' , '1', 'JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0 JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.BORRADO = 0 WHERE SCM.DD_SCM_CODIGO = ''''10''''' )
		    , T_TIPO_DATA('F05' ,'El activo es no comercializable o está fuera de perímetro haya' , '1', 'JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0 JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0 WHERE PAC.PAC_INCLUIDO = 0 OR PAC.PAC_CHECK_COMERCIALIZAR = 0 ' )
		    , T_TIPO_DATA('F06' ,'El activo no tiene un periodo vivo y recibe una fecha de inicio concurrencia anterior a hoy' , '1', 'JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0 LEFT JOIN '||V_ESQUEMA||'.CON_CONCURRENCIA CON ON CON.ACT_ID = ACT.ACT_ID AND CON.BORRADO = 0 WHERE (( SYSDATE < AUX.FEC_INICIO_CONCURENCIA OR SYSDATE > AUX.FEC_FIN_CONCURENCIA ) OR CON.CON_ID IS NULL) AND TRUNC(TO_DATE(AUX.FEC_INICIO_CONCURENCIA, ''''dd/mm/yy'''')) < TRUNC(SYSDATE) ' )
		), T_TIPO_DATA('F07' ,'El activo recibe una fecha fin menor a la de inicio' , '1', 'WHERE TO_DATE(AUX.FEC_INICIO_CONCURENCIA, ''''yyyymmdd'''') > TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''''yyyymmdd'''')' )
		), T_TIPO_DATA('F08' ,'El activo no está recibiendo un precio venta web' , '1', 'JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0 JOIN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL ON VAL.ACT_ID = ACT.ACT_ID AND VAL.BORRADO = 0 JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID =  VAL.DD_TPC_ID AND TPC.BORRADO = 0 WHERE VAL.VAL_IMPORTE IS NULL AND TPC.DD_TPC_CODIGO = ''''02'''' AND VAL.VAL_FECHA_FIN IS NULL AND AUX.IMP_PRECIO_VENTA IS NULL' )
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_MRC_MOTIVO_RECHAZO_CONCURRENCIA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_MRC_MOTIVO_RECHAZO_CONCURRENCIA] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_MRC_MOTIVO_RECHAZO_CONCURRENCIA WHERE DD_MRC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_MRC_MOTIVO_RECHAZO_CONCURRENCIA '||
                    'SET DD_MRC_DESCRIPCION = '''||SUBSTR(TRIM(V_TMP_TIPO_DATA(2)),0,100)||''''|| 
					', DD_MRC_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
					', PROCESO_VALIDAR = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', QUERY_ITER = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', USUARIOMODIFICAR = ''HREOS-18259'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_MRC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_MRC_MOTIVO_RECHAZO_CONCURRENCIA.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_MRC_MOTIVO_RECHAZO_CONCURRENCIA (' ||
                      'DD_MRC_ID, DD_MRC_CODIGO, DD_MRC_DESCRIPCION, DD_MRC_DESCRIPCION_LARGA, PROCESO_VALIDAR, QUERY_ITER, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||SUBSTR(TRIM(V_TMP_TIPO_DATA(2)),0,100)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''', '''||TRIM(V_TMP_TIPO_DATA(3))||''', '''||TRIM(V_TMP_TIPO_DATA(4))||''', 0, ''HREOS-18259'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_MRC_MOTIVO_RECHAZO_CONCURRENCIA ACTUALIZADO CORRECTAMENTE ');
   

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
