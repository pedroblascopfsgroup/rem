--/*
--##########################################
--## AUTOR=Joaquin_Arnal
--## FECHA_CREACION=20161102
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1089
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_GRF_GESTORIA_RECEP_FICH los datos añadidos de T_ARRAY_DATA
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

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_MRG_MOTIVO_RECHAZO_GASTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TRES_LETRAS_TABLA VARCHAR2(2400 CHAR) := 'MRG'; -- Vble. auxiliar para almacenar el sufijo de los campos de la tabla de ref.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(5012);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	T_TIPO_DATA('000' ,'Registro validado' , '0', ' ' ),        
	T_TIPO_DATA('T01' ,'Formato incorrecto: Error tamaño' , '0', ' ' ),
        T_TIPO_DATA('T02' ,'Formato incorrecto: Error tipo' ,'0', ' '),
        T_TIPO_DATA('E01' ,'Obligatorio campo [Fecha devengo especial], si se ha cumplimentado el campo [Periodicidad especial]', '1', 'WHERE AUX.FECHA_DEVENGO_ESPECIAL IS NULL AND AUX.PERIO_ESPECIAL IS NOT NULL' ),
        T_TIPO_DATA('E02' ,'Obligatorio campo [Partida presupuestaria especial] , si se ha cumplimentado el campo [periodicidad especial]', '1', 'WHERE AUX.PARTIDA_PRESU_ESPECIAL IS NULL AND AUX.PERIO_ESPECIAL IS NOT NULL'),
        
        T_TIPO_DATA('E03' ,'Obligatorio campo [Motivo anulación], si se ha cumplimentado el campo [fecha anulación]', '1', 'WHERE AUX.MOTIVO_ANULACION IS NULL AND AUX.FECHA_ANULACION IS NOT NULL'),
        T_TIPO_DATA('E04' ,'Obligatorio campo [Importe pagado], si se ha cumplimentado el campo [fecha de pago]', '1', 'WHERE AUX.IMPORTE_PAGADO IS NULL AND AUX.FECHA_PAGO IS NOT NULL' ),
        T_TIPO_DATA('E05' ,'Obligatorio campo [Fecha de pago], si se ha cumplimentado el campo [importe pagado]', '1', 'WHERE AUX.FECHA_PAGO IS NULL AND AUX.IMPORTE_PAGADO IS NOT NULL' ),
        T_TIPO_DATA('E06' ,'Obligatorio campo [Pagado por], si se ha cumplimentado el campo [importe pagado]', '1', 'WHERE AUX.PAGADO_POR IS NULL AND AUX.IMPORTE_PAGADO IS NOT NULL' ),  
        T_TIPO_DATA('F01' ,'Llega fecha de anulación y no existe gasto en la tabla' ,'1', 'WHERE AUX.FECHA_ANULACION is not null AND NOT EXISTS (SELECT * FROM GPV_GASTOS_PROVEEDOR GPV WHERE GPV.GPV_NUM_GASTO_GESTORIA = AUX.COD_GASTO_GESTORIA AND GPV.DD_GRF_ID = #TOKEN_IDGESTORIA# )'),
        T_TIPO_DATA('F02' ,'Llega alta de gasto que ya existe', '1', 'WHERE AUX.TIPO_ENVIO like ''''01'''' AND EXISTS (SELECT * FROM GPV_GASTOS_PROVEEDOR GPV WHERE GPV.GPV_NUM_GASTO_GESTORIA = AUX.COD_GASTO_GESTORIA AND GPV.DD_GRF_ID = #TOKEN_IDGESTORIA#)'),
        T_TIPO_DATA('F03', 'Error en tipo / subtipo de gasto', '1', 'LEFT JOIN DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_CODIGO = trim(AUX.TIPO_GASTO) LEFT JOIN DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_CODIGO = trim(AUX.SUBTIPO_GASTO) WHERE (TGA.DD_TGA_ID is null OR STG.DD_STG_ID is null)' ),
        T_TIPO_DATA('F04' ,'No existe el activo' , '0', 'WHERE NOT EXISTS (SELECT * FROM ACT_ACTIVO ACT  WHERE ACT.ACT_NUM_ACTIVO = AUX.COD_ACTIVO) AND AUX.COD_ACTIVO is not null' ),
        T_TIPO_DATA('F05' ,'Gasto cíclico sin fecha inicio o fin', '1', 'WHERE AUX.ID_PRIMER_GASTO_SERIE is not null AND (AUX.FECHA_FIN_EMISION is null or AUX.FECHA_INICIO_EMISION is null)' ),
        T_TIPO_DATA('F06' ,'Llega anulación de un gasto que YA está pagado', '1', 'WHERE AUX.TIPO_ENVIO like ''''04'''' AND EXISTS (SELECT * FROM GPV_GASTOS_PROVEEDOR GPV  JOIN DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID AND EGA.DD_EGA_CODIGO = ''''05'''' WHERE GPV.GPV_NUM_GASTO_GESTORIA = AUX.COD_GASTO_GESTORIA AND GPV.DD_GRF_ID = #TOKEN_IDGESTORIA# )'),
        T_TIPO_DATA('F07' ,'Llega modificación de un gasto que YA está pagado' , '1' ,'WHERE AUX.TIPO_ENVIO like ''''03'''' AND EXISTS (SELECT *  FROM GPV_GASTOS_PROVEEDOR GPV JOIN DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID AND EGA.DD_EGA_CODIGO = ''''05'''' WHERE GPV.GPV_NUM_GASTO_GESTORIA = AUX.COD_GASTO_GESTORIA AND GPV.DD_GRF_ID = #TOKEN_IDGESTORIA# )' ),
        T_TIPO_DATA('F08' ,'Llega anulación con datos diferentes al alta', '1' ,'JOIN GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_NUM_GASTO_GESTORIA = AUX.COD_GASTO_GESTORIA AND GPV.DD_GRF_ID = #TOKEN_IDGESTORIA# 
JOIN GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID JOIN GPV_ACT GA ON GPV.GPV_ID = GA.GPV_ID JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = GA.ACT_ID WHERE AUX.TIPO_ENVIO LIKE ''''04'''' AND  (AUX.COD_ACTIVO       = ACT.ACT_NUM_ACTIVO or AUX.PRINCIPAL = GDE.GDE_PRINCIPAL_NO_SUJETO or AUX.RECARGO = GDE.GDE_RECARGO or AUX.INT_DEMORA = GDE.GDE_INTERES_DEMORA or AUX.COSTAS = GDE.GDE_COSTAS or AUX.OTROS_INCREMENTOS = GDE.GDE_OTROS_INCREMENTOS or AUX.PROVISIONES_Y_SUPL = GDE.GDE_PROV_SUPLIDOS or AUX.IMPORTE_PAGADO  = GDE.GDE_IMPORTE_PAGADO)'),
        T_TIPO_DATA('F09' ,'Llega un abono con importe positivo' , '1' ,'WHERE AUX.TIPO_OPERACION = ''''03'''' AND (AUX.PRINCIPAL > 0 OR AUX.PRINCIPAL is null)' ),
        /*T_TIPO_DATA('F10' ,'El propietario no existe' , '1' ,'' ),
		destinatario del gasto no existe, o ese destinatario no corresponde con el activo.
		*/
        T_TIPO_DATA('F11' ,'Valor incorrecto en partida presupuestaria' , '0' ,'LEFT JOIN DD_PPR_PDAS_PRESUPUESTARIAS PPR ON PPR.DD_PPR_CODIGO = AUX.PARTIDA_PRESU_ESPECIAL WHERE PPR.DD_PPR_ID is null' ),
        
        T_TIPO_DATA('F13' ,'Fecha de devengo inválida. (no se admiten anteriores a 01.01.1989)' , '1' ,'WHERE AUX.FECHA_DEVENGO_REAL < to_date(''''01-ENE-1989'''',''''DD-MON-YYYY'''')'),
        T_TIPO_DATA('F14' ,'Gasto sin activo (SOLO PARA SAREB)' , '1' ,'WHERE AUX.COD_ACTIVO is null'),
		/*
		“Tipo de operación” abono y no informa gasto abonado 
        T_TIPO_DATA('F15' ,'Tipo de operación” abono y no informa gasto abonado', '1' ,'' ),
		*/
		T_TIPO_DATA('F16' ,'Llega gasto cíclico sin que esté autorizado el primero de las serie', '1', 'WHERE AUX.ID_PRIMER_GASTO_SERIE is not null AND NOT EXISTS (SELECT * FROM GPV_GASTOS_PROVEEDOR GPV JOIN DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID AND  DD_EGA_CODIGO = ''''03'''' WHERE GPV.GPV_NUM_GASTO_HAYA = AUX.ID_PRIMER_GASTO_SERIE AND GPV.DD_GRF_ID = #TOKEN_IDGESTORIA#)'),
		T_TIPO_DATA('F17' ,'Subsanación de gasto que no existe' , '1' , 'WHERE AUX.TIPO_ENVIO = ''''03'''' AND NOT EXISTS (SELECT * FROM GPV_GASTOS_PROVEEDOR GPV WHERE GPV.GPV_NUM_GASTO_GESTORIA = AUX.COD_GASTO_GESTORIA AND GPV.DD_GRF_ID = #TOKEN_IDGESTORIA# )'),
        T_TIPO_DATA('F18' ,'Anulación de gasto que no existe' , '1' , 'WHERE AUX.TIPO_ENVIO = ''''04'''' AND NOT EXISTS (SELECT * FROM GPV_GASTOS_PROVEEDOR GPV WHERE GPV.GPV_NUM_GASTO_GESTORIA = AUX.COD_GASTO_GESTORIA AND GPV.DD_GRF_ID = #TOKEN_IDGESTORIA# )' ),
        T_TIPO_DATA('F19' ,'Periodicidad incorrecta', '1' ,'LEFT JOIN DD_TPE_TIPOS_PERIOCIDAD TPE ON TPE.DD_TPE_CODIGO = AUX.PERIO_REAL WHERE TPE.DD_TPE_ID is null'  ),
        T_TIPO_DATA('F20' ,'Falta importe' , '1' ,'WHERE (AUX.PRINCIPAL + AUX.RECARGO + AUX.INT_DEMORA + AUX.COSTAS + AUX.OTROS_INCREMENTOS + AUX.PROVISIONES_Y_SUPL) <= 0' ),
 	T_TIPO_DATA('F21' ,'Emisor (proveedor) no existe', '1' ,'WHERE AUX.NIF_PROVEEDOR is null OR NOT EXISTS (SELECT * FROM ACT_PVE_PROVEEDOR PVE WHERE PVE.PVE_DOCIDENTIF = AUX.NIF_PROVEEDOR AND PVE.BORRADO = 0)'),
        T_TIPO_DATA('F22' ,'Valor incorrecto para "tipo_operacion" (DD -> DD_TOG_TIPO_OPERACION_GASTO)', '1' ,'LEFT JOIN DD_TOG_TIPO_OPERACION_GASTO TOG ON TOG.DD_TOG_CODIGO = AUX.TIPO_OPERACION WHERE TOG.DD_TOG_ID is null'),
		T_TIPO_DATA('F23' ,'Esta cumplimentado sin ser obligatorio, pero el valor es incorrecto para "pagador_por" (DD -> DD_TPA_TIPOS_PAGADOR)', '1' ,'LEFT JOIN DD_TPA_TIPOS_PAGADOR TPA ON TPA.DD_TPA_CODIGO = AUX.PAGADO_POR WHERE TPA.DD_TPA_ID is null AND AUX.PAGADO_POR is not null'),
		T_TIPO_DATA('F24' ,'Valor incorrecto para "tipo_envio" (DD -> DD_TEN_TIPO_ENVIO)', '1' ,'LEFT JOIN DD_TEN_TIPO_ENVIO TEN ON TEN.DD_TEN_CODIGO = AUX.TIPO_ENVIO WHERE TEN.DD_TEN_ID is null'),
		T_TIPO_DATA('F25' ,'Esta cumplimentado sin ser obligatorio, pero el valor es incorrecto para "motivo_anulacion" (DD -> DD_MAG_MOTIVOS_ANULACION_GASTO)', '1' ,'LEFT JOIN DD_MAG_MOTIVOS_ANULACION_GASTO MAG ON MAG.DD_MAG_CODIGO = AUX.MOTIVO_ANULACION WHERE MAG.DD_MAG_ID is null AND AUX.MOTIVO_ANULACION is not null')
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

