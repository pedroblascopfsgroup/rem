package es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento;

import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.decisionProcedimiento.dto.DtoDecisionProcedimiento;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;

import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import java.util.List;

public interface DecisionProcedimientoApi {

	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_DECISIONPROCEDIMIENTO_REANUDAR)
	@Transactional(readOnly = false)
	public void reanudarProcedimientoParalizado(Long id);
	
	 /**
     * Da por aceptada la propuesta de Decision<br>
     * Lanza los correspondientes BPM.
     * @param dtoDecisionProcedimiento dtoDecisionProcedimiento
	 * @throws Exception 
     * @throws Exception e
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
	@Transactional(readOnly = false)
	public void rechazarPropuesta(MEJDtoDecisionProcedimiento dto);

	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_DECISIONPROCEDIMIENTO_LISTA)
	public List<DecisionProcedimiento> getListDecisionProcedimientoSoloConDecisionFinal(Long id);	
	
}
