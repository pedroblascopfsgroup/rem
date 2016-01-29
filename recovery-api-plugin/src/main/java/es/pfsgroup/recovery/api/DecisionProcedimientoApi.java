package es.pfsgroup.recovery.api;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.decisionProcedimiento.dto.DtoDecisionProcedimiento;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

/**
 * BO de Recovery para la Decision Procedimiento
 * @author bruno
 *
 */
public interface DecisionProcedimientoApi {
	/**
     * Da por aceptada la propuesta de Decision<br>
     * Lanza los correspondientes BPM.
     * @param dtoDecisionProcedimiento dtoDecisionProcedimiento
     * @throws Exception e
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_DEC_PRC_MGR_ACEPTAR_PROPUESTA)
    void aceptarPropuesta(DtoDecisionProcedimiento dtoDecisionProcedimiento) throws Exception;
    
    
    /**
     * Para crear o actualizar una propuesta de decision desde un rol de gestor.
     * @param dtoDecisionProcedimiento dtoDecisionProcedimiento
     * @throws Exception e
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_DEC_PRC_MGR_CREAR_PROPUESTA)
    @Transactional
    public void crearPropuesta(DtoDecisionProcedimiento dtoDecisionProcedimiento) throws Exception ;
    
    /**
     * Rechaza la propuesta de Decision.
     *
     * @param dtoDecisionProcedimiento dto
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_DEC_PRC_MGR_RECHAZAR_PROPUESTA)
    @Transactional
    void rechazarPropuesta(DtoDecisionProcedimiento dtoDecisionProcedimiento) ;
    
    
    /**
     * Crea o Actualiza un objeto DecisionProcedimiento en la BD.
     *
     * @param dtoDecisionProcedimiento dtoDecisionProcedimiento
     * @return DecisionProcedimiento
     * @throws Exception e
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_DEC_PRC_MGR_CREATE_OR_UPDATE)
    @Transactional
    public DecisionProcedimiento createOrUpdate(DtoDecisionProcedimiento dtoDecisionProcedimiento) throws Exception;
}
