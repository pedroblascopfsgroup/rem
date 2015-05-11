package es.capgemini.pfs.batch.scoring.dao.impl;

import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.pfs.batch.scoring.dao.ScoringBatchDao;

/**
 * Clase que contiene los métodos de acceso a la bbdd para la entidad Movimientos.
 *
 * @author mtorrado
 *
 */
public class ScoringBatchDaoImpl implements ScoringBatchDao {



	private final Log logger = LogFactory.getLog(getClass());

    private DataSource dataSource;
    private String descactivarTotalesQuery;
    private String crearRegistrosEnTablasTotalesQuery;
    private String crearRegistrosEnTablasParcialesQuery;
    private String calcularPuntuacionTotalQuery;
    private String calcularRatingQuery;
    private String calcularRangoQuery;
    private String existeRangoQuery;
    private String metricasValidasQuery;
    private String insertIncidencia;

    /**
     * Validación ale-31.existeRango.
     * @return true si es correcto.
     */
    public boolean validarRangos(){
    	JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        long cantidadDeRegistros = jdbcTemplate.queryForLong(existeRangoQuery);
        if (cantidadDeRegistros==0){
        	jdbcTemplate.update(insertIncidencia,new Object[]{"No existe el rango","error"});
        	return false;
        }
        return true;
    }

    /**
     * Validación ale-32.metricaValidas.
     * @return true si es correcto.
     */
    @SuppressWarnings("unchecked")
    public boolean validarMetricas(){
    	JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
    	List<Map> result;
        result = jdbcTemplate.queryForList(metricasValidasQuery);
        if (result.isEmpty()) {
        	return true;
        }
        for (Map record : result) {

            String codigoValor = "" + record.get("ERROR_FIELD");
            String codigoEntidad = "" + record.get("ENTITY_CODE");
            jdbcTemplate.update(insertIncidencia,new Object[]{"Problemas con la métrica"+codigoEntidad+" del tipo "+codigoValor,"error"});
        }
      	return false;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void desactivarTotales() {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        jdbcTemplate.update(descactivarTotalesQuery);
        logger.debug("Registros en la tabla de totales desactivadas");
    }


    /**
     * {@inheritDoc}
     */
    @Override
    public void crearRegistrosEnTablasTotales() {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        jdbcTemplate.update(crearRegistrosEnTablasTotalesQuery);
        logger.debug("Registros en la tabla de totales creados");

    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void crearRegistrosEnTablaParciales() {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        jdbcTemplate.update(crearRegistrosEnTablasParcialesQuery);
        logger.debug("Registros en la tabla de parciales creados");

    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void calcularPuntuacionTotal() {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        jdbcTemplate.update(calcularPuntuacionTotalQuery);
        logger.debug("Totales calculados");
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void calcularRating() {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        jdbcTemplate.update(calcularRatingQuery);
        logger.debug("Rating calculados");
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void calcularRango() {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        jdbcTemplate.update(calcularRangoQuery);
        logger.debug("Rangos calculados");
    }
    // ------------------------------
    // Setters
    // ------------------------------

    /**
     * {@inheritDoc}
     */
    @Override
    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;

    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setDesactivarTotalesQuery(String descactivarTotalesQuery) {
        this.descactivarTotalesQuery = descactivarTotalesQuery;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setCrearRegistrosEnTablasTotalesQuery(String crearRegistrosEnTablasTotales) {
        this.crearRegistrosEnTablasTotalesQuery = crearRegistrosEnTablasTotales;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setCrearRegistrosEnTablasParcialesQuery(String crearRegistrosEnTablasParciales) {
        this.crearRegistrosEnTablasParcialesQuery = crearRegistrosEnTablasParciales;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setCalcularPuntuacionTotalQuery(String calcularPuntuacionTotal) {
        this.calcularPuntuacionTotalQuery = calcularPuntuacionTotal;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setCalcularRatingQuery(String calcularRatingQuery) {
        this.calcularRatingQuery = calcularRatingQuery;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setCalcularRangoQuery(String calcularRangoQuery) {
        this.calcularRangoQuery = calcularRangoQuery;
    }

    /**
	 * @param existeRangoQuery the existeRangoQuery to set
	 */
	public void setExisteRangoQuery(String existeRangoQuery) {
		this.existeRangoQuery = existeRangoQuery;
	}

	/**
	 * @param metricasValidasQuery the metricasValidasQuery to set
	 */
	public void setMetricasValidasQuery(String metricasValidasQuery) {
		this.metricasValidasQuery = metricasValidasQuery;
	}

	/**
	 * @param insertIncidencia the insertIncidencia to set
	 */
	public void setInsertIncidencia(String insertIncidencia) {
		this.insertIncidencia = insertIncidencia;
	}

}
