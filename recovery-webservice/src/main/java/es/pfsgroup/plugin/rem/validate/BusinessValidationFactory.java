package es.pfsgroup.plugin.rem.validate;

import java.util.List;

import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

/**
 * Esta interfaz representa una factor�a que devuelve validadores de negocio para una determinada operaci�n masiva.
 * 
 * @author bruno
 *
 */
public interface BusinessValidationFactory {

	/**
	 * Devuelve los validadores para un tipo de operaci�n. 
	 * @param tipoOperacion
	 * @return Si no existen validadores definidos devolverá lista vacia
	 */
	List<BusinessValidators> getValidators(DDTipoAgrupacion tipoAgrupacion);

}
