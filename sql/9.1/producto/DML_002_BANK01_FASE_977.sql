--/*
--##########################################
--## AUTOR=JOSEVI
--## FECHA_CREACION=20150529
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.5.13
--## INCIDENCIA_LINK=FASE-977
--## PRODUCTO=SI
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
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  	
BEGIN	

DBMS_OUTPUT.PUT_LINE('[INICIO]');  

V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.dd_eas_estado_asuntos WHERE DD_EAS_CODIGO = ''20''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS > 0 THEN    
    DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA_M||'.dd_eas_estado_asuntos ...no se modificará nada.');
  ELSE
    V_MSQL := 'insert into '||V_ESQUEMA_M||'.dd_eas_estado_asuntos (dd_eas_id, DD_EAS_CODIGO, DD_EAS_DESCRIPCION, DD_EAS_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) '||
              ' VALUES ('||V_ESQUEMA_M||'.s_dd_eas_estado_asuntos.nextval, ''20'', ''Gestión finalizada'', ''Gestión finalizada con provisiones pendientes'', ''SAG'', sysdate)';
        
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.dd_eas_estado_asuntos... Datos del diccionario insertado');
        
    END IF; 

    COMMIT;


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
