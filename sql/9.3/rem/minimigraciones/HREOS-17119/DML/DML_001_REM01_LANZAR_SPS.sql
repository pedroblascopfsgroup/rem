--/*
--#########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20221209
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## ARTEFACTO=batch
--## INCIDENCIA_LINK=HREOS-19071
--## PRODUCTO=NO
--## 
--## Finalidad:
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-17119] - Santi Monzó (20220214)
--##        0.2 Quitar el update de la situación comercial = null para los activos nuevos - [HREOS-19071] - Alejandra García (20221209)
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

	V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
	V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-17119';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);
	V_SENTENCIA VARCHAR2(4000 CHAR);
	TABLE_COUNT NUMBER(10,0) := 0;
	V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
	V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_ACTIVO';
  V_TABLA_AUX_MIG VARCHAR2 (30 CHAR) := 'AUX_SEGUIR_MIGRACION';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'HREOS-17293';
    V_COUNT NUMBER(16):= 0;

  CURSOR RECALCULAR_RATING IS 
        
        SELECT ACT.ACT_ID
          FROM REM01.AUX_ACT_TRASPASO_ACTIVO AUX
          JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT;

    FILA RECALCULAR_RATING%ROWTYPE;

BEGIN
  

DBMS_OUTPUT.PUT_LINE('[INFO] [INICIO]');
 
     V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_AUX_MIG||' WHERE SEGUIR_MIGRACION = 0';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 0  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA HAY ACTIVOS INSERTADOS EN ACT_ACTIVO DE LOS QUE SE QUIEREN INSERTAR');
        
    ELSE 

   EXECUTE IMMEDIATE ('
        UPDATE '||V_ESQUEMA||'.ACT_ACTIVO
            SET DD_SCM_ID = NULL
            WHERE ACT_ID IN (

            SELECT ACT.ACT_ID
            FROM '||V_ESQUEMA||'.AUX_ACT_TRASPASO_ACTIVO AUX
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT)
            '
  )
  ;
	COMMIT;
  DBMS_OUTPUT.PUT_LINE('[INFO] SE VA A EJECUTAR EL SP_ASC_ACT_SIT_COM_VACIOS_V2.');
    REM01.SP_ASC_ACT_SIT_COM_VACIOS_V2 (0);


  END IF;
  
  COMMIT;

   DBMS_OUTPUT.put_line('[INFO] SE VA A EJECUTAR EL SP_CAMBIO_ESTADO_PUBLICACION.');
     
    OPEN RECALCULAR_RATING;
    
    V_COUNT := 0;
    
    LOOP
        FETCH RECALCULAR_RATING INTO FILA;
        EXIT WHEN RECALCULAR_RATING%NOTFOUND;
        
        REM01.SP_CAMBIO_ESTADO_PUBLICACION (FILA.ACT_ID, 1 , ''||V_USUARIOMODIFICAR||'');
            
        V_COUNT := V_COUNT + 1;
    END LOOP;
     
    DBMS_OUTPUT.PUT_LINE('  [INFO] Se ha recalculado el rating para '||V_COUNT||' .');
    CLOSE RECALCULAR_RATING;
     
    COMMIT;

 DBMS_OUTPUT.PUT_LINE('[FIN]');
  
  
  
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
