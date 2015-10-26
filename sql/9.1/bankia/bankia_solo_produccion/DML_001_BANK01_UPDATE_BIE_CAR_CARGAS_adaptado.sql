--/*
--##########################################
--## AUTOR=OSCAR DORADO
--## FECHA_CREACION=20150914
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.15-bk
--## INCIDENCIA_LINK=no_tiene
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


--Script perteneciente a NO_PROTOCOLO adaptado para el resto de entornos BANKIA
DBMS_OUTPUT.PUT_LINE('[INICIO] ');

DBMS_OUTPUT.PUT_LINE('[START]  tabla BIE_CAR_CARGAS');

EXECUTE IMMEDIATE 'UPDATE '|| V_ESQUEMA ||'.bie_car_cargas set dd_tpc_id = 2, usuariomodificar = ''SAG'', fechamodificar = sysdate where dd_tpc_id = 5';
EXECUTE IMMEDIATE 'UPDATE '|| V_ESQUEMA ||'.bie_car_cargas set dd_tpc_id = 1, usuariomodificar = ''SAG'', fechamodificar = sysdate where dd_tpc_id = 4';
EXECUTE IMMEDIATE 'UPDATE '|| V_ESQUEMA ||'.bie_car_cargas set dd_tpc_id = 1, usuariomodificar = ''SAG'', fechamodificar = sysdate where dd_tpc_id in (7,6,3)';



	DBMS_OUTPUT.PUT_LINE('UPDATE  '|| V_ESQUEMA ||'.bie_car_cargas ... OK');



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
	
