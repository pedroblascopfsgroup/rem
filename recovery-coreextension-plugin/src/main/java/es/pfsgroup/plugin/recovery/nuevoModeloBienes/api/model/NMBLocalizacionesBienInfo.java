package es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;

/**
 * Datos a considerar de los domicilios
 * @author bruno
 *
 */
public interface NMBLocalizacionesBienInfo {
	
	/**
	 * C�digo postal del Bien
	 * @return
	 */
	Long getId();
	
	/**
	 * C�digo postal del Bien
	 * @return
	 */
	NMBBienInfo getBien();
	
	/**
	 * C�digo postal del Bien
	 * @return
	 */
	String getPoblacion();
	
	/**
	 * Localidad en la que est� ubidado el bien
	 * @return
	 */
	String getDireccion();
	
	/**
	 * Direcci�n en la que est� ubidado el bien
	 * @return
	 */
	String getCodPostal();

	DDProvincia getProvincia();
	
	Localidad getLocalidad();
	
	DDUnidadPoblacional getUnidadPoblacional();
	
	/**
	 * Auditoria
	 */
	Auditoria getAuditoria();
}
