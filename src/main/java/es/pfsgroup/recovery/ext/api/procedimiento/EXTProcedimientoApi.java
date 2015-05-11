package es.pfsgroup.recovery.ext.api.procedimiento;

import java.util.List;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;

public interface EXTProcedimientoApi {

	public static final String BO_PRC_MGR_BUSCAR_PRC_CON_CONTRATO = "es.pfsgroup.recovery.ext.api.procedimiento.buscaProcedimientoConContrato";
	public static final String BO_PRC_MGR_IS_PERSONA_EN_PROCEDIMIENTO = "es.pfsgroup.recovery.ext.api.procedimiento.isPersonaEnProcedimiento";
	public static final String BO_PRC_MGR_GET_INSTANCE_OF = "es.pfsgroup.recovery.ext.api.procedimiento.getInstanceOf";

	/**
	 * Busca procedimientos que contengan un determinado contrato
	 * 
	 * @param idContrato
	 *            ID del contrato buscado
	 * @param estados
	 *            Posibles estados de los Procedimientos a devolver. Si es NULL
	 *            se devolveran todos los procedimientos independientemente del
	 *            estado
	 * @return
	 */
	@BusinessOperationDefinition(BO_PRC_MGR_BUSCAR_PRC_CON_CONTRATO)
	List<? extends Procedimiento> buscaProcedimientoConContrato(
			Long idContrato, String[] estados);
	
	@BusinessOperationDefinition(BO_PRC_MGR_IS_PERSONA_EN_PROCEDIMIENTO)
	Boolean isPersonaEnProcedimiento(Long procedimiento, Long persona);

	@BusinessOperationDefinition(BO_PRC_MGR_GET_INSTANCE_OF)
	public MEJProcedimiento getInstanceOf(Procedimiento procedimiento);
}
