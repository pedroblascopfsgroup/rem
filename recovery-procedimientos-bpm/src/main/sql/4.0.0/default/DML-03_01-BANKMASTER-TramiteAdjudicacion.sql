/*
--##########################################
--## Author: Josevi Jimenez
--## Adaptado a BP : Josevi
--## Finalidad: Crear Despacho, Gestor y Subtarea Base en BANKMASTER
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
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    --Array BANKMASTER.DD_TDE_TIPO_DESPACHO 
    TYPE T_TIPO_DESP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_DESP IS TABLE OF T_TIPO_DESP;
    V_TIPO_DESP T_ARRAY_DESP := T_ARRAY_DESP(
      T_TIPO_DESP('GPA','Gestoría para adjudicación','Gestoría para adjudicación','0','DD',null,null,null,null,'0'),
      T_TIPO_DESP('GPS','Gestoría para saneamiento','Gestoría para saneamiento','0','DD',null,null,null,null,'0')
      --('S_DD_TDE_TIPO_DESPACHO.nextval',GPS','Gestoría para saneamiento','Gestoría para saneamiento','0','DD',sysdate,null,null,null,null,'0')
    ); 
    V_TMP_TIPO_DESP T_TIPO_DESP;


    --Array BANKMASTER.DD_TGE_TIPO_GESTOR 
    TYPE T_TIPO_GES IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_GES IS TABLE OF T_TIPO_GES;
    V_TIPO_GES T_ARRAY_GES := T_ARRAY_GES(
      T_TIPO_GES('GGADJ','Gestor gestoría adjudicación','Gestor gestoría adjudicación','0','DD',null,null,null,null,'0','1'),
      T_TIPO_GES('GGSAN','Gestor gestoría saneamiento','Gestor gestoría saneamiento','0','DD',null,null,null,null,'0','1'),
      T_TIPO_GES('SGADJ','Supervisor gestoría adjudicación','Supervisor gestoría adjudicación','0','DD',null,null,null,null,'0','1'),
      T_TIPO_GES('SGSAN','Supervisor gestoría saneamiento','Supervisor gestoría saneamiento','0','DD',null,null,null,null,'0','1')
      --(BANKMASTER.S_DD_TGE_TIPO_GESTOR.nextval','SGSAN','Supervisor gestoría saneamiento','Supervisor gestoría saneamiento','0','DD','sysdate',null,null,null,null,'0','1')
    ); 
    V_TMP_TIPO_GES T_TIPO_GES;


    /*--Array BANKMASTER.dd_sta_subtipo_tarea_base 
    TYPE T_TIPO_BASE IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_BASE IS TABLE OF T_TIPO_BASE;
    V_TIPO_BASE T_ARRAY_BASE := T_ARRAY_BASE(
      T_TIPO_BASE(100, '100', 'Tarea externa', 'Tarea externa (Gestor gestoria adjudicacion)', 0, 'DD', 0, '(select dd_tge_id from '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO=''''GGADJ'''')', 'EXTSubtipoTarea'),
      T_TIPO_BASE(101, '101', 'Tarea externa', 'Tarea externa (Gestor gestoria saneamiento)', 0, 'DD', 0, '(select dd_tge_id from '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO=''''GGSAN'''')', 'EXTSubtipoTarea'),
      T_TIPO_BASE(102, '102', 'Tarea externa', 'Tarea externa (Supervisor gestoria adjudicacion)', 0, 'DD', 0, '(select dd_tge_id from '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO=''''SGADJ'''')', 'EXTSubtipoTarea'),
      T_TIPO_BASE(103, '103', 'Tarea externa', 'Tarea externa (Supervisor gestoria saneamiento)', 0, 'DD', 0, '(select dd_tge_id from '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO=''''SGSAN'''')', 'EXTSubtipoTarea')
    ); 
    V_TMP_TIPO_BASE T_TIPO_BASE;*/
    
--Array BANKMASTER.dd_sta_subtipo_tarea_base 
    TYPE T_TIPO_BASE IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_BASE IS TABLE OF T_TIPO_BASE;
    V_TIPO_BASE T_ARRAY_BASE := T_ARRAY_BASE(
      T_TIPO_BASE(1, '100', 'Tarea externa', 'Tarea externa (Gestor gestoria adjudicacion)', 0, 'DD', 0, 'GGADJ', 'EXTSubtipoTarea'),
      T_TIPO_BASE(1, '101', 'Tarea externa', 'Tarea externa (Gestor gestoria saneamiento)', 0, 'DD', 0, 'GGSAN', 'EXTSubtipoTarea'),
      T_TIPO_BASE(1, '102', 'Tarea externa', 'Tarea externa (Supervisor gestoria adjudicacion)', 0, 'DD', 0, 'SGADJ', 'EXTSubtipoTarea'),
      T_TIPO_BASE(1, '103', 'Tarea externa', 'Tarea externa (Supervisor gestoria saneamiento)', 0, 'DD', 0, 'SGSAN', 'EXTSubtipoTarea')
    ); 
    V_TMP_TIPO_BASE T_TIPO_BASE;


BEGIN 

    -- LOOP Insertando valores en BANKMASTER.DD_TDE_TIPO_DESPACHO 
    VAR_TABLENAME := 'DD_TDE_TIPO_DESPACHO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME || '... Empezando a insertar REGISTROS');
    FOR I IN V_TIPO_DESP.FIRST .. V_TIPO_DESP.LAST
      LOOP
        V_TMP_TIPO_DESP := V_TIPO_DESP(I);
        
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME ||' WHERE DD_TDE_CODIGO = '''||TRIM(V_TMP_TIPO_DESP(1))||'''';
        DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
          
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_MASTER || '.' || VAR_TABLENAME ||'... Ya existe la tarea '''|| TRIM(V_TMP_TIPO_DESP(1)) ||'''');
        ELSE
        
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA_MASTER ||'.' || VAR_TABLENAME || 
					' (DD_TDE_ID,DD_TDE_CODIGO,DD_TDE_DESCRIPCION,DD_TDE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) '||
                    'SELECT '|| V_ESQUEMA_MASTER||'.S_DD_TDE_TIPO_DESPACHO.nextval ' ||
                     ','''||V_TMP_TIPO_DESP(1)||
                     ''','''||TRIM(V_TMP_TIPO_DESP(2))||
                     ''','''||TRIM(V_TMP_TIPO_DESP(3))||
                     ''','''||TRIM(V_TMP_TIPO_DESP(4))||
                     ''','''||TRIM(V_TMP_TIPO_DESP(5))|| 
                     ''','''||SYSDATE||
                     ''','''||TRIM(V_TMP_TIPO_DESP(6))||
                     ''','''||TRIM(V_TMP_TIPO_DESP(7))||
                     ''','''||TRIM(V_TMP_TIPO_DESP(8))||
                     ''','''||TRIM(V_TMP_TIPO_DESP(9))||
                     ''','||TRIM(V_TMP_TIPO_DESP(10))||
                     ' FROM DUAL';

            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: (''' || V_ESQUEMA_MASTER||'): '|| V_TMP_TIPO_DESP(1) ||''','''||TRIM(V_TMP_TIPO_DESP(2))||'''');
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME || '... Procedimiento');

    -- LOOP Insertando valores en BANKMASTER.DD_TGE_TIPO_GESTOR 
    VAR_TABLENAME := 'DD_TGE_TIPO_GESTOR';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME || '... Empezando a insertar REGISTROS');
    FOR I IN V_TIPO_GES.FIRST .. V_TIPO_GES.LAST
      LOOP
        V_TMP_TIPO_GES := V_TIPO_GES(I);
        
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME ||' WHERE DD_TGE_CODIGO = '''||TRIM(V_TMP_TIPO_GES(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_MASTER || '.' || VAR_TABLENAME ||'... Ya existe el DD_TGE_CODIGO '''|| TRIM(V_TMP_TIPO_GES(1)) ||'''');
        ELSE
        
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA_MASTER ||'.' || VAR_TABLENAME || 
					' (DD_TGE_ID,DD_TGE_CODIGO,DD_TGE_DESCRIPCION,DD_TGE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_TGE_EDITABLE_WEB) '||
                    'SELECT '|| V_ESQUEMA_MASTER||'.S_DD_TGE_TIPO_GESTOR.nextval ' ||
                     ','''||V_TMP_TIPO_GES(1)||
                     ''','''||TRIM(V_TMP_TIPO_GES(2))||
                     ''','''||TRIM(V_TMP_TIPO_GES(3))||
                     ''','''||TRIM(V_TMP_TIPO_GES(4))||
                     ''','''||TRIM(V_TMP_TIPO_GES(5))|| 
                     ''','''||SYSDATE||
                     ''','''||TRIM(V_TMP_TIPO_GES(6))||
                     ''','''||TRIM(V_TMP_TIPO_GES(7))||
                     ''','''||TRIM(V_TMP_TIPO_GES(8))||
                     ''','''||TRIM(V_TMP_TIPO_GES(9))||
					 ''','''||TRIM(V_TMP_TIPO_GES(10))||                     
                     ''','||TRIM(V_TMP_TIPO_GES(11))||
                     ' FROM DUAL';

            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: (''' || V_ESQUEMA_MASTER||'): '|| V_TMP_TIPO_GES(1) ||''','''||TRIM(V_TMP_TIPO_GES(2))||'''');
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME || '... Procedimiento');




    -- LOOP Insertando valores en BANKMASTER.dd_sta_subtipo_tarea_base 
    VAR_TABLENAME := 'dd_sta_subtipo_tarea_base';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME || '... Empezando a insertar REGISTROS');
    FOR I IN V_TIPO_BASE.FIRST .. V_TIPO_BASE.LAST
      LOOP
        V_TMP_TIPO_BASE := V_TIPO_BASE(I);
        
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME ||' WHERE dd_sta_codigo = '''||TRIM(V_TMP_TIPO_BASE(2))||'''';
        DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
          
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_MASTER || '.' || VAR_TABLENAME ||'... Ya existe la dd_sta_codigo '''|| TRIM(V_TMP_TIPO_BASE(2)) ||'''');
        ELSE
        
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA_MASTER ||'.' || VAR_TABLENAME || 
					' (dd_sta_id, dd_tar_id, dd_sta_codigo, dd_sta_descripcion, dd_sta_descripcion_larga, version, usuariocrear, fechacrear, borrado, dd_tge_id, dtype) '||
                    'SELECT '||V_ESQUEMA_MASTER||'.s_dd_sta_subtipo_tarea_base.nextval' ||
                     ', (select dd_tar_id from dd_tar_tipo_tarea_base where dd_tar_codigo = '''||V_TMP_TIPO_BASE(1)||
                     '''),'''||TRIM(V_TMP_TIPO_BASE(2))||
                     ''','''||TRIM(V_TMP_TIPO_BASE(3))||
                     ''','''||TRIM(V_TMP_TIPO_BASE(4))||
                     ''','''||TRIM(V_TMP_TIPO_BASE(5))|| 
                     ''','''||TRIM(V_TMP_TIPO_BASE(6))||                      
                     ''','''||SYSDATE||
                     ''','||TRIM(V_TMP_TIPO_BASE(7))||
                       ',(select dd_tge_id from '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR  where DD_TGE_CODIGO='''||TRIM(V_TMP_TIPO_BASE(8))||''''||
                     '),'''||TRIM(V_TMP_TIPO_BASE(9))||''''||                       
                     ' FROM DUAL';

            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: (''' || V_ESQUEMA_MASTER||'): '|| V_TMP_TIPO_BASE(1) ||''','''||TRIM(V_TMP_TIPO_BASE(2))||'''');
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_MASTER||'.' || VAR_TABLENAME || '... Procedimiento');

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