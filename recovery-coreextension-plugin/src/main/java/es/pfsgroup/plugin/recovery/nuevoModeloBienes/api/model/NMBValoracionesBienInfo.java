package es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model;

import java.math.BigDecimal;
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
	BigDecimal getImporteValorSubjetivo();

	/**
	 * Fecha valor apreciaci�n para el bien
	 */	
	Date getFechaValorApreciacion();

	/**
	 * Importe valor apreciaci�n para el bien
	 * @return
	 */
	BigDecimal getImporteValorApreciacion();
	
	/**
	 * Fecha valor tasaci�n para el bien
	 */	
	Date getFechaValorTasacion();

	/**
	 * Importe valor tasaci�n para el bien
	 * @return
	 */
	BigDecimal getImporteValorTasacion();	
	
	/**
	 * Auditoria
	 */
	Auditoria getAuditoria();
	
	/**
	 * C�digo nuita para el bien
	 */
	Long getCodigoNuita();
}
