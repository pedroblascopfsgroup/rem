--/*
--#########################################
--## AUTOR=Pau Serrano
--## FECHA_CREACION=20171220
--## ARTEFACTO=
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3484
--## PRODUCTO=NO
--## 
--## Finalidad: Migración. Actualizar fechas de sanción de los ECO  que coinciden con los numeros de ofertas insertados en AUX_HREOS_3484
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA_PFS VARCHAR2(25 CHAR):= 'PFSREM'; -- Esquema de aux_hreos_3484
  V_ESQUEMA_REM VARCHAR2(25 CHAR):= 'REM01'; -- Esquema de Eco_expediente_comercial
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

  V_NUM NUMBER(25);-- Contador de updates
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] Updates del campo FECHA_SANCION de ECO_EXPEDIENTE_COMERCIAL');

 DBMS_OUTPUT.PUT_LINE('[INFO] Realizamos updates de la cartera de SAREB (02).');

 V_MSQL := '
    merge into '||V_ESQUEMA_REM||'.eco_expediente_comercial eco
    using (
        select 
          aux.fecha_sancion as fecha_act
          , ofr.ofr_id as ofr_id
        from '||V_ESQUEMA_PFS||'.Aux_Hreos_3484 aux
          join '||V_ESQUEMA_REM||'.Ofr_Ofertas ofr on aux.NUMERO_OFERTA = ofr.OFR_NUM_OFERTA  
          join '||V_ESQUEMA_REM||'.Eco_Expediente_Comercial eco on ofr.ofr_id = eco.ofr_id
        where Aux.CARTERA = ''02'' /*SAREB*/
        ) act
    on (eco.ofr_id = act.ofr_id)
    when matched then update
      set Eco.Eco_Fecha_Sancion = act.fecha_act
          , eco.USUARIOMODIFICAR = ''HREOS-3484''
          , eco.FECHAMODIFICAR = sysdate
    ';
 
 EXECUTE IMMEDIATE V_MSQL;
 DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' campos');
 V_NUM := SQL%ROWCOUNT;
 
 DBMS_OUTPUT.PUT_LINE('[INFO] Realizamos updates de la cartera de CAJAMAR (01).');

 V_MSQL := '
    merge into '||V_ESQUEMA_REM||'.eco_expediente_comercial eco
    using (
        select 
          aux.fecha_sancion as fecha_act
          , ofr.ofr_id as ofr_id
        from '||V_ESQUEMA_PFS||'.Aux_Hreos_3484 aux
          join '||V_ESQUEMA_REM||'.Ofr_Ofertas ofr on aux.NUMERO_OFERTA = ofr.OFR_NUM_OFERTA  
          join '||V_ESQUEMA_REM||'.Eco_Expediente_Comercial eco on ofr.ofr_id = eco.ofr_id
        where Aux.CARTERA = ''01'' /*CAJAMAR*/
        ) act
    on (eco.ofr_id = act.ofr_id)
    when matched then update
      set Eco.Eco_Fecha_Sancion = act.fecha_act
          , eco.USUARIOMODIFICAR = ''HREOS-3484''
          , eco.FECHAMODIFICAR = sysdate
    ';
 
 EXECUTE IMMEDIATE V_MSQL;
 DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' campos');
 V_NUM := V_NUM + SQL%ROWCOUNT;

 DBMS_OUTPUT.PUT_LINE('[INFO] Realizamos updates de la cartera de BANKIA (03).');

 V_MSQL := '
    merge into '||V_ESQUEMA_REM||'.eco_expediente_comercial eco
    using (
        select 
          aux.fecha_sancion as fecha_act
          , ofr.ofr_id as ofr_id
        from '||V_ESQUEMA_PFS||'.Aux_Hreos_3484 aux
          join '||V_ESQUEMA_REM||'.Ofr_Ofertas ofr on aux.NUMERO_OFERTA = ofr.OFR_NUM_OFERTA  
          join '||V_ESQUEMA_REM||'.Eco_Expediente_Comercial eco on ofr.ofr_id = eco.ofr_id
        where Aux.CARTERA = ''03'' /*BANKIA*/
        ) act
    on (eco.ofr_id = act.ofr_id)
    when matched then update
      set Eco.Eco_Fecha_Sancion = act.fecha_act
          , eco.USUARIOMODIFICAR = ''HREOS-3484''
          , eco.FECHAMODIFICAR = sysdate
    ';
 
 EXECUTE IMMEDIATE V_MSQL;
 DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' campos');
 V_NUM := V_NUM + SQL%ROWCOUNT;
  
 DBMS_OUTPUT.PUT_LINE('[FIN] Se han actualizado un total de '||V_NUM||' registros.');

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
