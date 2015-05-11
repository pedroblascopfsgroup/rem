package es.capgemini.pfs.batch.configuracion.dao;

import java.util.List;

import es.capgemini.pfs.batch.configuracion.model.ConfiguracionEntrada;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * Intefaz de métdodos para el acceso a BBDD configuración de entrada para el Batch
 * @author Javier Ruiz
 *
 */
public interface ConfiguracionEntradaDao extends AbstractDao<ConfiguracionEntrada, Long> {
	
	/**
	 * Obtenemos todos los registros de la configuración del batch,
	 * ordenados por Cartera, SubCartera, Agencia,
	 * cuyos campos borrado = false 
	 * @param estadoEsquemaCodigo
	 * @return
	 */
	public List<ConfiguracionEntrada> obtenerAgenciasOrdenadosCarSubAge(String estadoEsquemaCodigo);
	
	/**
	 * Obtenemos el primer id esquema encontrado de la configuracion del batch
	 * @return
	 */
	public Long obtenerEsquema();
	
	/**
	 * Obtiene los esquemas y sus subcarteras, cuyos esquemas se encuentran en los estados requeridos
	 * @param estadosEsquemas, Codigo de estado de esquemas
	 * @return
	 */
	public List<Object[]> obtenerEsquemasSubCarterasPorEstadosEsquema(String[] estadosEsquemas);
}
