package es.pfsgroup.recovery.ext.api.asunto;

import java.util.Date;
import java.util.List;
import java.util.Set;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto.MEJFinalizarAsuntoDto;
import es.pfsgroup.recovery.ext.impl.asunto.dto.EXTDtoBusquedaAsunto;

public interface EXTAsuntoApi  {

	public static final String EXT_MGR_ASUNTO_GET_GESTORES = "es.pfsgroup.recovery.ext.api.asunto.getGestoresAsuto";
	public static final String EXT_MGR_ASUNTO_GET_GESTORES_ADICIONALES_ASUNTO = "es.pfsgroup.recovery.ext.api.asunto.getGestoresAdicionalesAsunto";
	public static final String EXT_MGR_ASUNTO_GET_USUARIOS_RELACIONADOS = "es.pfsgroup.recovery.ext.api.asunto.getUsuariosAsociados";
	public static final String EXT_MGR_ASUNTO_GET_SUPERVISORES = "es.pfsgroup.recovery.ext.api.asunto.getSupervisoresAsunto";
	public static final String EXT_MGR_ASUNTO_MODELO_MULTI_GESTOR = "es.pfsgroup.recovery.ext.api.asunto.modeloMultiGestor";
	public static final String EXT_MGR_ASUNTO_GET_TIPOS_GESTOR_USU_LOGADO = "es.pfsgroup.recovery.ext.api.asunto.getListTiposGestorAsuntoUsuarioLogado";
	public static final String EXT_BO_ASU_MGR_FIND_ASUNTOS_PAGINATED_DINAMICO = "es.pfsgroup.recovery.ext.api.asunto.findAsuntosPaginatedDinamico";
	public static final String BO_ASU_MGR_OBTENER_ACTUACIONES_ASUNTO_OPTIMIZADO = "asuntosManager.obtenerActuacionesAsuntoOptimizado";
	public static final String EXT_BO_ASU_MGR_FIND_ASUNTOS_PAGINATED_DINAMICO_COUNT = "es.pfsgroup.recovery.ext.api.asunto.findAsuntosPaginatedDinamicoCount";
	public static final String EXT_BO_ES_TITULIZADA = "es.pfsgroup.recovery.ext.api.asunto.esTitulizada";
	public static final String EXT_BO_ES_GET_FONDO = "es.pfsgroup.recovery.ext.api.asunto.getFondo";
	public static final String EXT_BO_ES_TIPO_GESTOR_ASIGNADO = "es.pfsgroup.recovery.ext.api.asunto.esTipoGestorAsignado";
	public static final String BO_ZONA_MGR_GET_ZONAS_POR_NIVEL_BY_CODIGO = "es.pfsgroup.recovery.ext.api.asunto.getZonasPorNivel";
	public static final String EXT_BO_MSG_ERROR_ENVIO_CDD = "asuntosManager.getMsgErrorEnvioCDD";
    public static final String EXT_BO_MSG_ERROR_ENVIO_CDD_NUSE = "asuntosManager.getMsgErrorEnvioCDDNuse";
    public static final String EXT_BO_MSG_ERROR_ENVIO_CDD_ASUNTO = "asuntosManager.getMsgErrorEnvioCDDCabecera";

	@BusinessOperationDefinition(EXT_MGR_ASUNTO_GET_GESTORES)
	public List<GestorDespacho> getGestoresAsunto(Long idAsunto);
	
	
	@BusinessOperationDefinition(EXT_MGR_ASUNTO_GET_SUPERVISORES)
	public List<GestorDespacho> getSupervisoresAsunto(Long idAsunto);
	
	
	@BusinessOperationDefinition(EXT_MGR_ASUNTO_GET_USUARIOS_RELACIONADOS)
	public Set<EXTUsuarioRelacionadoInfo> getUsuariosRelacionados(Long idAsunto);
	
	/**
	 * Nos dice si el modelo multi-gestor est� activo o no
	 * @return
	 */
	@BusinessOperationDefinition(EXT_MGR_ASUNTO_MODELO_MULTI_GESTOR)
	public boolean modeloMultiGestor();
	
	@BusinessOperationDefinition(EXT_BO_ASU_MGR_FIND_ASUNTOS_PAGINATED_DINAMICO)
	public Page findAsuntosPaginatedDinamico(EXTDtoBusquedaAsunto dto, String params);
	
	/**
	 * Esta funci�n no devuelve una lista de tipos de gestor (modelo multigestor)
	 * para el usuario logado. Si el modelo NO es multigestor, devuelve la Lista VAC�A
	 * @param idAsunto
	 * @return
	 */
	
	@BusinessOperationDefinition(EXT_MGR_ASUNTO_GET_TIPOS_GESTOR_USU_LOGADO)
	public List<EXTDDTipoGestor> getListTiposGestorAsuntoUsuarioLogado(Long idAsunto);

	@BusinessOperationDefinition(BO_ASU_MGR_OBTENER_ACTUACIONES_ASUNTO_OPTIMIZADO)
	List<Procedimiento> obtenerActuacionesAsuntoOptimizado(Long asuId);

	@BusinessOperationDefinition(EXT_BO_ASU_MGR_FIND_ASUNTOS_PAGINATED_DINAMICO_COUNT)
	public List<Asunto> findAsuntosPaginatedDinamicoCount(EXTDtoBusquedaAsunto dto, String params);
	
	/**
     * Indica si el Usuario Logado es el gestor de decision del asunto.
     * @return true si es el gestor.
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ASU_MGR_ES_GESTOR_DECISION)
    public Boolean esGestorDecision(Long id); 		
	

	@BusinessOperationDefinition(EXT_BO_ES_TITULIZADA)
	public String esTitulizada(Long idAsunto);
	
	@BusinessOperationDefinition(EXT_BO_ES_GET_FONDO)
	public String getFondo(Long idAsunto);
	
	@BusinessOperationDefinition(EXT_BO_ES_TIPO_GESTOR_ASIGNADO)
	public Boolean esTipoGestorAsignado(Long idAsunto, String codigoTipoGestor);
        
   /**
   * Indica sobre el Asunto si el proceso de envio a cierre de deuda man/auto ha generado errores de validaci�n
   * @return Mensaje de error.
   */
	@BusinessOperationDefinition(EXT_BO_MSG_ERROR_ENVIO_CDD)
	public String getMsgErrorEnvioCDD(Long idAsunto);
        
    /**
    * Indica sobre el Asunto si el proceso de envio a cierre de deuda man/auto ha generado errores en NUSE
    * @return Mensaje de error.
    */
	@BusinessOperationDefinition(EXT_BO_MSG_ERROR_ENVIO_CDD_NUSE)
	public String getMsgErrorEnvioCDDNuse(Long idAsunto);

	@BusinessOperationDefinition(BO_ZONA_MGR_GET_ZONAS_POR_NIVEL_BY_CODIGO)
	List<DDZona> getZonasPorNivel(Integer codigoNivel);

    /**
    * Eval�a el mensaje de error de envio a cierre de deuda para mostrar en cabecera asunto: Validaci�n / NUSE
    * @return Mensaje de error.
    */
	@BusinessOperationDefinition(EXT_BO_MSG_ERROR_ENVIO_CDD_ASUNTO)
	public String getMsgErrorEnvioCDDCabecera(Long idAsunto);


	@BusinessOperationDefinition(EXT_MGR_ASUNTO_GET_GESTORES_ADICIONALES_ASUNTO)
	List<EXTGestorAdicionalAsunto> getGestoresAdicionalesAsunto(Long idAsunto);
	
	/**
	 * Finaliza un asunto.
	 * 
	 * @param dto dto con los datos necesarios para finalizar en asunto. {@link MEJFinalizarAsuntoDto}
	 */
	void finalizarAsunto(MEJFinalizarAsuntoDto dto);
	
	
	/**
	 * Finaliza un asunto.
	 * 
	 * @param dto dto con los datos necesarios para finalizar en asunto. {@link MEJFinalizarAsuntoDto}
	 * @param sincronizar Indica si debe sincronizar información.
	 * 
	 */
	void finalizarAsunto(MEJFinalizarAsuntoDto dto, boolean sincronizar);
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.coreextension.api.AsuntoCoreApi#paralizaAsunto(es.capgemini.pfs.asunto.model.Asunto, java.util.Date)
	 */
	void paralizaAsunto(Asunto asunto, Date fechaParalizacion);
	
}
