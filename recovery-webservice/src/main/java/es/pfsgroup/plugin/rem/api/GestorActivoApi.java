package es.pfsgroup.plugin.rem.api;

import es.capgemini.pfs.gestorEntidad.model.GestorEntidad;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.framework.paradise.gestorEntidad.api.GestorEntidadApi;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDIdentificacionGestoria;

public interface GestorActivoApi extends GestorEntidadApi {

	public static final String CODIGO_GESTOR_ACTIVO = "GACT";
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
	public static final String CODIGO_TIPO_PROVEEDOR_TECNICO="PTEC";
	public static final String CODIGO_GESTOR_GOLDEN_TREE = "GTREE";
	public static final String CODIGO_GESTOR_COMITE_DIRECCION_LIBERBANK = "GCODI";
	public static final String CODIGO_GESTOR_SINGULAR_TERCIARIA_LIBERBANK = "GLIBSINTER";
	public static final String CODIGO_GESTOR_INVERSION_INMOBILIARIA_LIBERBANK = "GLIBINVINM";
	public static final String CODIGO_GESTOR_COMITE_INVERSION_INMOBILIARIA_LIBERBANK = "GCOIN";
	public static final String CODIGO_GESTOR_COMITE_INMOBILIARIO_LIBERBANK = "GCOINM";
	public static final String CODIGO_GESTOR_LIBERBANK_RESIDENCIAL = "GLIBRES";
	public static final String CODIGO_GESTOR_CAPA_CONTROL_LIBERBANK = "GCCLBK";
	public static final String CODIGO_GESTOR_COMERCIAL_ALQUILERES = "GESTCOMALQ";
	public static final String CODIGO_SUPERVISOR_COMERCIAL_ALQUILERES = "SUPCOMALQ";
	public static final String CODIGO_SUPERVISOR_COMERCIAL_BACKOFFICE_INMOBILIARIO_LIBERBANK= "SBACKOFFICEINMLIBER";
	public static final String CODIGO_SUPERVISOR_ALQUILERES = "SUALQ";
	public static final String CODIGO_GESTOR_ALQUILERES = "GALQ";
	public static final String CODIGO_GESTOR_SUELOS = "GSUE";
	public static final String CODIGO_SUPERVISOR_SUELOS = "SUPSUE";
	public static final String CODIGO_GESTOR_EDIFICACIONES = "GEDI";
	public static final String CODIGO_SUPERVISOR_EDIFICACIONES = "SUPEDI";
	public static final String CODIGO_GESTOR_LLAVES = "GLLA";
	public static final String CODIGO_GESTOR_HPM = "GALQ";
	public static final String CODIGO_GESTOR_PUBLICACION= "GPUBL";
	public static final String CODIGO_SUPERVISOR_PUBLICACION = "SPUBL";
	public static final String CODIGO_GESTOR_DE_ADMINISTRACION = "GADMT";
	public static final String CODIGO_GESTOR_FORMALIZACION_ADMINISTRACION = "GFORMADM";
	public static final String CODIGO_GESTOR_PORTFOLIO_MANAGER = "GPM";
	public static final String USU_PROVEEDOR_BANKIA_SAREB_TINSA = "proveedor.tinsa";
	public static final String USU_PROVEEDOR_HOMESERVE = "proveedor.homeserve";
	public static final String USU_PROVEEDOR_AESCTECTONICA = "proveedor.aesctectonica";
	public static final String USU_CEE_BANKIA_POR_DEFECTO = "proveedor.cee.bankia";
	public static final String USU_CEDULA_HABITABILIDAD_SAREB_POR_DEFECTO = "proveedor.cedula.habitabilidad.sareb";
	public static final String USUARIO_FICTICIO_OFERTA_CAJAMAR = "usuario.ficticio.oferta.cajamar";
	public static final String BUZON_REM = "buzon.rem";
	public static final String BUZON_PFS = "buzon.pfs";
	public static final String USU_PROVEEDOR_ELECNOR = "proveedor.elecnor";
	public static final String CODIGO_GESTORIA_ADMINISTRACION = "GIAADMT";
	public static final String USU_PROVEEDOR_PACI = "proveedor.paci";
	public static final String CODIGO_GESTORIA_PLUSVALIA = "GTOPLUS";
	public static final String CODIGO_GESTOR_CONTROLLER = "GCONT";
	public static final String CODIGO_GESTOR_CIERRE_VENTA = "GCV";
	public static final String CODIGO_GESTOR_BOARDING = "GBOAR";
	
	Boolean insertarGestorAdicionalActivo(GestorEntidadDto dto);

	Usuario getGestorByActivoYTipo(Activo activo, Long tipo);
	
	GestorEntidad getGestorEntidadByActivoYTipo(Activo activo, String codigoTipo);
	
	Usuario getDirectorEquipoByGestor(Usuario gestor);
	
	Usuario getGestorByActivoYTipo(Activo activo, String codigoTipo);
	
	Boolean isGestorActivo(Activo activo, Usuario usuario);
	
	Boolean isSupervisorActivo(Activo activo, Usuario usuario);
	

	Boolean isGestorAlquileres(Activo activo, Usuario usuario);

	
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
	
	public Boolean isGestorSuelos(Activo activo, Usuario usuario);

	public Boolean isGestorEdificaciones(Activo activo, Usuario usuario);

	public void borrarGestorAdicionalEntidad(GestorEntidadDto dto);

	Usuario getUsuarioByTareaCaixa(String codTarea);

	/**
	 * Obtiene el usuario de grupo que realiza ciertas tareas del trámite comercial Apple
	 * @param codigoTarea
	 * @return
	 */
	public Usuario usuarioGrupoTareaT017(String codigoTarea, Boolean esApple, Boolean esArrow, Boolean esRemaining, Boolean isActivoJaguar, TareaExterna tareaExterna);
	
	public Usuario supervisorTareaApple(String codigoTarea);

	/**
	 * Mediante el usario logado obtenemos la gestoría a la que pertenece
	 * @param usuario
	 * @return
	 */
	public DDIdentificacionGestoria isGestoria(Usuario usuario);

	public Usuario usuarioTareaDivarian(String codigoTarea);

	Usuario supervisorTareaDivarian(String codigoTarea);

	Boolean isGestorMantenimiento(Activo activo, Usuario usuario);

}
