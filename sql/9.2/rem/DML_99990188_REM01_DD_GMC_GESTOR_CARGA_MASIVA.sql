--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20171114
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3116
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_GCM_GESTOR_CARGA_MASIVA los datos añadidos en T_ARRAY_DATA
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
        T_TIPO_DATA('GIAFORM'	,'Gestoría de formalización'		,'Gestoría de formalización' 			,'02','0','1','0'),
        T_TIPO_DATA('GFORM'		,'Gestor formalización'				,'Gestor formalización'					,'02','0','1','0'),
        T_TIPO_DATA('SFORM'		,'Supervisor formalización'			,'Supervisor formalización'				,'02','0','1','0'),
        T_TIPO_DATA('GIAFORM'	,'Gestoría de formalización'		,'Gestoría de formalización'			,'21','0','1','0'),
        T_TIPO_DATA('GFORM'		,'Gestor formalización'				,'Gestor formalización'					,'21','0','1','0'),
        T_TIPO_DATA('SFORM'		,'Supervisor formalización'			,'Supervisor formalización'				,'21','0','1','0'),
        T_TIPO_DATA('GESRES'	,'Gestor de reserva (Cajamar)'		,'Gestor de reserva (Cajamar)'			,'01','0','1','0'),
        T_TIPO_DATA('SUPRES'	,'Supervisor de reserva (Cajamar)'	,'Supervisor de reserva (Cajamar)'		,'01','0','1','0'),
        T_TIPO_DATA('GESMIN'	,'Gestor de minuta (Cajamar)'		,'Gestor de minuta (Cajamar)'			,'01','0','1','0'),
        T_TIPO_DATA('SUPMIN'	,'Supervisor de minuta (Cajamar)'	,'Supervisor de minuta (Cajamar)'		,'01','0','1','0'),
        T_TIPO_DATA('GFORM'		,'Gestor formalización'				,'Gestor formalización'					,'01','0','1','0'),
        T_TIPO_DATA('SFORM'		,'Supervisor formalización'			,'Supervisor formalización'				,'01','0','1','0'),
        T_TIPO_DATA('GCOM'		,'Gestor comercial'					,'Gestor comercial'						,'02','0','0','1'),
        T_TIPO_DATA('GCOM'		,'Gestor comercial'					,'Gestor comercial'						,'21','0','0','1'),
        T_TIPO_DATA('GCOM'		,'Gestor comercial'					,'Gestor comercial'						,'01','0','0','1')
        
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_ACC_ACCION_GASTOS -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_GCM_GESTOR_CARGA_MASIVA] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_GCM_GESTOR_CARGA_MASIVA WHERE DD_GCM_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND DD_CRA_ID = (SELECT DD_CRA_ID FROM DD_CRA_CARTERA where DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_GCM_GESTOR_CARGA_MASIVA '||
                    'SET DD_GCM_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_GCM_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', DD_CRA_ID = (SELECT DD_CRA_ID FROM DD_CRA_CARTERA where DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''')'||
					', DD_GCM_ACTIVO = '''||TRIM(V_TMP_TIPO_DATA(5))||''''||
					', DD_GCM_EXPEDIENTE = '''||TRIM(V_TMP_TIPO_DATA(6))||''''||
					', DD_GCM_AGRUPACION = '''||TRIM(V_TMP_TIPO_DATA(7))||''''||
					', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_GCM_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND DD_CRA_ID = (SELECT DD_CRA_ID FROM DD_CRA_CARTERA where DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''') ';
           DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_GCM_GESTOR_CARGA_MASIVA.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_GCM_GESTOR_CARGA_MASIVA (' ||
                      'DD_GCM_ID, DD_GCM_CODIGO, DD_GCM_DESCRIPCION, DD_GCM_DESCRIPCION_LARGA,DD_CRA_ID,DD_GCM_ACTIVO,DD_GCM_EXPEDIENTE,DD_GCM_AGRUPACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'VALUES ('|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''',(SELECT DD_CRA_ID FROM DD_CRA_CARTERA where DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''),'''||TRIM(V_TMP_TIPO_DATA(5))||''','''||TRIM(V_TMP_TIPO_DATA(6))||''','''||TRIM(V_TMP_TIPO_DATA(7))||''', 0, ''DML'',SYSDATE,0)';
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_GCM_GESTOR_CARGA_MASIVA ACTUALIZADO CORRECTAMENTE ');
   

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