package es.capgemini.pfs.batch.scoring.dao;

import javax.sql.DataSource;

/**
 * Clase que contiene los métodos de acceso a la bbdd para las tablas PTO_PUNTUACION_TOTAL y PPA_PUNTUACION_PARCIAL.
 *
 * @author Andrés Esteban
 *
 */
public interface ScoringBatchDao {

    /**
     * Desactiva los registros de la tabla PTO_PUNTUACION_TOTAL.
     */
    void desactivarTotales();

    /**
     * Crea en la tabla PTO_PUNTUACION_TOTAL un registro por cada persona con una alerta activa.
     */
    void crearRegistrosEnTablasTotales();

    /**
     * Crea en la tabla PPA_PUNTUACION_PARCIAL un registro por cada alerta activa.
     */
    void crearRegistrosEnTablaParciales();

    /**
     * Calcula el campo de puntuacion para la tabla PTO_PUNTUACION_TOTAL en base
     * a los registros asociados en PPA_PUNTUACION_PARCIAL.
     */
    void calcularPuntuacionTotal();

    /**
     * Calcula el campo de raitng para la tabla PTO_PUNTUACION_TOTAL en base
     * al campo PTO_PUNTUACION. A valores iguales le corresponde distinto rating.
     */
    void calcularRating();

    /**
     * Calcula el rango de la tabla PTO_PUNTUACION_TOTAL en base al rating de cada registro y el rango definido.
     * Los valores posibles empiezan desde A hasta ZZ.
     */
    void calcularRango();

    // ------------------------------
    // Setters
    // ------------------------------

    /**
     * Setea el DataSource.
     *
     * @param dataSource
     *            datasource to set
     */
    void setDataSource(DataSource dataSource);

    /**
     * @param descactivarTotalesQuery the descactivarTotalesQuery to set
     */
    void setDesactivarTotalesQuery(String descactivarTotalesQuery);

    /**
     * @param crearRegistrosEnTablasTotales the crearRegistrosEnTablasTotales to set
     */
    void setCrearRegistrosEnTablasTotalesQuery(String crearRegistrosEnTablasTotales);

    /**
     * @param crearRegistrosEnTablasParciales the crearRegistrosEnTablasParciales to set
     */
    void setCrearRegistrosEnTablasParcialesQuery(String crearRegistrosEnTablasParciales);

    /**
     * @param calcularPuntuacionTotal the calcularPuntuacionTotal to set
     */
    void setCalcularPuntuacionTotalQuery(String calcularPuntuacionTotal);

    /**
     * @param calcularRatingQuery the calcularRatingQuery to set
     */
    void setCalcularRatingQuery(String calcularRatingQuery);

    /**
     * @param calcularRangoQuery the calcularRangoQuery to set
     */
    void setCalcularRangoQuery(String calcularRangoQuery);

    /**
	 * @param existeRangoQuery the existeRangoQuery to set
	 */
	void setExisteRangoQuery(String existeRangoQuery);

	/**
	 * @param metricasValidasQuery the metricasValidasQuery to set
	 */
	void setMetricasValidasQuery(String metricasValidasQuery);

	/**
	 * @param insertIncidencia the insertIncidencia to set
	 */
	void setInsertIncidencia(String insertIncidencia);

    /**
     * Validación ale-31.existeRango.
     * @return true si es correcto.
     */
    boolean validarRangos();

    /**
     * Validación ale-32.metricaValidas.
     * @return true si es correcto.
     */
    boolean validarMetricas();
}
