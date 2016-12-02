--/*
--##########################################
--## AUTOR=Joaquin_Arnal
--## FECHA_CREACION=20161123
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1091
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_MRE_MOTIVO_RECH_ENTIDAD los datos añadidos de T_ARRAY_DATA
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

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_MRE_MOTIVO_RECH_ENTIDAD'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TRES_LETRAS_TABLA VARCHAR2(2400 CHAR) := 'MRE'; -- Vble. auxiliar para almacenar el sufijo de los campos de la tabla de ref.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(5012);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('000' ,'Registro validado' , '0', ' ' ),        
		T_TIPO_DATA('T01' ,'Formato incorrecto: Error tamaño' , '0', ' ' ),
        T_TIPO_DATA('T02' ,'Formato incorrecto: Error tipo' ,'0', ' '),
        T_TIPO_DATA('E01' ,'Obligatorio campo [NIF_ENTIDAD], si esta a null el campo [ID_ENTIDAD_GESTORIA]', '1', 'WHERE AUX.NIF_ENTIDAD IS NULL AND AUX.ID_ENTIDAD_GESTORIA IS NULL' ),
        T_TIPO_DATA('E02' ,'Obligatorio campo [ID_ENTIDAD_GESTORIA] , si esta a null el campo [NIF_ENTIDAD]', '1', 'WHERE AUX.NIF_ENTIDAD IS NULL AND AUX.ID_ENTIDAD_GESTORIA IS NULL'),
        -- T_TIPO_DATA('F01' ,'aaaa' ,'1', 'WHERE AUX.FECHA_ANULACION is not null AND NOT EXISTS (SELECT * FROM GPV_GASTOS_PROVEEDOR GPV WHERE GPV.GPV_NUM_GASTO_GESTORIA = AUX.COD_GASTO_GESTORIA AND GPV.DD_GRF_ID = #TOKEN_IDGESTORIA# )'),
        /* falta */ T_TIPO_DATA('F01' ,'ID_ENTIDAD_GESTORIA or NIF_ENTIDAD ya existen', '1', 'WHERE EXISTS (SELECT * FROM ACT_PVE_PROVEEDOR PVE WHERE PVE.PVE_DOCIDENTIF = AUX.NIF_ENTIDAD) or EXISTS ( SELECT * FROM ACT_PVE_PROVEEDOR PVE WHERE PVE.??? = AUX.ID_ENTIDAD_GESTORIA) '),
        T_TIPO_DATA('F02', 'TIPO_ENTIDAD no es un valor del DD - DD_TEP_TIPO_ENTIDAD_PROVEEDOR', '1', 'WHERE EXISTS (SELECT * FROM DD_TEP_TIPO_ENTIDAD_PROVEEDOR TEP WHERE TEP.DD_TEP_CODIGO = AUX.TIPO_ENTIDAD)' ),
        T_TIPO_DATA('F03' ,'SUBTIPO_ENTIDAD no es un valor del DD - DD_TEP_TIPO_ENTIDAD_PROVEEDOR ', '1', 'WHERE EXISTS (SELECT * FROM DD_TEP_TIPO_ENTIDAD_PROVEEDOR TEP WHERE TEP.DD_TEP_CODIGO = AUX.TIPO_ENTIDAD)' ),
        T_TIPO_DATA('F04' ,'ESTADO no es un valor del DD -DD_EPR_ESTADO_PROVEEDOR ', '1', 'WHERE AUX.ESTADO is not null AND EXISTS (SELECT * FROM DD_EPR_ESTADO_PROVEEDOR EPR WHERE EPR.DD_EPR_CODIGO = AUX.ESTADO)' ),
        T_TIPO_DATA('F05' ,'DOCU_NIF_CONTACTO no es un valor del DD - DD_TDI_TIPO_DOCUMENTO_ID', '1', 'WHERE AUX.DOCU_NIF_CONTACTO is not null AND EXISTS (SELECT * FROM DD_TDI_TIPO_DOCUMENTO_ID TDI WHERE TDI.DD_TDI_CODIGO = AUX.DOCU_NIF_CONTACTO)' ),
        T_TIPO_DATA('F06' ,'ESTADO_CONTACTO no es un valor del DD - DD_EDC_ESTADO_DOCUMENTO', '1', 'WHERE AUX.ESTADO_CONTACTO is not null AND EXISTS (SELECT * FROM DD_EDC_ESTADO_DOCUMENTO EDC WHERE EDC.DD_EDC_CODIGO = AUX.ESTADO_CONTACTO)' ),
        /* no lo se */ T_TIPO_DATA('F07' ,'CODIGO_USUARIO_CONTACTO no es un valor del DD - USU_USUARIOS', '1', 'WHERE AUX.CODIGO_USUARIO_CONTACTO is not null AND EXISTS (SELECT * FROM USU_USUARIOS USU WHERE USU.USU_USERNAME = AUX.CODIGO_USUARIO_CONTACTO)' ),
        /* duda */ T_TIPO_DATA('F08' ,'ID_ACTIVO no es un valor del DD - ACT_ACTIVO', '1', 'WHERE EXISTS (SELECT * FROM ACT_ACTIVO ACT WHERE ACT.ACT_ID = AUX.ID_ACTIVO)' )
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	

	--Comprobamos el dato a insertar
        V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET BORRADO = 1,  USUARIOBORRAR = ''DML'', FECHABORRAR = sysdate';
        EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO LOGICO A TODO LA TABLA: '||V_TEXT_TABLA||'] ');
        
	 
	-- LOOP para insertar los valores en la tabla indicada
    	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||'] ');
    	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      	LOOP
             	V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
	        --Comprobamos el dato a insertar
        	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_'||V_TRES_LETRAS_TABLA||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
	        --Si existe lo modificamos
        	IF V_NUM_TABLAS > 0 THEN				
			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
	       	  	V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
		        		'SET DD_'||V_TRES_LETRAS_TABLA||'_DESCRIPCION = '''||SUBSTR(TRIM(V_TMP_TIPO_DATA(2)),0,100)||''''|| 
					', DD_'||V_TRES_LETRAS_TABLA||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
					', PROCESO_VALIDAR = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', QUERY_ITER = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
					', USUARIOBORRAR = null , FECHABORRAR = null, BORRADO = 0 '||
					'WHERE DD_'||V_TRES_LETRAS_TABLA||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
			DBMS_OUTPUT.PUT_LINE(V_MSQL);
		  	EXECUTE IMMEDIATE V_MSQL;
		  	DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          	--Si no existe, lo insertamos   
       		ELSE
       			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          		V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          		EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          		V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      		'DD_'||V_TRES_LETRAS_TABLA||'_ID, DD_'||V_TRES_LETRAS_TABLA||'_CODIGO, DD_'||V_TRES_LETRAS_TABLA||'_DESCRIPCION,'||
				'DD_'||V_TRES_LETRAS_TABLA||'_DESCRIPCION_LARGA, PROCESO_VALIDAR, QUERY_ITER,' ||
				' VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      		'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||SUBSTR(TRIM(V_TMP_TIPO_DATA(2)),0,100)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','||
				''''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','||
                      		'0, ''DML'',SYSDATE,0 FROM DUAL';
			DBMS_OUTPUT.PUT_LINE(V_MSQL);
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

