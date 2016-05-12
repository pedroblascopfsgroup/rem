--/*
--##########################################
--## AUTOR=MIGUEL ANGEL SANCHEZ
--## FECHA_CREACION=12-04-2016
--## ARTEFACTO=BACHT
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2225
--## PRODUCTO=NO
--## Finalidad:  borrado asunto 0006044 | B35449289 CONSTRUCCIONES Y REFORMAS LAMA. 
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE('[INICIO] Borrado asunto 0006044 | B35449289 CONSTRUCCIONES Y REFORMAS LAMA.');

-------------------------------------------------------------------------------------------------------------
V_MSQL := '
MERGE INTO HAYA01.ASU_ASUNTOS ASU 
   USING (
      SELECT ASU_ID FROM HAYA01.ASU_ASUNTOS ASU 
      WHERE asu.asu_nombre=''0006044 | B35449289 CONSTRUCCIONES Y REFORMAS LAMA''
   )  TMP
   ON (TMP.ASU_ID=ASU.ASU_ID)
   WHEN MATCHED THEN UPDATE SET 
      BORRADO=1,
      USUARIOBORRAR=''HR2225'',
      FECHABORRAR=SYSDATE
';
EXECUTE IMMEDIATE V_MSQL;
-------------------------------------------------------------------------------------------------------------    
V_MSQL := '
MERGE INTO HAYA01.PRC_PROCEDIMIENTOS PRC 
   USING (
      SELECT PRC_ID FROM HAYA01.ASU_ASUNTOS ASU 
      INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON ASU.ASU_ID=PRC.ASU_ID
      WHERE asu.asu_nombre=''0006044 | B35449289 CONSTRUCCIONES Y REFORMAS LAMA''
   )  TMP
   ON (PRC.PRC_ID=TMP.PRC_ID)
   WHEN MATCHED THEN UPDATE SET 
   BORRADO=1,
   USUARIOBORRAR=''HR2225'',
   FECHABORRAR=SYSDATE
';
EXECUTE IMMEDIATE V_MSQL;
-------------------------------------------------------------------------------------------------------------
V_MSQL := '
MERGE INTO HAYA01.TAR_TAREAS_NOTIFICACIONES TAR
   USING (
      SELECT TAR_ID FROM HAYA01.ASU_ASUNTOS ASU 
      INNER JOIN HAYA01.PRC_PROCEDIMIENTOS PRC ON ASU.ASU_ID=PRC.ASU_ID
      INNER JOIN HAYA01.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.PRC_ID = PRC.PRC_ID 
      WHERE asu.asu_nombre=''0006044 | B35449289 CONSTRUCCIONES Y REFORMAS LAMA''
   )  TMP
   ON (TAR.TAR_ID=TMP.TAR_ID)
   WHEN MATCHED THEN UPDATE SET
         BORRADO=1,
      USUARIOBORRAR=''HR2225'',
      FECHABORRAR=SYSDATE
';
EXECUTE IMMEDIATE V_MSQL;

-------------------------------------------------------------------------------------------------------------


    DBMS_OUTPUT.PUT_LINE('    [INFO] Borrado el asunto.');	

DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('KO no modificado');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          ROLLBACK;
          RAISE;          
END;
/
EXIT