package es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model;

import java.util.Date;

import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Datos registrales del Bien
 * @author bruno
 *
 */
public interface NMBValoracionesBienInfo {

	/**
	 * Id de la valoración del bien 
	 * @return Lista de datos registrales
	 */
	Long getId();
	
	/**
	 * El bien relacionado con esta valoración
	 * @return Lista de datos registrales
	 */
	NMBBienInfo getBien();
	
	/**
	 * Fecha valor subjetivo para el bien
	 */	
	Date getFechaValorSubjetivo();

	/**
	 * Importe valor subjetivo para el bien
	 * @return
	 */
	Float getImporteValorSubjetivo();

	/**
	 * Fecha valor apreciación para el bien
	 */	
	Date getFechaValorApreciacion();

	/**
	 * Importe valor apreciación para el bien
	 * @return
	 */
	Float getImporteValorApreciacion();
	
	/**
	 * Fecha valor tasación para el bien
	 */	
	Date getFechaValorTasacion();

	/**
	 * Importe valor tasación para el bien
	 * @return
	 */
	Float getImporteValorTasacion();	
	
	/**
	 * Auditoria
	 */
	Auditoria getAuditoria();
	
	/**
	 * Código nuita para el bien
	 */
	Integer getCodigoNuita();
}
