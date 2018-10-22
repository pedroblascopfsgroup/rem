--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20180918
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1916
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade Oficina Liberbank en la TPH
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
    V_TIPO_ID NUMBER(16); --Vle para el id DD_TGE_TIPO_GESTOR 
    
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT EN DD_TPH_TIPO_PROV_HONORARIO');
    	
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPH_TIPO_PROV_HONORARIO WHERE DD_TPH_CODIGO = ''38''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS = 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO');
       	  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPH_TIPO_PROV_HONORARIO (DD_TPH_ID, DD_TPH_CODIGO, DD_TPH_DESCRIPCION, DD_TPH_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
            SELECT S_DD_TPH_TIPO_PROV_HONORARIO.NEXTVAL, TPR.DD_TPR_CODIGO, TPR.DD_TPR_DESCRIPCION, TPR.DD_TPR_DESCRIPCION_LARGA,
            ''REMVIP-1916'', SYSDATE
            FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR WHERE DD_TPR_CODIGO = ''38''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
        
       END IF;
       
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TPH_TIPO_PROV_HONORARIO ACTUALIZADO CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          DBMS_OUTPUT.PUT_LINE(V_MSQL);

          ROLLBACK;
          RAISE;          

END;

/

EXIT



   



   
