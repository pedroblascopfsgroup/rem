package es.pfsgroup.plugin.recovery.mejoras.tareaNotificacion;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.prorroga.dto.DtoSolicitarProrroga;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;

public interface MEJTareaNoficacionApi {
	
	/**
	 * método para generar autoprórrogas
	 * llama a las operaciones de negocio de solicitar prorroga y de conceder prorroga
	 * @param dto
	 */
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_GENERAR_AUTOPRORROGA)
	@Transactional(readOnly=false)
	void generarAutoprorroga(DtoSolicitarProrroga dto);
	

	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_LISTA_COMUNICACIONES_ASU)
	public List<TareaNotificacion> getListComunicacionesAsunto(Long idAsunto);
		
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_PERMITE_PRORROGAS)
	public boolean permiteProrrogas(Long idProcedimiento);

}
