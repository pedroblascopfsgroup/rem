--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200416
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-7030
--## PRODUCTO=NO
--## 
--## Finalidad: Carga masiva. Prescriptores Ofertas
--##                    
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Merge ofr_ofertas.PVE_ID_PRESCRIPTOR. Carga masiva.');

    
    execute immediate '
    MERGE INTO '||V_ESQUEMA||'.ofr_ofertas t1 USING (
	    select distinct
        ofr.ofr_id, pve.pve_id
        from '||V_ESQUEMA||'.aux_ofr_prescriptor_remvip_7030 aux
        inner join '||V_ESQUEMA||'.ofr_ofertas ofr on ofr.ofr_cod_divarian = aux.oferta
        left join '||V_ESQUEMA||'.act_pve_proveedor pve on pve.pve_cod_origen = aux.prescriptor
	) t2
	ON (t2.ofr_id = t1.ofr_id)
	WHEN MATCHED THEN UPDATE SET
	t1.PVE_ID_PRESCRIPTOR = t2.pve_id,
	t1.USUARIOMODIFICAR = ''REMVIP-7030'',
	t1.FECHAMODIFICAR = SYSDATE
    ';


    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. (Deberian de ser 12.180)');


    COMMIT;


    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
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
