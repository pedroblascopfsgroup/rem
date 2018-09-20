package es.pfsgroup.framework.paradise.bulkUpload.bvfactory;

/**
 * Extensi�n de los validadores compuestos de negocio con soporte para el autowiring de Spring
 * @author pedro
 *
 */
public interface MSVBusinessCompositeValidatorsAutowiredSupport extends MSVBusinessCompositeValidators {

	/**
	 * C�digo de tipo de operaci�n para el que aplica este validador.
	 * @return
	 */
	String getCodigoTipoOperacion();

}
