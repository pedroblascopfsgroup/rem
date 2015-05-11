package es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model;

import java.util.Date;

import es.capgemini.pfs.auditoria.model.Auditoria;

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
	Float getSuperficie();

	/**
	 * Superficie construida
	 * @return
	 */
	Float getSuperficieConstruida();
	
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
	 * Inscripción
	 */
	String getInscripcion();
	
	/**
	 * Fecha de expedición
	 */
	Date getFechaInscripcion();
	
	/**
	 * Inscripción
	 */
	String getNumRegistro();
	
	/**
	 * Inscripción
	 */
	String getMunicipoLibro();
	
	/**
	 * Inscripción
	 */
	String getCodigoRegistro();	
	
	/**
	 * Número de la finca
	 * @return
	 */
	String getNumFinca();
	
	/**
	 * Auditoria
	 */
	Auditoria getAuditoria();	
	
}
