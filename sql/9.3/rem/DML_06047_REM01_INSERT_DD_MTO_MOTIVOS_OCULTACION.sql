--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20211202
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10864
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-10864'; -- USUARIOCREAR/USUARIOMODIFICAR
    vEXISTECODIGO NUMBER;
       
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('18', 'Oferta aprobada', 0, '02',13)
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
                  ,DD_MTO_ORDEN
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
                  , '''||V_TMP_TIPO_DATA(5)||'''
					  , 0
					  , '''||V_USR||'''
					  , SYSDATE
				  , 0
					FROM DUAL
					'
					;
				DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO]: Ya existe registro con ese codigo');				
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
