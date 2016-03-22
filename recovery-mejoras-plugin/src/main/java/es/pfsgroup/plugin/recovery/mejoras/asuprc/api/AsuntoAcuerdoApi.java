package es.pfsgroup.plugin.recovery.mejoras.asuprc.api;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.expediente.model.Expediente;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;


public interface AsuntoAcuerdoApi {
	
	String BO_CORE_ASUNTO_PUEDER_VER_TAB_ACUERDOS = "AsuntoAcuerdoManager.puedeVerTabAcuerdos";
	String BO_ASUNTO_ORIGEN = "AsuntoAcuerdoManager.asuntoOrigen";
	String BO_EXPEDIENTE_ORIGEN = "AsuntoAcuerdoManager.expedienteOrigen";

	
	/**
	 * Método que devuelve el origen del asunto
	 * @param asuId
	 */
    @BusinessOperationDefinition(BO_ASUNTO_ORIGEN)
    public Asunto asuntoOrigen(Long idAsunto);
    
    /**
	 * Método que devuelve el origen del asunto
	 * @param asuId
	 */
    @BusinessOperationDefinition(BO_ASUNTO_ORIGEN)
    public Expediente expedienteOrigen(Long idAsunto);
    
    @BusinessOperation(BO_CORE_ASUNTO_PUEDER_VER_TAB_ACUERDOS)
    public Boolean puedeVerTabAcuerdos(Long idAsunto);
}