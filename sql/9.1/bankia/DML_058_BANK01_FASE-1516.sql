--/*
--##########################################
--## AUTOR=OSCAR DORADO
--## FECHA_CREACION=20150723
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.12-bk
--## INCIDENCIA_LINK=FASE-1516
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

          
execute immediate 'DELETE FROM '||V_ESQUEMA||'.prb_prc_bie
      WHERE prb_id IN (SELECT prb_id
                         FROM (SELECT prb_id, prc_id, bie_id, usuariocrear, fechacrear, RANK () OVER (PARTITION BY prc_id, bie_id ORDER BY fechacrear) AS ranking
                                 FROM '||V_ESQUEMA||'.prb_prc_bie
                                WHERE (prc_id, bie_id) IN (SELECT   prc_id, bie_id                                                                                                          --, count(1)
                                                               FROM '||V_ESQUEMA||'.prb_prc_bie
                                                              WHERE borrado = 0
                                                           GROUP BY prc_id, bie_id
                                                             HAVING COUNT (1) > 1) AND usuariocrear <> ''MIGRABNKF2'')
                        WHERE ranking = 2)';

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

