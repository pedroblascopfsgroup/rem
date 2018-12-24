--/*
--##########################################
--## AUTOR=NURIA GARCES
--## FECHA_CREACION=20170802
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4309
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el campo DD_TDE_ID de la tabla DES_DESPACHO_EXTERNO
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
	
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(5050);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    				-- DES_DESPACHO	-- DD_TDE_CODIGO	
		T_TIPO_DATA('GESTCOMALQ'		,'GALQ'	),
		T_TIPO_DATA('SUPCOMALQ'			,'SUALQ')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	 
    -- LOOP para modificar los valores en DES_DESPACHO_EXTERNO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INICIO LOOP -> UPDATE EN DES_DESPACHO_EXTERNO ] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a modificar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE BORRADO = 0 AND DES_DESPACHO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        -- ------------------------------------------------------------------------------------
        --Si existe el DESPACHO.
        IF V_NUM_TABLAS > 0 THEN	

     --Comprobamos el dato a INSERTAR
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO WHERE BORRADO = 0 AND DD_TDE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        -- ------------------------------------------------------------------------------------
        --Si existe el TIPO DE DESPACHO.
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL DESPACHO ');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DES_DESPACHO_EXTERNO
                        SET USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE,
                        DD_TDE_ID = (SELECT DD_TDE_ID FROM '|| V_ESQUEMA_M ||'.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''') 
                        WHERE DES_DESPACHO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''  AND BORRADO = 0';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: OK en DES_DESPACHO_EXTERNO');
          
       --Si no existe, NO HACEMOS NADA
       ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO NO EXISTE');
        
       END IF;
       ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO NO EXISTE');
        
       END IF;
       -- ------------------------------------------------------------------------------------
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: LOOP ');
   

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
