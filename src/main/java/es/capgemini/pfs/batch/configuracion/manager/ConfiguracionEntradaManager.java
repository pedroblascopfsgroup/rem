package es.capgemini.pfs.batch.configuracion.manager;

import java.util.List;

import es.capgemini.pfs.batch.configuracion.model.ConfiguracionEntrada;

public interface ConfiguracionEntradaManager {

	/**
	 * Obtenemos todos los registros de la configuración del batch, ordenados
	 * por Cartera, SubCartera, Agencia
	 * 
	 * @return
	 */
	public List<ConfiguracionEntrada> obtenerAgenciasOrdenadosCarSubAge();
	
	/**
	 * Obtenemos todos los registros de la configuración del batch de los esquemas pendientes de simular, ordenados
	 * por Cartera, SubCartera, Agencia
	 * 
	 * @return
	 */
	public List<ConfiguracionEntrada> obtenerAgenciasOrdenadosCarSubAgeDeEsquemasPendientesSimular();
	
	/**
	 * Obtenemos todos los registros de la configuración del batch de los esquemas Liberados, ordenados
	 * por Cartera, SubCartera, Agencia
	 * 
	 * @return
	 */
	public List<ConfiguracionEntrada> obtenerAgenciasOrdenadosCarSubAgeDeEsquemasLiberados();
	
	/**
	 * Obtenemos el primer id esquema encontrado de la configuracion del batch
	 * @return
	 */
	public Long obtenerEsquema();
}
