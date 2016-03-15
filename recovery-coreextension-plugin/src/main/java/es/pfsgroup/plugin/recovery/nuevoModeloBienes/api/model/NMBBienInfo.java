package es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model;

import java.math.BigDecimal;
import java.util.List;

import es.capgemini.pfs.bien.model.DDTipoBien;
import es.capgemini.pfs.embargoProcedimiento.model.EmbargoProcedimiento;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBEmbargoProcedimiento;

/**
 * Datos a considerar sobre el Bien
 * @author bruno
 *
 */
public interface NMBBienInfo {
	
	/**
	 * Devuelve el identificador del bien
	 * @return
	 */
	Long getId();

	/**
	 * Devuelve el identificador del bien
	 * @return
	 */
	Integer getMarcaExternos();
	
	/**
	 * Lista de datos registrales del Bien 
	 */
	List<? extends NMBInformacionRegistralBienInfo> getInformacionRegistral();

	/**
	 * Datos registrales del Bien que se encuentran activos 
	 */
	NMBInformacionRegistralBienInfo getDatosRegistralesActivo();
	
	/**
	 * Lista de las valoraciones para el Bien 
	 */
	List<? extends NMBValoracionesBienInfo> getValoraciones();
	
	/**
	 * �ltima valoraci�n del bien
	 */
	NMBValoracionesBienInfo getValoracionActiva();
	
	/**
	 * Lista de ubicaciones del bien
	 */
	List<? extends NMBLocalizacionesBienInfo> getLocalizaciones();	

	/**
	 * Lista de ubicaciones del bien
	 */
	List<? extends NMBContratoBienInfo> getContratos();
	
	/**
	 * Lista de ubicaciones del bien
	 */
	NMBLocalizacionesBienInfo getLocalizacionActual();	
	
	/**
	 * Devuelve el tipo de bien registrado
	 */
	DDTipoBien getTipoBien();	
	
	/**
	 * Devuelve el origen de donde viene la fila
	 */
	NMBDDOrigenBienInfo getOrigen();	
	
	/**
	 * La descripci�n del bien
	 */
	String getDescripcion();	
	
	/**
	 * Devuelve el tipo de carga que tiene registrada
	 */
	NMBDDTipoCargaBienInfo getTipoCarga();
	
	/**
	 * Devuelve el importe de las cargas registradas
	 */
	BigDecimal getImporteCargas();
	
	/**
	 * Devuelve el c�digo interno del bien
	 */
	String getCodigoInterno();

	/**
	 * Devuelve el c�digo interno del bien
	 */
	EmbargoProcedimiento getEmbargoProcedimiento();
	
	/**
	 * Devuelve la lista de buienes embargados según el nuevo modelo de bienes
	 */
	List<NMBEmbargoProcedimiento> getNMBEmbargosProcedimiento();
	
	/**
	 * Devuelve el c�digo interno del bien
	 */
	List<? extends NMBSubastaInstruccionesInfo> getInstruccionesSubasta();
	
}
