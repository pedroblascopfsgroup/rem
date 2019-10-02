--/*
--##########################################
--## AUTOR=ALBERT PASTOR
--## FECHA_CREACION=20190716
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6985
--## PRODUCTO=NO
--##
--## Finalidad: Creamos las secuencias de las secuencias temporales para el cálculo de comisiones
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_NUM NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('S_TMP_TRC_TRAMO_COMISION'),
      T_TIPO_DATA('S_TMP_OTC_OFERTA_TRAMO_COMISION')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
 BEGIN 
	
   FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

      V_TMP_TIPO_DATA := V_TIPO_DATA(I);

    DBMS_OUTPUT.PUT_LINE('******** '||TRIM(V_TMP_TIPO_DATA(1))||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||TRIM(V_TMP_TIPO_DATA(1))||'... Comprobaciones previas'); 
    
    -- Comprobamos si existe la secuencia   
    V_SQL := 'SELECT COUNT(1) FROM sys.all_sequences WHERE SEQUENCE_NAME = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    -- Si existe la secuencia 
    IF V_NUM > 0 THEN 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||TRIM(V_TMP_TIPO_DATA(1))||'... secuencia existente');
  	
  	ELSE
  	
		DBMS_OUTPUT.PUT_LINE('[INICIO] ' || V_ESQUEMA || '.'||TRIM(V_TMP_TIPO_DATA(1))||'... Se va ha crear.');  		
		--Creamos la secuencia
		V_SQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.'||TRIM(V_TMP_TIPO_DATA(1))||'   
              MINVALUE 1 
              MAXVALUE 999999 
              INCREMENT BY 1 
              START WITH 1 
			';

		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||TRIM(V_TMP_TIPO_DATA(1))||'... secuencia creada');
		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||TRIM(V_TMP_TIPO_DATA(1))||'... OK');
  		
    END IF;    
END LOOP;

COMMIT;

DBMS_OUTPUT.PUT_LINE('[INFO] Proceso terminado.');
 
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
EXIT;
