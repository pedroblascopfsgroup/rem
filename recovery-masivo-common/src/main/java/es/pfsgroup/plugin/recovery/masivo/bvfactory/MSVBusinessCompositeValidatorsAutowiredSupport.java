package es.pfsgroup.plugin.recovery.masivo.bvfactory;

/**
 * Extensión de los validadores compuestos de negocio con soporte para el autowiring de Spring
 * @author pedro
 *
 */
public interface MSVBusinessCompositeValidatorsAutowiredSupport extends MSVBusinessCompositeValidators {

	/**
	 * Código de tipo de operación para el que aplica este validador.
	 * @return
	 */
	String getCodigoTipoOperacion();

}
