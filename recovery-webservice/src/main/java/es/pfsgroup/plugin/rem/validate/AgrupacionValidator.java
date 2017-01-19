package es.pfsgroup.plugin.rem.validate;

import es.pfsgroup.plugin.rem.genericService.api.GenericService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;

public interface AgrupacionValidator extends GenericService{

	public static final String DEFAULT_SERVICE_BEAN_KEY = "DEFAULT";

	public static final String ERROR_ACTIVE_DUPLICATED = "Este activo ya pertenece a ésta agrupación.";
	public static final String ERROR_ACTIVE_LIVE_OFFERS = "El activo tiene ofertas vivas";
	public static final String ERROR_NOT_SAME_TYPE = "Este activo no es del mismo tipo que el resto de la agrupación.";
	public static final String ERROR_ACTIVE_DUPLICATED_OTHER_GROUP = "Este activo ya pertenece a otra agrupación.";
	public static final String ERROR_CP_NULL = "El código postal está vacío y no se puede comparar con la agrupación.";
	public static final String ERROR_CP_NOT_EQUAL = "El código postal del activo y la agrupación no coinciden.";
	public static final String ERROR_PROV_NULL = "La provincia está vacía y no se puede comparar con la agrupación.";
	public static final String ERROR_PROV_NOT_EQUAL = "La provincia del activo y la agrupación no coinciden.";	
	public static final String ERROR_LOC_NULL = "La población está vacía y no se puede comparar con la agrupación.";
	public static final String ERROR_LOC_NOT_EQUAL = "La población del activo y la agrupación no coinciden.";	
	public static final String ERROR_PROPIETARIO_NULL = "El propietario de este activo está vacío y no se puede comparar con el de los activos de la agrupación.";
	public static final String ERROR_PROPIETARIO_NOT_EQUAL = "El propietario del activo y el propietario de los otros activos de la agrupación no coinciden.";
	public static final String ERROR_CARTERA_NULL = "La cartera está vacía y no se puede comparar con la agrupación.";
	public static final String ERROR_CARTERA_NOT_EQUAL = "La cartera del activo y la agrupación no coinciden.";	
	public static final String ERROR_TIPO_NULL = "El tipo (alquiler/venta) está vacío y no se puede comparar con la agrupación.";
	public static final String ERROR_TIPO_NOT_EQUAL = "El tipo (alquiler/venta) del activo y la agrupación no coinciden.";
	public static final String ERROR_NOT_ASISTIDA = "El activo no pertenece a la subcartera asistida.";
	public static final String ERROR_IS_PERIMETRO = "El activo no debe estar incluido en perímetro.";
	public static final String ERROR_NOT_FINANCIERO = "El activo no es financiero";
	public static final String ERROR_FINANCIERO_NULL = "La clase del activo bancario no está definida";
	public static final String ERROR_ACTIVO_VENDIDO = "El activo se encuentra en situación comercial vendido y no puede ser incluido";
	public static final String ERROR_OFERTA_ACTIVO_ACEPTADA = "El activo tiene al menos una oferta aprobada y no puede ser incluido";
	public static final String ERROR_OFERTA_AGRUPACION_ACTIVO_ACEPTADA = "La agrupación restringida a la que pertenece el activo tiene al menos una oferta aprobada y no puede ser incluido";


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