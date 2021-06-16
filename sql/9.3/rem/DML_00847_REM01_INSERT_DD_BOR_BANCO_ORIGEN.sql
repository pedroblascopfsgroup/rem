--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20210615
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14344
--## PRODUCTO=NO
--##
--## Finalidad: Script que inserta en DD_BOR_BANCO_ORIGEN
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-14344';
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
                  --DD_BOR_CODIGO        	--DD_BOR_DESCRIPCION y DD_BOR_DESCRIPCION_LARGA
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('001','Banco Valencia'),
        T_TIPO_DATA('002','Vip_1'),
        T_TIPO_DATA('004','Fondos banco Valencia'),
        T_TIPO_DATA('005','Soinmob'),
        T_TIPO_DATA('006','Abanca'),
        T_TIPO_DATA('007','Barclays'),
        T_TIPO_DATA('008','Liberbank'),
        T_TIPO_DATA('009','Banco de valencia'),
        T_TIPO_DATA('010','real equility s.l.'),
        T_TIPO_DATA('011','Vip viviendas y locales, s.l.u.'),
        T_TIPO_DATA('012','Vipactivos, s.l.u.'),
        T_TIPO_DATA('013','Vip gestión de inmuebles, s.l.u.'),
        T_TIPO_DATA('014','Hip.2'),
        T_TIPO_DATA('015','Vip promo. Inm. Sur, s.l.u.'),
        T_TIPO_DATA('016','Banco de valencia, s.a.'),
        T_TIPO_DATA('017','Bv'),
        T_TIPO_DATA('018','Hip.5'),
        T_TIPO_DATA('019','Hip.4'),
        T_TIPO_DATA('020','Hip.3'),
        T_TIPO_DATA('021','Pyme1'),
        T_TIPO_DATA('022','Hip.1'),
        T_TIPO_DATA('023','Ensanche urbano s.a.'),
        T_TIPO_DATA('024','Pyme 2'),
        T_TIPO_DATA('025','Vip promociones inmobiliarias sur, s.lu.'),
        T_TIPO_DATA('026','Vip gestión de inmuebles, s.l.u.'),
        T_TIPO_DATA('027','Vip viviendas y locales, s.l.u.'),
        T_TIPO_DATA('028','Hábitat dos mil dieciocho, s.l.'),
        T_TIPO_DATA('029','Vipcartera, s.l.'),
        T_TIPO_DATA('030','BANKIA'),
        T_TIPO_DATA('032','BFA'),
        T_TIPO_DATA('033','CAJA RIOJA'),
        T_TIPO_DATA('034','CAIXA LAIETANA'),
        T_TIPO_DATA('035','CAJA INSULAR'),
        T_TIPO_DATA('036','CAJA SEGOVIA'),
        T_TIPO_DATA('037','BANCAJA'),
        T_TIPO_DATA('038','CAJA AVILA'),
        T_TIPO_DATA('039','SAREB')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_BOR_BANCO_ORIGEN ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_BOR_BANCO_ORIGEN WHERE DD_BOR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_BOR_BANCO_ORIGEN '||
                    'SET   DD_BOR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
                        ', DD_BOR_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
                        ', USUARIOMODIFICAR = '''||TRIM(V_ITEM)||''' 
                         , FECHAMODIFICAR = SYSDATE '||
                    'WHERE DD_BOR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   

          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_BOR_BANCO_ORIGEN 
                      (' ||'
                            DD_BOR_ID
                          , DD_BOR_CODIGO
                          , DD_BOR_DESCRIPCION
                          , DD_BOR_DESCRIPCION_LARGA
                          , VERSION
                          , USUARIOCREAR
                          , FECHACREAR
                          , BORRADO) ' ||
                      'SELECT 
                           '|| V_ESQUEMA ||'.S_DD_BOR_BANCO_ORIGEN.NEXTVAL
                          ,'''||TRIM(V_TMP_TIPO_DATA(1))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(2))||'''
                          ,'''||TRIM(V_TMP_TIPO_DATA(2))||'''
                          , 0
                          , '''||TRIM(V_ITEM)||'''
                          ,SYSDATE
                          ,0
                      FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_BOR_BANCO_ORIGEN MODIFICADO CORRECTAMENTE ');
   

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
