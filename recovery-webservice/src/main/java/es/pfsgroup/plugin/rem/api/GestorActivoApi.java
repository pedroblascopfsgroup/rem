package es.pfsgroup.plugin.rem.api;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.framework.paradise.gestorEntidad.api.GestorEntidadApi;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;

public interface GestorActivoApi extends GestorEntidadApi {

	public static final String CODIGO_GESTOR_ACTIVO = "GACT";
	public static final String CODIGO_GESTOR_EDIFICACIONES = "GEDI";
	public static final String CODIGO_GESTOR_SUELOS = "GSUE";
	public static final String CODIGO_GESTOR_ALQUILER = "GALQ";
	public static final String CODIGO_GESTOR_ADMISION = "GADM";
	public static final String CODIGO_GESTORIA_ADMISION = "GGADM";
	public static final String CODIGO_GESTORIA_CEDULAS = "GTOCED";
	public static final String CODIGO_PROVEEDOR = "UPROV";
	public static final String CODIGO_SUPERVISOR_ADMISION = "SUPADM";
	public static final String CODIGO_SUPERVISOR_ACTIVOS = "SUPACT";
	public static final String CODIGO_GESTOR_PRECIOS = "GPREC";
	public static final String CODIGO_GESTOR_MARKETING = "GMARK";
	public static final String CODIGO_SUPERVISOR_PRECIOS = "SPREC";
	public static final String CODIGO_SUPERVISOR_MARKETING = "SMARK";
	public static final String CODIGO_GESTOR_COMERCIAL = "GCOM";
	public static final String CODIGO_GESTOR_COMERCIAL_RETAIL = "GCOMRET";
	public static final String CODIGO_GESTOR_COMERCIAL_SINGULAR = "GCOMSIN";
	public static final String CODIGO_SUPERVISOR_COMERCIAL = "SCOM";
	public static final String CODIGO_SUPERVISOR_COMERCIAL_RETAIL = "SCOMRET";
	public static final String CODIGO_SUPERVISOR_COMERCIAL_SINGULAR = "SCOMSIN";
	public static final String CODIGO_GESTOR_FORMALIZACION = "GFORM";
	public static final String CODIGO_GESTORIA_FORMALIZACION = "GIAFORM";
	public static final String CODIGO_SUPERVISOR_FORMALIZACION = "SFORM";
	public static final String CODIGO_GESTOR_BACKOFFICE = "GCBO";
	public static final String CODIGO_FVD_BKOFERTA = "FVDBACKOFR";
	public static final String CODIGO_FVD_BKVENTA = "FVDBACKVNT";
	public static final String CODIGO_FVD_NEGOCIO = "FVDNEG";
	public static final String CODIGO_SUPERVISOR_FVD = "SUPFVD";
	public static final String CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO = "HAYAGBOINM";
	public static final String CODIGO_GESTOR_COMERCIAL_BACKOFFICE_FINANCIERO = "HAYAGBOFIN";
	public static final String CODIGO_GESTOR_RESERVA_CAJAMAR = "GESRES";
	public static final String CODIGO_GESTOR_MINUTA_CAJAMAR = "GESMIN";
	public static final String CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO = "HAYASBOINM";
	public static final String CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_FINANCIERO = "HAYASBOFIN";
	public static final String CODIGO_SUPERVISOR_RESERVA_CAJAMAR = "SUPRES";
	public static final String CODIGO_SUPERVISOR_MINUTA_CAJAMAR = "SUPMIN";
	public static final String CIF_PROVEEDOR_BANKIA_SAREB_TINSA = "B86689494";
	public static final String CODIGO_TIPO_PROVEEDOR_TECNICO="PTEC";
	public static final String CODIGO_GESTOR_GOLDEN_TREE = "GTREE";
	public static final String CODIGO_GESTOR_COMITE_DIRECCION_LIBERBANK = "GCODI";
	public static final String CODIGO_GESTOR_SINGULAR_TERCIARIA_LIBERBANK = "GLIBSINTER";
	public static final String CODIGO_GESTOR_INVERSION_INMOBILIARIA_LIBERBANK = "GLIBINVINM";
	public static final String CODIGO_GESTOR_COMITE_INVERSION_INMOBILIARIA_LIBERBANK = "GCOIN";
	public static final String CODIGO_GESTOR_COMITE_INMOBILIARIO_LIBERBANK = "GCOINM";
	public static final String CODIGO_GESTOR_LIBERBANK_RESIDENCIAL = "GLIBRES";
	
	Boolean insertarGestorAdicionalActivo(GestorEntidadDto dto);

	Usuario getGestorByActivoYTipo(Activo activo, Long tipo);
	
	Usuario getGestorByActivoYTipo(Activo activo, String codigoTipo);
	
	Boolean isGestorActivo(Activo activo, Usuario usuario);
	
	Boolean isSupervisorActivo(Activo activo, Usuario usuario);
	
	Boolean esGestorEdificaciones(Activo activo, Usuario usuario);
	Boolean esGestorSuelos(Activo activo, Usuario usuario);
	Boolean esGestorAlquileres(Activo activo, Usuario usuario);

	
	Boolean isGestorAdmision(Activo activo, Usuario usuario);
	
	Boolean isGestorActivoOAdmision(Activo activo, Usuario usuario);
	
	Boolean isGestorActivoYTipo(Usuario usuario, Activo activo, String codigoGestor);
	
	Boolean isUsuarioGestorAdmision(Usuario usuario);
	
	Boolean isGestorPrecios(Activo activo, Usuario usuario);
	
	Boolean isGestorMarketing(Activo activo, Usuario usuario);
	
	Boolean isGestorPreciosOMarketing(Activo activo, Usuario usuario);

	/**
	 * Devuelve el usuario de una tarea a partir del código de la tarea (tipo) y el id del trámite.
	 * @param codigoTarea
	 * @param idTramite
	 * @return devuelve el Usuario si existe y null si no existe.
	 */
	public Usuario userFromTarea(String codigoTarea, Long idTramite);
	
	/**
	 * Actualiza las tareas del activo, asignando los gestores adecuados.
	 * @param idActivo
	 */
	public void actualizarTareas(Long idActivo);
	
	/**
	 * Comprueba si existe el gestor en el activo, a través del código TGE
	 * @param activo
	 * @param codGestor
	 * @return
	 */
	public Boolean existeGestorEnActivo(Activo activo, String codGestor);
	
	/**
	 * Comprueba si se pueden actualizar las tareas
	 * @param idActivo
	 * @return
	 */
	public Boolean validarTramitesNoMultiActivo(Long idActivo);
	
	/**
	 * Devuelve el gestor comercial, si existe en el activo, por el codigo pasado por
	 * parametro (GCOMRET, GCOMSIN), y si no es ninguno de esos dos, comprobará si tiene GCOM
	 * @param activo
	 * @param codGestor
	 * @return
	 */
	public Usuario getGestorComercialActual(Activo activo, String codGestor);
	
	
	/**
	 * Obtiene el proveedor técnico del activo dado
	 * @param idActivo
	 * @return
	 */
	public ActivoProveedor obtenerProveedorTecnico(Long idActivo);
}
