--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20170802
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2543
--## PRODUCTO=NO
--##
--## Finalidad: Script que cambia los tipos de documentos de expediente de dos subtipos			
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
       
    
BEGIN	
	
  DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    --DD_TDE_CODIGO | DESCRIPCION | DD_SDE_CODIGO | DESCRIPCION

    -- Cambio INFORME JURIDICO
    -- 3  3.- Reserva 10  Informe jurídico -- A -- 5.- Formalizacion
    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS LOS REGISTROS');
    V_MSQL :=   'UPDATE '|| V_ESQUEMA ||'.DD_SDE_SUBTIPO_DOC_EXP '||
                'SET DD_TDE_ID = (SELECT DD_TDE_ID FROM '||V_ESQUEMA||'.DD_TDE_TIPO_DOC_EXP WHERE DD_TDE_CODIGO = ''04'')'||
                ',USUARIOMODIFICAR = ''HREOS-2543'''||
                ',FECHAMODIFICAR = SYSDATE'||
                ' WHERE DD_SDE_CODIGO = ''10'' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL;
    
    -- Cambio Autorizacion venta VPO
    -- 3  3.- Reserva 21  Autorización venta VPO -- A -- 5.- Formalizacion
    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS LOS REGISTROS');
    V_MSQL :=   'UPDATE '|| V_ESQUEMA ||'.DD_SDE_SUBTIPO_DOC_EXP '||
                'SET DD_TDE_ID = (SELECT DD_TDE_ID FROM '||V_ESQUEMA||'.DD_TDE_TIPO_DOC_EXP WHERE DD_TDE_CODIGO = ''04'')'||
                ',USUARIOMODIFICAR = ''HREOS-2543'''||
                ',FECHAMODIFICAR = SYSDATE'||
                ' WHERE DD_SDE_CODIGO = ''21'' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL;
    
    -- Cambio Contrato Alquiler
    -- 2  4.- Tanteo  9 Contrato alquiler -- A -- 5.- Formalizacion
    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS LOS REGISTROS');
    V_MSQL :=   'UPDATE '|| V_ESQUEMA ||'.DD_SDE_SUBTIPO_DOC_EXP '||
                'SET DD_TDE_ID = (SELECT DD_TDE_ID FROM '||V_ESQUEMA||'.DD_TDE_TIPO_DOC_EXP WHERE DD_TDE_CODIGO = ''04'')'||
                ',USUARIOMODIFICAR = ''HREOS-2543'''||
                ',FECHAMODIFICAR = SYSDATE'||
                ' WHERE DD_SDE_CODIGO = ''09'' AND BORRADO = 0';        
                
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS CORRECTAMENTE');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_SDE_SUBTIPO_DOC_EXP ACTUALIZADO CORRECTAMENTE ');
   

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