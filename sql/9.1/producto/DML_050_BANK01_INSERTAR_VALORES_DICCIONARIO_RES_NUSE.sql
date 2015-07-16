--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=20150710
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-94	
--## PRODUCTO=SI
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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

    
    TYPE T_TIPO_RVC IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_RVC IS TABLE OF T_TIPO_RVC;
    V_TIPO_RVC T_ARRAY_RVC := T_ARRAY_RVC(
        T_TIPO_RVC('0'	,'PROPUESTA GENERADA CORRECTAMENTE'),
		T_TIPO_RVC('20'	,'IDENTIFICADOR PROCEDIMIENTO NO EXISTE'),
		T_TIPO_RVC('20'	,'BUSCA EXPEDIENTE'),
		T_TIPO_RVC('21'	,'FALTAN DATOS DEL EXPEDIENTE'),
		T_TIPO_RVC('23'	,'NO EXISTE ID_EXPEDIENTE'),
		T_TIPO_RVC('25'	,'BUSCA PRIMER TITULAR'),
		T_TIPO_RVC('30'	,'IDENTIFICADOR ACUERDO PROPUESTA SUBASTA DEL PROCEDIMIENTO YA EXISTE'),
		T_TIPO_RVC('30'	,'BUSCA DATOS PRIMER TITULAR'),
		T_TIPO_RVC('35'	,'INSERCION RCV_CD_EXP'),
		T_TIPO_RVC('40'	,'NO EXISTEN PARA LA CLAVE DATOS EN RCV_CD_EXP.'),
		T_TIPO_RVC('49'	,'INSERCION RCV_CD_CTA_DEU'),
		T_TIPO_RVC('55'	,'NO EXISTE EL JUZGADO'),
		T_TIPO_RVC('60'	,'TIPO DE PROCEDIMIENTO INCORRECTO'),
		T_TIPO_RVC('60'	,'NO ENCUENTRA EN POS_LEASING'),
		T_TIPO_RVC('65'	,'NUMERO DE AUTOS SIN INFORMAR'),
		T_TIPO_RVC('65'	,'INSERCION RCV_CD_CTA_LEA'),
		T_TIPO_RVC('115'	,'OPERACION DEMANDADA NO ES DEUDORA EN RCV_CD_CTA_DEU'),
		T_TIPO_RVC('125'	,'NO HAY DATOS DE LA DEUDA PARA LA CUENTA EN RCV_CD_CTA_DAT'),
		T_TIPO_RVC('128'	,'INSERCION RCV_CD_CTA_INF'),
		T_TIPO_RVC('132'	,'OPERACION DUPLICADA PARA LA PROPUESTA'),
		T_TIPO_RVC('140'	,'OPERACION MARCADA BFA Y BMD'),
		T_TIPO_RVC('145'	,'INSERCION RCV_CD_CTA_LEA INF'),
		T_TIPO_RVC('155'	,'OPERACION CON MARCAS DE BFA Y BMD DISTINTAS EN LA MISMA PROPUESTA'),
		T_TIPO_RVC('160'	,'OPERACION CON MARCAS DE BFA Y BMD DISTINTAS EN LA MISMA PROPUESTA'),
		T_TIPO_RVC('195'	,'NO HAY DATOS SIMULACION DEUDA DEL LEASING EN RCV_CD_CTA_DAT.'),
		T_TIPO_RVC('200'	,'ERROR EN SIMULACION DEUDA DEL LEASING EN RCV_CD_CTA_DAT'),
		T_TIPO_RVC('225'	,'OPERACION DUPLICADA PARA LA PROPUESTA'),
		T_TIPO_RVC('265'	,'NO HAY OPERACIONES EN LA PROPUESTA'),
		T_TIPO_RVC('275'	,'NO IMPORTE CALCULADO EN LA PROPUESTA'),
		T_TIPO_RVC('355'	,'NO DATOS SIMULACION DEUDA DEL LEASING EN RCV_CD_CTA_LEA'),
		T_TIPO_RVC('360'	,'ERROR EN SIMULACION DEUDA DEL LEASING EN RCV_CD_CTA_LEA'),
		T_TIPO_RVC('390'	,'OPERACION CONEXIONADA DUPLICADA PARA LA PROPUESTA'),
		T_TIPO_RVC('420'	,'PERSONA INEXISTENTE'),
		T_TIPO_RVC('445'	,'LOTE NULO'),
		T_TIPO_RVC('450'	,'ID_BIEN_RECOVERY NULO'),
		T_TIPO_RVC('455'	,'NUMERO DE ACTIVO NO VALIDO'),
		T_TIPO_RVC('470'	,'NO EXISTE ID_BIEN_NUSE'),
		T_TIPO_RVC('475'	,'EL IDENTIFICADOR DEL BIEN NUSE ESTA DUPLICADO EN LA PROPUESTA.'),
		T_TIPO_RVC('490'	,'NO EXISTEN DATOS DEL BIEN EN RCV_CD_BIE_PROP'),
		T_TIPO_RVC('495'	,'FALLO CONSULTA EN RCV_CD_BIE_PROP'),
		T_TIPO_RVC('505'	,'NO HAY BIENES EN LA PROPUESTA'),
		T_TIPO_RVC('520'	,'NO HAY DATOS RESOLUCION LOTE EN RCV_CD_BIE_LOT_RES'),
		T_TIPO_RVC('555'	,'YA EXISTE ESE LOTE FORMALIZADO EN EL PROCEDIMIENTO'),
		T_TIPO_RVC('565'	,'NO HAY DATOS INSTRUCCIONES LOTE EN RCV_CD_BIE_LOT_INS'),
		T_TIPO_RVC('575'	,'FALTA SUBASTA CELEBRADA'),
		T_TIPO_RVC('585'	,'EL RESULTADO SUBASTA PARA EL LOTE ES INCORRECTO'),
		T_TIPO_RVC('590'	,'DISTINTOS RESULTADOS DE SUBASTA POR LOTE EN LA MISMA PROPUESTA'),
		T_TIPO_RVC('655'	,'IDENTIFICADOR BIEN EN NUSE NO INFORMADO'),
		T_TIPO_RVC('665'	,'TASACION ACTIVO NO INFORMADA'),
		T_TIPO_RVC('675'	,'FECHA TASACION ACTIVO NO INFORMADA'),
		T_TIPO_RVC('685'	,'FECHA DE SEÑALAMIENTO SUBASTA NO INFORMADA'),
		T_TIPO_RVC('688'	,'IMPORTE SUBASTA NO INFORMADO'),
		T_TIPO_RVC('695'	,'CODIGO HITO MAS AVANZADO NO INFORMADO'),
		T_TIPO_RVC('705'	,'CODIGO HITO MAS AVANZADO INCORRECTO'),
		T_TIPO_RVC('715'	,'CODIGO HITO MAS AVANZADO NO INFORMADO'),
		T_TIPO_RVC('720'	,'RESULTADO DE LA SUBATASTA PARA EL BIEN DISTINTO DEL LOTE DONDE ESTA INCLUIDO'),
		T_TIPO_RVC('722'	,'BIEN CON LA FECHA AUTO ADJUDICACION FIRME NO INFORMADA EN PROPUESTA DE SAREB'),
		T_TIPO_RVC('985'	,'OPERACION DEMANDADA NO ES DEUDORA EN RCV_CD_CTA_DEU'),
		T_TIPO_RVC('995'	,'NO HAY DATOS DE LA DEUDA PARA LA CUENTA EN RCV_CD_CTA_DAT'),
		T_TIPO_RVC('1005'	,'OPERACION DUPLICADA PARA LA PROPUESTA'),
		T_TIPO_RVC('1015'	,'OPERACION MARCADA BFA Y BMD'),
		T_TIPO_RVC('1030'	,'OPERACION CON MARCAS DE BFA Y BMD DISTINTAS EN LA MISMA PROPUESTA'),
		T_TIPO_RVC('1035'	,'OPERACION CON MARCAS DE BFA Y BMD DISTINTAS EN LA MISMA PROPUESTA'),
		T_TIPO_RVC('1070'	,'NO HAY DATOS SIMULACION DEUDA DEL LEASING EN RCV_CD_CTA_DAT'),
		T_TIPO_RVC('1075'	,'ERROR EN SIMULACION DEUDA DEL LEASING EN RCV_CD_CTA_DAT'),
		T_TIPO_RVC('1100','OPERACION DUPLICADA PARA LA PROPUESTA')
    ); 
    V_TMP_TIPO_RVC T_TIPO_RVC;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	
	
	 
    -- LOOP para insertar/modificar los valores en DD_TVI_TIPO_VIA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION/MODIFICACION EN DD_RVN_RES_VALIDACION_NUSE] ');
    FOR I IN V_TIPO_RVC.FIRST .. V_TIPO_RVC.LAST
      LOOP
      
        V_TMP_TIPO_RVC := V_TIPO_RVC(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RVN_RES_VALIDACION_NUSE WHERE DD_RVN_CODIGO = '''||TRIM(V_TMP_TIPO_RVC(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_RVC(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_RVN_RES_VALIDACION_NUSE '||
                    'SET DD_RVN_DESCRIPCION = '''||TRIM(V_TMP_TIPO_RVC(2))||''''|| 
					', DD_RVN_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_RVC(2))||''''||
					', USUARIOMODIFICAR = ''FASE-1376'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_RVN_CODIGO = '''||TRIM(V_TMP_TIPO_RVC(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_RVC(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_RVN_RES_VALIDACION_NUSE.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_RVN_RES_VALIDACION_NUSE (' ||
                      'DD_RVN_ID, DD_RVN_CODIGO, DD_RVN_DESCRIPCION, DD_RVN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_RVC(1)||''','''||TRIM(V_TMP_TIPO_RVC(2))||''','''||TRIM(V_TMP_TIPO_RVC(2))||''', 0, ''FASE-1464'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_RVN_RES_VALIDACION_NUSE ACTUALIZADO CORRECTAMENTE ');
   

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



   