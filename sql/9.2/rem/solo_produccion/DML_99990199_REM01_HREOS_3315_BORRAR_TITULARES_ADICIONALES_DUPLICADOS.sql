--/*
--#########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20171213
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3315
--## PRODUCTO=NO
--## 
--## Finalidad: CAÑONAZO
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
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] BORRADO LOGICO DE TITULARES_ADICIONALES CON DNI IGUAL EN CLC_CLIENTE.');
		
	EXECUTE IMMEDIATE 'MERGE INTO REM01.OFR_TIA_TITULARES_ADICIONALES T1
        USING (
            select distinct clc_documento from (
              SELECT 
              ofr.OFR_ID, clc.CLC_DOCUMENTO
              FROM REM01.OFR_OFERTAS ofr
              join rem01.clc_cliente_comercial clc on ofr.clc_id = clc.clc_id
              union all
              select tia.ofr_id, tia.TIA_DOCUMENTO 
              from REM01.OFR_TIA_TITULARES_ADICIONALES tia)
              group by ofr_id, clc_documento
              having count(*) > 1) T2
        ON (T1.TIA_DOCUMENTO = T2.clc_documento)
        WHEN MATCHED THEN UPDATE SET
            T1.BORRADO = 1, T1.USUARIOBORRAR= ''HREOS-3315'', T1.FECHABORRAR= SYSDATE';

    DBMS_OUTPUT.PUT_LINE('[FIN] BORRADO LOGICO.');
    
    COMMIT;

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