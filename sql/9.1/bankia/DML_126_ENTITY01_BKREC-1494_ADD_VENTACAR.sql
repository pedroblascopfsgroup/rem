--/*
--##########################################
--## AUTOR=David González
--## FECHA_CREACION=20151127
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=BKREC-1494
--## PRODUCTO=NO
--## 
--## Finalidad: Añadimos motivo de finalización "VENTA DE CARTERA" en el
--## 			diccionario DD_DFI_DECISION_FINALIZAR del esquema ENTIDAD
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

V_ESQUEMA VARCHAR2(10 CHAR) := 'BANK01';
V_SENTENCIA VARCHAR2(1600 CHAR);
V_NUM NUMBER(2,0);

BEGIN
	--------------------------
	-- ## DD_DFI_DECISION_FINALIZAR ## --
	--------------------------

		DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del script de inserción de motivo de finalización');

V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR WHERE DD_DFI_DESCRIPCION = ''Venta de cartera''';
                
		EXECUTE IMMEDIATE V_SENTENCIA INTO V_NUM;

		IF V_NUM > 0 THEN
		
		DBMS_OUTPUT.PUT_LINE('[INFO] El motivo de finalización "Venta de cartera" ya existe');
		
ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] Insertando motivo de finalización...');

V_SENTENCIA := 'INSERT INTO '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR VALUES (
				'||V_ESQUEMA||'.S_DD_DFI_DECISION_FINALIZAR.NEXTVAL,
				''VENTACAR'',
				''Venta de cartera'',
				''Venta de cartera'',
				1,
				''DD'',
				SYSDATE,
				null,
				null,
				null,
				null,
				0
				)';
				
EXECUTE IMMEDIATE V_SENTENCIA;
    
COMMIT;

		DBMS_OUTPUT.PUT_LINE('[INFO] Motivo de finalización añadido');
		
END IF;

		DBMS_OUTPUT.PUT_LINE('[FIN] Script finalizado');
		
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

