--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190520
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4082
--## PRODUCTO=NO
--## Finalidad: Rellenar tabla ACT_ASI_HAYA.
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
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_ASI_HAYA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN
   
    DBMS_OUTPUT.PUT_LINE('******** INSERTS SOBRE ' ||V_TEXT_TABLA|| '********'); 
    
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33720742'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE(V_MSQL);
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''31439729'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE(V_MSQL);
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32913609'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE(V_MSQL);
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32579679'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE(V_MSQL);
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32082086'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33574652'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33694638'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32676597'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33715388'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33629548'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32474610'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32748954'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32388986'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33582256'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33697626'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32620934'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32821424'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32938735'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''31904084'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32764045'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33332973'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''31846045'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32795671'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''31939628'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32763736'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32559482'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33351655'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32821172'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32353712'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32399461'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33724876'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33709509'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32014512'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33582022'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33582139'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33219641'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32619732'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33108423'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32001610'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32790490'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33099528'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32400790'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33003570'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''31954995'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33116144'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33726718'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33308955'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33265815'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''31519069'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33531639'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32913591'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32333515'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''31895927'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''32901502'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33719774'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''34275514'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;
V_MSQL := 'Insert into '||V_ESQUEMA||'.ACT_ASI_HAYA  values(''33719891'',  NULL, SYSDATE,  NULL,  0, ''ALT_BANKIA'', SYSDATE,  NULL,  NULL,  NULL, NULL, 0 )';
EXECUTE IMMEDIATE V_MSQL;



COMMIT;

   
    DBMS_OUTPUT.PUT_LINE('INSERTADOS  REGISTROS EN LA TABLA '||V_TEXT_TABLA||'');


EXCEPTION

     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificada');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;
/

EXIT
