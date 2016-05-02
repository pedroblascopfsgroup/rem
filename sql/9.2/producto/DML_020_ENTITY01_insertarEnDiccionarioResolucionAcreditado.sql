--/*
--##########################################
--## AUTOR=Alberto Soler
--## FECHA_CREACION=20160401
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-948
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
set linesize 2000
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master

   V_NUM_REGS NUMBER(16); -- Vble. para validar la existencia de un registro   
   ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

   V_DDNAME VARCHAR2(50 CHAR):= 'DD_RCA_RESOLUCION_ACRE';
   V_SEQNAME VARCHAR2(50 CHAR):= 'S_DD_RCA_RESOLUCION_ACRE';
   V_PREFIJO VARCHAR2(50 CHAR) := 'DD_RCA_';

   V_MERGE  VARCHAR2(4000 CHAR) := 'MERGE INTO ' || V_ESQUEMA || '.' || V_DDNAME|| ' tabla  ' || 
    ' USING (SELECT :id id, :codigo codigo, :des descripcion, :des_l descripcion_larga, ''PRODUCTO-948'' usuariocrear, sysdate fechacrear from DUAL) actual ' ||
    ' ON (tabla.' || V_PREFIJO || 'CODIGO=actual.codigo) ' ||
    ' WHEN NOT MATCHED THEN ' ||
    ' INSERT (' || V_PREFIJO || 'ID, ' || V_PREFIJO || 'CODIGO, ' || V_PREFIJO || 'DESCRIPCION, ' || V_PREFIJO || 'DESCRIPCION_LARGA, usuariocrear, fechacrear) ' ||
    ' VALUES (actual.id, actual.codigo, actual.descripcion, actual.descripcion_larga, actual.usuariocrear, actual.fechacrear) ' ||
    ' WHEN MATCHED THEN ' ||
    ' UPDATE SET tabla.' || V_PREFIJO || 'DESCRIPCION=actual.descripcion, tabla.' || V_PREFIJO || 'DESCRIPCION_LARGA=actual.descripcion_larga,BORRADO=0'  ;
         
    --Valores a insertar
    TYPE T_TIPO IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE T_ARRAY IS TABLE OF T_TIPO;
    V_TIPO T_ARRAY := T_ARRAY(
      T_TIPO('ACE', 'Aceptada', 'Aceptada')
     ,T_TIPO('REC', 'Rechazada', 'Rechazada')
    ); 
    V_TMP_TIPO T_TIPO;

    V_ENTIDAD_ID NUMBER(16);
    
    V_OBTENER_ID VARCHAR2(2000 CHAR) := 'SELECT ' || V_ESQUEMA || '.' || V_SEQNAME || '.NEXTVAL FROM DUAL';
    V_SELECT_ID  VARCHAR2(2000 CHAR) := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE ' || V_PREFIJO || 'ID=:1';
  
BEGIN
  
  -- LOOP Insertando valores en la tabla del diccionario
  DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || V_DDNAME ||'... Empezando a insertar datos en el diccionario');
  FOR I IN V_TIPO.FIRST .. V_TIPO.LAST
  LOOP
    V_TMP_TIPO := V_TIPO(I);
    LOOP
      --Obtenemos el ID correspondiente al siguiente valor de la secuencia 
      --DBMS_OUTPUT.PUT_LINE(V_OBTENER_ID);
      EXECUTE IMMEDIATE V_OBTENER_ID INTO V_ENTIDAD_ID;
      --Comprobamos que no exista ese ID como identificador de ningún registro
      --DBMS_OUTPUT.PUT_LINE(V_SELECT_ID);
      EXECUTE IMMEDIATE V_SELECT_ID INTO V_NUM_REGS USING V_ENTIDAD_ID;
      EXIT WHEN V_NUM_REGS=0;
    END LOOP;
    -- Ejecutamos el merge que ya comprueba si existe el código, en cuyo caso lo que hace es actualizar valores del registro
    --DBMS_OUTPUT.PUT_LINE(V_MERGE);
    EXECUTE IMMEDIATE V_MERGE USING V_ENTIDAD_ID, V_TMP_TIPO(1), V_TMP_TIPO(2), V_TMP_TIPO(3);
    DBMS_OUTPUT.PUT_LINE('INSERTANDO: ' || V_ENTIDAD_ID || ', '''||V_TMP_TIPO(1)||''','''||TRIM(V_TMP_TIPO(2))||'''');
  END LOOP;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || V_DDNAME ||'... Datos del diccionario insertado');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificado');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT