package es.capgemini.pfs.batch.revisar.cargaVolumenContratos.dao;

import java.math.BigDecimal;
import java.util.Date;
import java.util.Map;

import javax.sql.DataSource;


/**
 * Carga la informaci�n sobre la carga anterior de contratos a producci�n en la tabla
 * de validaciones de carga de contratos (ver BATCH-83).
 * @author Mariano Ruiz
 *
 */
public interface CargaVolumenContratosBatchDao {

	/**
     * Estad�sticas de la tabla temporal de contratos.
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
     * Estad�sticas de una carga anterior de contratos.
     * @param idRegistroValidacion Long: ID de la registraci�n anterior a buscar
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
     * Busca el �ltimo registro de carga de validaci�n.
     * @return Long: ID de la �ltima carga de validaci�n, <code>null</code> si la tabla est� vac�a
     */
    Long buscarUltimaValidacion();

    // Inserci�n el la BBDD

    /**
     * Inserta en la tabla de validaciones de carga, los datos estad�sticos de la carga a realizarse.
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
