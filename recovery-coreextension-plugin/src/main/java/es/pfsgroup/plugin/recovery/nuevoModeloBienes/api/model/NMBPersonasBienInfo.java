package es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.Persona;

/**
 * Datos a considerar sobre el Bien
 * @author bruno
 *
 */
public interface NMBPersonasBienInfo {
	
	/**
	 * Bien asociado a la relación bien-contrato
	 */
	Long getId();
	
	/**
	 * Bien asociado a la relación bien-contrato
	 */
	NMBBienInfo getBien();
	
	/**
	 * Contrato asociado a la relación bien-contrato
	 */
	Persona getPersona();	
	
	/**
	 * Tipo de relación entre el bien y el contrato 
	 */
	Float getParticipacion();
	
	/**
	 * Auditoria
	 */
	Auditoria getAuditoria();
	
	/**
	 * Version
	 */
	Integer getVersion();
	
	
}
