--/*
--#########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20220214
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## ARTEFACTO=batch
--## INCIDENCIA_LINK=HREOS-15592
--## PRODUCTO=NO
--## 
--## Finalidad:
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

	V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
	V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-16329';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);
	V_SENTENCIA VARCHAR2(4000 CHAR);
	TABLE_COUNT NUMBER(10,0) := 0;
	
	V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
	V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_ACTIVO';
	V_TABLA VARCHAR2(40 CHAR) := 'ACT_AOB_ACTIVO_OBS';
  V_TABLA_AUX_MIG VARCHAR2 (30 CHAR) := 'AUX_SEGUIR_MIGRACION';

DECLARE
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'HREOS-16329';
    V_COUNT NUMBER(16):= 0;
    
    CURSOR RECALCULAR_RATING IS 
        SELECT ACT.ACT_ID
        FROM REM01.AUX_ACT_TRASPASO_ACTIVO AUX
        JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT;

    FILA RECALCULAR_RATING%ROWTYPE;
   
BEGIN
    DBMS_OUTPUT.put_line('[INICIO]');
      
    OPEN RECALCULAR_RATING;
    
    V_COUNT := 0;
    
    LOOP
        FETCH RECALCULAR_RATING INTO FILA;
        EXIT WHEN RECALCULAR_RATING%NOTFOUND;
        
        REM01.SP_CAMBIO_ESTADO_PUBLICACION (FILA.ACT_ID, 1 , ''||V_USUARIOMODIFICAR||'');
            
        V_COUNT := V_COUNT + 1;
    END LOOP;
     
    DBMS_OUTPUT.PUT_LINE('  [INFO] Se ha recalculado el rating para '||V_COUNT||' de Cajamar');
    CLOSE RECALCULAR_RATING;
     
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');
 
EXCEPTION
    WHEN OTHERS THEN
         ERR_NUM := SQLCODE;
         ERR_MSG := SQLERRM;
         DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
         DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
         DBMS_OUTPUT.put_line(ERR_MSG);
         ROLLBACK;
         RAISE;   
END;
