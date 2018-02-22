--/*
--#########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20180222
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.14
--## INCIDENCIA_LINK=REMVIP-121-126
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##            
--## INSTRUCCIONES:  DML para borrar los OFR_TIA_TITULARES_ADICIONALES que tengan el mismo documento que CLC_CLIENTE_COMERCIAL 
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';             --REM01
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';   --REMMASTER
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-121-126';
    V_TABLA VARCHAR2(40 CHAR) := 'OFR_TIA_TITULARES_ADICIONALES';
    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_COUNT NUMBER(10) := 0;
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(250);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
BEGIN

   -----------------
    --   OFR_TIA_TITULARES_ADICIONALES   --
    -----------------   
    
    --** Comprobamos si existe la tabla   
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''OFR_TIA_TITULARES_ADICIONALES'' and owner = '''||v_esquema||'''';
    EXECUTE IMMEDIATE V_MSQL INTO v_num_tablas;
    -- Si existe comprobamos si existe la columna
    IF V_NUM_TABLAS = 1 THEN 
  			  
			--** Modificamos la tabla
		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.OFR_TIA_TITULARES_ADICIONALES TIA USING (
						select tia.TIA_ID from '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL clc, '||V_ESQUEMA||'.OFR_TIA_TITULARES_ADICIONALES tia, '||V_ESQUEMA||'.OFR_OFERTAS ofr
							where ofr.OFR_ID=tia.OFR_ID and clc.CLC_DOCUMENTO = tia.TIA_DOCUMENTO and ofr.CLC_ID = clc.CLC_ID 
               				and ofr.DD_EOF_ID=4 and tia.BORRADO = 0
						) AUX
						  ON (AUX.TIA_ID=tia.TIA_ID)
						  WHEN MATCHED THEN
							UPDATE SET 
							TIA.BORRADO = 1';								
								
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS EN OFR_TIA_TITULARES_ADICIONALES');
   END IF;
   
   DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.OFR_TIA_TITULARES_ADICIONALES... MERGE FIN');  
   COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT;
