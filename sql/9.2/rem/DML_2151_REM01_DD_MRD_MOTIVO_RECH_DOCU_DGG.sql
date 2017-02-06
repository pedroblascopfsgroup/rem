--/*
--##########################################
--## AUTOR=Joaquin_Arnal
--## FECHA_CREACION=20170116
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1449
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_MRD_MOTIVO_RECH_DOCU_DGG los datos añadidos de T_ARRAY_DATA
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

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_MRD_MOTIVO_RECH_DOCU_DGG'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TRES_LETRAS_TABLA VARCHAR2(2400 CHAR) := 'MRD'; -- Vble. auxiliar para almacenar el sufijo de los campos de la tabla de ref.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(5012);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	T_TIPO_DATA('000' ,'Registro validado' , '0', ' ' ),        
	T_TIPO_DATA('T01' ,'Formato incorrecto: Error tamaño' , '0', ' ' ),
	T_TIPO_DATA('T02' ,'Formato incorrecto: Error tipo' ,'0', ' '),
        T_TIPO_DATA('E01' ,'Obligatorio campo [ID_GESTORIA]', '1', 'WHERE AUX.ID_GESTORIA IS NULL'),
        T_TIPO_DATA('E02' ,'Obligatorio campo [ID_GASTO_GESTORIA]', '1', 'WHERE AUX.ID_GASTO_GESTORIA IS NULL'),
        T_TIPO_DATA('E03' ,'Obligatorio campo [ID_ACTIVO]', '1', 'WHERE AUX.ID_ACTIVO IS NULL'),
        T_TIPO_DATA('E04' ,'Obligatorio campo [TIPO_DOC_GES_DOCU]', '1', 'WHERE AUX.TIPO_DOC_GES_DOCU IS NULL'),
	T_TIPO_DATA('E05' ,'Obligatorio campo [RUTA]', '1', 'WHERE AUX.RUTA IS NULL' ),
        --T_TIPO_DATA('F01' ,'ID_GESTORIA incorrecto, el codigo gestoria no es correcto' ,'1', 'WHERE AUX.ID_GESTORIA is not null AND NOT EXISTS (SELECT * FROM DD_GRF_GESTORIA_RECEP_FICH GRF WHERE TO_NUMBER(GRF.DD_GRF_CODIGO) =  TO_NUMBER(AUX.ID_GESTORIA))'),
        T_TIPO_DATA('F02' ,'ID_GASTO_GESTORIA incorrecto, no existe el gasto indicado', '1', 'WHERE NOT EXISTS (SELECT * FROM "#TOKEN_Schema#".GPV_GASTOS_PROVEEDOR GPV WHERE GPV.GPV_NUM_GASTO_GESTORIA = AUX.T_ID_GASTO_GESTORIA AND GPV.DD_GRF_ID = #TOKEN_IDGESTORIA#) AND AUX.ID_GASTO_GESTORIA is not null'),
        T_TIPO_DATA('F03', 'ID_ACTIVO incorrecto, no existe el activo indicado', '1', 'WHERE NOT EXISTS (SELECT * FROM "#TOKEN_Schema#".ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = AUX.T_ID_ACTIVO) AND AUX.ID_ACTIVO is not null' ),
	T_TIPO_DATA('F04' ,'Gasto y activo no estan relacionados' , '1', 'WHERE NOT EXISTS (SELECT * FROM "#TOKEN_Schema#".GPV_GASTOS_PROVEEDOR GPV JOIN "#TOKEN_Schema#".GPV_ACT GA ON GA.GPV_ID = GPV.GPV_ID JOIN "#TOKEN_Schema#".ACT_ACTIVO ACT ON ACT.ACT_ID = GA.ACT_ID WHERE ACT.ACT_NUM_ACTIVO = AUX.T_ID_ACTIVO AND GPV.GPV_NUM_GASTO_GESTORIA = AUX.T_ID_GASTO_GESTORIA AND GPV.DD_GRF_ID = #TOKEN_IDGESTORIA#) AND AUX.ID_ACTIVO is not null AND AUX.ID_GASTO_GESTORIA is not null' ),
        T_TIPO_DATA('F05' ,'TIPO_DOC_GES_DOCU incorrecto, tipo documento indicado no existe' , '1', 'WHERE NOT EXISTS (SELECT * FROM "#TOKEN_Schema#".DD_TPD_TIPOS_DOCUMENTO_GASTO TPD WHERE TPD.DD_TPD_CODIGO = AUX.TIPO_DOC_GES_DOCU) AND AUX.TIPO_DOC_GES_DOCU is not null' )
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

