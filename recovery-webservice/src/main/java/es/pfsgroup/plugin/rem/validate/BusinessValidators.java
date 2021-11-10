package es.pfsgroup.plugin.rem.validate;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;

/**
 * Esta interfaz representa un conjunto de validadores para una determinada
 * operaci�n. Estas validaciones se obtienen usando la factor�a
 * {@link MSVBusinessValidationFactory}
 * 
 * @author CarlosPons
 * 
 */
public interface BusinessValidators {

	public static final String ERROR_ACTIVE_DUPLICATED = "Este activo ya pertenece a esta agrupación.";
	public static final String ERROR_NOT_SAME_TYPE = "Este activo no es del mismo tipo que el resto de la agrupación.";
	public static final String ERROR_ACTIVE_DUPLICATED_OTHER_GROUP = "Este activo ya pertenece a otra agrupación.";
	public static final String ERROR_CP_NULL = "El código postal esta vacio y no se puede comparar con la agrupación.";
	public static final String ERROR_CP_NOT_EQUAL = "El código postal del activo y la agrupación no coinciden.";
	public static final String ERROR_PROV_NULL = "La provincia esta vacia y no se puede comparar con la agrupación.";
	public static final String ERROR_PROV_NOT_EQUAL = "La provincia del activo y la agrupación no coinciden.";	
	public static final String ERROR_LOC_NULL = "La población esta vacia y no se puede comparar con la agrupación.";
	public static final String ERROR_LOC_NOT_EQUAL = "La población del activo y la agrupación no coinciden.";	
	public static final String ERROR_PROPIETARIO_NULL = "El propietario de este activo está vacío y no se puede comparar con el de los activos de la agrupación.";
	public static final String ERROR_PROPIETARIO_NOT_EQUAL = "El propietario del activo y el propietario de los otros activos de la agrupación no coinciden.";
	public static final String ERROR_CARTERA_NULL = "La cartera esta vacia y no se puede comparar con la agrupación.";
	public static final String ERROR_CARTERA_NOT_EQUAL = "La cartera del activo y la agrupación no coinciden.";	
	public static final String ERROR_TIPO_NULL = "El tipo (alquiler/venta) esta vacio y no se puede comparar con la agrupación.";
	public static final String ERROR_TIPO_NOT_EQUAL = "El tipo (alquiler/venta) del activo y la agrupación no coinciden.";
	public static final String ERROR_ESTADO_PUBLICACION_NOT_EQUAL = "El activo tiene un estado de publicación distinto al de la agrupación.";
	public static final String ERROR_DESTINO_COMERCIAL_NOT_EQUAL = "El activo no tiene el mismo destino comercial que la agrupación";
	public static final String ERROR_ACTIVO_CARTERA_BANKIA_TO_AGR_RESTRINGIDAS = "El activo pertenece a Caixa";
	
	/**
	 * C�digo de tipo de operaci�n para el que aplica este validador.
	 * @return
	 */
	public String getCodigoTipoOperacion();
	
	/**
	 * 
	 * @param codigoTipoAgrupacion
	 * @return true o false en función del tipo de agrupación
	 */
	public Boolean usarValidator(String codigoTipoAgrupacion); 
	
	/**
	 * Devuelve resultado validacion
	 * 
	 */
	public String getValidationError (Activo activo, ActivoAgrupacion agrupacion);

}
