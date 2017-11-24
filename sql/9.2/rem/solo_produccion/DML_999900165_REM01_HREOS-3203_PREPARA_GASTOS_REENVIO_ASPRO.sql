--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20171124
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3203
--## PRODUCTO=NO
--##
--## Finalidad: Script posiciona gastos en estado subsanado y los prepara para generar nuevas agrupaciones y enviarlos todos a ASPRO de nuevo
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
 
BEGIN   
 
DBMS_OUTPUT.PUT_LINE('[INICIO] PROCESO ACTUALIZACION CUENTAS CONTABLES'); 

-- ACTUALIZAMOS LA CUENTA CONTABLE
merge into rem01.gpv_gastos_proveedor GPV_OLD
USING (
select distinct gpv.gpv_id
FROM REM01.GPV_GASTOS_PROVEEDOR GPV 
   inner join REM01.GIC_GASTOS_INFO_CONTABILIDAD GIC on gpv.gpv_id = GIC.GPV_ID
   inner join rem01.prg_provision_gastos prg on prg.prg_id = gpv.prg_id
   join rem01.act_pve_proveedor pve on prg.pve_id_gestoria = pve.pve_id
         LEFT JOIN REM01.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ANYO = TO_CHAR(GPV.GPV_FECHA_EMISION,'YYYY')
   LEFT JOIN REM01.CCC_CONFIG_CTAS_CONTABLES CCC on GPV.DD_STG_ID = CCC.DD_STG_ID AND CCC.EJE_ID  = EJE.EJE_ID AND NVL(CCC.CCC_ARRENDAMIENTO,0) = 0
   LEFT JOIN REM01.CPP_CONFIG_PTDAS_PREP CPP on GPV.DD_STG_ID = CPP.DD_STG_ID AND CPP.EJE_ID  = EJE.EJE_ID AND NVL(CPP.CPP_ARRENDAMIENTO,0) = 0
        JOIN rem01.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
        JOIN rem01.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
        JOIN rem01.DD_EAH_ESTADOS_AUTORIZ_HAYA EAH ON GGE.DD_EAH_ID = EAH.DD_EAH_ID --AND EAH.DD_EAH_CODIGO = '03' 
    where 
          gic.GIC_CUENTA_CONTABLE is  not null
      and gpv.usuariocrear = 'gestoria_gastos_gr'
      and prg.dd_epr_id = (select dd_epr_id from rem01.dd_epr_estados_provision_gasto where dd_epr_codigo = '03')
      and dd_ega_id = (select dd_ega_id from rem01.dd_ega_estados_gasto where dd_ega_codigo = '08')
) GPV_NEW ON (GPV_OLD.GPV_ID = GPV_NEW.GPV_ID)
WHEN MATCHED THEN UPDATE SET
  GPV_OLD.DD_EGA_ID = (select dd_ega_id from rem01.dd_ega_estados_gasto where dd_ega_codigo = '10')
, GPV_OLD.PRG_ID = NULL
, GPV_OLD.USUARIOMODIFICAR = 'HREOS-3203'
, GPV_OLD.FECHAMODIFICAR = sysdate;


    dbms_output.put_line('Registros actualizados: '||sql%rowcount); 

    DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO POSICIONAMIENTO GASTOS ');

    DBMS_OUTPUT.PUT_LINE('[INICIO]: PROCESO BORRADO PROVISIONES VACIAS ');
    
COMMIT;    
    
-- ACTUALIZAMOS LA PARTIDA PRESUPUESTARIA
delete REM01.prg_provision_gastos prg
where not exists (select 1 from REM01.GPV_GASTOS_PROVEEDOR gpv where gpv.prg_id = prg.prg_ID)
and prg.usuariocrear = 'apr_main_ra_gastos_aspro';

    dbms_output.put_line('Registros borrados '||sql%rowcount); 
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO BORRADO PROVISIONES VACIAS');

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

EXIT;

    