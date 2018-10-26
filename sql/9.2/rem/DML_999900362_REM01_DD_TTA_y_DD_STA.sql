--/*
--######################################### 
--## AUTOR=CARLOS LOPEZ
--## FECHA_CREACION=20181025
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.19
--## INCIDENCIA_LINK=HREOS-4660
--## PRODUCTO=NO
--## 
--## Finalidad: Creación reglas
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

  V_USR VARCHAR2(30 CHAR) := 'HREOS-4660'; -- USUARIOCREAR/USUARIOMODIFICAR

    TYPE T_TYPE_RE is table of VARCHAR2(250); 
    TYPE T_ARRAY_RE IS TABLE OF T_TYPE_RE;
    V_FOR_RE T_ARRAY_RE := T_ARRAY_RE(
        T_TYPE_RE('03','Colateral (PDV)'),
        T_TYPE_RE('04','Colateral – Liquidación de colaterales')
    );
    V_TMP_RE T_TYPE_RE; 
    
  NDD_sta_codigo VARCHAR2(50 CHAR);
    
  CURSOR C1 IS
    SELECT 
       STA.DD_STA_DESCRIPCION
      ,STA.DD_STA_DESCRIPCION_LARGA
    FROM #ESQUEMA#.DD_STA_SUBTIPO_TITULO_ACTIVO STA
    WHERE STA.BORRADO = 0
      AND STA.DD_TTA_ID = (select DD_TTA_ID 
                           from #ESQUEMA#.DD_TTA_TIPO_TITULO_ACTIVO 
                          WHERE BORRADO = 0 
                          AND DD_TTA_CODIGO = '03')
      AND NOT EXISTS (SELECT 1
                        FROM #ESQUEMA#.DD_TTA_TIPO_TITULO_ACTIVO TTA, #ESQUEMA#.DD_STA_SUBTIPO_TITULO_ACTIVO STA2
                       WHERE STA2.DD_TTA_ID = TTA.DD_TTA_ID 
                         AND TTA.BORRADO = 0 
                         AND TTA.DD_TTA_CODIGO = '04'
                         AND STA.DD_STA_DESCRIPCION = STA2.DD_STA_DESCRIPCION
                      )
      ORDER BY STA.DD_STA_CODIGO ASC;



BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INICIO]');

  DBMS_OUTPUT.PUT_LINE('  [INFO] Comprobaciones previas...');
  -- Verificar si la tabla ya existe
  V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_TTA_TIPO_TITULO_ACTIVO'' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
  
  IF V_NUM_TABLAS = 1 THEN
   
    FOR I IN V_FOR_RE.FIRST .. V_FOR_RE.LAST 
    LOOP
      V_TMP_RE := V_FOR_RE(I);  
 
      V_MSQL := 'SELECT COUNT(1) 
                   FROM '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO 
                  WHERE DD_TTA_CODIGO = '''||V_TMP_RE(1)||''' ';
                  
      EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
  
      IF V_NUM_TABLAS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('    [INFO] Insertando '||V_TMP_RE(1)||'...');
        EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO (
             DD_TTA_ID
            ,DD_TTA_CODIGO
            ,DD_TTA_DESCRIPCION
            ,DD_TTA_DESCRIPCION_LARGA
            ,VERSION
            ,USUARIOCREAR
            ,FECHACREAR
            ,BORRADO
          )
          SELECT '||V_ESQUEMA||'.S_DD_TTA_TIPO_TITULO_ACTIVO.NEXTVAL
                ,'''||V_TMP_RE(1)||'''
                ,'''||V_TMP_RE(2)||'''
                ,'''||V_TMP_RE(2)||'''
                ,0
                ,'''||V_USR||'''
                ,SYSDATE
                ,0
           FROM DUAL        
        ';
      ELSE
        DBMS_OUTPUT.PUT_LINE('      [INFO] El codigo '||V_TMP_RE(1)||'... Existe.');

        EXECUTE IMMEDIATE '
          UPDATE '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO
             SET USUARIOMODIFICAR = '''||V_USR||'''
            ,FECHAMODIFICAR = SYSDATE
            ,DD_TTA_DESCRIPCION = '''||V_TMP_RE(2)||'''
            ,DD_TTA_DESCRIPCION_LARGA = '''||V_TMP_RE(2)||'''
          WHERE DD_TTA_CODIGO = '''||V_TMP_RE(1)||'''       
        ';        
      END IF;
      
    END LOOP;    

  ELSE
    DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_ESQUEMA|| '.DD_TTA_TIPO_TITULO_ACTIVO... No existe.');
  END IF;
  
  V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_STA_SUBTIPO_TITULO_ACTIVO'' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
  
  IF V_NUM_TABLAS = 1 THEN  
    FOR R IN C1 LOOP
    
      V_SQL := 'SELECT MAX(DD_sta_codigo)+1
                FROM '||V_ESQUEMA||'.DD_STA_SUBTIPO_TITULO_ACTIVO
                ';
      EXECUTE IMMEDIATE V_SQL INTO NDD_sta_codigo;
      
      EXECUTE IMMEDIATE ' 
        INSERT INTO '||V_ESQUEMA||'.DD_STA_SUBTIPO_TITULO_ACTIVO (DD_STA_ID
                                                                  ,DD_TTA_ID
                                                                  ,DD_STA_CODIGO
                                                                  ,DD_STA_DESCRIPCION
                                                                  ,DD_STA_DESCRIPCION_LARGA
                                                                  ,VERSION
                                                                  ,USUARIOCREAR
                                                                  ,FECHACREAR
                                                                  ,BORRADO)
            (SELECT '||V_ESQUEMA||'.S_DD_STA_SUBTIPO_TITULO.NEXTVAL
                  ,(select DD_TTA_ID from '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO WHERE BORRADO = 0 AND DD_TTA_CODIGO = ''04'') DD_TTA_ID
                  , '||nDD_sta_codigo||' DD_STA_CODIGO
                  ,'''||R.DD_STA_DESCRIPCION||'''
                  ,'''||R.DD_STA_DESCRIPCION_LARGA||'''
                  ,0 VERSION
                  ,'''||V_USR||''' USUARIOCREAR
                  ,SYSDATE FECHACREAR
                  ,0 BORRADO
                FROM DUAL
      )
      ';
    END LOOP;
  END IF;
  
  
   COMMIT;
   
  DBMS_OUTPUT.PUT_LINE('[FIN]');    

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    err_num := SQLCODE;
    err_msg := SQLERRM;
    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    
    ROLLBACK;
    RAISE;          

END;

/

EXIT;
