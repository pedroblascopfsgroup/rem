--/*
--##########################################
--## AUTOR=Guillem Rey
--## FECHA_CREACION=20171128
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3263
--## PRODUCTO=NO
--##
--## Finalidad: Script que saca de perimetro los activos financieros que no estén en agrupacion asistida
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_PAC_PERIMETRO_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-3263';
    
    
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' PAC
						SET PAC.PAC_INCLUIDO = 0, USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE
						WHERE PAC.ACT_ID IN (SELECT PAC.ACT_ID FROM (SELECT ACT.* FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
						                                  LEFT JOIN (SELECT AGA.* FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA
						                                              INNER JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID
						                                              WHERE AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = ''13'') AND AGR.AGR_FIN_VIGENCIA>SYSDATE) AGA2 ON ACT.ACT_ID = AGA2.ACT_ID
						                                  WHERE AGA2.AGA_ID IS NULL) ACT
						INNER JOIN '||V_ESQUEMA||'.'||V_TEXT_TABLA||' PAC ON PAC.ACT_ID = ACT.ACT_ID
						INNER JOIN '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO ABA ON ABA.ACT_ID = ACT.ACT_ID
						WHERE PAC.PAC_INCLUIDO = 1 AND ABA.DD_CLA_ID = (SELECT DD_CLA_ID FROM '||V_ESQUEMA||'.DD_CLA_CLASE_ACTIVO WHERE DD_CLA_CODIGO = ''01''))';
						
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN] Activos financieros sin agrupación asistida sacados de perímetro');
	
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