--/*
--##########################################
--## AUTOR=David González
--## FECHA_CREACION=20151221
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=BKREC-1197
--## PRODUCTO=NO
--## 
--## Finalidad: En un caso de asuntos sin demandados,
--## 			añadimos su registro en PRC_PER.
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

V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
V_TABLA VARCHAR2(30 CHAR);
V_TABLA_ASU VARCHAR2(20 CHAR):= 'ASU_ASUNTOS';
V_TABLA_CPE VARCHAR2(30 CHAR):= 'CPE_CONTRATOS_PERSONAS';
V_TABLA_CEX VARCHAR2(30 CHAR):= 'CEX_CONTRATOS_EXPEDIENTE';
V_SENTENCIA VARCHAR2(1600 CHAR);
V_NUM NUMBER(2,0);
PRC_ID NUMBER(16,0);
PER_ID NUMBER(16,0);

BEGIN

		--BUSCAMOS EL ASUNTO

		DBMS_OUTPUT.PUT_LINE('[INICIO] Buscando el asunto a tratar...');
		
		V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ASU||' WHERE ASU_NOMBRE LIKE (''%1143583%'')';
        EXECUTE IMMEDIATE V_SENTENCIA INTO V_NUM;
		
		IF V_NUM > 0 THEN 
		
			DBMS_OUTPUT.PUT_LINE('[INFO] El asunto ya existe, buscando el procedimiento asociado...');
			
			--AVANZAMOS PARA BUSCAR EL PRC_ID Y EL PER_ID
			--BUSCAMOS EL PRC_ID
			
			V_TABLA := 'PRC_PROCEDIMIENTOS';
			
			V_SENTENCIA := 'SELECT PRC_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ASU_ID = (
								SELECT ASU_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ASU||' WHERE ASU_NOMBRE LIKE (''%1143583%''))';
								
			EXECUTE IMMEDIATE V_SENTENCIA INTO PRC_ID;
			
			DBMS_OUTPUT.PUT_LINE('[INFO] Procedimiento hallado, buscando a la persona...');
			
			--BUSCAMOS EL PER_ID
						
			V_SENTENCIA := 'SELECT PER_ID FROM '||V_ESQUEMA||'.'||V_TABLA_CPE||' WHERE CNT_ID = (
								SELECT CNT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_CEX||' WHERE EXP_ID = (
									SELECT EXP_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ASU||' WHERE ASU_ID = (
										SELECT ASU_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ASU||' WHERE ASU_NOMBRE LIKE (''%1143583%''))))';
								
			EXECUTE IMMEDIATE V_SENTENCIA INTO PER_ID;
			
			--MIRAMOS SI EXISTEN REGISTROS PARA ESTE ASUNTO Y ESTA PERSONA EN LA TABLA PRC_PER
			
			V_TABLA := 'PRC_PER';
			
			DBMS_OUTPUT.PUT_LINE('[INFO] Persona hallada, buscando si existe registro en la tabla '||V_ESQUEMA||'.'||V_TABLA||' para el asunto a tratar...');
		
			V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PRC_ID = '||PRC_ID||'
																					AND PER_ID = '||PER_ID||'';
																					
			EXECUTE IMMEDIATE V_SENTENCIA INTO V_NUM;
			
			--SI EXISTEN REGISTROS, INFORMAMOS Y NO HACEMOS NADA
			
			IF V_NUM > 0 THEN
				
				DBMS_OUTPUT.PUT_LINE('[INFO] El asunto a tratar ya tiene registro en la tabla '||V_ESQUEMA||'.'||V_TABLA||'.');
				
			--SI NO EXISTEN REGISTROS, LO INSERTAMOS
				
			ELSE
			
				DBMS_OUTPUT.PUT_LINE('[INFO] Insertando el nuevo registro en la tabla '||V_ESQUEMA||'.'||V_TABLA||'...');
							
				V_SENTENCIA := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (PRC_ID, PER_ID, VERSION)
								VALUES (
								'||PRC_ID||',
								'||PER_ID||',
								0
								)';
								
				EXECUTE IMMEDIATE V_SENTENCIA;
				
				COMMIT;
				
			END IF;
			
		--SI LA BÚSQUEDA DEL ASUNTO A TRAVÉS DE EL NOMBRE NO NOS DEVUELVE NADA, ABORTAMOS EL PROCESO
							
		ELSE

				DBMS_OUTPUT.PUT_LINE('[INFO] No existe un asunto con ese identificador.');
				
		END IF;

				DBMS_OUTPUT.PUT_LINE('[FIN] Script finalizado');
				
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
