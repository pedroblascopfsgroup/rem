--/*
--##########################################
--## AUTOR=Sergio Salt
--## FECHA_CREACION=20190719
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6841
--## PRODUCTO=NO
--## 
--## Finalidad: DML
--## INSTRUCCIONES: Crear BPM Apple
--## VERSIONES:
--##        0.1 Sergio Salt - Versión inicial 
--##
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
declare
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_COUNT NUMBER(16); -- Vble. para contar.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
  V_NUM_REGISTRO NUMBER(16);-- Vble. para validar la existencia de un registro.  
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  TPO_ID NUMBER (16,0); --Vble. Para extraer el ID de la TPO
  TAP_ID NUMBER (16,0); --Vble. Para extraer el ID de la TAP
  TFI_ID NUMBER (16,0); --Vble. Para extraer el ID de la TFI
  PTP_ID NUMBER(16,0); --Vble. Para extraer el ID de la PTP
  -----------------------------------
  ---------  MAPA DE TAREAS  --------
  -----------------------------------  
SCOPE_TAREA NUMBER(16,0) := 0; --Vble. para seleccionar una tarea o todas
  /**********************************
  **
  ** SCOPE_TAREA permite updatear todas las tareas o una en concreto
  ** solo con indicar dicha tarea por su código.
  ** 
  ** IMPORTATNE: commitear los cambios con SCOPE_TAREA = 0 para evitar
  ** fallos en otros entornos/ramas.
  **
  ** El listado de códigos es el siguiente:
  **
  **  0-    TODO EL BPM
  **  1-    DEFINICION DE OFERTA              
  **  2-    Informe Juridico              
  ************************************/
  USUARIOCREAR VARCHAR(1000) := 'HREOS-6516';
  
-----------------DECLARACION DE LA TPO--------------------------
  type tpo_field is table of varchar(5000) index by VARCHAR2(64);
  TPO tpo_field;
 --------------------------------------------------------------- 
------------------DECLARACION DE LA TAP-------------------------
  type tap_content is table of varchar(5000) index by VARCHAR2(64);
  type tap_record is record
  (
    tap_field tap_content
  );

  type t_tap is table of tap_record index by pls_integer;
  TAP t_tap;
 --------------------------------------------------------------- 
 ------------------DECLARACION DE LA PTP-------------------------
  type ptp_content is table of varchar(5000) index by VARCHAR2(64);
  type ptp_record is record
  (
    ptp_field ptp_content
  );

  type t_ptp is table of ptp_record index by pls_integer;
  PTP t_ptp;
 --------------------------------------------------------------- 
------------------DECLARACION DE LA TFI-------------------------
  type tfi_content is table of varchar(5000) index by VARCHAR2(64);
  type tfi_record is record
  (
    tfi_field tfi_content
  );
  type t_tfi is table of tfi_record index by pls_integer;
  type tfi_structure is record
  (
    tfi_field_row t_tfi
  );
    type t_tfi_map is table of tfi_structure index by pls_integer;
    TFI_MAP t_tfi_map;

--------------------------------------------------------------- 
-------------------DECLARACION DE FUNCIONES--------------------
  function is_string  
    (input IN varchar2 ) return varchar2    IS
    null_input exception;
    output varchar2(5000);
    begin
      if input is not null then
            output := '''' || trim(input) || '''';
            return output;
      else 
        raise null_input;
      end if;
      exception 
        when null_input then
          return 'NULL';

    end;
    
  function is_number
    (input IN varchar2 ) return varchar2    IS
    null_input exception;
    output varchar2(5000);
    flag number;
    begin
    
      if input is not null then
        flag := to_number(input);
        return input;
      else 
        raise null_input;
      end if;
      exception 
        when null_input then
          return 'NULL'; 
        when VALUE_ERROR then
         DBMS_OUTPUT.PUT_LINE(input);
         raise VALUE_ERROR;
    end;
  --------------------------------------------------------------- 
  --------------------PROCEDIMIENTO PRINCIPAL--------------------
  procedure create_or_update_bpm (scopeTarea in number) 
  IS
  begin
       IF ScopeTarea < 0 THEN
      DBMS_OUTPUT.PUT_LINE('SE LANZA TODO EL BPM');
      /*SE CREA O SE ACTUALIZA LA TPO*/
      V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME= '|| is_string('DD_TPO_TIPO_PROCEDIMIENTO') || ' and owner = ' || is_string(V_ESQUEMA);
      DBMS_OUTPUT.PUT_LINE(V_SQL);
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      IF V_NUM_TABLAS > 0 THEN
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '||  is_string(TPO('DD_TPO_CODIGO'));
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO; 
        IF V_NUM_REGISTRO > 0 THEN
          DBMS_OUTPUT.PUT_LINE('SE ACTUALIZA EL REGISTRO EN LA TABLA TPO');
          V_SQL := 'UPDATE '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO SET  DD_TPO_CODIGO = '|| is_string(TPO('DD_TPO_CODIGO'))||', '||
          ' DD_TPO_DESCRIPCION = '|| is_string(TPO('DD_TPO_DESCRIPCION'))||', '||' DD_TPO_DESCRIPCION_LARGA = '|| is_string(TPO('DD_TPO_DESCRIPCION_LARGA'))||', '||
          ' DD_TPO_HTML = '|| is_string(TPO('DD_TPO_HTML'))||', '||' DD_TPO_XML_JBPM = '|| is_string(TPO('DD_TPO_XML_JBPM'))||', '||' VERSION = '|| is_number(TPO('VERSION'))||', '||
          ' USUARIOCREAR = '|| is_string(TPO('USUARIOCREAR'))||', '||' FECHACREAR = '|| is_string(TPO('FECHACREAR'))||', '||' USUARIOMODIFICAR = '|| is_string(TPO('USUARIOMODIFICAR'))||', '||
          ' FECHAMODIFICAR = '|| is_string(TPO('FECHAMODIFICAR'))||', '||' USUARIOBORRAR = '|| is_string(TPO('USUARIOBORRAR'))||', '||' FECHABORRAR = '|| is_string(TPO('FECHABORRAR'))||', '||
          ' BORRADO = '|| is_number(TPO('BORRADO'))||', '||' DD_TAC_ID = '|| is_number(TPO('DD_TAC_ID'))||', '||' DD_TPO_SALDO_MIN = '|| is_number(TPO('DD_TPO_SALDO_MIN'))||', '||
          ' DD_TPO_SALDO_MAX = '|| is_number(TPO('DD_TPO_SALDO_MAX'))||', '||' DTYPE = '|| is_string(TPO('DTYPE'))||', '||' FLAG_DERIVABLE = '|| is_number(TPO('FLAG_DERIVABLE'))||', '||
          ' FLAG_UNICO_BIEN = '|| is_number(TPO('FLAG_UNICO_BIEN'))||
          ' WHERE DD_TPO_CODIGO = ' || is_string(TPO('DD_TPO_CODIGO'));
          DBMS_OUTPUT.PUT_LINE('SE LANZA LA QUERY DE ACTUALIZACION DE LA TPO');
          DBMS_OUTPUT.PUT_LINE(V_SQL);
          EXECUTE IMMEDIATE V_SQL;
        ELSE
          DBMS_OUTPUT.PUT_LINE('SE CREA EL REGISTRO EN LA TABLA TPO');
            V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_SQL INTO TPO_ID;
          V_SQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO'||
          ' ( DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR,'||
          ' USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO, DD_TAC_ID,'||
          ' DD_TPO_SALDO_MIN, DD_TPO_SALDO_MAX, FLAG_PRORROGA, DTYPE, FLAG_DERIVABLE, FLAG_UNICO_BIEN ) '||
          ' VALUES '
          ||'( '|| 
                    is_number(TPO_ID) ||', '||is_string(TPO('DD_TPO_CODIGO'))||', '||is_string(TPO('DD_TPO_DESCRIPCION'))||', '||
                    is_string(TPO('DD_TPO_DESCRIPCION_LARGA'))||', '||is_string(TPO('DD_TPO_HTML'))||', '||is_string(TPO('DD_TPO_XML_JBPM')) ||', '||
                    is_number(TPO('VERSION')) ||', '||is_string(TPO('USUARIOCREAR')) ||', '||is_string(TPO('FECHACREAR')) ||', '||
                    is_string(TPO('USUARIOMODIFICAR'))||', '|| is_string(TPO('FECHAMODIFICAR'))||', '||is_string(TPO('USUARIOBORRAR'))||', '||is_string(TPO('FECHABORRAR'))||', '||
                    is_number(TPO('BORRADO'))||', '||is_number(TPO('DD_TAC_ID'))||', '||is_number(TPO('DD_TPO_SALDO_MIN')) ||', '||
                    is_number(TPO('DD_TPO_SALDO_MAX'))||', ' || is_number(TPO('FLAG_PRORROGA'))||', '||is_string(TPO('DTYPE')) ||', ' ||
                    is_number(TPO('FLAG_DERIVABLE'))||', '||is_number(TPO('FLAG_UNICO_BIEN'))
          ||' )' ;
          DBMS_OUTPUT.PUT_LINE('SE LANZA LA QUERY DE INSERCION DE LA TPO');
          DBMS_OUTPUT.PUT_LINE(V_SQL);
          EXECUTE IMMEDIATE V_SQL;
        END IF;
        V_SQL := 'SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ' ||is_string(TPO('DD_TPO_CODIGO'));
        EXECUTE IMMEDIATE V_SQL INTO TPO_ID;
        DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL;
      ELSE
        DBMS_OUTPUT.PUT_LINE('[ERROR] NO SE HA ENCONTRADO LA TABLA [-DD_TPO_TIPO_PROCEDIMIENTO-]');
      END IF;
          DBMS_OUTPUT.PUT_LINE('El id de la TPO es => ');
          DBMS_OUTPUT.PUT_LINE(TPO_ID);
          IF TPO_ID IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('EMPIEZA EL PROCESO DE CREAR O ACTUALIZAR LA TAP'); 
            FOR I IN TAP.FIRST .. TAP.LAST
            LOOP
            V_SQL := 'SELECT count(1) FROM ' ||V_ESQUEMA|| '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ' || is_string(TAP(I).tap_field('TAP_CODIGO'));
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
            IF V_NUM_REGISTRO > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[ACTUALIZAR] TAREA CON CODIGO  = ' || is_string(TAP(I).tap_field('TAP_CODIGO')) ); 
                V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET  TAP_CODIGO = '|| is_string(TAP(I).tap_field('TAP_CODIGO'))||', '||
                ' TAP_VIEW = '|| is_string(TAP(I).tap_field('TAP_VIEW'))||', '||' TAP_SCRIPT_VALIDACION = '|| is_string(TAP(I).tap_field('TAP_SCRIPT_VALIDACION'))||', '||
                ' TAP_SCRIPT_VALIDACION_JBPM = '||is_string(TAP(I).tap_field('TAP_SCRIPT_VALIDACION_JBPM'))||', '||' TAP_SCRIPT_DECISION = '|| is_string(TAP(I).tap_field('TAP_SCRIPT_DECISION'))||', '||
                ' DD_TPO_ID_BPM = '||is_number(TAP(I).tap_field('DD_TPO_ID_BPM'))||', '||
                ' TAP_SUPERVISOR = '|| is_number(TAP(I).tap_field('TAP_SUPERVISOR'))||', '||' TAP_DESCRIPCION = '|| is_string(TAP(I).tap_field('TAP_DESCRIPCION'))||', '||' VERSION = '|| is_number(TAP(I).tap_field('VERSION'))||', '||
                ' USUARIOCREAR = '|| is_string(TAP(I).tap_field('USUARIOCREAR'))||', '||' FECHACREAR = '|| is_string(TAP(I).tap_field('FECHACREAR'))||', '||' USUARIOMODIFICAR = '|| is_string(TAP(I).tap_field('USUARIOMODIFICAR'))||', '||
                ' FECHAMODIFICAR = '|| is_string(TAP(I).tap_field('FECHAMODIFICAR'))||', '||' USUARIOBORRAR = '|| is_string(TAP(I).tap_field('USUARIOBORRAR'))||', '||' FECHABORRAR = '|| is_string(TAP(I).tap_field('FECHABORRAR'))||', '||
                ' BORRADO = '|| is_number(TAP(I).tap_field('BORRADO'))||', '||' TAP_ALERT_NO_RETORNO = '|| is_string(TAP(I).tap_field('TAP_ALERT_NO_RETORNO'))||', '||' TAP_ALERT_VUELTA_ATRAS = '|| is_string(TAP(I).tap_field('TAP_ALERT_VUELTA_ATRAS'))||', '||
                ' DD_FAP_ID = '|| is_number(TAP(I).tap_field('DD_FAP_ID'))||', '||' TAP_AUTOPRORROGA = '|| is_number(TAP(I).tap_field('TAP_AUTOPRORROGA'))||', '||' DTYPE = '|| is_string(TAP(I).tap_field('DTYPE'))||', '||
                ' TAP_MAX_AUTOP = '|| is_number(TAP(I).tap_field('TAP_MAX_AUTOP'))||', '||' DD_TGE_ID = '|| is_number(TAP(I).tap_field('DD_TGE_ID'))||', '||' DD_STA_ID = '|| is_number(TAP(I).tap_field('DD_STA_ID'))||', '||
                ' TAP_EVITAR_REORG = '|| is_number(TAP(I).tap_field('TAP_EVITAR_REORG'))||', '||' DD_TSUP_ID = '|| is_number(TAP(I).tap_field('DD_TSUP_ID'))||', '||' TAP_BUCLE_BPM = '|| is_string(TAP(I).tap_field('TAP_BUCLE_BPM'))||
                ' WHERE TAP_CODIGO = ' || is_string(TAP(I).tap_field('TAP_CODIGO'));
                DBMS_OUTPUT.PUT_LINE('SE LANZA LA QUERY DE ACTUALIZACION DE LA TAP');
                DBMS_OUTPUT.PUT_LINE(V_SQL);
                EXECUTE IMMEDIATE V_SQL;
            
            ELSE
                DBMS_OUTPUT.PUT_LINE('[CREAR] TAREA CON CODIGO  = ' || is_string(TAP(I).tap_field('TAP_CODIGO')) );
                V_SQL := 'SELECT '||V_ESQUEMA||'.S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL FROM DUAL';
                EXECUTE IMMEDIATE V_SQL INTO TAP_ID;
                DBMS_OUTPUT.PUT_LINE('TAP_ID ES = ' ||TAP_ID);
                V_SQL := 'INSERT INTO '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO'||
                ' ( TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_VALIDACION_JBPM, TAP_SCRIPT_DECISION, DD_TPO_ID_BPM, TAP_SUPERVISOR,'||
                ' TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR,'||
                ' USUARIOBORRAR, FECHABORRAR, BORRADO, TAP_ALERT_NO_RETORNO, TAP_ALERT_VUELTA_ATRAS, DD_FAP_ID,  '||
                ' TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_TGE_ID, DD_STA_ID, TAP_EVITAR_REORG,  '||
                ' DD_TSUP_ID, TAP_BUCLE_BPM ) '||
                ' VALUES '
                ||'( '|| 
                    is_number(TAP_ID)||', '||is_number(TPO_ID)||', '||is_string(TAP(I).tap_field('TAP_CODIGO'))||', '||is_string(TAP(I).tap_field('TAP_VIEW'))||', '||
                    is_string(TAP(I).tap_field('TAP_SCRIPT_VALIDACION'))||', '||is_string(TAP(I).tap_field('TAP_SCRIPT_VALIDACION_JBPM'))||', '||
                    is_string(TAP(I).tap_field('TAP_SCRIPT_DECISION'))||', '||is_number(TAP(I).tap_field('DD_TPO_ID_BPM'))||', '||
                    is_number(TAP(I).tap_field('TAP_SUPERVISOR'))||', '||is_string(TAP(I).tap_field('TAP_DESCRIPCION'))||', '||is_number(TAP(I).tap_field('VERSION'))||', '||
                    is_string(TAP(I).tap_field('USUARIOCREAR'))||', '||is_string(TAP(I).tap_field('FECHACREAR'))||', '||is_string(TAP(I).tap_field('USUARIOMODIFICAR'))||', '||
                    is_string(TAP(I).tap_field('FECHAMODIFICAR'))||', '||is_string(TAP(I).tap_field('USUARIOBORRAR'))||', '||
                    is_string(TAP(I).tap_field('FECHABORRAR'))||', '||
                    is_number(TAP(I).tap_field('BORRADO'))||', '||is_string(TAP(I).tap_field('TAP_ALERT_NO_RETORNO'))||', '||is_string(TAP(I).tap_field('TAP_ALERT_VUELTA_ATRAS'))||', '||
                    is_number(TAP(I).tap_field('DD_FAP_ID'))||', '||is_number(TAP(I).tap_field('TAP_AUTOPRORROGA'))||', '||is_string(TAP(I).tap_field('DTYPE'))||', '||
                    is_number(TAP(I).tap_field('TAP_MAX_AUTOP'))||', '||is_number(TAP(I).tap_field('DD_TGE_ID'))||', '||is_number(TAP(I).tap_field('DD_STA_ID'))||', '||
                    is_number(TAP(I).tap_field('TAP_EVITAR_REORG'))||', '||is_number(TAP(I).tap_field('DD_TSUP_ID'))||', '||is_string(TAP(I).tap_field('TAP_BUCLE_BPM'))
                  ||' )' ;
                DBMS_OUTPUT.PUT_LINE('SE LANZA LA QUERY DE INSERCION DE LA TAP');
                DBMS_OUTPUT.PUT_LINE(V_SQL);
                EXECUTE IMMEDIATE V_SQL;
            END IF;
            V_SQL := 'SELECT TAP_ID FROM ' ||V_ESQUEMA|| '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ' || is_string(TAP(I).tap_field('TAP_CODIGO'));
            EXECUTE IMMEDIATE V_SQL INTO TAP_ID;
            IF TAP_ID IS NOT NULL THEN
                V_SQL := 'SELECT count(1) FROM DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID = ' || is_number(TAP_ID);
                DBMS_OUTPUT.PUT_LINE('[INFO] SE CREA O SE ACTUALIZA EL PLAZO DE LA TAREA CON EL ID (TAP_ID) => ' || TAP_ID);
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
                IF V_NUM_REGISTRO > 0 THEN
                    DBMS_OUTPUT.PUT_LINE('[ACTUALIZAR] ACTUALIZACION DEL PLAZO ');
                     V_SQL := 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET  DD_JUZ_ID = '|| is_number(PTP(I).ptp_field('DD_JUZ_ID'))||', '||
                    ' DD_PLA_ID = '|| is_number(PTP(I).ptp_field('DD_PLA_ID'))||', '||' DD_PTP_PLAZO_SCRIPT = '|| is_string(PTP(I).ptp_field('DD_PTP_PLAZO_SCRIPT'))||', '||
                    ' VERSION = '||is_number(PTP(I).ptp_field('VERSION'))||', '||' USUARIOCREAR = '||  is_string(PTP(I).ptp_field('USUARIOCREAR'))||', '||
                    ' FECHACREAR = '||is_string(PTP(I).ptp_field('FECHACREAR'))||', '||' USUARIOMODIFICAR = '||is_string(PTP(I).ptp_field('USUARIOMODIFICAR'))||', '||' FECHAMODIFICAR = '||is_string(PTP(I).ptp_field('FECHAMODIFICAR'))||', '||
                    ' USUARIOBORRAR = '||is_string(PTP(I).ptp_field('USUARIOBORRAR'))||', '||' FECHABORRAR = '||is_string(PTP(I).ptp_field('FECHABORRAR'))||', '||' BORRADO = '||is_number(PTP(I).ptp_field('BORRADO'))||', '||
                    ' DD_PTP_ABSOLUTO = '||is_number(PTP(I).ptp_field('DD_PTP_ABSOLUTO'))||', '||' DD_PTP_OBSERVACIONES = '||is_string(PTP(I).ptp_field('DD_PTP_OBSERVACIONES'))||
                    ' WHERE TAP_ID = ' || is_number(TAP_ID);
                    DBMS_OUTPUT.PUT_LINE('SE LANZA LA QUERY DE ACTUALIZACION DE LA PTP');
                    --DBMS_OUTPUT.PUT_LINE(V_SQL);
                    EXECUTE IMMEDIATE V_SQL;
                ELSE
                DBMS_OUTPUT.PUT_LINE('[CREAR] CREACION DEL PLAZO ');
                V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL FROM DUAL';
                EXECUTE IMMEDIATE V_SQL INTO PTP_ID;
                V_SQL := 'INSERT INTO '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS'||
                ' ( DD_PTP_ID, DD_JUZ_ID, DD_PLA_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR,'||
                ' FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO, DD_PTP_ABSOLUTO, DD_PTP_OBSERVACIONES )'|| 
                ' VALUES '
                ||'( '|| 
                    is_number(PTP_ID)||', '||is_number(PTP(I).ptp_field('DD_JUZ_ID'))||', '||is_number(PTP(I).ptp_field('DD_PLA_ID'))||', '||is_number(TAP_ID)||', '||
                    is_string(PTP(I).ptp_field('DD_PTP_PLAZO_SCRIPT'))||', '||is_number(PTP(I).ptp_field('VERSION'))||', '||is_string(PTP(I).ptp_field('USUARIOCREAR'))||', '||is_string(PTP(I).ptp_field('FECHACREAR'))||', '||
                    is_string(PTP(I).ptp_field('USUARIOMODIFICAR'))||', '||is_string(PTP(I).ptp_field('FECHAMODIFICAR'))||', '||is_string(PTP(I).ptp_field('USUARIOBORRAR'))||', '||is_string(PTP(I).ptp_field('FECHABORRAR'))||', '||
                    is_number(PTP(I).ptp_field('BORRADO'))||', '||is_number(PTP(I).ptp_field('DD_PTP_ABSOLUTO'))||', '||is_string(PTP(I).ptp_field('DD_PTP_OBSERVACIONES'))
                  ||' )' ;
                DBMS_OUTPUT.PUT_LINE('SE LANZA LA QUERY DE INSERCION DE LA PTP');
                DBMS_OUTPUT.PUT_LINE(V_SQL);
                EXECUTE IMMEDIATE V_SQL;
                END IF;
                
              FOR J IN TFI_MAP(I).tfi_field_row.FIRST .. TFI_MAP(I).tfi_field_row.LAST
              LOOP
                DBMS_OUTPUT.PUT_LINE('CREACION O ACTUALIZACION DE LOS TFI');
                V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = ' || is_number(TAP_ID) || ' and TFI_NOMBRE = ' || is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('TFI_NOMBRE'));
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
                IF V_NUM_REGISTRO > 0 THEN
                  DBMS_OUTPUT.PUT_LINE('[ACTUALIZAR] ACTUALIZANDO TAREA_FORM_ITEM CON NOMBRE  = ' || is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('TFI_NOMBRE')) );
                 V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET  TFI_ORDEN = '|| is_number(TFI_MAP(I).tfi_field_row(J).tfi_field('TFI_ORDEN'))||', '||
                      ' TFI_TIPO = '|| is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('TFI_TIPO'))||', '||' TFI_NOMBRE = '|| is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('TFI_NOMBRE'))||', '||
                      ' TFI_LABEL = '||is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('TFI_LABEL'))||', '||' TFI_ERROR_VALIDACION = '|| is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('TFI_ERROR_VALIDACION'))||', '||
                      ' TFI_VALIDACION = '||is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('TFI_VALIDACION'))||', '||
                      ' TFI_VALOR_INICIAL = '||is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('TFI_VALOR_INICIAL'))||', '||
                      ' TFI_BUSINESS_OPERATION = '||is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('TFI_BUSINESS_OPERATION'))||', '||' VERSION = '||is_number(TFI_MAP(I).tfi_field_row(J).tfi_field('VERSION'))||', '||
                      ' USUARIOCREAR = '|| is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('USUARIOCREAR'))||', '||' FECHACREAR = '|| is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('FECHACREAR'))||', '||
                      ' USUARIOMODIFICAR = '|| is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('USUARIOMODIFICAR'))||', '||' FECHAMODIFICAR = '||is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('FECHAMODIFICAR'))||', '||
                      ' USUARIOBORRAR = '|| is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('USUARIOBORRAR'))||', '||' FECHABORRAR = '||  is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('FECHABORRAR'))||', '||
                      ' BORRADO = '|| is_number(TFI_MAP(I).tfi_field_row(J).tfi_field('BORRADO'))||
                      ' WHERE TAP_ID = ' || is_number(TAP_ID) || ' and TFI_NOMBRE = ' || is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('TFI_NOMBRE')) ;
                DBMS_OUTPUT.PUT_LINE('SE LANZA LA QUERY DE ACTUALIZACION DE LA TFI');
                --DBMS_OUTPUT.PUT_LINE(V_SQL);
                EXECUTE IMMEDIATE V_SQL;
                ELSE
                  DBMS_OUTPUT.PUT_LINE('[CREAR] CREANDO TAREA_FORM_ITEM CON NOMBRE  = ' || is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('TFI_NOMBRE')) );
                  V_SQL := 'SELECT '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL FROM DUAL';
                  EXECUTE IMMEDIATE V_SQL INTO TFI_ID;
                  V_SQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS'||
                  ' ( TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_VALOR_INICIAL,'||
                  ' TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR,'||
                  ' USUARIOBORRAR, FECHABORRAR, BORRADO) '||
                  ' VALUES '
                  ||'( '|| 
                      is_number(TFI_ID)||', '||is_number(TAP_ID)||', '||is_number(TFI_MAP(I).tfi_field_row(J).tfi_field('TFI_ORDEN'))||', '||
                      is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('TFI_TIPO'))||', '||is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('TFI_NOMBRE'))||', '||
                      is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('TFI_LABEL'))||', '||is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('TFI_ERROR_VALIDACION'))||', '||
                      is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('TFI_VALIDACION'))||', '||is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('TFI_VALOR_INICIAL'))||', '||
                      is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('TFI_BUSINESS_OPERATION'))||', '||is_number(TFI_MAP(I).tfi_field_row(J).tfi_field('VERSION'))||', '||
                      is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('USUARIOCREAR'))||', '||is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('FECHACREAR'))||', '||
                      is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('USUARIOMODIFICAR'))||', '||is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('FECHAMODIFICAR'))||', '||
                      is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('USUARIOBORRAR'))||', '||is_string(TFI_MAP(I).tfi_field_row(J).tfi_field('FECHABORRAR'))||', '||
                      is_number(TFI_MAP(I).tfi_field_row(J).tfi_field('BORRADO'))
                    ||' )' ;
                DBMS_OUTPUT.PUT_LINE('SE LANZA LA QUERY DE INSERCION DE LA TFI');
                DBMS_OUTPUT.PUT_LINE(V_SQL);
                EXECUTE IMMEDIATE V_SQL;
                END IF;
              END LOOP;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[ERROR] NO SE HA RECUPERADO EL ID DE LA TAP {TAP_ID} EN LA TAREA ' || is_string(TAP(I).tap_field('TAP_CODIGO')));
                ROLLBACK;
            END IF;
            
            END LOOP;
          ELSE 
            DBMS_OUTPUT.PUT_LINE('[ERROR] No se ha recogido ningun valor en la id de la TPO(DD_TPO_ID)');  
            ROLLBACK;
          END IF;
          ---------------------
        ELSE
        DBMS_OUTPUT.PUT_LINE('SE HA SELECCIONADO UNA TAREA');
              /*SE CREA O SE ACTUALIZA LA TPO*/
      V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME= '|| is_string('DD_TPO_TIPO_PROCEDIMIENTO') || ' and owner = ' || is_string(V_ESQUEMA);
      DBMS_OUTPUT.PUT_LINE(V_SQL);
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      IF V_NUM_TABLAS > 0 THEN
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '||  is_string(TPO('DD_TPO_CODIGO'));
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO; 
        IF V_NUM_REGISTRO > 0 THEN
          DBMS_OUTPUT.PUT_LINE('SE ACTUALIZA EL REGISTRO EN LA TABLA TPO');
          V_SQL := 'UPDATE '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO SET  DD_TPO_CODIGO = '|| is_string(TPO('DD_TPO_CODIGO'))||', '||
          ' DD_TPO_DESCRIPCION = '|| is_string(TPO('DD_TPO_DESCRIPCION'))||', '||' DD_TPO_DESCRIPCION_LARGA = '|| is_string(TPO('DD_TPO_DESCRIPCION_LARGA'))||', '||
          ' DD_TPO_HTML = '|| is_string(TPO('DD_TPO_HTML'))||', '||' DD_TPO_XML_JBPM = '|| is_string(TPO('DD_TPO_XML_JBPM'))||', '||' VERSION = '|| is_number(TPO('VERSION'))||', '||
          ' USUARIOCREAR = '|| is_string(TPO('USUARIOCREAR'))||', '||' FECHACREAR = '|| is_string(TPO('FECHACREAR'))||', '||' USUARIOMODIFICAR = '|| is_string(TPO('USUARIOMODIFICAR'))||', '||
          ' FECHAMODIFICAR = '|| is_string(TPO('FECHAMODIFICAR'))||', '||' USUARIOBORRAR = '|| is_string(TPO('USUARIOBORRAR'))||', '||' FECHABORRAR = '|| is_string(TPO('FECHABORRAR'))||', '||
          ' BORRADO = '|| is_number(TPO('BORRADO'))||', '||' DD_TAC_ID = '|| is_number(TPO('DD_TAC_ID'))||', '||' DD_TPO_SALDO_MIN = '|| is_number(TPO('DD_TPO_SALDO_MIN'))||', '||
          ' DD_TPO_SALDO_MAX = '|| is_number(TPO('DD_TPO_SALDO_MAX'))||', '||' DTYPE = '|| is_string(TPO('DTYPE'))||', '||' FLAG_DERIVABLE = '|| is_number(TPO('FLAG_DERIVABLE'))||', '||
          ' FLAG_UNICO_BIEN = '|| is_number(TPO('FLAG_UNICO_BIEN'))||
          ' WHERE DD_TPO_CODIGO = ' || is_string(TPO('DD_TPO_CODIGO'));
          DBMS_OUTPUT.PUT_LINE('SE LANZA LA QUERY DE ACTUALIZACION DE LA TPO');
          DBMS_OUTPUT.PUT_LINE(V_SQL);
          EXECUTE IMMEDIATE V_SQL;
        ELSE
          DBMS_OUTPUT.PUT_LINE('SE CREA EL REGISTRO EN LA TABLA TPO');
            V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_SQL INTO TPO_ID;
          V_SQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO'||
          ' ( DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR,'||
          ' USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO, DD_TAC_ID,'||
          ' DD_TPO_SALDO_MIN, DD_TPO_SALDO_MAX, FLAG_PRORROGA, DTYPE, FLAG_DERIVABLE, FLAG_UNICO_BIEN ) '||
          ' VALUES '
          ||'( '|| 
                    is_number(TPO_ID) ||', '||is_string(TPO('DD_TPO_CODIGO'))||', '||is_string(TPO('DD_TPO_DESCRIPCION'))||', '||
                    is_string(TPO('DD_TPO_DESCRIPCION_LARGA'))||', '||is_string(TPO('DD_TPO_HTML'))||', '||is_string(TPO('DD_TPO_XML_JBPM')) ||', '||
                    is_number(TPO('VERSION')) ||', '||is_string(TPO('USUARIOCREAR')) ||', '||is_string(TPO('FECHACREAR')) ||', '||
                    is_string(TPO('USUARIOMODIFICAR'))||', '|| is_string(TPO('FECHAMODIFICAR'))||', '||is_string(TPO('USUARIOBORRAR'))||', '||is_string(TPO('FECHABORRAR'))||', '||
                    is_number(TPO('BORRADO'))||', '||is_number(TPO('DD_TAC_ID'))||', '||is_number(TPO('DD_TPO_SALDO_MIN')) ||', '||
                    is_number(TPO('DD_TPO_SALDO_MAX'))||', ' || is_number(TPO('FLAG_PRORROGA'))||', '||is_string(TPO('DTYPE')) ||', ' ||
                    is_number(TPO('FLAG_DERIVABLE'))||', '||is_number(TPO('FLAG_UNICO_BIEN'))
          ||' )' ;
          DBMS_OUTPUT.PUT_LINE('SE LANZA LA QUERY DE INSERCION DE LA TPO');
          DBMS_OUTPUT.PUT_LINE(V_SQL);
          EXECUTE IMMEDIATE V_SQL;
        END IF;
        V_SQL := 'SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ' ||is_string(TPO('DD_TPO_CODIGO'));
        EXECUTE IMMEDIATE V_SQL INTO TPO_ID;
        DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL;
      ELSE
        DBMS_OUTPUT.PUT_LINE('[ERROR] NO SE HA ENCONTRADO LA TABLA [-DD_TPO_TIPO_PROCEDIMIENTO-]');
      END IF;
          DBMS_OUTPUT.PUT_LINE('El id de la TPO es => ');
          DBMS_OUTPUT.PUT_LINE(TPO_ID);
          IF TPO_ID IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('EMPIEZA EL PROCESO DE CREAR O ACTUALIZAR LA TAP'); 
            V_SQL := 'SELECT count(1) FROM ' ||V_ESQUEMA|| '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ' || is_string(TAP(scopeTarea).tap_field('TAP_CODIGO'));
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
            IF V_NUM_REGISTRO > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[ACTUALIZAR] TAREA CON CODIGO  = ' || is_string(TAP(scopeTarea).tap_field('TAP_CODIGO')) ); 
                V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET  TAP_CODIGO = '|| is_string(TAP(scopeTarea).tap_field('TAP_CODIGO'))||', '||
                ' TAP_VIEW = '|| is_string(TAP(scopeTarea).tap_field('TAP_VIEW'))||', '||' TAP_SCRIPT_VALIDACION = '|| is_string(TAP(scopeTarea).tap_field('TAP_SCRIPT_VALIDACION'))||', '||
                ' TAP_SCRIPT_VALIDACION_JBPM = '||is_string(TAP(scopeTarea).tap_field('TAP_SCRIPT_VALIDACION_JBPM'))||', '||' TAP_SCRIPT_DECISION = '|| is_string(TAP(scopeTarea).tap_field('TAP_SCRIPT_DECISION'))||', '||
                ' DD_TPO_ID_BPM = '||is_number(TAP(scopeTarea).tap_field('DD_TPO_ID_BPM'))||', '||
                ' TAP_SUPERVISOR = '|| is_number(TAP(scopeTarea).tap_field('TAP_SUPERVISOR'))||', '||' TAP_DESCRIPCION = '|| is_string(TAP(scopeTarea).tap_field('TAP_DESCRIPCION'))||', '||' VERSION = '|| is_number(TAP(scopeTarea).tap_field('VERSION'))||', '||
                ' USUARIOCREAR = '|| is_string(TAP(scopeTarea).tap_field('USUARIOCREAR'))||', '||' FECHACREAR = '|| is_string(TAP(scopeTarea).tap_field('FECHACREAR'))||', '||' USUARIOMODIFICAR = '|| is_string(TAP(scopeTarea).tap_field('USUARIOMODIFICAR'))||', '||
                ' FECHAMODIFICAR = '|| is_string(TAP(scopeTarea).tap_field('FECHAMODIFICAR'))||', '||' USUARIOBORRAR = '|| is_string(TAP(scopeTarea).tap_field('USUARIOBORRAR'))||', '||' FECHABORRAR = '|| is_string(TAP(scopeTarea).tap_field('FECHABORRAR'))||', '||
                ' BORRADO = '|| is_number(TAP(scopeTarea).tap_field('BORRADO'))||', '||' TAP_ALERT_NO_RETORNO = '|| is_string(TAP(scopeTarea).tap_field('TAP_ALERT_NO_RETORNO'))||', '||' TAP_ALERT_VUELTA_ATRAS = '|| is_string(TAP(scopeTarea).tap_field('TAP_ALERT_VUELTA_ATRAS'))||', '||
                ' DD_FAP_ID = '|| is_number(TAP(scopeTarea).tap_field('DD_FAP_ID'))||', '||' TAP_AUTOPRORROGA = '|| is_number(TAP(scopeTarea).tap_field('TAP_AUTOPRORROGA'))||', '||' DTYPE = '|| is_string(TAP(scopeTarea).tap_field('DTYPE'))||', '||
                ' TAP_MAX_AUTOP = '|| is_number(TAP(scopeTarea).tap_field('TAP_MAX_AUTOP'))||', '||' DD_TGE_ID = '|| is_number(TAP(scopeTarea).tap_field('DD_TGE_ID'))||', '||' DD_STA_ID = '|| is_number(TAP(scopeTarea).tap_field('DD_STA_ID'))||', '||
                ' TAP_EVITAR_REORG = '|| is_number(TAP(scopeTarea).tap_field('TAP_EVITAR_REORG'))||', '||' DD_TSUP_ID = '|| is_number(TAP(scopeTarea).tap_field('DD_TSUP_ID'))||', '||' TAP_BUCLE_BPM = '|| is_string(TAP(scopeTarea).tap_field('TAP_BUCLE_BPM'))||
                ' WHERE TAP_CODIGO = ' || is_string(TAP(scopeTarea).tap_field('TAP_CODIGO'));
                DBMS_OUTPUT.PUT_LINE('SE LANZA LA QUERY DE ACTUALIZACION DE LA TAP');
                DBMS_OUTPUT.PUT_LINE(V_SQL);
                EXECUTE IMMEDIATE V_SQL;
            
            ELSE
                DBMS_OUTPUT.PUT_LINE('[CREAR] TAREA CON CODIGO  = ' || is_string(TAP(scopeTarea).tap_field('TAP_CODIGO')) );
                V_SQL := 'SELECT '||V_ESQUEMA||'.S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL FROM DUAL';
                EXECUTE IMMEDIATE V_SQL INTO TAP_ID;
                DBMS_OUTPUT.PUT_LINE('TAP_ID ES = ' ||TAP_ID);
                V_SQL := 'INSERT INTO '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO'||
                ' ( TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_VALIDACION_JBPM, TAP_SCRIPT_DECISION, DD_TPO_ID_BPM, TAP_SUPERVISOR,'||
                ' TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR,'||
                ' USUARIOBORRAR, FECHABORRAR, BORRADO, TAP_ALERT_NO_RETORNO, TAP_ALERT_VUELTA_ATRAS, DD_FAP_ID,  '||
                ' TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_TGE_ID, DD_STA_ID, TAP_EVITAR_REORG,  '||
                ' DD_TSUP_ID, TAP_BUCLE_BPM ) '||
                ' VALUES '
                ||'( '|| 
                    is_number(TAP_ID)||', '||is_number(TPO_ID)||', '||is_string(TAP(scopeTarea).tap_field('TAP_CODIGO'))||', '||is_string(TAP(scopeTarea).tap_field('TAP_VIEW'))||', '||
                    is_string(TAP(scopeTarea).tap_field('TAP_SCRIPT_VALIDACION'))||', '||is_string(TAP(scopeTarea).tap_field('TAP_SCRIPT_VALIDACION_JBPM'))||', '||
                    is_string(TAP(scopeTarea).tap_field('TAP_SCRIPT_DECISION'))||', '||is_number(TAP(scopeTarea).tap_field('DD_TPO_ID_BPM'))||', '||
                    is_number(TAP(scopeTarea).tap_field('TAP_SUPERVISOR'))||', '||is_string(TAP(scopeTarea).tap_field('TAP_DESCRIPCION'))||', '||is_number(TAP(scopeTarea).tap_field('VERSION'))||', '||
                    is_string(TAP(scopeTarea).tap_field('USUARIOCREAR'))||', '||is_string(TAP(scopeTarea).tap_field('FECHACREAR'))||', '||is_string(TAP(scopeTarea).tap_field('USUARIOMODIFICAR'))||', '||
                    is_string(TAP(scopeTarea).tap_field('FECHAMODIFICAR'))||', '||is_string(TAP(scopeTarea).tap_field('USUARIOBORRAR'))||', '||
                    is_string(TAP(scopeTarea).tap_field('FECHABORRAR'))||', '||
                    is_number(TAP(scopeTarea).tap_field('BORRADO'))||', '||is_string(TAP(scopeTarea).tap_field('TAP_ALERT_NO_RETORNO'))||', '||is_string(TAP(scopeTarea).tap_field('TAP_ALERT_VUELTA_ATRAS'))||', '||
                    is_number(TAP(scopeTarea).tap_field('DD_FAP_ID'))||', '||is_number(TAP(scopeTarea).tap_field('TAP_AUTOPRORROGA'))||', '||is_string(TAP(scopeTarea).tap_field('DTYPE'))||', '||
                    is_number(TAP(scopeTarea).tap_field('TAP_MAX_AUTOP'))||', '||is_number(TAP(scopeTarea).tap_field('DD_TGE_ID'))||', '||is_number(TAP(scopeTarea).tap_field('DD_STA_ID'))||', '||
                    is_number(TAP(scopeTarea).tap_field('TAP_EVITAR_REORG'))||', '||is_number(TAP(scopeTarea).tap_field('DD_TSUP_ID'))||', '||is_string(TAP(scopeTarea).tap_field('TAP_BUCLE_BPM'))
                  ||' )' ;
                DBMS_OUTPUT.PUT_LINE('SE LANZA LA QUERY DE INSERCION DE LA TAP');
                DBMS_OUTPUT.PUT_LINE(V_SQL);
                EXECUTE IMMEDIATE V_SQL;
            END IF;
            V_SQL := 'SELECT TAP_ID FROM ' ||V_ESQUEMA|| '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ' || is_string(TAP(scopeTarea).tap_field('TAP_CODIGO'));
            EXECUTE IMMEDIATE V_SQL INTO TAP_ID;
            IF TAP_ID IS NOT NULL THEN
                V_SQL := 'SELECT count(1) FROM DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID = ' || is_number(TAP_ID);
                DBMS_OUTPUT.PUT_LINE('[INFO] SE CREA O SE ACTUALIZA EL PLAZO DE LA TAREA CON EL ID (TAP_ID) => ' || TAP_ID);
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
                IF V_NUM_REGISTRO > 0 THEN
                    DBMS_OUTPUT.PUT_LINE('[ACTUALIZAR] ACTUALIZACION DEL PLAZO ');
                     V_SQL := 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET  DD_JUZ_ID = '|| is_number(PTP(scopeTarea).ptp_field('DD_JUZ_ID'))||', '||
                    ' DD_PLA_ID = '|| is_number(PTP(scopeTarea).ptp_field('DD_PLA_ID'))||', '||' DD_PTP_PLAZO_SCRIPT = '|| is_string(PTP(scopeTarea).ptp_field('DD_PTP_PLAZO_SCRIPT'))||', '||
                    ' VERSION = '||is_number(PTP(scopeTarea).ptp_field('VERSION'))||', '||' USUARIOCREAR = '||  is_string(PTP(scopeTarea).ptp_field('USUARIOCREAR'))||', '||
                    ' FECHACREAR = '||is_string(PTP(scopeTarea).ptp_field('FECHACREAR'))||', '||' USUARIOMODIFICAR = '||is_string(PTP(scopeTarea).ptp_field('USUARIOMODIFICAR'))||', '||' FECHAMODIFICAR = '||is_string(PTP(scopeTarea).ptp_field('FECHAMODIFICAR'))||', '||
                    ' USUARIOBORRAR = '||is_string(PTP(scopeTarea).ptp_field('USUARIOBORRAR'))||', '||' FECHABORRAR = '||is_string(PTP(scopeTarea).ptp_field('FECHABORRAR'))||', '||' BORRADO = '||is_number(PTP(scopeTarea).ptp_field('BORRADO'))||', '||
                    ' DD_PTP_ABSOLUTO = '||is_number(PTP(scopeTarea).ptp_field('DD_PTP_ABSOLUTO'))||', '||' DD_PTP_OBSERVACIONES = '||is_string(PTP(scopeTarea).ptp_field('DD_PTP_OBSERVACIONES'))||
                    ' WHERE TAP_ID = ' || is_number(TAP_ID);
                    DBMS_OUTPUT.PUT_LINE('SE LANZA LA QUERY DE ACTUALIZACION DE LA PTP');
                    --DBMS_OUTPUT.PUT_LINE(V_SQL);
                    EXECUTE IMMEDIATE V_SQL;
                ELSE
                DBMS_OUTPUT.PUT_LINE('[CREAR] CREACION DEL PLAZO ');
                V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL FROM DUAL';
                EXECUTE IMMEDIATE V_SQL INTO PTP_ID;
                V_SQL := 'INSERT INTO '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS'||
                ' ( DD_PTP_ID, DD_JUZ_ID, DD_PLA_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR,'||
                ' FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO, DD_PTP_ABSOLUTO, DD_PTP_OBSERVACIONES )'|| 
                ' VALUES '
                ||'( '|| 
                    is_number(PTP_ID)||', '||is_number(PTP(scopeTarea).ptp_field('DD_JUZ_ID'))||', '||is_number(PTP(scopeTarea).ptp_field('DD_PLA_ID'))||', '||is_number(TAP_ID)||', '||
                    is_string(PTP(scopeTarea).ptp_field('DD_PTP_PLAZO_SCRIPT'))||', '||is_number(PTP(scopeTarea).ptp_field('VERSION'))||', '||is_string(PTP(scopeTarea).ptp_field('USUARIOCREAR'))||', '||is_string(PTP(scopeTarea).ptp_field('FECHACREAR'))||', '||
                    is_string(PTP(scopeTarea).ptp_field('USUARIOMODIFICAR'))||', '||is_string(PTP(scopeTarea).ptp_field('FECHAMODIFICAR'))||', '||is_string(PTP(scopeTarea).ptp_field('USUARIOBORRAR'))||', '||is_string(PTP(scopeTarea).ptp_field('FECHABORRAR'))||', '||
                    is_number(PTP(scopeTarea).ptp_field('BORRADO'))||', '||is_number(PTP(scopeTarea).ptp_field('DD_PTP_ABSOLUTO'))||', '||is_string(PTP(scopeTarea).ptp_field('DD_PTP_OBSERVACIONES'))
                  ||' )' ;
                DBMS_OUTPUT.PUT_LINE('SE LANZA LA QUERY DE INSERCION DE LA PTP');
                DBMS_OUTPUT.PUT_LINE(V_SQL);
                EXECUTE IMMEDIATE V_SQL;
                END IF;
                
              FOR J IN TFI_MAP(scopeTarea).tfi_field_row.FIRST .. TFI_MAP(scopeTarea).tfi_field_row.LAST
              LOOP
                DBMS_OUTPUT.PUT_LINE('CREACION O ACTUALIZACION DE LOS TFI');
                V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = ' || is_number(TAP_ID) || ' and TFI_NOMBRE = ' || is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('TFI_NOMBRE'));
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
                IF V_NUM_REGISTRO > 0 THEN
                  DBMS_OUTPUT.PUT_LINE('[ACTUALIZAR] ACTUALIZANDO TAREA_FORM_ITEM CON NOMBRE  = ' || is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('TFI_NOMBRE')) );
                 V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET  TFI_ORDEN = '|| is_number(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('TFI_ORDEN'))||', '||
                      ' TFI_TIPO = '|| is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('TFI_TIPO'))||', '||' TFI_NOMBRE = '|| is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('TFI_NOMBRE'))||', '||
                      ' TFI_LABEL = '||is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('TFI_LABEL'))||', '||' TFI_ERROR_VALIDACION = '|| is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('TFI_ERROR_VALIDACION'))||', '||
                      ' TFI_VALIDACION = '||is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('TFI_VALIDACION'))||', '||
                      ' TFI_VALOR_INICIAL = '||is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('TFI_VALOR_INICIAL'))||', '||
                      ' TFI_BUSINESS_OPERATION = '||is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('TFI_BUSINESS_OPERATION'))||', '||' VERSION = '||is_number(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('VERSION'))||', '||
                      ' USUARIOCREAR = '|| is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('USUARIOCREAR'))||', '||' FECHACREAR = '|| is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('FECHACREAR'))||', '||
                      ' USUARIOMODIFICAR = '|| is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('USUARIOMODIFICAR'))||', '||' FECHAMODIFICAR = '||is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('FECHAMODIFICAR'))||', '||
                      ' USUARIOBORRAR = '|| is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('USUARIOBORRAR'))||', '||' FECHABORRAR = '||  is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('FECHABORRAR'))||', '||
                      ' BORRADO = '|| is_number(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('BORRADO'))||
                      ' WHERE TAP_ID = ' || is_number(TAP_ID) || ' and TFI_NOMBRE = ' || is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('TFI_NOMBRE')) ;
                DBMS_OUTPUT.PUT_LINE('SE LANZA LA QUERY DE ACTUALIZACION DE LA TFI');
                --DBMS_OUTPUT.PUT_LINE(V_SQL);
                EXECUTE IMMEDIATE V_SQL;
                ELSE
                  DBMS_OUTPUT.PUT_LINE('[CREAR] CREANDO TAREA_FORM_ITEM CON NOMBRE  = ' || is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('TFI_NOMBRE')) );
                  V_SQL := 'SELECT '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL FROM DUAL';
                  EXECUTE IMMEDIATE V_SQL INTO TFI_ID;
                  V_SQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS'||
                  ' ( TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_VALOR_INICIAL,'||
                  ' TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR,'||
                  ' USUARIOBORRAR, FECHABORRAR, BORRADO) '||
                  ' VALUES '
                  ||'( '|| 
                      is_number(TFI_ID)||', '||is_number(TAP_ID)||', '||is_number(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('TFI_ORDEN'))||', '||
                      is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('TFI_TIPO'))||', '||is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('TFI_NOMBRE'))||', '||
                      is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('TFI_LABEL'))||', '||is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('TFI_ERROR_VALIDACION'))||', '||
                      is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('TFI_VALIDACION'))||', '||is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('TFI_VALOR_INICIAL'))||', '||
                      is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('TFI_BUSINESS_OPERATION'))||', '||is_number(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('VERSION'))||', '||
                      is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('USUARIOCREAR'))||', '||is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('FECHACREAR'))||', '||
                      is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('USUARIOMODIFICAR'))||', '||is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('FECHAMODIFICAR'))||', '||
                      is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('USUARIOBORRAR'))||', '||is_string(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('FECHABORRAR'))||', '||
                      is_number(TFI_MAP(scopeTarea).tfi_field_row(J).tfi_field('BORRADO'))
                    ||' )' ;
                DBMS_OUTPUT.PUT_LINE('SE LANZA LA QUERY DE INSERCION DE LA TFI');
                DBMS_OUTPUT.PUT_LINE(V_SQL);
                EXECUTE IMMEDIATE V_SQL;
                END IF;
              END LOOP;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[ERROR] NO SE HA RECUPERADO EL ID DE LA TAP {TAP_ID} EN LA TAREA ' || is_string(TAP(scopeTarea).tap_field('TAP_CODIGO')));
                ROLLBACK;
            END IF;
          ELSE 
            DBMS_OUTPUT.PUT_LINE('[ERROR] No se ha recogido ningun valor en la id de la TPO(DD_TPO_ID)');  
            ROLLBACK;
          END IF;
        END IF;
  end;

begin
---------------------- MAPEO DE TPO-----------------------------------------
-- EN CASO DE CREACION SE INICIALIZA LA ID EN EL PROCEDIMIENTO PRINCIPAL----
  TPO('DD_TPO_CODIGO')            := 'T013';
  TPO('DD_TPO_DESCRIPCION')       := 'Trámite comercial venta';
  TPO('DD_TPO_DESCRIPCION_LARGA') := 'Trámite comercial venta';
  TPO('DD_TPO_HTML')              :=  NULL;
  TPO('DD_TPO_XML_JBPM')          := 'activo_tramiteSancionOferta';
  TPO('VERSION')                  := 1;
  TPO('USUARIOCREAR')             := USUARIOCREAR;
  TPO('FECHACREAR')               :=  SYSDATE;
  TPO('USUARIOMODIFICAR')         :=  NULL;
  TPO('FECHAMODIFICAR')           := NULL;
  TPO('USUARIOBORRAR')            := NULL;
  TPO('FECHABORRAR')              := NULL;
  TPO('BORRADO')                  := 0;
  V_SQL := 'SELECT DD_TAC_ID FROM '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ' || is_string('GES');
  EXECUTE IMMEDIATE V_SQL INTO TPO('DD_TAC_ID');
  TPO('DD_TPO_SALDO_MIN')         := NULL;
  TPO('DD_TPO_SALDO_MAX')         := NULL;
  TPO('FLAG_PRORROGA')            := 1;
  TPO('DTYPE')                    := 'MEJTipoProcedimiento';
  TPO('FLAG_DERIVABLE')           := 1;
  TPO('FLAG_UNICO_BIEN')          := 0;
----------------------------------------------------------------------------
---------------------- MAPEO DE TAP_TAREA_PROCEDIMIENTO---------------------
  /*NOTA : En caso de que se cree una nueva tarea se inicializa la secuencia
          en el  procedimiento principal (TAP_ID) al igual que el (TPO_ID) */
  
  ------------------DEFINICION DE OFERTA------------------------------------
  TAP(0).tap_field('TAP_CODIGO') := 'T013_DefinicionOferta';
  TAP(0).tap_field('TAP_VIEW') := NULL;
  TAP(0).tap_field('TAP_SCRIPT_VALIDACION') := 'checkImporteParticipacion() ? checkCamposComprador() ? checkCompradores() ? checkVendido() ? ''''El activo est&aacute; vendido'''' : checkComercializable() ? checkBankia() ? checkImpuestos() ? null : ''''Debe indicar el tipo de impuesto y tipo aplicable.''''  : null : ''''El activo debe ser comercializable'''' : ''''Los compradores deben sumar el 100%'''' : ''''Es necesario cumplimentar todos los campos obligatorios de los compradores para avanzar la tarea.'''' : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''';
  TAP(0).tap_field('TAP_SCRIPT_VALIDACION_JBPM') := 'existeAdjuntoUGCarteraValidacion("36", "E", "01") == null ? valores[''''T013_DefinicionOferta''''][''''comboConflicto''''] == DDSiNo.SI || valores[''''T013_DefinicionOferta''''][''''comboRiesgo''''] == DDSiNo.SI  ?  ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' : comprobarComiteLiberbankPlantillaPropuesta() ? existeAdjuntoUGCarteraValidacion("36", "E", "08") : definicionOfertaT013(valores[''''T013_DefinicionOferta''''][''''comiteSuperior''''])  : existeAdjuntoUGCarteraValidacion("36", "E", "01")';
  TAP(0).tap_field('TAP_SCRIPT_DECISION') := 'checkFormalizacion() ? valores[''''T013_DefinicionOferta''''][''''comiteSuperior''''] != DDSiNo.SI ? checkAtribuciones() ? checkReserva() == false ? esYubai() ? ''''esYubai'''': ''''ConFormalizacionSinTanteoConAtribucionSinReservaSinTanteo'''' : esYubai() ? ''''esYubai'''' : ''''ConFormalizacionSinTanteoConAtribucionConReserva'''' : ''''ConFormalizacionSinTanteoSinAtribucion''''  : ''''ConFormalizacionSinTanteoSinAtribucion'''' : ''''SinFormalizacion''''';
  TAP(0).tap_field('DD_TPO_ID_BPM') := null;
  TAP(0).tap_field('TAP_SUPERVISOR') := 0;
  TAP(0).tap_field('TAP_DESCRIPCION') := 'Definición oferta';
  TAP(0).tap_field('VERSION') := 0;
  TAP(0).tap_field('USUARIOCREAR') := USUARIOCREAR;
  TAP(0).tap_field('FECHACREAR') := SYSDATE;
  TAP(0).tap_field('USUARIOMODIFICAR') := NULL;
  TAP(0).tap_field('FECHAMODIFICAR') := NULL;
  TAP(0).tap_field('USUARIOBORRAR') := NULL;
  TAP(0).tap_field('FECHABORRAR') := NULL;
  TAP(0).tap_field('BORRADO') := 0;
  TAP(0).tap_field('TAP_ALERT_NO_RETORNO') := NULL;
  TAP(0).tap_field('TAP_ALERT_VUELTA_ATRAS') := NULL;
  TAP(0).tap_field('DD_FAP_ID') := NULL;
  TAP(0).tap_field('TAP_AUTOPRORROGA') := 0;
  TAP(0).tap_field('DTYPE') := 'EXTTareaProcedimiento';
  TAP(0).tap_field('TAP_MAX_AUTOP') := 3;
  V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ' || is_string('GCOM');
  EXECUTE IMMEDIATE V_SQL INTO TAP(0).tap_field('DD_TGE_ID');
  V_SQL := 'SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ' || is_string('811');
  EXECUTE IMMEDIATE V_SQL INTO TAP(0).tap_field('DD_STA_ID');
  TAP(0).tap_field('TAP_EVITAR_REORG') := NULL;
  TAP(0).tap_field('DD_TSUP_ID') := NULL;
  TAP(0).tap_field('TAP_BUCLE_BPM') := NULL;
  ----------------------------------------------------------------------------
----------------------- MAPEO DE PTP PLAZOS--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL PTP_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------
    --PTP(0).ptp_field('DD_PTP_ID'); SE RECUPERA / GENERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(0).ptp_field('DD_JUZ_ID') := null;
    PTP(0).ptp_field('DD_PLA_ID') := null;
    --PTP(0).ptp_field('TAP_ID'); SE RECUPERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(0).ptp_field('DD_PTP_PLAZO_SCRIPT') := '3*24*60*60*1000L';
    PTP(0).ptp_field('VERSION') := 1;
    PTP(0).ptp_field('USUARIOCREAR') := USUARIOCREAR;
    PTP(0).ptp_field('FECHACREAR') := SYSDATE;
    PTP(0).ptp_field('USUARIOMODIFICAR') := null;
    PTP(0).ptp_field('FECHAMODIFICAR') := null;
    PTP(0).ptp_field('USUARIOBORRAR') := null;
    PTP(0).ptp_field('FECHABORRAR') :=null;
    PTP(0).ptp_field('BORRADO') := 0;
    PTP(0).ptp_field('DD_PTP_ABSOLUTO') := 0;
    PTP(0).ptp_field('DD_PTP_OBSERVACIONES') := null;
    
----------------------------------------------------------------------------
----------------------- MAPEO DE TFI PROCEDIMIENTO--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL TFI_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------

--------------FORM ITEMS----#DEFINICION DE OFERTA#--------------------------
  TFI_MAP(0).tfi_field_row(0).tfi_field('TFI_ORDEN') := 0;
  TFI_MAP(0).tfi_field_row(0).tfi_field('TFI_TIPO') := 'label';
  TFI_MAP(0).tfi_field_row(0).tfi_field('TFI_NOMBRE') := 'titulo';
  TFI_MAP(0).tfi_field_row(0).tfi_field('TFI_LABEL') :=  '<p style="margin-bottom: 10px">
  Ha aceptado una oferta y se ha creado un expediente comercial asociado a la misma. 
  A continuación  debería rellenar todos los campos necesarios para definir la oferta, pudiendo darse la siguiente casuística para finalizar la tarea 
  </p> 
  <p style="margin-bottom: 10px">A) Si tiene atribuciones para sancionar la oferta:<br />
  i) Si el activo está dentro del perímetro de formalización al pulsar el botón Aceptar finalizará esta tarea y se le lanzará a la gestoría de  formalización una nueva tarea para la realización del "Informe jurídico".<br />  
  ii) Si el activo no se encuentra dentro del perímetro de formalización, la siguiente tarea que se lanzará es "Firma por el propietario".</p> 	
  <p style="margin-bottom: 10px"> B) Si no tiene atribuciones para sancionar la oferta, deberá preparar la propuesta y remitirla al comité sancionador, indicando  abajo la fecha de envío.</p> 
  <p style="margin-bottom: 10px"> C) El presente expediente tiene origen en el ejercicio del derecho de tanteo y retracto administrativo, por lo que la oferta ya fue aprobada en su momento.
  De ser así, marque el check dispuesto al efecto, identificando el nº de expediente origen, para que el trámite vaya directamente a la tarea de "Posicionamiento y firma".
  </p> 
  <p style="margin-bottom: 10px"> 
  En cualquier caso, para poder finalizar la tarea, tiene que reflejar si existe riesgo reputacional y/o conflicto de intereses en la Ficha del expediente.
  </p> 
  <p style="margin-bottom: 10px"> 
  En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite 
  </p>';
  TFI_MAP(0).tfi_field_row(0).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(0).tfi_field_row(0).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(0).tfi_field_row(0).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(0).tfi_field_row(0).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(0).tfi_field_row(0).tfi_field('VERSION') := 1;
  TFI_MAP(0).tfi_field_row(0).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(0).tfi_field_row(0).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(0).tfi_field_row(0).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(0).tfi_field_row(0).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(0).tfi_field_row(0).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(0).tfi_field_row(0).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(0).tfi_field_row(0).tfi_field('BORRADO') := 0;
  
  TFI_MAP(0).tfi_field_row(1).tfi_field('TFI_ORDEN') := 1;
  TFI_MAP(0).tfi_field_row(1).tfi_field('TFI_TIPO') := 'comboboxreadonly';
  TFI_MAP(0).tfi_field_row(1).tfi_field('TFI_NOMBRE') := 'comite';
  TFI_MAP(0).tfi_field_row(1).tfi_field('TFI_LABEL') :=  'Comité sancionador';
  TFI_MAP(0).tfi_field_row(1).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(0).tfi_field_row(1).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(0).tfi_field_row(1).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(0).tfi_field_row(1).tfi_field('TFI_BUSINESS_OPERATION') := 'DDComiteSancion';
  TFI_MAP(0).tfi_field_row(1).tfi_field('VERSION') := 1;
  TFI_MAP(0).tfi_field_row(1).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(0).tfi_field_row(1).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(0).tfi_field_row(1).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(0).tfi_field_row(1).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(0).tfi_field_row(1).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(0).tfi_field_row(1).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(0).tfi_field_row(1).tfi_field('BORRADO') := 0;
  
  TFI_MAP(0).tfi_field_row(2).tfi_field('TFI_ORDEN') := 2;
  TFI_MAP(0).tfi_field_row(2).tfi_field('TFI_TIPO') := 'comboboxinicial';
  TFI_MAP(0).tfi_field_row(2).tfi_field('TFI_NOMBRE') := 'comboConflicto';
  TFI_MAP(0).tfi_field_row(2).tfi_field('TFI_LABEL') :=  'Conflicto de intereses';
  TFI_MAP(0).tfi_field_row(2).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(0).tfi_field_row(2).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(0).tfi_field_row(2).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(0).tfi_field_row(2).tfi_field('TFI_BUSINESS_OPERATION') := 'DDSiNo';
  TFI_MAP(0).tfi_field_row(2).tfi_field('VERSION') := 1;
  TFI_MAP(0).tfi_field_row(2).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(0).tfi_field_row(2).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(0).tfi_field_row(2).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(0).tfi_field_row(2).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(0).tfi_field_row(2).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(0).tfi_field_row(2).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(0).tfi_field_row(2).tfi_field('BORRADO') := 0;
  
  TFI_MAP(0).tfi_field_row(3).tfi_field('TFI_ORDEN') := 3;
  TFI_MAP(0).tfi_field_row(3).tfi_field('TFI_TIPO') := 'comboboxinicial';
  TFI_MAP(0).tfi_field_row(3).tfi_field('TFI_NOMBRE') := 'comboRiesgo';
  TFI_MAP(0).tfi_field_row(3).tfi_field('TFI_LABEL') :=  'Riesgo reputacional';
  TFI_MAP(0).tfi_field_row(3).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(0).tfi_field_row(3).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(0).tfi_field_row(3).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(0).tfi_field_row(3).tfi_field('TFI_BUSINESS_OPERATION') := 'DDSiNo';
  TFI_MAP(0).tfi_field_row(3).tfi_field('VERSION') := 1;
  TFI_MAP(0).tfi_field_row(3).tfi_field('USUARIOCREAR') := 'HREOS-6516';
  TFI_MAP(0).tfi_field_row(3).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(0).tfi_field_row(3).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(0).tfi_field_row(3).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(0).tfi_field_row(3).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(0).tfi_field_row(3).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(0).tfi_field_row(3).tfi_field('BORRADO') := 0;
  
  TFI_MAP(0).tfi_field_row(4).tfi_field('TFI_ORDEN') := 4;
  TFI_MAP(0).tfi_field_row(4).tfi_field('TFI_TIPO') := 'datefield';
  TFI_MAP(0).tfi_field_row(4).tfi_field('TFI_NOMBRE') := 'fechaEnvio';
  TFI_MAP(0).tfi_field_row(4).tfi_field('TFI_LABEL') :=  'Fecha de envío';
  TFI_MAP(0).tfi_field_row(4).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(0).tfi_field_row(4).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(0).tfi_field_row(4).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(0).tfi_field_row(4).tfi_field('TFI_BUSINESS_OPERATION') := 'DDSiNo';
  TFI_MAP(0).tfi_field_row(4).tfi_field('VERSION') := 1;
  TFI_MAP(0).tfi_field_row(4).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(0).tfi_field_row(4).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(0).tfi_field_row(4).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(0).tfi_field_row(4).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(0).tfi_field_row(4).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(0).tfi_field_row(4).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(0).tfi_field_row(4).tfi_field('BORRADO') := 0;
    
  TFI_MAP(0).tfi_field_row(5).tfi_field('TFI_ORDEN') := 5;
  TFI_MAP(0).tfi_field_row(5).tfi_field('TFI_TIPO') := 'comboboxinicial';
  TFI_MAP(0).tfi_field_row(5).tfi_field('TFI_NOMBRE') := 'comiteSuperior';
  TFI_MAP(0).tfi_field_row(5).tfi_field('TFI_LABEL') :=  'Aplica comité superior';
  TFI_MAP(0).tfi_field_row(5).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(0).tfi_field_row(5).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(0).tfi_field_row(5).tfi_field('TFI_VALOR_INICIAL') := '02';
  TFI_MAP(0).tfi_field_row(5).tfi_field('TFI_BUSINESS_OPERATION') := 'DDSiNo';
  TFI_MAP(0).tfi_field_row(5).tfi_field('VERSION') := 1;
  TFI_MAP(0).tfi_field_row(5).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(0).tfi_field_row(5).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(0).tfi_field_row(5).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(0).tfi_field_row(5).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(0).tfi_field_row(5).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(0).tfi_field_row(5).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(0).tfi_field_row(5).tfi_field('BORRADO') := 0;
  
  TFI_MAP(0).tfi_field_row(6).tfi_field('TFI_ORDEN') := 6;
  TFI_MAP(0).tfi_field_row(6).tfi_field('TFI_TIPO') := 'textarea';
  TFI_MAP(0).tfi_field_row(6).tfi_field('TFI_NOMBRE') := 'observaciones';
  TFI_MAP(0).tfi_field_row(6).tfi_field('TFI_LABEL') :=  'Observaciones';
  TFI_MAP(0).tfi_field_row(6).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(0).tfi_field_row(6).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(0).tfi_field_row(6).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(0).tfi_field_row(6).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(0).tfi_field_row(6).tfi_field('VERSION') := 1;
  TFI_MAP(0).tfi_field_row(6).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(0).tfi_field_row(6).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(0).tfi_field_row(6).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(0).tfi_field_row(6).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(0).tfi_field_row(6).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(0).tfi_field_row(6).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(0).tfi_field_row(6).tfi_field('BORRADO') := 0;


----------------------------------------------------------------------------
--------------------------FIRMA PROPIETARIO---------------------------------
----------------------------------------------------------------------------
  TAP(1).tap_field('TAP_CODIGO') := 'T013_FirmaPropietario';
  TAP(1).tap_field('TAP_VIEW') := NULL;
  TAP(1).tap_field('TAP_SCRIPT_VALIDACION') := 'checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''';
  TAP(1).tap_field('TAP_SCRIPT_VALIDACION_JBPM') := 'valores[''''T013_FirmaPropietario''''][''''comboFirma''''] == DDSiNo.NO ? (valores[''''T013_FirmaPropietario''''][''''motivoAnulacion''''] ==  '''''''' ? ''''Si no se firma el motivo de anulaci&oacute;n es obligatorio rellenarlo'''' : null ) : null  ';
  TAP(1).tap_field('TAP_SCRIPT_DECISION') := 'valores[''''T013_FirmaPropietario''''][''''comboFirma''''] == DDSiNo.SI ? ''''Si'''' : ''''No''''';
  TAP(1).tap_field('DD_TPO_ID_BPM') := null;
  TAP(1).tap_field('TAP_SUPERVISOR') := 0;
  TAP(1).tap_field('TAP_DESCRIPCION') := 'Firma propietario';
  TAP(1).tap_field('VERSION') := 0;
  TAP(1).tap_field('USUARIOCREAR') := USUARIOCREAR;
  TAP(1).tap_field('FECHACREAR') := SYSDATE;
  TAP(1).tap_field('USUARIOMODIFICAR') := NULL;
  TAP(1).tap_field('FECHAMODIFICAR') := NULL;
  TAP(1).tap_field('USUARIOBORRAR') := NULL;
  TAP(1).tap_field('FECHABORRAR') := NULL;
  TAP(1).tap_field('BORRADO') := 0;
  TAP(1).tap_field('TAP_ALERT_NO_RETORNO') := NULL;
  TAP(1).tap_field('TAP_ALERT_VUELTA_ATRAS') := NULL;
  TAP(1).tap_field('DD_FAP_ID') := NULL;
  TAP(1).tap_field('TAP_AUTOPRORROGA') := 0;
  TAP(1).tap_field('DTYPE') := 'EXTTareaProcedimiento';
  TAP(1).tap_field('TAP_MAX_AUTOP') := 3;
  V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ' || is_string('GCOM');
  EXECUTE IMMEDIATE V_SQL INTO TAP(1).tap_field('DD_TGE_ID');
  V_SQL := 'SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ' || is_string('811');
  EXECUTE IMMEDIATE V_SQL INTO TAP(1).tap_field('DD_STA_ID');
  TAP(1).tap_field('TAP_EVITAR_REORG') := NULL;
  TAP(1).tap_field('DD_TSUP_ID') := NULL;
  TAP(1).tap_field('TAP_BUCLE_BPM') := NULL;
  ----------------------------------------------------------------------------
----------------------- MAPEO DE PTP PLAZOS--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL PTP_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------
    --PTP(1).ptp_field('DD_PTP_ID'); SE RECUPERA / GENERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(1).ptp_field('DD_JUZ_ID') := null;
    PTP(1).ptp_field('DD_PLA_ID') := null;
    --PTP(1).ptp_field('TAP_ID'); SE RECUPERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(1).ptp_field('DD_PTP_PLAZO_SCRIPT') := '3*24*60*60*1000L';
    PTP(1).ptp_field('VERSION') := 1;
    PTP(1).ptp_field('USUARIOCREAR') := USUARIOCREAR;
    PTP(1).ptp_field('FECHACREAR') := SYSDATE;
    PTP(1).ptp_field('USUARIOMODIFICAR') := null;
    PTP(1).ptp_field('FECHAMODIFICAR') := null;
    PTP(1).ptp_field('USUARIOBORRAR') := null;
    PTP(1).ptp_field('FECHABORRAR') :=null;
    PTP(1).ptp_field('BORRADO') := 0;
    PTP(1).ptp_field('DD_PTP_ABSOLUTO') := 0;
    PTP(1).ptp_field('DD_PTP_OBSERVACIONES') := null;
    
----------------------------------------------------------------------------
----------------------- MAPEO DE TFI PROCEDIMIENTO--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL TFI_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------

----------------------------FORM ITEMS--------------------------------------
  TFI_MAP(1).tfi_field_row(0).tfi_field('TFI_ORDEN') := 0;
  TFI_MAP(1).tfi_field_row(0).tfi_field('TFI_TIPO') := 'label';
  TFI_MAP(1).tfi_field_row(0).tfi_field('TFI_NOMBRE') := 'titulo';
  TFI_MAP(1).tfi_field_row(0).tfi_field('TFI_LABEL') :=  '<p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p>';
  TFI_MAP(1).tfi_field_row(0).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(1).tfi_field_row(0).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(1).tfi_field_row(0).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(1).tfi_field_row(0).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(1).tfi_field_row(0).tfi_field('VERSION') := 1;
  TFI_MAP(1).tfi_field_row(0).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(1).tfi_field_row(0).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(1).tfi_field_row(0).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(1).tfi_field_row(0).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(1).tfi_field_row(0).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(1).tfi_field_row(0).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(1).tfi_field_row(0).tfi_field('BORRADO') := 0;
  
  TFI_MAP(1).tfi_field_row(1).tfi_field('TFI_ORDEN') := 1;
  TFI_MAP(1).tfi_field_row(1).tfi_field('TFI_TIPO') := 'combobox';
  TFI_MAP(1).tfi_field_row(1).tfi_field('TFI_NOMBRE') := 'comboFirma';
  TFI_MAP(1).tfi_field_row(1).tfi_field('TFI_LABEL') :=  '¿Se ha firmado la escritura?';
  TFI_MAP(1).tfi_field_row(1).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(1).tfi_field_row(1).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(1).tfi_field_row(1).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(1).tfi_field_row(1).tfi_field('TFI_BUSINESS_OPERATION') := 'DDSiNo';
  TFI_MAP(1).tfi_field_row(1).tfi_field('VERSION') := 1;
  TFI_MAP(1).tfi_field_row(1).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(1).tfi_field_row(1).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(1).tfi_field_row(1).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(1).tfi_field_row(1).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(1).tfi_field_row(1).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(1).tfi_field_row(1).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(1).tfi_field_row(1).tfi_field('BORRADO') := 0;
  
  TFI_MAP(1).tfi_field_row(2).tfi_field('TFI_ORDEN') := 2;
  TFI_MAP(1).tfi_field_row(2).tfi_field('TFI_TIPO') := 'datefield';
  TFI_MAP(1).tfi_field_row(2).tfi_field('TFI_NOMBRE') := 'fechaFirma';
  TFI_MAP(1).tfi_field_row(2).tfi_field('TFI_LABEL') :=  'Fecha efectiva de firma';
  TFI_MAP(1).tfi_field_row(2).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(1).tfi_field_row(2).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(1).tfi_field_row(2).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(1).tfi_field_row(2).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(1).tfi_field_row(2).tfi_field('VERSION') := 1;
  TFI_MAP(1).tfi_field_row(2).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(1).tfi_field_row(2).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(1).tfi_field_row(2).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(1).tfi_field_row(2).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(1).tfi_field_row(2).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(1).tfi_field_row(2).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(1).tfi_field_row(2).tfi_field('BORRADO') := 0;
    
  TFI_MAP(1).tfi_field_row(3).tfi_field('TFI_ORDEN') := 3;
  TFI_MAP(1).tfi_field_row(3).tfi_field('TFI_TIPO') := 'textfield';
  TFI_MAP(1).tfi_field_row(3).tfi_field('TFI_NOMBRE') := 'notario';
  TFI_MAP(1).tfi_field_row(3).tfi_field('TFI_LABEL') :=  'Notario';
  TFI_MAP(1).tfi_field_row(3).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(1).tfi_field_row(3).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(1).tfi_field_row(3).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(1).tfi_field_row(3).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(1).tfi_field_row(3).tfi_field('VERSION') := 1;
  TFI_MAP(1).tfi_field_row(3).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(1).tfi_field_row(3).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(1).tfi_field_row(3).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(1).tfi_field_row(3).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(1).tfi_field_row(3).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(1).tfi_field_row(3).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(1).tfi_field_row(3).tfi_field('BORRADO') := 0;

  TFI_MAP(1).tfi_field_row(4).tfi_field('TFI_ORDEN') := 4;
  TFI_MAP(1).tfi_field_row(4).tfi_field('TFI_TIPO') := 'numberfield';
  TFI_MAP(1).tfi_field_row(4).tfi_field('TFI_NOMBRE') := 'numProtocolo';
  TFI_MAP(1).tfi_field_row(4).tfi_field('TFI_LABEL') :=  'Nº protocolo';
  TFI_MAP(1).tfi_field_row(4).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(1).tfi_field_row(4).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(1).tfi_field_row(4).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(1).tfi_field_row(4).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(1).tfi_field_row(4).tfi_field('VERSION') := 1;
  TFI_MAP(1).tfi_field_row(4).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(1).tfi_field_row(4).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(1).tfi_field_row(4).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(1).tfi_field_row(4).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(1).tfi_field_row(4).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(1).tfi_field_row(4).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(1).tfi_field_row(4).tfi_field('BORRADO') := 0;

  TFI_MAP(1).tfi_field_row(5).tfi_field('TFI_ORDEN') := 5;
  TFI_MAP(1).tfi_field_row(5).tfi_field('TFI_TIPO') := 'numberfield';
  TFI_MAP(1).tfi_field_row(5).tfi_field('TFI_NOMBRE') := 'precioEscrituracion';
  TFI_MAP(1).tfi_field_row(5).tfi_field('TFI_LABEL') :=  'Precio escrituración';
  TFI_MAP(1).tfi_field_row(5).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(1).tfi_field_row(5).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(1).tfi_field_row(5).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(1).tfi_field_row(5).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(1).tfi_field_row(5).tfi_field('VERSION') := 1;
  TFI_MAP(1).tfi_field_row(5).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(1).tfi_field_row(5).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(1).tfi_field_row(5).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(1).tfi_field_row(5).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(1).tfi_field_row(5).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(1).tfi_field_row(5).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(1).tfi_field_row(5).tfi_field('BORRADO') := 0;

  TFI_MAP(1).tfi_field_row(6).tfi_field('TFI_ORDEN') := 6;
  TFI_MAP(1).tfi_field_row(6).tfi_field('TFI_TIPO') := 'combobox';
  TFI_MAP(1).tfi_field_row(6).tfi_field('TFI_NOMBRE') := 'motivoAnulacion';
  TFI_MAP(1).tfi_field_row(6).tfi_field('TFI_LABEL') :=  'Motivo anulación';
  TFI_MAP(1).tfi_field_row(6).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(1).tfi_field_row(6).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(1).tfi_field_row(6).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(1).tfi_field_row(6).tfi_field('TFI_BUSINESS_OPERATION') := 'DDMotivoAnulacionExpediente';
  TFI_MAP(1).tfi_field_row(6).tfi_field('VERSION') := 1;
  TFI_MAP(1).tfi_field_row(6).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(1).tfi_field_row(6).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(1).tfi_field_row(6).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(1).tfi_field_row(6).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(1).tfi_field_row(6).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(1).tfi_field_row(6).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(1).tfi_field_row(6).tfi_field('BORRADO') := 0;

  TFI_MAP(1).tfi_field_row(7).tfi_field('TFI_ORDEN') := 7;
  TFI_MAP(1).tfi_field_row(7).tfi_field('TFI_TIPO') := 'textarea';
  TFI_MAP(1).tfi_field_row(7).tfi_field('TFI_NOMBRE') := 'observaciones';
  TFI_MAP(1).tfi_field_row(7).tfi_field('TFI_LABEL') :=  'Observaciones';
  TFI_MAP(1).tfi_field_row(7).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(1).tfi_field_row(7).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(1).tfi_field_row(7).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(1).tfi_field_row(7).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(1).tfi_field_row(7).tfi_field('VERSION') := 1;
  TFI_MAP(1).tfi_field_row(7).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(1).tfi_field_row(7).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(1).tfi_field_row(7).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(1).tfi_field_row(7).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(1).tfi_field_row(7).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(1).tfi_field_row(7).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(1).tfi_field_row(7).tfi_field('BORRADO') := 0;
----------------------------------------------------------------------------
-------------------------CIERRE ECONOMICO-----------------------------------
----------------------------------------------------------------------------
  TAP(2).tap_field('TAP_CODIGO') := 'T013_CierreEconomico';
  TAP(2).tap_field('TAP_VIEW') := NULL;
  TAP(2).tap_field('TAP_SCRIPT_VALIDACION') := 'checkFechaVenta() ?( checkImporteParticipacion() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''):''''La fecha de ingreso cheque ha de estar informada''''';
  TAP(2).tap_field('TAP_SCRIPT_VALIDACION_JBPM') := NULL;
  TAP(2).tap_field('TAP_SCRIPT_DECISION') := NULL;
  TAP(2).tap_field('DD_TPO_ID_BPM') := null;
  TAP(2).tap_field('TAP_SUPERVISOR') := 0;
  TAP(2).tap_field('TAP_DESCRIPCION') := 'Cierre económico';
  TAP(2).tap_field('VERSION') := 0;
  TAP(2).tap_field('USUARIOCREAR') := USUARIOCREAR;
  TAP(2).tap_field('FECHACREAR') := SYSDATE;
  TAP(2).tap_field('USUARIOMODIFICAR') := NULL;
  TAP(2).tap_field('FECHAMODIFICAR') := NULL;
  TAP(2).tap_field('USUARIOBORRAR') := NULL;
  TAP(2).tap_field('FECHABORRAR') := NULL;
  TAP(2).tap_field('BORRADO') := 0;
  TAP(2).tap_field('TAP_ALERT_NO_RETORNO') := NULL;
  TAP(2).tap_field('TAP_ALERT_VUELTA_ATRAS') := NULL;
  TAP(2).tap_field('DD_FAP_ID') := NULL;
  TAP(2).tap_field('TAP_AUTOPRORROGA') := 0;
  TAP(2).tap_field('DTYPE') := 'EXTTareaProcedimiento';
  TAP(2).tap_field('TAP_MAX_AUTOP') := 3;
  V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ' || is_string('GCOM');
  EXECUTE IMMEDIATE V_SQL INTO TAP(2).tap_field('DD_TGE_ID');
  V_SQL := 'SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ' || is_string('811');
  EXECUTE IMMEDIATE V_SQL INTO TAP(2).tap_field('DD_STA_ID');
  TAP(2).tap_field('TAP_EVITAR_REORG') := NULL;
  TAP(2).tap_field('DD_TSUP_ID') := NULL;
  TAP(2).tap_field('TAP_BUCLE_BPM') := NULL;
  ----------------------------------------------------------------------------
----------------------- MAPEO DE PTP PLAZOS--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL PTP_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------
    --PTP(2).ptp_field('DD_PTP_ID'); SE RECUPERA / GENERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(2).ptp_field('DD_JUZ_ID') := null;
    PTP(2).ptp_field('DD_PLA_ID') := null;
    --PTP(2).ptp_field('TAP_ID'); SE RECUPERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(2).ptp_field('DD_PTP_PLAZO_SCRIPT') := '3*24*60*60*1000L';
    PTP(2).ptp_field('VERSION') := 1;
    PTP(2).ptp_field('USUARIOCREAR') := USUARIOCREAR;
    PTP(2).ptp_field('FECHACREAR') := SYSDATE;
    PTP(2).ptp_field('USUARIOMODIFICAR') := null;
    PTP(2).ptp_field('FECHAMODIFICAR') := null;
    PTP(2).ptp_field('USUARIOBORRAR') := null;
    PTP(2).ptp_field('FECHABORRAR') :=null;
    PTP(2).ptp_field('BORRADO') := 0;
    PTP(2).ptp_field('DD_PTP_ABSOLUTO') := 0;
    PTP(2).ptp_field('DD_PTP_OBSERVACIONES') := null;
    
----------------------------------------------------------------------------
----------------------- MAPEO DE TFI PROCEDIMIENTO--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL TFI_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------

----------------------------FORM ITEMS--------------------------------------
  TFI_MAP(2).tfi_field_row(0).tfi_field('TFI_ORDEN') := 0;
  TFI_MAP(2).tfi_field_row(0).tfi_field('TFI_TIPO') := 'label';
  TFI_MAP(2).tfi_field_row(0).tfi_field('TFI_NOMBRE') := 'titulo';
  TFI_MAP(2).tfi_field_row(0).tfi_field('TFI_LABEL') :=  '<p style="margin-bottom: 10px">Se ha otorgado la escritura del expediente asociado.
   Verifique los honorarios asignados en la pestaña Cierre económico, seleccionando el check de Honorarios ratificados</p> 
   <p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>';
  TFI_MAP(2).tfi_field_row(0).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(2).tfi_field_row(0).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(2).tfi_field_row(0).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(2).tfi_field_row(0).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(2).tfi_field_row(0).tfi_field('VERSION') := 1;
  TFI_MAP(2).tfi_field_row(0).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(2).tfi_field_row(0).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(2).tfi_field_row(0).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(2).tfi_field_row(0).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(2).tfi_field_row(0).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(2).tfi_field_row(0).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(2).tfi_field_row(0).tfi_field('BORRADO') := 0;
  
  TFI_MAP(2).tfi_field_row(1).tfi_field('TFI_ORDEN') := 1;
  TFI_MAP(2).tfi_field_row(1).tfi_field('TFI_TIPO') := 'combobox';
  TFI_MAP(2).tfi_field_row(1).tfi_field('TFI_NOMBRE') := 'numHonorarios';
  TFI_MAP(2).tfi_field_row(1).tfi_field('TFI_LABEL') :=  'Honorarios ratificados';
  TFI_MAP(2).tfi_field_row(1).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(2).tfi_field_row(1).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(2).tfi_field_row(1).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(2).tfi_field_row(1).tfi_field('TFI_BUSINESS_OPERATION') := 'DDSiNo';
  TFI_MAP(2).tfi_field_row(1).tfi_field('VERSION') := 1;
  TFI_MAP(2).tfi_field_row(1).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(2).tfi_field_row(1).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(2).tfi_field_row(1).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(2).tfi_field_row(1).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(2).tfi_field_row(1).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(2).tfi_field_row(1).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(2).tfi_field_row(1).tfi_field('BORRADO') := 0;
  
  TFI_MAP(2).tfi_field_row(2).tfi_field('TFI_ORDEN') := 2;
  TFI_MAP(2).tfi_field_row(2).tfi_field('TFI_TIPO') := 'textarea';
  TFI_MAP(2).tfi_field_row(2).tfi_field('TFI_NOMBRE') := 'observaciones';
  TFI_MAP(2).tfi_field_row(2).tfi_field('TFI_LABEL') :=  'Observaciones';
  TFI_MAP(2).tfi_field_row(2).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(2).tfi_field_row(2).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(2).tfi_field_row(2).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(2).tfi_field_row(2).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(2).tfi_field_row(2).tfi_field('VERSION') := 1;
  TFI_MAP(2).tfi_field_row(2).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(2).tfi_field_row(2).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(2).tfi_field_row(2).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(2).tfi_field_row(2).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(2).tfi_field_row(2).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(2).tfi_field_row(2).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(2).tfi_field_row(2).tfi_field('BORRADO') := 0;

----------------------------------------------------------------------------
--------------------------RESOLUCION COMITE---------------------------------
----------------------------------------------------------------------------
  TAP(3).tap_field('TAP_CODIGO') := 'T013_ResolucionComite';
  TAP(3).tap_field('TAP_VIEW') := NULL;
  TAP(3).tap_field('TAP_SCRIPT_VALIDACION') := 'checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''';
  TAP(3).tap_field('TAP_SCRIPT_VALIDACION_JBPM') := 'valores[''''T013_ResolucionComite''''][''''comboResolucion''''] != DDResolucionComite.CODIGO_APRUEBA ? (valores[''''T013_ResolucionComite''''][''''comboResolucion''''] == DDResolucionComite.CODIGO_CONTRAOFERTA ? ((checkBankia() || checkLiberbank() || checkGiants()) ? null : existeAdjuntoUGValidacion("22","E")) : null) : resolucionComiteT013()';
  TAP(3).tap_field('TAP_SCRIPT_DECISION') := 'valores[''''T013_ResolucionComite''''][''''comboResolucion''''] == DDResolucionComite.CODIGO_APRUEBA ? checkReserva() ? esYubai() ? ''''esYubai'''' : ''''ApruebaConReserva'''' : esYubai() ? ''''esYubai'''' : ''''ApruebaSinReservaSinTanteo'''' : valores[''''T013_ResolucionComite''''][''''comboResolucion''''] == DDResolucionComite.CODIGO_RECHAZA ? ''''Rechaza'''' : ''''Contraoferta''''';
  TAP(3).tap_field('DD_TPO_ID_BPM') := null;
  TAP(3).tap_field('TAP_SUPERVISOR') := 0;
  TAP(3).tap_field('TAP_DESCRIPCION') := 'Resolución comité';
  TAP(3).tap_field('VERSION') := 0;
  TAP(3).tap_field('USUARIOCREAR') := USUARIOCREAR;
  TAP(3).tap_field('FECHACREAR') := SYSDATE;
  TAP(3).tap_field('USUARIOMODIFICAR') := NULL;
  TAP(3).tap_field('FECHAMODIFICAR') := NULL;
  TAP(3).tap_field('USUARIOBORRAR') := NULL;
  TAP(3).tap_field('FECHABORRAR') := NULL;
  TAP(3).tap_field('BORRADO') := 0;
  TAP(3).tap_field('TAP_ALERT_NO_RETORNO') := NULL;
  TAP(3).tap_field('TAP_ALERT_VUELTA_ATRAS') := NULL;
  TAP(3).tap_field('DD_FAP_ID') := NULL;
  TAP(3).tap_field('TAP_AUTOPRORROGA') := 0;
  TAP(3).tap_field('DTYPE') := 'EXTTareaProcedimiento';
  TAP(3).tap_field('TAP_MAX_AUTOP') := 3;
  V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ' || is_string('GCOM');
  EXECUTE IMMEDIATE V_SQL INTO TAP(3).tap_field('DD_TGE_ID');
  V_SQL := 'SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ' || is_string('811');
  EXECUTE IMMEDIATE V_SQL INTO TAP(3).tap_field('DD_STA_ID');
  TAP(3).tap_field('TAP_EVITAR_REORG') := NULL;
  TAP(3).tap_field('DD_TSUP_ID') := NULL;
  TAP(3).tap_field('TAP_BUCLE_BPM') := NULL;
  ----------------------------------------------------------------------------
----------------------- MAPEO DE PTP PLAZOS--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL PTP_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------
    --PTP(3).ptp_field('DD_PTP_ID'); SE RECUPERA / GENERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(3).ptp_field('DD_JUZ_ID') := null;
    PTP(3).ptp_field('DD_PLA_ID') := null;
    --PTP(3).ptp_field('TAP_ID'); SE RECUPERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(3).ptp_field('DD_PTP_PLAZO_SCRIPT') := '3*24*60*60*1000L';
    PTP(3).ptp_field('VERSION') := 1;
    PTP(3).ptp_field('USUARIOCREAR') := USUARIOCREAR;
    PTP(3).ptp_field('FECHACREAR') := SYSDATE;
    PTP(3).ptp_field('USUARIOMODIFICAR') := null;
    PTP(3).ptp_field('FECHAMODIFICAR') := null;
    PTP(3).ptp_field('USUARIOBORRAR') := null;
    PTP(3).ptp_field('FECHABORRAR') :=null;
    PTP(3).ptp_field('BORRADO') := 0;
    PTP(3).ptp_field('DD_PTP_ABSOLUTO') := 0;
    PTP(3).ptp_field('DD_PTP_OBSERVACIONES') := null;
    
----------------------------------------------------------------------------
----------------------- MAPEO DE TFI PROCEDIMIENTO--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL TFI_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------

----------------------------FORM ITEMS--------------------------------------
  TFI_MAP(3).tfi_field_row(0).tfi_field('TFI_ORDEN') := 0;
  TFI_MAP(3).tfi_field_row(0).tfi_field('TFI_TIPO') := 'label';
  TFI_MAP(3).tfi_field_row(0).tfi_field('TFI_NOMBRE') := 'titulo';
  TFI_MAP(3).tfi_field_row(0).tfi_field('TFI_LABEL') :=  '<p style="margin-bottom: 10px">Ha elevado un expediente comercial al comité sancionador de la cartera. 
  Para completar esta  tarea es necesario esperar a la respuesta del comité, subiendo el documento de respuesta por parte del comité en la pestaña "documentos". Además:</p>
  <p style="margin-bottom: 10px">A) Si el comité ha <b>rechazado</b> la oferta, seleccione en el campo "Resolución comité" la opción "Rechazada".
  Con esto finalizará el trámite, quedando el expediente rechazado.</p> <p style="margin-bottom: 10px">B) Si el comité ha <b>propuesto</b>
  una contraoferta, suba el documento justificativo en la pestaña "documentos" del expediente.
  Seleccione la opción "contraoferta" e introduzca el importe propuesto en el campo "importe contraoferta".
  La siguiente tarea que se lanzará es  "Respuesta contraoferta".</p>
  <p style="margin-bottom: 10px">C) Si el comité ha <b>aprobado</b>
  la oferta, suba el documento justificativo en la pestaña "documentos" del expediente y seleccione la opción "aprobado" en el campo "Resolución comité". 
  La siguiente tarea se le lanzará a la gestoría para la realización del informe jurídico.</p> <p style="margin-bottom: 10px">En el campo "observaciones" puede hacer
  constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>';
  TFI_MAP(3).tfi_field_row(0).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(3).tfi_field_row(0).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(3).tfi_field_row(0).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(3).tfi_field_row(0).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(3).tfi_field_row(0).tfi_field('VERSION') := 1;
  TFI_MAP(3).tfi_field_row(0).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(3).tfi_field_row(0).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(3).tfi_field_row(0).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(3).tfi_field_row(0).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(3).tfi_field_row(0).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(3).tfi_field_row(0).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(3).tfi_field_row(0).tfi_field('BORRADO') := 0;
  
  TFI_MAP(3).tfi_field_row(1).tfi_field('TFI_ORDEN') := 1;
  TFI_MAP(3).tfi_field_row(1).tfi_field('TFI_TIPO') := 'datefield';
  TFI_MAP(3).tfi_field_row(1).tfi_field('TFI_NOMBRE') := 'fechaRespuesta';
  TFI_MAP(3).tfi_field_row(1).tfi_field('TFI_LABEL') :=  'Fecha de respuesta';
  TFI_MAP(3).tfi_field_row(1).tfi_field('TFI_ERROR_VALIDACION') := 'false';
  TFI_MAP(3).tfi_field_row(1).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(3).tfi_field_row(1).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(3).tfi_field_row(1).tfi_field('TFI_BUSINESS_OPERATION') := 'DDSiNo';
  TFI_MAP(3).tfi_field_row(1).tfi_field('VERSION') := 1;
  TFI_MAP(3).tfi_field_row(1).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(3).tfi_field_row(1).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(3).tfi_field_row(1).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(3).tfi_field_row(1).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(3).tfi_field_row(1).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(3).tfi_field_row(1).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(3).tfi_field_row(1).tfi_field('BORRADO') := 0;
  
  TFI_MAP(3).tfi_field_row(2).tfi_field('TFI_ORDEN') := 2;
  TFI_MAP(3).tfi_field_row(2).tfi_field('TFI_TIPO') := 'comboboxinicialedi';
  TFI_MAP(3).tfi_field_row(2).tfi_field('TFI_NOMBRE') := 'comboResolucion';
  TFI_MAP(3).tfi_field_row(2).tfi_field('TFI_LABEL') :=  'Resolución';
  TFI_MAP(3).tfi_field_row(2).tfi_field('TFI_ERROR_VALIDACION') := 'false';
  TFI_MAP(3).tfi_field_row(2).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(3).tfi_field_row(2).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(3).tfi_field_row(2).tfi_field('TFI_BUSINESS_OPERATION') := 'DDResolucionComite';
  TFI_MAP(3).tfi_field_row(2).tfi_field('VERSION') := 1;
  TFI_MAP(3).tfi_field_row(2).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(3).tfi_field_row(2).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(3).tfi_field_row(2).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(3).tfi_field_row(2).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(3).tfi_field_row(2).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(3).tfi_field_row(2).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(3).tfi_field_row(2).tfi_field('BORRADO') := 0;
    
  TFI_MAP(3).tfi_field_row(3).tfi_field('TFI_ORDEN') := 3;
  TFI_MAP(3).tfi_field_row(3).tfi_field('TFI_TIPO') := 'numberfield';
  TFI_MAP(3).tfi_field_row(3).tfi_field('TFI_NOMBRE') := 'numImporteContra';
  TFI_MAP(3).tfi_field_row(3).tfi_field('TFI_LABEL') :=  'Importe contraoferta';
  TFI_MAP(3).tfi_field_row(3).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(3).tfi_field_row(3).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(3).tfi_field_row(3).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(3).tfi_field_row(3).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(3).tfi_field_row(3).tfi_field('VERSION') := 1;
  TFI_MAP(3).tfi_field_row(3).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(3).tfi_field_row(3).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(3).tfi_field_row(3).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(3).tfi_field_row(3).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(3).tfi_field_row(3).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(3).tfi_field_row(3).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(3).tfi_field_row(3).tfi_field('BORRADO') := 0;

  TFI_MAP(3).tfi_field_row(4).tfi_field('TFI_ORDEN') := 4;
  TFI_MAP(3).tfi_field_row(4).tfi_field('TFI_TIPO') := 'datefield';
  TFI_MAP(3).tfi_field_row(4).tfi_field('TFI_NOMBRE') := 'fechaReunionComite';
  TFI_MAP(3).tfi_field_row(4).tfi_field('TFI_LABEL') :=  'Fecha reunión comité';
  TFI_MAP(3).tfi_field_row(4).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(3).tfi_field_row(4).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(3).tfi_field_row(4).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(3).tfi_field_row(4).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(3).tfi_field_row(4).tfi_field('VERSION') := 1;
  TFI_MAP(3).tfi_field_row(4).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(3).tfi_field_row(4).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(3).tfi_field_row(4).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(3).tfi_field_row(4).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(3).tfi_field_row(4).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(3).tfi_field_row(4).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(3).tfi_field_row(4).tfi_field('BORRADO') := 0;

  TFI_MAP(3).tfi_field_row(5).tfi_field('TFI_ORDEN') := 5;
  TFI_MAP(3).tfi_field_row(5).tfi_field('TFI_TIPO') := 'combobox';
  TFI_MAP(3).tfi_field_row(5).tfi_field('TFI_NOMBRE') := 'comiteInternoSancionador';
  TFI_MAP(3).tfi_field_row(5).tfi_field('TFI_LABEL') :=  'Comité interno sancionador';
  TFI_MAP(3).tfi_field_row(5).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(3).tfi_field_row(5).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(3).tfi_field_row(5).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(3).tfi_field_row(5).tfi_field('TFI_BUSINESS_OPERATION') := 'DDCisComiteInternoSancionador';
  TFI_MAP(3).tfi_field_row(5).tfi_field('VERSION') := 1;
  TFI_MAP(3).tfi_field_row(5).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(3).tfi_field_row(5).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(3).tfi_field_row(5).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(3).tfi_field_row(5).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(3).tfi_field_row(5).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(3).tfi_field_row(5).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(3).tfi_field_row(5).tfi_field('BORRADO') := 0;

  TFI_MAP(3).tfi_field_row(6).tfi_field('TFI_ORDEN') := 6;
  TFI_MAP(3).tfi_field_row(6).tfi_field('TFI_TIPO') := 'textarea';
  TFI_MAP(3).tfi_field_row(6).tfi_field('TFI_NOMBRE') := 'observaciones';
  TFI_MAP(3).tfi_field_row(6).tfi_field('TFI_LABEL') :=  'Observaciones';
  TFI_MAP(3).tfi_field_row(6).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(3).tfi_field_row(6).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(3).tfi_field_row(6).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(3).tfi_field_row(6).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(3).tfi_field_row(6).tfi_field('VERSION') := 1;
  TFI_MAP(3).tfi_field_row(6).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(3).tfi_field_row(6).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(3).tfi_field_row(6).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(3).tfi_field_row(6).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(3).tfi_field_row(6).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(3).tfi_field_row(6).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(3).tfi_field_row(6).tfi_field('BORRADO') := 0;

----------------------------------------------------------------------------
--------------------------RESPUESTA OFERTANTE-------------------------------
----------------------------------------------------------------------------
  TAP(4).tap_field('TAP_CODIGO') := 'T013_RespuestaOfertante';
  TAP(4).tap_field('TAP_VIEW') := NULL;
  TAP(4).tap_field('TAP_SCRIPT_VALIDACION') := 'checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''';
  TAP(4).tap_field('TAP_SCRIPT_VALIDACION_JBPM') := 'valores[''''T013_RespuestaOfertante''''][''''comboRespuesta''''] == DDRespuestaOfertante.CODIGO_RECHAZA ? null : respuestaOfertanteT013(valores[''''T013_RespuestaOfertante''''][''''importeOfertante''''])';
  TAP(4).tap_field('TAP_SCRIPT_DECISION') := 'valores[''''T013_RespuestaOfertante''''][''''comboRespuesta''''] == DDRespuestaOfertante.CODIGO_ACEPTA || valores[''''T013_RespuestaOfertante''''][''''comboRespuesta''''] == DDRespuestaOfertante.CODIGO_CONTRAOFERTA ? checkBankia() ? ''''AceptaBankia'''' :  checkReserva() ? esYubai() ? ''''esYubai'''' :''''AceptaConReserva'''' : esYubai() ? ''''esYubai'''' :''''AceptaSinReservaSinTanteo'''' : ''''Rechaza''''';
  TAP(4).tap_field('DD_TPO_ID_BPM') := null;
  TAP(4).tap_field('TAP_SUPERVISOR') := 0;
  TAP(4).tap_field('TAP_DESCRIPCION') := 'Respuesta ofertante';
  TAP(4).tap_field('VERSION') := 0;
  TAP(4).tap_field('USUARIOCREAR') := USUARIOCREAR;
  TAP(4).tap_field('FECHACREAR') := SYSDATE;
  TAP(4).tap_field('USUARIOMODIFICAR') := NULL;
  TAP(4).tap_field('FECHAMODIFICAR') := NULL;
  TAP(4).tap_field('USUARIOBORRAR') := NULL;
  TAP(4).tap_field('FECHABORRAR') := NULL;
  TAP(4).tap_field('BORRADO') := 0;
  TAP(4).tap_field('TAP_ALERT_NO_RETORNO') := NULL;
  TAP(4).tap_field('TAP_ALERT_VUELTA_ATRAS') := NULL;
  TAP(4).tap_field('DD_FAP_ID') := NULL;
  TAP(4).tap_field('TAP_AUTOPRORROGA') := 0;
  TAP(4).tap_field('DTYPE') := 'EXTTareaProcedimiento';
  TAP(4).tap_field('TAP_MAX_AUTOP') := 3;
  V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ' || is_string('GCOM');
  EXECUTE IMMEDIATE V_SQL INTO TAP(4).tap_field('DD_TGE_ID');
  V_SQL := 'SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ' || is_string('811');
  EXECUTE IMMEDIATE V_SQL INTO TAP(4).tap_field('DD_STA_ID');
  TAP(4).tap_field('TAP_EVITAR_REORG') := NULL;
  TAP(4).tap_field('DD_TSUP_ID') := NULL;
  TAP(4).tap_field('TAP_BUCLE_BPM') := NULL;
  ----------------------------------------------------------------------------
----------------------- MAPEO DE PTP PLAZOS--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL PTP_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------
    --PTP(4).ptp_field('DD_PTP_ID'); SE RECUPERA / GENERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(4).ptp_field('DD_JUZ_ID') := null;
    PTP(4).ptp_field('DD_PLA_ID') := null;
    --PTP(4).ptp_field('TAP_ID'); SE RECUPERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(4).ptp_field('DD_PTP_PLAZO_SCRIPT') := '3*24*60*60*1000L';
    PTP(4).ptp_field('VERSION') := 1;
    PTP(4).ptp_field('USUARIOCREAR') := USUARIOCREAR;
    PTP(4).ptp_field('FECHACREAR') := SYSDATE;
    PTP(4).ptp_field('USUARIOMODIFICAR') := null;
    PTP(4).ptp_field('FECHAMODIFICAR') := null;
    PTP(4).ptp_field('USUARIOBORRAR') := null;
    PTP(4).ptp_field('FECHABORRAR') :=null;
    PTP(4).ptp_field('BORRADO') := 0;
    PTP(4).ptp_field('DD_PTP_ABSOLUTO') := 0;
    PTP(4).ptp_field('DD_PTP_OBSERVACIONES') := null;
    
----------------------------------------------------------------------------
----------------------- MAPEO DE TFI PROCEDIMIENTO--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL TFI_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------

----------------------------FORM ITEMS--------------------------------------
  TFI_MAP(4).tfi_field_row(0).tfi_field('TFI_ORDEN') := 0;
  TFI_MAP(4).tfi_field_row(0).tfi_field('TFI_TIPO') := 'label';
  TFI_MAP(4).tfi_field_row(0).tfi_field('TFI_NOMBRE') := 'titulo';
  TFI_MAP(4).tfi_field_row(0).tfi_field('TFI_LABEL') :=  '<p style="margin-bottom: 10px">La resolución del comité sancionador ha sido porponer nuevo importe como contraoferta. Para finalizar esta tarea, debe reflejar la decisión del comprador con respecto a la misma.</p> <p style="margin-bottom: 10px">Si el ofertante ha rechazado la propuesta de contraoferta, seleccione la opción "Rechaza contraoferta" en el campo "Respuesta ofertante". Con esto se dará por concluido el trámite y el expediente quedará rechazado.</p> <p style="margin-bottom: 10px">Si el ofertante ha aceptado la propuesta de contraoferta, seleccione la opción "Acepta contraoferta". Si es así, se lanzará la tarea "Informe jurídico" a la gestoría de formalización.</p> 
  <p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>';
  TFI_MAP(4).tfi_field_row(0).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(4).tfi_field_row(0).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(4).tfi_field_row(0).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(4).tfi_field_row(0).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(4).tfi_field_row(0).tfi_field('VERSION') := 1;
  TFI_MAP(4).tfi_field_row(0).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(4).tfi_field_row(0).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(4).tfi_field_row(0).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(4).tfi_field_row(0).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(4).tfi_field_row(0).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(4).tfi_field_row(0).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(4).tfi_field_row(0).tfi_field('BORRADO') := 0;
  
  TFI_MAP(4).tfi_field_row(1).tfi_field('TFI_ORDEN') := 1;
  TFI_MAP(4).tfi_field_row(1).tfi_field('TFI_TIPO') := 'comboboxinicialedi';
  TFI_MAP(4).tfi_field_row(1).tfi_field('TFI_NOMBRE') := 'comboRespuesta';
  TFI_MAP(4).tfi_field_row(1).tfi_field('TFI_LABEL') :=  '¿Acepta contraoferta?';
  TFI_MAP(4).tfi_field_row(1).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(4).tfi_field_row(1).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(4).tfi_field_row(1).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(4).tfi_field_row(1).tfi_field('TFI_BUSINESS_OPERATION') := 'DDRespuestaOfertante';
  TFI_MAP(4).tfi_field_row(1).tfi_field('VERSION') := 1;
  TFI_MAP(4).tfi_field_row(1).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(4).tfi_field_row(1).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(4).tfi_field_row(1).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(4).tfi_field_row(1).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(4).tfi_field_row(1).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(4).tfi_field_row(1).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(4).tfi_field_row(1).tfi_field('BORRADO') := 0;
  
  TFI_MAP(4).tfi_field_row(2).tfi_field('TFI_ORDEN') := 2;
  TFI_MAP(4).tfi_field_row(2).tfi_field('TFI_TIPO') := 'datefield';
  TFI_MAP(4).tfi_field_row(2).tfi_field('TFI_NOMBRE') := 'fechaRespuesta';
  TFI_MAP(4).tfi_field_row(2).tfi_field('TFI_LABEL') :=  'Fecha respuesta';
  TFI_MAP(4).tfi_field_row(2).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(4).tfi_field_row(2).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(4).tfi_field_row(2).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(4).tfi_field_row(2).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(4).tfi_field_row(2).tfi_field('VERSION') := 1;
  TFI_MAP(4).tfi_field_row(2).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(4).tfi_field_row(2).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(4).tfi_field_row(2).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(4).tfi_field_row(2).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(4).tfi_field_row(2).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(4).tfi_field_row(2).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(4).tfi_field_row(2).tfi_field('BORRADO') := 0;
    
  TFI_MAP(4).tfi_field_row(3).tfi_field('TFI_ORDEN') := 3;
  TFI_MAP(4).tfi_field_row(3).tfi_field('TFI_TIPO') := 'textinf';
  TFI_MAP(4).tfi_field_row(3).tfi_field('TFI_NOMBRE') := 'importeContraoferta';
  TFI_MAP(4).tfi_field_row(3).tfi_field('TFI_LABEL') :=  'Importe contraoferta';
  TFI_MAP(4).tfi_field_row(3).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(4).tfi_field_row(3).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(4).tfi_field_row(3).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(4).tfi_field_row(3).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(4).tfi_field_row(3).tfi_field('VERSION') := 1;
  TFI_MAP(4).tfi_field_row(3).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(4).tfi_field_row(3).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(4).tfi_field_row(3).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(4).tfi_field_row(3).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(4).tfi_field_row(3).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(4).tfi_field_row(3).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(4).tfi_field_row(3).tfi_field('BORRADO') := 0;

  TFI_MAP(4).tfi_field_row(4).tfi_field('TFI_ORDEN') := 4;
  TFI_MAP(4).tfi_field_row(4).tfi_field('TFI_TIPO') := 'numberfield';
  TFI_MAP(4).tfi_field_row(4).tfi_field('TFI_NOMBRE') := 'importeOfertante';
  TFI_MAP(4).tfi_field_row(4).tfi_field('TFI_LABEL') :=  'Importe ofertante';
  TFI_MAP(4).tfi_field_row(4).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(4).tfi_field_row(4).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(4).tfi_field_row(4).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(4).tfi_field_row(4).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(4).tfi_field_row(4).tfi_field('VERSION') := 1;
  TFI_MAP(4).tfi_field_row(4).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(4).tfi_field_row(4).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(4).tfi_field_row(4).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(4).tfi_field_row(4).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(4).tfi_field_row(4).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(4).tfi_field_row(4).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(4).tfi_field_row(4).tfi_field('BORRADO') := 0;

  TFI_MAP(4).tfi_field_row(5).tfi_field('TFI_ORDEN') := 5;
  TFI_MAP(4).tfi_field_row(5).tfi_field('TFI_TIPO') := 'textarea';
  TFI_MAP(4).tfi_field_row(5).tfi_field('TFI_NOMBRE') := 'observaciones';
  TFI_MAP(4).tfi_field_row(5).tfi_field('TFI_LABEL') :=  'Observaciones';
  TFI_MAP(4).tfi_field_row(5).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(4).tfi_field_row(5).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(4).tfi_field_row(5).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(4).tfi_field_row(5).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(4).tfi_field_row(5).tfi_field('VERSION') := 1;
  TFI_MAP(4).tfi_field_row(5).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(4).tfi_field_row(5).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(4).tfi_field_row(5).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(4).tfi_field_row(5).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(4).tfi_field_row(5).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(4).tfi_field_row(5).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(4).tfi_field_row(5).tfi_field('BORRADO') := 0;


------------------------------------------------------------------------------
--------------------------RATIFICACION COMITE---------------------------------
------------------------------------------------------------------------------
  TAP(5).tap_field('TAP_CODIGO') := 'T013_RatificacionComite';
  TAP(5).tap_field('TAP_VIEW') := NULL;
  TAP(5).tap_field('TAP_SCRIPT_VALIDACION') := 'checkImporteParticipacion() ? null : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''';
  TAP(5).tap_field('TAP_SCRIPT_VALIDACION_JBPM') := 'ratificacionComiteT013()';
  TAP(5).tap_field('TAP_SCRIPT_DECISION') := 'valores[''''T013_RatificacionComite''''][''''comboRatificacion''''] == DDResolucionComite.CODIGO_APRUEBA ? (checkReserva() ? esYubai() ? ''''esYubai'''' : ''''AceptaConReserva'''' : (esYubai() ? ''''esYubai'''' : checkDerechoTanteo() ? ''''AceptaSinReservaConTanteo'''' : ''''AceptaSinReservaSinTanteo'''') ) : valores[''''T013_RatificacionComite''''][''''comboRatificacion''''] == DDResolucionComite.CODIGO_RECHAZA ? ''''Rechaza'''' : ''''Contraoferta''''';
  TAP(5).tap_field('DD_TPO_ID_BPM') := null;
  TAP(5).tap_field('TAP_SUPERVISOR') := 0;
  TAP(5).tap_field('TAP_DESCRIPCION') := 'Ratificación Comité';
  TAP(5).tap_field('VERSION') := 0;
  TAP(5).tap_field('USUARIOCREAR') := USUARIOCREAR;
  TAP(5).tap_field('FECHACREAR') := SYSDATE;
  TAP(5).tap_field('USUARIOMODIFICAR') := NULL;
  TAP(5).tap_field('FECHAMODIFICAR') := NULL;
  TAP(5).tap_field('USUARIOBORRAR') := NULL;
  TAP(5).tap_field('FECHABORRAR') := NULL;
  TAP(5).tap_field('BORRADO') := 0;
  TAP(5).tap_field('TAP_ALERT_NO_RETORNO') := NULL;
  TAP(5).tap_field('TAP_ALERT_VUELTA_ATRAS') := NULL;
  TAP(5).tap_field('DD_FAP_ID') := NULL;
  TAP(5).tap_field('TAP_AUTOPRORROGA') := 0;
  TAP(5).tap_field('DTYPE') := 'EXTTareaProcedimiento';
  TAP(5).tap_field('TAP_MAX_AUTOP') := 3;
  V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ' || is_string('GCOM');
  EXECUTE IMMEDIATE V_SQL INTO TAP(5).tap_field('DD_TGE_ID');
  V_SQL := 'SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ' || is_string('811');
  EXECUTE IMMEDIATE V_SQL INTO TAP(5).tap_field('DD_STA_ID');
  TAP(5).tap_field('TAP_EVITAR_REORG') := NULL;
  TAP(5).tap_field('DD_TSUP_ID') := NULL;
  TAP(5).tap_field('TAP_BUCLE_BPM') := NULL;
  ----------------------------------------------------------------------------
----------------------- MAPEO DE PTP PLAZOS--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL PTP_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------
    --PTP(5).ptp_field('DD_PTP_ID'); SE RECUPERA / GENERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(5).ptp_field('DD_JUZ_ID') := null;
    PTP(5).ptp_field('DD_PLA_ID') := null;
    --PTP(5).ptp_field('TAP_ID'); SE RECUPERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(5).ptp_field('DD_PTP_PLAZO_SCRIPT') := '3*24*60*60*1000L';
    PTP(5).ptp_field('VERSION') := 1;
    PTP(5).ptp_field('USUARIOCREAR') := USUARIOCREAR;
    PTP(5).ptp_field('FECHACREAR') := SYSDATE;
    PTP(5).ptp_field('USUARIOMODIFICAR') := null;
    PTP(5).ptp_field('FECHAMODIFICAR') := null;
    PTP(5).ptp_field('USUARIOBORRAR') := null;
    PTP(5).ptp_field('FECHABORRAR') :=null;
    PTP(5).ptp_field('BORRADO') := 0;
    PTP(5).ptp_field('DD_PTP_ABSOLUTO') := 0;
    PTP(5).ptp_field('DD_PTP_OBSERVACIONES') := null;
    
----------------------------------------------------------------------------
----------------------- MAPEO DE TFI PROCEDIMIENTO--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL TFI_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------

----------------------------FORM ITEMS--------------------------------------
  TFI_MAP(5).tfi_field_row(0).tfi_field('TFI_ORDEN') := 0;
  TFI_MAP(5).tfi_field_row(0).tfi_field('TFI_TIPO') := 'label';
  TFI_MAP(5).tfi_field_row(0).tfi_field('TFI_NOMBRE') := 'titulo';
  TFI_MAP(5).tfi_field_row(0).tfi_field('TFI_LABEL') :=  '<p style="margin-bottom: 10px"></p>';
  TFI_MAP(5).tfi_field_row(0).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(5).tfi_field_row(0).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(5).tfi_field_row(0).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(5).tfi_field_row(0).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(5).tfi_field_row(0).tfi_field('VERSION') := 1;
  TFI_MAP(5).tfi_field_row(0).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(5).tfi_field_row(0).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(5).tfi_field_row(0).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(5).tfi_field_row(0).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(5).tfi_field_row(0).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(5).tfi_field_row(0).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(5).tfi_field_row(0).tfi_field('BORRADO') := 0;
  
  TFI_MAP(5).tfi_field_row(1).tfi_field('TFI_ORDEN') := 1;
  TFI_MAP(5).tfi_field_row(1).tfi_field('TFI_TIPO') := 'datefield';
  TFI_MAP(5).tfi_field_row(1).tfi_field('TFI_NOMBRE') := 'fechaRespuesta';
  TFI_MAP(5).tfi_field_row(1).tfi_field('TFI_LABEL') :=  'Fecha ratificación';
  TFI_MAP(5).tfi_field_row(1).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(5).tfi_field_row(1).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(5).tfi_field_row(1).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(5).tfi_field_row(1).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(5).tfi_field_row(1).tfi_field('VERSION') := 1;
  TFI_MAP(5).tfi_field_row(1).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(5).tfi_field_row(1).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(5).tfi_field_row(1).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(5).tfi_field_row(1).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(5).tfi_field_row(1).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(5).tfi_field_row(1).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(5).tfi_field_row(1).tfi_field('BORRADO') := 0;
  
  TFI_MAP(5).tfi_field_row(2).tfi_field('TFI_ORDEN') := 2;
  TFI_MAP(5).tfi_field_row(2).tfi_field('TFI_TIPO') := 'comboboxinicialedi';
  TFI_MAP(5).tfi_field_row(2).tfi_field('TFI_NOMBRE') := 'comboRatificacion';
  TFI_MAP(5).tfi_field_row(2).tfi_field('TFI_LABEL') :=  '¿Aprueba Ratificación?';
  TFI_MAP(5).tfi_field_row(2).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(5).tfi_field_row(2).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(5).tfi_field_row(2).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(5).tfi_field_row(2).tfi_field('TFI_BUSINESS_OPERATION') := 'DDResolucionComite';
  TFI_MAP(5).tfi_field_row(2).tfi_field('VERSION') := 1;
  TFI_MAP(5).tfi_field_row(2).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(5).tfi_field_row(2).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(5).tfi_field_row(2).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(5).tfi_field_row(2).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(5).tfi_field_row(2).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(5).tfi_field_row(2).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(5).tfi_field_row(2).tfi_field('BORRADO') := 0;
    
  TFI_MAP(5).tfi_field_row(3).tfi_field('TFI_ORDEN') := 3;
  TFI_MAP(5).tfi_field_row(3).tfi_field('TFI_TIPO') := 'textinf';
  TFI_MAP(5).tfi_field_row(3).tfi_field('TFI_NOMBRE') := 'importeContraoferta';
  TFI_MAP(5).tfi_field_row(3).tfi_field('TFI_LABEL') :=  'Importe contraoferta';
  TFI_MAP(5).tfi_field_row(3).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(5).tfi_field_row(3).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(5).tfi_field_row(3).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(5).tfi_field_row(3).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(5).tfi_field_row(3).tfi_field('VERSION') := 1;
  TFI_MAP(5).tfi_field_row(3).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(5).tfi_field_row(3).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(5).tfi_field_row(3).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(5).tfi_field_row(3).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(5).tfi_field_row(3).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(5).tfi_field_row(3).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(5).tfi_field_row(3).tfi_field('BORRADO') := 0;

  TFI_MAP(5).tfi_field_row(4).tfi_field('TFI_ORDEN') := 4;
  TFI_MAP(5).tfi_field_row(4).tfi_field('TFI_TIPO') := 'textarea';
  TFI_MAP(5).tfi_field_row(4).tfi_field('TFI_NOMBRE') := 'observaciones';
  TFI_MAP(5).tfi_field_row(4).tfi_field('TFI_LABEL') :=  'Observaciones';
  TFI_MAP(5).tfi_field_row(4).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(5).tfi_field_row(4).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(5).tfi_field_row(4).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(5).tfi_field_row(4).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(5).tfi_field_row(4).tfi_field('VERSION') := 1;
  TFI_MAP(5).tfi_field_row(4).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(5).tfi_field_row(4).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(5).tfi_field_row(4).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(5).tfi_field_row(4).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(5).tfi_field_row(4).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(5).tfi_field_row(4).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(5).tfi_field_row(4).tfi_field('BORRADO') := 0;
----------------------------------------------------------------------------
----------------------INSTRUCCIONES DE RESERVA------------------------------
----------------------------------------------------------------------------
  TAP(6).tap_field('TAP_CODIGO') := 'T013_InstruccionesReserva';
  TAP(6).tap_field('TAP_VIEW') := NULL;
  TAP(6).tap_field('TAP_SCRIPT_VALIDACION') := 'checkImporteParticipacion() ? (checkCompradores() ? checkProvinciaCompradores() ? checkNifConyugueLBB() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ? null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''El NIF del c&oacute;nyugue debe estar informado si el comprador est&aacute; casado'''' : ''''Todos los compradores tienen que tener provincia informada'''' : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''';
  TAP(6).tap_field('TAP_SCRIPT_VALIDACION_JBPM') := 'checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ? (checkCompradoresTienenNumeroUrsus() ?  (!esCajamar() ? (esLiberBank() ?  (mismoNumeroAdjuntosComoCompradoresExpedienteUGValidacion("37", "E", "01") == "" ? existeAdjuntoUGValidacion("06,E;12,E") : mismoNumeroAdjuntosComoCompradoresExpedienteUGValidacion("37", "E", "01")) : mismoNumeroAdjuntosComoCompradoresExpedienteUGValidacion("37", "E", "01")) : null) : ''''No todos los compradores tienen NºURSUS'''') : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''';
  TAP(6).tap_field('TAP_SCRIPT_DECISION') := 'checkDerechoTanteo() ? ''''Si'''' : ''''No'''' ';
  TAP(6).tap_field('DD_TPO_ID_BPM') := null;
  TAP(6).tap_field('TAP_SUPERVISOR') := 0;
  TAP(6).tap_field('TAP_DESCRIPCION') := 'Instrucciones reserva';
  TAP(6).tap_field('VERSION') := 0;
  TAP(6).tap_field('USUARIOCREAR') := USUARIOCREAR;
  TAP(6).tap_field('FECHACREAR') := SYSDATE;
  TAP(6).tap_field('USUARIOMODIFICAR') := NULL;
  TAP(6).tap_field('FECHAMODIFICAR') := NULL;
  TAP(6).tap_field('USUARIOBORRAR') := NULL;
  TAP(6).tap_field('FECHABORRAR') := NULL;
  TAP(6).tap_field('BORRADO') := 0;
  TAP(6).tap_field('TAP_ALERT_NO_RETORNO') := NULL;
  TAP(6).tap_field('TAP_ALERT_VUELTA_ATRAS') := NULL;
  TAP(6).tap_field('DD_FAP_ID') := NULL;
  TAP(6).tap_field('TAP_AUTOPRORROGA') := 0;
  TAP(6).tap_field('DTYPE') := 'EXTTareaProcedimiento';
  TAP(6).tap_field('TAP_MAX_AUTOP') := 3;
  V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ' || is_string('GCOM');
  EXECUTE IMMEDIATE V_SQL INTO TAP(6).tap_field('DD_TGE_ID');
  V_SQL := 'SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ' || is_string('811');
  EXECUTE IMMEDIATE V_SQL INTO TAP(6).tap_field('DD_STA_ID');
  TAP(6).tap_field('TAP_EVITAR_REORG') := NULL;
  TAP(6).tap_field('DD_TSUP_ID') := NULL;
  TAP(6).tap_field('TAP_BUCLE_BPM') := NULL;
  ----------------------------------------------------------------------------
----------------------- MAPEO DE PTP PLAZOS--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL PTP_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------
    --PTP(6).ptp_field('DD_PTP_ID'); SE RECUPERA / GENERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(6).ptp_field('DD_JUZ_ID') := null;
    PTP(6).ptp_field('DD_PLA_ID') := null;
    --PTP(6).ptp_field('TAP_ID'); SE RECUPERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(6).ptp_field('DD_PTP_PLAZO_SCRIPT') := '3*24*60*60*1000L';
    PTP(6).ptp_field('VERSION') := 1;
    PTP(6).ptp_field('USUARIOCREAR') := USUARIOCREAR;
    PTP(6).ptp_field('FECHACREAR') := SYSDATE;
    PTP(6).ptp_field('USUARIOMODIFICAR') := null;
    PTP(6).ptp_field('FECHAMODIFICAR') := null;
    PTP(6).ptp_field('USUARIOBORRAR') := null;
    PTP(6).ptp_field('FECHABORRAR') :=null;
    PTP(6).ptp_field('BORRADO') := 0;
    PTP(6).ptp_field('DD_PTP_ABSOLUTO') := 0;
    PTP(6).ptp_field('DD_PTP_OBSERVACIONES') := null;
    
----------------------------------------------------------------------------
----------------------- MAPEO DE TFI PROCEDIMIENTO--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL TFI_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------

----------------------------FORM ITEMS--------------------------------------
  TFI_MAP(6).tfi_field_row(0).tfi_field('TFI_ORDEN') := 0;
  TFI_MAP(6).tfi_field_row(0).tfi_field('TFI_TIPO') := 'label';
  TFI_MAP(6).tfi_field_row(0).tfi_field('TFI_NOMBRE') := 'titulo';
  TFI_MAP(6).tfi_field_row(0).tfi_field('TFI_LABEL') :=  '<p style="margin-bottom: 10px">Para finalizar esta tarea, recopile la información necesaria para remitirla a la oficina y anote en el campo "fecha de envío" en día efectivo en que lo ha hecho. La siguiente tarea que se le lanzará a la gestoría de formalización es "Obtención contrato reserva".</p> <p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>';
  TFI_MAP(6).tfi_field_row(0).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(6).tfi_field_row(0).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(6).tfi_field_row(0).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(6).tfi_field_row(0).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(6).tfi_field_row(0).tfi_field('VERSION') := 1;
  TFI_MAP(6).tfi_field_row(0).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(6).tfi_field_row(0).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(6).tfi_field_row(0).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(6).tfi_field_row(0).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(6).tfi_field_row(0).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(6).tfi_field_row(0).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(6).tfi_field_row(0).tfi_field('BORRADO') := 0;
  
  TFI_MAP(6).tfi_field_row(1).tfi_field('TFI_ORDEN') := 1;
  TFI_MAP(6).tfi_field_row(1).tfi_field('TFI_TIPO') := 'combobox';
  TFI_MAP(6).tfi_field_row(1).tfi_field('TFI_NOMBRE') := 'tipoArras';
  TFI_MAP(6).tfi_field_row(1).tfi_field('TFI_LABEL') :=  'Tipo de arras';
  TFI_MAP(6).tfi_field_row(1).tfi_field('TFI_ERROR_VALIDACION') := 'Debe indicar el tipo de arras';
  TFI_MAP(6).tfi_field_row(1).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(6).tfi_field_row(1).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(6).tfi_field_row(1).tfi_field('TFI_BUSINESS_OPERATION') := 'DDTiposArras';
  TFI_MAP(6).tfi_field_row(1).tfi_field('VERSION') := 1;
  TFI_MAP(6).tfi_field_row(1).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(6).tfi_field_row(1).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(6).tfi_field_row(1).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(6).tfi_field_row(1).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(6).tfi_field_row(1).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(6).tfi_field_row(1).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(6).tfi_field_row(1).tfi_field('BORRADO') := 0;
  
  TFI_MAP(6).tfi_field_row(2).tfi_field('TFI_ORDEN') := 2;
  TFI_MAP(6).tfi_field_row(2).tfi_field('TFI_TIPO') := 'datefield';
  TFI_MAP(6).tfi_field_row(2).tfi_field('TFI_NOMBRE') := 'fechaEnvio';
  TFI_MAP(6).tfi_field_row(2).tfi_field('TFI_LABEL') :=  'Fecha de envío';
  TFI_MAP(6).tfi_field_row(2).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(6).tfi_field_row(2).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(6).tfi_field_row(2).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(6).tfi_field_row(2).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(6).tfi_field_row(2).tfi_field('VERSION') := 1;
  TFI_MAP(6).tfi_field_row(2).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(6).tfi_field_row(2).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(6).tfi_field_row(2).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(6).tfi_field_row(2).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(6).tfi_field_row(2).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(6).tfi_field_row(2).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(6).tfi_field_row(2).tfi_field('BORRADO') := 0;

  TFI_MAP(6).tfi_field_row(3).tfi_field('TFI_ORDEN') := 3;
  TFI_MAP(6).tfi_field_row(3).tfi_field('TFI_TIPO') := 'textarea';
  TFI_MAP(6).tfi_field_row(3).tfi_field('TFI_NOMBRE') := 'observaciones';
  TFI_MAP(6).tfi_field_row(3).tfi_field('TFI_LABEL') :=  'Observaciones';
  TFI_MAP(6).tfi_field_row(3).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(6).tfi_field_row(3).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(6).tfi_field_row(3).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(6).tfi_field_row(3).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(6).tfi_field_row(3).tfi_field('VERSION') := 1;
  TFI_MAP(6).tfi_field_row(3).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(6).tfi_field_row(3).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(6).tfi_field_row(3).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(6).tfi_field_row(3).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(6).tfi_field_row(3).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(6).tfi_field_row(3).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(6).tfi_field_row(3).tfi_field('BORRADO') := 0;
  
----------------------------------------------------------------------------
----------------------INFORME JURIDICO--------------------------------------
----------------------------------------------------------------------------
  TAP(7).tap_field('TAP_CODIGO') := 'T013_InformeJuridico';
  TAP(7).tap_field('TAP_VIEW') := NULL;
  TAP(7).tap_field('TAP_SCRIPT_VALIDACION') := 'checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''';
  TAP(7).tap_field('TAP_SCRIPT_VALIDACION_JBPM') := 'checkFechaEmisionInformeJuridico() ? mismoNumeroAdjuntosComoActivosExpedienteUGValidacion("10", "E") : "No todos los activos tienen fecha de emisi&oacute;n de informe en el listado de activos del expediente comercial."';
  TAP(7).tap_field('TAP_SCRIPT_DECISION') := 'checkReserva() == false  ? ''''SinReservaSinTanteo'''' : ''''ConReserva''''';
  TAP(7).tap_field('DD_TPO_ID_BPM') := null;
  TAP(7).tap_field('TAP_SUPERVISOR') := 0;
  TAP(7).tap_field('TAP_DESCRIPCION') := 'Informe jurídico';
  TAP(7).tap_field('VERSION') := 0;
  TAP(7).tap_field('USUARIOCREAR') := USUARIOCREAR;
  TAP(7).tap_field('FECHACREAR') := SYSDATE;
  TAP(7).tap_field('USUARIOMODIFICAR') := NULL;
  TAP(7).tap_field('FECHAMODIFICAR') := NULL;
  TAP(7).tap_field('USUARIOBORRAR') := NULL;
  TAP(7).tap_field('FECHABORRAR') := NULL;
  TAP(7).tap_field('BORRADO') := 0;
  TAP(7).tap_field('TAP_ALERT_NO_RETORNO') := NULL;
  TAP(7).tap_field('TAP_ALERT_VUELTA_ATRAS') := NULL;
  TAP(7).tap_field('DD_FAP_ID') := NULL;
  TAP(7).tap_field('TAP_AUTOPRORROGA') := 0;
  TAP(7).tap_field('DTYPE') := 'EXTTareaProcedimiento';
  TAP(7).tap_field('TAP_MAX_AUTOP') := 3;
  V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ' || is_string('GFORM');
  EXECUTE IMMEDIATE V_SQL INTO TAP(7).tap_field('DD_TGE_ID');
  V_SQL := 'SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ' || is_string('811');
  EXECUTE IMMEDIATE V_SQL INTO TAP(7).tap_field('DD_STA_ID');
  TAP(7).tap_field('TAP_EVITAR_REORG') := NULL;
  TAP(7).tap_field('DD_TSUP_ID') := NULL;
  TAP(7).tap_field('TAP_BUCLE_BPM') := NULL;
  ----------------------------------------------------------------------------
----------------------- MAPEO DE PTP PLAZOS--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL PTP_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------
    --PTP(7).ptp_field('DD_PTP_ID'); SE RECUPERA / GENERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(7).ptp_field('DD_JUZ_ID') := null;
    PTP(7).ptp_field('DD_PLA_ID') := null;
    --PTP(7).ptp_field('TAP_ID'); SE RECUPERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(7).ptp_field('DD_PTP_PLAZO_SCRIPT') := '3*24*60*60*1000L';
    PTP(7).ptp_field('VERSION') := 1;
    PTP(7).ptp_field('USUARIOCREAR') := USUARIOCREAR;
    PTP(7).ptp_field('FECHACREAR') := SYSDATE;
    PTP(7).ptp_field('USUARIOMODIFICAR') := null;
    PTP(7).ptp_field('FECHAMODIFICAR') := null;
    PTP(7).ptp_field('USUARIOBORRAR') := null;
    PTP(7).ptp_field('FECHABORRAR') :=null;
    PTP(7).ptp_field('BORRADO') := 0;
    PTP(7).ptp_field('DD_PTP_ABSOLUTO') := 0;
    PTP(7).ptp_field('DD_PTP_OBSERVACIONES') := null;
    
----------------------------------------------------------------------------
----------------------- MAPEO DE TFI PROCEDIMIENTO--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL TFI_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------

------------------------FORM ITEMS------------------------------------------
  TFI_MAP(7).tfi_field_row(0).tfi_field('TFI_ORDEN') := 0;
  TFI_MAP(7).tfi_field_row(0).tfi_field('TFI_TIPO') := 'label';
  TFI_MAP(7).tfi_field_row(0).tfi_field('TFI_NOMBRE') := 'titulo';
  TFI_MAP(7).tfi_field_row(0).tfi_field('TFI_LABEL') :=  '<p style="margin-bottom: 10px">Para dar por completada esta tarea deberá subir una copia del informe emitido a la pestaña "documentos" del expediente comercial. 
  En el campo Resultado deberá consignar el resultado del informe, seleccionado "Favorable" si todo es correcto o "Desfavorable" si hay alguna incidencia.
   De ser así, marque los checks correspondientes en el listado de bloqueos; el gestor comercial rebirá una notificación de estos bloqueos.</p>
   <p style="margin-bottom: 10px">Si el expediente lleva asociada una reserva, la siguiente tarea se le lanzará al gestor comercial para que prepare las "Instrucciones de reserva".</p>
   <p style="margin-bottom: 10px">Si no lleva reserva asociada, la siguiente tarea será "Resultado PBC", para el gestor de formalización.
   En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.
   </p>';
  TFI_MAP(7).tfi_field_row(0).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(7).tfi_field_row(0).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(7).tfi_field_row(0).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(7).tfi_field_row(0).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(7).tfi_field_row(0).tfi_field('VERSION') := 1;
  TFI_MAP(7).tfi_field_row(0).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(7).tfi_field_row(0).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(7).tfi_field_row(0).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(7).tfi_field_row(0).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(7).tfi_field_row(0).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(7).tfi_field_row(0).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(7).tfi_field_row(0).tfi_field('BORRADO') := 0;
  
  TFI_MAP(7).tfi_field_row(1).tfi_field('TFI_ORDEN') := 1;
  TFI_MAP(7).tfi_field_row(1).tfi_field('TFI_TIPO') := 'datefield';
  TFI_MAP(7).tfi_field_row(1).tfi_field('TFI_NOMBRE') := 'fechaEmision';
  TFI_MAP(7).tfi_field_row(1).tfi_field('TFI_LABEL') :=  'Fecha de emisión';
  TFI_MAP(7).tfi_field_row(1).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(7).tfi_field_row(1).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(7).tfi_field_row(1).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(7).tfi_field_row(1).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(7).tfi_field_row(1).tfi_field('VERSION') := 1;
  TFI_MAP(7).tfi_field_row(1).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(7).tfi_field_row(1).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(7).tfi_field_row(1).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(7).tfi_field_row(1).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(7).tfi_field_row(1).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(7).tfi_field_row(1).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(7).tfi_field_row(1).tfi_field('BORRADO') := 0;
  
  TFI_MAP(7).tfi_field_row(2).tfi_field('TFI_ORDEN') := 2;
  TFI_MAP(7).tfi_field_row(2).tfi_field('TFI_TIPO') := 'textarea';
  TFI_MAP(7).tfi_field_row(2).tfi_field('TFI_NOMBRE') := 'observaciones';
  TFI_MAP(7).tfi_field_row(2).tfi_field('TFI_LABEL') :=  'Observaciones';
  TFI_MAP(7).tfi_field_row(2).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(7).tfi_field_row(2).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(7).tfi_field_row(2).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(7).tfi_field_row(2).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(7).tfi_field_row(2).tfi_field('VERSION') := 1;
  TFI_MAP(7).tfi_field_row(2).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(7).tfi_field_row(2).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(7).tfi_field_row(2).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(7).tfi_field_row(2).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(7).tfi_field_row(2).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(7).tfi_field_row(2).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(7).tfi_field_row(2).tfi_field('BORRADO') := 0;


----------------------------------------------------------------------------
--------------------------RESULTADO PBC-------------------------------------
----------------------------------------------------------------------------
  TAP(8).tap_field('TAP_CODIGO') := 'T013_ResultadoPBC';
  TAP(8).tap_field('TAP_VIEW') := NULL;
  TAP(8).tap_field('TAP_SCRIPT_VALIDACION') := '!tieneTramiteGENCATVigenteByIdActivo() ? checkImporteParticipacion() ? (checkCompradores() ? checkProvinciaCompradores() ? checkNifConyugueLBB() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ? (checkCompradoresTienenNumeroUrsus() ? null : ''''No todos los compradores tienen numero URSUS'''' ) : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''El NIF del c&oacute;nyugue debe estar informado si el comprador est&aacute; casado'''' : ''''Todos los compradores tienen que tener provincia informada'''' : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''' : ''''El activo tiene un tr&aacute;mite GENCAT en curso.''''';
  TAP(8).tap_field('TAP_SCRIPT_VALIDACION_JBPM') := NULL;
  TAP(8).tap_field('TAP_SCRIPT_DECISION') := 'valores[''''T013_ResultadoPBC''''][''''comboResultado''''] == DDSiNo.SI ? esYubai() ? ''''esYubai'''' : ''''Aprobado''''  : (checkReserva() ? esYubai() ? ''''esYubai'''' : ''''NoAprobadoConReserva'''' : ''''NoAprobadoSinReserva'''') ';
  TAP(8).tap_field('DD_TPO_ID_BPM') := null;
  TAP(8).tap_field('TAP_SUPERVISOR') := 0;
  TAP(8).tap_field('TAP_DESCRIPCION') := 'Resultado PBC';
  TAP(8).tap_field('VERSION') := 0;
  TAP(8).tap_field('USUARIOCREAR') := USUARIOCREAR;
  TAP(8).tap_field('FECHACREAR') := SYSDATE;
  TAP(8).tap_field('USUARIOMODIFICAR') := NULL;
  TAP(8).tap_field('FECHAMODIFICAR') := NULL;
  TAP(8).tap_field('USUARIOBORRAR') := NULL;
  TAP(8).tap_field('FECHABORRAR') := NULL;
  TAP(8).tap_field('BORRADO') := 0;
  TAP(8).tap_field('TAP_ALERT_NO_RETORNO') := NULL;
  TAP(8).tap_field('TAP_ALERT_VUELTA_ATRAS') := NULL;
  TAP(8).tap_field('DD_FAP_ID') := NULL;
  TAP(8).tap_field('TAP_AUTOPRORROGA') := 0;
  TAP(8).tap_field('DTYPE') := 'EXTTareaProcedimiento';
  TAP(8).tap_field('TAP_MAX_AUTOP') := 3;
  V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ' || is_string('GFORM');
  EXECUTE IMMEDIATE V_SQL INTO TAP(8).tap_field('DD_TGE_ID');
  V_SQL := 'SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ' || is_string('811');
  EXECUTE IMMEDIATE V_SQL INTO TAP(8).tap_field('DD_STA_ID');
  TAP(8).tap_field('TAP_EVITAR_REORG') := NULL;
  TAP(8).tap_field('DD_TSUP_ID') := NULL;
  TAP(8).tap_field('TAP_BUCLE_BPM') := NULL;
  ----------------------------------------------------------------------------
----------------------- MAPEO DE PTP PLAZOS--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL PTP_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------
    --PTP(8).ptp_field('DD_PTP_ID'); SE RECUPERA / GENERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(8).ptp_field('DD_JUZ_ID') := null;
    PTP(8).ptp_field('DD_PLA_ID') := null;
    --PTP(8).ptp_field('TAP_ID'); SE RECUPERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(8).ptp_field('DD_PTP_PLAZO_SCRIPT') := '3*24*60*60*1000L';
    PTP(8).ptp_field('VERSION') := 1;
    PTP(8).ptp_field('USUARIOCREAR') := USUARIOCREAR;
    PTP(8).ptp_field('FECHACREAR') := SYSDATE;
    PTP(8).ptp_field('USUARIOMODIFICAR') := null;
    PTP(8).ptp_field('FECHAMODIFICAR') := null;
    PTP(8).ptp_field('USUARIOBORRAR') := null;
    PTP(8).ptp_field('FECHABORRAR') :=null;
    PTP(8).ptp_field('BORRADO') := 0;
    PTP(8).ptp_field('DD_PTP_ABSOLUTO') := 0;
    PTP(8).ptp_field('DD_PTP_OBSERVACIONES') := null;
    
----------------------------------------------------------------------------
----------------------- MAPEO DE TFI PROCEDIMIENTO--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL TFI_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------

----------------------------FORM ITEMS--------------------------------------
  TFI_MAP(8).tfi_field_row(0).tfi_field('TFI_ORDEN') := 0;
  TFI_MAP(8).tfi_field_row(0).tfi_field('TFI_TIPO') := 'label';
  TFI_MAP(8).tfi_field_row(0).tfi_field('TFI_NOMBRE') := 'titulo';
  TFI_MAP(8).tfi_field_row(0).tfi_field('TFI_LABEL') :=  '<p style="margin-bottom: 10px">
  En la presente tarea deberá reflejar si se ha aprobado el proceso de PBC.</p>
  <p style="margin-bottom: 10px">Si no se ha aprobado, el expediente quedará anulado, finalizándose el trámite</p>
  <p style="margin-bottom: 10px"> Si se ha aprobado, se lanzará a la gestoría de formalización la tarea de "Posicionamiento y firma"</p> <p style="margin-bottom: 10px"> En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite</p>';
  TFI_MAP(8).tfi_field_row(0).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(8).tfi_field_row(0).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(8).tfi_field_row(0).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(8).tfi_field_row(0).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(8).tfi_field_row(0).tfi_field('VERSION') := 1;
  TFI_MAP(8).tfi_field_row(0).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(8).tfi_field_row(0).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(8).tfi_field_row(0).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(8).tfi_field_row(0).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(8).tfi_field_row(0).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(8).tfi_field_row(0).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(8).tfi_field_row(0).tfi_field('BORRADO') := 0;
  
  TFI_MAP(8).tfi_field_row(1).tfi_field('TFI_ORDEN') := 1;
  TFI_MAP(8).tfi_field_row(1).tfi_field('TFI_TIPO') := 'combobox';
  TFI_MAP(8).tfi_field_row(1).tfi_field('TFI_NOMBRE') := 'comboResultado';
  TFI_MAP(8).tfi_field_row(1).tfi_field('TFI_LABEL') :=  '¿PBC Aprobado?';
  TFI_MAP(8).tfi_field_row(1).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(8).tfi_field_row(1).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(8).tfi_field_row(1).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(8).tfi_field_row(1).tfi_field('TFI_BUSINESS_OPERATION') := 'DDSiNo';
  TFI_MAP(8).tfi_field_row(1).tfi_field('VERSION') := 1;
  TFI_MAP(8).tfi_field_row(1).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(8).tfi_field_row(1).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(8).tfi_field_row(1).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(8).tfi_field_row(1).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(8).tfi_field_row(1).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(8).tfi_field_row(1).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(8).tfi_field_row(1).tfi_field('BORRADO') := 0;

  TFI_MAP(8).tfi_field_row(2).tfi_field('TFI_ORDEN') := 2;
  TFI_MAP(8).tfi_field_row(2).tfi_field('TFI_TIPO') := 'textarea';
  TFI_MAP(8).tfi_field_row(2).tfi_field('TFI_NOMBRE') := 'observaciones';
  TFI_MAP(8).tfi_field_row(2).tfi_field('TFI_LABEL') :=  'Observaciones';
  TFI_MAP(8).tfi_field_row(2).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(8).tfi_field_row(2).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(8).tfi_field_row(2).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(8).tfi_field_row(2).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(8).tfi_field_row(2).tfi_field('VERSION') := 1;
  TFI_MAP(8).tfi_field_row(2).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(8).tfi_field_row(2).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(8).tfi_field_row(2).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(8).tfi_field_row(2).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(8).tfi_field_row(2).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(8).tfi_field_row(2).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(8).tfi_field_row(2).tfi_field('BORRADO') := 0;

----------------------------------------------------------------------------
--------------------------OBTENCIÓN CONTRATO RESERVA------------------------
----------------------------------------------------------------------------
  TAP(9).tap_field('TAP_CODIGO') := 'T013_ObtencionContratoReserva';
  TAP(9).tap_field('TAP_VIEW') := NULL;
  TAP(9).tap_field('TAP_SCRIPT_VALIDACION') := 'checkReservaFirmada() ? (checkImporteParticipacion() ?  (checkCompradores() ?  (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''') : ''''La reserva debe estar en estado firmado'''' ';
  TAP(9).tap_field('TAP_SCRIPT_VALIDACION_JBPM') := '!esLiberBank() ? existeAdjuntoUGValidacion("06,E;12,E") : null  ';
  TAP(9).tap_field('TAP_SCRIPT_DECISION') := NULL;
  TAP(9).tap_field('DD_TPO_ID_BPM') := NULL;
  TAP(9).tap_field('TAP_SUPERVISOR') := 0;
  TAP(9).tap_field('TAP_DESCRIPCION') := 'Obtención contrato reserva';
  TAP(9).tap_field('VERSION') := 0;
  TAP(9).tap_field('USUARIOCREAR') := USUARIOCREAR;
  TAP(9).tap_field('FECHACREAR') := SYSDATE;
  TAP(9).tap_field('USUARIOMODIFICAR') := NULL;
  TAP(9).tap_field('FECHAMODIFICAR') := NULL;
  TAP(9).tap_field('USUARIOBORRAR') := NULL;
  TAP(9).tap_field('FECHABORRAR') := NULL;
  TAP(9).tap_field('BORRADO') := 0;
  TAP(9).tap_field('TAP_ALERT_NO_RETORNO') := NULL;
  TAP(9).tap_field('TAP_ALERT_VUELTA_ATRAS') := NULL;
  TAP(9).tap_field('DD_FAP_ID') := NULL;
  TAP(9).tap_field('TAP_AUTOPRORROGA') := 0;
  TAP(9).tap_field('DTYPE') := 'EXTTareaProcedimiento';
  TAP(9).tap_field('TAP_MAX_AUTOP') := 3;
  V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ' || is_string('GIAFORM');
  EXECUTE IMMEDIATE V_SQL INTO TAP(9).tap_field('DD_TGE_ID');
  V_SQL := 'SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ' || is_string('811');
  EXECUTE IMMEDIATE V_SQL INTO TAP(9).tap_field('DD_STA_ID');
  TAP(9).tap_field('TAP_EVITAR_REORG') := NULL;
  TAP(9).tap_field('DD_TSUP_ID') := NULL;
  TAP(9).tap_field('TAP_BUCLE_BPM') := NULL;
  ----------------------------------------------------------------------------
----------------------- MAPEO DE PTP PLAZOS--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL PTP_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------
    --PTP(9).ptp_field('DD_PTP_ID'); SE RECUPERA / GENERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(9).ptp_field('DD_JUZ_ID') := null;
    PTP(9).ptp_field('DD_PLA_ID') := null;
    --PTP(9).ptp_field('TAP_ID'); SE RECUPERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(9).ptp_field('DD_PTP_PLAZO_SCRIPT') := '3*24*60*60*1000L';
    PTP(9).ptp_field('VERSION') := 1;
    PTP(9).ptp_field('USUARIOCREAR') := USUARIOCREAR;
    PTP(9).ptp_field('FECHACREAR') := SYSDATE;
    PTP(9).ptp_field('USUARIOMODIFICAR') := null;
    PTP(9).ptp_field('FECHAMODIFICAR') := null;
    PTP(9).ptp_field('USUARIOBORRAR') := null;
    PTP(9).ptp_field('FECHABORRAR') :=null;
    PTP(9).ptp_field('BORRADO') := 0;
    PTP(9).ptp_field('DD_PTP_ABSOLUTO') := 0;
    PTP(9).ptp_field('DD_PTP_OBSERVACIONES') := null;
    
----------------------------------------------------------------------------
----------------------- MAPEO DE TFI PROCEDIMIENTO--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL TFI_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------

----------------------------FORM ITEMS--------------------------------------
  TFI_MAP(9).tfi_field_row(0).tfi_field('TFI_ORDEN') := 0;
  TFI_MAP(9).tfi_field_row(0).tfi_field('TFI_TIPO') := 'label';
  TFI_MAP(9).tfi_field_row(0).tfi_field('TFI_NOMBRE') := 'titulo';
  TFI_MAP(9).tfi_field_row(0).tfi_field('TFI_LABEL') :=  '<p style="margin-bottom: 10px">
  Para dar por completada esta tarea deberá subir una copia del contrato de reserva a la pestaña "documentos" 
  del expediente comercial. La siguiente tarea, que se lanzará al gestor de formalización, será "Resultado PBC".</p>
  <p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que 
  debe quedar reflejado en este punto del trámite.</p>';
  TFI_MAP(9).tfi_field_row(0).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(9).tfi_field_row(0).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(9).tfi_field_row(0).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(9).tfi_field_row(0).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(9).tfi_field_row(0).tfi_field('VERSION') := 1;
  TFI_MAP(9).tfi_field_row(0).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(9).tfi_field_row(0).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(9).tfi_field_row(0).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(9).tfi_field_row(0).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(9).tfi_field_row(0).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(9).tfi_field_row(0).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(9).tfi_field_row(0).tfi_field('BORRADO') := 0;
  
  TFI_MAP(9).tfi_field_row(1).tfi_field('TFI_ORDEN') := 1;
  TFI_MAP(9).tfi_field_row(1).tfi_field('TFI_TIPO') := 'textinf';
  TFI_MAP(9).tfi_field_row(1).tfi_field('TFI_NOMBRE') := 'cartera';
  TFI_MAP(9).tfi_field_row(1).tfi_field('TFI_LABEL') :=  'Cartera del activo';
  TFI_MAP(9).tfi_field_row(1).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(9).tfi_field_row(1).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(9).tfi_field_row(1).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(9).tfi_field_row(1).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(9).tfi_field_row(1).tfi_field('VERSION') := 1;
  TFI_MAP(9).tfi_field_row(1).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(9).tfi_field_row(1).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(9).tfi_field_row(1).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(9).tfi_field_row(1).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(9).tfi_field_row(1).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(9).tfi_field_row(1).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(9).tfi_field_row(1).tfi_field('BORRADO') := 0;
  
  TFI_MAP(9).tfi_field_row(2).tfi_field('TFI_ORDEN') := 2;
  TFI_MAP(9).tfi_field_row(2).tfi_field('TFI_TIPO') := 'textinf';
  TFI_MAP(9).tfi_field_row(2).tfi_field('TFI_NOMBRE') := 'oficinaReserva';
  TFI_MAP(9).tfi_field_row(2).tfi_field('TFI_LABEL') :=  'Oficina en la que se ha firmado la reserva';
  TFI_MAP(9).tfi_field_row(2).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(9).tfi_field_row(2).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(9).tfi_field_row(2).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(9).tfi_field_row(2).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(9).tfi_field_row(2).tfi_field('VERSION') := 1;
  TFI_MAP(9).tfi_field_row(2).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(9).tfi_field_row(2).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(9).tfi_field_row(2).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(9).tfi_field_row(2).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(9).tfi_field_row(2).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(9).tfi_field_row(2).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(9).tfi_field_row(2).tfi_field('BORRADO') := 0;
    
  TFI_MAP(9).tfi_field_row(3).tfi_field('TFI_ORDEN') := 3;
  TFI_MAP(9).tfi_field_row(3).tfi_field('TFI_TIPO') := 'datefield';
  TFI_MAP(9).tfi_field_row(3).tfi_field('TFI_NOMBRE') := 'fechaFirma';
  TFI_MAP(9).tfi_field_row(3).tfi_field('TFI_LABEL') :=  'Fecha de firma';
  TFI_MAP(9).tfi_field_row(3).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(9).tfi_field_row(3).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(9).tfi_field_row(3).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(9).tfi_field_row(3).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(9).tfi_field_row(3).tfi_field('VERSION') := 1;
  TFI_MAP(9).tfi_field_row(3).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(9).tfi_field_row(3).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(9).tfi_field_row(3).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(9).tfi_field_row(3).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(9).tfi_field_row(3).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(9).tfi_field_row(3).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(9).tfi_field_row(3).tfi_field('BORRADO') := 0;
  
  TFI_MAP(9).tfi_field_row(4).tfi_field('TFI_ORDEN') := 4;
  TFI_MAP(9).tfi_field_row(4).tfi_field('TFI_TIPO') := 'textarea';
  TFI_MAP(9).tfi_field_row(4).tfi_field('TFI_NOMBRE') := 'observaciones';
  TFI_MAP(9).tfi_field_row(4).tfi_field('TFI_LABEL') :=  'Observaciones';
  TFI_MAP(9).tfi_field_row(4).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(9).tfi_field_row(4).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(9).tfi_field_row(4).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(9).tfi_field_row(4).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(9).tfi_field_row(4).tfi_field('VERSION') := 1;
  TFI_MAP(9).tfi_field_row(4).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(9).tfi_field_row(4).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(9).tfi_field_row(4).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(9).tfi_field_row(4).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(9).tfi_field_row(4).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(9).tfi_field_row(4).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(9).tfi_field_row(4).tfi_field('BORRADO') := 0;

----------------------------------------------------------------------------
--------------------------Posicionamiento y firma---------------------------
----------------------------------------------------------------------------
  TAP(10).tap_field('TAP_CODIGO') := 'T013_PosicionamientoYFirma';
  TAP(10).tap_field('TAP_VIEW') := NULL;
  TAP(10).tap_field('TAP_SCRIPT_VALIDACION') := '!tieneTramiteGENCATVigenteByIdActivo() ? checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''' : ''''El activo tiene un tr&aacute;mite GENCAT en curso.''''';
  TAP(10).tap_field('TAP_SCRIPT_VALIDACION_JBPM') := 'checkExpedienteBloqueado() ? (valores[''''T013_PosicionamientoYFirma''''][''''comboFirma''''] == DDSiNo.SI ? (checkPosicionamiento() ? existeAdjuntoUGValidacion("15,E") : ''''El expediente debe tener alg&uacute;n posicionamiento'''') : null) : ''''El expediente no est&aacute; bloqueado''''';
  TAP(10).tap_field('TAP_SCRIPT_DECISION') := 'valores[''''T013_PosicionamientoYFirma''''][''''comboFirma''''] == DDSiNo.SI ? ''''ConFirma'''' : ''''SinFirma'''' ';
  TAP(10).tap_field('DD_TPO_ID_BPM') := null;
  TAP(10).tap_field('TAP_SUPERVISOR') := 0;
  TAP(10).tap_field('TAP_DESCRIPCION') := 'Posicionamiento y firma';
  TAP(10).tap_field('VERSION') := 0;
  TAP(10).tap_field('USUARIOCREAR') := USUARIOCREAR;
  TAP(10).tap_field('FECHACREAR') := SYSDATE;
  TAP(10).tap_field('USUARIOMODIFICAR') := NULL;
  TAP(10).tap_field('FECHAMODIFICAR') := NULL;
  TAP(10).tap_field('USUARIOBORRAR') := NULL;
  TAP(10).tap_field('FECHABORRAR') := NULL;
  TAP(10).tap_field('BORRADO') := 0;
  TAP(10).tap_field('TAP_ALERT_NO_RETORNO') := NULL;
  TAP(10).tap_field('TAP_ALERT_VUELTA_ATRAS') := NULL;
  TAP(10).tap_field('DD_FAP_ID') := NULL;
  TAP(10).tap_field('TAP_AUTOPRORROGA') := 0;
  TAP(10).tap_field('DTYPE') := 'EXTTareaProcedimiento';
  TAP(10).tap_field('TAP_MAX_AUTOP') := 3;
  V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ' || is_string('GFORM');
  EXECUTE IMMEDIATE V_SQL INTO TAP(10).tap_field('DD_TGE_ID');
  V_SQL := 'SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ' || is_string('811');
  EXECUTE IMMEDIATE V_SQL INTO TAP(10).tap_field('DD_STA_ID');
  TAP(10).tap_field('TAP_EVITAR_REORG') := NULL;
  TAP(10).tap_field('DD_TSUP_ID') := NULL;
  TAP(10).tap_field('TAP_BUCLE_BPM') := NULL;
  ----------------------------------------------------------------------------
----------------------- MAPEO DE PTP PLAZOS--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL PTP_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------
    --PTP(10).ptp_field('DD_PTP_ID'); SE RECUPERA / GENERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(10).ptp_field('DD_JUZ_ID') := null;
    PTP(10).ptp_field('DD_PLA_ID') := null;
    --PTP(10).ptp_field('TAP_ID'); SE RECUPERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(10).ptp_field('DD_PTP_PLAZO_SCRIPT') := '10*24*60*60*1000L';
    PTP(10).ptp_field('VERSION') := 1;
    PTP(10).ptp_field('USUARIOCREAR') := USUARIOCREAR;
    PTP(10).ptp_field('FECHACREAR') := SYSDATE;
    PTP(10).ptp_field('USUARIOMODIFICAR') := null;
    PTP(10).ptp_field('FECHAMODIFICAR') := null;
    PTP(10).ptp_field('USUARIOBORRAR') := null;
    PTP(10).ptp_field('FECHABORRAR') :=null;
    PTP(10).ptp_field('BORRADO') := 0;
    PTP(10).ptp_field('DD_PTP_ABSOLUTO') := 0;
    PTP(10).ptp_field('DD_PTP_OBSERVACIONES') := null;
    
----------------------------------------------------------------------------
----------------------- MAPEO DE TFI PROCEDIMIENTO--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL TFI_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------

----------------------------FORM ITEMS--------------------------------------
  TFI_MAP(10).tfi_field_row(0).tfi_field('TFI_ORDEN') := 0;
  TFI_MAP(10).tfi_field_row(0).tfi_field('TFI_TIPO') := 'label';
  TFI_MAP(10).tfi_field_row(0).tfi_field('TFI_NOMBRE') := 'titulo';
  TFI_MAP(10).tfi_field_row(0).tfi_field('TFI_LABEL') :=  '<p style="margin-bottom: 10px">La operación ya está lista para su firma.
  Contacte con los intervientes del expediente para acordar una fecha para la firma del contrato de compraventa. 
  Asimismo, recopile todos los juegos de llaves del activo y la documentación necesaria para la firma.</p>
  <p style="margin-bottom: 10px">Para finalizar esta tarea, indique si la firma se ha llevado a término, y en su caso,
  la fecha efectiva de escritura y el número de protocolo.
  Para dar por finalizada la tarea deberá subir al expediente los siguientes documentos: 
  Copia simple (obligatorio), Hoja de datos (obligatorio), minuta, recibí llaves firmado por el cliente 
  y el justificante de ingreso del cheque. La siguiente tarea que se lanzará es "Documentos postventa".</p>
  <p style="margin-bottom: 10px">Si la firma se ha cancelado, anule el expediente indicando el motivo, finalizando así 
  el trámite. Se le enviará una notificación a los gestores comercial y de formalización.</p>
  <p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere
  que debe quedar reflejado en este punto del trámite.</p>';
  TFI_MAP(10).tfi_field_row(0).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(10).tfi_field_row(0).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(10).tfi_field_row(0).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(10).tfi_field_row(0).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(10).tfi_field_row(0).tfi_field('VERSION') := 1;
  TFI_MAP(10).tfi_field_row(0).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(10).tfi_field_row(0).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(10).tfi_field_row(0).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(0).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(0).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(0).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(0).tfi_field('BORRADO') := 0;
  
  TFI_MAP(10).tfi_field_row(1).tfi_field('TFI_ORDEN') := 1;
  TFI_MAP(10).tfi_field_row(1).tfi_field('TFI_TIPO') := 'combobox';
  TFI_MAP(10).tfi_field_row(1).tfi_field('TFI_NOMBRE') := 'comboFirma';
  TFI_MAP(10).tfi_field_row(1).tfi_field('TFI_LABEL') :=  '¿Firmado?';
  TFI_MAP(10).tfi_field_row(1).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(10).tfi_field_row(1).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(10).tfi_field_row(1).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(10).tfi_field_row(1).tfi_field('TFI_BUSINESS_OPERATION') := 'DDSiNo';
  TFI_MAP(10).tfi_field_row(1).tfi_field('VERSION') := 1;
  TFI_MAP(10).tfi_field_row(1).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(10).tfi_field_row(1).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(10).tfi_field_row(1).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(1).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(1).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(1).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(1).tfi_field('BORRADO') := 0;
  
  TFI_MAP(10).tfi_field_row(2).tfi_field('TFI_ORDEN') := 2;
  TFI_MAP(10).tfi_field_row(2).tfi_field('TFI_TIPO') := 'datemaxtoday';
  TFI_MAP(10).tfi_field_row(2).tfi_field('TFI_NOMBRE') := 'fechaFirma';
  TFI_MAP(10).tfi_field_row(2).tfi_field('TFI_LABEL') :=  'Fecha firma';
  TFI_MAP(10).tfi_field_row(2).tfi_field('TFI_ERROR_VALIDACION') := 'Debe indicar la fecha de firma';
  TFI_MAP(10).tfi_field_row(2).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(10).tfi_field_row(2).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(10).tfi_field_row(2).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(10).tfi_field_row(2).tfi_field('VERSION') := 1;
  TFI_MAP(10).tfi_field_row(2).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(10).tfi_field_row(2).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(10).tfi_field_row(2).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(2).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(2).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(2).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(2).tfi_field('BORRADO') := 0;
    
  TFI_MAP(10).tfi_field_row(3).tfi_field('TFI_ORDEN') := 3;
  TFI_MAP(10).tfi_field_row(3).tfi_field('TFI_TIPO') := 'numberfield';
  TFI_MAP(10).tfi_field_row(3).tfi_field('TFI_NOMBRE') := 'numProtocolo';
  TFI_MAP(10).tfi_field_row(3).tfi_field('TFI_LABEL') :=  'Núm Protocolo';
  TFI_MAP(10).tfi_field_row(3).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(10).tfi_field_row(3).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(10).tfi_field_row(3).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(10).tfi_field_row(3).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(10).tfi_field_row(3).tfi_field('VERSION') := 1;
  TFI_MAP(10).tfi_field_row(3).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(10).tfi_field_row(3).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(10).tfi_field_row(3).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(3).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(3).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(3).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(3).tfi_field('BORRADO') := 0;

  TFI_MAP(10).tfi_field_row(4).tfi_field('TFI_ORDEN') := 4;
  TFI_MAP(10).tfi_field_row(4).tfi_field('TFI_TIPO') := 'combobox';
  TFI_MAP(10).tfi_field_row(4).tfi_field('TFI_NOMBRE') := 'comboCondiciones';
  TFI_MAP(10).tfi_field_row(4).tfi_field('TFI_LABEL') :=  'Condiciones postventa';
  TFI_MAP(10).tfi_field_row(4).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(10).tfi_field_row(4).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(10).tfi_field_row(4).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(10).tfi_field_row(4).tfi_field('TFI_BUSINESS_OPERATION') := 'DDSiNo';
  TFI_MAP(10).tfi_field_row(4).tfi_field('VERSION') := 1;
  TFI_MAP(10).tfi_field_row(4).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(10).tfi_field_row(4).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(10).tfi_field_row(4).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(4).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(4).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(4).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(4).tfi_field('BORRADO') := 0;

  TFI_MAP(10).tfi_field_row(5).tfi_field('TFI_ORDEN') := 5;
  TFI_MAP(10).tfi_field_row(5).tfi_field('TFI_TIPO') := 'textfield';
  TFI_MAP(10).tfi_field_row(5).tfi_field('TFI_NOMBRE') := 'condiciones';
  TFI_MAP(10).tfi_field_row(5).tfi_field('TFI_LABEL') :=  'Texto condiciones postventa';
  TFI_MAP(10).tfi_field_row(5).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(10).tfi_field_row(5).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(10).tfi_field_row(5).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(10).tfi_field_row(5).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(10).tfi_field_row(5).tfi_field('VERSION') := 1;
  TFI_MAP(10).tfi_field_row(5).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(10).tfi_field_row(5).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(10).tfi_field_row(5).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(5).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(5).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(5).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(5).tfi_field('BORRADO') := 0;

  TFI_MAP(10).tfi_field_row(6).tfi_field('TFI_ORDEN') := 6;
  TFI_MAP(10).tfi_field_row(6).tfi_field('TFI_TIPO') := 'combobox';
  TFI_MAP(10).tfi_field_row(6).tfi_field('TFI_NOMBRE') := 'motivoNoFirma';
  TFI_MAP(10).tfi_field_row(6).tfi_field('TFI_LABEL') :=  'Motivo de no firma';
  TFI_MAP(10).tfi_field_row(6).tfi_field('TFI_ERROR_VALIDACION') := 'Debe indicar un motivo de no firma';
  TFI_MAP(10).tfi_field_row(6).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(10).tfi_field_row(6).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(10).tfi_field_row(6).tfi_field('TFI_BUSINESS_OPERATION') := 'DDMotivoAnulacionExpediente';
  TFI_MAP(10).tfi_field_row(6).tfi_field('VERSION') := 1;
  TFI_MAP(10).tfi_field_row(6).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(10).tfi_field_row(6).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(10).tfi_field_row(6).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(6).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(6).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(6).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(6).tfi_field('BORRADO') := 0;

  TFI_MAP(10).tfi_field_row(7).tfi_field('TFI_ORDEN') := 7;
  TFI_MAP(10).tfi_field_row(7).tfi_field('TFI_TIPO') := 'textarea';
  TFI_MAP(10).tfi_field_row(7).tfi_field('TFI_NOMBRE') := 'observaciones';
  TFI_MAP(10).tfi_field_row(7).tfi_field('TFI_LABEL') :=  'Observaciones';
  TFI_MAP(10).tfi_field_row(7).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(10).tfi_field_row(7).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(10).tfi_field_row(7).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(10).tfi_field_row(7).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(10).tfi_field_row(7).tfi_field('VERSION') := 1;
  TFI_MAP(10).tfi_field_row(7).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(10).tfi_field_row(7).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(10).tfi_field_row(7).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(7).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(7).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(7).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(7).tfi_field('BORRADO') := 0;
  
  TFI_MAP(10).tfi_field_row(8).tfi_field('TFI_ORDEN') := 8;
  TFI_MAP(10).tfi_field_row(8).tfi_field('TFI_TIPO') := 'textfield';
  TFI_MAP(10).tfi_field_row(8).tfi_field('TFI_NOMBRE') := 'tieneReserva';
  TFI_MAP(10).tfi_field_row(8).tfi_field('TFI_LABEL') :=  'Tiene reserva';
  TFI_MAP(10).tfi_field_row(8).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(10).tfi_field_row(8).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(10).tfi_field_row(8).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(10).tfi_field_row(8).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(10).tfi_field_row(8).tfi_field('VERSION') := 1;
  TFI_MAP(10).tfi_field_row(8).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(10).tfi_field_row(8).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(10).tfi_field_row(8).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(8).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(8).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(8).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(8).tfi_field('BORRADO') := 0;

  TFI_MAP(10).tfi_field_row(9).tfi_field('TFI_ORDEN') := 9;
  TFI_MAP(10).tfi_field_row(9).tfi_field('TFI_TIPO') := 'combobox';
  TFI_MAP(10).tfi_field_row(9).tfi_field('TFI_NOMBRE') := 'asistenciaPBC';
  TFI_MAP(10).tfi_field_row(9).tfi_field('TFI_LABEL') :=  'Confirmar asistencia PBC';
  TFI_MAP(10).tfi_field_row(9).tfi_field('TFI_ERROR_VALIDACION') := 'Debe confirmar la asistencia';
  TFI_MAP(10).tfi_field_row(9).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(10).tfi_field_row(9).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(10).tfi_field_row(9).tfi_field('TFI_BUSINESS_OPERATION') := 'DDSiNo';
  TFI_MAP(10).tfi_field_row(9).tfi_field('VERSION') := 1;
  TFI_MAP(10).tfi_field_row(9).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(10).tfi_field_row(9).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(10).tfi_field_row(9).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(9).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(9).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(9).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(9).tfi_field('BORRADO') := 0;

  TFI_MAP(10).tfi_field_row(10).tfi_field('TFI_ORDEN') := 10;
  TFI_MAP(10).tfi_field_row(10).tfi_field('TFI_TIPO') := 'textarea';
  TFI_MAP(10).tfi_field_row(10).tfi_field('TFI_NOMBRE') := 'obsAsisPBC';
  TFI_MAP(10).tfi_field_row(10).tfi_field('TFI_LABEL') :=  'Asistencia PBC descripción';
  TFI_MAP(10).tfi_field_row(10).tfi_field('TFI_ERROR_VALIDACION') := 'Debe indicar los motivos';
  TFI_MAP(10).tfi_field_row(10).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(10).tfi_field_row(10).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(10).tfi_field_row(10).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(10).tfi_field_row(10).tfi_field('VERSION') := 1;
  TFI_MAP(10).tfi_field_row(10).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(10).tfi_field_row(10).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(10).tfi_field_row(10).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(10).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(10).tfi_field_row(10).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(10).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(10).tfi_field_row(10).tfi_field('BORRADO') := 0;

----------------------------------------------------------------------------
--------------------------RESOLUCION EXPEDIENTE-----------------------------
----------------------------------------------------------------------------
  TAP(11).tap_field('TAP_CODIGO') := 'T013_ResolucionExpediente';
  TAP(11).tap_field('TAP_VIEW') := NULL;
  TAP(11).tap_field('TAP_SCRIPT_VALIDACION') := 'checkImporteParticipacion() ? null : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''';
  TAP(11).tap_field('TAP_SCRIPT_VALIDACION_JBPM') := NULL;
  TAP(11).tap_field('TAP_SCRIPT_DECISION') := 'checkBankia() ? reservaFirmada() ? checkActivoNoFormalizar() ? ''''noAvanzaRespuestaBankia'''' : checkPaseDirectoPendDevol() ? ''''avanzaPendienteDevol'''' : ''''avanzaRespuestaBankia'''' : ''''noAvanzaRespuestaBankia'''' : ''''noAvanzaRespuestaBankia''''';
  TAP(11).tap_field('DD_TPO_ID_BPM') := null;
  TAP(11).tap_field('TAP_SUPERVISOR') := 0;
  TAP(11).tap_field('TAP_DESCRIPCION') := 'Resolución expediente';
  TAP(11).tap_field('VERSION') := 0;
  TAP(11).tap_field('USUARIOCREAR') := USUARIOCREAR;
  TAP(11).tap_field('FECHACREAR') := SYSDATE;
  TAP(11).tap_field('USUARIOMODIFICAR') := NULL;
  TAP(11).tap_field('FECHAMODIFICAR') := NULL;
  TAP(11).tap_field('USUARIOBORRAR') := NULL;
  TAP(11).tap_field('FECHABORRAR') := NULL;
  TAP(11).tap_field('BORRADO') := 0;
  TAP(11).tap_field('TAP_ALERT_NO_RETORNO') := NULL;
  TAP(11).tap_field('TAP_ALERT_VUELTA_ATRAS') := NULL;
  TAP(11).tap_field('DD_FAP_ID') := NULL;
  TAP(11).tap_field('TAP_AUTOPRORROGA') := 0;
  TAP(11).tap_field('DTYPE') := 'EXTTareaProcedimiento';
  TAP(11).tap_field('TAP_MAX_AUTOP') := 3;
  V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ' || is_string('GCOM');
  EXECUTE IMMEDIATE V_SQL INTO TAP(11).tap_field('DD_TGE_ID');
  V_SQL := 'SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ' || is_string('811');
  EXECUTE IMMEDIATE V_SQL INTO TAP(11).tap_field('DD_STA_ID');
  TAP(11).tap_field('TAP_EVITAR_REORG') := NULL;
  TAP(11).tap_field('DD_TSUP_ID') := NULL;
  TAP(11).tap_field('TAP_BUCLE_BPM') := NULL;
  ----------------------------------------------------------------------------
----------------------- MAPEO DE PTP PLAZOS--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL PTP_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------
    --PTP(11).ptp_field('DD_PTP_ID'); SE RECUPERA / GENERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(11).ptp_field('DD_JUZ_ID') := null;
    PTP(11).ptp_field('DD_PLA_ID') := null;
    --PTP(11).ptp_field('TAP_ID'); SE RECUPERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(11).ptp_field('DD_PTP_PLAZO_SCRIPT') := '3*24*60*60*1000L';
    PTP(11).ptp_field('VERSION') := 1;
    PTP(11).ptp_field('USUARIOCREAR') := USUARIOCREAR;
    PTP(11).ptp_field('FECHACREAR') := SYSDATE;
    PTP(11).ptp_field('USUARIOMODIFICAR') := null;
    PTP(11).ptp_field('FECHAMODIFICAR') := null;
    PTP(11).ptp_field('USUARIOBORRAR') := null;
    PTP(11).ptp_field('FECHABORRAR') :=null;
    PTP(11).ptp_field('BORRADO') := 0;
    PTP(11).ptp_field('DD_PTP_ABSOLUTO') := 0;
    PTP(11).ptp_field('DD_PTP_OBSERVACIONES') := null;
    
----------------------------------------------------------------------------
----------------------- MAPEO DE TFI PROCEDIMIENTO--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL TFI_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------

----------------------------FORM ITEMS--------------------------------------
  TFI_MAP(11).tfi_field_row(0).tfi_field('TFI_ORDEN') := 0;
  TFI_MAP(11).tfi_field_row(0).tfi_field('TFI_TIPO') := 'label';
  TFI_MAP(11).tfi_field_row(0).tfi_field('TFI_NOMBRE') := 'titulo';
  TFI_MAP(11).tfi_field_row(0).tfi_field('TFI_LABEL') :=  '<p style="margin-bottom: 10px"></p>';
  TFI_MAP(11).tfi_field_row(0).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(11).tfi_field_row(0).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(11).tfi_field_row(0).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(11).tfi_field_row(0).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(11).tfi_field_row(0).tfi_field('VERSION') := 1;
  TFI_MAP(11).tfi_field_row(0).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(11).tfi_field_row(0).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(11).tfi_field_row(0).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(11).tfi_field_row(0).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(11).tfi_field_row(0).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(11).tfi_field_row(0).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(11).tfi_field_row(0).tfi_field('BORRADO') := 0;
  
  TFI_MAP(11).tfi_field_row(1).tfi_field('TFI_ORDEN') := 1;
  TFI_MAP(11).tfi_field_row(1).tfi_field('TFI_TIPO') := 'textinf';
  TFI_MAP(11).tfi_field_row(1).tfi_field('TFI_NOMBRE') := 'tipoArras';
  TFI_MAP(11).tfi_field_row(1).tfi_field('TFI_LABEL') :=  'Tipo de arras';
  TFI_MAP(11).tfi_field_row(1).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(11).tfi_field_row(1).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(11).tfi_field_row(1).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(11).tfi_field_row(1).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(11).tfi_field_row(1).tfi_field('VERSION') := 1;
  TFI_MAP(11).tfi_field_row(1).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(11).tfi_field_row(1).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(11).tfi_field_row(1).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(11).tfi_field_row(1).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(11).tfi_field_row(1).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(11).tfi_field_row(1).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(11).tfi_field_row(1).tfi_field('BORRADO') := 0;
  
  TFI_MAP(11).tfi_field_row(2).tfi_field('TFI_ORDEN') := 2;
  TFI_MAP(11).tfi_field_row(2).tfi_field('TFI_TIPO') := 'combobox';
  TFI_MAP(11).tfi_field_row(2).tfi_field('TFI_NOMBRE') := 'motivoAnulacion';
  TFI_MAP(11).tfi_field_row(2).tfi_field('TFI_LABEL') :=  'Motivo anulación';
  TFI_MAP(11).tfi_field_row(2).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(11).tfi_field_row(2).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(11).tfi_field_row(2).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(11).tfi_field_row(2).tfi_field('TFI_BUSINESS_OPERATION') := 'DDMotivoAnulacionExpediente';
  TFI_MAP(11).tfi_field_row(2).tfi_field('VERSION') := 1;
  TFI_MAP(11).tfi_field_row(2).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(11).tfi_field_row(2).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(11).tfi_field_row(2).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(11).tfi_field_row(2).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(11).tfi_field_row(2).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(11).tfi_field_row(2).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(11).tfi_field_row(2).tfi_field('BORRADO') := 0;
    
  TFI_MAP(11).tfi_field_row(3).tfi_field('TFI_ORDEN') := 3;
  TFI_MAP(11).tfi_field_row(3).tfi_field('TFI_TIPO') := 'combobox';
  TFI_MAP(11).tfi_field_row(3).tfi_field('TFI_NOMBRE') := 'comboProcede';
  TFI_MAP(11).tfi_field_row(3).tfi_field('TFI_LABEL') :=  'Procede Devolución';
  TFI_MAP(11).tfi_field_row(3).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(11).tfi_field_row(3).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(11).tfi_field_row(3).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(11).tfi_field_row(3).tfi_field('TFI_BUSINESS_OPERATION') := 'DDDevolucionReserva';
  TFI_MAP(11).tfi_field_row(3).tfi_field('VERSION') := 1;
  TFI_MAP(11).tfi_field_row(3).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(11).tfi_field_row(3).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(11).tfi_field_row(3).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(11).tfi_field_row(3).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(11).tfi_field_row(3).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(11).tfi_field_row(3).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(11).tfi_field_row(3).tfi_field('BORRADO') := 0;

  TFI_MAP(11).tfi_field_row(4).tfi_field('TFI_ORDEN') := 4;
  TFI_MAP(11).tfi_field_row(4).tfi_field('TFI_TIPO') := 'combobox';
  TFI_MAP(11).tfi_field_row(4).tfi_field('TFI_NOMBRE') := 'comboMotivoAnulacionReserva';
  TFI_MAP(11).tfi_field_row(4).tfi_field('TFI_LABEL') :=  'Motivo anulación reserva';
  TFI_MAP(11).tfi_field_row(4).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(11).tfi_field_row(4).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(11).tfi_field_row(4).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(11).tfi_field_row(4).tfi_field('TFI_BUSINESS_OPERATION') := 'DDMotivoAnulacionReserva';
  TFI_MAP(11).tfi_field_row(4).tfi_field('VERSION') := 1;
  TFI_MAP(11).tfi_field_row(4).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(11).tfi_field_row(4).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(11).tfi_field_row(4).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(11).tfi_field_row(4).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(11).tfi_field_row(4).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(11).tfi_field_row(4).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(11).tfi_field_row(4).tfi_field('BORRADO') := 0;

  TFI_MAP(11).tfi_field_row(5).tfi_field('TFI_ORDEN') := 5;
  TFI_MAP(11).tfi_field_row(5).tfi_field('TFI_TIPO') := 'textinf';
  TFI_MAP(11).tfi_field_row(5).tfi_field('TFI_NOMBRE') := 'estadoReserva';
  TFI_MAP(11).tfi_field_row(5).tfi_field('TFI_LABEL') :=  'Estado reserva';
  TFI_MAP(11).tfi_field_row(5).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(11).tfi_field_row(5).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(11).tfi_field_row(5).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(11).tfi_field_row(5).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(11).tfi_field_row(5).tfi_field('VERSION') := 1;
  TFI_MAP(11).tfi_field_row(5).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(11).tfi_field_row(5).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(11).tfi_field_row(5).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(11).tfi_field_row(5).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(11).tfi_field_row(5).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(11).tfi_field_row(5).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(11).tfi_field_row(5).tfi_field('BORRADO') := 0;

  TFI_MAP(11).tfi_field_row(6).tfi_field('TFI_ORDEN') := 6;
  TFI_MAP(11).tfi_field_row(6).tfi_field('TFI_TIPO') := 'textarea';
  TFI_MAP(11).tfi_field_row(6).tfi_field('TFI_NOMBRE') := 'observaciones';
  TFI_MAP(11).tfi_field_row(6).tfi_field('TFI_LABEL') :=  'Observaciones';
  TFI_MAP(11).tfi_field_row(6).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(11).tfi_field_row(6).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(11).tfi_field_row(6).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(11).tfi_field_row(6).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(11).tfi_field_row(6).tfi_field('VERSION') := 1;
  TFI_MAP(11).tfi_field_row(6).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(11).tfi_field_row(6).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(11).tfi_field_row(6).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(11).tfi_field_row(6).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(11).tfi_field_row(6).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(11).tfi_field_row(6).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(11).tfi_field_row(6).tfi_field('BORRADO') := 0;


----------------------------------------------------------------------------
----------------RESPUESTA BANKIA SOBRE LA DEVOLUCION------------------------
----------------------------------------------------------------------------
  TAP(12).tap_field('TAP_CODIGO') := 'T013_RespuestaBankiaDevolucion';
  TAP(12).tap_field('TAP_VIEW') := NULL;
  TAP(12).tap_field('TAP_SCRIPT_VALIDACION') := NULL;
  TAP(12).tap_field('TAP_SCRIPT_VALIDACION_JBPM') := NULL;
  TAP(12).tap_field('TAP_SCRIPT_DECISION') := NULL;
  TAP(12).tap_field('DD_TPO_ID_BPM') := null;
  TAP(12).tap_field('TAP_SUPERVISOR') := 0;
  TAP(12).tap_field('TAP_DESCRIPCION') := 'Respuesta Bankia sobre la devolución';
  TAP(12).tap_field('VERSION') := 0;
  TAP(12).tap_field('USUARIOCREAR') := USUARIOCREAR;
  TAP(12).tap_field('FECHACREAR') := SYSDATE;
  TAP(12).tap_field('USUARIOMODIFICAR') := NULL;
  TAP(12).tap_field('FECHAMODIFICAR') := NULL;
  TAP(12).tap_field('USUARIOBORRAR') := NULL;
  TAP(12).tap_field('FECHABORRAR') := NULL;
  TAP(12).tap_field('BORRADO') := 0;
  TAP(12).tap_field('TAP_ALERT_NO_RETORNO') := NULL;
  TAP(12).tap_field('TAP_ALERT_VUELTA_ATRAS') := NULL;
  TAP(12).tap_field('DD_FAP_ID') := NULL;
  TAP(12).tap_field('TAP_AUTOPRORROGA') := 0;
  TAP(12).tap_field('DTYPE') := 'EXTTareaProcedimiento';
  TAP(12).tap_field('TAP_MAX_AUTOP') := 3;
  V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ' || is_string('SUPER');
  EXECUTE IMMEDIATE V_SQL INTO TAP(12).tap_field('DD_TGE_ID');
  V_SQL := 'SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ' || is_string('811');
  EXECUTE IMMEDIATE V_SQL INTO TAP(12).tap_field('DD_STA_ID');
  TAP(12).tap_field('TAP_EVITAR_REORG') := NULL;
  TAP(12).tap_field('DD_TSUP_ID') := NULL;
  TAP(12).tap_field('TAP_BUCLE_BPM') := NULL;
  ----------------------------------------------------------------------------
----------------------- MAPEO DE PTP PLAZOS--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL PTP_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------
    --PTP(12).ptp_field('DD_PTP_ID'); SE RECUPERA / GENERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(12).ptp_field('DD_JUZ_ID') := null;
    PTP(12).ptp_field('DD_PLA_ID') := null;
    --PTP(12).ptp_field('TAP_ID'); SE RECUPERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(12).ptp_field('DD_PTP_PLAZO_SCRIPT') := '3*24*60*60*1000L';
    PTP(12).ptp_field('VERSION') := 1;
    PTP(12).ptp_field('USUARIOCREAR') := USUARIOCREAR;
    PTP(12).ptp_field('FECHACREAR') := SYSDATE;
    PTP(12).ptp_field('USUARIOMODIFICAR') := null;
    PTP(12).ptp_field('FECHAMODIFICAR') := null;
    PTP(12).ptp_field('USUARIOBORRAR') := null;
    PTP(12).ptp_field('FECHABORRAR') :=null;
    PTP(12).ptp_field('BORRADO') := 0;
    PTP(12).ptp_field('DD_PTP_ABSOLUTO') := 0;
    PTP(12).ptp_field('DD_PTP_OBSERVACIONES') := null;
    
----------------------------------------------------------------------------
----------------------- MAPEO DE TFI PROCEDIMIENTO--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL TFI_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------

----------------------------FORM ITEMS--------------------------------------
  TFI_MAP(12).tfi_field_row(0).tfi_field('TFI_ORDEN') := 0;
  TFI_MAP(12).tfi_field_row(0).tfi_field('TFI_TIPO') := 'label';
  TFI_MAP(12).tfi_field_row(0).tfi_field('TFI_NOMBRE') := 'titulo';
  TFI_MAP(12).tfi_field_row(0).tfi_field('TFI_LABEL') :=  '<p style="margin-bottom: 10px">Esta tarea espera la resolución por parte de Bankia para proceder o no a la devolución de la reserva.</p>';
  TFI_MAP(12).tfi_field_row(0).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(12).tfi_field_row(0).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(12).tfi_field_row(0).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(12).tfi_field_row(0).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(12).tfi_field_row(0).tfi_field('VERSION') := 1;
  TFI_MAP(12).tfi_field_row(0).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(12).tfi_field_row(0).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(12).tfi_field_row(0).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(12).tfi_field_row(0).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(12).tfi_field_row(0).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(12).tfi_field_row(0).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(12).tfi_field_row(0).tfi_field('BORRADO') := 0;
  
  TFI_MAP(12).tfi_field_row(1).tfi_field('TFI_ORDEN') := 1;
  TFI_MAP(12).tfi_field_row(1).tfi_field('TFI_TIPO') := 'datefield';
  TFI_MAP(12).tfi_field_row(1).tfi_field('TFI_NOMBRE') := 'fecha';
  TFI_MAP(12).tfi_field_row(1).tfi_field('TFI_LABEL') :=  'Fecha respuesta';
  TFI_MAP(12).tfi_field_row(1).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(12).tfi_field_row(1).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(12).tfi_field_row(1).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(12).tfi_field_row(1).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(12).tfi_field_row(1).tfi_field('VERSION') := 1;
  TFI_MAP(12).tfi_field_row(1).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(12).tfi_field_row(1).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(12).tfi_field_row(1).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(12).tfi_field_row(1).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(12).tfi_field_row(1).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(12).tfi_field_row(1).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(12).tfi_field_row(1).tfi_field('BORRADO') := 0;
  
  TFI_MAP(12).tfi_field_row(2).tfi_field('TFI_ORDEN') := 2;
  TFI_MAP(12).tfi_field_row(2).tfi_field('TFI_TIPO') := 'combobox';
  TFI_MAP(12).tfi_field_row(2).tfi_field('TFI_NOMBRE') := 'comboRespuesta';
  TFI_MAP(12).tfi_field_row(2).tfi_field('TFI_LABEL') :=  'Respuesta de la devolución';
  TFI_MAP(12).tfi_field_row(2).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(12).tfi_field_row(2).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(12).tfi_field_row(2).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(12).tfi_field_row(2).tfi_field('TFI_BUSINESS_OPERATION') := 'DDSiNo';
  TFI_MAP(12).tfi_field_row(2).tfi_field('VERSION') := 1;
  TFI_MAP(12).tfi_field_row(2).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(12).tfi_field_row(2).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(12).tfi_field_row(2).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(12).tfi_field_row(2).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(12).tfi_field_row(2).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(12).tfi_field_row(2).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(12).tfi_field_row(2).tfi_field('BORRADO') := 0;

  TFI_MAP(12).tfi_field_row(3).tfi_field('TFI_ORDEN') := 3;
  TFI_MAP(12).tfi_field_row(3).tfi_field('TFI_TIPO') := 'textarea';
  TFI_MAP(12).tfi_field_row(3).tfi_field('TFI_NOMBRE') := 'observaciones';
  TFI_MAP(12).tfi_field_row(3).tfi_field('TFI_LABEL') :=  'Observaciones';
  TFI_MAP(12).tfi_field_row(3).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(12).tfi_field_row(3).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(12).tfi_field_row(3).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(12).tfi_field_row(3).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(12).tfi_field_row(3).tfi_field('VERSION') := 1;
  TFI_MAP(12).tfi_field_row(3).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(12).tfi_field_row(3).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(12).tfi_field_row(3).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(12).tfi_field_row(3).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(12).tfi_field_row(3).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(12).tfi_field_row(3).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(12).tfi_field_row(3).tfi_field('BORRADO') := 0;

----------------------------------------------------------------------------
--------------------------Pendiente Devolucion------------------------------
----------------------------------------------------------------------------
  TAP(13).tap_field('TAP_CODIGO') := 'T013_PendienteDevolucion';
  TAP(13).tap_field('TAP_VIEW') := NULL;
  TAP(13).tap_field('TAP_SCRIPT_VALIDACION') := NULL;
  TAP(13).tap_field('TAP_SCRIPT_VALIDACION_JBPM') := NULL;
  TAP(13).tap_field('TAP_SCRIPT_DECISION') := NULL;
  TAP(13).tap_field('DD_TPO_ID_BPM') := null;
  TAP(13).tap_field('TAP_SUPERVISOR') := 0;
  TAP(13).tap_field('TAP_DESCRIPCION') := 'Pendiente de la devolución';
  TAP(13).tap_field('VERSION') := 0;
  TAP(13).tap_field('USUARIOCREAR') := USUARIOCREAR;
  TAP(13).tap_field('FECHACREAR') := SYSDATE;
  TAP(13).tap_field('USUARIOMODIFICAR') := NULL;
  TAP(13).tap_field('FECHAMODIFICAR') := NULL;
  TAP(13).tap_field('USUARIOBORRAR') := NULL;
  TAP(13).tap_field('FECHABORRAR') := NULL;
  TAP(13).tap_field('BORRADO') := 0;
  TAP(13).tap_field('TAP_ALERT_NO_RETORNO') := NULL;
  TAP(13).tap_field('TAP_ALERT_VUELTA_ATRAS') := NULL;
  TAP(13).tap_field('DD_FAP_ID') := NULL;
  TAP(13).tap_field('TAP_AUTOPRORROGA') := 0;
  TAP(13).tap_field('DTYPE') := 'EXTTareaProcedimiento';
  TAP(13).tap_field('TAP_MAX_AUTOP') := 3;
  V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ' || is_string('SUPER');
  EXECUTE IMMEDIATE V_SQL INTO TAP(13).tap_field('DD_TGE_ID');
  V_SQL := 'SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ' || is_string('811');
  EXECUTE IMMEDIATE V_SQL INTO TAP(13).tap_field('DD_STA_ID');
  TAP(13).tap_field('TAP_EVITAR_REORG') := NULL;
  TAP(13).tap_field('DD_TSUP_ID') := NULL;
  TAP(13).tap_field('TAP_BUCLE_BPM') := NULL;
  ----------------------------------------------------------------------------
----------------------- MAPEO DE PTP PLAZOS--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL PTP_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------
    --PTP(13).ptp_field('DD_PTP_ID'); SE RECUPERA / GENERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(13).ptp_field('DD_JUZ_ID') := null;
    PTP(13).ptp_field('DD_PLA_ID') := null;
    --PTP(13).ptp_field('TAP_ID'); SE RECUPERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(13).ptp_field('DD_PTP_PLAZO_SCRIPT') := '3*24*60*60*1000L';
    PTP(13).ptp_field('VERSION') := 1;
    PTP(13).ptp_field('USUARIOCREAR') := USUARIOCREAR;
    PTP(13).ptp_field('FECHACREAR') := SYSDATE;
    PTP(13).ptp_field('USUARIOMODIFICAR') := null;
    PTP(13).ptp_field('FECHAMODIFICAR') := null;
    PTP(13).ptp_field('USUARIOBORRAR') := null;
    PTP(13).ptp_field('FECHABORRAR') :=null;
    PTP(13).ptp_field('BORRADO') := 0;
    PTP(13).ptp_field('DD_PTP_ABSOLUTO') := 0;
    PTP(13).ptp_field('DD_PTP_OBSERVACIONES') := null;
    
----------------------------------------------------------------------------
----------------------- MAPEO DE TFI PROCEDIMIENTO--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL TFI_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------

----------------------------FORM ITEMS--------------------------------------
  TFI_MAP(13).tfi_field_row(0).tfi_field('TFI_ORDEN') := 0;
  TFI_MAP(13).tfi_field_row(0).tfi_field('TFI_TIPO') := 'label';
  TFI_MAP(13).tfi_field_row(0).tfi_field('TFI_NOMBRE') := 'titulo';
  TFI_MAP(13).tfi_field_row(0).tfi_field('TFI_LABEL') :=  '<p style="margin-bottom: 10px">Esta tarea espera la devolución de la reserva por parte de Bankia. Es posible anular esta devolución durante esta tarea.</p>';
  TFI_MAP(13).tfi_field_row(0).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(13).tfi_field_row(0).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(13).tfi_field_row(0).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(13).tfi_field_row(0).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(13).tfi_field_row(0).tfi_field('VERSION') := 1;
  TFI_MAP(13).tfi_field_row(0).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(13).tfi_field_row(0).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(13).tfi_field_row(0).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(13).tfi_field_row(0).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(13).tfi_field_row(0).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(13).tfi_field_row(0).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(13).tfi_field_row(0).tfi_field('BORRADO') := 0;
  
  TFI_MAP(13).tfi_field_row(1).tfi_field('TFI_ORDEN') := 1;
  TFI_MAP(13).tfi_field_row(1).tfi_field('TFI_TIPO') := 'datefield';
  TFI_MAP(13).tfi_field_row(1).tfi_field('TFI_NOMBRE') := 'fecha';
  TFI_MAP(13).tfi_field_row(1).tfi_field('TFI_LABEL') :=  'Fecha respuesta';
  TFI_MAP(13).tfi_field_row(1).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(13).tfi_field_row(1).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(13).tfi_field_row(1).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(13).tfi_field_row(1).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(13).tfi_field_row(1).tfi_field('VERSION') := 1;
  TFI_MAP(13).tfi_field_row(1).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(13).tfi_field_row(1).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(13).tfi_field_row(1).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(13).tfi_field_row(1).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(13).tfi_field_row(1).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(13).tfi_field_row(1).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(13).tfi_field_row(1).tfi_field('BORRADO') := 0;
  
  TFI_MAP(13).tfi_field_row(2).tfi_field('TFI_ORDEN') := 2;
  TFI_MAP(13).tfi_field_row(2).tfi_field('TFI_TIPO') := 'combobox';
  TFI_MAP(13).tfi_field_row(2).tfi_field('TFI_NOMBRE') := 'comboRespuesta';
  TFI_MAP(13).tfi_field_row(2).tfi_field('TFI_LABEL') :=  'Reserva devuelta';
  TFI_MAP(13).tfi_field_row(2).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(13).tfi_field_row(2).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(13).tfi_field_row(2).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(13).tfi_field_row(2).tfi_field('TFI_BUSINESS_OPERATION') := 'DDSiNo';
  TFI_MAP(13).tfi_field_row(2).tfi_field('VERSION') := 1;
  TFI_MAP(13).tfi_field_row(2).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(13).tfi_field_row(2).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(13).tfi_field_row(2).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(13).tfi_field_row(2).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(13).tfi_field_row(2).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(13).tfi_field_row(2).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(13).tfi_field_row(2).tfi_field('BORRADO') := 0;
  
  TFI_MAP(13).tfi_field_row(3).tfi_field('TFI_ORDEN') := 3;
  TFI_MAP(13).tfi_field_row(3).tfi_field('TFI_TIPO') := 'textarea';
  TFI_MAP(13).tfi_field_row(3).tfi_field('TFI_NOMBRE') := 'observaciones';
  TFI_MAP(13).tfi_field_row(3).tfi_field('TFI_LABEL') :=  'Observaciones';
  TFI_MAP(13).tfi_field_row(3).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(13).tfi_field_row(3).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(13).tfi_field_row(3).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(13).tfi_field_row(3).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(13).tfi_field_row(3).tfi_field('VERSION') := 1;
  TFI_MAP(13).tfi_field_row(3).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(13).tfi_field_row(3).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(13).tfi_field_row(3).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(13).tfi_field_row(3).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(13).tfi_field_row(3).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(13).tfi_field_row(3).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(13).tfi_field_row(3).tfi_field('BORRADO') := 0;

----------------------------------------------------------------------------
--------------RESPUESTA BANKIA ANULACION DEVOLUCION-------------------------
----------------------------------------------------------------------------
  TAP(14).tap_field('TAP_CODIGO') := 'T013_RespuestaBankiaAnulacionDevolucion';
  TAP(14).tap_field('TAP_VIEW') := NULL;
  TAP(14).tap_field('TAP_SCRIPT_VALIDACION') := NULL;
  TAP(14).tap_field('TAP_SCRIPT_VALIDACION_JBPM') := NULL;
  TAP(14).tap_field('TAP_SCRIPT_DECISION') := NULL;
  TAP(14).tap_field('DD_TPO_ID_BPM') := null;
  TAP(14).tap_field('TAP_SUPERVISOR') := 0;
  TAP(14).tap_field('TAP_DESCRIPCION') := 'Respuesta Bankia sobre la anulación de la devolución';
  TAP(14).tap_field('VERSION') := 0;
  TAP(14).tap_field('USUARIOCREAR') := USUARIOCREAR;
  TAP(14).tap_field('FECHACREAR') := SYSDATE;
  TAP(14).tap_field('USUARIOMODIFICAR') := NULL;
  TAP(14).tap_field('FECHAMODIFICAR') := NULL;
  TAP(14).tap_field('USUARIOBORRAR') := NULL;
  TAP(14).tap_field('FECHABORRAR') := NULL;
  TAP(14).tap_field('BORRADO') := 0;
  TAP(14).tap_field('TAP_ALERT_NO_RETORNO') := NULL;
  TAP(14).tap_field('TAP_ALERT_VUELTA_ATRAS') := NULL;
  TAP(14).tap_field('DD_FAP_ID') := NULL;
  TAP(14).tap_field('TAP_AUTOPRORROGA') := 0;
  TAP(14).tap_field('DTYPE') := 'EXTTareaProcedimiento';
  TAP(14).tap_field('TAP_MAX_AUTOP') := 3;
  V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ' || is_string('SUPER');
  EXECUTE IMMEDIATE V_SQL INTO TAP(14).tap_field('DD_TGE_ID');
  V_SQL := 'SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ' || is_string('811');
  EXECUTE IMMEDIATE V_SQL INTO TAP(14).tap_field('DD_STA_ID');
  TAP(14).tap_field('TAP_EVITAR_REORG') := NULL;
  TAP(14).tap_field('DD_TSUP_ID') := NULL;
  TAP(14).tap_field('TAP_BUCLE_BPM') := NULL;
  ----------------------------------------------------------------------------
----------------------- MAPEO DE PTP PLAZOS--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL PTP_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------
    --PTP(14).ptp_field('DD_PTP_ID'); SE RECUPERA / GENERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(14).ptp_field('DD_JUZ_ID') := null;
    PTP(14).ptp_field('DD_PLA_ID') := null;
    --PTP(14).ptp_field('TAP_ID'); SE RECUPERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(14).ptp_field('DD_PTP_PLAZO_SCRIPT') := '3*24*60*60*1000L';
    PTP(14).ptp_field('VERSION') := 1;
    PTP(14).ptp_field('USUARIOCREAR') := USUARIOCREAR;
    PTP(14).ptp_field('FECHACREAR') := SYSDATE;
    PTP(14).ptp_field('USUARIOMODIFICAR') := null;
    PTP(14).ptp_field('FECHAMODIFICAR') := null;
    PTP(14).ptp_field('USUARIOBORRAR') := null;
    PTP(14).ptp_field('FECHABORRAR') :=null;
    PTP(14).ptp_field('BORRADO') := 0;
    PTP(14).ptp_field('DD_PTP_ABSOLUTO') := 0;
    PTP(14).ptp_field('DD_PTP_OBSERVACIONES') := null;
    
----------------------------------------------------------------------------
----------------------- MAPEO DE TFI PROCEDIMIENTO--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL TFI_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------

----------------------------FORM ITEMS--------------------------------------
  TFI_MAP(14).tfi_field_row(0).tfi_field('TFI_ORDEN') := 0;
  TFI_MAP(14).tfi_field_row(0).tfi_field('TFI_TIPO') := 'label';
  TFI_MAP(14).tfi_field_row(0).tfi_field('TFI_NOMBRE') := 'titulo';
  TFI_MAP(14).tfi_field_row(0).tfi_field('TFI_LABEL') :=  '<p style="margin-bottom: 10px">Esta tarea espera la resolución por parte de Bankia para la anulación de la devolución de la reserva.</p>';
  TFI_MAP(14).tfi_field_row(0).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(14).tfi_field_row(0).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(14).tfi_field_row(0).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(14).tfi_field_row(0).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(14).tfi_field_row(0).tfi_field('VERSION') := 1;
  TFI_MAP(14).tfi_field_row(0).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(14).tfi_field_row(0).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(14).tfi_field_row(0).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(14).tfi_field_row(0).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(14).tfi_field_row(0).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(14).tfi_field_row(0).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(14).tfi_field_row(0).tfi_field('BORRADO') := 0;
  
  TFI_MAP(14).tfi_field_row(1).tfi_field('TFI_ORDEN') := 1;
  TFI_MAP(14).tfi_field_row(1).tfi_field('TFI_TIPO') := 'datefield';
  TFI_MAP(14).tfi_field_row(1).tfi_field('TFI_NOMBRE') := 'fecha';
  TFI_MAP(14).tfi_field_row(1).tfi_field('TFI_LABEL') :=  'Fecha respuesta';
  TFI_MAP(14).tfi_field_row(1).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(14).tfi_field_row(1).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(14).tfi_field_row(1).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(14).tfi_field_row(1).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(14).tfi_field_row(1).tfi_field('VERSION') := 1;
  TFI_MAP(14).tfi_field_row(1).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(14).tfi_field_row(1).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(14).tfi_field_row(1).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(14).tfi_field_row(1).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(14).tfi_field_row(1).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(14).tfi_field_row(1).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(14).tfi_field_row(1).tfi_field('BORRADO') := 0;
  
  TFI_MAP(14).tfi_field_row(2).tfi_field('TFI_ORDEN') := 2;
  TFI_MAP(14).tfi_field_row(2).tfi_field('TFI_TIPO') := 'combobox';
  TFI_MAP(14).tfi_field_row(2).tfi_field('TFI_NOMBRE') := 'comboRespuesta';
  TFI_MAP(14).tfi_field_row(2).tfi_field('TFI_LABEL') :=  'Respuesta anulación de la devolución';
  TFI_MAP(14).tfi_field_row(2).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(14).tfi_field_row(2).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(14).tfi_field_row(2).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(14).tfi_field_row(2).tfi_field('TFI_BUSINESS_OPERATION') := 'DDSiNo';
  TFI_MAP(14).tfi_field_row(2).tfi_field('VERSION') := 1;
  TFI_MAP(14).tfi_field_row(2).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(14).tfi_field_row(2).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(14).tfi_field_row(2).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(14).tfi_field_row(2).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(14).tfi_field_row(2).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(14).tfi_field_row(2).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(14).tfi_field_row(2).tfi_field('BORRADO') := 0;

  TFI_MAP(14).tfi_field_row(3).tfi_field('TFI_ORDEN') := 3;
  TFI_MAP(14).tfi_field_row(3).tfi_field('TFI_TIPO') := 'textarea';
  TFI_MAP(14).tfi_field_row(3).tfi_field('TFI_NOMBRE') := 'observaciones';
  TFI_MAP(14).tfi_field_row(3).tfi_field('TFI_LABEL') :=  'Observaciones';
  TFI_MAP(14).tfi_field_row(3).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(14).tfi_field_row(3).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(14).tfi_field_row(3).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(14).tfi_field_row(3).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(14).tfi_field_row(3).tfi_field('VERSION') := 1;
  TFI_MAP(14).tfi_field_row(3).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(14).tfi_field_row(3).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(14).tfi_field_row(3).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(14).tfi_field_row(3).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(14).tfi_field_row(3).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(14).tfi_field_row(3).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(14).tfi_field_row(3).tfi_field('BORRADO') := 0;

----------------------------------------------------------------------------
--------------------------Devolucion llaves---------------------------------
----------------------------------------------------------------------------
  TAP(15).tap_field('TAP_CODIGO') := 'T013_DevolucionLlaves';
  TAP(15).tap_field('TAP_VIEW') := NULL;
  TAP(15).tap_field('TAP_SCRIPT_VALIDACION') := 'checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''';
  TAP(15).tap_field('TAP_SCRIPT_VALIDACION_JBPM') := NULL;
  TAP(15).tap_field('TAP_SCRIPT_DECISION') := ' checkReserva() ? ''''ConReserva'''' : ''''SinReserva''''';
  TAP(15).tap_field('DD_TPO_ID_BPM') := null;
  TAP(15).tap_field('TAP_SUPERVISOR') := 0;
  TAP(15).tap_field('TAP_DESCRIPCION') := 'Devolución de llaves HRE';
  TAP(15).tap_field('VERSION') := 0;
  TAP(15).tap_field('USUARIOCREAR') := USUARIOCREAR;
  TAP(15).tap_field('FECHACREAR') := SYSDATE;
  TAP(15).tap_field('USUARIOMODIFICAR') := NULL;
  TAP(15).tap_field('FECHAMODIFICAR') := NULL;
  TAP(15).tap_field('USUARIOBORRAR') := NULL;
  TAP(15).tap_field('FECHABORRAR') := NULL;
  TAP(15).tap_field('BORRADO') := 0;
  TAP(15).tap_field('TAP_ALERT_NO_RETORNO') := NULL;
  TAP(15).tap_field('TAP_ALERT_VUELTA_ATRAS') := NULL;
  TAP(15).tap_field('DD_FAP_ID') := NULL;
  TAP(15).tap_field('TAP_AUTOPRORROGA') := 0;
  TAP(15).tap_field('DTYPE') := 'EXTTareaProcedimiento';
  TAP(15).tap_field('TAP_MAX_AUTOP') := 3;
  V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ' || is_string('SUPER');
  EXECUTE IMMEDIATE V_SQL INTO TAP(15).tap_field('DD_TGE_ID');
  V_SQL := 'SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ' || is_string('811');
  EXECUTE IMMEDIATE V_SQL INTO TAP(15).tap_field('DD_STA_ID');
  TAP(15).tap_field('TAP_EVITAR_REORG') := NULL;
  TAP(15).tap_field('DD_TSUP_ID') := NULL;
  TAP(15).tap_field('TAP_BUCLE_BPM') := NULL;
  ----------------------------------------------------------------------------
----------------------- MAPEO DE PTP PLAZOS--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL PTP_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------
    --PTP(15).ptp_field('DD_PTP_ID'); SE RECUPERA / GENERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(15).ptp_field('DD_JUZ_ID') := null;
    PTP(15).ptp_field('DD_PLA_ID') := null;
    --PTP(15).ptp_field('TAP_ID'); SE RECUPERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(15).ptp_field('DD_PTP_PLAZO_SCRIPT') := '3*24*60*60*1000L';
    PTP(15).ptp_field('VERSION') := 1;
    PTP(15).ptp_field('USUARIOCREAR') := USUARIOCREAR;
    PTP(15).ptp_field('FECHACREAR') := SYSDATE;
    PTP(15).ptp_field('USUARIOMODIFICAR') := null;
    PTP(15).ptp_field('FECHAMODIFICAR') := null;
    PTP(15).ptp_field('USUARIOBORRAR') := null;
    PTP(15).ptp_field('FECHABORRAR') :=null;
    PTP(15).ptp_field('BORRADO') := 0;
    PTP(15).ptp_field('DD_PTP_ABSOLUTO') := 0;
    PTP(15).ptp_field('DD_PTP_OBSERVACIONES') := null;
    
----------------------------------------------------------------------------
----------------------- MAPEO DE TFI PROCEDIMIENTO--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL TFI_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------

----------------------------FORM ITEMS--------------------------------------
  TFI_MAP(15).tfi_field_row(0).tfi_field('TFI_ORDEN') := 0;
  TFI_MAP(15).tfi_field_row(0).tfi_field('TFI_TIPO') := 'label';
  TFI_MAP(15).tfi_field_row(0).tfi_field('TFI_NOMBRE') := 'titulo';
  TFI_MAP(15).tfi_field_row(0).tfi_field('TFI_LABEL') :=  '<p style="margin-bottom: 10px">
  La operación se ha anulado. Envíe de vuelta las llaves al gestor correspondiente, 
  indicando a a continuación la fecha de envío</p> <p style="margin-bottom: 10px">
  En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar 
  reflejado en este punto del trámite.</p>';
  TFI_MAP(15).tfi_field_row(0).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(15).tfi_field_row(0).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(15).tfi_field_row(0).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(15).tfi_field_row(0).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(15).tfi_field_row(0).tfi_field('VERSION') := 1;
  TFI_MAP(15).tfi_field_row(0).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(15).tfi_field_row(0).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(15).tfi_field_row(0).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(15).tfi_field_row(0).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(15).tfi_field_row(0).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(15).tfi_field_row(0).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(15).tfi_field_row(0).tfi_field('BORRADO') := 0;
  
  TFI_MAP(15).tfi_field_row(1).tfi_field('TFI_ORDEN') := 1;
  TFI_MAP(15).tfi_field_row(1).tfi_field('TFI_TIPO') := 'datefield';
  TFI_MAP(15).tfi_field_row(1).tfi_field('TFI_NOMBRE') := 'fechaEnvio';
  TFI_MAP(15).tfi_field_row(1).tfi_field('TFI_LABEL') :=  'Fecha envío';
  TFI_MAP(15).tfi_field_row(1).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(15).tfi_field_row(1).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(15).tfi_field_row(1).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(15).tfi_field_row(1).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(15).tfi_field_row(1).tfi_field('VERSION') := 1;
  TFI_MAP(15).tfi_field_row(1).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(15).tfi_field_row(1).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(15).tfi_field_row(1).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(15).tfi_field_row(1).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(15).tfi_field_row(1).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(15).tfi_field_row(1).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(15).tfi_field_row(1).tfi_field('BORRADO') := 0;
  
  TFI_MAP(15).tfi_field_row(2).tfi_field('TFI_ORDEN') := 2;
  TFI_MAP(15).tfi_field_row(2).tfi_field('TFI_TIPO') := 'datefield';
  TFI_MAP(15).tfi_field_row(2).tfi_field('TFI_NOMBRE') := 'fechaRespuesta';
  TFI_MAP(15).tfi_field_row(2).tfi_field('TFI_LABEL') :=  'Fecha respuesta';
  TFI_MAP(15).tfi_field_row(2).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(15).tfi_field_row(2).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(15).tfi_field_row(2).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(15).tfi_field_row(2).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(15).tfi_field_row(2).tfi_field('VERSION') := 1;
  TFI_MAP(15).tfi_field_row(2).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(15).tfi_field_row(2).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(15).tfi_field_row(2).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(15).tfi_field_row(2).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(15).tfi_field_row(2).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(15).tfi_field_row(2).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(15).tfi_field_row(2).tfi_field('BORRADO') := 0;

  TFI_MAP(15).tfi_field_row(3).tfi_field('TFI_ORDEN') := 3;
  TFI_MAP(15).tfi_field_row(3).tfi_field('TFI_TIPO') := 'textarea';
  TFI_MAP(15).tfi_field_row(3).tfi_field('TFI_NOMBRE') := 'observaciones';
  TFI_MAP(15).tfi_field_row(3).tfi_field('TFI_LABEL') :=  'Observaciones';
  TFI_MAP(15).tfi_field_row(3).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(15).tfi_field_row(3).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(15).tfi_field_row(3).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(15).tfi_field_row(3).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(15).tfi_field_row(3).tfi_field('VERSION') := 1;
  TFI_MAP(15).tfi_field_row(3).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(15).tfi_field_row(3).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(15).tfi_field_row(3).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(15).tfi_field_row(3).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(15).tfi_field_row(3).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(15).tfi_field_row(3).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(15).tfi_field_row(3).tfi_field('BORRADO') := 0;


----------------------------------------------------------------------------
--------------------------Documentos post-venta-----------------------------
----------------------------------------------------------------------------
  TAP(16).tap_field('TAP_CODIGO') := 'T013_DocumentosPostVenta';
  TAP(16).tap_field('TAP_VIEW') := NULL;
  TAP(16).tap_field('TAP_SCRIPT_VALIDACION') := 'checkImporteParticipacion() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''';
  TAP(16).tap_field('TAP_SCRIPT_VALIDACION_JBPM') := 'existeAdjuntoUGValidacion("19,E;17,E")';
  TAP(16).tap_field('TAP_SCRIPT_DECISION') := NULL;
  TAP(16).tap_field('DD_TPO_ID_BPM') := null;
  TAP(16).tap_field('TAP_SUPERVISOR') := 0;
  TAP(16).tap_field('TAP_DESCRIPCION') := 'Documentos post-venta';
  TAP(16).tap_field('VERSION') := 0;
  TAP(16).tap_field('USUARIOCREAR') := USUARIOCREAR;
  TAP(16).tap_field('FECHACREAR') := SYSDATE;
  TAP(16).tap_field('USUARIOMODIFICAR') := NULL;
  TAP(16).tap_field('FECHAMODIFICAR') := NULL;
  TAP(16).tap_field('USUARIOBORRAR') := NULL;
  TAP(16).tap_field('FECHABORRAR') := NULL;
  TAP(16).tap_field('BORRADO') := 0;
  TAP(16).tap_field('TAP_ALERT_NO_RETORNO') := NULL;
  TAP(16).tap_field('TAP_ALERT_VUELTA_ATRAS') := NULL;
  TAP(16).tap_field('DD_FAP_ID') := NULL;
  TAP(16).tap_field('TAP_AUTOPRORROGA') := 0;
  TAP(16).tap_field('DTYPE') := 'EXTTareaProcedimiento';
  TAP(16).tap_field('TAP_MAX_AUTOP') := 3;
  V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ' || is_string('GFORM');
  EXECUTE IMMEDIATE V_SQL INTO TAP(16).tap_field('DD_TGE_ID');
  V_SQL := 'SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ' || is_string('811');
  EXECUTE IMMEDIATE V_SQL INTO TAP(16).tap_field('DD_STA_ID');
  TAP(16).tap_field('TAP_EVITAR_REORG') := NULL;
  TAP(16).tap_field('DD_TSUP_ID') := NULL;
  TAP(16).tap_field('TAP_BUCLE_BPM') := NULL;
  ----------------------------------------------------------------------------
----------------------- MAPEO DE PTP PLAZOS--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL PTP_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------
    --PTP(16).ptp_field('DD_PTP_ID'); SE RECUPERA / GENERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(16).ptp_field('DD_JUZ_ID') := null;
    PTP(16).ptp_field('DD_PLA_ID') := null;
    --PTP(16).ptp_field('TAP_ID'); SE RECUPERA EN EL PROCEDIMIENTO PRINCIPAL
    PTP(16).ptp_field('DD_PTP_PLAZO_SCRIPT') := '3*24*60*60*1000L';
    PTP(16).ptp_field('VERSION') := 1;
    PTP(16).ptp_field('USUARIOCREAR') := USUARIOCREAR;
    PTP(16).ptp_field('FECHACREAR') := SYSDATE;
    PTP(16).ptp_field('USUARIOMODIFICAR') := null;
    PTP(16).ptp_field('FECHAMODIFICAR') := null;
    PTP(16).ptp_field('USUARIOBORRAR') := null;
    PTP(16).ptp_field('FECHABORRAR') :=null;
    PTP(16).ptp_field('BORRADO') := 0;
    PTP(16).ptp_field('DD_PTP_ABSOLUTO') := 0;
    PTP(16).ptp_field('DD_PTP_OBSERVACIONES') := null;
    
----------------------------------------------------------------------------
----------------------- MAPEO DE TFI PROCEDIMIENTO--------------------------
--EN CASO DE CREARSE UNA NUEVA ENTRADA, TANTO EL EL TFI_ID Y EL TAP_ID -----
----------------SE RECUPERAN EN EL PROCEDIMIENTO----------------------------

----------------------------FORM ITEMS--------------------------------------
  TFI_MAP(16).tfi_field_row(0).tfi_field('TFI_ORDEN') := 0;
  TFI_MAP(16).tfi_field_row(0).tfi_field('TFI_TIPO') := 'label';
  TFI_MAP(16).tfi_field_row(0).tfi_field('TFI_NOMBRE') := 'titulo';
  TFI_MAP(16).tfi_field_row(0).tfi_field('TFI_LABEL') :=  '"<p style="margin-bottom: 10px">Se ha otorgado la escritura del expediente asociado.
   Para finalizar esta tarea, se requiere que suba los documentos:</p>
<ul class="alternate" type="square">
<li>Copia simple.</li>
<li>Justificante ingreso importe compraventa.</li>
</ul>
<p style="margin-bottom: 10px">Adicionalmente, podr&aacute; adjuntar los siguientes documentos:</p>
<ul class="alternate" type="square">
<li>Liquidaci&oacute;n de plusval&iacute;a.</li>
<li>Recib&iacute; entrega de llaves</li>
<li>Comunicaci&oacute;n a la Comunidad de Propietarios</li>
</ul>
<p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto 
relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p>"';
  TFI_MAP(16).tfi_field_row(0).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(16).tfi_field_row(0).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(16).tfi_field_row(0).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(16).tfi_field_row(0).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(16).tfi_field_row(0).tfi_field('VERSION') := 1;
  TFI_MAP(16).tfi_field_row(0).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(16).tfi_field_row(0).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(16).tfi_field_row(0).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(16).tfi_field_row(0).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(16).tfi_field_row(0).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(16).tfi_field_row(0).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(16).tfi_field_row(0).tfi_field('BORRADO') := 0;
  
  TFI_MAP(16).tfi_field_row(1).tfi_field('TFI_ORDEN') := 1;
  TFI_MAP(16).tfi_field_row(1).tfi_field('TFI_TIPO') := 'datefield';
  TFI_MAP(16).tfi_field_row(1).tfi_field('TFI_NOMBRE') := 'fechaIngreso';
  TFI_MAP(16).tfi_field_row(1).tfi_field('TFI_LABEL') :=  'Fecha ingreso cheque';
  TFI_MAP(16).tfi_field_row(1).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(16).tfi_field_row(1).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(16).tfi_field_row(1).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(16).tfi_field_row(1).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(16).tfi_field_row(1).tfi_field('VERSION') := 1;
  TFI_MAP(16).tfi_field_row(1).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(16).tfi_field_row(1).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(16).tfi_field_row(1).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(16).tfi_field_row(1).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(16).tfi_field_row(1).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(16).tfi_field_row(1).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(16).tfi_field_row(1).tfi_field('BORRADO') := 0;
  
  TFI_MAP(16).tfi_field_row(2).tfi_field('TFI_ORDEN') := 2;
  TFI_MAP(16).tfi_field_row(2).tfi_field('TFI_TIPO') := 'checkbox';
  TFI_MAP(16).tfi_field_row(2).tfi_field('TFI_NOMBRE') := 'checkboxVentaDirecta';
  TFI_MAP(16).tfi_field_row(2).tfi_field('TFI_LABEL') :=  'Venta directa';
  TFI_MAP(16).tfi_field_row(2).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(16).tfi_field_row(2).tfi_field('TFI_VALIDACION') := 'false';
  TFI_MAP(16).tfi_field_row(2).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(16).tfi_field_row(2).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(16).tfi_field_row(2).tfi_field('VERSION') := 1;
  TFI_MAP(16).tfi_field_row(2).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(16).tfi_field_row(2).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(16).tfi_field_row(2).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(16).tfi_field_row(2).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(16).tfi_field_row(2).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(16).tfi_field_row(2).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(16).tfi_field_row(2).tfi_field('BORRADO') := 0;

  TFI_MAP(16).tfi_field_row(3).tfi_field('TFI_ORDEN') := 3;
  TFI_MAP(16).tfi_field_row(3).tfi_field('TFI_TIPO') := 'textarea';
  TFI_MAP(16).tfi_field_row(3).tfi_field('TFI_NOMBRE') := 'observaciones';
  TFI_MAP(16).tfi_field_row(3).tfi_field('TFI_LABEL') :=  'Observaciones';
  TFI_MAP(16).tfi_field_row(3).tfi_field('TFI_ERROR_VALIDACION') := NULL;
  TFI_MAP(16).tfi_field_row(3).tfi_field('TFI_VALIDACION') := NULL;
  TFI_MAP(16).tfi_field_row(3).tfi_field('TFI_VALOR_INICIAL') := NULL;
  TFI_MAP(16).tfi_field_row(3).tfi_field('TFI_BUSINESS_OPERATION') := NULL;
  TFI_MAP(16).tfi_field_row(3).tfi_field('VERSION') := 1;
  TFI_MAP(16).tfi_field_row(3).tfi_field('USUARIOCREAR') := USUARIOCREAR;
  TFI_MAP(16).tfi_field_row(3).tfi_field('FECHACREAR') := SYSDATE;
  TFI_MAP(16).tfi_field_row(3).tfi_field('USUARIOMODIFICAR') := NULL;
  TFI_MAP(16).tfi_field_row(3).tfi_field('FECHAMODIFICAR') := NULL;
  TFI_MAP(16).tfi_field_row(3).tfi_field('USUARIOBORRAR') := NULL;
  TFI_MAP(16).tfi_field_row(3).tfi_field('FECHABORRAR') := NULL;
  TFI_MAP(16).tfi_field_row(3).tfi_field('BORRADO') := 0;



----------------------------------------------------------------------------
----------------------------------------------------------------------------
---------------------------CREACION DEL BPM---------------------------------
  create_or_update_bpm(SCOPE_TAREA -1);
  COMMIT;
EXCEPTION
    when VALUE_ERROR then
        DBMS_OUTPUT.put_line('[ERROR] NO SE HA INTRODUCIDO UN VALOR NUMERICO');
    ROLLBACK;
        
     WHEN OTHERS THEN
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
