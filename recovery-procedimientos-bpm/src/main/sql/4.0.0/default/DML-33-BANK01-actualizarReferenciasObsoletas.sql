/*
--##########################################
--## Author: Gonzalo Estellés
--## Adaptado a BP : Gonzalo Estellés
--## Finalidad: Actualizar las referencias obsoletas
--## INSTRUCCIONES:  Actualizar las referencias a los trámites que han quedado obsoletos por los nuevos
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

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
      T_TIPO_TPO('P65','P410'), -- Tramite de Cesión de Remate
      T_TIPO_TPO('P56','P412'), -- Tramite de F. Común Abreviado
      T_TIPO_TPO('P05','P413'),  -- Tramite de Adjudicación
      T_TIPO_TPO('P24','P400'), -- Tramite notificacion demandados
      T_TIPO_TPO('P11','P401'), -- Tramite subasta BANKIA
      T_TIPO_TPO('P29','P408'),
      T_TIPO_TPO('P06','P400'),
      T_TIPO_TPO('P54','P416'),
      T_TIPO_TPO('P61','P420')      
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;
    
    
    TYPE T_TIPO_TPO2 IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO2 IS TABLE OF T_TIPO_TPO2;
    V_TIPO_TPO2 T_ARRAY_TPO2 := T_ARRAY_TPO2(
      T_TIPO_TPO2('P401','AP','T. de subasta BANKIA',0), 
      T_TIPO_TPO2('P409','AP','T. de subasta SAREB',0), 
      T_TIPO_TPO2('P419','AP','T. de ocupantes',0),
      T_TIPO_TPO2('P415','AP','T. de saneamiento de cargas',0),
      T_TIPO_TPO2('P414','AP','T. de subsanación de decreto de embargo',0),
      T_TIPO_TPO2('P413','AP','T. de adjudicación',0),
      T_TIPO_TPO2('P404','CO','T. de aceptacion y decision Concursal',0),
      T_TIPO_TPO2('P420','03','T. de aceptacion y decision litigios',0),
      T_TIPO_TPO2('P418','AP','T. de moratoria de lanzamiento',0),
      T_TIPO_TPO2('P417','AP','T. de gestión de llaves',0),
      T_TIPO_TPO2('P400','TR','T. notificación demandados',0),
      T_TIPO_TPO2('P411','AP','T. tributación en bienes',0),
      T_TIPO_TPO2('P60','TR','T. de anotación y vigilancia de embargos en registro',0),
      T_TIPO_TPO2('P412','CO','T. fase común',0),
      T_TIPO_TPO2('P11','--','--',1),
      T_TIPO_TPO2('P05','--','--',1),
      T_TIPO_TPO2('P29','--','--',1),
      T_TIPO_TPO2('P06','--','--',1),
      T_TIPO_TPO2('P65','--','--',1),
      T_TIPO_TPO2('P54','--','--',1),
      T_TIPO_TPO2('P56','--','--',1),
      T_TIPO_TPO2('P24','--','--',1),
      T_TIPO_TPO2('P61','--','--',1)
      
    ); 
    V_TMP_TIPO_TPO2 T_TIPO_TPO2;

BEGIN	

    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... Actualizando referencias');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET DD_TPO_ID_BPM=(SELECT dd_tpo_id FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo=''' || V_TMP_TIPO_TPO(2) || ''') 
                      WHERE DD_TPO_ID_BPM=(SELECT dd_tpo_id FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE dd_tpo_codigo='''|| V_TMP_TIPO_TPO(1) || ''')'; 

            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando: ''' || V_TMP_TIPO_TPO(1) ||'''->'''||TRIM(V_TMP_TIPO_TPO(2))||'''');
            
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'... Referencias actualizadas');
    
   COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'... Actualizando descripciones y tipos de actuación');
    FOR I IN V_TIPO_TPO2.FIRST .. V_TIPO_TPO2.LAST
      LOOP
        V_TMP_TIPO_TPO2 := V_TIPO_TPO2(I);
        
        IF (V_TMP_TIPO_TPO2(4) = 1) THEN
          V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO SET BORRADO=1, FECHABORRAR=SYSDATE, USUARIOBORRAR=''DML'' WHERE DD_TPO_CODIGO =''' || TRIM(V_TMP_TIPO_TPO2(1)) || '''';

            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] Borrando: ''' || V_TMP_TIPO_TPO2(1) ||'''');
        ELSE 
       
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO SET DD_TAC_ID = (SELECT DD_TAC_ID FROM '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ''' || TRIM(V_TMP_TIPO_TPO2(2)) || 
            '''), DD_TPO_DESCRIPCION = ''' || TRIM(V_TMP_TIPO_TPO2(3)) || ''', DD_TPO_DESCRIPCION_LARGA = ''' || TRIM(V_TMP_TIPO_TPO2(3)) || 
            ''' WHERE DD_TPO_CODIGO = ''' || TRIM(V_TMP_TIPO_TPO2(1)) || ''''; 

            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] Renombrando: ''' || V_TMP_TIPO_TPO2(1) ||'''');
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... Tipos de actuación actualizadas');
    
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