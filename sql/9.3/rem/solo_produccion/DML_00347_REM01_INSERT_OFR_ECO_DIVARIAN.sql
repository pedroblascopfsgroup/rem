--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200618
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-7567
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
    			-- OFR_NUM_OFERTA	DESCRIPCION		DESCRIPCION LARGA	DD_PRV_CODIGO
		T_TIPO_DATA(6013458,1675834,'2815956','2017/10/06','2019/01/17',200000,1529636,110167484,'','2019/12/02'),
		T_TIPO_DATA(6013459,1564439,'2905192','2017/12/15','',90000,1531567,1531567,'','2019/12/02'),
		T_TIPO_DATA(6013460,1673465,'2978109','2018/04/11','',210000,1529843,1534010,'','2019/25/09'),
		T_TIPO_DATA(6013461,1598136,'3003622','2018/09/18','',313050,1531670,1528120,'','2019/28/01'),
		T_TIPO_DATA(6013462,1671119,'3013531','2018/06/27','',385000,1530267,1530267,'','2020/23/03'),
		T_TIPO_DATA(6013463,1588428,'3014046','2018/08/28','2018/12/05',120800,1529077,1529077,'','2019/21/02'),
		T_TIPO_DATA(6013464,1579543,'3017444','2018/07/10','',210000,1529038,1530837,'','2019/18/11'),
		T_TIPO_DATA(6013465,1678092,'3025688','2018/07/30','',380000,1537500,1526824,'9277','2020/23/03'),
		T_TIPO_DATA(6013466,1588843,'3027195','2018/09/14','',200000,1543026,110167484,'','2020/23/03'),
		T_TIPO_DATA(6013467,1674746,'3027811','2018/08/24','2018/11/19',413200,1531734,1531708,'','2019/15/01'),
		T_TIPO_DATA(6013468,1642447,'3029940','2018/08/09','2019/07/22',9700,1537460,1530742,'', '2019/29/07'),
		T_TIPO_DATA(6013469,1658579,'3030181','2018/08/14','',78743,55009999,1540679,'','2019/14/02'),
		T_TIPO_DATA(6013470,1668409,'3034719','2018/08/28','2019/01/17',32400,1532597,1532576,'', '2019/13/11'),
		T_TIPO_DATA(6013471,1605748,'3034963','2018/08/27','2018/11/23',12600,1531670,1531613,'','2019/28/01'),
		T_TIPO_DATA(6013472,1677944,'3036590','2018/09/18','2019/02/12',42000,1533523,1544079,'', '2019/22/04'),
		T_TIPO_DATA(6013473,1581518,'3037994','2018/09/03','',11800,1529466,1531610,'', '2019/28/02'),
		T_TIPO_DATA(6013474,1672320,'3042043','2018/09/17','2019/01/22',149000,1531847,1529363,'','2020/20/02'),
		T_TIPO_DATA(6013475,1596222,'3045366','2018/09/20','2018/12/20',35700,1537004,1528074,'','2019/22/11'),
		T_TIPO_DATA(6013476,1685531,'3045670','2018/09/21','2018/12/12',50000,1529363,1529424,'','2020/23/03'),
		T_TIPO_DATA(6013477,1673274,'3045804','2018/09/21','2019/01/04',40000,1531074,1531074,'', '2019/07/02'),
		T_TIPO_DATA(6013478,1673274,'3045812','2018/09/21','2019/01/04',35000,1536834,1531074,'','2019/07/02'),
		T_TIPO_DATA(6013479,1618383,'3048026','2018/09/26','2018/12/05',93000,1546095,1530268,'', '2019/30/01'),
		T_TIPO_DATA(6013480,1616144,'3048622','2018/09/26','',15900,1529437,1529437,'','2019/28/02'),
		T_TIPO_DATA(6013481,1687885,'OF0000026803','2018/09/13','2018/12/20',17500,1537100,1529038,'', '2019/24/01')

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
                      	'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(6))||''',(SELECT AGR_ID FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION WHERE AGR_NUM_AGRUP_UVEM='''||V_TMP_TIPO_DATA(9)||'''),(SELECT CLC_ID FROM '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL WHERE CLC_COD_CLIENTE_PRINEX='''||TRIM(V_TMP_TIPO_DATA(2))||''')	'||',TO_DATE('''||TRIM(V_TMP_TIPO_DATA(4))||''', ''yyyy/mm/dd''), (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO=''02''), (SELECT DD_TOF_ID FROM '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA WHERE DD_TOF_CODIGO=''01''), (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_ORIGEN='''||TRIM(V_TMP_TIPO_DATA(7))||'''),(SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_ORIGEN='''||TRIM(V_TMP_TIPO_DATA(8))||'''),0, ''REMVIP-7567'',SYSDATE,0, '''||TRIM(V_TMP_TIPO_DATA(3))||''' FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_ECO_EXPEDIENTE_COMERCIAL.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL (' ||
                      	'ECO_ID,
			 ECO_NUM_EXPEDIENTE,
			 OFR_ID, DD_EEC_ID, ECO_FECHA_ALTA, ECO_FECHA_SANCION, ECO_FECHA_ANULACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 		'||
                      	'SELECT '|| V_ID || ','|| V_ESQUEMA ||'.S_ECO_NUM_EXPEDIENTE.NEXTVAL, (SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA='''||V_TMP_TIPO_DATA(1)||'''), (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO=''02''), TO_DATE('''||TRIM(V_TMP_TIPO_DATA(4))||''', ''yyyy/mm/dd''), TO_DATE('''||TRIM(V_TMP_TIPO_DATA(5))||''', ''yyyy/mm/dd''), TO_DATE('''||TRIM(V_TMP_TIPO_DATA(10))||''', ''yyyy/dd/mm'') ,0, ''REMVIP-7567'',SYSDATE,0 FROM DUAL';
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
