--/*
--##########################################
--## Author: Nacho
--## Finalidad: DML Inserción en DD_VIN_VALINSTRUCCIONES
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  
  V_ENTIDAD_ID NUMBER(16);
  --Insertando valores en DD_RCC_RES_COMITE_CONCURS
  TYPE T_TIPO_ACR1 IS TABLE OF VARCHAR2(2048);
  TYPE T_ARRAY_ACR1 IS TABLE OF T_TIPO_ACR1;
  V_TIPO_ACR1 T_ARRAY_ACR1 := T_ARRAY_ACR1(
    T_TIPO_ACR1('OPOSICION','Oposición','Oposición',0,'DD',sysdate,0),
    T_TIPO_ACR1('ALLANAPARCIAL','Allanamiento parcial','Allanamiento parcial',0,'DD',sysdate,0),
    T_TIPO_ACR1('ALLANATOTAL','Allanamiento total','Allanamiento total',0,'DD',sysdate,0)
  ); 
  V_TMP_TIPO_ACR1 T_TIPO_ACR1; 
  
  
BEGIN 
	DBMS_OUTPUT.PUT_LINE('******** DD_VIN_VALINSTRUCCIONES ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_VIN_VALINSTRUCCIONES... Comprobaciones previas'); 

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_VIN_VALINSTRUCCIONES';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe registros
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.DD_VIN_VALINSTRUCCIONES...no se modificara nada.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_VIN_VALINSTRUCCIONES... Empezando a insertar datos en el diccionario');
	    FOR I IN V_TIPO_ACR1.FIRST .. V_TIPO_ACR1.LAST
	      LOOP
	        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_VIN_VALINSTRUCCIONES.NEXTVAL FROM DUAL';
	        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
	        V_TMP_TIPO_ACR1 := V_TIPO_ACR1(I);
	        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_VIN_VALINSTRUCCIONES (
	                    DD_VIN_ID,DD_VIN_CODIGO,DD_VIN_DESCRIPCION,DD_VIN_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) ' ||
	                    'SELECT '|| V_ENTIDAD_ID || ', '''||TRIM(V_TMP_TIPO_ACR1(1))||''' ,'''||TRIM(V_TMP_TIPO_ACR1(2))||''','''||TRIM(V_TMP_TIPO_ACR1(3))||''','||V_TMP_TIPO_ACR1(4)||
	                    ','''||TRIM(V_TMP_TIPO_ACR1(5))||''','''||TRIM(V_TMP_TIPO_ACR1(6))||''','||V_TMP_TIPO_ACR1(7)||' FROM DUAL';
	                       DBMS_OUTPUT.PUT_LINE(V_MSQL);
	            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||TRIM(V_TMP_TIPO_ACR1(1))||''','''||TRIM(V_TMP_TIPO_ACR1(2)));
	        EXECUTE IMMEDIATE V_MSQL;
	      END LOOP;
	    COMMIT;
	    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_VIN_VALINSTRUCCIONES... Datos del diccionario insertado');
	END IF;
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