package es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento;

import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;

import java.util.List;

public interface DecisionProcedimientoApi {

	public static final String BO_DEC_PCR_ELIMINAR_PROCEDIMIENTO = "decisionProcedimientoManager.borrarProcedimiento";
	public static final String BO_DEC_PCR_ACTUALIZAR_PROCEDIMIENTO = "decisionProcedimientoManager.actualizarProcedimiento";

	public static final String MEJ_BO_DECISIONPROCEDIMIENTO_REANUDAR="plugin.mejoras.decisionProcedimiento.reanudarProcedimiento";
	public static final String MEJ_BO_DECISIONPROCEDIMIENTO_LISTA="plugin.mejoras.decisionProcedimiento.getListDecisionProcedimiento";
	
	/**
	 * reanuda las tareas que estaban paralizadas del procedimiento
	 * @param id del procedimiento
	 */
	@BusinessOperationDefinition(MEJ_BO_DECISIONPROCEDIMIENTO_REANUDAR)
	@Transactional(readOnly = false)
	public void reanudarProcedimientoParalizado(Long id);
	
	 /**
     * Da por aceptada la propuesta de Decision<br>
     * Lanza los correspondientes BPM.
     * @param dtoDecisionProcedimiento dtoDecisionProcedimiento
	 * @throws Exception 
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_DEC_PRC_MGR_ACEPTAR_PROPUESTA)
    public void aceptarPropuesta(MEJDtoDecisionProcedimiento dtoDecisionProcedimiento);

	 /**
     * Para crear o actualizar una propuesta de decision desde un rol de gestor.
     * @param dtoDecisionProcedimiento dtoDecisionProcedimiento
     * @throws Exception e
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_DEC_PRC_MGR_CREAR_PROPUESTA)
	public void crearPropuesta(MEJDtoDecisionProcedimiento dtoDecisionProcedimiento);

	
	@BusinessOperationDefinition(ExternaBusinessOperation.BO_DEC_PRC_MGR_RECHAZAR_PROPUESTA)
	public void rechazarPropuesta(MEJDtoDecisionProcedimiento dto);

	@BusinessOperationDefinition(MEJ_BO_DECISIONPROCEDIMIENTO_LISTA)
	public List<DecisionProcedimiento> getListDecisionProcedimientoSoloConDecisionFinal(Long id);	
	
}
