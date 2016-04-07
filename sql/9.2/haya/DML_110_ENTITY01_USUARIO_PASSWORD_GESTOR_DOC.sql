--/*
--##########################################
--## AUTOR=MANU MEJIAS
--## FECHA_CREACION=20160407
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc37
--## INCIDENCIA_LINK=PRODUCTO-1116
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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

V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD WHERE PEN_PARAM = ''usuarioHayaGestorDoc''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
      EXECUTE IMMEDIATE 'update '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD set pen_valor = ''srv.recovery_ot'' where pen_param = ''usuarioHayaGestorDoc''';
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD
   			(PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 			Values
   			('||V_ESQUEMA||'.s_pen_param_entidad.nextval, ''usuarioHayaGestorDoc'', ''srv.recovery_ot'', ''Usuario del gestor documental de HAYA'', 0, ''DD'', sysdate, 0)';
      EXECUTE IMMEDIATE V_SQL ;
      DBMS_OUTPUT.put_line('[INFO] Se ha insertado el registro usuarioHayaGestorDoc');
    END IF ;
    
    
    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD WHERE PEN_PARAM = ''passwordHayaGestorDoc''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
      EXECUTE IMMEDIATE 'update '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD set pen_valor = ''Author8'' where pen_param = ''passwordHayaGestorDoc''';
    ELSE        
      V_SQL := 'Insert into '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD
   			(PEN_ID, PEN_PARAM, PEN_VALOR, PEN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 			Values
   			('||V_ESQUEMA||'.s_pen_param_entidad.nextval, ''passwordHayaGestorDoc'', ''Author8'', ''Password del gestor documental de HAYA'', 0, ''DD'', sysdate, 0)';
      EXECUTE IMMEDIATE V_SQL ;
      DBMS_OUTPUT.put_line('[INFO] Se ha insertado el registro passwordHayaGestorDoc');
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

