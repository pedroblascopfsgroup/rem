package es.capgemini.pfs.batch.revisar.cargaVolumenContratos.dao;

import java.math.BigDecimal;
import java.util.Date;
import java.util.Map;

import javax.sql.DataSource;


/**
 * Carga la información sobre la carga anterior de contratos a producción en la tabla
 * de validaciones de carga de contratos (ver BATCH-83).
 * @author Mariano Ruiz
 *
 */
public interface CargaVolumenContratosBatchDao {

	/**
     * Estadísticas de la tabla temporal de contratos.
     * @return Map con los siguientes objectos:
     * <ul>
     *  <li>Long   activoLineas</li>
     *  <li>Double activoPosicionVencida</li>
     *  <li>Long   pasivoLineas</li>
     *  <li>Double pasivoPosicionVencida</li>
     *  <li>Double activoPosicionViva</li>
     *  <li>Double pasivoPosicionViva</li>
     * </ul>
     */
    Map<String, Object> buscarVolumenContratos();

    /**
     * Estadísticas de una carga anterior de contratos.
     * @param idRegistroValidacion Long: ID de la registración anterior a buscar
     * @return Map con los siguientes objectos:
     * <ul>
     *  <li>Long   activoLineas</li>
     *  <li>Double activoPosicionVencida</li>
     *  <li>Long   pasivoLineas</li>
     *  <li>Double pasivoPosicionVencida</li>
     *  <li>Double activoPosicionViva</li>
     *  <li>Double pasivoPosicionViva</li>
     * </ul>
     */
    Map<String, Object> buscarDatosValidacionAnterior(Long idRegistroValidacion);

    /**
     * Busca el último registro de carga de validación.
     * @return Long: ID de la última carga de validación, <code>null</code> si la tabla está vacía
     */
    Long buscarUltimaValidacion();

    // Inserción el la BBDD

    /**
     * Inserta en la tabla de validaciones de carga, los datos estadísticos de la carga a realizarse.
     * @param fechaCarga fecha
     * @param ficheroCarga fichero carga
     * @param activoLineas activo Lineas
     * @param activoPosicionVencida activoPosicionVencida
     * @param activoPosicionViva activoPosicionViva
     * @param pasivoLineas pasivoLineas
     * @param pasivoPosicionVencida pasivoPosicionVencida
     * @param pasivoPosicionViva pasivoPosicionViva
     */
     void insertValidacionCarga(Date fechaCarga, String ficheroCarga,
                                      BigDecimal activoLineas, BigDecimal activoPosicionVencida, BigDecimal activoPosicionViva,
                                      BigDecimal pasivoLineas, BigDecimal pasivoPosicionVencida, BigDecimal pasivoPosicionViva);


    /*
     *  Getters y setters
     *
     */

     /**
     * @param dataSource the dataSource to set
     */
     void setDataSource(DataSource dataSource);

    /**
     * @param buscarUltimaValidacionQuery the buscarUltimaValidacionQuery to set
     */
     void setBuscarUltimaValidacionQuery(String buscarUltimaValidacionQuery);

    /**
     * @param insertValidacionCargaQuery the insertValidacionCargaQuery to set
     */
     void setInsertValidacionCargaQuery(String insertValidacionCargaQuery);


    /**
     * @param cargaContratosVolumenValidatorQuery the cargaContratosVolumenValidatorQuery to set
     */
     void setCargaContratosVolumenValidatorQuery(String cargaContratosVolumenValidatorQuery);


    /**
     * @param buscarDatosValidacionAnteriorQuery the buscarDatosValidacionAnteriorQuery to set
     */
     void setBuscarDatosValidacionAnteriorQuery(String buscarDatosValidacionAnteriorQuery);
}
