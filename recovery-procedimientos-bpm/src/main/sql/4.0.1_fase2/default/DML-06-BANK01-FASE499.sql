--/*
--##########################################
--## Author: JoseVi Jimenez
--## Adaptado a BP : JoseVI
--## Finalidad: DML para correcciones UNDERCARPET
--## INSTRUCCIONES:  - Configurar las constantes del DECLARE
--##                 - Procedimiento PRINCIPAL - Al final. Llamadas a sub-procedimientos
--##                 - Hay 2 sub-proced con UPDATES masivos. Estos tienen PRE-Definidos el 
--##                   máximo de registros que deben actualizar. Definido en CONSTANTES con MAX_UPD_XXX.
--##                   Si se produce un error por sobrepasar el máximo compruebe filtro y redimensione maximo.
--##                 
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Modificado para tener principal y sub-p
--##        0.3 Añadido sub-p FASE_502
--##        0.4 Añadido sub-p FASE_503
--##        0.5 Añadido sub-p FASE_504
--##        0.6 Añadido sub-p FASE_505
--##        0.7 Añadido sub-p FASE_507
--##        0.8 Añadido sub-p FASE_508
--##        0.9 Añadido sub-p FASE_509
--##        1.0 Añadido sub-p FASE_510
--##        1.1 Añadido sub-p FASE_513
--##        1.2 Añadido sub-p FASE_514
--##        1.3 Añadido sub-p FASE_526
--##        1.4 Añadido sub-p FASE_538
--##        1.5 Añadido sub-p FASE_540
--##        1.6 Añadido sub-p FASE_541
--##        1.7 Añadido sub-p FASE_556
--##        1.8 Añadido sub-p FASE_566
--##        1.9 Añadido sub-p FASE_569
--##        2.0 Añadido sub-p FASE_572
--##        2.1 Añadido sub-p FASE_598
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    --Constantes
    --------------------------------------------------------------------------------------------------------
    P_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    P_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    P_MAX_NUM_UPD_503 NUMBER(5,0):= 2000; --Número máximo de registros actualizados permitidos con operaciones UPDATE de FASE_503
    P_MAX_NUM_UPD_513 NUMBER(5,0):= 10; --Número máximo de registros actualizados permitidos con operaciones UPDATE de FASE_513    
    P_MAX_NUM_UPD_598 NUMBER(5,0):= 70; --Número máximo de registros actualizados permitidos con operaciones UPDATE de FASE_598 


    --Variables
    --------------------------------------------------------------------------------------------------------
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_ESQUEMA VARCHAR2(25 CHAR); --Variable para esquema a elegir
    V_TABLA_UPD VARCHAR2(100 CHAR); -- Variable con la tabla sobre la que se actualizan valores
    V_COL_UPD VARCHAR2(200 CHAR); --Variable con la columna a actualizar
    V_COL_UPD1 VARCHAR2(200 CHAR); --Variable con la columna1 a actualizar
    V_COL_UPD2 VARCHAR2(200 CHAR); --Variable con la columna2 a actualizar
    V_COL_UPD3 VARCHAR2(200 CHAR); --Variable con la columna3 a actualizar
    V_TABLA1_UPD VARCHAR2(100 CHAR); -- Variable con la tabla1 sobre la que se actualizan valores
    V_T1_COL1_UPD VARCHAR2(200 CHAR); --Variable con la columna1 a actualizar de tabla1
    V_T1_COL2_UPD VARCHAR2(200 CHAR); --Variable con la columna2 a actualizar de tabla1
    V_T1_COL3_UPD VARCHAR2(200 CHAR); --Variable con la columna3 a actualizar de tabla1
    V_T1_COD1_WRE VARCHAR2(200 CHAR); --Variable con el campo1 del where a filtrar de tabla1
    V_T1_COD2_WRE VARCHAR2(200 CHAR); --Variable con el campo2 del where a filtrar de tabla1
    V_T1_COD3_WRE VARCHAR2(200 CHAR); --Variable con el campo3 del where a filtrar de tabla1
    V_TABLA2_UPD VARCHAR2(100 CHAR); -- Variable con la tabla2 sobre la que se actualizan valores
    V_T2_COL1_UPD VARCHAR2(200 CHAR); --Variable con la columna1 a actualizar de tabla2
    V_T2_COL2_UPD VARCHAR2(200 CHAR); --Variable con la columna2 a actualizar de tabla2
    V_T2_COL3_UPD VARCHAR2(200 CHAR); --Variable con la columna3 a actualizar de tabla2
    V_T2_COD1_WRE VARCHAR2(200 CHAR); --Variable con el campo1 del where a filtrar de tabla2
    V_T2_COD2_WRE VARCHAR2(200 CHAR); --Variable con el campo2 del where a filtrar de tabla2
    V_T2_COD3_WRE VARCHAR2(200 CHAR); --Variable con el campo3 del where a filtrar de tabla2
    V_TABLE_INS VARCHAR2(100 CHAR); -- Variable Nombre de la tabla a insertar registros
    V_CODIGO_FADJ VARCHAR2(200 CHAR); -- Variable Nombre del campo CODIGO para comparar valores y considerar existencia de registros
    V_MAX_NUM_UPD_503 NUMBER(5,0); -- Variable para definir un máximo de registros actualizados de tarea FASE_503
    V_MAX_NUM_UPD_513 NUMBER(5,0); -- Variable para definir un máximo de registros actualizados de tarea FASE_513
    V_MAX_NUM_UPD_598 NUMBER(5,0); -- Variable para definir un máximo de registros actualizados de tarea FASE_598
    V_WHERE VARCHAR2(2000 CHAR); -- Variable para construir la parte WHERE q será comun a select verificacion y update o delete
    V_NUM_UPD NUMBER(5,0); -- Variable para definir número de registros actualizados

    --Arrays
    --------------------------------------------------------------------------------------------------------
    TYPE T_TIPO_FADJ IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_FADJ IS TABLE OF T_TIPO_FADJ;

    --Valores Array BANK01.DD_TDE_TIPO_DESPACHO 
    V_TIPO_FADJ T_ARRAY_FADJ := T_ARRAY_FADJ(
      T_TIPO_FADJ('OT', 'Otros', 'Otros', 0, 'DML', 0, 'NULL')
    ); 
    V_ARR_TIPO_FADJ T_TIPO_FADJ;

    --Valores Array BANK01.TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(3000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
      T_TIPO_TFI('P400_GestionarNotificaciones', 0, 'label', 'titulo', '<p>Dado que se ha iniciado un trámite de notificación con el objeto de notificar a todos los demandados en el procedimiento, esta tarea seguirá pendiente mientras no se haya conseguido notificar a todos los demandados o en su caso, haber marcado la casilla Descartado en aquellos demandados que no se pudiera o considere su notificación.</p><p>Para gestionar las notificaciones de los demandados en el procedimiento, deberá abrir la ficha de procedimiento correspondiente y registrar las gestiones realizadas en la pestaña Notificación demandados.</p> <p>En el momento que queden todos los demandados notificados o en su caso descartados, el sistema completará esta tarea de forma automática dando así­ por finalizada esta actuación.</p>', NULL, NULL, NULL, NULL, 0, 'DML', NULL, NULL, NULL, NULL, 0),
      T_TIPO_TFI('P400_GestionarNotificaciones', 1, 'textarea', 'observaciones', 'Observaciones', NULL, NULL, NULL, NULL, 0, 'DML', NULL, NULL, NULL, NULL, 0),
      T_TIPO_TFI('P401_CelebracionSubasta', 0, 'label', 'titulo', '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez se celebre la subasta, en esta pantalla debe introducir la siguiente información:</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Celebrada deberá indicar si la subasta ha sido celebrada o no. En caso de haberse celebrado deberá indicar a través de la pestaña Subastas de la ficha del asunto correspondiente, el resultado de la subasta para cada uno de los bienes subastados y en el caso de adjudicación por parte de la entidad deberá informar también del importe por el cual se le lo ha adjudicado la entidad.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de suspensión de la subasta deberá indicar dicha circunstancia en el campo "Celebrada", en el campo "Decisión suspensión" deberá consignar quien ha provocado dicha suspensión y en el campo "Motivo suspensión" deberá indicar el motivo por el cual se ha suspendido.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de haberse adjudicado alguno de los bienes la Entidad, deberá indicar si ha habido Postores o no en la subasta y en el campo Cesión deberá indicar si se debe cursar la cesión de remate o no, según el procedimiento establecido por la entidad.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de haber cesión del remate deberá indicar si es requerida la preparación o no según el procedimiento establecido por la Entidad.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla la siguiente tarea será:<br>En caso de haberse producido la subasta se lanzará la tarea "Registrar acta de subasta".<br>En caso de haber cesión de remate y haber requerido la preparación de la misma "Preparar cesión de remate" a realizar por el supervisor.<br>En caso de haber cesión de remate y no haber requerido preparación de la misma, se lanzará directamente el trámite de cesión de remate.<br>En caso de haberse suspendido la subasta, se lanzará la tarea "Señalamiento de subasta".</p></div>', NULL, NULL, NULL, NULL, 0, 'DML', NULL, NULL, NULL, NULL, 0)
    ); 
    V_ARR_TIPO_TFI T_TIPO_TFI;

    --Valores Array BANK01.DD_GES_GESTORIA
    TYPE T_TIPO_GEST IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_GEST IS TABLE OF T_TIPO_GEST;
    V_TIPO_GEST T_ARRAY_GEST := T_ARRAY_GEST(
      T_TIPO_GEST('01','Gestoría adjudicación 1','Gestoría adjudicación 1','0','DD',null,null,null,null,'0'),
      T_TIPO_GEST('02','Gestoría adjudicación 2','Gestoría adjudicación 2','0','DD',null,null,null,null,'0')
      --( s_dd_ges_gestoria.nextval, '02', 'Gestoría adjudicación 2', 'Gestoría adjudicación 2', '0', 'DD', sysdate, NULL, NULL, NULL, NULL, '0' )
    ); 
    V_TMP_TIPO_GEST T_TIPO_GEST;

    --Valores Array BANK01.DD_TFO_TIPO_FONDO
    TYPE T_TIPO_FON IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_FON IS TABLE OF T_TIPO_FON;
    V_TIPO_FON T_ARRAY_FON := T_ARRAY_FON(
      T_TIPO_FON('01','Fondo 1','Fondo 1','0','DD',null,null,null,null,'0')
      --(S_DD_TFO_TIPO_FONDO, '01', 'Fondo 1', 'Fondo 1', 0, 'DD', sysdate, NULL, NULL, NULL, NULL, 0)
    ); 
    V_ARR_TIPO_FON T_TIPO_FON;


    --Excepciones definidas para el procedimiento
    MAX_UPD EXCEPTION;


    --SUB-PROCEDIMIENTOS
    --------------------------------------------------------------------------------------------------------
    PROCEDURE FASE_502 IS
    BEGIN
    
        /****************************************************************************************************
        * FASE-502 - Correccion titulo y descripciones de procedimiento Aceptacion Concurso
        ****************************************************************************************************/
        --InicializaCION VAriables
        V_TABLA_UPD := 'DD_TPO_TIPO_PROCEDIMIENTO';
        V_COL_UPD   := NULL;
        V_COL_UPD1  := 'DD_TAC_ID';
        V_COL_UPD2  := 'DD_TPO_DESCRIPCION';
        V_COL_UPD3  := 'DD_TPO_DESCRIPCION_LARGA';
    
        DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* FASE-502 - Correccion titulo y descripciones de procedimiento Aceptacion Concurso                  ');
        DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');
    
        --Se verifica si existe la tabla  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = UPPER(''' || V_TABLA_UPD || ''') AND OWNER = UPPER('''||V_ESQUEMA||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM de plazos, en esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe tabla
            V_MSQL := 
                'update '||V_ESQUEMA||'.'||V_TABLA_UPD||' tpo ' ||
                'set   tpo.'||V_COL_UPD1||' =(select dd_tac_id from dd_tac_tipo_actuacion where dd_tac_codigo=''03'') ' ||
                '    , tpo.'||V_COL_UPD2||' = ''T. Aceptacion de concurso'' ' ||
                '    , tpo.'||V_COL_UPD3||' = ''T. Aceptacion de concurso'' ' ||
                'where tpo.DD_TPO_CODIGO = ''P404'' '
                ;
    
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
        ELSE
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es POSIBLE realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA_UPD||' con sus campos '||V_COL_UPD1||', '||V_COL_UPD2||', '||V_COL_UPD3||' y repita ejecución');
            RETURN;
        END IF;
    
        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script FASE-502');
        RETURN;
        
    END; --END PROCEDURE
    
    
    PROCEDURE FASE_503 IS
    BEGIN
    
        /****************************************************************************************************
        * FASE-503 - Correccion groovys en TFI_VALIDACION
        ****************************************************************************************************/
        --InicializaCION VAriables
        V_TABLA_UPD := 'TFI_TAREAS_FORM_ITEMS';
        V_COL_UPD   := 'TFI_VALIDACION';
        V_COL_UPD1  := NULL;
        V_COL_UPD2  := NULL;
        V_COL_UPD3  := NULL;
    
        DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* FASE-503 - Correccion groovys en TFI_VALIDACION                                                    ');
        DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');

        --Se verifica si existe la tabla  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA_UPD || ''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA_UPD||', en esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe tabla
            
            --Se define el WHERE comun a comprobación y UPDATE
            V_WHERE := V_COL_UPD||' LIKE ''valor %!=%null%&&%!=%?%true%false''';

            --Como es un UPDATE de tipo masivo, se realiza una comprobación por cantidad de registros
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_UPD||' WHERE '||V_WHERE;
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_UPD;

            --Se considera un valor normal un número por debajo de CONSTANTE P_MAX_NUM_UPD
            IF V_NUM_UPD > V_MAX_NUM_UPD_503 THEN
                DBMS_OUTPUT.PUT_LINE('KO');
                DBMS_OUTPUT.put_line('[ERROR] El número de registros filtrados para cambiarse/borrarse de este sub-procedimiento supera el máximo definido');
                DBMS_OUTPUT.put_line('[ERROR] El filtro encuentra '||V_NUM_UPD||' registros cuando el máximo a cambiar es '||V_MAX_NUM_UPD_503||' registros');
                DBMS_OUTPUT.put_line('[ERROR] NO es POSIBLE realizar las acciones de este sub-procedimiento');
                DBMS_OUTPUT.put_line('[ERROR] Verifique que sigue siendo correcto el resultado del filtro y solo es que han aparecido más casos desde la dimensión del máximo');
                DBMS_OUTPUT.put_line('[ERROR] Si la comprobación es correcta, cambie el máximo en el parámetro global P_MAX_NUM_UPD_503');
                DBMS_OUTPUT.put_line('[ERROR] Filtro: '||V_WHERE);
                RAISE MAX_UPD; --Provoca error pre-definido y devuelve control a principal
                RETURN;
                --No se cumple esta validación y devuelve el control al procedimiento principal
            END IF;

            V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA_UPD||' '||
                'SET '||V_COL_UPD||' = '''||
                'valor != null && valor != '''''''' ? true : false''' ||
                ' WHERE '||V_WHERE
                ;
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');

        ELSE
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es POSIBLE realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA_UPD||' con sus campo '||V_COL_UPD||' y repita ejecución');
            RETURN;
        END IF;
    
        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script FASE-503');
        RETURN;
        
    END; --END PROCEDURE
    
        
    PROCEDURE FASE_504 IS
    BEGIN
    
        /****************************************************************************************************
        * FASE-504 - Correccion error al derivar en cesion remate
        ****************************************************************************************************/
        --InicializaCION VAriables
        V_TABLA_UPD := 'DD_PTP_PLAZOS_TAREAS_PLAZAS';
        V_TABLA1_UPD:= 'TAP_TAREA_PROCEDIMIENTO';
        V_COL_UPD   := 'DD_PTP_PLAZO_SCRIPT';
        V_COL_UPD1  := 'TAP_CODIGO';
        V_COL_UPD2  := NULL;
        V_COL_UPD3  := NULL;
    
        DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* FASE-504 - Correccion error al derivar en cesion remate                                            ');
        DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');
    
        --Se verifica si existe la tabla  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA_UPD || ''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA_UPD||', en esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe tabla
            V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA_UPD||' '||
                'SET '||V_COL_UPD||' = '''||
                'valoresBPMPadre[''''P401_SenyalamientoSubasta''''] == null ? 5*24*60*60*1000L : (damePlazo(valoresBPMPadre[''''P401_SenyalamientoSubasta''''][''''fechaSenyalamiento''''])+5*24*60*60*1000L)''' ||
                ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.'||V_TABLA1_UPD||' WHERE '||V_COL_UPD1||' =''P410_AperturaPlazo'') '
                ;
    
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
        ELSE
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es POSIBLE realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA_UPD||' con su campo '||V_COL_UPD||' y repita ejecución');
            RETURN;
        END IF; 
    
        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script FASE-504');
        RETURN;
        
    END; --END PROCEDURE
       
       
    PROCEDURE FASE_505 IS
    BEGIN
    
        /****************************************************************************************************
        * FASE-505 - Correcciones errores Tramite ejecucion notarial
        ****************************************************************************************************/
        V_TABLA_UPD := NULL;
        V_COL_UPD   := NULL;
        V_COL_UPD1  := NULL;
        V_COL_UPD2  := NULL;
        V_COL_UPD3  := NULL;
        V_TABLA1_UPD  := 'DD_TPO_TIPO_PROCEDIMIENTO';
        V_T1_COL1_UPD := 'DD_TPO_XML_JBPM';
        V_TABLA2_UPD  := 'TAP_TAREA_PROCEDIMIENTO';
        V_T2_COL1_UPD := 'TAP_SCRIPT_VALIDACION';
        V_T2_COL2_UPD := 'TAP_VIEW';
    
        DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* FASE-505 - Correcciones errores Tramite ejecucion notarial                                         ');
        DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');
    
        /*----------------------------------------
         UPDATES TABLA 1
        ------------------------------------------*/
        --Se verifica si existe la tabla1  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = UPPER(''' || V_TABLA1_UPD || ''') AND OWNER = UPPER('''||V_ESQUEMA||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla1 a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA1_UPD||', en esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe correcto
            V_MSQL := 
                'update '||V_ESQUEMA||'.'||V_TABLA1_UPD||' tpo ' ||
                'set   tpo.'||V_T1_COL1_UPD||' = ''tramiteEjecucionNotarialV4'' ' ||
                'where tpo.DD_TPO_CODIGO = ''P95'' '
                ;
    
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
        ELSE
            --No existe tabla
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA1_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es posible realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA1_UPD||' con sus campos '||V_T1_COL1_UPD||' y repita ejecución');
            RETURN;
        END IF;
    
    
        /*----------------------------------------
         UPDATES TABLA 2
        ------------------------------------------*/
        --Se verifica si existe la tabla2  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = UPPER(''' || V_TABLA2_UPD || ''') AND OWNER = UPPER('''||V_ESQUEMA||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla2 a actualizar, se ejecuta el script de actualización
        --DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA2_UPD||', en esquema '||V_ESQUEMA||'...');     
        IF V_NUM_TABLAS > 0 THEN
            --Existe correcto
    
            /* Actualizar T2 - Campo 1
            ----------------------------*/
            V_MSQL := 
                'update '||V_ESQUEMA||'.'||V_TABLA2_UPD||' tpo ' ||
                'set   tpo.'||V_T2_COL1_UPD||' =  ' ||
                    '''!comprobarBienAsociadoPrc() ? '||
                        '''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea, deber&aacute; registrar al menos un bien, para ello debe acceder a la pesta&ntilde;a Bienes.</p></div>''''' ||
                    ': '||
                        '( !tieneAlgunBienConFichaSubasta2() ? ' ||
                            '''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea, deber&aacute; dictar instrucciones para subasta en al menos un bien, para ello debe acceder a la pesta&ntilde;a Bienes de la ficha del Procedimiento correspondiente y proceder a dictar instrucciones.</p></div>''''' ||
                        ' : '||
                            'null'||
                        ')'' '||
                'where UPPER(tpo.TAP_CODIGO) = ''P95_REGISTRARANUNCIOSUBASTA'' '
                ;
    
            DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA2_UPD||', campo '||V_T2_COL1_UPD||' en esquema '||V_ESQUEMA||'...'); 
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
    
            /* Actualizar T2 - Campo 2, varios registros de tareas
            --------------------------------------------------------*/
            --Tarea1 - P95_dictarInstrucciones
            V_MSQL := 
                'update '||V_ESQUEMA||'.'||V_TABLA2_UPD||' tpo ' ||
                'set   tpo.'||V_T2_COL2_UPD||' = ''plugin/procedimientos/tramiteEjecucionNotarial/dictarInstrucciones'' ' ||
                'where UPPER(tpo.TAP_CODIGO) = ''P95_DICTARINSTRUCCIONES'' '
                ;
    
            DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA2_UPD||', campo '||V_T2_COL2_UPD||' en esquema '||V_ESQUEMA||' para TAREA(1) P95_dictarInstrucciones...'); 
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
    
            --Tarea2 - P95_entregaActaRequerimiento
            V_MSQL := 
                'update '||V_ESQUEMA||'.'||V_TABLA2_UPD||' tpo ' ||
                'set   tpo.'||V_T2_COL2_UPD||' = ''plugin/procedimientos/tramiteEjecucionNotarial/entregaActaRequerimiento'' ' ||
                'where UPPER(tpo.TAP_CODIGO) = ''P95_ENTREGAACTAREQUERIMIENTO'' '
                ;
    
            DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA2_UPD||', campo '||V_T2_COL2_UPD||' en esquema '||V_ESQUEMA||' para TAREA(2) P95_entregaActaRequerimiento...'); 
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
    
            --Tarea3 - P95_leerInstrucciones
            V_MSQL := 
                'update '||V_ESQUEMA||'.'||V_TABLA2_UPD||' tpo ' ||
                'set   tpo.'||V_T2_COL2_UPD||' = ''plugin/procedimientos/tramiteEjecucionNotarial/leerInstrucciones'' ' ||
                'where UPPER(tpo.TAP_CODIGO) = ''P95_LEERINSTRUCCIONES'' '
                ;
    
            DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA2_UPD||', campo '||V_T2_COL2_UPD||' en esquema '||V_ESQUEMA||' para TAREA(3) P95_leerInstrucciones...'); 
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
    
            --Tarea4 - P95_registrarAnuncioSubasta
            V_MSQL := 
                'update '||V_ESQUEMA||'.'||V_TABLA2_UPD||' tpo ' ||
                'set   tpo.'||V_T2_COL2_UPD||' = ''plugin/procedimientos/tramiteEjecucionNotarial/registrarAnuncioSubasta'' ' ||
                'where UPPER(tpo.TAP_CODIGO) = ''P95_REGISTRARANUNCIOSUBASTA'' '
                ;
    
            DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA2_UPD||', campo '||V_T2_COL2_UPD||' en esquema '||V_ESQUEMA||' para TAREA(4) P95_registrarAnuncioSubasta...'); 
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
    
            --Tarea5 - P95_registrarCelebracion1Subasta
            V_MSQL := 
                'update '||V_ESQUEMA||'.'||V_TABLA2_UPD||' tpo ' ||
                'set   tpo.'||V_T2_COL2_UPD||' = ''plugin/procedimientos/tramiteEjecucionNotarial/celebracionSubasta'' ' ||
                'where UPPER(tpo.TAP_CODIGO) = ''P95_REGISTRARCELEBRACION1SUBASTA'' '
                ;
    
            DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA2_UPD||', campo '||V_T2_COL2_UPD||' en esquema '||V_ESQUEMA||' para TAREA(5) P95_registrarCelebracion1Subasta...'); 
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
    
            --Tarea6 - P95_registrarCelebracion2Subasta
            V_MSQL := 
                'update '||V_ESQUEMA||'.'||V_TABLA2_UPD||' tpo ' ||
                'set   tpo.'||V_T2_COL2_UPD||' = ''plugin/procedimientos/tramiteEjecucionNotarial/celebracionSubasta'' ' ||
                'where UPPER(tpo.TAP_CODIGO) = ''P95_REGISTRARCELEBRACION2SUBASTA'' '
                ;
    
            DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA2_UPD||', campo '||V_T2_COL2_UPD||' en esquema '||V_ESQUEMA||' para TAREA(6) P95_registrarCelebracion2Subasta...'); 
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
    
            --Tarea7 - P95_registrarCelebracion3Subasta
            V_MSQL := 
                'update '||V_ESQUEMA||'.'||V_TABLA2_UPD||' tpo ' ||
                'set   tpo.'||V_T2_COL2_UPD||' = ''plugin/procedimientos/tramiteEjecucionNotarial/celebracionSubasta'' ' ||
                'where UPPER(tpo.TAP_CODIGO) = ''P95_REGISTRARCELEBRACION3SUBASTA'' '
                ;
    
            DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA2_UPD||', campo '||V_T2_COL2_UPD||' en esquema '||V_ESQUEMA||' para TAREA(7) P95_registrarCelebracion3Subasta...'); 
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');        
    
        ELSE
            --No existe tabla
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA2_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es posible realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA2_UPD||' con sus campos '||V_T2_COL1_UPD||', '||V_T2_COL2_UPD||' y repita ejecución');
            RETURN;
        END IF;
    
        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script FASE-505');
        RETURN;
        
    END; --END PROCEDURE
    
    
    PROCEDURE FASE_507 IS
    BEGIN
    
        /****************************************************************************************************
        * FASE-507 - Correcciones errores ficheros adjuntos tipo OTROS
        ****************************************************************************************************/
        --InicializaCION VAriables
        V_TABLA_UPD := NULL;
        V_COL_UPD   := NULL;
        V_COL_UPD1  := NULL;
        V_COL_UPD2  := NULL;
        V_COL_UPD3  := NULL;
        V_TABLA1_UPD  := NULL;
        V_T1_COL1_UPD := NULL;
        V_TABLA2_UPD  := NULL;
        V_T2_COL1_UPD := NULL;
        V_T2_COL2_UPD := NULL;
        V_TABLE_INS   := 'DD_TFA_FICHERO_ADJUNTO';
        V_CODIGO_FADJ := 'DD_TFA_CODIGO';
    
        DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* FASE-507 - Correcciones errores ficheros adjuntos tipo OTROS                                       ');
        DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');
    
        /*-----------------------------------
        * VERIFICACIONES
        -------------------------------------*/
        --EXISTENCIA DE TABLA: Mediante consulta a tablas del sistema se verifica si existe la tabla
        -----------------------------------------------------------------------------------------------------------
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = UPPER(''' || V_TABLE_INS || ''') AND OWNER = UPPER('''||V_ESQUEMA||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla1 a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de la tabla '||V_TABLE_INS||', en esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe correcto
            DBMS_OUTPUT.PUT_LINE('OK');
            DBMS_OUTPUT.put_line('[INFO] SI existe la tabla a actualizar '||V_TABLE_INS);        
        ELSE
            --No existe tabla
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLE_INS);
            DBMS_OUTPUT.put_line('[WARN] NO es posible realizar las acciones de este sub-procedimiento. No es posible insertar registros');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla y repita ejecución');
            RETURN;
        END IF;
    

        --EXISTENCIA DEL REGISTRO 'OTR': Mediante consulta a tabla se verifica si existe 'OTR' y se borra
        -----------------------------------------------------------------------------------------------------------
        V_SQL := 'SELECT COUNT(1) FROM '||V_TABLE_INS||' WHERE '||V_CODIGO_FADJ||' = ''OTR''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe un registro con DD_TFA_CODIGO = 'OTR', se elimina
        DBMS_OUTPUT.PUT('[INFO] Verificando la existencia del registro '||V_CODIGO_FADJ||'=''OTR'' en la tabla '||V_TABLE_INS||', esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe correcto
            DBMS_OUTPUT.PUT_LINE('OK');
            DBMS_OUTPUT.put_line('[INFO] YA existe un registro en la tabla con codigo '||V_CODIGO_FADJ||' = ''OTR'''); 
            DBMS_OUTPUT.PUT('[INFO] Se BORRA el registro existente ''OTR''...');

            V_MSQL := 
              'DELETE FROM '||V_TABLE_INS||' WHERE '||V_CODIGO_FADJ||' = ''OTR''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK - Eliminado');            
        ELSE
            DBMS_OUTPUT.PUT_LINE('OK');
            DBMS_OUTPUT.put_line('[INFO] NO existe el registro ''OTR''. No se realiza borrado.');
        END IF;


        /*-------------------------------------------------------
        * LOOP INSERT TABLA CON VERIFICACION EXISTENCIA REGISTROS
        --------------------------------------------------------*/
        FOR I IN V_TIPO_FADJ.FIRST .. V_TIPO_FADJ.LAST
          LOOP
            V_ARR_TIPO_FADJ := V_TIPO_FADJ(I);
    
        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
        -- verificacion comparando campo TFA_CODIGO con CODIGO del array
        -----------------------------------------------------------------------------------------------------------
        V_NUM_TABLAS := NULL;
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLE_INS||' WHERE  '||V_CODIGO_FADJ||' = '''||V_ARR_TIPO_FADJ(1)||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        DBMS_OUTPUT.PUT_LINE('Array codigo '||V_CODIGO_FADJ||' = '''||V_ARR_TIPO_FADJ(1)||'''---------------------------------'); 
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||V_TABLE_INS||', con codigo '||V_CODIGO_FADJ||' = '''||V_ARR_TIPO_FADJ(1)||'''...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe ya registro en la tabla
            DBMS_OUTPUT.put_line('[INFO] YA existe un registro en la tabla con codigo '||V_CODIGO_FADJ||' = '''||V_ARR_TIPO_FADJ(1)||'''...');            
            --INSERT DE REGISTROS
        -----------------------------------------------------------------------------------------------------------
          DBMS_OUTPUT.PUT('[INFO] Procediendo a modificar el registro...');
            V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.' || V_TABLE_INS || 
                         ' SET DD_TFA_CODIGO ='''||V_ARR_TIPO_FADJ(1)||
                         ''', DD_TFA_DESCRIPCION = '''||TRIM(V_ARR_TIPO_FADJ(2))||
                         ''', DD_TFA_DESCRIPCION_LARGA = '''||TRIM(V_ARR_TIPO_FADJ(3))||
                         ''', VERSION = 1' ||
                         '  , USUARIOMODIFICAR = '''||TRIM(V_ARR_TIPO_FADJ(5))|| 
                         ''', FECHAMODIFICAR = '''||SYSDATE||
                         ''', BORRADO = '''||TRIM(V_ARR_TIPO_FADJ(6))||
                         ''', DD_TAC_ID = '||TRIM(V_ARR_TIPO_FADJ(7)) ||
                         ' where DD_TFA_CODIGO = ''' || V_ARR_TIPO_FADJ(1) || '''';
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('OK - Modificado');
        ELSE
            --No existe registro en la tabla            
            DBMS_OUTPUT.put_line('[INFO] NO existe un registro en la tabla '||V_TABLE_INS||', con codigo '||V_CODIGO_FADJ||' = '''||V_ARR_TIPO_FADJ(1)||'''');
            --INSERT DE REGISTROS
        -----------------------------------------------------------------------------------------------------------
          DBMS_OUTPUT.PUT('[INFO] Procediendo a insertar el registro...');
            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || V_TABLE_INS || 
              ' (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID) '||
                        'SELECT '|| V_ESQUEMA||'.S_DD_TFA_FICHERO_ADJUNTO.NEXTVAL ' ||
                         ','''||V_ARR_TIPO_FADJ(1)||
                         ''','''||TRIM(V_ARR_TIPO_FADJ(2))||
                         ''','''||TRIM(V_ARR_TIPO_FADJ(3))||
                         ''','''||TRIM(V_ARR_TIPO_FADJ(4))||
                         ''','''||TRIM(V_ARR_TIPO_FADJ(5))|| 
                         ''','''||SYSDATE||
                         ''','''||TRIM(V_ARR_TIPO_FADJ(6))||
                         ''', '||TRIM(V_ARR_TIPO_FADJ(7))||
                         ' FROM DUAL';
    
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
    
    
        
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('OK');
    
        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script FASE-507');
        RETURN;
        
    END; --END PROCEDURE
    
    
    PROCEDURE FASE_508 IS
    BEGIN    
    
        /****************************************************************************************************
        * FASE-508 - Correcciones errores en TFI de T.Gestionar Notificaciones
        ****************************************************************************************************/
        --InicializaCION VAriables
        V_TABLA_UPD := NULL;
        V_COL_UPD   := NULL;
        V_COL_UPD1  := NULL;
        V_COL_UPD2  := NULL;
        V_COL_UPD3  := NULL;
        V_TABLA1_UPD  := NULL;
        V_T1_COL1_UPD := NULL;
        V_TABLA2_UPD  := NULL;
        V_T2_COL1_UPD := NULL;
        V_T2_COL2_UPD := NULL;
        V_TABLE_INS   := 'TFI_TAREAS_FORM_ITEMS';
        V_CODIGO_FADJ := 'TAP_CODIGO';
    
        DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* FASE-508 - Correcciones errores en TFI de T.Gestionar Notificaciones                               ');
        DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');
    
        /************************************
        * VERIFICACION
        ************************************/
        --EXISTENCIA DE TABLA: Mediante consulta a tablas del sistema se verifica si existe la tabla
        -----------------------------------------------------------------------------------------------------------
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = UPPER(''' || V_TABLE_INS || ''') AND OWNER = UPPER('''||V_ESQUEMA||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla1 a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de la tabla '||V_TABLE_INS||', en esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe correcto
            DBMS_OUTPUT.PUT_LINE('OK');
            DBMS_OUTPUT.put_line('[INFO] SI existe la tabla a actualizar '||V_TABLE_INS);        
        ELSE
            --No existe tabla
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLE_INS);
            DBMS_OUTPUT.put_line('[WARN] NO es posible realizar las acciones de este sub-procedimiento. No es posible insertar registros');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla y repita ejecución');
            RETURN;
        END IF;
    
    
        /********************************************************
        * LOOP INSERT TABLA CON VERIFICACION EXISTENCIA REGISTROS
        *********************************************************/
        FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
          LOOP
            V_ARR_TIPO_TFI := V_TIPO_TFI(I);
    
            --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
            -- verificacion comparando campo TFA_CODIGO con CODIGO del array
            -----------------------------------------------------------------------------------------------------------
            V_NUM_TABLAS := NULL;
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLE_INS||' WHERE TFI_ORDEN = '''|| V_ARR_TIPO_TFI(2) ||''' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE '||V_CODIGO_FADJ||' = '''||V_ARR_TIPO_TFI(1)||''')';
            --DBMS_OUTPUT.PUT_LINE(V_SQL);
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
            DBMS_OUTPUT.PUT_LINE('Array codigo '||V_CODIGO_FADJ||' = '''||V_ARR_TIPO_TFI(1)||''' Item = '''||V_ARR_TIPO_TFI(4)||'''---------------------------------'); 
            DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||V_TABLE_INS||', con codigo '||V_CODIGO_FADJ||' = '''||V_ARR_TIPO_TFI(1)||'''...'); 
            IF V_NUM_TABLAS > 0 THEN
                --Existe ya registro en la tabla
                DBMS_OUTPUT.PUT_LINE('OK');
                DBMS_OUTPUT.put_line('[INFO] YA existe un registro en la tabla con codigo '||V_CODIGO_FADJ||' = '''||V_ARR_TIPO_TFI(1)||'''...'); 
                DBMS_OUTPUT.PUT('[INFO] Para realizar la inserción limpia, primero se BORRA el registro existente...');
                
                V_MSQL := 
              'DELETE FROM '||V_TABLE_INS||' WHERE TFI_ORDEN = '''|| V_ARR_TIPO_TFI(2) ||''' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE '||V_CODIGO_FADJ||' = '''||V_ARR_TIPO_TFI(1)||''')';
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);      
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('OK - Eliminado');
            ELSE
                --No existe registro en la tabla
                DBMS_OUTPUT.PUT_LINE('OK');
                DBMS_OUTPUT.put_line('[INFO] NO existe un registro en la tabla '||V_TABLE_INS||', con codigo '||V_CODIGO_FADJ||' = '''||V_ARR_TIPO_TFI(1)||'''');
            END IF;
    
    
            --INSERT DE REGISTROS
            -----------------------------------------------------------------------------------------------------------
            DBMS_OUTPUT.PUT('[INFO] Procediendo a insertar el registro...');
            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || V_TABLE_INS || 
                        ' (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_VALOR_INICIAL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO) '||
                        'SELECT '|| V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL ' ||
                         ', (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_ARR_TIPO_TFI(1)) || ''') ' ||
                         ','''||V_ARR_TIPO_TFI(2)||
                         ''','''||TRIM(V_ARR_TIPO_TFI(3))||
                         ''','''||TRIM(V_ARR_TIPO_TFI(4))||
                         ''','''||TRIM(V_ARR_TIPO_TFI(5))||
                         ''','''||TRIM(V_ARR_TIPO_TFI(6))||
                         ''','''||TRIM(V_ARR_TIPO_TFI(7))||
                         ''','''||TRIM(V_ARR_TIPO_TFI(8))||
                         ''','''||TRIM(V_ARR_TIPO_TFI(9))||
                         ''','''||TRIM(V_ARR_TIPO_TFI(10))|| 
                         ''','''||TRIM(V_ARR_TIPO_TFI(11))||
                         ''','''||SYSDATE ||''||
                         ''','''||TRIM(V_ARR_TIPO_TFI(12))||
                         ''','''||TRIM(V_ARR_TIPO_TFI(13))||
                         ''','''||TRIM(V_ARR_TIPO_TFI(14))||
                         ''','''||TRIM(V_ARR_TIPO_TFI(15))||
                         ''', '||TRIM(V_ARR_TIPO_TFI(16))||
                         ' FROM DUAL';
    
          EXECUTE IMMEDIATE V_MSQL;
        END LOOP;
    
        DBMS_OUTPUT.PUT_LINE('OK');
    
        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script FASE-508');
        RETURN;
    
    END; --END PROCEDURE


    PROCEDURE FASE_509 IS
    BEGIN    
    
        /****************************************************************************************************
        * FASE-509 - Correcciones errores en Procedimiento Verbal
        ****************************************************************************************************/
        --InicializaCION VAriables
        V_TABLA_UPD := 'TAP_TAREA_PROCEDIMIENTO';
        V_COL_UPD   := 'TAP_SCRIPT_VALIDACION';
        V_COL_UPD1  := NULL;
        V_COL_UPD2  := NULL;
        V_COL_UPD3  := NULL;
        V_TABLA1_UPD  := NULL;
        V_T1_COL1_UPD := NULL;
        V_TABLA2_UPD  := NULL;
        V_T2_COL1_UPD := NULL;
        V_T2_COL2_UPD := NULL;
        V_TABLE_INS   := NULL;
        V_CODIGO_FADJ := 'TAP_CODIGO';
    
        DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* FASE-509 - Correcciones errores en Procedimiento Verbal                                            ');
        DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');


        --Se verifica si existe la tabla  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = UPPER(''' || V_TABLA_UPD || ''') AND OWNER = UPPER('''||V_ESQUEMA||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA_UPD||', en esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe tabla
            V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA_UPD||'  ' ||
                'SET    '||V_COL_UPD||' = ''!asuntoConProcurador() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'''' : (comprobarExisteDocumentoDSO() ? null : ''''Es necesario adjuntar el documento demanda sellada'''')'' ' ||
                'WHERE  '||V_CODIGO_FADJ||' = ''P04_InterposicionDemanda'' '
                ;
            
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
        ELSE
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es POSIBLE realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA_UPD||' con su campo '||V_COL_UPD||' y repita ejecución');
            RETURN;
        END IF;

        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script FASE-509');
        RETURN;

    END; --END PROCEDURE


    PROCEDURE FASE_510 IS
    BEGIN    
    
        /****************************************************************************************************
        * FASE-510 - Correcciones errores varios UPDATES
        ****************************************************************************************************/
        --InicializaCION VAriables
        V_TABLA_UPD := 'DD_TPO_TIPO_PROCEDIMIENTO';
        V_COL_UPD   := 'DD_TPO_XML_JBPM';
        V_CODIGO_FADJ:= 'DD_TPO_CODIGO';
        V_COL_UPD1  := NULL;
        V_COL_UPD2  := NULL;
        V_COL_UPD3  := NULL;
        V_TABLA1_UPD  := 'TAP_TAREA_PROCEDIMIENTO';
        V_T1_COL1_UPD := 'DD_STA_ID';
        V_T1_COL2_UPD := 'TAP_SCRIPT_VALIDACION';
        V_T1_COL3_UPD := 'TAP_VIEW';
        V_T1_COD1_WRE := 'TAP_CODIGO';
        V_TABLA2_UPD  := 'TFI_TAREAS_FORM_ITEMS';
        V_T2_COL1_UPD := 'TFI_ORDEN';
        V_T2_COL2_UPD := NULL;
        V_T2_COD1_WRE := 'TFI_ID';
        V_TABLE_INS   := NULL;
    
        DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* FASE-510 - Correcciones errores varios UPDATES                                                     ');
        DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');

        /*----------------------------------------
         UPDATES TABLA 1 TAP_TAREA_PROCEDIMIENTO
        ------------------------------------------*/
        --Se verifica si existe la tabla  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = UPPER(''' || V_TABLA1_UPD || ''') AND OWNER = UPPER('''||V_ESQUEMA||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA1_UPD||', en esquema '||V_ESQUEMA||'...............'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe tabla
            DBMS_OUTPUT.PUT_LINE('OK');

            -- UPDATE P12_SolitarTasacionInterna -----------
            DBMS_OUTPUT.PUT('[INFO] Cambio '||V_T1_COL1_UPD||' en P12_SolitarTasacionInterna...');
            V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA1_UPD||'  ' ||
                'SET    '||V_T1_COL1_UPD||' = 40 ' ||
                'WHERE  '||V_T1_COD1_WRE||' = ''P12_SolitarTasacionInterna'' '
                ;
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');


            -- UPDATE P20_RevisarInvestigacionYActualizacionDatos -----------
            DBMS_OUTPUT.PUT('[INFO] Cambio '||V_T1_COL1_UPD||' en P20_RevisarInvestigacionYActualizacionDatos...');
            V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA1_UPD||'  ' ||
                'SET    '||V_T1_COL1_UPD||' = 40 ' ||
                'WHERE  '||V_T1_COD1_WRE||' = ''P20_RevisarInvestigacionYActualizacionDatos'' '
                ;
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');

            -- UPDATE P409_AdjuntarInformeSubasta -----------
            DBMS_OUTPUT.PUT('[INFO] Cambio '||V_T1_COL2_UPD||' en P409_AdjuntarInformeSubasta...');
            V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA1_UPD||'  ' ||
                'SET    '||V_T1_COL2_UPD||' = ''comprobarExisteDocumentoINS() ? null : ''''Debe adjuntar el informe de subasta al procedimiento.''''  ''' ||
                'WHERE  '||V_T1_COD1_WRE||' = ''P409_AdjuntarInformeSubasta'' '
                ;
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');

            -- UPDATE P15_AutoDespaEjecMasDecretoEmbargo_new1 -----------
            DBMS_OUTPUT.PUT('[INFO] Cambio '||V_T1_COL3_UPD||' en P15_AutoDespaEjecMasDecretoEmbargo_new1...');
            V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA1_UPD||'  ' ||
                'SET    '||V_T1_COL3_UPD||' = ''plugin/procedimientos/ejecucionTituloNoJudicial/autoDespachandoEjecucion'' ' ||
                'WHERE  '||V_T1_COD1_WRE||' = ''P15_AutoDespaEjecMasDecretoEmbargo_new1'' '
                ;
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');

        ELSE
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA1_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es POSIBLE realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA1_UPD||' con sus campos '||V_T1_COL1_UPD||', '||V_T1_COL2_UPD||', '||V_T1_COL3_UPD||' y repita ejecución');
            RETURN;
        END IF;


        /*----------------------------------------
         UPDATES TABLA 2 DD_TPO_TIPO_PROCEDIMIENTO
        ------------------------------------------*/
        --Se verifica si existe la tabla  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = UPPER(''' || V_TABLA_UPD || ''') AND OWNER = UPPER('''||V_ESQUEMA||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando tabla BPM '||V_TABLA_UPD||', en esquema '||V_ESQUEMA||'...............OK'); 
        DBMS_OUTPUT.PUT('[INFO] Cambio '||V_COL_UPD||' en P96...');
        IF V_NUM_TABLAS > 0 THEN
            --Existe tabla

            V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA_UPD||'  ' ||
                'SET    '||V_COL_UPD||' = ''tramiteDemandadoEnIncidenteV4'' ' ||
                'WHERE  '||V_CODIGO_FADJ||' = ''P96'' '
                ;
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');

        ELSE
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es POSIBLE realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA_UPD||' con su campo '||V_COL_UPD||' y repita ejecución');
            RETURN;
        END IF;


        /*----------------------------------------
         UPDATES TABLA 3 TFI_TAREAS_FORM_ITEMS - eliminar Situacion Concusal
        ------------------------------------------*/
        --Se verifica si existe la tabla  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = UPPER(''' || V_TABLA2_UPD || ''') AND OWNER = UPPER('''||V_ESQUEMA||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA2_UPD||', en esquema '||V_ESQUEMA||'...............'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe tabla
            DBMS_OUTPUT.PUT_LINE('OK');

            DBMS_OUTPUT.PUT('[INFO] Cambio orden campos ''Observaciones'' en TAP_ID con ''SituacionConcursal''...');
            V_MSQL := 
              'UPDATE '||V_ESQUEMA||'.'||V_TABLA2_UPD||' TFIU '||
              'SET TFIU.TFI_ORDEN = ( ' ||
              '      select tfisc.tfi_orden sc_orden '||
              '      from '||V_ESQUEMA||'.'||V_TABLA2_UPD||' tfi '||
              '      inner join ( '||
              '         SELECT '||
              '            tfi1.'||V_T2_COD1_WRE||' '||
              '            , tfi1.tap_id '||
              '            , tfi1.tfi_orden '||
              '         FROM '||V_ESQUEMA||'.'||V_TABLA2_UPD||' tfi1 '||
              '         WHERE tfi1.TFI_NOMBRE = ''SituacionConcursal'' '||
              '         ) tfisc on tfi.tap_id = tfisc.tap_id '||
              '      where UPPER(tfi.tfi_nombre) = ''OBSERVACIONES'' '||
              '      AND TFI.'||V_T2_COD1_WRE||' = TFIU.'||V_T2_COD1_WRE||') ' ||
              'WHERE EXISTS ( '||
              '      select 1 '||
              '      from '||V_ESQUEMA||'.'||V_TABLA2_UPD||' tfi '||
              '      inner join ( '||
              '       SELECT '||
              '          tfi1.'||V_T2_COD1_WRE||' '||
              '          , tfi1.tap_id '||
              '          , tfi1.tfi_orden '||
              '       FROM '||V_ESQUEMA||'.'||V_TABLA2_UPD||' tfi1 '||
              '       WHERE tfi1.TFI_NOMBRE = ''SituacionConcursal'' '||
              '       ) tfisc on tfi.tap_id = tfisc.tap_id '||
              '      where UPPER(tfi.tfi_nombre) = ''OBSERVACIONES'' '||
              '      AND TFI.'||V_T2_COD1_WRE||' = TFIU.'||V_T2_COD1_WRE||') '
              ;

            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');

            DBMS_OUTPUT.PUT('[INFO] Borrado registros de ''SituacionConcursal''...');
            V_MSQL := 
              'DELETE '||V_ESQUEMA||'.'||V_TABLA2_UPD||' TFID '||
              'WHERE EXISTS ( '||
              '      select 1 '||
              '      from '||V_ESQUEMA||'.'||V_TABLA2_UPD||' tfi '||
              '      inner join ( '||
              '       SELECT '||
              '          tfi1.'||V_T2_COD1_WRE||' '||
              '          , tfi1.tap_id '||
              '          , tfi1.tfi_orden '||
              '       FROM '||V_ESQUEMA||'.'||V_TABLA2_UPD||' tfi1 '||
              '       WHERE tfi1.TFI_NOMBRE = ''SituacionConcursal'' '||
              '       ) tfisc on tfi.tap_id = tfisc.tap_id '||
              '      where UPPER(tfi.tfi_nombre) = ''OBSERVACIONES'' '||
              '      AND TFISC.'||V_T2_COD1_WRE||' = TFID.'||V_T2_COD1_WRE||') '
              ;

            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');

        ELSE
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA2_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es POSIBLE realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA2_UPD||' con su campo '||V_T2_COL1_UPD||' y repita ejecución');
            RETURN;
        END IF;



        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script FASE-510');
        RETURN;

    END; --END PROCEDURE


    PROCEDURE FASE_513 IS
    BEGIN    
    
        /****************************************************************************************************
        * FASE-513 - Correcciones errores de comillado incorrecto en fragmentos con NULL
        ****************************************************************************************************/
        --InicializaCION VAriables
        V_TABLA_UPD   := 'TAP_TAREA_PROCEDIMIENTO';
        V_COL_UPD     := NULL;
        V_CODIGO_FADJ := NULL;
        V_COL_UPD1    := 'TAP_SCRIPT_VALIDACION';
        V_COL_UPD2    := 'TAP_SCRIPT_VALIDACION_JBPM';
        V_COL_UPD3    := NULL;
        V_TABLA1_UPD  := NULL;
        V_T1_COL1_UPD := NULL;
        V_T1_COL2_UPD := NULL;
        V_T1_COL3_UPD := NULL;
        V_T1_COD1_WRE := NULL;
        V_TABLA2_UPD  := NULL;
        V_T2_COL1_UPD := NULL;
        V_T2_COL2_UPD := NULL;
        V_T2_COD1_WRE := NULL;
        V_TABLE_INS   := NULL;
        V_NUM_TABLAS  := NULL;
        V_NUM_UPD     := NULL;
    
        DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* FASE-513 - Correcciones errores de comillado incorrecto en fragmentos con NULL                     ');
        DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');


        --Se verifica si existe la tabla  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = UPPER(''' || V_TABLA_UPD || ''') AND OWNER = UPPER('''||V_ESQUEMA||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA_UPD||', en esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe tabla

            -----------------------------------------------------------------------------------------------------
            --ACCIONES PARA TAP_SCRIPT_VALIDACION
            -----------------------------------------------------------------------------------------------------
            --Se construye el WHERE común a verificacion y updates/deletes
            V_WHERE := ' '||V_COL_UPD1||'  like ''%''''null''''%'' ';

            --Se obtiene el número de registros que van a ser alterados o borrados por el filtro común
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_UPD||' WHERE '||V_WHERE;
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_UPD;

            --Se verifica que el filtro de updates masivo no supera el máximo comprobado
            IF V_NUM_UPD > V_MAX_NUM_UPD_513 THEN
                DBMS_OUTPUT.PUT_LINE('KO');
                DBMS_OUTPUT.put_line('[ERROR] El número de registros filtrados para cambiarse/borrarse de este sub-procedimiento supera el máximo definido');
                DBMS_OUTPUT.put_line('[ERROR] El filtro encuentra '||V_NUM_UPD||' registros cuando el máximo a cambiar es '||V_MAX_NUM_UPD_513||' registros');
                DBMS_OUTPUT.put_line('[ERROR] NO es POSIBLE realizar las acciones de este sub-procedimiento');
                DBMS_OUTPUT.put_line('[ERROR] Verifique que sigue siendo correcto el resultado del filtro y solo es que han aparecido más casos desde la dimensión del máximo');
                DBMS_OUTPUT.put_line('[ERROR] Si la comprobación es correcta, cambie el máximo en el parámetro global P_MAX_NUM_UPD_513');
                DBMS_OUTPUT.put_line('[ERROR] Filtro: '||V_WHERE);
                RAISE MAX_UPD; --Provoca error pre-definido y devuelve control a principal
                RETURN;
                --No se cumple esta validación y devuelve el control al procedimiento principal
            END IF;

            --Se verifica que el filtro de updates masivo encuentra registros
            IF V_NUM_UPD > 0 THEN
                --Hay registros para actualizar
                --Realiza el UPDATE masivo
                V_MSQL := 
                    'UPDATE '||V_ESQUEMA||'.'||V_TABLA_UPD||'  ' ||
                    'SET    '||V_COL_UPD1||' = replace('||V_COL_UPD1||','||'''null'''||',''null'') ' ||
                    'WHERE  '||V_WHERE
                    ;
                
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('OK');
                DBMS_OUTPUT.put_line('[INFO] '||V_COL_UPD1||': '||V_NUM_UPD||' casos actualizados.');

            ELSE
                --No hay registros para actualizar
                --Se muestra un mensaje
                DBMS_OUTPUT.PUT_LINE('OK');
                DBMS_OUTPUT.put_line('[INFO] '||V_COL_UPD1||': '||V_NUM_UPD||' casos actualizados. El filtro no ha producido ningún resultado');
            END IF;


            -----------------------------------------------------------------------------------------------------
            --ACCIONES PARA TAP_SCRIPT_VALIDACION_JBPM
            -----------------------------------------------------------------------------------------------------
            --Se construye el WHERE común a verificacion y updates/deletes
            V_WHERE := ' '||V_COL_UPD2||'  like ''%''''null''''%'' ';

            --Se obtiene el número de registros que van a ser alterados o borrados por el filtro común
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_UPD||' WHERE '||V_WHERE;
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_UPD;

            --Se verifica que el filtro de updates masivo no supera el máximo comprobado
            IF V_NUM_UPD > V_MAX_NUM_UPD_513 THEN
                DBMS_OUTPUT.PUT_LINE('KO');
                DBMS_OUTPUT.put_line('[ERROR] El número de registros filtrados para cambiarse/borrarse de este sub-procedimiento supera el máximo definido');
                DBMS_OUTPUT.put_line('[ERROR] El filtro encuentra '||V_NUM_UPD||' registros cuando el máximo a cambiar es '||V_MAX_NUM_UPD_513||' registros');
                DBMS_OUTPUT.put_line('[ERROR] NO es POSIBLE realizar las acciones de este sub-procedimiento');
                DBMS_OUTPUT.put_line('[ERROR] Verifique que sigue siendo correcto el resultado del filtro y solo es que han aparecido más casos desde la dimensión del máximo');
                DBMS_OUTPUT.put_line('[ERROR] Si la comprobación es correcta, cambie el máximo en el parámetro global P_MAX_NUM_UPD_513');
                DBMS_OUTPUT.put_line('[ERROR] Filtro: '||V_WHERE);
                RAISE MAX_UPD; --Provoca error pre-definido y devuelve control a principal
                RETURN;
                --No se cumple esta validación y devuelve el control al procedimiento principal
            END IF;

            --Se verifica que el filtro de updates masivo encuentra registros
            IF V_NUM_UPD > 0 THEN
                --Hay registros para actualizar
                --Realiza el UPDATE masivo
                V_MSQL := 
                    'UPDATE '||V_ESQUEMA||'.'||V_TABLA_UPD||'  ' ||
                    'SET    '||V_COL_UPD2||' = replace('||V_COL_UPD2||','||'''null'''||',''null'') ' ||
                    'WHERE  '||V_WHERE
                    ;
                
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.put_line('[INFO] '||V_COL_UPD2||': '||V_NUM_UPD||' casos actualizados.');

            ELSE
                --No hay registros para actualizar
                --Se muestra un mensaje
                DBMS_OUTPUT.put_line('[INFO] '||V_COL_UPD2||': '||V_NUM_UPD||' casos actualizados. El filtro no ha producido ningún resultado');
            END IF;


        ELSE
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es POSIBLE realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA_UPD||' con sus campos '||V_COL_UPD1||', '||V_COL_UPD2||' y repita ejecución');
            RETURN;
        END IF;


        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script FASE-513');
        RETURN;

    EXCEPTION
      WHEN MAX_UPD THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('[INFO] ROLLBACK realizado');
      DBMS_OUTPUT.PUT_LINE('[INFO] Fin script FASE-513');
      RAISE;
    END; --END PROCEDURE



    PROCEDURE FASE_514 IS
    BEGIN    
    
        /****************************************************************************************************
        * FASE-514 - Correcciones errores trámite de subasta BANKIA
        ****************************************************************************************************/
        --InicializaCION VAriables
        V_TABLA_UPD   := 'TAP_TAREA_PROCEDIMIENTO';
        V_COL_UPD     := 'TAP_SCRIPT_DECISION';
        V_CODIGO_FADJ := 'TAP_CODIGO';
        V_COL_UPD1    := NULL;
        V_COL_UPD2    := NULL;
        V_COL_UPD3    := NULL;
        V_TABLA1_UPD  := NULL;
        V_T1_COL1_UPD := NULL;
        V_T1_COL2_UPD := NULL;
        V_T1_COL3_UPD := NULL;
        V_T1_COD1_WRE := NULL;
        V_TABLA2_UPD  := NULL;
        V_T2_COL1_UPD := NULL;
        V_T2_COL2_UPD := NULL;
        V_T2_COD1_WRE := NULL;
        V_TABLE_INS   := NULL;
        V_NUM_TABLAS  := NULL;
        V_NUM_UPD     := NULL;
    
        DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* FASE-514 - Correcciones errores trámite de subasta BANKIA                                          ');
        DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');


        --Se verifica si existe la tabla  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = UPPER(''' || V_TABLA_UPD || ''') AND OWNER = UPPER('''||V_ESQUEMA||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA_UPD||', en esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe tabla
            V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA_UPD||'  ' ||
                'SET    '||V_COL_UPD||' = ''valores[''''P401_ValidarPropuesta''''][''''comboResultado''''] == ''''ACE'''' ? (comprobarIsDemandadoPerJuridica() ? ''''lecturaYTributacion'''' : ''''lectura'''') : (valores[''''P401_ValidarPropuesta''''][''''comboResultado''''] == ''''SUS'''' ? ''''SuspenderSubasta'''' : ''''ModificarInstrucciones'''')'' ' ||
                'WHERE  '||V_CODIGO_FADJ||' = ''P401_ValidarPropuesta'' '
                ;
            
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
        ELSE
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es POSIBLE realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA_UPD||' con su campo '||V_COL_UPD||' y repita ejecución');
            RETURN;
        END IF;

        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script FASE-514');
        RETURN;

    END; --END PROCEDURE



    PROCEDURE FASE_526 IS
    BEGIN    
    
        /****************************************************************************************************
        * FASE-526 - Correcciones errores Insert Gestoria trámite tributacion bienes
        ****************************************************************************************************/
        --InicializaCION VAriables
        V_TABLA_UPD   := NULL;
        V_COL_UPD     := NULL;
        V_CODIGO_FADJ := 'DD_GES_CODIGO';
        V_COL_UPD1    := NULL;
        V_COL_UPD2    := NULL;
        V_COL_UPD3    := NULL;
        V_TABLA1_UPD  := NULL;
        V_T1_COL1_UPD := NULL;
        V_T1_COL2_UPD := NULL;
        V_T1_COL3_UPD := NULL;
        V_T1_COD1_WRE := NULL;
        V_TABLA2_UPD  := NULL;
        V_T2_COL1_UPD := NULL;
        V_T2_COL2_UPD := NULL;
        V_T2_COD1_WRE := NULL;
        V_TABLE_INS   := 'DD_GES_GESTORIA';
        V_NUM_TABLAS  := NULL;
        V_NUM_UPD     := NULL;
    
        DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* FASE-526 - Correcciones errores Insert Gestoria trámite tributacion bienes                         ');
        DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');


        DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || V_TABLE_INS || '...');
        FOR I IN V_TIPO_GEST.FIRST .. V_TIPO_GEST.LAST
          LOOP
            V_TMP_TIPO_GEST := V_TIPO_GEST(I);


            --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
            -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
            -----------------------------------------------------------------------------------------------------------
            V_NUM_TABLAS := NULL;
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLE_INS||' WHERE '||V_CODIGO_FADJ||' IN ('''|| V_TMP_TIPO_GEST(1) ||''', '''||V_TMP_TIPO_GEST(2)||''')';
            --DBMS_OUTPUT.PUT_LINE(V_SQL);
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            DBMS_OUTPUT.PUT_LINE('Array codigo '||V_CODIGO_FADJ||' = '''||V_TMP_TIPO_GEST(1)||''' Descripcion = '''||V_TMP_TIPO_GEST(2)||'''---------------------------------'); 
            DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||V_TABLE_INS||', con codigo '||V_CODIGO_FADJ||' = '''||V_TMP_TIPO_GEST(1)||'''...'); 
            IF V_NUM_TABLAS > 0 THEN
                --Existe ya registro en la tabla
                DBMS_OUTPUT.PUT_LINE('OK');
                DBMS_OUTPUT.put_line('[INFO] YA existe un registro en la tabla con codigo '||V_CODIGO_FADJ||' = '''||V_TMP_TIPO_GEST(1)||'''.'); 
            ELSE
                --No existe registro en la tabla
                DBMS_OUTPUT.PUT_LINE('OK');
                DBMS_OUTPUT.put_line('[INFO] NO existe un registro en la tabla '||V_TABLE_INS||', con codigo '||V_CODIGO_FADJ||' = '''||V_TMP_TIPO_GEST(1)||'''');

                -- INSERT REGISTROS en BANK01.DD_GES_GESTORIA
                -- Se insertan solo si la comprobación NO encuentra el registro
                ----------------------------------------------------------------------------------------------------------
                DBMS_OUTPUT.PUT('[INFO] INSERTANDO REGISTRO con codigo '||V_CODIGO_FADJ||' = '''||V_TMP_TIPO_GEST(1)||''' Descripcion = '''||V_TMP_TIPO_GEST(2)||'''...'); 
                V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || V_TABLE_INS || 
                            ' (DD_GES_ID, DD_GES_CODIGO, DD_GES_DESCRIPCION, DD_GES_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO) '||
                            'SELECT '|| V_ESQUEMA||'.S_DD_GES_GESTORIA.nextval ' ||
                             ','''||V_TMP_TIPO_GEST(1)||
                             ''','''||TRIM(V_TMP_TIPO_GEST(2))||
                             ''','''||TRIM(V_TMP_TIPO_GEST(3))||
                             ''','''||TRIM(V_TMP_TIPO_GEST(4))||
                             ''','''||TRIM(V_TMP_TIPO_GEST(5))|| 
                             ''','''||SYSDATE ||''||
                             ''','''||TRIM(V_TMP_TIPO_GEST(6))||
                             ''','''||TRIM(V_TMP_TIPO_GEST(7))||
                             ''','''||TRIM(V_TMP_TIPO_GEST(8))||
                             ''','''||TRIM(V_TMP_TIPO_GEST(9))||
                             ''','||TRIM(V_TMP_TIPO_GEST(10))||
                             ' FROM DUAL';

                    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                    EXECUTE IMMEDIATE V_MSQL;
                
                DBMS_OUTPUT.PUT_LINE('OK');

            END IF;

        END LOOP;

        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script FASE-526');
        RETURN;

    END; --END PROCEDURE



    PROCEDURE FASE_538 IS
    BEGIN    
    
        /****************************************************************************************************
        * FASE-538 - Correcciones errores trámite de demanda incidental
        ****************************************************************************************************/
        --InicializaCION VAriables
        V_TABLA_UPD   := 'TAP_TAREA_PROCEDIMIENTO';
        V_COL_UPD     := NULL;
        V_CODIGO_FADJ := 'TAP_CODIGO';
        V_COL_UPD1    := 'TAP_CODIGO';
        V_COL_UPD2    := 'TAP_SCRIPT_DECISION';
        V_COL_UPD3    := 'TAP_SCRIPT_VALIDACION_JBPM';
        V_TABLA1_UPD  := NULL;
        V_T1_COL1_UPD := NULL;
        V_T1_COL2_UPD := NULL;
        V_T1_COL3_UPD := NULL;
        V_T1_COD1_WRE := NULL;
        V_TABLA2_UPD  := NULL;
        V_T2_COL1_UPD := NULL;
        V_T2_COL2_UPD := NULL;
        V_T2_COD1_WRE := NULL;
        V_TABLE_INS   := NULL;
        V_NUM_TABLAS  := NULL;
        V_NUM_UPD     := NULL;
    
        DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* FASE-538 - Correcciones errores trámite de demanda incidental                                      ');
        DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');


        --Se verifica si existe la tabla  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = UPPER(''' || V_TABLA_UPD || ''') AND OWNER = UPPER('''||V_ESQUEMA||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA_UPD||', en esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe tabla
            V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA_UPD||'  ' ||
                'SET    '||V_COL_UPD1||' = ''P25_admisionOposicionYSenyalamientoVista'' ' ||
                '      ,'||V_COL_UPD2||' = ''(valores[''''P25_admisionOposicionYSenyalamientoVista''''][''''comboVista''''] == DDSiNo.NO || valores[''''P25_admisionOposicionYSenyalamientoVista''''][''''admisionOp''''] == DDSiNo.NO)  ? ''''NO'''' : (valores[''''P25_admisionOposicionYSenyalamientoVista''''][''''comboVista''''] == DDSiNo.SI ? ''''SI'''': ''''NO'''' )'' '  ||
                '      ,'||V_COL_UPD3||' = ''( ((valores[''''P25_admisionOposicionYSenyalamientoVista''''][''''admisionOp''''] == DDSiNo.SI) && (valores[''''P25_admisionOposicionYSenyalamientoVista''''][''''fechaResol''''] == '''''''')) || ((valores[''''P25_admisionOposicionYSenyalamientoVista''''][''''comboVista''''] == DDSiNo.SI) && (valores[''''P25_admisionOposicionYSenyalamientoVista''''][''''fechaVista''''] == '''''''')) )?''''tareaExterna.error.faltaAlgunaFecha'''':null '' ' ||
                'WHERE  '||V_CODIGO_FADJ||' = ''P25_admisionOposicionYSeñalamientoVista'' '
                ;
            
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
        ELSE
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es POSIBLE realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA_UPD||' con sus campos '||V_COL_UPD1||', '||V_COL_UPD2||' y repita ejecución');
            RETURN;
        END IF;

        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script FASE-538');
        RETURN;

    END; --END PROCEDURE
    


    PROCEDURE FASE_540 IS
    BEGIN
    
        /****************************************************************************************************
        * FASE-540 - Correccion error cambiar tarea a supervisor
        ****************************************************************************************************/
        --InicializaCION VAriables
        V_TABLA_UPD   := 'TAP_TAREA_PROCEDIMIENTO';
        V_COL_UPD     := 'DD_STA_ID';
        V_CODIGO_FADJ := 'TAP_CODIGO';
        V_COL_UPD1    := NULL;
        V_COL_UPD2    := NULL;
        V_COL_UPD3    := NULL;
        V_TABLA1_UPD  := NULL;
        V_T1_COL1_UPD := NULL;
        V_T1_COL2_UPD := NULL;
        V_T1_COL3_UPD := NULL;
        V_T1_COD1_WRE := NULL;
        V_TABLA2_UPD  := NULL;
        V_T2_COL1_UPD := NULL;
        V_T2_COL2_UPD := NULL;
        V_T2_COD1_WRE := NULL;
        V_TABLE_INS   := NULL;
        V_NUM_TABLAS  := NULL;
        V_NUM_UPD     := NULL;
    
        DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* FASE-540 - Correccion error cambiar tarea a supervisor                                             ');
        DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');
    
        --Se verifica si existe la tabla  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA_UPD || ''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA_UPD||', en esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe tabla
            V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA_UPD||' '||
                'SET '||V_COL_UPD||' = 40 ' ||
                ' WHERE '||V_CODIGO_FADJ||' =  ''P10_ElaborarLiquidacion'' '
                ;
    
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
        ELSE
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es POSIBLE realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA_UPD||' con su campo '||V_COL_UPD||' y repita ejecución');
            RETURN;
        END IF; 
    
        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script FASE-540');
        RETURN;
        
    END; --END PROCEDURE



    PROCEDURE FASE_541 IS
    BEGIN
    
        /****************************************************************************************************
        * FASE-541 - Correccion error cambiar tarea a supervisor
        ****************************************************************************************************/
        --InicializaCION VAriables
        V_TABLA_UPD   := 'TAP_TAREA_PROCEDIMIENTO';
        V_COL_UPD     := 'DD_STA_ID';
        V_CODIGO_FADJ := 'TAP_CODIGO';
        V_COL_UPD1    := NULL;
        V_COL_UPD2    := NULL;
        V_COL_UPD3    := NULL;
        V_TABLA1_UPD  := NULL;
        V_T1_COL1_UPD := NULL;
        V_T1_COL2_UPD := NULL;
        V_T1_COL3_UPD := NULL;
        V_T1_COD1_WRE := NULL;
        V_TABLA2_UPD  := NULL;
        V_T2_COL1_UPD := NULL;
        V_T2_COL2_UPD := NULL;
        V_T2_COD1_WRE := NULL;
        V_TABLE_INS   := NULL;
        V_NUM_TABLAS  := NULL;
        V_NUM_UPD     := NULL;
    
        DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* FASE-541 - Correccion error cambiar tarea a supervisor                                             ');
        DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');
    
        --Se verifica si existe la tabla  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA_UPD || ''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA_UPD||', en esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe tabla
            V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA_UPD||' '||
                'SET '||V_COL_UPD||' = 40 ' ||
                ' WHERE '||V_CODIGO_FADJ||' IN  (''P12_ObtencionTasacionInterna'', ''P12_EstConformidadOAlegacion'') '
                ;
    
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
        ELSE
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es POSIBLE realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA_UPD||' con su campo '||V_COL_UPD||' y repita ejecución');
            RETURN;
        END IF; 
    
        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script FASE-541');
        RETURN;
        
    END; --END PROCEDURE



    PROCEDURE FASE_556 IS
    BEGIN
    
        /****************************************************************************************************
        * FASE-556 - Correccion error validacion por tap_script_decision
        ****************************************************************************************************/
        --InicializaCION VAriables
        V_TABLA_UPD   := 'TAP_TAREA_PROCEDIMIENTO';
        V_COL_UPD     := 'TAP_SCRIPT_DECISION';
        V_CODIGO_FADJ := 'TAP_CODIGO';
        V_COL_UPD1    := NULL;
        V_COL_UPD2    := NULL;
        V_COL_UPD3    := NULL;
        V_TABLA1_UPD  := NULL;
        V_T1_COL1_UPD := NULL;
        V_T1_COL2_UPD := NULL;
        V_T1_COL3_UPD := NULL;
        V_T1_COD1_WRE := NULL;
        V_TABLA2_UPD  := NULL;
        V_T2_COL1_UPD := NULL;
        V_T2_COL2_UPD := NULL;
        V_T2_COD1_WRE := NULL;
        V_TABLE_INS   := NULL;
        V_NUM_TABLAS  := NULL;
        V_NUM_UPD     := NULL;
    
        DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* FASE-556 - Correccion error validacion por tap_script_decision                                     ');
        DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');
    
        --Se verifica si existe la tabla  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA_UPD || ''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA_UPD||', en esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe tabla
            V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA_UPD||' '||
                'SET '||V_COL_UPD||' =  ''comprobarObraEnCurso() ? ''''hayObraEnCurso'''' : ''''noHayObraEncurso'''''' ' ||
                ' WHERE '||V_CODIGO_FADJ||' = ''P409_AnalizarDUEDiligence''  '
                ;
    
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
        ELSE
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es POSIBLE realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA_UPD||' con su campo '||V_COL_UPD||' y repita ejecución');
            RETURN;
        END IF; 
    
        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script FASE-556');
        RETURN;
        
    END; --END PROCEDURE



    PROCEDURE FASE_566 IS
    BEGIN    
    
        /****************************************************************************************************
        * FASE-566 - Correcciones errores en TFI e insertar un tipo de fondo
        ****************************************************************************************************/
        --InicializaCION VAriables
        V_TABLA_UPD   := NULL;
        V_COL_UPD     := NULL;
        V_CODIGO_FADJ := 'DD_TFO_CODIGO';
        V_COL_UPD1    := NULL;
        V_COL_UPD2    := NULL;
        V_COL_UPD3    := NULL;
        V_TABLA1_UPD  := 'TFI_TAREAS_FORM_ITEMS';
        V_T1_COL1_UPD := 'TFI_TIPO';
        V_T1_COL2_UPD := 'TFI_BUSINESS_OPERATION';
        V_T1_COL3_UPD := NULL;
        V_T1_COD1_WRE := 'TAP_CODIGO';
        V_TABLA2_UPD  := NULL;
        V_T2_COL1_UPD := NULL;
        V_T2_COL2_UPD := NULL;
        V_T2_COD1_WRE := NULL;
        V_TABLE_INS   := 'DD_TFO_TIPO_FONDO';
        V_NUM_TABLAS  := NULL;
        V_NUM_UPD     := NULL;
    
        DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* FASE-566 - Correcciones errores en TFI e insertar un tipo de fondo                                 ');
        DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');

        --UPDATE TFI_TAREAS_FORM_ITEMS
        --Se verifica si existe la tabla  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA1_UPD || ''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA1_UPD||', en esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe tabla
            V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA1_UPD||' '||
                'SET '||V_T1_COL1_UPD||' =  ''label'' ' ||
                '   ,'||V_T1_COL2_UPD||' =  '''' ' ||
                ' WHERE TFI_ORDEN = 0 AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE '||V_T1_COD1_WRE||' = ''P413_notificacionDecretoAdjudicacionAEntidad'')  '
                ;
    
            EXECUTE IMMEDIATE V_MSQL;
            
                    V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA1_UPD||' '||
                'SET '||V_T1_COL1_UPD||' =  ''date'' ' ||
                '   ,'||V_T1_COL2_UPD||' =  '''' ' ||
                ' WHERE TFI_ORDEN = 1 AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE '||V_T1_COD1_WRE||' = ''P413_notificacionDecretoAdjudicacionAEntidad'')  '
                ;
    
            EXECUTE IMMEDIATE V_MSQL;            
            
                    V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA1_UPD||' '||
                'SET '||V_T1_COL1_UPD||' =  ''combo'' ' ||
                '   ,'||V_T1_COL2_UPD||' =  ''DDEntidadAdjudicataria'' ' ||
                ' WHERE TFI_ORDEN = 2 AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE '||V_T1_COD1_WRE||' = ''P413_notificacionDecretoAdjudicacionAEntidad'')  '
                ;
    
            EXECUTE IMMEDIATE V_MSQL;            
            
                    V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA1_UPD||' '||
                'SET '||V_T1_COL1_UPD||' =  ''combo'' ' ||
                '   ,'||V_T1_COL2_UPD||' =  ''DDTipoFondo'' ' ||
                ' WHERE TFI_ORDEN = 3 AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE '||V_T1_COD1_WRE||' = ''P413_notificacionDecretoAdjudicacionAEntidad'')  '
                ;
    
            EXECUTE IMMEDIATE V_MSQL;            
            
                    V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA1_UPD||' '||
                'SET '||V_T1_COL1_UPD||' =  ''combo'' ' ||
                '   ,'||V_T1_COL2_UPD||' =  ''DDSiNo'' ' ||
                ' WHERE TFI_ORDEN = 4 AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE '||V_T1_COD1_WRE||' = ''P413_notificacionDecretoAdjudicacionAEntidad'')  '
                ;
    
            EXECUTE IMMEDIATE V_MSQL;            
            
                    V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA1_UPD||' '||
                'SET '||V_T1_COL1_UPD||' =  ''textarea'' ' ||
                '   ,'||V_T1_COL2_UPD||' =  '''' ' ||
                ' WHERE TFI_ORDEN = 5 AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE '||V_T1_COD1_WRE||' = ''P413_notificacionDecretoAdjudicacionAEntidad'')  '
                ;
    
            	EXECUTE IMMEDIATE V_MSQL;    
            
            DBMS_OUTPUT.PUT_LINE('OK');
        ELSE
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA1_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es POSIBLE realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA1_UPD||' con sus campos '||V_T1_COL1_UPD||', '||V_T1_COL2_UPD||' y repita ejecución');
            RETURN;
        END IF; 

    
        --INSERT DD_TPO_TIPO_FONDO
        /************************************
        * VERIFICACION
        ************************************/
        --EXISTENCIA DE TABLA: Mediante consulta a tablas del sistema se verifica si existe la tabla
        -----------------------------------------------------------------------------------------------------------
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = UPPER(''' || V_TABLE_INS || ''') AND OWNER = UPPER('''||V_ESQUEMA||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla1 a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de la tabla '||V_TABLE_INS||', en esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe correcto
            DBMS_OUTPUT.PUT_LINE('OK');
            DBMS_OUTPUT.put_line('[INFO] SI existe la tabla a actualizar '||V_TABLE_INS);        
        ELSE
            --No existe tabla
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLE_INS);
            DBMS_OUTPUT.put_line('[WARN] NO es posible realizar las acciones de este sub-procedimiento. No es posible insertar registros');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla y repita ejecución');
            RETURN;
        END IF;
    
    
        /********************************************************
        * LOOP INSERT TABLA CON VERIFICACION EXISTENCIA REGISTROS
        *********************************************************/
        FOR I IN V_TIPO_FON.FIRST .. V_TIPO_FON.LAST
          LOOP
            V_ARR_TIPO_FON := V_TIPO_FON(I);
    
            --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
            -- verificacion comparando campo TFA_CODIGO con CODIGO del array
            -----------------------------------------------------------------------------------------------------------
            V_NUM_TABLAS := NULL;
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLE_INS||' WHERE '||V_CODIGO_FADJ||' = '''|| V_ARR_TIPO_FON(1) ||''' ';
            --DBMS_OUTPUT.PUT_LINE(V_SQL);
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
            DBMS_OUTPUT.PUT_LINE('Array codigo '||V_CODIGO_FADJ||' = '''||V_ARR_TIPO_FON(1)||''' Desc = '''||V_ARR_TIPO_FON(2)||'''---------------------------------'); 
            DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla '||V_TABLE_INS||', con codigo '||V_CODIGO_FADJ||' = '''||V_ARR_TIPO_FON(1)||'''...'); 
            IF V_NUM_TABLAS > 0 THEN
                --Existe ya registro en la tabla
                DBMS_OUTPUT.PUT_LINE('OK');
                DBMS_OUTPUT.put_line('[INFO] YA existe un registro en la tabla con codigo '||V_CODIGO_FADJ||' = '''||V_ARR_TIPO_FON(1)||'''...'); 
                DBMS_OUTPUT.PUT('[INFO] Se actualizan los datos por los indicados en el array V_ARR_TIPO_FON...');
                
                V_MSQL := 
                    'UPDATE '||V_ESQUEMA||'.'||V_TABLE_INS||' '||
                    'SET DD_TFO_DESCRIPCION = '''||V_ARR_TIPO_FON(2)||''' ' ||
                    '  , DD_TFO_DESCRIPCION_LARGA = '''||V_ARR_TIPO_FON(3)||''' ' ||
                    '  , VERSION = '''||V_ARR_TIPO_FON(4)||''' ' ||
                    '  , USUARIOMODIFICAR = '''||V_ARR_TIPO_FON(5)||''' ' ||
                    '  , FECHAMODIFICAR = SYSDATE ' ||
                    '  , BORRADO = '''||V_ARR_TIPO_FON(10)||''' ' ||
                    ' WHERE '||V_CODIGO_FADJ||' = '''||V_ARR_TIPO_FON(1)||''' '
                    ;
                    --DBMS_OUTPUT.PUT_LINE(V_MSQL);      
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('OK - Actualizado');
            ELSE
                --No existe registro en la tabla
                DBMS_OUTPUT.PUT_LINE('OK');
                DBMS_OUTPUT.put_line('[INFO] NO existe un registro en la tabla '||V_TABLE_INS||', con codigo '||V_CODIGO_FADJ||' = '''||V_ARR_TIPO_FON(1)||'''');
                --INSERT DE REGISTROS
                -----------------------------------------------------------------------------------------------------------
                DBMS_OUTPUT.PUT('[INFO] Procediendo a insertar el registro...');
                V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || V_TABLE_INS || 
                            ' (DD_TFO_ID, DD_TFO_CODIGO, DD_TFO_DESCRIPCION, DD_TFO_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO) '||
                            'SELECT '|| V_ESQUEMA||'.S_DD_TFO_TIPO_FONDO.NEXTVAL ' ||
                             ','''||TRIM(V_ARR_TIPO_FON(1))||
                             ''','''||TRIM(V_ARR_TIPO_FON(2))||
                             ''','''||TRIM(V_ARR_TIPO_FON(3))||
                             ''','''||TRIM(V_ARR_TIPO_FON(4))||
                             ''','''||TRIM(V_ARR_TIPO_FON(5))||
                             ''','''||SYSDATE ||''||
                             ''','''||TRIM(V_ARR_TIPO_FON(6))||
                             ''','''||TRIM(V_ARR_TIPO_FON(7))||
                             ''','''||TRIM(V_ARR_TIPO_FON(8))||
                             ''','''||TRIM(V_ARR_TIPO_FON(9))||
                             ''', '||TRIM(V_ARR_TIPO_FON(10))||
                             ' FROM DUAL';
        
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('OK - Insertado');
            END IF;
    
   
        END LOOP;
    
        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script FASE-566');
        RETURN;
    
    END; --END PROCEDURE



    PROCEDURE FASE_569 IS
    BEGIN
    
        /****************************************************************************************************
        * FASE-569 - Correccion error validacion de tarea
        ****************************************************************************************************/
        --InicializaCION VAriables
        V_TABLA_UPD   := 'TAP_TAREA_PROCEDIMIENTO';
        V_COL_UPD     := NULL;
        V_CODIGO_FADJ := 'TAP_CODIGO';
        V_COL_UPD1    := 'TAP_SCRIPT_VALIDACION';
        V_COL_UPD2    := 'TAP_SCRIPT_VALIDACION_JBPM';
        V_COL_UPD3    := NULL;
        V_TABLA1_UPD  := NULL;
        V_T1_COL1_UPD := NULL;
        V_T1_COL2_UPD := NULL;
        V_T1_COL3_UPD := NULL;
        V_T1_COD1_WRE := NULL;
        V_TABLA2_UPD  := NULL;
        V_T2_COL1_UPD := NULL;
        V_T2_COL2_UPD := NULL;
        V_T2_COD1_WRE := NULL;
        V_TABLE_INS   := NULL;
        V_NUM_TABLAS  := NULL;
        V_NUM_UPD     := NULL;
    
        DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* FASE-569 - Correccion error validacion de tarea                                                    ');
        DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');
    
        --Se verifica si existe la tabla  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA_UPD || ''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA_UPD||', en esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe tabla
            V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA_UPD||' '||
                'SET '||V_COL_UPD1||' =  ''comprobarGestoriaAsignadaPrc() ? comprobarAdjuntoDecretoFirmeAdjudicacion() ? null : ''''Debe adjuntar el Decreto Firme de Adjudicacion.'''' : ''''Debe asignar la Gestoría encargada de tramitar la adjudicación.'''''' ' ||
                '  , '||V_COL_UPD2||' =  NULL ' ||
                ' WHERE '||V_CODIGO_FADJ||' = ''P413_ConfirmarTestimonio'' '
                ;
    
            EXECUTE IMMEDIATE V_MSQL;

            V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA_UPD||' '||
                'SET '||V_COL_UPD1||' =  ''comprobarAdjuntoDocumentoLiquidacionImpuestos() ? null : ''''Debe adjuntar la copia escaneada del Documento de Liquidación de Impuestos.'''''' ' ||
                '  , '||V_COL_UPD2||' =  NULL ' ||
                ' WHERE '||V_CODIGO_FADJ||' = ''P413_RegistrarPresentacionEnHacienda'' '
                ;
    
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
        ELSE
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es POSIBLE realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA_UPD||' con sus campos '||V_COL_UPD1||', '||V_COL_UPD2||' y repita ejecución');
            RETURN;
        END IF; 
    
        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script FASE-569');
        RETURN;
        
    END; --END PROCEDURE



    PROCEDURE FASE_572 IS
    BEGIN
    
        /****************************************************************************************************
        * FASE-572 - Correccion error de plazo en tarea
        ****************************************************************************************************/
        --InicializaCION VAriables
        V_TABLA_UPD   := 'DD_PTP_PLAZOS_TAREAS_PLAZAS';
        V_COL_UPD     := 'DD_PTP_PLAZO_SCRIPT';
        V_CODIGO_FADJ := 'TAP_CODIGO';
        V_COL_UPD1    := NULL;
        V_COL_UPD2    := NULL;
        V_COL_UPD3    := NULL;
        V_TABLA1_UPD  := NULL;
        V_T1_COL1_UPD := NULL;
        V_T1_COL2_UPD := NULL;
        V_T1_COL3_UPD := NULL;
        V_T1_COD1_WRE := NULL;
        V_TABLA2_UPD  := NULL;
        V_T2_COL1_UPD := NULL;
        V_T2_COL2_UPD := NULL;
        V_T2_COD1_WRE := NULL;
        V_TABLE_INS   := NULL;
        V_NUM_TABLAS  := NULL;
        V_NUM_UPD     := NULL;
    
        DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* FASE-572 - Correccion error de plazo en tarea                                                      ');
        DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');
    
        --Se verifica si existe la tabla  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA_UPD || ''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Actualizando tabla BPM '||V_TABLA_UPD||', en esquema '||V_ESQUEMA||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe tabla
            V_MSQL := 
                'UPDATE '||V_ESQUEMA||'.'||V_TABLA_UPD||' '||
                'SET '||V_COL_UPD||' =   ''damePlazo(valores[''''P25_admisionOposicionYSenyalamientoVista''''][''''fechaVista'''']) + 2*24*60*60*1000L'' ' ||
                'WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE '||V_CODIGO_FADJ||' = ''P25_registrarVista'') '
                ;
    
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('OK');
        ELSE
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es POSIBLE realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA_UPD||' con su campo '||V_COL_UPD||' y repita ejecución');
            RETURN;
        END IF; 
    
        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script FASE-572');
        RETURN;
        
    END; --END PROCEDURE



    PROCEDURE FASE_598 IS
    BEGIN
    
        /****************************************************************************************************
        * FASE-502 - Correccion validaciones JBPM cambio vacios por null - compatibilizar weblogic
        ****************************************************************************************************/
        --InicializaCION VAriables
        V_TABLA_UPD   := 'TAP_TAREA_PROCEDIMIENTO';
        V_COL_UPD     := 'TAP_SCRIPT_VALIDACION_JBPM';
        V_CODIGO_FADJ := NULL;
        V_COL_UPD1    := NULL;
        V_COL_UPD2    := NULL;
        V_COL_UPD3    := NULL;
        V_TABLA1_UPD  := NULL;
        V_T1_COL1_UPD := NULL;
        V_T1_COL2_UPD := NULL;
        V_T1_COL3_UPD := NULL;
        V_T1_COD1_WRE := NULL;
        V_TABLA2_UPD  := NULL;
        V_T2_COL1_UPD := NULL;
        V_T2_COL2_UPD := NULL;
        V_T2_COD1_WRE := NULL;
        V_TABLE_INS   := NULL;
        V_NUM_TABLAS  := NULL;
        V_NUM_UPD     := NULL;
    
        DBMS_OUTPUT.PUT_LINE('/****************************************************************************************************');
        DBMS_OUTPUT.PUT_LINE('* FASE-598 - Correccion validaciones JBPM cambio vacios por null - compatibilizar weblogic           ');
        DBMS_OUTPUT.PUT_LINE('****************************************************************************************************/');
    
        --Se verifica si existe la tabla  en el esquema indicado
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = UPPER(''' || V_TABLA_UPD || ''') AND OWNER = UPPER('''||V_ESQUEMA||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
        -- Solo si existe la tabla a actualizar, se ejecuta el script de actualización
        DBMS_OUTPUT.PUT('[INFO] Realizando correccion ''== ''''''  por  ''== null'' de forma masiva en '||V_TABLA_UPD||'.'||V_COL_UPD||'...'); 
        IF V_NUM_TABLAS > 0 THEN
            --Existe tabla

            -----------------------------------------------------------------------------------------------------
            --PRIMERA CORRECCION == '' POR == null
            -----------------------------------------------------------------------------------------------------

            --Se construye el WHERE común a verificacion y updates/deletes
            V_WHERE := ' '||V_COL_UPD||'  like ''%fecha%==%''''''''%'' ';

            --Se obtiene el número de registros que van a ser alterados o borrados por el filtro común
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_UPD||' WHERE '||V_WHERE;
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_UPD;

            --Se verifica que el filtro de updates masivo no supera el máximo comprobado
            IF V_NUM_UPD > V_MAX_NUM_UPD_598 THEN
                DBMS_OUTPUT.PUT_LINE('KO');
                DBMS_OUTPUT.put_line('[ERROR] El número de registros filtrados para cambiarse/borrarse de este sub-procedimiento supera el máximo definido');
                DBMS_OUTPUT.put_line('[ERROR] El filtro encuentra '||V_NUM_UPD||' registros cuando el máximo a cambiar es '||V_MAX_NUM_UPD_598||' registros');
                DBMS_OUTPUT.put_line('[ERROR] NO es POSIBLE realizar las acciones de este sub-procedimiento');
                DBMS_OUTPUT.put_line('[ERROR] Verifique que sigue siendo correcto el resultado del filtro y solo es que han aparecido más casos desde la dimensión del máximo');
                DBMS_OUTPUT.put_line('[ERROR] Si la comprobación es correcta, cambie el máximo en el parámetro global P_MAX_NUM_UPD_598');
                DBMS_OUTPUT.put_line('[ERROR] Filtro: '||V_WHERE);
                RAISE MAX_UPD; --Provoca error pre-definido y devuelve control a principal
                RETURN;
                --No se cumple esta validación y devuelve el control al procedimiento principal
            END IF;

            --Se verifica que el filtro de updates masivo encuentra registros
            IF V_NUM_UPD > 0 THEN
                --Hay registros para actualizar
                --Realiza el UPDATE masivo
                V_MSQL := 
                    'UPDATE '||V_ESQUEMA||'.'||V_TABLA_UPD||'  ' ||
                    'SET    '||V_COL_UPD||' = replace(replace(replace(replace(tap_script_validacion_jbpm,''   '','' ''),''  '','' ''),''=='''''''''',''== ''''''''''),''== '''''''''',''== null'') ' ||
                    'WHERE  '||V_WHERE
                    ;
                
                DBMS_OUTPUT.PUT_LINE(V_MSQL);
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('OK');
                DBMS_OUTPUT.put_line('[INFO] '||V_COL_UPD||': '||V_NUM_UPD||' casos actualizados.');

            ELSE
                --No hay registros para actualizar
                --Se muestra un mensaje
                DBMS_OUTPUT.PUT_LINE('OK');
                DBMS_OUTPUT.put_line('[INFO] '||V_COL_UPD||': '||V_NUM_UPD||' casos actualizados. El filtro no ha producido ningún resultado');
            END IF;

    
        ELSE
            DBMS_OUTPUT.PUT_LINE('KO');
            DBMS_OUTPUT.put_line('[WARN] NO existe la tabla a actualizar '||V_TABLA_UPD);
            DBMS_OUTPUT.put_line('[WARN] NO es POSIBLE realizar las acciones de este sub-procedimiento');
            DBMS_OUTPUT.put_line('[WARN] Script terminado con problemas. Verifique existencia de la tabla '||V_TABLA_UPD||' con sus campos '||V_COL_UPD1||', '||V_COL_UPD2||', '||V_COL_UPD3||' y repita ejecución');
            RETURN;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[INFO] cambiar ''null'' TAP_SCRIPT_VALIDACION');
        V_MSQL := 'update tap_tarea_procedimiento set tap_script_validacion = replace(tap_script_validacion,''''''null'''''',''null'') where tap_script_validacion like ''%''''null''''%'' ';
      --  DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL;
    
        DBMS_OUTPUT.PUT_LINE('[INFO] Fin script FASE-598');
        RETURN;
        
    END; --END PROCEDURE



BEGIN

    /****************************************
    * PROCEDIMIENTO PRINCIPAL
    ****************************************/

    -- ******** Diccionarios previos ********
    -- No hay

    --Asignación valores constantes en variables GLOBALES
    V_ESQUEMA         := P_ESQUEMA;
    V_MAX_NUM_UPD_503 := P_MAX_NUM_UPD_503;
    V_MAX_NUM_UPD_513 := P_MAX_NUM_UPD_513; 
    V_MAX_NUM_UPD_598 := P_MAX_NUM_UPD_598;


    --InicializaCION VAriables
    V_TABLA_UPD   := NULL;
    V_COL_UPD     := NULL;
    V_CODIGO_FADJ := NULL;    
    V_COL_UPD1    := NULL;
    V_COL_UPD2    := NULL;
    V_COL_UPD3    := NULL;
    V_TABLA1_UPD  := NULL;
    V_T1_COL1_UPD := NULL;
    V_T1_COL2_UPD := NULL;
    V_T1_COL3_UPD := NULL;
    V_T1_COD1_WRE := NULL;
    V_TABLA2_UPD  := NULL;
    V_T2_COL1_UPD := NULL;
    V_T2_COL2_UPD := NULL;
    V_T2_COD1_WRE := NULL;
    V_TABLE_INS   := NULL;

    --LLAMADAS a SUB-PROCEDIMIENTOS

    FASE_502; COMMIT; 
    FASE_503; COMMIT;
    FASE_504; COMMIT;
    FASE_505; COMMIT;
    FASE_507; COMMIT;
    FASE_508; COMMIT;
    FASE_509; COMMIT;
    FASE_510; COMMIT;
    FASE_513; COMMIT;
    FASE_514; COMMIT;
    FASE_526; COMMIT;
    FASE_538; COMMIT;
    FASE_540; COMMIT;
    FASE_541; COMMIT;
    FASE_556; COMMIT;
    FASE_566; COMMIT;
    FASE_569; COMMIT;
    FASE_572; COMMIT;
    FASE_598; COMMIT;


    DBMS_OUTPUT.PUT_LINE('**********************************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('[INFO] COMMIT realizado');
    
    RETURN;

EXCEPTION
  WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.PUT_LINE('KO');
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.PUT_LINE('**********************************************************************************************************');    
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      DBMS_OUTPUT.PUT('[INFO] ROLLBACK realizado');
      RAISE;   
END;
/

EXIT;