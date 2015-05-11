package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dao;

import java.util.Date;
import java.util.List;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.model.PeticionCambioMasivoGestoresAsunto;

/**
 * DAO para las actualizaciones de BBDD necesarias para las peticiones de cambios masivas.
 * @author bruno
 *
 */
public interface CambioMasivoGestoresAsuntoDao extends AbstractDao<PeticionCambioMasivoGestoresAsunto, Long>{
	
	/**
	 * Inserta de golpe todas las peticiones para todos los asuntos que coinciden con gestor/tipo gestor
	 * 
	 * @param solicitante Usuario que solicita el cambio
	 * @param tipoGestor Código del tipo de gestor
	 * @param idGestorOriginal Id del usuario gestor que se quiere cambiar
	 * @param idNuevoGestor Id del nuevo gestor
	 * @param fechaInicio Inicio vigencia del cambio
	 * @param fechaFin Si es distinto de null, fin vigencia cambio. Si es null el cambio es permanente
	 */
	void insertDirectoPeticiones(Usuario solicitante, String tipoGestor, Long idGestorOriginal, Long idNuevoGestor, Date fechaInicio, Date fechaFin);

	/**
	 * Cuenta las inserciones que se realizarían para unos determinados parámetros
	 * @param solicitante Usuario que solicita el cambio
	 * @param tipoGestor Código del tipo de gestor
	 * @param idGestorOriginal Id del usuario gestor que se quiere cambiar
	 * @param idNuevoGestor Id del nuevo gestor
	 * @param fechaInicio Inicio vigencia del cambio
	 * @param fechaFin Si es distinto de null, fin vigencia cambio. Si es null el cambio es permanente
	 * @return
	 */
	int contarPeticiones(Usuario solicitante, String tipoGestor, Long idGestorOriginal, Long idNuevoGestor, Date fechaInicio, Date fechaFin);

}
