--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190520
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4082
--## PRODUCTO=NO
--## Finalidad: Rellenar tabla APR_AUX_STOCK_UVEM_TO_REM.
--##      
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##    0.1 Versión inicial
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
  ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

  V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'APR_AUX_STOCK_UVEM_TO_REM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN
  
  DBMS_OUTPUT.PUT_LINE('******** INSERTS SOBRE ' ||V_TEXT_TABLA|| '********'); 
  
V_MSQL := 'Insert into '||V_ESQUEMA||'.APR_AUX_STOCK_UVEM_TO_REM  values ('||V_ESQUEMA||'.S_APR_AUX_STOCK_UVEM_TO_REM.NEXTVAL,''0'',''31439729'',''00000'',''1'',''VI01'',''113420860'',to_date(''26/12/11'',''DD/MM/RR''),''01'',''02'',''04'',null,''100'',''01'',''00'',''00487'',''00000'',''00000'',''00000'',''0'',''0'',''0'',''20060417'',''000000008442000'',''00011'',''02'',''000000000000000'',''000000000000000'',''S'',''20060417'',''8442000'',''00011'',''00'',''21000'',''00000000001752776689'',''2'',''00018'',''00000000'',null,null,to_date(''30/06/14'',''DD/MM/RR''),to_date(''31/10/12'',''DD/MM/RR''),''20121031'',''S'',''N'',''00000000'',to_date(''30/11/13'',''DD/MM/RR''),''00000000'',''00000000'',''23'',''447'',''1180'',''10'',null,''000111124437'',null,null,null,null,null,null,''0'',null,null,''07'',null,null,null,''00000000'',null,null,null,null,null,null,''00000000'',null,null,null,null,''000000000000000'',''000000000000000'',''1'',null,null,''00000000'',null,''00'',null,''77 2009'',null,null,null,null,''CIEZA 1'',null,null,null,''000000000000000'',''00000000'',null,''4'',''1'',null,null,null,''1'',''HOYO'',''10'',null,null,null,''30530'',''1'',''30'',''37967'',''1'',''300190000'',''2'',''0'',null,null,''7835906XH3373F0001KO'',''N'',''+'',''00000000000000000'',''+'',''00000000000000000'',''90'',null,''134'',''3'',''1'',''N'',null,''N'',''N'',''N'',null,null,''05'',''1900'',null,null,null,null,null,null,null,''00000000'',''1'',''S'',null,''F'',to_date(''06/06/14'',''DD/MM/RR''),null,to_date(''06/06/24'',''DD/MM/RR''),null,null,''0'',null,null,null,null,null,null,null,''35465,66'',''20180317'',null,''20180319'',''000000003285055'',''000000000135056'',''000000000000000'',''000000000000000'',''35000'',to_date(''18/10/18'',''DD/MM/RR''),null,''186'',''0'',null,''0'',null,''75156232'',''0'',''0'',''0'',''0'',''0'',''0'',''1'',''9'',null,SYSDATE,null)';
EXECUTE IMMEDIATE V_MSQL;


COMMIT;

  
  DBMS_OUTPUT.PUT_LINE('INSERTADOS '||SQL%ROWCOUNT||' REGISTROS EN LA TABLA '||V_TEXT_TABLA||'');


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
