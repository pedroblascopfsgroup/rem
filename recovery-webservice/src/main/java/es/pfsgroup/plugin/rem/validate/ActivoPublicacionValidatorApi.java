package es.pfsgroup.plugin.rem.validate;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.validate.validator.ActivoPublicacionValidator;

public interface ActivoPublicacionValidatorApi{

	/**
	 * Devuelve una instancia de esta clase para utilizarla como validador,
	 * en la que se aplican todas las validaciones para publicar.
	 * @param activo
	 * @return
	 */
	public ActivoPublicacionValidator initPublicacionValidator(Activo activo);
	
	/**
	 * Devuelve una instancia de esta clase para utilizarla como validador,
	 * para validar con las validaciones indicadas.
	 * @param activo
	 * @param validarOKGestion
	 * @param validarOKAdmision
	 * @param validarOKPrecio
	 * @param validarInfComercialTiposIguales
	 * @param validarInfComercialAceptado
	 * @return
	 */
	public ActivoPublicacionValidator initPublicacionValidator(Activo activo, 
			boolean validarOKGestion,
			boolean validarOKAdmision,
			boolean validarOKPrecio,
			boolean validarInfComercialTiposIguales,
			boolean validarInfComercialAceptado);
	
	/**
	 * Indica si se cumplen o no las validaciones para publicar.
	 * Realiza las validaciones que se indicaron al instanciar con initPublicacionValidator
	 * Realiza las validaciones para el activo que se indico al instanciar con initPublicacionValidator
	 * @return
	 */
	public boolean cumpleValidaciones();


}