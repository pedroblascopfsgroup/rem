package es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model;

import es.capgemini.pfs.persona.model.Persona;

/**
 * Datos a considerar sobre el titular de un Bien.
 * @author bruno
 *
 */
public interface NMBTitularBienInfo {
	
	/**
	 * Persona titular
	 * @return
	 */
	Persona getPersona();
	
	/**
	 * Bien del que �s titular
	 * @return
	 */
	NMBBienInfo getBien();
	
	/**
	 * Porcentage de participaci�n
	 * @return
	 */
	Integer getParticipacion();

}
