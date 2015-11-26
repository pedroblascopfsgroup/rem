package es.pfsgroup.recovery.ext.api.procedimiento;

import java.util.List;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;

public interface EXTProcedimientoApi {

	public static final String BO_PRC_MGR_BUSCAR_PRC_CON_CONTRATO = "es.pfsgroup.recovery.ext.api.procedimiento.buscaProcedimientoConContrato";
	public static final String BO_PRC_MGR_IS_PERSONA_EN_PROCEDIMIENTO = "es.pfsgroup.recovery.ext.api.procedimiento.isPersonaEnProcedimiento";
	public static final String BO_PRC_MGR_GET_INSTANCE_OF = "es.pfsgroup.recovery.ext.api.procedimiento.getInstanceOf";
	public static final String MEJ_BO_PRC_ES_GESTOR_CEX = "es.pfsgroup.recovery.mejoras.api.procedimiento.esGestorCex";
	public static final String MEJ_BO_PRC_ES_SUPERVISOR_CEX = "es.pfsgroup.recovery.mejoras.api.procedimiento.esSupervisorCex";

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
	MEJProcedimiento getInstanceOf(Procedimiento procedimiento);
	
	@BusinessOperationDefinition(MEJ_BO_PRC_ES_GESTOR_CEX)
    Boolean esGestorCEX(Long idProcedimiento,String codUg);
    
    @BusinessOperationDefinition(MEJ_BO_PRC_ES_SUPERVISOR_CEX)
    Boolean esSupervisorCEX(Long idProcedimiento,String codUg);

	boolean isDespararizable(Long idProcedimiento);

	boolean isDespararizablePorEntidad(Long idProcedimiento);
	
	void desparalizarProcedimiento(Long idProcedimiento);
	void desparalizarProcedimiento(Long idProcedimiento, boolean envioMsg);

	MEJProcedimiento get(Long id);

}
