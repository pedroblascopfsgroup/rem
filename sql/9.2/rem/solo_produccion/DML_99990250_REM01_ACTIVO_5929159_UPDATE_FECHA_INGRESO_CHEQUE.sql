--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20180301
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-189
--## PRODUCTO=NO
--##
--## Finalidad: Script que pone a null la fecha del ingreso del cheque para el expediente 84428 del activo  5929159
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';--'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';--'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIOMOD VARCHAR2(50 CHAR):= 'REMVIP-189';

    
BEGIN 
  
  DBMS_OUTPUT.PUT_LINE('[INICIO]: Se va a actualizar la fecha de ingreso del cheque del expediente 84428 del activo  5929159');
  
          
  EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL 
                    set eco_fecha_cont_propietario = null
                    where ECO_NUM_EXPEDIENTE = 84428';          

    
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN]: Actualizada la fecha de ingreso del cheque del expediente 84428 del activo  5929159');

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

EXIT;