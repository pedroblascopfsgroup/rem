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

<<<<<<< HEAD:sql/9.2/producto/DML_020_ENTITY01_insertarEnDiccionarioAsistenciaAFirma.sql
   V_DDNAME VARCHAR2(50 CHAR):= 'DD_AAF_ASISTENCIA_FIRMA';
   V_SEQNAME VARCHAR2(50 CHAR):= 'S_DD_AAF_ASISTENCIA_FIRMA';
   V_PREFIJO VARCHAR2(50 CHAR) := 'DD_AAF_';

   V_MERGE  VARCHAR2(4000 CHAR) := 'MERGE INTO ' || V_ESQUEMA || '.' || V_DDNAME|| ' tabla  ' || 
    ' USING (SELECT :id id, :codigo codigo, :des descripcion, :des_l descripcion_larga, ''PRODUCTO-948'' usuariocrear, sysdate fechacrear from DUAL) actual ' ||
    ' ON (tabla.' || V_PREFIJO || 'CODIGO=actual.codigo) ' ||
    ' WHEN NOT MATCHED THEN ' ||
    ' INSERT (' || V_PREFIJO || 'ID, ' || V_PREFIJO || 'CODIGO, ' || V_PREFIJO || 'DESCRIPCION, ' || V_PREFIJO || 'DESCRIPCION_LARGA, usuariocrear, fechacrear) ' ||
    ' VALUES (actual.id, actual.codigo, actual.descripcion, actual.descripcion_larga, actual.usuariocrear, actual.fechacrear) ' ||
    ' WHEN MATCHED THEN ' ||
    ' UPDATE SET tabla.' || V_PREFIJO || 'DESCRIPCION=actual.descripcion, tabla.' || V_PREFIJO || 'DESCRIPCION_LARGA=actual.descripcion_larga,BORRADO=0'  ;
         
=======
   V_DDNAME VARCHAR2(50 CHAR):= 'DD_TFA_FICHERO_ADJUNTO';
   V_SEQNAME VARCHAR2(50 CHAR):= 'S_DD_TFA_FICHERO_ADJUNTO';
   V_PREFIJO VARCHAR2(50 CHAR) := 'DD_TFA_';
   V_ENTIDAD_ID NUMBER(16);
  
   V_MSQL VARCHAR(5000);
   
>>>>>>> eb5149b... PRODUCTO-1093 Fichero adjuntos obligatorios - inserción en el diccionario:sql/9.2/producto/DML_023_ENTITY01_insertarEnDiccionarioTFA.sql
    --Valores a insertar
    TYPE T_TIPO IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE T_ARRAY IS TABLE OF T_TIPO;
    V_TIPO T_ARRAY := T_ARRAY(
<<<<<<< HEAD:sql/9.2/producto/DML_020_ENTITY01_insertarEnDiccionarioAsistenciaAFirma.sql
      T_TIPO('GESTOR', 'Gestor', 'Gestor')
     ,T_TIPO('GESTORIA', 'Gestoria', 'Gestoria')
=======
      T_TIPO('ESSU', 'Escrito de solicitud de la subasta','AP')
     ,T_TIPO('DCSU', 'Decreto de convocatoria de subasta','AP')
     ,T_TIPO('DO', 'Diligencia de ordenación','AP')
     ,T_TIPO('ESUSU', 'Edicto subsanado de subasta','AP')
     ,T_TIPO('PTSU', 'Pago tasa subasta','AP')
     ,T_TIPO('PPSBOE', 'Pantallazo de publicación de la subasta en BOE.ES','AP')
     ,T_TIPO('TCION', 'Tasación','AP')
     ,T_TIPO('ESADJ', 'Escrito de solicitud de adjudicación','AP')
     
>>>>>>> eb5149b... PRODUCTO-1093 Fichero adjuntos obligatorios - inserción en el diccionario:sql/9.2/producto/DML_023_ENTITY01_insertarEnDiccionarioTFA.sql
    ); 
    V_TMP_TIPO T_TIPO;
       
    BEGIN

   FOR I IN V_TIPO.FIRST .. V_TIPO.LAST
   LOOP
        V_TMP_TIPO := V_TIPO(I);

        EXECUTE IMMEDIATE('SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE DD_TFA_CODIGO = '''||V_TMP_TIPO(1)||'''') INTO V_NUM_REGS;
 
     if V_NUM_REGS = 0 then    

           V_MSQL := 'SELECT '||V_ESQUEMA||'.'||V_SEQNAME||'.NEXTVAL FROM DUAL';
           EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;

            DBMS_OUTPUT.PUT_LINE('Producto nuevo en '||V_DDNAME||' - INSERT: '||V_TMP_TIPO(1));  

           V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_DDNAME||'
                        (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID)
               VALUES 
                        ('||  V_ENTIDAD_ID || ','''||V_TMP_TIPO(1)||''','''||V_TMP_TIPO(2)||''','''||V_TMP_TIPO(2)||''',0,''PRODUCTO-1093'',SYSDATE,0, (SELECT DD_TAC_ID FROM '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = '''||V_TMP_TIPO(3)||'''))';
         
          EXECUTE IMMEDIATE V_MSQL;
                      
      else 

            DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO: '||V_TMP_TIPO(1)||','||TRIM(V_TMP_TIPO(2)));
 
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_DDNAME||'
            SET 
                DD_TFA_DESCRIPCION = '''||V_TMP_TIPO(2)||''', 
                DD_TFA_DESCRIPCION_LARGA = '''||V_TMP_TIPO(2)||''', 
                USUARIOMODIFICAR = ''PRODUCTO-1093'', 
                FECHAMODIFICAR = SYSDATE,
                DD_TAC_ID = (SELECT DD_TAC_ID FROM '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = '''||V_TMP_TIPO(3)||''')
            WHERE DD_TFA_CODIGO = '''||V_TMP_TIPO(1)||'''';   
            
           EXECUTE IMMEDIATE V_MSQL;
            

       end if;    
   
   END LOOP; 
   COMMIT;
  
  
<<<<<<< HEAD:sql/9.2/producto/DML_020_ENTITY01_insertarEnDiccionarioAsistenciaAFirma.sql
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
=======
   -- DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INSERTADO '||V_COUNT||' PRODUCTOS NUEVOS.');
    DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO.');
    
>>>>>>> eb5149b... PRODUCTO-1093 Fichero adjuntos obligatorios - inserción en el diccionario:sql/9.2/producto/DML_023_ENTITY01_insertarEnDiccionarioTFA.sql
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