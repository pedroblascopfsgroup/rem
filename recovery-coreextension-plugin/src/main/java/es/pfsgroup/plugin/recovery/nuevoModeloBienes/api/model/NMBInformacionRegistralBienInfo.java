package es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model;

import java.math.BigDecimal;
import java.util.Date;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.Localidad;

/**
 * Datos registrales del Bien
 * @author bruno
 *
 */
public interface NMBInformacionRegistralBienInfo {

	/**
	 * Lista de datos registrales del Bien 
	 * @return Lista de datos registrales
	 */
	NMBBienInfo getBien();
	
	
	/**
	 * Referencia catastral del bien
	 */	
	String getReferenciaCatastralBien();

	/**
	 * Superficie completa
	 * @return
	 */
	BigDecimal getSuperficie();

	/**
	 * Superficie construida
	 * @return
	 */
	BigDecimal getSuperficieConstruida();
	
	/**
	 * Tomo
	 * @return
	 */
	String getTomo();

	/**
	 * Libro
	 * @return
	 */
	String getLibro();
	
	/**
	 * Folio
	 */
	String getFolio();
	
	/**
	 * Inscripci�n
	 */
	String getInscripcion();
	
	/**
	 * Fecha de expedici�n
	 */
	Date getFechaInscripcion();
	
	/**
	 * Inscripci�n
	 */
	String getNumRegistro();
	
	/**
	 * Inscripci�n
	 */
	String getMunicipoLibro();
	
	/**
	 * Inscripci�n
	 */
	String getCodigoRegistro();	
	
	/**
	 * N�mero de la finca
	 * @return
	 */
	String getNumFinca();
	
	/**
	 * Auditoria
	 */
	Auditoria getAuditoria();	
	
	/**
	 * Localidad
	 */
	Localidad getLocalidad();	
	
}
