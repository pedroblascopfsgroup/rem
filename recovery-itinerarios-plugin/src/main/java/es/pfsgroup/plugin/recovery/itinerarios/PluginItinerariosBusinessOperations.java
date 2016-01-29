package es.pfsgroup.plugin.recovery.itinerarios;

public class PluginItinerariosBusinessOperations {
	
	/**
	 * 
	 * @return devuelve la lista de todos los valores de la tabla
	 * DD_TIT_TIPO_ITINERARIO
	 */
	public static final String DDTIT_MGR_LISTA = "plugin.itinerarios.ddTipoItinerario.listaTipoItinerario";

	
	/**
	 * 
	 * @return devuelve la lista de todos los valores de la tabla
	 * DD_AEX_AMBITO_EXPEDIENTE
	 */
	public static final String AEX_MGR_LISTA = "plugin.itinerarios.ddAmbitoExpediente.listaAmbitoExpediente";

	public static final String AEX_MGR_LISTASEG="plugin.itinerarios.ddAmbitoExpediente.listaAmbitoExpedienteSeguimiento";
	
	public static final String AEX_MGR_LISTAREC="plugin.itinerarios.ddAmbitoExpediente.listaAmbitoExpedienteRecuperaciones";
	
	public static final String AEX_MGR_LISTA_BY_REGLA = "plugin.itinerarios.ddAmbitoExpediente.listaAmbitoExpedienteByRegla";
	
	/**
	 * @param id del tipo de itinerario
	 * @return devuelve una lista de ambitos de Expediente dependiendo del tipo de itinerario
	 */
	public static final String AEX_MGR_LISTASEGUNTIPOITI="plugin.itinerarios.ambitoExpediente.buscaPorTipoItinerario";
	/**
	 * @param dto de b�squeda de itinerarios
	 * @return devuelve una lista paginada de itinerarios que cumplen los criterios
	 * de b�squeda
	 */
	public static final String ITI_MGR_BUSCA = "plugin.itinerarios.itinerario.findItinerario";
	
	/**
	 * @param dto de alta de itinerarios
	 * Crea un nuevo itinerario o guarda las modificaciones de uno ya existente
	 * 
	 */
	public static final String ITI_MGR_GUARDA = "plugin.itinerarios.itinerario.save";
	
	/**
	 * @param id del itinerario que se desea eliminar
	 * elimana el itinerario cuyo id coincide con el que se le pasa como par�metro
	 * 
	 */
	public static final String ITI_MGR_BORRA ="plugin.itinerarios.itinerario.remove";
	
	/**
	 * @param id
	 * Devuelve el objeto de tipo Itinerario cuyo id coincide con el que se le pasa como par�metro
	 */
	public static final String ITI_MGR_GET = "plugin.itinerarios.itinerario.getItinerario";
	
	/**
	 * @param id
	 * Crea una copia del itinerario cuyo id coincide con el que se le pasa como par�metro
	 * Crear� una copia tanto de sus datos como de lo sus estados
	 */
	public static final String ITI_MGR_COPIA ="plugin.itinerarios.itinerario.copiaItinerario";
	
	/**
	 * @param id del itinerario
	 * Devuelve el objeto telecobro que tiene asociado un estado de ese itinerario
	 */
	public static final String EST_MGR_GETTELECOBRO ="plugin.itinerarios.estados.getTelecobroItinerario";
	
	public static final String EST_MGR_GETDTOESTADOSITI="plugin.itinerarios.estados.listaDtoEstadosItinerario";
	
	/**
	 * @param id del itinerario
	 * Devuelve true si ese itinerario se gestiona por telecobro
	 */
	public static final String EST_MGR_GETTELECOBROACTIVO="plugin.itinerarios.estados.getTelecobroItinerarioSiNo";
	
	
	public static final String EST_MGR_ESTADOCEITI = "plugin.itinerarios.estados.getEstadoCompletarExpediente";
	
	public static final String EST_MGR_ESTADOREITI = "plugin.itinerarios.estados.getEstadoRevisarExpediente";
	
	
	/**
	 * @param id del itinerario
	 * Devuelve true si ese itinerario admite decisi�n de comit� autom�tica
	 */
	public static final String EST_MGR_DCASINO = "plugin.itinerarios.estados.getDCASiNo";
	
	/**
	 * @param id del itinerario
	 * Devuelve true si el estado RE del itinerario es autom�tico
	 */
	public static final String EST_MGR_REAUTO ="plugin.itinerarios.estados.getAutoRESiNo";
	
	
	/**
	 * @param id del itinerario
	 * Devuelve true si el estado CE del itinerario es autom�tico
	 */
	public static final String EST_MGR_CEAUTO="plugin.itinerarios.estados.getAutoCESiNo";
	
	/**
	 * @param id del itinerario y c�digo del tipo de estado que se quiere consultar
	 * Devuelve true o false si el estado que coincide con el c�digo de ese itinerario 
	 * es autom�tico
	 */
	public static final String EST_MGR_AUTOSINO="plugin.itinerarios.estados.getAutoSiNo";
	
	
	/**
	 * @param id del itinerario
	 * Devuelve la Decisi�n de comit� autom�tica que tiene asociada ese itinerario
	 */
	public static final String EST_MGR_GETDCAITINERARIO="plugin.itinerarios.estados.getDCA";
	
	/**
	 * @param id del estado, autom�tico, dtoAltaDCA
	 * da de alta una decisi�n de comit� autom�tica en un estado
	 * Si autom�tico es cierto la guarda, si es falso no hace nada
	 */
	public static final String EST_MGR_GUARDADCA ="plugin.itinerarios.estados.saveDCA";
	
	/**
	 * @param id del itinerario a consultar
	 * @return devuelve la lista de todos los estados del itinerario
	 */
	public static final String EST_MGR_GETESTADOSITI = "plugin.itinerarios.estados.listaEstadosItinerario";
	
	/**
	 * @param formulario con los cambios efectuados en el grid
	 * Guarda los cambios que se han ido efectuando en un grid editable 
	 */
	public static final String EST_MGR_UPDATELIST="plugin.itinerarios.estados.updateList";
	
	/**
	 * @param id del estado que queremos consultar
	 */
	public static final String EST_MGR_GETESTADO="plugin.itinerarios.estados.get";
	
	/**
	 * @param id del itinerarios y string con el c�digo del tipo del estado
	 * Devuelve el estado de tipo XX del itinerario que se le pasa como entrada
	 */
	public static final String EST_MGR_DAMEESTADOPORTIPO ="plugin.itinerarios.estados.dameEstadoPorTipo";
	/**
	 * @param id del itinerario
	 * devuelve el estado del itinerario de tipo Gesti�n de Vencidos
	 */
	public static final String EST_MGR_ESTADOGVITI="plugin.itinerarios.estados.getEstadoGV";
	
	/**
	 * @param id del itinerario
	 * devuelve el estado del itinerario de tipo Decisi�n de Comit�
	 */
	public static final String EST_MGR_ESTADODCITI="plugin.itinerarios.estados.getEstadoDC";
	
	/**
	 * @param id del itinerario
	 * devuelve el estado del itinerario de tipo FormalizarPropuesta
	 */
	public static final String EST_MGR_ESTADOFPITI="plugin.itinerarios.estados.getEstadoFP";
	
	/**
	 * @param id del itinerario
	 * devuelve la regla de consenso del estado ce de ese itinerario
	 */
	public static final String EST_MGR_GETREGLASCONSENSOCE="plugin.itinerarios.estado.getReglasConsensoCE";
	
	/**
	 * @param id del itinerario
	 * devuelve la regla de consenso del estado re de ese itinerario
	 */
	public static final String EST_MGR_GETREGLASCONSENSORE="plugin.itinerarios.estado.getReglasConsensoRE";
	
	/**
	 * @param id del itinerario
	 * devuelve la regla de exclusi�n del estado ce de ese itinerario
	 */
	public static final String EST_MGR_GETREGLASEXCLUSIONCE="plugin.itinerarios.estado.getReglasExclusionCE";
	
	/**
	 * @param id del itinerario
	 * devuelve la regla de exclusi�n del estado re de ese itinerario
	 */
	public static final String EST_MGR_GETREGLASEXCLUSIONRE="plugin.itinerarios.estado.getReglasExclusionRE";
	
	public static final String EST_MGR_SETAUTOMATICO="plugin.itinerarios.estado.setAutomatico";
	
	/**
	 * @return Devuelve una lista con todos los perfiles dados de alta en la base de datos
	 */
	public static final String PEF_MGR_GETPERFILES = "plugin.itinerarios.perfil.getPerfiles";
	
	public static final String DSN_MGR_LISTA ="plugin.itinerarios.ddSiNo.lista";
	
	
	
	/**
	 * @param id del itinerario
	 * @return Devuelve una lista de objetos ReglasVigenciaPolitica
	 */
	public static final String RVP_MGR_GETREGLAS ="plugin.itinerarios.reglasVigenciaPolitica.listaReglasVigencia";

	/**
	 * @return devuelve un listado de todos los proveedores de telecobro dados de alta en la base de datos
	 */
	public static final String PTL_MGR_LISTAPROVEEDORES ="plugin.itinerarios.proveedorTelecobro.listaProveedores";

	/**
	 * @param dto de alta de telecobro
	 * Guarda configuraci�n de un telecobro con los datos que se le pasan en el dto
	 */
	public static final String TLC_MGR_GUARDA ="plugin.itinerarios.estadoTelecobro.save";
	
	public static final String TLC_MGR_GET ="plugin.itinerarios.estadoTelecobro.getTelecobro";
	
	/**
	 * @param dto de alta de decision de comite automatico
	 * Guarda configuraci�n de una DecisionComiteAutomatico con los datos
	 * que se le pasan en el dto
	 */
	public static final String DCA_MGR_NUEVODCA ="plugin.itinerarios.decisionComiteAutomatica.save";
	

	
	/**
	 * devuelve una lista de objetos gestor despacho con todos los que son gestores, es decir que son
	 * usuarios externos
	 */
	public static final String GDP_MGR_GETGESTORES = "plugin.itinerarios.gestorDespacho.listaGestores";
	
	/**
	 * devuelve una lista de objetos gestor despacho con todos los que son gestores, es decir que son
	 * usuarios no externos
	 */
	public static final String GDP_MGR_GETSUPERVISORES="plugin.itinerarios.gestorDespacho.listaSupervisores";
	
	/**
	 * devuelve una lista con todos los comites dados de alta en la base de datos
	 */
	public static final String COM_MGR_GETCOMITES ="plugin.itinerarios.comite.listaComites";
	
	/**
	 * Devuelve una lista de todos los posibles tipos de actuaci�n
	 */
	public static final String TPA_MGR_GETTIPOSACTUACION ="plugin.itinerarios.tipoActuacion.listaTiposActuacion";
	
	/**
	 * Lista todos los posibles tipos de procedimiento 
	 */
	public static final String TPC_MGR_GETTIPOSPROCEDIMIENTO ="plugin.itinerarios.tipoProcedimiento.listaTiposProcedimiento";
	
	
	public static final String TRC_MGR_GETTIPOSRECLAMACION ="plugin.itinerarios.ddTipoReclamacion.listaTiposReclamacion";

	/**
	 * @param id del itinerario 
	 * @return una lista de objetos tipoReglasElevaci�n del estado Completar Expediente de ese itinerario
	 */
	public static final String TRE_MGR_REGLASELEVACIONITINERARIO_CE="plugin.itinerarios.reglasElevacion.listaReglasElevacionCE";

	/**
	 * @param id del itinerario 
	 * @return una lista de objetos tipoReglasElevaci�n del estado Revisar Expediente de ese itinerario
	 */
	public static final String TRE_MGR_REGLASELVACION_RE="plugin.itinerarios.reglasElevacion.listaReglasElevacionRE";
	
	public static final String TRE_MGR_REGLASELEVACION_DC="plugin.itinerarios.reglasElevacion.listaReglasElevacionDC";

	public static final String TRE_MGR_REGLASELEVACION_FP="plugin.itinerarios.reglasElevacion.listaReglasElevacionFP";
	
	/**
	 * @param id del itinerario
	 * @return devuelve una lista de todos los objetos de tipo ddTipoReglasElevaci�n que no est�n asociadas
	 * al estado CE de ese itinerario
	 */
	public static final String TRE_MGR_RESTOREGLAS_CE="plugin.itinerarios.reglasElevacion.getRestoReglasCE";
	
	public static final String TRE_MGR_RESTOREGLAS_FP="plugin.itinerarios.reglasElevacion.getRestoReglasFP";
	
	/**
	 * @param id del itinerario
	 * @return devuelve una lista de todos los objetos de tipo ddTipoReglasElevaci�n que no est�n asociadas
	 * al estado RE de ese itinerario
	 */
	public static final String TRE_MGR_RESTOREGLAS_RE="plugin.itinerarios.reglasElevacion.getRestoReglasRE";
	
	
	public static final String TRE_MGR_RESTOREGLAS_DC="plugin.itinerarios.reglasElevacion.getRestoReglasDC";
	
	/**
	 * @param dto de alta de reglas de elevacion
	 * 
	 */
	public static final String TRE_MGR_SAVE="plugin.itinerarios.reglasElevacion.save";
	
	public static final String TRE_MGR_REMOVE="plugin.itinerarios.reglasElevacion.remove";
	
	/**
	 * @param id del itinerario
	 * @return lista de comites compatibles con ese itinerario
	 */
	public static final String COM_MGR_LISTACOMITI ="plugin.itinerarios.comite.listaComitesItinerario";

	/**
	 * @param id del estado
	 * @return regla del estado de tipo consenso
	 * 
	 */
	public static final String RVP_MGR_GETREGLASCONSENSOESTADO="plugin.itinerarios.reglaVigenciaPolitica.getReglasConsensoEstado";


	/**
	 * @param id del estado
	 * @return regla del estado de tipo exclusion
	 */
	public static final String RVP_MGR_GETREGLASEXCLUSIONESTADO = "plugin.itinerarios.reglaVigenciaPolitica.getReglasExclusionEstado";

	/**
	 * @return devuelve una lista de objetos ddTipoReglaVigencia Pol�ca
	 * que son de tipo consenso
	 */
	public static final String RVP_MGR_GETDDREGLASCONSENSO="plugin.itinerarios.reglaVigenciaPolitica.getReglasConsenso";
	
	public static final String RVP_MGR_GETDDREGLASCONSENSOCE="plugin.itinerarios.reglaVigenciaPolitica.getReglasConsensoCE";
	
	public static final String RVP_MGR_GETDDREGLASEXCLUSIONCE="plugin.itinerarios.reglaVigenciaPolitica.getReglasExclusionCE";
	
	public static final String RVP_MGR_GETDDREGLASEXCLUSIONRE="plugin.itinerarios.reglaVigenciaPolitica.getReglasExclusionRE";

	/**
	 * @param dto de alta de regla de Vigencia pol�tica
	 * 
	 */
	public static final String RVP_MGR_SAVE="plugin.itinerarios.reglasVigenciaPolitica.save";
	
	public static final String ITI_MGR_PUNTO_ENGANCHE_BUTTONS_LEFT="plugin.itinerarios.web.buttons.left";
	
	public static final String ITI_MGR_PUNTO_ENGANCHE_BUTTONS_RIGHT="plugin.itinerarios.web.buttons.right";

}

