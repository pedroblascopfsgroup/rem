package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.asuntos.dao;

import java.util.Date;
import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.model.PeticionCambioMasivoGestoresAsunto;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJInfoRegistro;

public interface CambiosMasivosDao extends AbstractDao<PeticionCambioMasivoGestoresAsunto, Long>{
	
	List<PeticionCambioMasivoGestoresAsunto> buscarCambioGestoresPendientesPaginados(Long idAsunto);

	/**
	 * Inserta de golpe todas las peticiones para todos los asuntos recibidos
	 * 
	 * @param solicitante Usuario que solicita el cambio
	 * @param tipoGestor Código del tipo de gestor
	 * @param idGestorOriginal Id del usuario gestor que se quiere cambiar
	 * @param fechaInicio Inicio vigencia del cambio
	 * @param fechaFin Si es distinto de null, fin vigencia cambio. Si es null el cambio es permanente
	 * @param listaAsuntos lista de asuntos a modificar
	 */
	void insertDirectoPeticionesPorAsuntos(Usuario solicitante, String tipoGestor, Long idNuevoGestor, Date fechaInicio, Date fechaFin, List<Long> listaAsuntos);

}
