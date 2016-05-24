--/*
--##########################################
--## AUTOR=Alberto S
--## FECHA_CREACION=20160323
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-897
--## PRODUCTO=NO
--## Finalidad: DML para crear nuevos tipos de gestores de Haya-Sareb
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
   V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
   V_MSQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
   V_TMP NUMBER(16); -- Vble. para validar la existencia de una tabla.
   V_TMP_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.
   V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.

   V_DDNAME VARCHAR2(50 CHAR):= 'DD_TGE_TIPO_GESTOR';
   V_SEQNAME VARCHAR2(50 CHAR):= 'S_DD_TGE_TIPO_GESTOR';
   V_PREFIJO VARCHAR2(50 CHAR) := 'DD_TGE_';

   V_MERGE  VARCHAR2(4000 CHAR) := 'MERGE INTO ' || V_ESQUEMA_M || '.' || V_DDNAME|| ' tabla  ' || 
    ' USING (SELECT :id id, :codigo codigo, :des descripcion, :des_l descripcion_larga, ''PRODUCTO-897'' usuariocrear, sysdate fechacrear from DUAL) actual ' ||
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
      T_TIPO('GDEU', 'Gestor deuda', 'Gestor deuda')
     ,T_TIPO('GAUD', 'Gestor auditoría', 'Gestor auditoría')
     ,T_TIPO('SAUD', 'Supervisor auditoría', 'Supervisor auditoría')
     ,T_TIPO('AJUR', 'Asesoría jurídica', 'Asesoría jurídica')
     ,T_TIPO('GSDE', 'Gestor soporte deuda', 'Gestor soporte deuda')
     ,T_TIPO('SSDE', 'Supervisor soporte deuda', 'Supervisor soporte deuda')
     ,T_TIPO('EADQ', 'Equipo de Adquisiciones', 'Equipo de Adquisiciones')
     ,T_TIPO('SADQ', 'Supervisor de Adquisiciones', 'Supervisor de Adquisiciones')
     ,T_TIPO('GCN', 'Gestor de CN', 'Gestor de CN')
     ,T_TIPO('SCN', 'Supervisor de CN', 'Supervisor de CN')
    ); 
    V_TMP_TIPO T_TIPO;

    V_ENTIDAD_ID NUMBER(16);
    
    V_OBTENER_ID VARCHAR2(2000 CHAR) := 'SELECT ' || V_ESQUEMA_M || '.' || V_SEQNAME || '.NEXTVAL FROM DUAL';
    V_SELECT_ID  VARCHAR2(2000 CHAR) := 'SELECT COUNT(*) FROM ' || V_ESQUEMA_M || '.' || V_DDNAME || ' WHERE ' || V_PREFIJO || 'ID=:1';
  
BEGIN

	  -- LOOP Insertando valores en la tabla del diccionario
	  DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.' || V_DDNAME ||'... Empezando a insertar datos en el diccionario');
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
	  
	  DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.' || V_DDNAME ||'... Datos del diccionario insertado');


---------------------------------------------------------
--INSERTAMOS EN ETG_ENTIDAD_TIPO_GESTOR
--NO PODEMOS REUTILIZAR EL BUCLE, POR TANTO LO HACEMOS SEPARADO
---------------------------------------------------------
V_SQL := 'SELECT ID FROM '||V_ESQUEMA_M||'.ENTIDAD WHERE DESCRIPCION = ''HAYA''';
V_MSQL := 'SELECT COUNT(ID) FROM '||V_ESQUEMA_M||'.ENTIDAD WHERE DESCRIPCION = ''HAYA''';
EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 1 THEN
DBMS_OUTPUT.PUT_LINE('LA ENTIDAD HAYA EXISTE, POR TANTO PROCEDEMOS A INSERTAR');
EXECUTE IMMEDIATE V_SQL INTO V_TMP_2;
FOR I IN V_TIPO.FIRST .. V_TIPO.LAST
	LOOP
		V_TMP_TIPO := V_TIPO(I);
		V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||V_TMP_TIPO(1)||''''; 
		EXECUTE IMMEDIATE V_SQL INTO V_TMP;
		V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.ETG_ENTIDAD_TIPO_GESTOR WHERE DD_TGE_ID = '||V_TMP||' AND ENTIDAD_ID = '||V_TMP_2||'';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO en ETG_ENTIDAD_TIPO_GESTOR');
			V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.ETG_ENTIDAD_TIPO_GESTOR (DD_TGE_ID, ENTIDAD_ID ) VALUES ('||V_TMP||','||V_TMP_2||')';        
			EXECUTE IMMEDIATE V_MSQL;
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] YA EXISTE ENTRADA EN ETG_ENTIDAD_TIPO_GESTOR');
		END IF;
	END LOOP;
ELSE
DBMS_OUTPUT.PUT_LINE('LA ENTIDAD HAYA NO EXISTE');
END IF;

COMMIT;
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