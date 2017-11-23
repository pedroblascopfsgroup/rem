--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171123
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-3294
--## PRODUCTO=NO
--## 
--## Finalidad: cAÑONAZO
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

  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  ERR_NUM NUMBER;-- Numero de errores
  ERR_MSG VARCHAR2(2048);-- Mensaje de error

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Copiado de tablas MIGRACION CAJAMAR en REM.');

    EXECUTE IMMEDIATE 'MERGE INTO REM01.COM_COMPRADOR T1
		USING (select distinct com.com_id, clc.CLC_COD_CLIENTE_UVEM, row_number() over(partition by com.com_id order by clc.CLC_COD_CLIENTE_UVEM nulls last) rn
		from rem01.com_comprador com
		join rem01.mig2_clc_cliente_comercial clc on clc.clc_documento = com.com_documento
		join REM01.CEX_COMPRADOR_EXPEDIENTE cex on cex.com_id = com.com_id
		join REM01.ECO_EXPEDIENTE_COMERCIAL eco on eco.eco_id = cex.eco_id
		join REM01.OFR_OFERTAS ofr on ofr.ofr_id = eco.ofr_id
		join rem01.act_ofr actofr on actofr.ofr_id = ofr.ofr_id
		join rem01.act_activo act on act.act_id = actofr.act_id
		join rem01.dd_scr_subcartera scr on scr.dd_scr_id = act.dd_scr_id
		where com.id_comprador_ursus is null and clc.clc_cod_cliente_uvem is not null and clc.clc_cod_cliente_uvem <> 0 and scr.dd_scr_codigo <> '06') T2
		ON (T1.COM_ID = T2.COM_ID and t2.rn = 1)
		WHEN MATCHED THEN UPDATE SET
		T1.ID_COMPRADOR_URSUS = T2.CLC_COD_CLIENTE_UVEM, T1.USUARIOMODIFICAR = ''HREOS-3294'', T1.FECHAMODIFICAR = SYSDATE';

    DBMS_OUTPUT.PUT_LINE('[FIN] Copiado de tablas MIGRACION CAJAMAR en REM.');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT