--/*
--##########################################
--## AUTOR=ALBERTO RAMIREZ
--## FECHA_CREACION=20150513
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.0.1
--## INCIDENCIA_LINK=BKNIVDOS-2016
--## PRODUCTO=SI
--## Finalidad: Actualizar los id del campo DD_CIC_ID en la tabla BIE_LOCALIZACION
--##           
--## INSTRUCCIONES: Relanzable
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

EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.BIE_LOCALIZACION bie USING (
    SELECT cirbe.DD_CIC_ID viejo, cirbeb.DD_CIC_ID nuevo, loc.BIE_ID id
    FROM '||V_ESQUEMA_M||'.DD_CIC_CODIGO_ISO_CIRBE cirbe
    JOIN '||V_ESQUEMA_M||'.DD_CIC_CODIGO_ISO_CIRBE_BKP cirbeb on cirbeb.DD_CIC_DESCRIPCION = UPPER (cirbe.DD_CIC_DESCRIPCION)
    JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION loc on loc.DD_CIC_ID = cirbe.DD_CIC_ID
    ) tmp
ON (bie.BIE_ID = tmp.id)
WHEN MATCHED THEN
    update SET bie.DD_CIC_ID = tmp.nuevo';

DBMS_OUTPUT.PUT_LINE('[INFO]: Operación realizada correctamente'); 

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