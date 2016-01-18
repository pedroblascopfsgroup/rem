--/*
--##########################################
--## AUTOR=DANIEL ALBERT PEREZ
--## FECHA_CREACION=20151218
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=1.01
--## INCIDENCIA_LINK= HR-1500
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos de Diccionarios de ESTADOS de ASUNTOS
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE

   TYPE T_ESTADO_ASUNTOS IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_EASUNTOS IS TABLE OF T_ESTADO_ASUNTOS;

  -- Configuracion Esquemas
   V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
   V_ESQUEMA_M VARCHAR(25) := '#ESQUEMA_MASTER#';
   
   V_USUARIO_CREAR VARCHAR2(10) := 'ALTAASUNCM';	
                                          	
   V_ESTADO_ASUNTOS T_ARRAY_EASUNTOS := T_ARRAY_EASUNTOS(
									T_ESTADO_ASUNTOS('21','Fuera de perímetro','Fuera de perímetro'),
									T_ESTADO_ASUNTOS('22','Sin gestión','Sin gestión'));   
                                             
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
   V_DD_EAS_ID NUMBER(16,0);
   V_MSQL VARCHAR(5000);
   V_EXIST NUMBER(10);
   V_TMP_ESTADO_ASUNTOS T_ESTADO_ASUNTOS;
   
   err_num NUMBER;
   err_msg VARCHAR2(255);
BEGIN
    DBMS_OUTPUT.PUT_LINE('************** Comprobando si existe el registro **************');
    DBMS_OUTPUT.PUT_LINE('SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.DD_EAS_ESTADO_ASUNTOS WHERE DD_EAS_CODIGO = ''21'' ');
    V_MSQL := 'SELECT COUNT(*) FROM '|| V_ESQUEMA_M ||'.DD_EAS_ESTADO_ASUNTOS WHERE DD_EAS_CODIGO = ''21'''; 
   EXECUTE IMMEDIATE V_MSQL INTO V_EXIST;
  IF V_EXIST = 0 THEN
     DBMS_OUTPUT.PUT_LINE('************** Insertando en DD_EAS_ESTADO_ASUNTOS **************');
   FOR I IN V_ESTADO_ASUNTOS.FIRST .. V_ESTADO_ASUNTOS.LAST
   LOOP
      
      V_MSQL := 'SELECT '||V_ESQUEMA_M||'.S_DD_EAS_ESTADO_ASUNTOS.NEXTVAL FROM DUAL';
      
      EXECUTE IMMEDIATE V_MSQL 
      INTO V_DD_EAS_ID;
      V_TMP_ESTADO_ASUNTOS := V_ESTADO_ASUNTOS(I); 
          
      DBMS_OUTPUT.PUT_LINE('Insertando ESTADO ASUNTO: '|| V_DD_EAS_ID ||' DD_EAS_CODIGO = '|| V_TMP_ESTADO_ASUNTOS(1));      

      V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_EAS_ESTADO_ASUNTOS(DD_EAS_ID,DD_EAS_CODIGO, DD_EAS_DESCRIPCION, DD_EAS_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) 
      VALUES ('||V_DD_EAS_ID||','||V_TMP_ESTADO_ASUNTOS(1)||','''||V_TMP_ESTADO_ASUNTOS(2)||''','''||V_TMP_ESTADO_ASUNTOS(3)||''','''||V_USUARIO_CREAR||''',SYSDATE,0)';
      
      EXECUTE IMMEDIATE V_MSQL;
END LOOP; --LOOP POBLACION 
END IF;
COMMIT;
   V_TMP_ESTADO_ASUNTOS:= NULL;
   V_ESTADO_ASUNTOS:= NULL;
   V_EXIST:= NULL;

EXCEPTION

WHEN OTHERS THEN  
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);
  
  ROLLBACK;
  RAISE;
END;
/
EXIT;
