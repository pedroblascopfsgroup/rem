--/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20160322
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=CMREC-2747
--## PRODUCTO=NO
--## Finalidad: DML de creacion de nuevo tipo de subtarea para Notificacion de Alerta por Scoring alto
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

DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
	V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base WHERE DD_STA_CODIGO = ''999''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
    ELSE   
        V_SQL := 'insert into '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base
          (dd_sta_id, dd_tar_id, dd_sta_codigo, dd_sta_descripcion, dd_sta_descripcion_larga, fechacrear, usuariocrear, dd_sta_gestor)
        values
          ('||V_ESQUEMA_M||'.s_dd_sta_subtipo_tarea_base.nextval, 3, ''999'', ''Cliente de Pase presenta Puntuación de Alertas Muy Grave'', ''Atención: Expediente de Seguimiento Sistemático, cliente de pase presenta puntuación de Alertas Muy Grave'', sysdate, ''SAG'',1)';
        EXECUTE IMMEDIATE V_SQL ; 
        DBMS_OUTPUT.put_line('[INFO] Se ha añadido el registro 999');
   END IF;
 
    
commit;

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
    
