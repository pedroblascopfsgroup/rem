--/*
--########################################################
--## AUTOR=VICTOR OLIVARES
--## FECHA_CREACION=20190306
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5654
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_SDE_SUBTIPO_DOC_EXP los valores enlazados al tipo de documento 'Reserva':
--## 		Contrato de arras penitenciales o desestimiento, cuya matricula será: OP-08-CNCV-90
--##		Depósito para la despublicación del activo, cuya matricula sera: OP-08-CERA-DE
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--#######################################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_MSQL2 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ID2 VARCHAR2(20);

    ARRAY_MATRICULAS dbms_sql.varchar2_table;
    ARRAY_DESCRIPCION dbms_sql.varchar2_table;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 	ARRAY_MATRICULAS(1) := 'OP-08-CNCV-90';
	ARRAY_MATRICULAS(2) := 'OP-08-CERA-DE';
	ARRAY_DESCRIPCION(1) := 'Contrato de arras penitenciales o desestimiento';
	ARRAY_DESCRIPCION(2) := 'Depósito para la despublicación del activo';

	-- LOOP para insertar los valores 
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_SDE_SUBTIPO_DOC_EXP');
    FOR I IN ARRAY_MATRICULAS.FIRST .. ARRAY_MATRICULAS.LAST
      LOOP
	V_MSQL := 'SELECT MAX(DD_SDE_CODIGO) + 1 FROM '|| V_ESQUEMA ||'.DD_SDE_SUBTIPO_DOC_EXP';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID2;
	--Comprobamos si existen las matrículas en DD_SDE_SUBTIPO_DOC_EXP para ver si insertamos la fila o no hacemos nada
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SDE_SUBTIPO_DOC_EXP WHERE DD_SDE_MATRICULA_GD = '''|| ARRAY_MATRICULAS(I) ||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				         
  	DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE UN REGISTRO CORRESPONDIENTE A LA MATRICULA '|| ARRAY_MATRICULAS(I) ||''); 	          
        ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '|| I ||'');   	
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_SDE_SUBTIPO_DOC_EXP.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
            	DBMS_OUTPUT.PUT_LINE('numero de secuencia  '||V_ID); 	          
			
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_SDE_SUBTIPO_DOC_EXP (
                      DD_SDE_ID
			, DD_TDE_ID
			, DD_SDE_CODIGO
			, DD_SDE_DESCRIPCION
			,DD_SDE_DESCRIPCION_LARGA
			, VERSION
			, USUARIOCREAR
			, FECHACREAR
			, DD_SDE_MATRICULA_GD
			, DD_SDE_VINCULABLE
			, DD_SDE_TPD_ID
			) VALUES(
                   	'|| V_ID ||'
			,(SELECT DD_TDE_ID FROM DD_TDE_TIPO_DOC_EXP WHERE DD_TDE_CODIGO=''03'')
			, '''|| V_ID2 ||'''
			,'''|| ARRAY_DESCRIPCION(I) ||'''
			,'''|| ARRAY_DESCRIPCION(I) ||'''
		      ,0
			,''HREOS-5654''
			,SYSDATE,
		      '''||ARRAY_MATRICULAS(I)||'''
		      ,NULL
			,NULL) ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE ');
        
       END IF;

      END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DD_SDE_SUBTIPO_DOC_EXP ACTUALIZADO CORRECTAMENTE ');
   

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



   
        
