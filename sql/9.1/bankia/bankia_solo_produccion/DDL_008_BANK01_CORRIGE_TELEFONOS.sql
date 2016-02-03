--/*
--##########################################
--## AUTOR=David González
--## FECHA_CREACION=20151118
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=BKREC-1403
--## PRODUCTO=NO
--## 
--## Finalidad: Corregir teléfonos obsoletos en la tabla BANK01.TEL_PER,
--## 			actualizando el campo BORRADO = 1 en función del fichero de aprovisionamiento de bk
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

V_ESQUEMA VARCHAR2(6 CHAR) := 'BANK01';
V_SENTENCIA VARCHAR2(1600 CHAR);
V_NUM NUMBER(9,0);

BEGIN
	--------------------------
	-- ## BANK01.TEL_PER ## --
	--------------------------

		DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del script de actualización de teléfonos');
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Buscando teléfonos obsoletos');

V_SENTENCIA := 'WITH 
                APR AS (
                SELECT TEL_ID,PER_ID FROM '||V_ESQUEMA||'.TEL_PER WHERE BORRADO = 0
                MINUS
                SELECT TEL.TEL_ID, PER.PER_ID FROM '||V_ESQUEMA||'.APR_AUX_TEL_TELEFONOS AUX 
                JOIN '||V_ESQUEMA||'.TEL_TELEFONOS TEL 
                  ON TEL.TEL_TELEFONO = AUX.ATT_TELEFONO 
                JOIN '||V_ESQUEMA||'.PER_PERSONAS PER 
                  ON PER.PER_COD_CLIENTE_ENTIDAD = AUX.ATT_CODIGO_PERSONA),
                BORRAR AS (
                SELECT TLP.TEL_PER_ID FROM '||V_ESQUEMA||'.TEL_PER TLP 
                JOIN APR 
                  ON TLP.TEL_ID = APR.TEL_ID 
                    AND TLP.PER_ID = APR.PER_ID)
                SELECT COUNT(1) FROM BORRAR';
                
EXECUTE IMMEDIATE V_SENTENCIA INTO V_NUM;

IF V_NUM > 0 THEN

		DBMS_OUTPUT.PUT_LINE('[INFO] Se han encontrado '||V_NUM||' teléfonos obsoletos');
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Creando tabla temporal TMP_ACT_ACTUALIZA_TELEFONOS...');
		
		V_SENTENCIA := 'CREATE TABLE TMP_ACT_ACTUALIZA_TELEFONOS (TEL_PER_ID_BORRAR NUMBER(16,0))';
    
		EXECUTE IMMEDIATE V_SENTENCIA;
    
    COMMIT;

		DBMS_OUTPUT.PUT_LINE('[INFO] Rellenando tabla temporal TMP_ACT_ACTUALIZA_TELEFONOS...');

		V_SENTENCIA := 'INSERT INTO TMP_ACT_ACTUALIZA_TELEFONOS (TEL_PER_ID_BORRAR)
						WITH 
						APR AS (
						SELECT TEL_ID,PER_ID FROM '||V_ESQUEMA||'.TEL_PER WHERE BORRADO = 0
						MINUS
						SELECT TEL.TEL_ID, PER.PER_ID FROM '||V_ESQUEMA||'.APR_AUX_TEL_TELEFONOS AUX 
						JOIN '||V_ESQUEMA||'.TEL_TELEFONOS TEL 
						  ON TEL.TEL_TELEFONO = AUX.ATT_TELEFONO 
						JOIN '||V_ESQUEMA||'.PER_PERSONAS PER 
						  ON PER.PER_COD_CLIENTE_ENTIDAD = AUX.ATT_CODIGO_PERSONA),
						BORRAR AS (
						SELECT TLP.TEL_PER_ID FROM '||V_ESQUEMA||'.TEL_PER TLP 
						JOIN APR 
						  ON TLP.TEL_ID = APR.TEL_ID 
							AND TLP.PER_ID = APR.PER_ID)
						SELECT TEL_PER_ID FROM BORRAR';
						
		EXECUTE IMMEDIATE V_SENTENCIA;
    
    COMMIT;
    
		V_SENTENCIA := 'ANALYZE TABLE TMP_ACT_ACTUALIZA_TELEFONOS COMPUTE STATISTICS';
						
		EXECUTE IMMEDIATE V_SENTENCIA;
    
    COMMIT;

		V_SENTENCIA := 'SELECT COUNT(1) FROM TMP_ACT_ACTUALIZA_TELEFONOS';

		EXECUTE IMMEDIATE V_SENTENCIA INTO V_NUM;

		DBMS_OUTPUT.PUT_LINE('[INFO] Se va a proceder al borrado lógico de '||V_NUM||' teléfonos');
						
		DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando teléfonos...');

		V_SENTENCIA := 'UPDATE '||V_ESQUEMA||'.TEL_PER SET BORRADO = 1, FECHAMODIFICAR = SYSDATE, USUARIOMODIFICAR = ''BKREC-1403'' WHERE TEL_PER_ID IN (SELECT TEL_PER_ID_BORRAR FROM TMP_ACT_ACTUALIZA_TELEFONOS)';

		EXECUTE IMMEDIATE V_SENTENCIA;
    
    COMMIT;

		DBMS_OUTPUT.PUT_LINE('[INFO] ¡Teléfonos actualizados!');

		DBMS_OUTPUT.PUT_LINE('[INFO] Borrando tabla temporal TMP_ACT_ACTUALIZA_TELEFONOS...');
    
		V_SENTENCIA := 'DROP TABLE TMP_ACT_ACTUALIZA_TELEFONOS PURGE';
		
		EXECUTE IMMEDIATE V_SENTENCIA;
    
    COMMIT;

		DBMS_OUTPUT.PUT_LINE('[FIN] Script finalizado');

ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] No se han encontrado teléfonos obsoletos');
		
END IF;
		
EXCEPTION
				WHEN OTHERS THEN

				  DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(SQLCODE));
				  DBMS_OUTPUT.put_line('-----------------------------------------------------------');
				  DBMS_OUTPUT.put_line(SQLERRM);

				  ROLLBACK;
				  RAISE;

END;
/
EXIT;

