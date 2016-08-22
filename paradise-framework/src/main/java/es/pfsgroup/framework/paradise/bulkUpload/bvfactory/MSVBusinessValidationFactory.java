package es.pfsgroup.framework.paradise.bulkUpload.bvfactory;

import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;

/**
 * Esta interfaz representa una factor�a que devuelve validadores de negocio para una determinada operaci�n masiva.
 * 
 * @author bruno
 *
 */
public interface MSVBusinessValidationFactory {

	/**
	 * Devuelve los validadores para un tipo de operaci�n. 
	 * @param tipoOperacion
	 * @return Si no existen validadores definidos puede devolver NULL
	 */
	MSVBusinessValidators getValidators(MSVDDOperacionMasiva tipoOperacion);

	/**
	 * Devuelve los validadores compuestos para un tipo de operaci�n. 
	 * @param tipoOperacion
	 * @return Si no existen validadores compuestos definidos puede devolver NULL
	 */
	MSVBusinessCompositeValidators getCompositeValidators(MSVDDOperacionMasiva tipoOperacion);

}
