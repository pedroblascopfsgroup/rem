package es.pfsgroup.framework.paradise.bulkUpload.bvfactory;

/**
 * Extensi�n de los validadores de negocio con soporte para el autowiring de Spring
 * @author bruno
 *
 */
public interface MSVBusinessValidatorsAutowiredSupport extends MSVBusinessValidators {

	/**
	 * C�digo de tipo de operaci�n para el que aplica este validador.
	 * @return
	 */
	String getCodigoTipoOperacion();

}
