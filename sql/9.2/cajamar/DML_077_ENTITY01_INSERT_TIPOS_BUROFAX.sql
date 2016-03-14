--/*
--##########################################
--## AUTOR=PEDRO_BLASCO
--## FECHA_CREACION=20160310
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=CMREC-1849
--## PRODUCTO=NO
--## Finalidad: DML para crear nuevos tipos de burofax de Cajamar
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master

    V_NUM_REGS NUMBER(16); -- Vble. para validar la existencia de un registro   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_DDNAME VARCHAR2(50 CHAR):= 'DD_PCO_BFT_TIPO';
    V_SEQNAME VARCHAR2(50 CHAR):= 'S_DD_PCO_BFT_TIPO';
	V_PREFIJO VARCHAR2(50 CHAR) := 'DD_PCO_BFT_';

	V_MERGE  VARCHAR2(4000 CHAR) := 'MERGE INTO ' || V_ESQUEMA || '.' || V_DDNAME|| ' tabla  ' || 
		' USING (SELECT :1 _id, :2 _codigo, :3 _descripcion, 4: _descripcion_larga, 5: _descripcion_larga, 6: _plantilla, 'INICIAL' _usuariocrear, sysdate _fechacrear from DUAL) actual ' ||
		' ON (tabla.' || V_PREFIJO || 'CODIGO=actual._codigo) ' ||
		' WHEN NOT MATCHED THEN ' ||
		' INSERT (' || V_PREFIJO || '_ID, ' || V_PREFIJO || 'CODIGO, ' || V_PREFIJO || ' DESCRIPCION' || V_PREFIJO || 'DESCRIPCION_LARGA' || V_PREFIJO || 'PLANTILLA, usuariocrear, fechacrear) ' ||
		' VALUES (actual._id, actual._codigo, actual._descripcion, actual._descripcion_larga, actual._plantilla, actual.usuariocrear, actual.fechacrear) ' ||
		' WHEN MATCHED THEN ' ||
		' UPDATE SET tabla.' || V_PREFIJO || 'DESCRIPCION=actual.descripcion, tabla.' || V_PREFIJO || 'DESCRIPCION_LARGA=actual.descripcion_larga, tabla.' || V_PREFIJO || 'PLANTILLA=actual.plantilla'  ;
         
    --Valores a insertar
    TYPE T_TIPO IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY IS TABLE OF T_TIPO;
    V_TIPO T_ARRAY := T_ARRAY(
      T_TIPO('BF_AVAL', 'Aval', 'Concurso de acreedores'),
      T_TIPO('BF_CARTERA', 'Cartera', 'Acuerdo extrajudicial'),
      T_TIPO('BF_COMERCIO_EXTERIOR', 'Comercio Exterior', 'Oposición Ley hipotecaria 1/2013'),
      T_TIPO('BF_CREDITO', 'Crédito', 'Instrucciones de la entidad'),
      T_TIPO('BF_LEASING', 'Leasing', 'Otras causa'),
      T_TIPO('BF_PRESTAMO_HIPO', 'Préstamo Hipotecario', 'Otras causa'),
      T_TIPO('BF_PRESTAMO_HIPO', 'Préstamo Personal', 'Otras causa')
    ); 
    V_TMP_TIPO T_TIPO;

    V_ENTIDAD_ID NUMBER(16);
    
    V_BORRADO_LOGICO VARCHAR2(2000 CHAR) := 'UPDATE ' || V_ESQUEMA || '.' || V_ESQUEMA || ' SET BORRADO=1';
	V_OBTENER_ID VARCHAR2(2000 CHAR) := 'SELECT ' || V_ESQUEMA || '.' || V_SEQNAME || '.NEXTVAL FROM DUAL';
	V_SELECT_ID  VARCHAR2(2000 CHAR) := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE ' || V_PREFIJO || 'ID=:1';
	
BEGIN

	-- Borrado lógico los valores preexistentes en el diccionario
	EXECUTE IMMEDIATE V_BORRADO_LOGICO;
	
    -- LOOP Insertando valores en la tabla del diccionario
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || V_DDNAME ||'... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO.FIRST .. V_TIPO.LAST
      LOOP
        V_TMP_TIPO := V_TIPO(I);
        
		LOOP
	      	--Obtenemos el ID correspondiente al siguiente valor de la secuencia 
	        EXECUTE IMMEDIATE V_OBTENER_ID INTO V_OBTENER_ID USING V_TMP_TIPO(1);
	        --Comprobamos que no exista ese ID como identificador de ningún registro
			EXECUTE IMMEDIATE V_SELECT_ID INTO V_NUM_REGS USING V_OBTENER_ID;
			EXIT WHEN V_NUM_REGS=0;
		END LOOP;
        
        -- Ejecutamos el merge que ya comprueba si existe el código, en cuyo caso lo que hace es actualizar valores del registro
        EXECUTE IMMEDIATE V_MERGE USING V_ENTIDAD_ID, V_TMP_TIPO(1), V_TMP_TIPO(2), V_TMP_TIPO(2), V_TMP_TIPO(3);
        DBMS_OUTPUT.PUT_LINE('INSERTANDO: ' || V_ENTIDAD_ID ', '''||V_TMP_TIPO(1)||''','''||TRIM(V_TMP_TIPO(2))||'''');
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

