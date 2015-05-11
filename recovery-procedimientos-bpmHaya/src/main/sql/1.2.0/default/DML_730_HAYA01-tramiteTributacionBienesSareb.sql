/*
--######################################################################
--## Author: JoseVI
--## Adaptado a BP: JoseVI template direct-BPM-script-creator
--## BPM: H054 Trámite Costas contra Entidad
--## Finalidad: Insertar datos en tablas de configuración del BPM
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        + 0.1 Versión inicial
--######################################################################
--*/
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE

    /*
    * CONFIGURACION: ESQUEMAS
    *---------------------------------------------------------------------
    */
    PAR_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01';               -- [PARAMETRO] Configuracion Esquemas
    PAR_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER';    -- [PARAMETRO] Configuracion Esquemas

    /*
    * CONFIGURACION: TABLAS
    *---------------------------------------------------------------------
    */    
    PAR_TABLENAME_TPROC VARCHAR2(50 CHAR) := 'DD_TPO_TIPO_PROCEDIMIENTO';   -- [PARAMETRO] TABLA para tipo de procedimiento. Por defecto DD_TPO_TIPO_PROCEDIMIENTO
    PAR_TABLENAME_TARPR VARCHAR2(50 CHAR) := 'TAP_TAREA_PROCEDIMIENTO';     -- [PARAMETRO] TABLA para tareas del procedimiento. Por defecto TAP_TAREA_PROCEDIMIENTO
    PAR_TABLENAME_TPLAZ VARCHAR2(50 CHAR) := 'DD_PTP_PLAZOS_TAREAS_PLAZAS'; -- [PARAMETRO] TABLA para plazos de tareas. Por defecto DD_PTP_PLAZOS_TAREAS_PLAZAS
    PAR_TABLENAME_TFITE VARCHAR2(50 CHAR) := 'TFI_TAREAS_FORM_ITEMS';       -- [PARAMETRO] TABLA para items del form de tareas. Por defecto TFI_TAREAS_FORM_ITEMS

    /*
    * CONFIGURACION: IDENTIDAD SCRIPT
    *---------------------------------------------------------------------
    */
    PAR_TIT_TRAMITE VARCHAR2(50 CHAR)   := 'Tramite Homologacion de Acuerdo';   -- [PARAMETRO] Título del trámite
    PAR_AUTHOR VARCHAR2(20 CHAR)        := 'JoseVI';                            -- [PARAMETRO] Nick del autor
    PAR_AUTHOR_EMAIL VARCHAR2(50 CHAR)  := 'josevicente.jimenez@pfsgroup.es';   -- [PARAMETRO] Email del autor
    PAR_AUTHOR_TELF VARCHAR2(10 CHAR)   := '2026';                              -- [PARAMETRO] Teléfono del autor

    /*
    * VARIABLES DEL SCRIPT
    *---------------------------------------------------------------------
    */    
    V_MSQL VARCHAR2(32000 CHAR);                        -- Sentencia a ejecutar     
    V_SQL VARCHAR2(4000 CHAR);                          -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16);                            -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);                                 -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR);                        -- Vble. auxiliar para registrar errores en el script.

    VAR_SEQUENCENAME VARCHAR2(50 CHAR);                 -- Variable para secuencias
    VAR_CURR_ROWARRAY VARCHAR2(25 CHAR);                -- Variable con fila array actual - para excepciones
    VAR_CURR_TABLE VARCHAR2(50 CHAR);                   -- Variable con tabla actual - para excepciones



    /*
    * ARRAY TABLA1: DD_TPO_TIPO_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
      T_TIPO_TPO(
        /*DD_TPO_CODIGO.............::*/ 'H054',
        /*DD_TPO_DESCRIPCION.........:*/ 'T. Tributacion de Bienes Sareb',
        /*DD_TPO_DESCRIPCION_LARGA...:*/ 'Trámite de Tributación de Bienes Sareb',
        /*DD_TPO_HTML................:*/ null,
        /*DD_TPO_XML_JBPM............:*/ 'haya_tramiteTributacionBienesSareb',
        /*VERSION....................:*/ '0',
        /*USUARIOCREAR...............:*/ 'DD',
        /*BORRADO....................:*/ '0',
        /*DD_TAC_ID..................:*/ 'CO',
        /*DD_TPO_SALDO_MIN...........:*/ null,
        /*DD_TPO_SALDO_MAX...........:*/ null,
        /*FLAG_PRORROGA..............:*/ '1',
        /*DTYPE......................:*/ 'MEJTipoProcedimiento',
        /*FLAG_DERIVABLE.............:*/ '1',
        /*FLAG_UNICO_BIEN............:*/ '0'
        )  --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;


    /*
    * ARRAY TABLA2: TAP_TAREA_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(2000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
      T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ 'H054',
        /*TAP_CODIGO...................:*/ 'H054_ValidaBienesTributacion',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ 'valores[''H054_ValidaBienesTributacion''][''comboInformeFiscal''] == DDSiNo.SI ? ''SI'' : ''NO''',
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Validar información de los bienes / tributación',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '1',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ '39',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'GUCL',
        /*TAP_BUCLE_BPM................:*/ null        
        ), --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

      T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ 'H054',
        /*TAP_CODIGO...................:*/ 'H054_EmisionInformeFiscal',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ 'comprobarExisteDocumentoINFFIS() ? null : ''Es necesario adjuntar el Informe Fiscal''',
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ 'valores[''H054_EmisionInformeFiscal''][''comboResultadoInformeFiscal''] == DDTipoTributacion.IGIC ? ''ITP_IGIC'' : (valores[''H054_EmisionInformeFiscal''][''comboResultadoInformeFiscal''] == DDTipoTributacion.ITP ? ''ITP_IGIC'' : (valores[''H054_EmisionInformeFiscal''][''comboResultadoInformeFiscal''] == DDTipoTributacion.IVA ? ''Deducible'' : ''NoDeducible''))',
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Emisión del informe fiscal',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '1',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ '39',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'GUCL',
        /*TAP_BUCLE_BPM................:*/ null        
        ), --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

      T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ 'H054',
        /*TAP_CODIGO...................:*/ 'H054_ConfirmarComEmpresario',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ null,
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ '',
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Confirmar comunicación empresario sujeto pasivo',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '1',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ '39',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'GUCL',
        /*TAP_BUCLE_BPM................:*/ null        
        ), --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

      T_TIPO_TAP(
        /*DD_TPO_ID(FK)................:*/ 'H054',
        /*TAP_CODIGO...................:*/ 'H054_PresentarEscritoJuzgado',
        /*TAP_VIEW.....................:*/ null,
        /*TAP_SCRIPT_VALIDACION........:*/ 'comprobarExisteDocumentoEJUZTBS() ? null : ''Es necesario adjuntar el escrito presentado al juzgado''',
        /*TAP_SCRIPT_VALIDACION_JBPM...:*/ null,
        /*TAP_SCRIPT_DECISION..........:*/ '',
        /*DD_TPO_ID_BPM(FK)............:*/ null,
        /*TAP_SUPERVISOR,..............:*/ '0',
        /*TAP_DESCRIPCION,.............:*/ 'Presentar escrito al juzgado',
        /*VERSION......................:*/ '0',
        /*USUARIOCREAR.................:*/ 'DD',
        /*BORRADO......................:*/ '0',
        /*TAP_ALERT_NO_RETORNO.........:*/ null,
        /*TAP_ALERT_VUELTA_ATRAS.......:*/ 'tareaExterna.cancelarTarea',
        /*DD_FAP_ID(FK)................:*/ null,
        /*TAP_AUTOPRORROGA.............:*/ '1',
        /*DTYPE........................:*/ 'EXTTareaProcedimiento',
        /*TAP_MAX_AUTOP................:*/ '3',
        /*DD_TGE_ID(FK)................:*/ null,
        /*DD_STA_ID(FK)................:*/ '39',
        /*TAP_EVITAR_REORG.............:*/ null,
        /*DD_TSUP_ID(FK)...............:*/ 'GUCL',
        /*TAP_BUCLE_BPM................:*/ null        
        ) --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;


    /*
    * ARRAYS TABLA3: DD_PTP_PLAZOS_TAREAS_PLAZAS
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
       T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'H054_ValidaBienesTributacion',
          /*DD_PTP_PLAZO_SCRIPT......:*/ '5*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),  --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

       T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'H054_EmisionInformeFiscal',
          /*DD_PTP_PLAZO_SCRIPT......:*/ 'damePlazo(valoresBPMPadre[''H002_SenyalamientoSubasta''][''fechaSenyalamiento''])-10*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),  --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

       T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'H054_ConfirmarComEmpresario',
          /*DD_PTP_PLAZO_SCRIPT......:*/ '1*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        ),  --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

       T_TIPO_PLAZAS(
          /*DD_JUZ_ID(FK)............:*/ null,
          /*DD_PLA_ID(FK)............:*/ null,
          /*TAP_ID(FK)...............:*/ 'H054_PresentarEscritoJuzgado',
          /*DD_PTP_PLAZO_SCRIPT......:*/ '5*24*60*60*1000L',
          /*VERSION..................:*/ '0',
          /*BORRADO..................:*/ '0',
          /*USUARIOCREAR.............:*/ 'DD'
        )  --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;


    /*
    * ARRAYS TABLA4: TFI_TAREAS_FORM_ITEMS
    *---------------------------------------------------------------------
    */
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H054_ValidaBienesTributacion',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá validar la información sobre tributación para los bienes afectos a la subasta. Estos bienes los podrá identificar a través de la pestaña Subastas del asunto correspondiente. Deberá validar, si para aquellos bienes que pertenezcan a persona jurídica o en cualquier caso aquellos bienes de tipo Suelo, Promociones o Bajosse dispone en la "ficha del bien" la siguiente información/documentación junto con el informe fiscal:</p><p style="margin-bottom: 10px"><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Viviendas y sus anexos: indicar si el transmitente de los inmuebles fue el promotor de los mismos y si se dispone de la Licencia de Primera Ocupación o han sido arrendados sin opción de compra o han sido usados por su promotor por un periodo superior a los dos años.</li><li style="margin-bottom: 10px; margin-left: 35px;">Locales, naves u oficinas y plazas de garaje aisladas: indicar si el transmitente de los inmuebles fue promotor de los mismos o han sido arrendados sin opción de compra o han sido usados por su promotor.</li><li style="margin-bottom: 10px; margin-left: 35px;">Terrenos en curso de urbanización: información acerca de si el transmitente ha abonado cuotas de urbanización o no, así como confirmación de que han dado comienzo las obras de urbanización.</li></ul></p><p style="margin-bottom: 10px">En el campo Fecha indicará la fecha en la que completa la información requerida.</p><p style="margin-bottom: 10px">En el campo  Informe Fiscal SI/NO, debe indicar si existe el documento de  informe fiscal. En el caso que no exista el informe fiscal,  se lanzará la siguiente tarea " Emision Informe Fiscal" al Area fiscal y, en caso contrario, no se llevará a cabo ninguna acción y el tramite finaliza.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ), --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

        T_TIPO_TFI(
            /*DD_TAP_ID..............:*/ 'H054_ValidaBienesTributacion',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fecha',
            /*TFI_LABEL..............:*/ 'Fecha información requerida',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ), --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

        T_TIPO_TFI(
            /*DD_TAP_ID..............:*/ 'H054_ValidaBienesTributacion',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboInformeFiscal',
            /*TFI_LABEL..............:*/ 'Aporta doc. informe fiscal',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ '',
            /*TFI_BUSINESS_OPERATION.:*/ 'DDSiNo',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ), --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

        T_TIPO_TFI(
            /*DD_TAP_ID..............:*/ 'H054_ValidaBienesTributacion',
            /*TFI_ORDEN..............:*/ '3',
            /*TFI_TIPO...............:*/ 'textarea',
            /*TFI_NOMBRE.............:*/ 'observaciones',
            /*TFI_LABEL..............:*/ 'Observaciones',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),  --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H054_EmisionInformeFiscal',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada la tarea deberá adjuntar el informe fiscal de aplicación a los bienes incluidos en la subasta según lo solicitado y actualizar la ficha del bien de todos los bienes incluidos en la subasta, que han sido analizados para determinar el tipo de tributación de la operación.</p><p style="margin-bottom: 10px">En el campo Fecha, indicar la fecha en la que adjunta el informe fiscal y en el campo Resultado del informe, el resultado del tipo de tributación de la operación seleccionando uno de los valores posibles.</p><p style="margin-bottom: 10px">En el caso que el A.Fiscal determine que algun bien esté sujeto a IVA ( Deducible o no deducible), se lanzará la siguiente tarea "Confirmar comunicación empresario sujeto pasivo" a la parte demandada y en el caso que el IVA sea deducible además se lanzará la tarea " Presentar escrito al juzgado" por parte del letrado.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ), --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

        T_TIPO_TFI(
            /*DD_TAP_ID..............:*/ 'H054_EmisionInformeFiscal',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fecha',
            /*TFI_LABEL..............:*/ 'Fecha aportación Informe Fiscal',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ), --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

        T_TIPO_TFI(
            /*DD_TAP_ID..............:*/ 'H054_EmisionInformeFiscal',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'combo',
            /*TFI_NOMBRE.............:*/ 'comboResultadoInformeFiscal',
            /*TFI_LABEL..............:*/ 'Resultado informe fiscal',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ '',
            /*TFI_BUSINESS_OPERATION.:*/ 'DDTipoTributacion',
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ), --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

        T_TIPO_TFI(
            /*DD_TAP_ID..............:*/ 'H054_EmisionInformeFiscal',
            /*TFI_ORDEN..............:*/ '3',
            /*TFI_TIPO...............:*/ 'textarea',
            /*TFI_NOMBRE.............:*/ 'observaciones',
            /*TFI_LABEL..............:*/ 'Observaciones',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),  --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H054_ConfirmarComEmpresario',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada la tarea deberá adjuntar el informe fiscal de aplicación a los bienes incluidos en la subasta según lo solicitado y actualizar la ficha del bien de todos los bienes incluidos en la subasta, que han sido analizados para determinar el tipo de tributación de la operación.</p><p style="margin-bottom: 10px">En el campo Fecha, indicar la fecha en la que adjunta el informe fiscal y en el campo Resultado del informe, el resultado del tipo de tributación de la operación seleccionando uno de los valores posibles.</p><p style="margin-bottom: 10px">En el caso que el A.Fiscal determine que algun bien esté sujeto a IVA ( Deducible o no deducible), se lanzará la siguiente tarea "Confirmar comunicación empresario sujeto pasivo" a la parte demandada y en el caso que el IVA sea deducible además se lanzará la tarea " Presentar escrito al juzgado" por parte del letrado.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ), --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

        T_TIPO_TFI(
            /*DD_TAP_ID..............:*/ 'H054_ConfirmarComEmpresario',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fecha',
            /*TFI_LABEL..............:*/ 'Fecha comunicación',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ), --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

        T_TIPO_TFI(
            /*DD_TAP_ID..............:*/ 'H054_ConfirmarComEmpresario',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'textarea',
            /*TFI_NOMBRE.............:*/ 'observaciones',
            /*TFI_LABEL..............:*/ 'Observaciones',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ),  --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

        T_TIPO_TFI (
            /*DD_TAP_ID..............:*/ 'H054_PresentarEscritoJuzgado',
            /*TFI_ORDEN..............:*/ '0',
            /*TFI_TIPO...............:*/ 'label',
            /*TFI_NOMBRE.............:*/ 'titulo',
            /*TFI_LABEL..............:*/ '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea, debe informar de la fecha de presentación del escrito en el juzgado y adjuntar el escrito, donde comunique que Sareb es sujeto pasivo del IVA así como el acogimiento al regimen establecido en la D.A. 6º de la LIVA.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Un vez realizada la tarea, se finalizará el trámite.</p></div>',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ), --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

        T_TIPO_TFI(
            /*DD_TAP_ID..............:*/ 'H054_PresentarEscritoJuzgado',
            /*TFI_ORDEN..............:*/ '1',
            /*TFI_TIPO...............:*/ 'date',
            /*TFI_NOMBRE.............:*/ 'fecha',
            /*TFI_LABEL..............:*/ 'Fecha presentación escrito',
            /*TFI_ERROR_VALIDACION...:*/ 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
            /*TFI_VALIDACION.........:*/ 'valor != null && valor != '''' ? true : false',
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        ), --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

        T_TIPO_TFI(
            /*DD_TAP_ID..............:*/ 'H054_PresentarEscritoJuzgado',
            /*TFI_ORDEN..............:*/ '2',
            /*TFI_TIPO...............:*/ 'textarea',
            /*TFI_NOMBRE.............:*/ 'observaciones',
            /*TFI_LABEL..............:*/ 'Observaciones',
            /*TFI_ERROR_VALIDACION...:*/ null,
            /*TFI_VALIDACION.........:*/ null,
            /*TFI_VALOR_INICIAL......:*/ null,
            /*TFI_BUSINESS_OPERATION.:*/ null,
            /*VERSION................:*/ '0',
            /*USUARIOCREAR...........:*/ 'DD'
        )  --Cerrar con ")," si no es la ultima fila. Cerrar con ")" si es ultima fila

    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
BEGIN	

    /*
    *---------------------------------------------------------------------------------------------------------
    *                                COMIENZO - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */
    DBMS_OUTPUT.PUT_LINE('[INICIO-SCRIPT]------------------------------------------------------- ');
    DBMS_OUTPUT.PUT_LINE('    Generacion de datos BPM: '||PAR_TIT_TRAMITE);

    /*
    * LOOP ARRAY BLOCK-CODE: DD_TPO_TIPO_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TPROC;
    DBMS_OUTPUT.PUT('    [INSERT] '||PAR_ESQUEMA||'.' || PAR_TABLENAME_TPROC || '......');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        
        V_MSQL := 'INSERT INTO '|| PAR_ESQUEMA ||'.' || PAR_TABLENAME_TPROC || ' (' ||
                    'DD_TPO_ID,DD_TPO_CODIGO,DD_TPO_DESCRIPCION,DD_TPO_DESCRIPCION_LARGA,' ||
                    'DD_TPO_HTML,DD_TPO_XML_JBPM,VERSION,USUARIOCREAR,' ||
                    'FECHACREAR,BORRADO,DD_TAC_ID,DD_TPO_SALDO_MIN,'||
                    'DD_TPO_SALDO_MAX,FLAG_PRORROGA,DTYPE,FLAG_DERIVABLE,FLAG_UNICO_BIEN) ' ||
                    'SELECT ' ||
                    'S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(3)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TPO(4)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TPO(6)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(7)),'''','''''') || ''',
                         sysdate,' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(8)),'''','''''') || ''',' ||
                         '(SELECT DD_TAC_ID FROM '|| PAR_ESQUEMA ||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO=''' || TRIM(V_TMP_TIPO_TPO(9)) || '''),' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(10)) || ''',''' 
                         || TRIM(V_TMP_TIPO_TPO(11)) || ''',''' 
                         || TRIM(V_TMP_TIPO_TPO(12)) || ''',' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(13)) || ''',''' 
                         || TRIM(V_TMP_TIPO_TPO(14)) || ''',''' 
                         || TRIM(V_TMP_TIPO_TPO(15)) 
                    || ''' FROM DUAL'; 

            VAR_CURR_ROWARRAY := I;
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
            EXECUTE IMMEDIATE V_MSQL;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' filas-OK]');


    /*
    * LOOP ARRAY BLOCK-CODE: TAP_TAREA_PROCEDIMIENTO
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TARPR;    
    DBMS_OUTPUT.PUT('    [INSERT] '||PAR_ESQUEMA||'.' || PAR_TABLENAME_TARPR || '........');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);
        V_MSQL := 'INSERT INTO '|| PAR_ESQUEMA ||'.' || PAR_TABLENAME_TARPR || ' (' ||
                    'TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,DD_TPO_ID_BPM,' ||
                    'TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,' ||
                    'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) ' ||
                    'SELECT ' ||
                    'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
                    '(SELECT DD_TPO_ID FROM ' || PAR_ESQUEMA || '.' || PAR_TABLENAME_TPROC || ' WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' || 
                    '(SELECT DD_TPO_ID FROM ' || PAR_ESQUEMA || '.' || PAR_TABLENAME_TPROC || ' WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
                    'sysdate,''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''',' ||
                    '(SELECT DD_TGE_ID FROM ' || PAR_ESQUEMA || '.DD_TGE_TIPO_GESTION WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(19)) || '''),' || 
                    '(SELECT DD_STA_ID FROM ' || PAR_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') || ''',' ||
                    '(SELECT DD_TGE_ID FROM ' || PAR_ESQUEMA || '.DD_TGE_TIPO_GESTION WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(22)) || '''),' || 
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') 
                    || ''' FROM DUAL';

            VAR_CURR_ROWARRAY := I;
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
            EXECUTE IMMEDIATE V_MSQL;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' filas-OK]');



    /*
    * LOOP ARRAY BLOCK-CODE: DD_PTP_PLAZOS_TAREAS_PLAZAS
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TPLAZ;    
    DBMS_OUTPUT.PUT('    [INSERT] '||PAR_ESQUEMA||'.' || PAR_TABLENAME_TPLAZ || '....');
    FOR I IN V_TIPO_PLAZAS.FIRST .. V_TIPO_PLAZAS.LAST
      LOOP
        V_TMP_TIPO_PLAZAS := V_TIPO_PLAZAS(I);
        V_MSQL := 'INSERT INTO '|| PAR_ESQUEMA ||'.' || PAR_TABLENAME_TPLAZ || 
                    '(DD_PTP_ID,DD_JUZ_ID,DD_PLA_ID,TAP_ID,DD_PTP_PLAZO_SCRIPT,VERSION,BORRADO,USUARIOCREAR,FECHACREAR)' ||
                    'SELECT ' ||
                    'S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, ' ||
                    '(SELECT DD_JUZ_ID FROM ' || PAR_ESQUEMA || '.DD_JUZ_JUZGADOS_PLAZA WHERE DD_JUZ_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(1)) || '''), ' ||
                    '(SELECT DD_PLA_ID FROM ' || PAR_ESQUEMA || '.DD_PLA_PLAZAS WHERE DD_PLA_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(2)) || '''), ' ||
                    '(SELECT TAP_ID FROM ' || PAR_ESQUEMA || '.' || PAR_TABLENAME_TARPR || ' WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(3)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(5)),'''','''''') || ''','   ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(6)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || 
                    ''', sysdate FROM DUAL'; 

            VAR_CURR_ROWARRAY := I;
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PLAZAS(3) ||''','''||TRIM(V_TMP_TIPO_PLAZAS(4))||'''');
            EXECUTE IMMEDIATE V_MSQL;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' filas-OK]');



    /*
    * LOOP ARRAY BLOCK-CODE: TFI_TAREAS_FORM_ITEMS
    *---------------------------------------------------------------------
    */
    VAR_CURR_TABLE := PAR_TABLENAME_TFITE;    
    DBMS_OUTPUT.PUT('    [INSERT] '||PAR_ESQUEMA||'.' || PAR_TABLENAME_TFITE || '..........');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);
        V_MSQL := 'INSERT INTO '|| PAR_ESQUEMA ||'.' || PAR_TABLENAME_TFITE || 
                    '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                    'SELECT ' ||
                    'S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
                    '(SELECT TAP_ID FROM ' || PAR_ESQUEMA || '.' || PAR_TABLENAME_TARPR || ' WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_TFI(1)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(2)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(10)),'''','''''') || ''',''' 
                         || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || 
                    ''',sysdate,0 FROM DUAL';

            VAR_CURR_ROWARRAY := I;
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI(1) ||''','''||TRIM(V_TMP_TIPO_TFI(4))||'''');
            EXECUTE IMMEDIATE V_MSQL;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('['||VAR_CURR_ROWARRAY||' filas-OK]');


    /*
    * COMMIT ALL BLOCK-CODE
    *---------------------------------------------------------------------
    */
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[COMMIT ALL]...............................................');
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');
    /*
    *---------------------------------------------------------------------------------------------------------
    *                                FIN - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */

EXCEPTION

    /*
    *---------------------------------------------------------------------------------------------------------
    *                                   TRATAMIENTO DE EXCEPCIONES
    *---------------------------------------------------------------------------------------------------------
    */
    WHEN OTHERS THEN
        /*
        * EXCEPTION: WHATEVER ERROR
        *---------------------------------------------------------------------
        */     
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT('[KO]');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          IF (ERR_NUM = -1427 OR ERR_NUM = -1) THEN
            DBMS_OUTPUT.put_line('[INFO] Ya existen los registros de este script insertados en la tabla '||VAR_CURR_TABLE
                              ||'. Encontrada fila num '||VAR_CURR_ROWARRAY||' de su array.');
            DBMS_OUTPUT.put_line('[INFO] Ejecute el script de limpieza del tramite '||PAR_TIT_TRAMITE||' y vuelva a ejecutar.');
          END IF;
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line('SQL que ha fallado:');
          DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('[ROLLBACK ALL].............................................');
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line('Contacto incidencia.....: '||PAR_AUTHOR);
          DBMS_OUTPUT.put_line('Email...................: '||PAR_AUTHOR_EMAIL);
          DBMS_OUTPUT.put_line('Telf....................: '||PAR_AUTHOR_TELF);
          DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');                    
          RAISE;   
END;
/