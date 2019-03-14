--/*
--##########################################
--## AUTOR=Ramon Llinares
--## FECHA_CREACION=20190306
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v2.4.0-rem
--## INCIDENCIA_LINK=REMVIP-3353
--## PRODUCTO=NO
--##
--## Finalidad: Insertar en la tabla DD_TPD_TIPO_DOCUMENTO
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
		T_TIPO_DATA('64', 'AI-01-DOCJ-29'),
		T_TIPO_DATA('42', 'AI-02-CNCV-04'),
		T_TIPO_DATA('43', 'AI-02-CNCV-05'),
		T_TIPO_DATA('44', 'AI-02-CERJ-54'),
		T_TIPO_DATA('45', 'AI-02-CERJ-78'),
		T_TIPO_DATA('65', 'AI-02-DOCJ-AK '),
		T_TIPO_DATA('66', 'AI-02-SERE-48'),
		T_TIPO_DATA('46', 'AI-01-DECL-01'),
		T_TIPO_DATA('47', 'AI-11-DECL-01'),
		T_TIPO_DATA('13', 'AI-09-LIPR-03'),
		T_TIPO_DATA('11', 'AI-10-CERT-05'),
		T_TIPO_DATA('24', 'AI-10-CERT-26'),
		T_TIPO_DATA('27', 'AI-09-LIPR-14'),
		T_TIPO_DATA('14', 'AI-08-CERT-17'),
		T_TIPO_DATA('02', 'AI-01-SERE-24'),
		T_TIPO_DATA('49', 'AI-02-DOCJ-AI'),
		T_TIPO_DATA('50', 'AI-02-DOCJ-AJ'),
		T_TIPO_DATA('67', 'AI-01-PBLO-28'),
		T_TIPO_DATA('25', 'AI-05-CERT-25'),
		T_TIPO_DATA('51', 'AI-01-ESCR-10'),
		T_TIPO_DATA('68', 'AI-01-ESCR-14'),
		T_TIPO_DATA('69', 'AI-01-CERA-14'),
		T_TIPO_DATA('52', 'AI-02-ESIN-97'),
		T_TIPO_DATA('15', 'AI-09-CERT-07'),
		T_TIPO_DATA('16', 'AI-09-CERT-10'),
		T_TIPO_DATA('17', 'AI-09-CERT-11'),
		T_TIPO_DATA('20', 'AI-05-ESIN-BB'),
		T_TIPO_DATA('12', 'AI-09-LIPR-06'),
		T_TIPO_DATA('63', 'AI-01-SERE-25'),
		T_TIPO_DATA('06', 'AI-01-NOTS-01'),
		T_TIPO_DATA('05', 'AI-01-NOTS-01'),
		T_TIPO_DATA('54', 'AI-09-CERT-28'),
		T_TIPO_DATA('55', 'AI-09-CERT-27'),
		T_TIPO_DATA('56', 'AI-02-DOCJ-14'),
		T_TIPO_DATA('04', 'AI-02-DOCJ-15'),
		T_TIPO_DATA('57', 'AI-02-DOCJ-AK'),
		T_TIPO_DATA('18', 'AI-03-PRES-01'),
		T_TIPO_DATA('22', 'AI-05-ESIN-AN'),
		T_TIPO_DATA('21', 'AI-05-ESIN-AM'),
		T_TIPO_DATA('23', 'AI-05-ESIN-AO'),
		T_TIPO_DATA('61', 'AI-01-COMU-80'),
		T_TIPO_DATA('58', 'AI-01-INRG-08'),
		T_TIPO_DATA('59', 'AI-01-CERJ-47'),
		T_TIPO_DATA('26', 'AI-03-PRES-15'),
		T_TIPO_DATA('07', 'AI-04-TASA-11'),
		T_TIPO_DATA('62', 'AI-01-SERE-26'),
		T_TIPO_DATA('09', 'AI-05-COMU-74'),
		T_TIPO_DATA('08', 'AI-05-ACUE-07'),
		T_TIPO_DATA('10', 'AI-05-PRPE-38'),
		T_TIPO_DATA('70', 'AI-03-COMU-81'),
		T_TIPO_DATA('72', 'AI-01-DOCJ-BJ'),
		T_TIPO_DATA('71', 'AI-01-ESCR-48')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para MODIFICAR los valores en DD_TPD_TIPO_DOCUMENTO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICANDO DD_TPD_TIPO_DOCUMENTO ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
 		
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.dd_tpd_tipo_documento SET dd_tpd_matricula_gd = '''|| TRIM(V_TMP_TIPO_DATA(2))||''', USUARIOMODIFICAR= ''REMVIP-3353_b'' WHERE 			dd_tpd_codigo = ''' ||TRIM(V_TMP_TIPO_DATA(1)) 		 ||''' ';

          EXECUTE IMMEDIATE V_MSQL;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TPD_TIPO_DOCUMENTO ACTUALIZADO CORRECTAMENTE ');


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



