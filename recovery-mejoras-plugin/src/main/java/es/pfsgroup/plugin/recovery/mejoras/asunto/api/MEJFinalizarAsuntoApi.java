package es.pfsgroup.plugin.recovery.mejoras.asunto.api;

import java.util.Date;

import es.capgemini.pfs.asunto.model.Asunto;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.coreextension.api.AsuntoCoreApi;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto.MEJFinalizarAsuntoDto;


/**
 * Api utilizada para finalizar, cancelar y paralizar asuntos.
 * 
 * Extiende {@link AsuntoCoreApi}
 * @author manuel
 *
 */
public interface MEJFinalizarAsuntoApi extends AsuntoCoreApi{
	
public static final String MEJ_FINALIZAR_ASUNTO = "plugin.mejoras.finalizarAsunto";
public static final String MEJ_CANCELAR_ASUNTO = "plugin.mejoras.cancelaAsunto";
public static final String MEJ_PARALIZAR_ASUNTO = "plugin.mejoras.paralizaAsunto";
	
	/**
	 * Finaliza un asunto.
	 * 
	 * @param dto dto con los datos necesarios para finalizar en asunto. {@link MEJFinalizarAsuntoDto}
	 */
	@BusinessOperationDefinition(MEJ_FINALIZAR_ASUNTO)
	public void finalizarAsunto(MEJFinalizarAsuntoDto dto);
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.coreextension.api.AsuntoCoreApi#cancelaAsunto(es.capgemini.pfs.asunto.model.Asunto, java.util.Date)
	 */
	@BusinessOperationDefinition(MEJ_CANCELAR_ASUNTO)
	public void cancelaAsunto(Asunto asunto, Date fechaCancelacion);
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.coreextension.api.AsuntoCoreApi#paralizaAsunto(es.capgemini.pfs.asunto.model.Asunto, java.util.Date)
	 */
	@BusinessOperationDefinition(MEJ_PARALIZAR_ASUNTO)
	public void paralizaAsunto(Asunto asunto, Date fechaParalizacion);
}
