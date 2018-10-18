--/*
--##########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20181019
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2291
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'GPL_GASTOS_PRINEX_LBK';
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-2291';    

    
BEGIN	
    
    
	V_SQL := 'update '||V_ESQUEMA||'.GPL_GASTOS_PRINEX_LBK set
				gpl_repercutir = null,
				USUARIOMODIFICAR = ''REMVIP2291'',
				FECHAMODIFICAR = SYSDATE
				where gpl_id in (
				select distinct gpl.gpl_id 
				from '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR gpv
				join '||V_ESQUEMA||'.GPL_GASTOS_PRINEX_LBK gpl on gpl.gpv_id = gpv.gpv_id
				where gpv.gpv_num_gasto_haya in (
				10077586,
				10077589,
				10077591,
				10077592,
				10077594,
				10077595,
				10077598,
				10077600,
				10077603,
				10077607,
				10060937,
				10060943,
				10060945,
				10060947,
				10060949,
				10060951,
				10060952,
				10060954,
				10060956,
				10060958,
				10060960,
				10060961,
				10060965,
				10060967,
				10060970,
				10060973,
				10060974,
				10060978,
				10060980,
				10067441,
				10067444
				))';
	 			  
        EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.put_line('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);


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

