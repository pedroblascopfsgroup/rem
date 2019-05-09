--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190511
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4214
--## PRODUCTO=NO
--##
--## Finalidad: corrección de cambio de proveedor
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
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-4214';    
    S_PVE NUMBER(16) := 0;  
   
   
    
    
BEGIN	
	
	V_MSQL := 'SELECT '||V_ESQUEMA||'.s_act_pve_proveedor.nextval FROM DUAL';
						-- DBMS_OUTPUT.PUT_LINE(V_MSQL);
						EXECUTE IMMEDIATE V_MSQL INTO S_PVE;
	
	EXECUTE IMMEDIATE V_MSQL INTO S_PVE;
	
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR (
					pve_id,
					dd_tpr_id,
					pve_cod_uvem,
					pve_nombre,
					pve_nombre_comercial,
					dd_tdi_id,
					pve_docidentif,
					dd_zng_id,
					dd_prv_id,
					dd_loc_id,
					pve_cp,
					pve_direccion,
					pve_telf1,
					pve_telf2,
					pve_fax,
					pve_email,
					pve_pagina_web,
					pve_franquicia,
					pve_iva_caja,
					pve_num_cuenta,
					version,
					usuariocrear,
					fechacrear,
					usuariomodificar,
					fechamodificar,
					usuarioborrar,
					fechaborrar,
					borrado,
					dd_tpc_id,
					dd_tpe_id,
					pve_nif,
					pve_fecha_alta,
					pve_fecha_baja,
					pve_localizada,
					dd_epr_id,
					pve_fecha_constitucion,
					pve_ambito,
					pve_observaciones,
					pve_homologado,
					dd_cpr_id,
					pve_top,
					pve_titular_cuenta,
					pve_retener,
					dd_mre_id,
					pve_fecha_retencion,
					pve_fecha_pbc,
					dd_rpb_id,
					pve_custodio,
					dd_tac_id,
					dd_ope_id,
					pve_criterio_caja_iva,
					pve_fecha_ejercicio_opcion,
					pve_cod_rem,
					pve_cod_api_proveedor,
					pve_autorizacion_web,
					dd_cpr_id_prop,
					pve_top_prop,
					pve_telf_contacto_vis,
					pve_webcom_id,
					pve_cod_prinex,
					pve_enviado
				) VALUES (
					'||S_PVE||',
					''21'',
					''30582810'',
					''CP POETA RAMON DE GARCIASOL 12'',
					''CP POETA RAMON DE GARCIASOL 12'',
					''2'',
					''H19107374'',
					NULL,
					''13'',
					''1934'',
					''12540'',
					''Jose Ramon Batalla,25'',
					''964523526'',
					NULL,
					''964523526'',
					NULL,
					NULL,
					''0'',
					''0'',
					''ES3900810668720001509660'',
					''2'',
					''REMVIP-4214'',
					SYSDATE,
					NULL,
					NULL,
					NULL,
					NULL,
					''0'',
					''3'',
					''102'',
					NULL,
					TO_DATE(''01/01/1999'',''DD/MM/YYYY''),
					NULL,
					''1'',
					''4'',
					NULL,
					NULL,
					NULL,
					''1'',
					NULL,
					''0'',
					''CP POETA RAMON DE GARCIASOL 12'',
					''0'',
					NULL,
					NULL,
					NULL,
					NULL,
					NULL,
					NULL,
					NULL,
					NULL,
					NULL,
					''20460'',
					''2810'',
					''0'',
					NULL,
					NULL,
					NULL,
					''20460'',
					''17790'',
					to_timestamp(''17/01/2019 20:57:30,000000000'',''DD/MM/YYYY HH24:MI:SSXFF''	)
				)';
	
    EXECUTE IMMEDIATE V_MSQL;
                    
    
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR SET 
					PVE_COD_PRINEX = NULL
				,	PVE_ENVIADO = NULL
				,	USUARIOMODIFICAR = ''REMVIP-4214''
				,	FECHAMODIFICAR = SYSDATE
				WHERE PVE_ID = 11603';
	
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('PVE_ID NUEVO : '||S_PVE);
	
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
