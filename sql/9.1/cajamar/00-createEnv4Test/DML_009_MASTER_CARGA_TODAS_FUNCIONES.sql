--/*
--##########################################
--## AUTOR=Carlos Perez
--## FECHA_CREACION=20151223
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=-
--## INCIDENCIA_LINK=-
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= 'CM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'CMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en FUN_FUNCIONES
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      T_FUNCION('Listado de Clientes','MENU-LIST-CLI'),
T_FUNCION('Listado de Expedientes','MENU-LIST-EXP'),
T_FUNCION('Listado de Asuntos','MENU-LIST-ASU'),
T_FUNCION('Menú de administrador','ROLE_ADMIN'),
T_FUNCION('Menú Búsqueda','BUSQUEDA'),
T_FUNCION('Comité','ROLE_COMITE'),
T_FUNCION('Editar Títulos','EDITAR_TITULOS'),
T_FUNCION('Editar Procedimientos','EDITAR_PROCEDIMIENTO'),
T_FUNCION('Editar Gestión y Análisis','EDITAR_GYA'),
T_FUNCION('Cerrar Decisión','CERRAR_DECISION'),
T_FUNCION('Nuevo Contrato','NUEVO_CONTRATO'),
T_FUNCION('Borrar Contrato','BORRA_CONTRATO'),
T_FUNCION('Asignar Asunto','ASIGNAR_ASUNTO'),
T_FUNCION('Generar Tarea','COMUNICACION'),
T_FUNCION('Generar Notificacion','RESPONDER'),
T_FUNCION('ABM de Bienes y Ingresos, y modificación de observaciones solvencia','EDITAR_SOLVENCIA'),
T_FUNCION('ABM de antecedentes externos, modificación de observaciones antecedentes','EDITAR_ANTECEDENTES'),
T_FUNCION('ABM de titulos','NUEVO_TITULO'),
T_FUNCION('ABM de titulos','BORRA_TITULO'),
T_FUNCION('Solicitar Prórroga','SOLICITAR_PRORROGA'),
T_FUNCION('Solicitar Expediente Manual Recobro','SOLICITAR_EXP_MANUAL_RECOBRO'),
T_FUNCION('Menu de telecobro','MENU-TELECOBRO'),
T_FUNCION('Menu de analisis','MENU-ANALISIS'),
T_FUNCION('Excluir clientes expediente','EXCLUIR_CLIENTES'),
T_FUNCION('Edita el umbral de deuda por persona para pasar a Expediente','EDITAR_UMBRAL'),
T_FUNCION('Puede buscar Contratos','MENU-LIST-CNT'),
T_FUNCION('Editar Revisión en Gestión y Análisis','EDITAR_GYA_REV'),
T_FUNCION('Visualizar la solapa del umbral','VER_UMBRAL'),
T_FUNCION('Incluir-Excluir contratos en expediente','INCLUIR_EXCLUIR_CONTRATOS'),
T_FUNCION('Ver opciones de configuración de plazas y juzgados','ROLE_CONFPLAZASYJUZ'),
T_FUNCION('Añadir nuevos juzgados','ROLE_ADDJUZGADO'),
T_FUNCION('Editar los atributos de una plaza de juzgado','ROLE_EDITPLAZA'),
T_FUNCION('Editar los atributos de un juzgado','ROLE_EDITJUZGADO'),
T_FUNCION('Exportar comunicaciones del asunto','EXPORTAR_COMUNICACIONES'),
T_FUNCION('Exportar histórico del asunto','EXPORTAR_HISTORICO'),
T_FUNCION('Acceder a la búsqueda de procedimientos','ROLE_BUSCAPROC'),
T_FUNCION('Poder reanudar un procedimiento paralizado','ROLE_REANUDAR_PROC'),
T_FUNCION('Permiso para revisar y ver revisión de una tarea alertada','ROLE_REVISAR_ALERTA'),
T_FUNCION('Permiso para revisar y ver revisión de una tarea','ROLE_REVISAR_TAREA'),
T_FUNCION('Permiso para revisar y ver revisión de una notificacion','ROLE_REVISAR_NOTIFICACION'),
T_FUNCION('Permiso para revisar y ver revisión de una tarea en espera','ROLE_REVISAR_ESPERA'),
T_FUNCION('Solicitar Expediente Manual Seguimiento','SOLICITAR_EXP_MANUAL_SEGUIMIENTO'),
T_FUNCION('Menú Scoring y Alertas','MENU-SCORING-ALERTAS'),
T_FUNCION('Ver el scoring de un cliente','VER-SCORING-CLIENTE'),
T_FUNCION('Mostrar VR en Listado de Tareas','MOSTRAR_VR_TAREAS'),
T_FUNCION('Superusuario de políticas','POLITICA_SUPER'),
T_FUNCION('Usuario habilitado para ver políticas','VER-POLITICA'),
T_FUNCION('Ver análisis de políticas de un cliente','VER-ANALISIS'),
T_FUNCION('Cambiar el supervisor de un asunto','CAMBIAR-SUPERVISOR-ASUNTO'),
T_FUNCION('Cambiar el supervisor de un asunto temporalmente, y reasingarse el asunto','REASIGNAR-SUPERVISOR-TEMPORAL-ASUNTO'),
T_FUNCION('Superusuario para crear Expedientes manualmente','SUPERUSUARIO_CREACION_EXPEDIENTE'),
T_FUNCION('Verificar bienes de una persona','VERIFICAR_BIEN'),
T_FUNCION('Verificar la solvencia de una persona','VIGENCIA_SOLVENCIA'),
T_FUNCION('Cambiar los datos de acceso','CAMBIO-DATOS-ACCESO'),
T_FUNCION('Ver el menú de configuración','VER-CONFIGURACION'),
T_FUNCION('Ver opciones de configuración de modelos de arquetipos','ROLE_CONFMODELOS'),
T_FUNCION('Ver las observaciones al asunto','VER-OBSERVACIONES-ASUNTO'),
T_FUNCION('Generar informe de liquidaciones desde la ficha del asunto','GENERAR-LIQUIDACIONES'),
T_FUNCION('Generar burofax desde la ficha del cliente','GENERAR-BUROFAX'),
T_FUNCION('Ver opciones de configuración de arquetipos','ROLE_CONFARQ'),
T_FUNCION('Ver menu de configuración de arquetipos y modelos','ROLE_MENUARQ'),
T_FUNCION('Ver opciones de editar datos del asunto','ROLE_EDIT_CABECERA_ASUNTO'),
T_FUNCION('Permite editar datos del procedimiento','ROLE_EDIT_CABECERA_PROCEDIMIENTO'),
T_FUNCION('Botón para generar el informe de situación contencioso','BOTON_INF_AGREGADO_CONTRATO'),
T_FUNCION('Visión completa de los bienes','ESTRUCTURA_COMPLETA_BIENES'),
T_FUNCION('Permiso para marcar bienes automáticos','BOTON_MARCAR_BIENES_PARA_EXTERNOS'),
T_FUNCION('Permiso para ver la pestaña bienes en contratos','SECCION_BIENES_EN_CONTRATO'),
T_FUNCION('Exportar información de análisis global a PDF','EXPORTAR_ANALISIS_PDF'),
T_FUNCION('Ver Tab de Expedientes Asuntos en la consulta de contratos','TAB-CNT-EXP-ASU'),
T_FUNCION('Ver opciones de configuración de comités','ROLE_CONFCOMITE'),
T_FUNCION('Dar de alta nuevos comités','ROLE_ADDCOMITE'),
T_FUNCION('Editar las opciones de un  comité','ROLE_EDITCOMITE'),
T_FUNCION('Editar los itinerarios compatibles con el comité','ROLE_EDIT_COM_ITI'),
T_FUNCION('Borrar puestos de comité de un comité','ROLE_COMITE_BORRAPUESTO'),
T_FUNCION('Dar de alta nuevos puestos de comité de un comité','ROLE_COMITE_ALTAPUESTO'),
T_FUNCION('Editar un puesto de comité de un comité','ROLE_COMITE_EDITPUESTO'),
T_FUNCION('Eliminar un comité','ROLE_BORRACOMITE'),
T_FUNCION('Ver opciones de configuración de itinerarios','ROLE_CONFITI'),
T_FUNCION('Ver el buscador de tareas','BUSCAR-TAREAS'),
T_FUNCION('Visibilidad sobre tareas no propias','VISIBILIDAD-TAREAS-NOPROPIAS'),
T_FUNCION('Permite borrar adjuntos de otros usuarios','BORRAR_ADJ_OTROS_USU'),
T_FUNCION('Menú búsqueda bienes','BUSCAR-BIENES'),
T_FUNCION('Crear bienes','SOLVENCIA_NUEVO'),
T_FUNCION('Borrar bienes','SOLVENCIA_BORRAR'),
T_FUNCION('Modificar bienes','SOLVENCIA_EDITAR'),
T_FUNCION('Editar INGRESOS','INGRESOS_EDITAR'),
T_FUNCION('Acumulación de contratos','ROLE_INCLUIR_CONTRATO_PROCEDIMIENTO'),
T_FUNCION('Ver pesatña de aceptación del asunto','ACEPTAR-ASUNTO'),
T_FUNCION('Ver pestaña de acciones judiciales modelo SIDHI','INFOJUDICIAL_SIDHI'),
T_FUNCION('Ver pestaña de actuaciones no procesables sobre el iter','ACTUACIONES_ADICIONAL'),
T_FUNCION('Ver panel de control','PANEL-CONTROL-GESTION_PRIMARIA'),
T_FUNCION('Permiso para ver la pestaña de contratos en la información del cliente','TAB_CLIENTE_CONTRATOS'),
T_FUNCION('Permiso para ver la pestaña de cabecera en la información del cliente','TAB_CLIENTE_CABECERA'),
T_FUNCION('Permiso para ver la pestaña de datos en la información del cliente','TAB_CLIENTE_DATOS'),
T_FUNCION('Permiso para ver la pestaña de antecedentes en la información del cliente','TAB_CLIENTE_ANTECEDENTES'),
T_FUNCION('Permiso para ver la pestaña de grupo en la información del cliente','TAB_CLIENTE_GRUPO'),
T_FUNCION('Permiso para ver la pestaña de históricos en la información del cliente','TAB_CLIENTE_HISTORICOS'),
T_FUNCION('Perfil de proveedor de solvencia','ROLE_PROVEEDOR_SOLVENCIA_deshabilitado'),
T_FUNCION('Permiso para ver la pestaña de toma de decision','ROLE_TOMA_DECISION'),
T_FUNCION('VER PESTAÑA GESTORES','VER_TAB_GESTORES'),
T_FUNCION('EDITAR GESTORES','EDIT_GESTORES'),
T_FUNCION('Acdeder al plugin para las instrucciones de tareas de exteerna','ROLE_CONF_INSTRUCC_EXT'),
T_FUNCION('Cambiar las instrucciones de tareas de externa','ROLE_EDITINSTRUCCIONESEXT'),
T_FUNCION('OPTIMIZACION_BUZON_TAREAS','OPTIMIZACION_BUZON_TAREAS'),
T_FUNCION('Permiso para ver el grid de acciones extrajudiciales','VER_ACCIONES_EXTRAJUDICIALES'),
T_FUNCION('Dar alta nuevos concursos','ROLE_DAR_ALTA_NUEVO_CONCURSO'),
T_FUNCION('Reorganizar procedimientos','REORGANIZAR_PROCEDIMIENTO'),
T_FUNCION('Permiso para que los letrados internos puedan modificar el estado del litigio','CAMBIAR-ESTADO-ASUNTO'),
T_FUNCION('Crear anotaciones','CREAR_ANOTACIONES'),
T_FUNCION('Permiso especial para finalizar cualquier asunto.','FINALIZAR-ASUNTO'),
T_FUNCION('Permiso especial para poder asignar un gestor HP en un asunto','CAMBIAR-GESTORHP'),
T_FUNCION('Ver menú de procesado masivo de tareas','PROCESADO_TAREAS'),
T_FUNCION('Funcion de gesor BO Lindorff','ROLE_BO'),
T_FUNCION('Funcion de gesor LEGAL Lindorff','ROLE_LEGAL'),
T_FUNCION('Ver menú de procesado de resoluciones','PROCESADO_RESOLUCIONES'),
T_FUNCION('Panel de control letrados','PANEL-CONTROL-GESTION_JUDICIAL'),
T_FUNCION('Acceso extrajudicial','ROLE_EXTRAJUDICIAL_LINDORFF'),
T_FUNCION('Ocultar Gestión del Clientes del Panel de Tareas','ROLE_OCULTAR_ARBOL_GESTION_CLIENTES'),
T_FUNCION('Ocultar Objetivos Pendientes del Panel de Tareas','ROLE_OCULTAR_ARBOL_OBJETIVOS_PENDIENTES'),
T_FUNCION('Modificaciones panel de control para Lindorff','PANEL_LINDORFF'),
T_FUNCION('Ver opciones de configuración de carteras','ROLE_CONFCARTERAS'),
T_FUNCION('Ver opciones de configuración de carteras','ROLE_ADDCARTERA'),
T_FUNCION('Editar carteras','ROLE_EDITCARTERA'),
T_FUNCION('Permitir la prorroga masiva de tareas','ROLE_PRORROGA_MASIVA'),
T_FUNCION('Ocultar botones edición acuerdo','OCULTAR_BOTONES_ACUERDO'),
T_FUNCION('Funcion de supervisor LEGAL Lindorff','ROLE_SUP_LEGAL'),
T_FUNCION('Ver opciones de configuración de impulsos procesales','ROLE_CONFIMPULSOS'),
T_FUNCION('Muestra el botón desplegable de cambiar gestores del asunto','MUESTRA-MENU-GESTORES-ASUNTO'),
T_FUNCION('Ver cabecera de las opciones del menú masivo','MENU_MASIVO_GENERAL'),
T_FUNCION('Ver botón de procesar inputs pendientes','ROLE_BOTON_PROCESAR_INPUTS'),
T_FUNCION('Visualizar las observaciones del bien en listado de embargos del procedimiento','OBSERVACIONES_BIENES_PRC'),
T_FUNCION('Muestra el botón de instrucciones de subasta del bien en el PRC.','BOTON_INSTRUCCIONES_SUBASTA'),
T_FUNCION('Alta asuntos masivo','FUN_OM_ALTA_ASU'),
T_FUNCION('Confirmar recepción contrato original masivo','FUN_OM_RECEP_CNT_ORIG'),
T_FUNCION('Confirmar recepción testimonio masivo','FUN_OM_RECEP_TEST'),
T_FUNCION('Impresión documentación masivo','FUN_OM_IMP_DOC'),
T_FUNCION('Envío Juzgado masivo','FUN_OM_ENV_JUZ'),
T_FUNCION('Reorganización asuntos masivo','FUN_OM_REORG_ASU'),
T_FUNCION('Cancelación Asuntos masivo','FUN_OM_CANC_ASU'),
T_FUNCION('Autoprórroga masivo','FUN_OM_AUTOPORR'),
T_FUNCION('Solicitar testimonio masivo','FUN_OM_SOL_TES'),
T_FUNCION('Regenerar documentación masivo','FUN_OM_REG_DOC'),
T_FUNCION('Generar fichero tasas masivo','FUN_OM_GEN_FICH_TAS'),
T_FUNCION('Validar fichero tasas masivo','FUN_OM_VAL_FICH_TAS'),
T_FUNCION('Solicitar pago tasas masivo','FUN_OM_SOL_PAG_TAS'),
T_FUNCION('Confirmar recepción justificante tasas masivo','FUN_OM_RECEP_DOC_IMP'),
T_FUNCION('Confirmar recepción documentación impresa masivo','FUN_OM_CONF_RECEP_DOC'),
T_FUNCION('Alta Lotes masivo','FUN_OM_ALTA_LOT'),
T_FUNCION('Paralización Asuntos masivo','FUN_OM_PARAL_ASU'),
T_FUNCION('Alta lote ETJ masivo','FUN_OM_ALTA_LOT_ETJ'),
T_FUNCION('Impulso procesal masivo','FUN_OM_IMPULSO'),
T_FUNCION('Alta Cartera Judicializada masivo','FUN_OM_ALT_CART_JUD'),
T_FUNCION('Redacción demandas masivo','FUN_OM_REDACC_DEM'),
T_FUNCION('Presentación demanda masivo','FUN_OM_PRES_DEM'),
T_FUNCION('Admisión demanda masivo','FUN_OM_ADM_DEM'),
T_FUNCION('Envío masivo a impresión masivo','FUN_OM_ENV_MAS_IMP'),
T_FUNCION('ABM telefonos del cliente','ABM_TELEFONOS_CLIENTE'),
T_FUNCION('Pestaña de ciclo de recobro expediente','TAB_CICLORECOBRO_EXPEDIENTE'),
T_FUNCION('Pestaña de ciclo de recobro persona expediente','TAB_CICLORECOBRO_PERS_EXPEDIENTE'),
T_FUNCION('Ver menu configuracion de Agencias','ROLE_VER_AGENCIAS'),
T_FUNCION('Modificación de Agencias','ROLE_CONF_AGENCIAS'),
T_FUNCION('Permite ver el menú de carteras','ROLE_VER_CARTERAS'),
T_FUNCION('Permite la configuración de carteras','ROLE_CONF_CARTERAS'),
T_FUNCION('Permite grabar/Modificar las carteras del esquema','ROLE_CONF_CARTERASESQUEMA'),
T_FUNCION('Permite grabar/Modificar las subcarteras del esquema','ROLE_CONF_REPARTOSUBCARTERAS'),
T_FUNCION('Permiso para poder ver cobros/pagos de un expediente','TAB_COBROS_PAGOS_EXP'),
T_FUNCION('Permiso para poder buscar incidencias expediente','BUSCAR-INCIDENCIAS-EXPEDIENTE'),
T_FUNCION('Permiso para poder buscar incidencias expediente','ALTA-INCIDENCIAS-EXPEDIENTE'),
T_FUNCION('Permiso para poder buscar incidencias expediente','BORRAR-INCIDENCIAS-EXPEDIENTE'),
T_FUNCION('Permiso que restringe la visibilidad','ES_PROVEEDOR'),
T_FUNCION('Permite ver el menú de esquemas de agencias','ROLE_VER_ESQUEMA'),
T_FUNCION('Permite la configuración de esquemas de agencias','ROLE_CONF_ESQUEMA'),
T_FUNCION('Permite ver el menú de metas volantes','ROLE_VER_METAS'),
T_FUNCION('Permite la configuración de metas volantes','ROLE_CONF_METAS'),
T_FUNCION('Permite ver el menú de Modelos de Ranking','ROLE_VER_RANKING'),
T_FUNCION('Permite la configuración de Modelos de Ranking','ROLE_CONF_RANKING'),
T_FUNCION('Permite ver el menú de modelos de facturación','ROLE_VER_FACTURACION'),
T_FUNCION('Permite la configuración de modelos de facturación','ROLE_CONF_FACTURACION'),
T_FUNCION('Permite ver el menú de procesos de facturación','ROLE_VER_PROC_FACTURACION'),
T_FUNCION('Permite la configuración de procesos de facturación','ROLE_CONF_PROC_FACTURACION'),
T_FUNCION('Permite editar modelos de políticas','ROLE_CONF_POLITICA'),
T_FUNCION('Permite ver el menú de políticas de acuerdo','ROLE_VER_POLITICAS'),
T_FUNCION('Pestaña de recibos/disposiciones/efectos del Contrato','TAB_CONTRATO_RECIBOS'),
T_FUNCION('Visualiza el menú padre de busquedas','MENU_BUSQUEDAS_GENERAL'),
T_FUNCION('Visualiza el menú padre de configuración de agencias','MENU_RECOBROCONFIG_GENERAL'),
T_FUNCION('Pestaña de ciclo de recobro contrato expediente','TAB_CICLORECOBRO_CNT_EXPEDIENTE'),
T_FUNCION('Pestaña de ciclo de recobro persona','TAB_CICLORECOBRO_PERSONA'),
T_FUNCION('Pestaña de ciclo de recobro contrato','TAB_CICLORECOBRO_CONTRATO'),
T_FUNCION('Permiso para poder ver acciones de un expediente','TAB_ACCIONES_EXP'),
T_FUNCION('Muestra el menú de busqueda de expedientes aunque el usuario sea externo','MENU-LIST-EXP-ALL-USERS'),
T_FUNCION('Permiso para poder exceptuar personas','CREAR_EXCEPCIONES_CLIENTE'),
T_FUNCION('Permiso para poder exceptuar contratos','CREAR_EXCEPCIONES_CONTRATO'),
T_FUNCION('Permiso para poder ver cobros/pagos de un expediente','VER_TAB_GESTORES_EXPEDIENTE'),
T_FUNCION('Permiso para ver la pestaña de Cirbe en la información del cliente','TAB_CLIENTE_CIRBE'),
T_FUNCION('Permite ver todos las expedientes de recobro a un externo','ROLE_VISIB_COMPLETA_RECOBRO_EXT'),
T_FUNCION('Permite ver todos las acciones de recobro a un externo','TODAS_LAS_ACCIONES_SIN_AGENCIA'),
T_FUNCION('Pestaña de ciclo de recobro expediente','TAB_ACUERDO_EXPEDIENTE'),
T_FUNCION('Ver todas las incidencias del expediente','TODAS_LAS_INCIDENCIAS_SIN_AGENCIA'),
T_FUNCION('Ver pestaña documentos del contrato','TAB_CONTRATO_DOCUMENTOS'),
T_FUNCION('Pestaña de inicio búsqueda de expedientes','INITIAL_TAB_BUS_EXP'),
T_FUNCION('Acceso a RECOVERY-BI','ROLE_RECOVERY_BI'),
T_FUNCION('Permite cambiar el estado de una incidencia.','CAMBIAR-ESTADO-INCIDENCIA'),
T_FUNCION('Habilitar la exportación a PDF del Expediente.','EXPORTAR_PDF_EXPEDIENTE'),
T_FUNCION('Ver pestaña adjuntos del expediente','TAB_EXPEDIENTE_ADJUNTOS'),
T_FUNCION('Menú alta direcciones Asunto','MENU-DIRECCION-ASUNTO'),
T_FUNCION('Permite ver la notificacion de demandados antigua','TAB-NOTIFICACION-DEMANDADOS-MSV'),
T_FUNCION('Permite ver la notificacion de demandados v4','TAB-NOTIFICACION-DEMANDADOS-v4'),
T_FUNCION('PERMITE VER LA PESTAÑA DE EMBARGOS DE UN BIEN','VER_EMBARGOS_DEL_BIEN'),
T_FUNCION('Menú Búsqueda de Subastas','BUSCAR-SUBASTAS'),
T_FUNCION('Oculta el campo tipo acuerdo en el alta de acuerdos del asunto','OCULTA_TIPO_ACUERDO'),
T_FUNCION('Edición de la pestaña adjudicación de la ficha del bien','BIEN_ADJUDICACION_EDITAR'),
T_FUNCION('Configurador de plazos','ROLE_CONFPLAZOSEXT'),
T_FUNCION('Añadir nuevos plazos de tareas externas','ROLE_ADDPLAZOSEXT'),
T_FUNCION('Eliminar un plazo de una tarea externa','ROLE_BORRAPLAZOSEXT'),
T_FUNCION('Editar un plazo de una tarea externa','ROLE_EDITPLAZOSEXT'),
T_FUNCION('Permite ver tab documentos','ROLE_VER_TAB_DOCUMENTOS'),
T_FUNCION('Únicamente permite agregar gestores del asunto entre usuaios de su mismo despacho.','ASU_GESTOR_SOLOPROPIAS'),
T_FUNCION('Únicamente permite agregar usuarios de gestorias.','ASU_GESTOR_SOLOPROPIAS_ADIC'),
T_FUNCION('Acceso manual a servicios UVEM','ACC_MAN_SERVICIOS_UVEM'),
T_FUNCION('Permite ver nada inicialmente','INITIAL_TAB_NOTHING'),
T_FUNCION('Muestra pestaña adjudicados del asunto','TAB_ADJUDICADOS'),
T_FUNCION('Muestra pestaña analisis contratos del asunto','TAB_ANALISISCONTRATOS'),
T_FUNCION('Únicamente permite agregar procuradores del asunto entre usuarios de su mismo despacho.','ASU_PROCURADOR_SOLOPROPIAS_ADIC'),
T_FUNCION('Ocultar campos del contrato','OCULTAR_DATOS_CONTRATO'),
T_FUNCION('Activar envio de email desde anotaciones del Asunto','ACTIVAR_EMAIL_ANOTACIONES'),
T_FUNCION('Mostrar campo Documento Adjudicación','VER_DOC_ADJUDICACION'),
T_FUNCION('Puede ver campos de garantia de bien','PERSONALIZACION-HY'),
T_FUNCION('Insinuación de creditos como supervisor','FUNCION_SUPERVISOR'),
T_FUNCION('Permite ver la pestaña cobros pagos','ROLE_TAB_COBROS_PAGOS'),
T_FUNCION('Cierre de acuerdos extrajudiciales desde aplicativo externo','CIERRE_ACUERDO_LIT_DESDE_APP_EXTERNA'),
T_FUNCION('Puede ver campos de tributación','PUEDE_VER_TRIBUTACION'),
T_FUNCION('Puede ver el campo provisión en cabecera del asunto','PUEDE_VER_PROVISIONES'),
T_FUNCION('Puede ver campos del envio a cierre de deuda','ENVIO_CIERRE_DEUDA'),
T_FUNCION('Ver la etiqueta información adicional en la cabecera de expedientes de recobro.','PUEDE_VER_INFO_ADICIONAL_EXP'),
T_FUNCION('Pestaña de titulos de expediente','TAB_TITULOS_EXPEDIENTE'),
T_FUNCION('Función que permite proponer acuerdos','PROPONER-ACUERDO'),
T_FUNCION('Función que permite validar acuerdos','VALIDAR-ACUERDO'),
T_FUNCION('Función que permite validar acuerdos','DECIDIR-ACUERDO'),
T_FUNCION('Muestra el menú del comité (Celebración comité, Actas comité)','ROLE_COMITE_MENU'),
T_FUNCION('Muestra el menú del comité (Gestión masiva inst. subasta)','MSV-INST-SUBASTA'),
T_FUNCION('Permisos de visualización para perfiles Cajamar','PERSONALIZACION-BCC'),
T_FUNCION('Puede ver el tab precontencioso','TAB_PRECONTENCIOSO'),
T_FUNCION('Puede ver las acciones precontencioso','ACCIONES_PRECONTENCIOSO'),
T_FUNCION('Puede ver la busqueda precontencioso','BUSQUEDA_PRECONTENCIOSO'),
T_FUNCION('Puede ver el grid de documentos del tab de precontencioso','TAB_PRECONTENCIOSO_DOCUMENTOS'),
T_FUNCION('Puede ver el grid de liquidaciones del tab de precontencioso','TAB_PRECONTENCIOSO_LIQUIDACIONES'),
T_FUNCION('Puede ver el grid de burofaxes del tab de precontencioso','TAB_PRECONTENCIOSO_BUROFAXES'),
T_FUNCION('Exportar ficha litigio del asunto','EXPORTAR_FICHAGLOBAL'),
T_FUNCION('Muestra la entrada de menu Proyectado Preproyectado','MENU-LIST-PROPRE'),
T_FUNCION('Desactiva la dependencia entre despachos y usuarios externos','ROLE_DESACTIVAR_DEPENDENCIA_USU_EXTERNO'),
T_FUNCION('Permite la edición de esquemas de turnado de letrados','ROLE_ESQUEMA_TURNADO_EDITAR'),
T_FUNCION('Permite la activación de esquemas de turnado de letrados','ROLE_ESQUEMA_TURNADO_ACTIVAR'),
T_FUNCION('Muestra el menú de busqueda de expedientes de recobro aunque el usuario sea externo','MENU-LIST-EXP-RECOBRO-ALL-USERS'),
T_FUNCION('Función solo consulta','SOLO_CONSULTA'),
T_FUNCION('Puede ver los botones del grid de documentos','TAB_PRECONTENCIOSO_DOC_BTN'),
T_FUNCION('Puede ver los botones del grid de liquidaciones','TAB_PRECONTENCIOSO_LIQ_BTN'),
T_FUNCION('Puede ver los botones del grid de burofaxes','TAB_PRECONTENCIOSO_BUR_BTN'),
T_FUNCION('Muestra el boton del documento de cancelacion de cargas','MUESTRA_DOC_CANC_CARGAS'),
T_FUNCION('Botón finalizar asunto','BTN_FINALIZAR_ASUNTO'),
T_FUNCION('Solicitar Expediente Manual Recuperaciones','SOLICITAR_EXP_MANUAL_RECUPERACIONES'),
T_FUNCION('Mostrar tareas masivas en el asunto','MENU_ACC_MULTIPLES_SUBASTA'),
T_FUNCION('Visibilidad pestaña OTROS de la ficha contrato','TAB_CONTRATO_OTROS'),
T_FUNCION('Modificar Riesgo Operacional pestaña OTROS de la ficha contrato','MODIFICAR_RIESGO_OPERACIONAL'),
T_FUNCION('Permite cambiar el procurador de asuntos con provisión','ROLE_PUEDE_CAMBIAR_PROCURADORES_CON_PROVISION'),
T_FUNCION('Permite ver la pestaña Clientes de expediente','ROLE_PUEDE_VER_TAB_EXP_CLIENTES'),
T_FUNCION('Permite ver la pestaña Titulo de expediente','ROLE_PUEDE_VER_TAB_EXP_TITULOS'),
T_FUNCION('Permite ver la pestaña Gestión de expediente','ROLE_PUEDE_VER_TAB_EXP_GESTION'),
T_FUNCION('Permite ver la pestaña Cumplimiento de expediente','ROLE_PUEDE_VER_TAB_EXP_CUMPLIMIENTO'),
T_FUNCION('Permite ver la pestaña Contratos de expediente','ROLE_PUEDE_VER_TAB_EXP_CONTRATOS')
    ); 
    V_TMP_FUNCION T_FUNCION;

BEGIN	
    -- LOOP Insertando valores en FUN_FUNCIONES
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.FUN_FUNCIONES... Empezando a insertar datos en el diccionario');
    
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_FUN_FUNCIONES.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(2))||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN				
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.FUN_FUNCIONES... Ya existe la funcion '''|| TRIM(V_TMP_FUNCION(2))||'''');
			ELSE		
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.FUN_FUNCIONES (' ||
						'FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
						'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||''','||
						'0, ''DML'',SYSDATE,0 FROM DUAL';
				DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||'''');
				EXECUTE IMMEDIATE V_MSQL;
			END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.FUN_FUNCIONES... Datos del diccionario insertado');

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
  	