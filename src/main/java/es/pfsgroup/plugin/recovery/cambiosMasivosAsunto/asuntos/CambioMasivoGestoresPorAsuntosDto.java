package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.asuntos;

import java.util.Date;
import java.util.List;

import es.capgemini.pfs.users.domain.Usuario;

/**
 * Petici�n de cambio masivo de gestores sobre un Asunto
 * 
 * @author bruno
 * 
 */
public interface CambioMasivoGestoresPorAsuntosDto {

	/**
	 * Usuario que solicita la petici�n
	 * 
	 * @return
	 */
	Usuario getSolicitante();

	/**
	 * C�digo del tipo de gestor que se quiere cambiar
	 * 
	 * @return
	 */
	String getTipoGestor();

	/**
	 * Id del nuevo usuario a asignar a los asuntos recibidos
	 * 
	 * @return
	 */
	Long getIdGestorOriginal();


	/**
	 * Fecha en la que se debe entrar en vigor el cambio
	 * 
	 * @return
	 */
	Date getFechaInicio();

	/**
	 * Fecha en la que el cambio debe dejar de estar en vigor. Llegado el d�a se
	 * debe volver al gestor original. Esta fecha puede estar vac�a para un
	 * cambio permanente
	 * 
	 * @return
	 */
	Date getFechaFin();
	
	/**
	 * Indica si la reasignaci�n se ha realizado (true) o est� a�n pendiente (false)
	 * @return
	 */
	boolean isReasignado();
	
	/**
	 * lista de asuntos a modificar
	 * @return
	 */
	List<Long> getListaAsuntos();
}
