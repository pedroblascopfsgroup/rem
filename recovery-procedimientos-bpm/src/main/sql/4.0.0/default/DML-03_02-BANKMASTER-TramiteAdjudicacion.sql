--/*
--##########################################
--## Author: Equipo Fase II - Bankia
--## Adaptado a BP : Guillermo Marin
--## Finalidad: DML para datos en tablas tramite adjudicacion
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas  
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_ENTIDAD_ID NUMBER(16);

--DD_TDE_TIPO_DESPACHO
TYPE T_TIPO_TDA IS TABLE OF VARCHAR2(2048);
  TYPE T_ARRAY_TDA IS TABLE OF T_TIPO_TDA;
  V_TIPO_TDA T_ARRAY_TDA := T_ARRAY_TDA(
    T_TIPO_TDA('GLL','Gestoría para llaves','Gestoría para llaves','0','DD',sysdate,null,null,null,null,'0'),
    T_TIPO_TDA('GDLL','Gestoría depositaria de llaves','Gestoría depositaria de llaves','0','DD',sysdate,null,null,null,null,'0')
  ); 
  V_TMP_TIPO_TDA T_TIPO_TDA; 
  
--  DD_TGE_TIPO_GESTOR
  TYPE T_TIPO_TGE IS TABLE OF VARCHAR2(2048);
  TYPE T_ARRAY_TGE IS TABLE OF T_TIPO_TGE;
  V_TIPO_TGE T_ARRAY_TGE := T_ARRAY_TGE(
    T_TIPO_TGE('GGLL','Gestor gestoría llaves','Gestor gestoría llaves','0','DD',sysdate,null,null,null,null,'0','1'),
    T_TIPO_TGE('GGDLL','Gestor gestoría depositaria llaves','Gestor gestoría depositaria llaves','0','DD',sysdate,null,null,null,null,'0','1')
  ); 
  V_TMP_TIPO_TGE T_TIPO_TGE; 

--dd_sta_subtipo_tarea_base  
  TYPE T_TIPO_STA IS TABLE OF VARCHAR2(2048);
  TYPE T_ARRAY_STA IS TABLE OF T_TIPO_STA;
  V_TIPO_STA T_ARRAY_STA := T_ARRAY_STA(
    T_TIPO_STA(1,'104','Tarea externa','Tarea externa (Gestor gestoria llaves)',0,'DD',sysdate,0,'(select dd_tge_id from '||V_ESQUEMA||'.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO=''GGLL'')','EXTSubtipoTarea'),
    T_TIPO_STA(1,'105','Tarea externa','Tarea externa (Gestor gestoria depositaria llaves)',0,'DD',sysdate,0,'(select dd_tge_id from '||V_ESQUEMA||'.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO=''GGDLL'')','EXTSubtipoTarea')
  ); 
  V_TMP_TIPO_STA T_TIPO_STA; 
  
  
BEGIN 
    
    -- 1) LOOP Insertando valores en DD_TDE_TIPO_DESPACHO
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_TDE_TIPO_DESPACHO... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_TDA.FIRST .. V_TIPO_TDA.LAST
      LOOP
        V_TMP_TIPO_TDA := V_TIPO_TDA(I);
       V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = ''' || TRIM(V_TMP_TIPO_TDA(1)) || '''';
       --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TDE_TIPO_DESPACHO... Ya existe el DESPACHO ''' || TRIM(V_TMP_TIPO_TDA(1)) || '''');        
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_TDE_TIPO_DESPACHO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TDE_TIPO_DESPACHO (
                      DD_TDE_ID, DD_TDE_CODIGO, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO) ' ||
                      'SELECT '''|| V_ENTIDAD_ID || ''','''||TRIM(V_TMP_TIPO_TDA(1))||''','''||TRIM(V_TMP_TIPO_TDA(2))||''','''||TRIM(V_TMP_TIPO_TDA(3))||''','''||TRIM(V_TMP_TIPO_TDA(4))||''','||
                       ''''||TRIM(V_TMP_TIPO_TDA(5)) || ''','''||V_TMP_TIPO_TDA(6)||''','''||V_TMP_TIPO_TDA(7)||''','''||V_TMP_TIPO_TDA(8)||''','''||V_TMP_TIPO_TDA(9)||''','||                     
                       ''''||V_TMP_TIPO_TDA(10) || ''','''||V_TMP_TIPO_TDA(11) ||
                        ''' FROM DUAL';
                        DBMS_OUTPUT.PUT_LINE(V_MSQL);
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TDA(1)||''','''||TRIM(V_TMP_TIPO_TDA(2)));
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_TDE_TIPO_DESPACHO... Datos del diccionario insertado');
    
    
    -- 2) LOOP Insertando valores en DD_TGE_TIPO_GESTOR
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_TGE_TIPO_GESTOR... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_TGE.FIRST .. V_TIPO_TGE.LAST
      LOOP
        V_TMP_TIPO_TGE := V_TIPO_TGE(I);
        V_SQL := 'SELECT COUNT(1) FROM DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||TRIM(V_TMP_TIPO_TGE(1)) || '''';
      -- DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TGE_TIPO_GESTOR... Ya existe el tipo gestor '''|| TRIM(V_TMP_TIPO_TGE(1)) || '''');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_TGE_TIPO_GESTOR.NEXTVAL FROM DUAL';
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TGE_TIPO_GESTOR (
                      DD_TGE_ID, DD_TGE_CODIGO, DD_TGE_DESCRIPCION, DD_TGE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO, DD_TGE_EDITABLE_WEB) ' ||
                      'SELECT '''|| V_ENTIDAD_ID || ''', '''||TRIM(V_TMP_TIPO_TGE(1))||''' ,'''||TRIM(V_TMP_TIPO_TGE(2))||''','''||TRIM(V_TMP_TIPO_TGE(3))||''','''||TRIM(V_TMP_TIPO_TGE(4))||''','||
                        ''''||TRIM(V_TMP_TIPO_TGE(5)) || ''','''||V_TMP_TIPO_TGE(6)||''','''||V_TMP_TIPO_TGE(7)||''','''||V_TMP_TIPO_TGE(8)||''','''||V_TMP_TIPO_TGE(9)||''','||
                        ''''||V_TMP_TIPO_TGE(10) || ''','''||V_TMP_TIPO_TGE(11)||''','''||TRIM(V_TMP_TIPO_TGE(12))||
                        ''' FROM DUAL';
                        DBMS_OUTPUT.PUT_LINE(V_MSQL);
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TGE(1)||''','''||TRIM(V_TMP_TIPO_TGE(2)));
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_TGE_TIPO_GESTOR... Datos del diccionario insertado');
    
    
    -- 3) LOOP Insertando valores en dd_sta_subtipo_tarea_base
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.dd_sta_subtipo_tarea_base... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_STA.FIRST .. V_TIPO_STA.LAST
      LOOP
        V_TMP_TIPO_STA := V_TIPO_STA(I);
         V_SQL := 'SELECT COUNT(1) FROM dd_sta_subtipo_tarea_base WHERE dd_tar_id = ' || V_TMP_TIPO_STA(1) || ' and dd_sta_codigo = '''||TRIM(V_TMP_TIPO_STA(2)) || '''';
      -- DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.dd_sta_subtipo_tarea_base... Ya existe la tarea '''|| TRIM(V_TMP_TIPO_STA(2)) || '''');
        ELSE
        
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.s_dd_sta_subtipo_tarea_base.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.dd_sta_subtipo_tarea_base (
                      dd_sta_id, dd_tar_id, dd_sta_codigo, dd_sta_descripcion, dd_sta_descripcion_larga, version, usuariocrear, fechacrear, borrado, dd_tge_id, dtype) ' ||
                      'SELECT '''|| V_ENTIDAD_ID || ''', '||TRIM(V_TMP_TIPO_STA(1))||' ,'''||TRIM(V_TMP_TIPO_STA(2))||''','''||TRIM(V_TMP_TIPO_STA(3))||''','''||TRIM(V_TMP_TIPO_STA(4))||''','||
                        ''''||TRIM(V_TMP_TIPO_STA(5)) || ''','''||V_TMP_TIPO_STA(6)||''','''||V_TMP_TIPO_STA(7)||''','''||V_TMP_TIPO_STA(8)||''','||V_TMP_TIPO_STA(9)||','||
                        ''''||V_TMP_TIPO_STA(10) || 
                        ''' FROM DUAL';
                        DBMS_OUTPUT.PUT_LINE(V_MSQL);
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_STA(1)||''','''||TRIM(V_TMP_TIPO_STA(2)));
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.dd_sta_subtipo_tarea_base... Datos del diccionario insertado');
  
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