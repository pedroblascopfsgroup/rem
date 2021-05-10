--/*
--##########################################
--## AUTOR=Pedro Blasco
--## FECHA_CREACION=20210416
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10454
--## PRODUCTO=NO
--## Finalidad: Limpieza de datos de tablas RST
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
SET TIMING ON
SET LINESIZE 1000

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejECVtar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion 
    
    S_ORIGINAL VARCHAR2(30 CHAR) := ''; 
    S_COPIA VARCHAR2(30 CHAR) := '_COPIA'; 
    S_ARCHIVADA VARCHAR2(30 CHAR) := '_ARCHIVADA'; 

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
 	FECHA_LIMITE VARCHAR2(25) := '14/04/2021';

    PROCEDURE PROCESAR_TABLA (V_PREFIJO VARCHAR2)
     IS
	    V_ORIGINAL VARCHAR2(30 CHAR); 
	    V_COPIA VARCHAR2(30 CHAR); 
	    V_ARCHIVADA VARCHAR2(30 CHAR); 
	    PROCEDURE EJECUTAR_FASE(V_PREFIJO VARCHAR2, V_NUM_FASE VARCHAR2, V_DES_FASE VARCHAR2, V_MSQL VARCHAR2)
	    IS
		    T1 TIMESTAMP; 
		 	T2 TIMESTAMP; 
	    BEGIN
			T1 := SYSTIMESTAMP; 
			DBMS_OUTPUT.PUT_LINE('Procesando ' ||V_PREFIJO|| ' Fase ' || V_NUM_FASE || ': ' || V_DES_FASE || ' - Inicio: ' || T1); 
			DBMS_OUTPUT.PUT_LINE('--- ' || V_MSQL);
			EXECUTE IMMEDIATE V_MSQL;
			T2 := SYSTIMESTAMP;
			DBMS_OUTPUT.PUT_LINE('------Fin Fase ' || V_NUM_FASE || ': '||T2|| '. Ha empleado ' || TO_CHAR(T2-T1, 'SSSS') || ' segundos.'); 
		EXCEPTION 
			WHEN OTHERS THEN
				IF V_NUM_FASE IN ('1','2','3') THEN
					RAISE_APPLICATION_ERROR(-20000,SQLCODE || '-' ||SQLERRM);
		      	ELSE
		      		DBMS_OUTPUT.put_line('......[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE)||' '||SQLERRM);
				END IF;
	    END;
     BEGIN
		V_ORIGINAL := V_PREFIJO || S_ORIGINAL;
		V_COPIA := V_PREFIJO || S_COPIA;
		V_ARCHIVADA := V_PREFIJO || S_ARCHIVADA;

		V_MSQL := 'CREATE TABLE ' || V_COPIA || ' AS SELECT * FROM ' || V_ORIGINAL || q'[ WHERE FECHACREAR>=TO_DATE(']' || FECHA_LIMITE || q'[','dd/mm/yyyy')]';
		EJECUTAR_FASE(V_PREFIJO, '1', 'CTAS', V_MSQL);

		V_MSQL := 'RENAME ' || V_ORIGINAL || ' TO ' || V_ARCHIVADA;
		EJECUTAR_FASE(V_PREFIJO, '2', 'RENAME ORIGINAL A ARCHIVADA', V_MSQL);

		V_MSQL := 'RENAME ' || V_COPIA || ' TO ' || V_ORIGINAL;
		EJECUTAR_FASE(V_PREFIJO, '3', 'RENAME COPIA A ORIGINAL', V_MSQL);

		V_MSQL := 'ALTER TABLE '|| V_ARCHIVADA ||' DROP CONSTRAINT ' || V_ORIGINAL || '_PK';
		EJECUTAR_FASE(V_PREFIJO, '4.1', 'QUITAR CONSTRAINT PK', V_MSQL);

		V_MSQL := 'ALTER TABLE '|| V_ORIGINAL ||' ADD CONSTRAINT ' || V_ORIGINAL || '_PK PRIMARY KEY (' || V_PREFIJO || '_ID) ENABLE';
		EJECUTAR_FASE(V_PREFIJO, '4.2', 'AÑADIR CONSTRAINT PK', V_MSQL);

		V_MSQL := 'DROP INDEX '|| V_ORIGINAL ||'_IDX1';
		EJECUTAR_FASE(V_PREFIJO, '5.1', 'QUITAR INDICE _IDX1', V_MSQL);

		V_MSQL := 'CREATE INDEX '|| V_ORIGINAL ||'_IDX1 ON '|| V_ORIGINAL ||' (TRUNC(FECHACREAR)) TABLESPACE '||V_TABLESPACE_IDX||'';
		EJECUTAR_FASE(V_PREFIJO, '5.2', 'RECREAR INDICE _IDX1', V_MSQL);

		V_MSQL := 'ALTER TABLE '|| V_ORIGINAL ||' MODIFY (BORRADO DEFAULT 0)';
		EJECUTAR_FASE(V_PREFIJO, '6', 'DEFAULT BORRADO', V_MSQL);

		V_MSQL := 'ALTER TABLE '|| V_ORIGINAL ||' MODIFY (VERSION DEFAULT 0)';
		EJECUTAR_FASE(V_PREFIJO, '7', 'DEFAULT VERSION', V_MSQL);

		IF V_PREFIJO = 'RST_PETICION' THEN
			V_MSQL := 'ALTER TABLE '|| V_ARCHIVADA ||' DROP CONSTRAINT FK_RST_BROKER_ID';
			EJECUTAR_FASE(V_PREFIJO, '8.1', 'CONSTRAINT FK', V_MSQL);			
			V_MSQL := 'ALTER TABLE '|| V_ORIGINAL ||' ADD CONSTRAINT FK_RST_BROKER_ID FOREIGN KEY ("RST_BROKER_ID") REFERENCES "REM01"."RST_BROKER" ("RST_BROKER_ID")';
			EJECUTAR_FASE(V_PREFIJO, '8.2', 'CONSTRAINT FK', V_MSQL);			
			V_MSQL := 'COMMENT ON COLUMN '|| V_ORIGINAL || q'[.RST_PETICION_SIGNATURE IS 'Firma de la peticion']';
			EJECUTAR_FASE(V_PREFIJO, '9', 'COMMENT 1', V_MSQL);			
			V_MSQL := 'COMMENT ON COLUMN '|| V_ORIGINAL || q'[.RST_PETICION_RESPONSE IS 'Datos de la respuesta']';
			EJECUTAR_FASE(V_PREFIJO, '10', 'COMMENT 2', V_MSQL);			
			V_MSQL := 'COMMENT ON COLUMN '|| V_ORIGINAL || q'[.RST_PETICION_TIME IS 'Tiempo ejecucion']';
			EJECUTAR_FASE(V_PREFIJO, '11', 'COMMENT 3', V_MSQL);			
			V_MSQL := 'COMMENT ON TABLE '|| V_ORIGINAL || q'[ IS 'Tabla de gestión de los operadores de la rest api.']';
			EJECUTAR_FASE(V_PREFIJO, '13', 'COMMENT 4', V_MSQL);			
		ELSE
			V_MSQL := 'COMMENT ON COLUMN '|| V_ORIGINAL || q'[.RST_REFRESCO_TIME IS 'Tiempo refresco vista materiaqlizada']';
			EJECUTAR_FASE(V_PREFIJO, '8', 'COMMENT 1', V_MSQL);			
			V_MSQL := 'COMMENT ON TABLE '|| V_ORIGINAL || q'[ IS 'Registro de peticiones REST.']';
			EJECUTAR_FASE(V_PREFIJO, '9', 'COMMENT 2', V_MSQL);			
		END IF;

     END;

BEGIN
	
	PROCESAR_TABLA('RST_PETICION');
	DBMS_OUTPUT.PUT_LINE('*****************'); 
	PROCESAR_TABLA('RST_LLAMADA');

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

/

EXIT