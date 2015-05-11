package es.capgemini.pfs.batch.revisar.cargaVolumenContratos;

import java.math.BigDecimal;
import java.util.Date;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.batch.revisar.cargaVolumenContratos.dao.CargaVolumenContratosBatchDao;

/**
 * Clase manager para la entidad Carga Volumen Contratos.
 *
 * @author mtorrado
 *
 */
public class CargaVolumenContratosBatchManager {

	@Autowired
	private CargaVolumenContratosBatchDao cargaVolumenContratosDao;

	/**
	 * Estadísticas de la tabla temporal de contratos.
	 *
	 * @return Map con los siguientes objectos:
	 *         <ul>
	 *         <li>Long activoLineas</li>
	 *         <li>Double activoPosicionVencida</li>
	 *         <li>Long pasivoLineas</li>
	 *         <li>Double pasivoPosicionVencida</li>
	 *         <li>Double activoPosicionViva</li>
	 *         <li>Double pasivoPosicionViva</li>
	 *         </ul>
	 */
	public Map<String, Object> buscarVolumenContratos() {
		return cargaVolumenContratosDao.buscarVolumenContratos();
	}

	/**
	 * Estadísticas de una carga anterior de contratos.
	 *
	 * @param idRegistroValidacion
	 *            Long: ID de la registración anterior a buscar
	 * @return Map con los siguientes objectos:
	 *         <ul>
	 *         <li>Long activoLineas</li>
	 *         <li>Double activoPosicionVencida</li>
	 *         <li>Long pasivoLineas</li>
	 *         <li>Double pasivoPosicionVencida</li>
	 *         <li>Double activoPosicionViva</li>
	 *         <li>Double pasivoPosicionViva</li>
	 *         </ul>
	 */
	public Map<String, Object> buscarDatosValidacionAnterior(
			Long idRegistroValidacion) {
		return cargaVolumenContratosDao
				.buscarDatosValidacionAnterior(idRegistroValidacion);
	}

	/**
	 * Busca el último registro de carga de validación.
	 *
	 * @return Long: ID de la última carga de validación, <code>null</code> si
	 *         la tabla está vacía
	 */
	public Long buscarUltimaValidacion() {
		return cargaVolumenContratosDao.buscarUltimaValidacion();
	}

	/**
	 * Inserta en la tabla de validaciones de carga, los datos estadísticos de
	 * la carga a realizarse.
	 *
	 * @param fechaCarga fecha
	 * @param ficheroCarga fichero carga
	 * @param activoLineas activo Lineas
	 * @param activoPosicionVencida activoPosicionVencida
	 * @param activoPosicionViva activoPosicionViva
	 * @param pasivoLineas pasivoLineas
	 * @param pasivoPosicionVencida pasivoPosicionVencida
	 * @param pasivoPosicionViva pasivoPosicionViva
	 */
	public void insertValidacionCarga(Date fechaCarga, String ficheroCarga,
			BigDecimal activoLineas, BigDecimal activoPosicionVencida,
			BigDecimal activoPosicionViva, BigDecimal pasivoLineas,
			BigDecimal pasivoPosicionVencida, BigDecimal pasivoPosicionViva) {
		cargaVolumenContratosDao.insertValidacionCarga(fechaCarga,
				ficheroCarga, activoLineas, activoPosicionVencida,
				activoPosicionViva, pasivoLineas, pasivoPosicionVencida,
				pasivoPosicionViva);
	}

}
