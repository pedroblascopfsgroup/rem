/*
--##########################################
--## Author: Josevi Jimenez
--## Adaptado a BP : Josevi
--## Finalidad: Insertar relaciones GESTOR - PROPIEDAD
--## INSTRUCCIONES:  Configurar las variables del declare
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la secuencia a crear


    --Array BANK01.TGP_TIPO_GESTOR_PROPIEDAD
    TYPE T_TIPO_BASE IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_BASE IS TABLE OF T_TIPO_BASE;
    V_TIPO_BASE T_ARRAY_BASE := T_ARRAY_BASE(
      T_TIPO_BASE('GGADJ', 'DES_VALIDOS', 'GPA', '0', 'SAG', null, null, null, null, '0'),
      T_TIPO_BASE('GGSAN', 'DES_VALIDOS', 'GPS', '0', 'SAG', null, null, null, null, '0'),
      T_TIPO_BASE('SGADJ', 'DES_VALIDOS', 'GPA', '0', 'SAG', null, null, null, null, '0'),
      T_TIPO_BASE('SGSAN', 'DES_VALIDOS', 'GPS', '0', 'SAG', null, null, null, null, '0')
    ); 
    V_TMP_TIPO_BASE T_TIPO_BASE;


BEGIN 


    -- LOOP Insertando valores en BANK01.TGP_TIPO_GESTOR_PROPIEDAD
    VAR_TABLENAME := 'TGP_TIPO_GESTOR_PROPIEDAD';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME || '... Empezando a insertar REGISTROS');
    FOR I IN V_TIPO_BASE.FIRST .. V_TIPO_BASE.LAST
      LOOP
        V_TMP_TIPO_BASE := V_TIPO_BASE(I);
        
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' WHERE DD_TGE_ID = (select DD_TGE_ID from '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR  where DD_TGE_CODIGO='''||TRIM(V_TMP_TIPO_BASE(1))||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
          
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'|| VAR_TABLENAME ||'... Ya existe la DD_TGE_ID '''|| TRIM(V_TMP_TIPO_BASE(1)) ||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
            ' (TGP_ID,DD_TGE_ID,TGP_CLAVE,TGP_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) '||
                    'SELECT '||V_ESQUEMA||'.S_TGP_TIPO_GESTOR_PROPIEDAD.nextval' ||
                       ',(select DD_TGE_ID from '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR  where DD_TGE_CODIGO='''||TRIM(V_TMP_TIPO_BASE(1))||''')'||
                     ','''||V_TMP_TIPO_BASE(2)||
                     ''',(select dd_tde_codigo from '||V_ESQUEMA_MASTER||'.DD_TDE_TIPO_DESPACHO where dd_tde_codigo='''||TRIM(V_TMP_TIPO_BASE(3))||''')'||
                     ','''||V_TMP_TIPO_BASE(4)||                       	
                     ''','''||TRIM(V_TMP_TIPO_BASE(5))||
                     ''','''||SYSDATE ||''||
                     ''','''||TRIM(V_TMP_TIPO_BASE(6))||
                     ''','''||TRIM(V_TMP_TIPO_BASE(7))||
                     ''','''||TRIM(V_TMP_TIPO_BASE(8))|| 
                     ''','''||TRIM(V_TMP_TIPO_BASE(9))||                      
                     ''','||TRIM(V_TMP_TIPO_BASE(10))||
                     ' FROM DUAL';
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: (''' || VAR_TABLENAME||'): '|| V_TMP_TIPO_BASE(1) ||''','''||TRIM(V_TMP_TIPO_BASE(2))||'''');
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Procedimiento');


    COMMIT;
    
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