--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20210511
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13959
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_OAC_OFERTA_ACCIONES los datos añadidos en T_ARRAY_DATA
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-13959';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_OAC_OFERTA_ACCIONES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- PARTIDA_PRESUPUESTARIA   DD_TGA_CODIGO  DD_TIM_CODIGO   DD_SCR_CODIGO
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('001','Aprobación Comercial','Aprobación Comercial'),
		T_TIPO_DATA('002','Rechazo Comercial','Rechazo Comercial'),
		T_TIPO_DATA('003','Comunicar Contraoferta al cliente','Comunicar Contraoferta al cliente'),
		T_TIPO_DATA('004','Resultado Scoring PBC','Resultado Scoring PBC'),
		T_TIPO_DATA('005','Arras Aprobadas','Arras Aprobadas'),
		T_TIPO_DATA('006','Arras Rechazadas','Arras Rechazadas'),
		T_TIPO_DATA('007','Arras Pdte. Documentación','Arras Pdte. Documentación'),
		T_TIPO_DATA('008','Ingreso final Aprobado','Ingreso final Aprobado'),
		T_TIPO_DATA('009','Ingreso final Rechazado','Ingreso final Rechazado'),
		T_TIPO_DATA('010','Ingreso final Pdte. Documentación','Ingreso final Pdte. Documentación'),
		T_TIPO_DATA('011','Bloqueo Screening','Bloqueo Screening'),
		T_TIPO_DATA('012','Desbloqueo Screening','Desbloqueo Screening'),
		T_TIPO_DATA('013','Firma de Arras Aprobadas','Firma de Arras Aprobadas'),
		T_TIPO_DATA('014','Firma de Arras Rechazadas','Firma de Arras Rechazadas'),
		T_TIPO_DATA('015','Firma de Contrato Aprobado','Firma de Contrato Aprobado'),
		T_TIPO_DATA('016','Firma de Contrato Rechazado','Firma de Contrato Rechazado'),
		T_TIPO_DATA('017','Arras y Reserva no devueltas','Arras y Reserva no devueltas'),
		T_TIPO_DATA('018','Arras devueltas, Reserva no devuelta','Arras devueltas, Reserva no devuelta'),
		T_TIPO_DATA('019','Arras no devueltas, Reserva devuelta','Arras no devueltas, Reserva devuelta'),
		T_TIPO_DATA('020','Arras y Reserva devueltas','Arras y Reserva devueltas'),
		T_TIPO_DATA('021','Reserva Contabilizada','Reserva Contabilizada'),
		T_TIPO_DATA('022','Arras Contabilizadas','Arras Contabilizadas'),
		T_TIPO_DATA('023','Venta Contabilizada','Venta Contabilizada'),
		T_TIPO_DATA('024','Plusvalía Contabilizada','Plusvalía Contabilizada')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	-- LOOP para insertar los valores -----------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' ');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
		 
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
			   
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE
				DD_OAC_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''
				AND DD_OAC_DESCRIPCION = '''||V_TMP_TIPO_DATA(2)||'''
				AND DD_OAC_DESCRIPCION_LARGA = '''||V_TMP_TIPO_DATA(3)||'''';

			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			IF V_NUM_TABLAS = 1 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO]: La '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (
					DD_OAC_ID,DD_OAC_CODIGO, DD_OAC_DESCRIPCION,DD_OAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES(
					'|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL
					,'''||V_TMP_TIPO_DATA(1)||''','''||V_TMP_TIPO_DATA(2)||'''
					,'''||V_TMP_TIPO_DATA(3)||''',0,'''||V_ITEM||''',SYSDATE,0)';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
			END IF;
	END LOOP;
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla '||V_TEXT_TABLA||' MODIFICADA CORRECTAMENTE ');
	   
	
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
