package es.pfsgroup.framework.paradise.bulkUpload.bvfactory;

/**
 * Extensión de los validadores de negocio con soporte para el autowiring de Spring
 * @author bruno
 *
 */
public interface MSVBusinessValidatorsAutowiredSupport extends MSVBusinessValidators {

	/**
	 * Código de tipo de operación para el que aplica este validador.
	 * @return
	 */
	String getCodigoTipoOperacion();

}
