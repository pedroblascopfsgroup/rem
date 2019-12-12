--/*
--##########################################
--## AUTOR=Oscar Diestre Pérez
--## FECHA_CREACION=20191125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5790
--## PRODUCTO=NO
--##
--## Finalidad: Dejar a nulo GIC_GASTOS_INFO_CONTABILIDAD.GIC_CUENTA_CONTABLE
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
    V_USUARIOMODIFICAR VARCHAR2(25 CHAR):= 'REMVIP-5790'; -- Configuracion Esquema

BEGIN	        

    DBMS_OUTPUT.PUT_LINE('[INICIO] ');


    DBMS_OUTPUT.PUT_LINE('[INFO]: Dejar nulo la cuenta contable' );

    V_MSQL := '	MERGE INTO '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC
		USING (

			select  
			GIC.GIC_ID
			from '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR gpv
			join '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO tga on tga.dd_tga_id = gpv.dd_tga_id
			join '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO pro on pro.pro_id = gpv.pro_id
			join '||V_ESQUEMA||'.dd_cra_cartera cra on cra.dd_cra_id = pro.dd_cra_id
			join '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD gic on gic.gpv_id = gpv.gpv_id
			join '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR pve on pve.pve_id = gpv.PVE_ID_GESTORIA
			join '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO ega on ega.dd_ega_id = gpv.dd_ega_id
			join '||V_ESQUEMA||'.GGE_GASTOS_GESTION gge on gge.gpv_id = gpv.gpv_id
			join '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA eah on eah.dd_eah_id = gge.dd_eah_id
			join '||V_ESQUEMA||'.DD_EAP_ESTADOS_AUTORIZ_PROP eap on eap.dd_eap_id = gge.dd_eap_id
			where tga.dd_tga_descripcion = ''Comunidad de propietarios'' 
			and cra.dd_cra_descripcion = ''Liberbank''
			and gpv.dd_stg_id in (26,27)
			AND GIC.GIC_CUENTA_CONTABLE IS NOT NULL      

		      ) AUX
			ON ( GIC.GIC_ID = AUX.GIC_ID )
			WHEN MATCHED THEN UPDATE SET
 
			    GIC_CUENTA_CONTABLE = NULL,
			    USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
			    FECHAMODIFICAR = SYSDATE

		';

	EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: Modificados ' || SQL%ROWCOUNT || ' registros de GIC_GASTOS_INFO_CONTABILIDAD ' );

--*******************************************************************************************************************************

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: GASTOS MODIFICADOS CORRECTAMENTE ');


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
