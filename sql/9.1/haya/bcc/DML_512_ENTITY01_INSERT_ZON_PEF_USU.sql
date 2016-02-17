--/*
--##########################################
--## AUTOR=Jorge Ros
--## FECHA_CREACION=20160216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-671
--## PRODUCTO=NO
--##
--## Finalidad:
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_DDNAME VARCHAR2(30):= 'ZON_PEF_USU';
BEGIN	
	-- Inserccion del perfil a todos los usuarios de un despacho de tipo Letrado, donde el despacho haya sido alguna vez de tipo Integral
	-- Y tenga el perfil de procuradores PROCUCAJAMAR
	DBMS_OUTPUT.PUT_LINE('Insertando asociaciones en '||V_ESQUEMA||'.'||V_DDNAME||' para usuarios con perfil PROCUCAJAMAR');

	  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
	  '(ZPU_ID, ZON_ID,USU_ID, PEF_ID,VERSION, USUARIOCREAR, FECHACREAR, BORRADO) '||
	  'SELECT '||V_ESQUEMA||'.S_ZON_PEF_USU.nextval, zon.ZON_ID, zon.USU_ID, (select pef_id from '||V_ESQUEMA||'.pef_perfiles where pef_codigo=''PROCUINTEGRAL''), 0,''PRO-671'', sysdate, 0 ' ||
	  'FROM '||V_ESQUEMA||'.zon_pef_usu zon ' ||
	  'join '||V_ESQUEMA||'.pef_perfiles pef on zon.pef_id=pef.pef_id and pef.pef_codigo=''PROCUCAJAMAR'' ' ||
	  'join '||V_ESQUEMA||'.usd_usuarios_despachos usd on zon.usu_id=usd.usu_id ' ||
	  'join '||V_ESQUEMA||'.des_despacho_externo des on usd.des_id=des.des_id and des.dd_tde_id IN ' ||
	  '(select dd_tde_id from '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO where dd_tde_codigo=''1'' or dd_tde_codigo=''DLETR'' or dd_tde_codigo=''D-CJ-LETR'') ' ||
	  'where des.des_id IN (select des_id from '||V_ESQUEMA||'.DEC_DESPACHO_EXT_CONFIG where DEC_DESPACHO_INTEGRAL=1) and ' ||
	  'zon.zon_id not in (select zon.zon_id from '||V_ESQUEMA||'.zon_pef_usu zon join '||V_ESQUEMA||'.pef_perfiles pef on zon.pef_id=pef.pef_id and pef.pef_codigo=''PROCUINTEGRAL'') ' ||
	  'and zon.borrado=0 and pef.borrado=0 and usd.borrado=0 and des.borrado=0 ';
	
	  DBMS_OUTPUT.PUT_LINE('OK - FUNCION INSERTADA');

EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
    
END;
/

EXIT;
