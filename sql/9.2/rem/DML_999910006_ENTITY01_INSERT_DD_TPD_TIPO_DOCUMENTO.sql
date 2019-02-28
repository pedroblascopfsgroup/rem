--/*
--##########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20190226
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
T_TIPO_DATA('83','Certificado sustitutivo de Cédula de Habitabilidad','Certificado sustitutivo de Cédula de Habitabilidad','OP-13-LIPR-14'),
T_TIPO_DATA('84','CEE (Etiqueta de eficiencia energética)','Eficiencia energética: etiqueta','OP-13-CERT-25'),
T_TIPO_DATA('85','CEE (Justificante de presentación en registro)','Tasa de inscripción en el Registro del Certificado Energético (CEE)','OP-13-CERA-71'),
T_TIPO_DATA('86','Boletín gas','Instalación gas: boletín suministro','OP-13-CERT-11'),
T_TIPO_DATA('87','Boletín electricidad','Instalación eléctrica: boletín suministro','OP-13-CERT-10'),
T_TIPO_DATA('88','Boletín agua','Instalación agua: boletín suministro','OP-13-CERT-07'),
T_TIPO_DATA('89','CFO (Certificado de final de obra)','Obra: certificado final','OP-13-CERT-17'),
T_TIPO_DATA('90','Cédula de habitabilidad','Obra: cédula de habitabilidad','OP-13-LIPR-03'),
T_TIPO_DATA('91','LPO (Licencia de primera ocupación)','Obra: licencia primera ocupación','OP-13-LIPR-06'),
T_TIPO_DATA('92','CEE (Certificado de eficiencia energética)','Eficiencia energética: certificado','OP-13-CERT-05'),
T_TIPO_DATA('93','VPO: Solicitud importe devolución ayudas','Vivienda de protección: Solicitud importe devolución ayudas','OP-13-PRPE-38'),
T_TIPO_DATA('94','VPO: Notificación adjudicación para tanteo','Vivienda de protección: Notificación adjudicación para tanteo','OP-13-COMU-74'),
T_TIPO_DATA('95','VPO: Solicitud autorización venta','Autorización venta Vivienda de Protección Oficial (VPO)','OP-13-ACUE-07'),
T_TIPO_DATA('96','Tasación adjudicación','Tasación: informe activo','OP-13-TASA-11'),
T_TIPO_DATA('97','Nota simple actualizada','Registro Propiedad: nota simple / literal','OP-13-NOTS-01'),
T_TIPO_DATA('98','Nota simple sin cargas','Registro Propiedad: nota simple inscrita/sin cargas','OP-13-NOTS-08'),
T_TIPO_DATA('99','Posesión: acta de lanzamiento','Posesión activo: acta lanzamiento','OP-13-DOCJ-15'),
T_TIPO_DATA('100','Informe okupación y/o desokupacion','Informe okupación y/o desokupacion','OP-13-ESIN-97'),
T_TIPO_DATA('101','Título inscrito (Testimonio)','Título inscrito (Testimonio)','OP-13-DOCJ-BJ'),
T_TIPO_DATA('102','Título inscrito (Escritura)','Título inscrito (Escritura)','OP-13-ESCR-48'),
T_TIPO_DATA('103','Decreto adjudicación','Subasta: auto / decreto adjudicación','OP-13-SERE-24'),
T_TIPO_DATA('104','Informes técnicos del trabajo','Documentos de trabajos técnicos','OP-13-DOCT-20'),
T_TIPO_DATA('105','Informe 0','Informe de Estado Edificación (Informe 0)','OP-13-ESIN-34'),
T_TIPO_DATA('106','Informe estado del activo','Obra: informe estado','OP-13-ESIN-45'),
T_TIPO_DATA('107','Respuesta propietario incremento de presupuesto','Respuesta de incremento de presupuesto','OP-13-PRES-15'),
T_TIPO_DATA('108','Presupuesto','Presupuesto inversión','OP-13-PRES-07'),
T_TIPO_DATA('109','Informe fotográfico de trabajos realizados','Fotografía reparación','OP-13-FOTO-02'),
T_TIPO_DATA('110','Propuesta de precios sancionada','Propuesta de precios propietario','OP-13-ESIN-AO'),
T_TIPO_DATA('111','Propuesta de precios enviada','Propuesta de precios enviada','OP-13-ESIN-AN'),
T_TIPO_DATA('112','Propuesta de precios generada','Propuesta de precios inicial','OP-13-ESIN-AM'),
T_TIPO_DATA('113','Listado de actualización de precios','Listado de actualización de precios','OP-13-ESIN-BB'),
T_TIPO_DATA('114','Factura de la actuación a incorporar en Gastos','Factura de la actuación a incorporar en Gastos','OP-13-FACT-AV'),
T_TIPO_DATA('115','Informes técnicos del trabajo','Documentos de trabajos técnicos','OP-13-DOCT-20'),
T_TIPO_DATA('116','Informe estado del activo','Obra: informe estado','OP-13-ESIN-45'),
T_TIPO_DATA('117','Proyecto ejecución: certificado de eficiencia energética','Proyecto ejecución: certificado de eficiencia energética','OP-13-CERT-22'),
T_TIPO_DATA('118','Eficiencia energética:No Calificable CEE','Eficiencia energética:No Calificable CEE','OP-13-CERT-30'),
T_TIPO_DATA('119','Advisory Note aceptación de presupuestos','Advisory Note aceptación de presupuestos','OP-13-ACUE-21')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para MODIFICAR los valores en DD_TPD_TIPO_DOCUMENTO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TPD_TIPO_DOCUMENTO ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
 		
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := '
                      INSERT INTO '|| V_ESQUEMA ||'.dd_tpd_tipo_documento (
                        dd_tpd_id,
                        dd_tpd_codigo,
                        dd_tpd_descripcion,
                        dd_tpd_descripcion_larga,
                        version,
                        usuariocrear,
                        fechacrear,
                        borrado,
                        dd_tpd_matricula_gd,
                        dd_tpd_visible
                      ) VALUES (
                        '|| V_ESQUEMA ||'.S_DD_TPD_TIPO_DOCUMENTO.NEXTVAL,
                        '''||TRIM(V_TMP_TIPO_DATA(1))||''',
                        '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                        '''||TRIM(V_TMP_TIPO_DATA(3))||''',
                        1,
                        ''REMVIP-3353'',
                        SYSDATE,
                        0,
                        '''||TRIM(V_TMP_TIPO_DATA(4))||''',
                        0
                      )';

          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADOS '||SQL%ROWCOUNT||' CORRECTAMENTE');
            
      
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



