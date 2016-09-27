package es.pfsgroup.plugin.rem.validate;

import es.pfsgroup.plugin.rem.genericService.api.GenericService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;

public interface AgrupacionValidator extends GenericService{
	
	public static final String DEFAULT_SERVICE_BEAN_KEY = "DEFAULT";
	
	public static final String ERROR_ACTIVE_DUPLICATED = "Este activo ya pertenece a esta agrupación.";
	public static final String ERROR_ACTIVE_LIVE_OFFERS = "El activo tiene ofertas vivas";
	public static final String ERROR_NOT_SAME_TYPE = "Este activo no es del mismo tipo que el resto de la agrupación.";
	public static final String ERROR_ACTIVE_DUPLICATED_OTHER_GROUP = "Este activo ya pertenece a otra agrupación.";
	public static final String ERROR_CP_NULL = "El código postal esta vacio y no se puede comparar con la agrupación.";
	public static final String ERROR_CP_NOT_EQUAL = "El código postal del activo y la agrupación no coinciden.";
	public static final String ERROR_PROV_NULL = "La provincia esta vacia y no se puede comparar con la agrupación.";
	public static final String ERROR_PROV_NOT_EQUAL = "La provincia del activo y la agrupación no coinciden.";	
	public static final String ERROR_LOC_NULL = "La población esta vacia y no se puede comparar con la agrupación.";
	public static final String ERROR_LOC_NOT_EQUAL = "La población del activo y la agrupación no coinciden.";	
	public static final String ERROR_PROPIETARIO_NULL = "El propietario de este activo esta vacio y no se puede comparar con el de los activos de la agrupación.";
	public static final String ERROR_PROPIETARIO_NOT_EQUAL = "El propietario del activo y el propietario de los otros activos de la agrupación no coinciden.";
	public static final String ERROR_CARTERA_NULL = "La cartera esta vacia y no se puede comparar con la agrupación.";
	public static final String ERROR_CARTERA_NOT_EQUAL = "La cartera del activo y la agrupación no coinciden.";	
	public static final String ERROR_TIPO_NULL = "El tipo (alquiler/venta) esta vacio y no se puede comparar con la agrupación.";
	public static final String ERROR_TIPO_NOT_EQUAL = "El tipo (alquiler/venta) del activo y la agrupación no coinciden.";
	public static final String ERROR_NOT_ASISTIDA = "El activo no es asistido.";
	
	
	/**
	 * C�digo de tipo de operaci�n para el que aplica este validador.
	 * @return
	 */
	public String[] getCodigoTipoAgrupacion();
	
	/**
	 * Devuelve resultado validacion
	 * 
	 */
	public String getValidationError (Activo activo, ActivoAgrupacion agrupacion);


}
