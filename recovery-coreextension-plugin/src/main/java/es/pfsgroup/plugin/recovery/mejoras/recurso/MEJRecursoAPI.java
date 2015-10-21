package es.pfsgroup.plugin.recovery.mejoras.recurso;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.mejoras.recurso.dto.MEJDtoRecurso;
import es.pfsgroup.plugin.recovery.mejoras.recurso.model.MEJRecurso;

public interface MEJRecursoAPI {

	public static final String MEJ_BO_RECURSO_GETINSTANCE = "plugin.mejoras.MEJrecursoManager.getInstance";
	public static final String MEJ_BO_RECURSO_CREATE_OR_UPDATE = "plugin.mejoras.MEJrecursoManager.createOUpdate";
	public static final String MEJ_BO_RECURSO_CREATE_OR_UPDATE_USER_INFO = "plugin.mejoras.MEJrecursoManager.createOUpdateUserInfo";
	public static final String MEJ_BO_RECURSO_REVISADO="plugin.mejoras.MEJrecursoManager.recursoRevisado";
	public static final String MEJ_IS_PARALIZADO="plugin.mejoras.MEJrecursoManager.isParalizado";
	public static final String MEJ_IS_FINALIZADO="plugin.mejoras.MEJrecursoManager.isFinalizado";
	
	@BusinessOperationDefinition(MEJ_BO_RECURSO_GETINSTANCE)
	public MEJRecurso getInstance(Long idProcedimiento);
	
	@BusinessOperationDefinition(MEJ_BO_RECURSO_CREATE_OR_UPDATE)
    public void createOrUpdate(MEJDtoRecurso dtoRecurso);

	@BusinessOperationDefinition(MEJ_BO_RECURSO_CREATE_OR_UPDATE_USER_INFO)
    public void createOrUpdateUserInfo(MEJDtoRecurso dtoRecurso, boolean esGestor, boolean esSupervisor);
	
	@BusinessOperationDefinition(MEJ_BO_RECURSO_REVISADO)
    public void recursoRevisado(MEJDtoRecurso dtoRecurso);

	@BusinessOperationDefinition(MEJ_IS_PARALIZADO)
	Boolean isParalizado(Long idProcedimiento);

	@BusinessOperationDefinition(MEJ_IS_FINALIZADO)
	Boolean isFinalizado(Long idProcedimiento);
}
