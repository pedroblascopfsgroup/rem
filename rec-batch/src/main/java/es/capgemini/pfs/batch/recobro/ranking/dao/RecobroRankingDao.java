package es.capgemini.pfs.batch.recobro.ranking.dao;

import java.util.Date;

/**
 * Interfaz de métodos de acceso ha base de datos para cacular
 * las variables de ranking
 * @author javier
 *
 */
public interface RecobroRankingDao {
	
	/**
	 * Calcula la contactabilidad para las fechas
	 * @param fechaInicio
	 * @param fechaFin
	 * @return
	 */
	public Float calcularContactabilidad(Date fechaInicio, Date fechaFin);
}
