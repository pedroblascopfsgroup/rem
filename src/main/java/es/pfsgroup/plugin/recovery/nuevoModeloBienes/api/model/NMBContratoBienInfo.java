package es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model;

import java.util.Date;

import es.capgemini.pfs.contrato.model.Contrato;

/**
 * Datos a considerar sobre el Bien
 * @author bruno
 *
 */
public interface NMBContratoBienInfo {
	
	/**
	 * Devuelve el identificador de la relación bien-contrato
	 */
	Long getId();
	
	/**
	 * Bien asociado a la relación bien-contrato
	 */
	NMBBienInfo getBien();
	
	/**
	 * Contrato asociado a la relación bien-contrato
	 */
	Contrato getContrato();	
	
	/**
	 * Tipo de relación entre el bien y el contrato 
	 */
	NMBDDTipoBienContratoInfo getTipo();
	
	/**
	 * Estado en que se encuentra la relación bien-contrato 
	 */
	NMBDDEstadoBienContratoInfo getEstado();
	
	/**
	 * El importe que queda garantizado gracias a este contrato
	 */
	Float getImporteGarantizado();	
	
	/**
	 * Fecha incio de la relación
	 */
	Date getFechaInicio();	
	
	/**
	 * Fecha en la que concluye la relación entre el bien y el contrato
	 */
	Date getFechaCierre();	

}
