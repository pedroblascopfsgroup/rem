--/*
--##########################################
--## AUTOR=OSCAR
--## FECHA_CREACION=20150504
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.5.12
--## INCIDENCIA_LINK=FASE-1241
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

EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.bie_localizacion loc
   USING (SELECT tmp.bie_id, dd.dd_loc_id nuevo
            FROM '||V_ESQUEMA_M||'.dd_loc_localidad dd
                 JOIN
                 (SELECT bie_loc_poblacion poblacion, loc.bie_id
                    FROM '||V_ESQUEMA||'.bie_localizacion loc
                   WHERE bie_loc_poblacion IS NOT NULL AND loc.dd_loc_id is null) tmp ON UPPER (tmp.poblacion) = UPPER (dd.dd_loc_descripcion)
                 ) pob
   ON (loc.bie_id = pob.bie_id)
   WHEN MATCHED THEN
      UPDATE
         SET loc.dd_loc_id = pob.nuevo, usuariomodificar = ''FASE-1241'', fechamodificar = SYSDATE'; 

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

