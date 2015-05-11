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
	 * Id de la valoraci�n del bien 
	 * @return Lista de datos registrales
	 */
	Long getId();
	
	/**
	 * El bien relacionado con esta valoraci�n
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
	 * Fecha valor apreciaci�n para el bien
	 */	
	Date getFechaValorApreciacion();

	/**
	 * Importe valor apreciaci�n para el bien
	 * @return
	 */
	Float getImporteValorApreciacion();
	
	/**
	 * Fecha valor tasaci�n para el bien
	 */	
	Date getFechaValorTasacion();

	/**
	 * Importe valor tasaci�n para el bien
	 * @return
	 */
	Float getImporteValorTasacion();	
	
	/**
	 * Auditoria
	 */
	Auditoria getAuditoria();
	
	/**
	 * C�digo nuita para el bien
	 */
	Integer getCodigoNuita();
}
