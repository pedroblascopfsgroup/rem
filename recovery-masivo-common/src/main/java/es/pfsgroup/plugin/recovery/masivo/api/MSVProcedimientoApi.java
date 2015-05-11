package es.pfsgroup.plugin.recovery.masivo.api;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVBuscaProcedimientoDelContratoDto;

/**
 * @author Carlos
 * Capa de negocio de los objetos Procedimiento para masivo.
 *
 */
public interface MSVProcedimientoApi {
	
	public static final String MSV_BO_CREA_PROCEDIMIENTO_HIJO = "es.pfsgroup.plugin.recovery.masivo.api.creaProcedimientoHijoMasivo";
	public static final String MSV_BO_BUSCA_PRC_CONTRATO = "es.pfsgroup.plugin.recovery.masivo.api.buscaProcedimientoDelContrato";
	public static final String MSV_BO_BUSCA_PRC_CONTRATO_DTO = "es.pfsgroup.plugin.recovery.masivo.api.buscaProcedimientoDelContratoDto";

	/**
	 * Crea un procedimiento hijo del tipo indicado, duplicado de mejoras pero para el batch
	 * 
	 * @param tipoProcedimiento
	 * @param procPadre
	 * @return
	 */
	@BusinessOperationDefinition(MSV_BO_CREA_PROCEDIMIENTO_HIJO)
	Procedimiento creaProcedimientoHijoMasivo(TipoProcedimiento tipoProcedimiento, Procedimiento procPadre);

	/**
	 * Busca el procedimiento del contrato indicado y que sea del tipo de procedimiento, si no encuentra el prc devuelve el último 
	 * 
	 * @param nroContrato
	 * @param tipoProcedimiento
	 * @return
	 */
	@BusinessOperationDefinition(MSV_BO_BUSCA_PRC_CONTRATO)
	Procedimiento buscaProcedimientoDelContrato(String nroContrato, long tipoProcedimiento);
	
	/**
	 * Busca el procedimiento del contrato que cumpla las condiciones pasadas en el dto. 
	 * En caso de que no cumpla las condiciones devuelve el último del contrato.
	 * 
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(MSV_BO_BUSCA_PRC_CONTRATO_DTO)
	Procedimiento buscaProcedimientoDelContrato(MSVBuscaProcedimientoDelContratoDto dto);
}
