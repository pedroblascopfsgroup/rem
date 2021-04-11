--/*
--##########################################
--## AUTOR=Jesus Jativa
--## FECHA_CREACION=20210409
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13695
--## PRODUCTO=NO
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

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');

V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD WHERE PEN_PARAM = ''comunicacionBoardingActivada''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
      EXECUTE IMMEDIATE 'update '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD set pen_valor = ''true'' where pen_param = ''comunicacionBoardingActivada''';
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD
   			(PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 			Values
   			('||V_ESQUEMA||'.s_pen_param_entidad.nextval, ''comunicacionBoardingActivada'', ''true'', ''Parametro para activar/desactivar la comunicacion con CFV '', 0, ''HREOS-13695'', sysdate, 0)';
      EXECUTE IMMEDIATE V_SQL ;      
    END IF ;
    
	

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');



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

