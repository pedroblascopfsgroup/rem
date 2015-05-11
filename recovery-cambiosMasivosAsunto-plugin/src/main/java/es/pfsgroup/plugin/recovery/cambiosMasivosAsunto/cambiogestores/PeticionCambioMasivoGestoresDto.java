package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores;

import java.util.Date;

import es.capgemini.pfs.users.domain.Usuario;

/**
 * Petición de cambio masivo de gestores sobre un Asunto
 * 
 * @author bruno
 * 
 */
public interface PeticionCambioMasivoGestoresDto {

	/**
	 * Usuario que solicita la petición
	 * 
	 * @return
	 */
	Usuario getSolicitante();

	/**
	 * Código del tipo de gestor que se quiere cambiar
	 * 
	 * @return
	 */
	String getTipoGestor();

	/**
	 * Id del Usuario gesor original
	 * 
	 * @return
	 */
	Long getIdGestorOriginal();

	/**
	 * Id del nuevo gestor que se quiere asignar
	 * 
	 * @return
	 */
	Long getIdNuevoGestor();

	/**
	 * Fecha en la que se debe entrar en vigor el cambio
	 * 
	 * @return
	 */
	Date getFechaInicio();

	/**
	 * Fecha en la que el cambio debe dejar de estar en vigor. Llegado el día se
	 * debe volver al gestor original. Esta fecha puede estar vacía para un
	 * cambio permanente
	 * 
	 * @return
	 */
	Date getFechaFin();
	
	/**
	 * Indica si la reasignación se ha realizado (true) o está aún pendiente (false)
	 * @return
	 */
	boolean isReasignado();
}
