--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200702
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-7702
--## PRODUCTO=NO
--##
--## Finalidad: Script que crea ofertas y expedientes.
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
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA(6013482,'1764307','S0361/2019','2019/01/14','2019/01/17',114000,1531074,1531074,'','2019/02/26'),
		T_TIPO_DATA(6013483,'1764309','S5442/2020','2020/01/24','2020/01/27',1142500,1531074,1531074,'', '2020/02/11')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_LOC_LOCALIDAD -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN OFR_OFERTAS] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: EL REGISTRO YA EXISTE '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_OFR_OFERTAS.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.OFR_OFERTAS (' ||
                      	'OFR_ID, OFR_NUM_OFERTA, OFR_IMPORTE, AGR_ID, CLC_ID, OFR_FECHA_ALTA, DD_EOF_ID, DD_TOF_ID, PVE_ID_CUSTODIO, PVE_ID_PRESCRIPTOR, VERSION, USUARIOCREAR, FECHACREAR, BORRADO , OFR_COD_DIVARIAN) 		'||
                      	'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(6))||''',(SELECT AGR_ID FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION WHERE AGR_NUM_AGRUP_UVEM='''||V_TMP_TIPO_DATA(9)||'''),(SELECT CLC_ID FROM '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL WHERE CLC_COD_CLIENTE_PRINEX='''||TRIM(V_TMP_TIPO_DATA(2))||''')	'||',TO_DATE('''||TRIM(V_TMP_TIPO_DATA(4))||''', ''yyyy/mm/dd''), (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO=''02''), (SELECT DD_TOF_ID FROM '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA WHERE DD_TOF_CODIGO=''01''), (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_ORIGEN='''||TRIM(V_TMP_TIPO_DATA(7))||'''),(SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_ORIGEN='''||TRIM(V_TMP_TIPO_DATA(8))||'''),0, ''REMVIP-7702'',SYSDATE,0, '''||TRIM(V_TMP_TIPO_DATA(3))||''' FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_ECO_EXPEDIENTE_COMERCIAL.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL (' ||
                      	'ECO_ID,
			 ECO_NUM_EXPEDIENTE,
			 OFR_ID, DD_EEC_ID, ECO_FECHA_ALTA, ECO_FECHA_SANCION, ECO_FECHA_ANULACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 		'||
                      	'SELECT '|| V_ID || ','|| V_ESQUEMA ||'.S_ECO_NUM_EXPEDIENTE.NEXTVAL, (SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA='''||V_TMP_TIPO_DATA(1)||'''), (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO=''02''), TO_DATE('''||TRIM(V_TMP_TIPO_DATA(4))||''', ''yyyy/mm/dd''), TO_DATE('''||TRIM(V_TMP_TIPO_DATA(5))||''', ''yyyy/mm/dd''), TO_DATE('''||TRIM(V_TMP_TIPO_DATA(10))||''', ''yyyy/mm/dd'') ,0, ''REMVIP-7702'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE EN LA ECO');
       END IF;

      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: HA ACABADO CORRECTAMENTE LA INSERCIÓN DE EXPEDIENTES Y OFERTAS');
   

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
