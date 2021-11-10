--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20210511
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13978
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_EEB_ESTADO_EXPEDIENTE_BC los datos añadidos en T_ARRAY_DATA
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-13978';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_EEB_ESTADO_EXPEDIENTE_BC'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- PARTIDA_PRESUPUESTARIA   DD_TGA_CODIGO  DD_TIM_CODIGO   DD_SCR_CODIGO
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('001','Pdte. Aprobación BC','Pdte. Aprobación BC'),
		T_TIPO_DATA('002','Oferta Cancelada','Oferta Cancelada'),
		T_TIPO_DATA('003','Oferta Aprobada','Oferta Aprobada'),
		T_TIPO_DATA('004','Contraoferta aceptada','Contraoferta aceptada'),
		T_TIPO_DATA('005','Scoring a revisar por BC','Scoring a revisar por BC'),
		T_TIPO_DATA('006','Valorar acuerdo sin garantías adicionales','Valorar acuerdo sin garantías adicionales'),
		T_TIPO_DATA('007','Oferta Pdte. Scoring','Oferta Pdte. Scoring'),
		T_TIPO_DATA('008','Bloqueada por Screening BC','Bloqueada por Screening BC'),
		T_TIPO_DATA('009','Arras Pendientes de Aprobación BC','Arras Pendientes de Aprobación BC'),
		T_TIPO_DATA('010','Arras– Documentación aportada a BC','Arras– Documentación aportada a BC'),
		T_TIPO_DATA('011','Ingreso final Pdte. BC','Ingreso final Pdte. BC'),
		T_TIPO_DATA('012','Ingreso final – Documentación aportada a BC','Ingreso final – Documentación aportada a BC'),
		T_TIPO_DATA('013','Arras Prorrogadas','Arras Prorrogadas'),
		T_TIPO_DATA('014','Ingreso de Arras','Ingreso de Arras'),
		T_TIPO_DATA('015','Validación de firma de Arras por BC','Validación de firma de Arras por BC'),
		T_TIPO_DATA('016','Firma de Arras Agendadas','Firma de Arras Agendadas'),
		T_TIPO_DATA('017','Arras Firmadas','Arras Firmadas'),
		T_TIPO_DATA('018','Validación de firma de Contrato por BC','Validación de firma de Contrato por BC'),
		T_TIPO_DATA('019','Firma de Contrato Agendado','Firma de Contrato Agendado'),
		T_TIPO_DATA('020','Contrato Firmado','Contrato Firmado'),
		T_TIPO_DATA('021','Venta Formalizada','Venta Formalizada'),
		T_TIPO_DATA('022','Compromiso Cancelado','Compromiso Cancelado'),
		T_TIPO_DATA('023','Solicitar devolución de reserva y/o arras a BC','Solicitar devolución de reserva y/o arras a BC')

		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	-- LOOP para insertar los valores -----------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' ');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
		 
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
			   
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE
				DD_EEB_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''
				AND DD_EEB_DESCRIPCION = '''||V_TMP_TIPO_DATA(2)||'''
				AND DD_EEB_DESCRIPCION_LARGA = '''||V_TMP_TIPO_DATA(3)||'''';

			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			IF V_NUM_TABLAS = 1 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO]: La '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (
					DD_EEB_ID,DD_EEB_CODIGO, DD_EEB_DESCRIPCION,DD_EEB_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES(
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
