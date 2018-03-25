--/*
--##########################################
--## AUTOR=Carlos López
--## FECHA_CREACION=20180322
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=HREOS-3897
--## PRODUCTO=NO
--##
--## Finalidad: 
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
    V_TABLA VARCHAR2(30 CHAR) := 'DD_MTO_MOTIVOS_OCULTACION';  -- Tabla a modificar
    V_TABLA_SEQ VARCHAR2(30 CHAR) := 'S_DD_MTO_MOTIVOS_OCULTACION';  -- Tabla a modificar    
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_USR VARCHAR2(30 CHAR) := 'HREOS-3890'; -- USUARIOCREAR/USUARIOMODIFICAR
    vEXISTECODIGO NUMBER;
       
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('01', 'No Publicable', 0, '02',3),
	T_TIPO_DATA('02', 'No Comercializable', 0, '02',4),
	T_TIPO_DATA('03', 'Alquilado', 0, '02',8),
	T_TIPO_DATA('04', 'Revisión adecuación', 0, '03',6),
	T_TIPO_DATA('05', 'No adecuado', 0, '03',7),
	T_TIPO_DATA('06', 'Revisión Publicación', 0, '02',5),
	T_TIPO_DATA('07', 'Reservado', 0, '02',9),
	T_TIPO_DATA('08', 'Salida Perímetro', 0, '02',2),
	T_TIPO_DATA('09', 'Revisión Admisión', 1, '02',10),
	T_TIPO_DATA('10', 'Revisión Técnica', 1, '02',11),
	T_TIPO_DATA('11', 'Revisión en curso', 1, '02',12),
	T_TIPO_DATA('12', 'Otros', 1, '02',13),
	T_TIPO_DATA('13', 'Vendido', 0, '02',1)
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en DD_MTO_MOTIVOS_OCULTACION -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_MTO_MOTIVOS_OCULTACION] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
 
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_MTO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = '''||V_TMP_TIPO_DATA(4)||''' AND BORRADO = 0 ';
		EXECUTE IMMEDIATE V_SQL INTO vEXISTECODIGO;  
		
		IF vEXISTECODIGO > 0 THEN
			IF V_NUM_TABLAS = 0 THEN 
				--Insertar datos
				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
				EXECUTE IMMEDIATE '
					INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
					   DD_MTO_ID
					  ,DD_MTO_CODIGO
					  ,DD_MTO_DESCRIPCION
				  ,DD_MTO_DESCRIPCION_LARGA
				  ,DD_TCO_ID
				  ,DD_MTO_MANUAL
					  ,VERSION
					  ,USUARIOCREAR
					  ,FECHACREAR
					  ,BORRADO
					)   
					SELECT
					  '||V_ESQUEMA||'.'||V_TABLA_SEQ||'.NEXTVAL
					  , '''||V_TMP_TIPO_DATA(1)||'''
					  , '''||V_TMP_TIPO_DATA(2)||'''
					  , '''||V_TMP_TIPO_DATA(2)||''' 
				  , (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = '''||V_TMP_TIPO_DATA(4)||''' AND BORRADO = 0 )
				  , '''||V_TMP_TIPO_DATA(3)||'''
					  , 0
					  , '''||V_USR||'''
					  , SYSDATE
				  , 0
					FROM DUAL
					'
					;
				DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
			ELSE
			
				V_MSQL :=  '
					UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
					   SET DD_MTO_ORDEN = '''||V_TMP_TIPO_DATA(5)||'''
					      , USUARIOMODIFICAR = '''||V_USR||'''
					      , FECHAMODIFICAR = SYSDATE
					 WHERE DD_MTO_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''
					   AND BORRADO = 0
					'
					;
				
				EXECUTE IMMEDIATE V_MSQL;
				
				DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ACTUALIZADO CORRECTAMENTE');				
			END IF;
		 END IF;	
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_MTO_MOTIVOS_OCULTACION ACTUALIZADO CORRECTAMENTE ');
   

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



   
