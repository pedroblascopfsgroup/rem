--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20211214
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10833
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el pve_cod_rem como nextval a partir del ultimo
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
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-10907';
    V_TABLA VARCHAR2(50 CHAR) := 'ACT_PVE_PROVEEDOR';


    
BEGIN   
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    DBMS_OUTPUT.PUT_LINE('[INFO]: Inicio Actualizacion proveedores en '||V_TABLA||'');


    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.clc_cliente_comercial T1
                USING (
                    SELECT DISTINCT CLC.CLC_ID,aux.id_persona_haya_caixa FROM REM01.clc_cliente_comercial CLC
                    JOIN REM01.aux_remvip_10907 AUX ON aux.id_persona_haya_bankia=clc.clc_id_persona_haya_caixa
                    WHERE aux.id_persona_haya_caixa IS NOT NULL AND CLC.BORRADO = 0

                ) T2
                ON (T1.CLC_ID = T2.CLC_ID)
                WHEN MATCHED THEN
                UPDATE SET 
                    T1.clc_id_persona_haya_caixa = T2.id_persona_haya_caixa,
                    T1.FECHAMODIFICAR = SYSDATE,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||'''	 		
                ';
		
	EXECUTE IMMEDIATE V_MSQL;  

    DBMS_OUTPUT.PUT_LINE('[INFO]: clc_cliente_comercial '|| SQL%ROWCOUNT ||' IDS actualizados  ');


        V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.clc_cliente_comercial T1
                USING (
SELECT DISTINCT CLC.CLC_ID,aux.id_persona_haya_caixa FROM REM01.clc_cliente_comercial CLC
JOIN REM01.aux_remvip_10907 AUX ON aux.id_persona_haya_bankia=clc.clc_id_persona_haya_caixa_repr
WHERE aux.id_persona_haya_caixa IS NOT NULL AND CLC.BORRADO = 0

                ) T2
                ON (T1.CLC_ID = T2.CLC_ID)
                WHEN MATCHED THEN
                UPDATE SET 
                    T1.clc_id_persona_haya_caixa_repr = T2.id_persona_haya_caixa,
                    T1.FECHAMODIFICAR = SYSDATE,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||'''	 		
                ';
		
	EXECUTE IMMEDIATE V_MSQL;  

    DBMS_OUTPUT.PUT_LINE('[INFO]:  clc_cliente_comercial REPRESENTANTE '|| SQL%ROWCOUNT ||' IDS actualizados  ');


            V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.OFR_TIA_TITULARES_ADICIONALES T1
                USING (
SELECT DISTINCT TIA.TIA_ID,AUX.id_persona_haya_caixa FROM REM01.OFR_TIA_TITULARES_ADICIONALES TIA
JOIN REM01.aux_remvip_10907 AUX ON aux.id_persona_haya_bankia=tia.tia_id_persona_haya_caixa
WHERE aux.id_persona_haya_caixa IS NOT NULL AND TIA.BORRADO = 0

                ) T2
                ON (T1.TIA_ID = T2.TIA_ID)
                WHEN MATCHED THEN
                UPDATE SET 
                    T1.tia_id_persona_haya_caixa = T2.id_persona_haya_caixa,
                    T1.FECHAMODIFICAR = SYSDATE,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||'''	 		
                ';
		
	EXECUTE IMMEDIATE V_MSQL;  

    DBMS_OUTPUT.PUT_LINE('[INFO]: OFR_TIA_TITULARES_ADICIONALES '|| SQL%ROWCOUNT ||' IDS actualizados  ');


            V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.OFR_TIA_TITULARES_ADICIONALES T1
                USING (
SELECT DISTINCT TIA.TIA_ID,AUX.id_persona_haya_caixa FROM REM01.OFR_TIA_TITULARES_ADICIONALES TIA
JOIN REM01.aux_remvip_10907 AUX ON aux.id_persona_haya_bankia=tia.tia_id_persona_haya_caixa_REPR
WHERE aux.id_persona_haya_caixa IS NOT NULL AND TIA.BORRADO = 0

                ) T2
                ON (T1.TIA_ID = T2.TIA_ID)
                WHEN MATCHED THEN
                UPDATE SET 
                    T1.tia_id_persona_haya_caixa_REPR = T2.id_persona_haya_caixa,
                    T1.FECHAMODIFICAR = SYSDATE,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||'''	 		
                ';
		
	EXECUTE IMMEDIATE V_MSQL;  

    DBMS_OUTPUT.PUT_LINE('[INFO]: OFR_TIA_TITULARES_ADICIONALES REPRESENTANTE '|| SQL%ROWCOUNT ||' IDS actualizados  ');


                V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ioc_interlocutor_pbc_caixa T1
                USING (
SELECT DISTINCT IOC.IOC_ID,AUX.id_persona_haya_caixa FROM REM01.ioc_interlocutor_pbc_caixa IOC
JOIN REM01.aux_remvip_10907 AUX ON aux.id_persona_haya_bankia=ioc.ioc_id_persona_haya_caixa
WHERE aux.id_persona_haya_caixa IS NOT NULL AND IOC.BORRADO = 0

                ) T2
                ON (T1.IOC_ID = T2.IOC_ID)
                WHEN MATCHED THEN
                UPDATE SET 
                    T1.ioc_id_persona_haya_caixa = T2.id_persona_haya_caixa,
                    T1.FECHAMODIFICAR = SYSDATE,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||'''	 		
                ';
		
	EXECUTE IMMEDIATE V_MSQL;  

    DBMS_OUTPUT.PUT_LINE('[INFO]: ioc_interlocutor_pbc_caixa '|| SQL%ROWCOUNT ||' IDS actualizados  ');


                    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.COM_COMPRADOR T1
                USING (
SELECT DISTINCT COM.COM_ID,AUX.id_persona_haya_caixa FROM REM01.COM_COMPRADOR COM
JOIN REM01.aux_remvip_10907 AUX ON aux.id_persona_haya_bankia=com.com_id_persona_haya_caixa
WHERE aux.id_persona_haya_caixa IS NOT NULL AND COM.BORRADO = 0

                ) T2
                ON (T1.COM_ID = T2.COM_ID)
                WHEN MATCHED THEN
                UPDATE SET 
                    T1.com_id_persona_haya_caixa = T2.id_persona_haya_caixa,
                    T1.FECHAMODIFICAR = SYSDATE,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||'''	 		
                ';
		
	EXECUTE IMMEDIATE V_MSQL;  

    DBMS_OUTPUT.PUT_LINE('[INFO]: COM_COMPRADOR '|| SQL%ROWCOUNT ||' IDS actualizados  ');

            V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE T1
                USING (
SELECT DISTINCT CEX.COM_ID,CEX.ECO_ID,AUX.id_persona_haya_caixa FROM REM01.CEX_COMPRADOR_EXPEDIENTE CEX
JOIN REM01.aux_remvip_10907 AUX ON aux.id_persona_haya_bankia=cex.cex_id_persona_haya_caixa_repr
WHERE aux.id_persona_haya_caixa IS NOT NULL AND CEX.BORRADO = 0

                ) T2
                ON (T1.COM_ID = T2.COM_ID AND T1.ECO_ID=T2.ECO_ID)
                WHEN MATCHED THEN
                UPDATE SET 
                    T1.cex_id_persona_haya_caixa_repr = T2.id_persona_haya_caixa,
                    T1.FECHAMODIFICAR = SYSDATE,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||'''	 		
                ';
		
	EXECUTE IMMEDIATE V_MSQL;  

    DBMS_OUTPUT.PUT_LINE('[INFO]: CEX_COMPRADOR_EXPEDIENTE '|| SQL%ROWCOUNT ||' IDS actualizados  ');

                V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.iap_info_adc_persona T1
                USING (
SELECT DISTINCT IAP.IAP_ID,AUX.id_persona_haya_caixa FROM REM01.iap_info_adc_persona IAP
JOIN REM01.aux_remvip_10907 AUX ON aux.id_persona_haya_bankia=iap.iap_id_persona_haya_caixa
WHERE aux.id_persona_haya_caixa IS NOT NULL AND IAP.BORRADO = 0

                ) T2
                ON (T1.IAP_ID = T2.IAP_ID)
                WHEN MATCHED THEN
                UPDATE SET 
                    T1.iap_id_persona_haya_caixa = T2.id_persona_haya_caixa,
                    T1.FECHAMODIFICAR = SYSDATE,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||'''	 		
                ';
		
	EXECUTE IMMEDIATE V_MSQL;  

    DBMS_OUTPUT.PUT_LINE('[INFO]: iap_info_adc_persona '|| SQL%ROWCOUNT ||' IDS actualizados  ');
        
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TABLA||' ACTUALIZADA ');
   
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
