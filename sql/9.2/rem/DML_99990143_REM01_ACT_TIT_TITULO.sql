--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20170905
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2774
--## PRODUCTO=NO
--##
--## Finalidad: Script que borra el campo TIT_FECHA_INSC_REG de ACT_TIT_TITULO de los activos financieros
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
             
    V_MSQL :=	'UPDATE '|| V_ESQUEMA ||'.ACT_TIT_TITULO tit '||
    			'SET tit.TIT_FECHA_INSC_REG = null '||
    			'WHERE tit.TIT_ID IN ( '||
    				'SELECT tit2.TIT_ID from '|| V_ESQUEMA ||'.ACT_TIT_TITULO tit2 '||
    					'INNER JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act ON tit2.ACT_ID = act.ACT_ID '||
    					'INNER JOIN '|| V_ESQUEMA ||'.ACT_ABA_ACTIVO_BANCARIO aba ON act.ACT_ID = aba.ACT_ID '||
    					'INNER JOIN '|| V_ESQUEMA ||'.DD_CLA_CLASE_ACTIVO cla ON aba.DD_CLA_ID = cla.DD_CLA_ID '||
    					'WHERE cla.DD_CLA_CODIGO = ''01'''||
    								')'; 
                
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS CORRECTAMENTE');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: CAMPOS TIT_FECHA_INSC_REG DE LA TABLA:ACT_TIT_TITULO ACTUALIZADOS CORRECTAMENTE ');
   

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