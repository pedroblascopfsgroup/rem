--/*
--##########################################
--## AUTOR=BRUNO ANGLÉS
--## FECHA_CREACION=20170726
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2379
--## PRODUCTO=NO
--##
--## Finalidad: Cambiar descripción a un tipo de documento	
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
       
	/**
	Formalización - Contrato de alquiler --> 2.- Sanción Contrato alquiler
	Formalización - VPO: Autorización de Venta --> 3.- Reserva Autorización venta VPO
	 */ 

    
BEGIN	
	
  DBMS_OUTPUT.PUT_LINE('[INICIO] ');
          
    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS LOS REGISTROS');
    V_MSQL :=   'UPDATE '|| V_ESQUEMA ||'.DD_SDE_SUBTIPO_DOC_EXP '||
                'SET DD_SDE_DESCRIPCION = ''Copia simple escritura de venta'''||
                ', DD_SDE_DESCRIPCION_LARGA = ''Copia simple escritura de venta'''||
                ',USUARIOMODIFICAR = ''HREOS-2379'''||
                ',FECHAMODIFICAR = SYSDATE'||
                ' WHERE DD_SDE_CODIGO = ''19''';
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