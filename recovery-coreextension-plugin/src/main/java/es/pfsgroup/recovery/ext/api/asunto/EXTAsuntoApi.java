package es.pfsgroup.recovery.ext.api.asunto;

import java.util.List;
import java.util.Set;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.dto.DtoProcedimiento;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.ext.impl.asunto.dto.EXTDtoBusquedaAsunto;

public interface EXTAsuntoApi {

	public static final String EXT_MGR_ASUNTO_GET_GESTORES = "es.pfsgroup.recovery.ext.api.asunto.getGestoresAsuto";
	public static final String EXT_MGR_ASUNTO_GET_USUARIOS_RELACIONADOS = "es.pfsgroup.recovery.ext.api.asunto.getUsuariosAsociados";
	public static final String EXT_MGR_ASUNTO_GET_SUPERVISORES = "es.pfsgroup.recovery.ext.api.asunto.getSupervisoresAsunto";
	public static final String EXT_MGR_ASUNTO_MODELO_MULTI_GESTOR = "es.pfsgroup.recovery.ext.api.asunto.modeloMultiGestor";
	public static final String EXT_MGR_ASUNTO_GET_TIPOS_GESTOR_USU_LOGADO = "es.pfsgroup.recovery.ext.api.asunto.getListTiposGestorAsuntoUsuarioLogado";
	public static final String EXT_BO_ASU_MGR_FIND_ASUNTOS_PAGINATED_DINAMICO = "es.pfsgroup.recovery.ext.api.asunto.findAsuntosPaginatedDinamico";
	public static final String BO_ASU_MGR_OBTENER_ACTUACIONES_ASUNTO_OPTIMIZADO = "asuntosManager.obtenerActuacionesAsuntoOptimizado";
	public static final String EXT_BO_ASU_MGR_FIND_ASUNTOS_PAGINATED_DINAMICO_COUNT = "es.pfsgroup.recovery.ext.api.asunto.findAsuntosPaginatedDinamicoCount";
	
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
	List<DtoProcedimiento> obtenerActuacionesAsuntoOptimizado(Long asuId);

	@BusinessOperationDefinition(EXT_BO_ASU_MGR_FIND_ASUNTOS_PAGINATED_DINAMICO_COUNT)
	public Integer findAsuntosPaginatedDinamicoCount(EXTDtoBusquedaAsunto dto, String params);
	
	/**
     * Indica si el Usuario Logado es el gestor de decision del asunto.
     * @return true si es el gestor.
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ASU_MGR_ES_GESTOR_DECISION)
    public Boolean esGestorDecision(); 		
	


	
}
