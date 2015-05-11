package es.capgemini.pfs.batch.revisar.cargaVolumenContratos.dao.impl;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.pfs.batch.revisar.cargaVolumenContratos.dao.CargaVolumenContratosBatchDao;


/**
 * Carga la información sobre la carga anterior de contratos a producción en la tabla
 * de validaciones de carga de contratos (ver BATCH-83).
 * @author Mariano Ruiz
 *
 */
//@Repository("CargaVolumenContratosBatchDao")
public class CargaVolumenContratosBatchDaoImpl implements CargaVolumenContratosBatchDao{

    private DataSource dataSource;

    // Querys acerca de un registro en particular de la tabla de val. de contratos
    private String buscarUltimaValidacionQuery;

    // Query que retorna las estadísticas de validación anteriormente cargado
    private String buscarDatosValidacionAnteriorQuery;

    // Query que calculan cantidad de registros y totales
    private String cargaContratosVolumenValidatorQuery;

    // Query de carga
    private String insertValidacionCargaQuery;

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> buscarVolumenContratos() {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        return jdbcTemplate.queryForMap(cargaContratosVolumenValidatorQuery);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> buscarDatosValidacionAnterior(Long idRegistroValidacion) {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        return jdbcTemplate.queryForMap(buscarDatosValidacionAnteriorQuery, new Object[] { idRegistroValidacion });
    }


    /**
     * Busca el último registro de carga de validación.
     * @return Long: ID de la última carga de validación, <code>null</code> si la tabla está vacía
     */
    public Long buscarUltimaValidacion() {
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        try {
            return (Long) jdbcTemplate.queryForObject(buscarUltimaValidacionQuery, Long.class);
        } catch(EmptyResultDataAccessException e) {
            // La tabla está vacía, retorno ID nulo
            return null;
        }
    }



    /**
     * {@inheritDoc}
     */
    public void insertValidacionCarga(Date fechaCarga, String ficheroCarga,
                                      BigDecimal activoLineas, BigDecimal activoPosicionVencida, BigDecimal activoPosicionViva,
                                      BigDecimal pasivoLineas, BigDecimal pasivoPosicionVencida, BigDecimal pasivoPosicionViva)
    {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat();
        simpleDateFormat.applyPattern("yyyy-MM-dd");
        JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
        Object[] args = { simpleDateFormat.format(fechaCarga), ficheroCarga, activoLineas, activoPosicionVencida, activoPosicionViva,
                          pasivoLineas, pasivoPosicionVencida, pasivoPosicionViva };
        jdbcTemplate.update(insertValidacionCargaQuery, args);
    }



    /*
     *  Getters y setters
     *
     */


    /**
     * @param dataSource the dataSource to set
     */
    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    /**
     * @param buscarUltimaValidacionQuery the buscarUltimaValidacionQuery to set
     */
    public void setBuscarUltimaValidacionQuery(String buscarUltimaValidacionQuery) {
        this.buscarUltimaValidacionQuery = buscarUltimaValidacionQuery;
    }

    /**
     * @param insertValidacionCargaQuery the insertValidacionCargaQuery to set
     */
    public void setInsertValidacionCargaQuery(String insertValidacionCargaQuery) {
        this.insertValidacionCargaQuery = insertValidacionCargaQuery;
    }


    /**
     * @param cargaContratosVolumenValidatorQuery the cargaContratosVolumenValidatorQuery to set
     */
    public void setCargaContratosVolumenValidatorQuery(String cargaContratosVolumenValidatorQuery) {
        this.cargaContratosVolumenValidatorQuery = cargaContratosVolumenValidatorQuery;
    }


    /**
     * @param buscarDatosValidacionAnteriorQuery the buscarDatosValidacionAnteriorQuery to set
     */
    public void setBuscarDatosValidacionAnteriorQuery(String buscarDatosValidacionAnteriorQuery) {
        this.buscarDatosValidacionAnteriorQuery = buscarDatosValidacionAnteriorQuery;
    }
}
