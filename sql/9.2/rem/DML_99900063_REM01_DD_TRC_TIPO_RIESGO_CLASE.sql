--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20170201
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TRC_TIPO_RIESGO_CLASE los datos añadidos en T_ARRAY_DATA
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
    
    T_TIPO_DATA('10010','AH.PLAZO 3 MESES'			  ,'AH.PLAZO 3 MESES'		  ),
	T_TIPO_DATA('10020','AH.PLAZO 6 MESES'			  ,'AH.PLAZO 6 MESES'		  ),
	T_TIPO_DATA('10030','AH.PLAZO 1 AÑO'              ,'AH.PLAZO 1 AÑO'           ),
	T_TIPO_DATA('10040','AH.PLAZO 2 AÑOS'             ,'AH.PLAZO 2 AÑOS'          ),
	T_TIPO_DATA('10050','AH.PLAZO 2,5 AÑOS'           ,'AH.PLAZO 2,5 AÑOS'        ),
	T_TIPO_DATA('10060','AH.PLAZO 3 AÑOS'             ,'AH.PLAZO 3 AÑOS'          ),
	T_TIPO_DATA('10070','SS.PLAZO 3 MESES'            ,'SS.PLAZO 3 MESES'         ),
	T_TIPO_DATA('10080','SS.PLAZO 6 MESES'            ,'SS.PLAZO 6 MESES'         ),
	T_TIPO_DATA('10090','SS.PLAZO 1 AÑO'              ,'SS.PLAZO 1 AÑO'           ),
	T_TIPO_DATA('10100','SS.PLAZO 2 AÑOS'             ,'SS.PLAZO 2 AÑOS'          ),
	T_TIPO_DATA('10110','D.INTEGR.CRECIENTE'          ,'D.INTEGR.CRECIENTE'       ),
	T_TIPO_DATA('10120','SS.PLAZO 3 AÑOS'             ,'SS.PLAZO 3 AÑOS'          ),
	T_TIPO_DATA('10250','LIB.CAPITALIZACION'          ,'LIB.CAPITALIZACION'       ),
	T_TIPO_DATA('10300','AHORRO ORDINARIO'            ,'AHORRO ORDINARIO'         ),
	T_TIPO_DATA('10310','PEQUEÑO AHORRO'              ,'PEQUEÑO AHORRO'           ),
	T_TIPO_DATA('10320','AHORRO ESCOLAR'              ,'AHORRO ESCOLAR'           ),
	T_TIPO_DATA('10340','SEG.SOC.AH.ORDINAR'          ,'SEG.SOC.AH.ORDINAR'       ),
	T_TIPO_DATA('10350','AH.VISTA PTS.CONV'           ,'AH.VISTA PTS.CONV'        ),
	T_TIPO_DATA('10380','LIBRETA INTEGRAL'            ,'LIBRETA INTEGRAL'         ),
	T_TIPO_DATA('10400','LIBRETA LIDER'               ,'LIBRETA LIDER'            ),
	T_TIPO_DATA('10450','LIBRETA 1'                   ,'LIBRETA 1'                ),
	T_TIPO_DATA('10500','AHORRO VIVIENDA'             ,'AHORRO VIVIENDA'          ),
	T_TIPO_DATA('10540','AH.BURSATIL CON PT'          ,'AH.BURSATIL CON PT'       ),
	T_TIPO_DATA('10550','AH.BURSATIL SINPT'           ,'AH.BURSATIL SINPT'        ),
	T_TIPO_DATA('10600','CUENTA CORRIENTE'            ,'CUENTA CORRIENTE'         ),
	T_TIPO_DATA('10610','CTA.ASOC.CTA.CREDI'          ,'CTA.ASOC.CTA.CREDI'       ),
	T_TIPO_DATA('10620','CTAS.CTES.ACTIVAS'           ,'CTAS.CTES.ACTIVAS'        ),
	T_TIPO_DATA('10630','COOP.CTO.SDO.AC'             ,'COOP.CTO.SDO.AC'          ),
	T_TIPO_DATA('10640','ENT.CORP.PUBLICA'            ,'ENT.CORP.PUBLICA'         ),
	T_TIPO_DATA('10670','CTA.CTE.VINCULADA'           ,'CTA.CTE.VINCULADA'        ),
	T_TIPO_DATA('10680','CTA.CTE.INTEGRAL'            ,'CTA.CTE.INTEGRAL'         ),
	T_TIPO_DATA('10700','SEG.SOC.CTAS.CTES.'          ,'SEG.SOC.CTAS.CTES.'       ),
	T_TIPO_DATA('10800','HABERES PASIVOS'             ,'HABERES PASIVOS'          ),
	T_TIPO_DATA('10810','CTAS.ESPEC.DPM.'             ,'CTAS.ESPEC.DPM.'          ),
	T_TIPO_DATA('10920','PLAN DE PENSIONES'           ,'PLAN DE PENSIONES'        ),
	T_TIPO_DATA('10950','LAMINAS DEPOSITO'            ,'LAMINAS DEPOSITO'         ),
	T_TIPO_DATA('10960','CERTIFIC.DEPOSITO'           ,'CERTIFIC.DEPOSITO'        ),
	T_TIPO_DATA('10970','DEPOS.FINANCIERO'            ,'DEPOS.FINANCIERO'         ),
	T_TIPO_DATA('21000','PRESTAMO'                    ,'PRESTAMO'                 ),
	T_TIPO_DATA('22000','EXP.DESCUENTO'               ,'EXP.DESCUENTO'            ),
	T_TIPO_DATA('22500','LINEA DE TESORERIA'          ,'LINEA DE TESORERIA'       ),
	T_TIPO_DATA('22900','CONTRATO DESCUENTO'          ,'CONTRATO DESCUENTO'       ),
	T_TIPO_DATA('23000','CUENTA DE CREDITO'           ,'CUENTA DE CREDITO'        ),
	T_TIPO_DATA('25000','AVAL'                        ,'AVAL'                     ),
	T_TIPO_DATA('25100','LINEA DE AVAL'               ,'LINEA DE AVAL'            ),
	T_TIPO_DATA('29000','SERV.DESCUBIERTO'            ,'SERV.DESCUBIERTO'         ),
	T_TIPO_DATA('30100','SERV.TELECAJA'               ,'SERV.TELECAJA'            ),
	T_TIPO_DATA('30200','INFOCAM/VIDEOCAM'            ,'INFOCAM/VIDEOCAM'         ),
	T_TIPO_DATA('30210','BANCA POR TELEFONO'          ,'BANCA POR TELEFONO'       ),
	T_TIPO_DATA('30250','TRANSMISION FICHER'          ,'TRANSMISION FICHER'       ),
	T_TIPO_DATA('30500','TARJETA CAJAMADRID'          ,'TARJETA CAJAMADRID'       ),
	T_TIPO_DATA('30550','TARJETA ELECTRON'            ,'TARJETA ELECTRON'         ),
	T_TIPO_DATA('30560','TARJETA VISA CASH'           ,'TARJETA VISA CASH'        ),
	T_TIPO_DATA('30575','TARJETA GASOLEO'             ,'TARJETA GASOLEO'          ),
	T_TIPO_DATA('30600','VISA CLASSIC'                ,'VISA CLASSIC'             ),
	T_TIPO_DATA('30610','VISA PREMIUM'                ,'VISA PREMIUM'             ),
	T_TIPO_DATA('30650','TAR.BUSINESS PLATA'          ,'TAR.BUSINESS PLATA'       ),
	T_TIPO_DATA('30660','TAR. BUSINESS ORO'           ,'TAR. BUSINESS ORO'        ),
	T_TIPO_DATA('30700','EUROCARD'                    ,'EUROCARD'                 ),
	T_TIPO_DATA('30850','FOTOGRAFIA'                  ,'FOTOGRAFIA'               ),
	T_TIPO_DATA('30900','CAJA DE SEGURIDAD'           ,'CAJA DE SEGURIDAD'        ),
	T_TIPO_DATA('31000','CUENTA DE VALORES'           ,'CUENTA DE VALORES'        ),
	T_TIPO_DATA('31100','CTA.CONTAB.VALORES'          ,'CTA.CONTAB.VALORES'       ),
	T_TIPO_DATA('31200','LIBRETA DINAMICA'            ,'LIBRETA DINAMICA'         ),
	T_TIPO_DATA('31500','FONDO DE INVERSION'          ,'FONDO DE INVERSION'       ),
	T_TIPO_DATA('31550','FON.INVERS.REDES'            ,'FON.INVERS.REDES'         ),
	T_TIPO_DATA('32000','SERVICIO NOMINA'             ,'SERVICIO NOMINA'          ),
	T_TIPO_DATA('32100','S.NOMINA H.PASIVOS'          ,'S.NOMINA H.PASIVOS'       ),
	T_TIPO_DATA('32200','COBRO DESEMPLEO'             ,'COBRO DESEMPLEO'          ),
	T_TIPO_DATA('33000','TRASPASO AUTOMATIC'          ,'TRASPASO AUTOMATIC'       ),
	T_TIPO_DATA('37000','CLUB NROS. VERDES'           ,'CLUB NROS. VERDES'        ),
	T_TIPO_DATA('38000','EXP.GESTION COBRO'           ,'EXP.GESTION COBRO'        ),
	T_TIPO_DATA('39000','SEGURO ACCIDENTES'           ,'SEGURO ACCIDENTES'        ),
	T_TIPO_DATA('40200','SEGURO DE RENTAS'            ,'SEGURO DE RENTAS'         ),
	T_TIPO_DATA('40300','SEGURO DE PENSION'           ,'SEGURO DE PENSION'        ),
	T_TIPO_DATA('40310','SEGURO PLAN PENSI.'          ,'SEGURO PLAN PENSI.'       ),
	T_TIPO_DATA('40400','SEGURO A. PRESTAMO'          ,'SEGURO A. PRESTAMO'       ),
	T_TIPO_DATA('40420','SEG.PT.PER.PRIMA P'          ,'SEG.PT.PER.PRIMA P'       ),
	T_TIPO_DATA('40450','SEGURO A.HIPOTECA'           ,'SEGURO A.HIPOTECA'        ),
	T_TIPO_DATA('40500','SEGURO PLURIANUAL'           ,'SEGURO PLURIANUAL'        ),
	T_TIPO_DATA('40510','SEG.VIDA CAJAMADRID'         ,'SEG.VIDA CAJAMADRID'      ),
	T_TIPO_DATA('41920','PLAN DE EMPLEO'              ,'PLAN DE EMPLEO'           ),
	T_TIPO_DATA('51190','PLAZO DIVISA RES.'           ,'PLAZO DIVISA RES.'        ),
	T_TIPO_DATA('51191','PLAZO DIV.NO RES'            ,'PLAZO DIV.NO RES'         ),
	T_TIPO_DATA('51200','CTA.CTE.DIVISA RES'          ,'CTA.CTE.DIVISA RES'       ),
	T_TIPO_DATA('51201','CTA.CTE.DIV.NO RES'          ,'CTA.CTE.DIV.NO RES'       ),
	T_TIPO_DATA('52200','EXTR.LINEA RIESGO'           ,'EXTR.LINEA RIESGO'        ),
	T_TIPO_DATA('52405','FINAN.PTS.IMPOR.'            ,'FINAN.PTS.IMPOR.'         ),
	T_TIPO_DATA('52415','FINAN.PTS.EXPOR / FIPEX.'    ,'FINAN.PTS.EXPOR / FIPEX.' ),
	T_TIPO_DATA('93000','EXP.MEDIOS DE PAGO'          ,'EXP.MEDIOS DE PAGO'       )
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_TRC_TIPO_RIESGO_CLASE -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TRC_TIPO_RIESGO_CLASE] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TRC_TIPO_RIESGO_CLASE WHERE DD_TRC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TRC_ESTADO_CNT_ALQUILER '||
                    'SET DD_TRC_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_TRC_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_TRC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_TRC_TIPO_RIESGO_CLASE.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TRC_TIPO_RIESGO_CLASE (' ||
                      'DD_TRC_ID, DD_TRC_CODIGO, DD_TRC_DESCRIPCION, DD_TRC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, ''DML'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TRC_TIPO_RIESGO_CLASE ACTUALIZADO CORRECTAMENTE ');
   

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



   
