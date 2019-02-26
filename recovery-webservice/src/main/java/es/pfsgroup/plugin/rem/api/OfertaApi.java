package es.pfsgroup.plugin.rem.api;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoClienteComercial;
import es.pfsgroup.plugin.rem.model.DtoDetalleOferta;
import es.pfsgroup.plugin.rem.model.DtoGastoExpediente;
import es.pfsgroup.plugin.rem.model.DtoHonorariosOferta;
import es.pfsgroup.plugin.rem.model.DtoOfertantesOferta;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;
import net.sf.json.JSONObject;

public interface OfertaApi {
	
	public static String ORIGEN_REM ="REM";
	public static String ORIGEN_WEBCOM ="WCOM";

	/**
	 * Devuelve una Oferta por id.
	 * 
	 * @param id
	 *            de la Oferta a consultar
	 * @return Oferta
	 */
	public Oferta getOfertaById(Long id);

	/**
	 * Devuelve una Oferta por idOfertaWebcom.
	 * 
	 * @param idOfertaWebcom
	 *            a consultar
	 * @return Oferta
	 */
	public Oferta getOfertaByIdOfertaWebcom(Long idOfertaWebcom) throws Exception;

	/**
	 * Devuelve una Oferta por numOfertaRem
	 * 
	 * @param numOfertaRem
	 *            a consultar
	 * @return Oferta
	 */
	public Oferta getOfertaByNumOfertaRem(Long numOfertaRem);

	/**
	 * Devuelve una Oferta por idOfertaWebcom y numOfertaRem.
	 * 
	 * @param idOfertaWebcom
	 *            a consultar
	 * @param numOfertaRem
	 *            a consultar
	 * @return Oferta
	 */
	public Oferta getOfertaByIdOfertaWebcomNumOfertaRem(Long idOfertaWebcom, Long numOfertaRem) throws Exception;

	/**
	 * Devuelve un Page de Ofertas aplicando el filtro que recibe.
	 * 
	 * @param dtoOfertasFilter
	 *            con los parametros de filtro
	 * @return Page<Oferta>
	 */
	public DtoPage getListOfertas(DtoOfertasFilter dtoOfertasFilter);
	
	/**
	 * Devuelve un Page de Ofertas aplicando el filtro que recibe teniendo en cuenta si se filtra por usuario gestor o gestoria determinado, o ambos, 
	 * o en caso de no recibirlo, teniendo en cuenta el usuario logado.
	 * @param dtoOfertasFilter
	 * @return
	 */
	public DtoPage getListOfertasUsuario(DtoOfertasFilter dtoOfertasFilter);


	/**
	 * Devuelve una lista de Ofertas aplicando el filtro que recibe.
	 * 
	 * @param dtoOfertasFilter con los parametros de filtro
	 * @return List<Oferta>
	 */
	public List<VOfertasActivosAgrupacion> getListOfertasFromView(DtoOfertasFilter dtoOfertasFilter);
	
	/**
	 * Devuelve una lista de Ofertas aplicando el filtro que recibe.
	 * 
	 * @param ofertaDto
	 *            con los parametros de filtro
	 * @return List<Oferta>
	 */
	public List<Oferta> getListaOfertas(OfertaDto ofertaDto);

	/**
	 * Devuelve una lista de errores encontrados en los parámetros de entrada de
	 * las peticiones POST.
	 * 
	 * @param OfertaDto
	 *            con los parametros de entrada
	 * @param jsonFields
	 *            estructura de parámetros para validar campos en caso de venir
	 *            informados
	 * @param alta
	 *            true si es para validar el alta, false para validar la
	 *            actualización
	 * @return List<String>
	 */
	public HashMap<String, String> validateOfertaPostRequestData(OfertaDto ofertaDto, Object jsonFields,
			Boolean alta) throws Exception;

	/**
	 * Crea una nueva Oferta a partir de la información pasada por parámetro.
	 * 
	 * @param ofertaDto
	 *            con la información de la Oferta a dar de alta
	 * @return List<String> con la lista de errores detectados
	 */
	public HashMap<String,String> saveOferta(OfertaDto ofertaDto) throws Exception;

	/**
	 * Actualiza una Oferta a partir de la información pasada por parámetro.
	 * 
	 * @param ofertaDto
	 *            con la información de la Oferta a actualizar
	 * @param jsonFields
	 *            estructura con los parámetros a actualizar. Si no vienen, no
	 *            hay que actualizar. Si vienen y están a null, hay que seterlos
	 *            a null
	 * @return List<String> con la lista de errores detectados
	 */
	public HashMap<String,String> updateOferta(Oferta oferta, OfertaDto ofertaDto, Object jsonFields)
			throws Exception;
	
	/**
	 * Actualiza una lista de ofertas a partir de la información pasada por parámetro.
	 * 
	 * @param listaOfertaDto
	 * @param jsonFields
	 * @param listaRespuesta
	 * @return
	 * @throws Exception
	 */
	public void saveOrUpdateOfertas(List<OfertaDto> listaOfertaDto,JSONObject jsonFields, ArrayList<Map<String, Object>> listaRespuesta)throws Exception;

	/**
	 * Actualizar el estado de disponibilidad comercial en los activos
	 * 
	 * @param oferta
	 */
	public void updateStateDispComercialActivosByOferta(Oferta oferta);
	
	
	/**
	 * Método que obtiene uno de los estados posibles de la oferta relacionado
	 * con una determinado código
	 * 
	 * @param codigo
	 * @return
	 */
	public DDEstadoOferta getDDEstadosOfertaByCodigo(String codigo);

	/**
	 * Método que rechaza una oferta
	 * @param oferta
	 * @return Boolean true si ha podido rechazar la oferta false en caso contrario
	 */
	public Boolean rechazarOferta(Oferta oferta);
	
	/**
	 * Método que congela una oferta y oculta las tareas pendientes
	 * @param oferta
	 * @return Boolean true si ha podido congelar la oferta false en caso contrario
	 */
	public Boolean congelarOferta(Oferta oferta);
	
	
	/**
	 * Congela las ofertas Pendientes asociadas a 
	 * un activo cuyo expediente comercial se ha aprobado.
	 * @param oferta
	 * @return Boolean true si ha podido congelar la oferta false en caso contrario
	 */
	public void congelarOfertasPendientes(ExpedienteComercial expediente) throws Exception;

	
	/**
	 * Descongela las ofertas suceptibles de descongelar asociadas a 
	 * un activo cuyo expediente comercial se ha anulado/denegado.
	 * @param expediente: expediente cuyo activo tiene ofertas a descongelar.
	 */
	public void descongelarOfertas(ExpedienteComercial expediente) throws Exception;

	
	/**
	 * Método que saca la oferta a partir de una tarea externa
	 * 
	 * @param tareaExterna
	 * @return Oferta
	 */
	public Oferta tareaExternaToOferta(TareaExterna tareaExterna);

	
	/**
	 * Método que saca la oferta aceptada a partir de un trabajo
	 * @param trabajo
	 * @return
	 */
	public Oferta trabajoToOferta(Trabajo trabajo);
	
	
	/**
	 * Método que saca las ofertas de un activo a partir de su trabajo
	 * @param trabajo
	 * @return
	 */
	public List<Oferta> trabajoToOfertas(Trabajo trabajo);
	
	/**
	 * Método que obtiene la oferta aceptada de un activo en caso de haberla.
	 * 
	 * @param activo
	 * @return Oferta
	 */
	public Oferta getOfertaAceptadaByActivo(Activo activo);

	/**
	 * Método que obtiene la oferta aceptada de un activo que ha sido aprobado.
	 * @param activo
	 */
	public Oferta getOfertaAceptadaExpdteAprobado(Activo activo);

	/**
	 * Método que comprueba si un activo tiene reserva.
	 * 
	 * @param tareaExterna
	 * @return true si tiene reserva, false si no la tiene.
	 */
	public boolean checkReserva(TareaExterna tareaExterna);
	
	/**
	 * Es express??
	 * 
	 * @param tareaExterna
	 * @return
	 */
	public boolean checkEsExpress(TareaExterna tareaExterna);
	
	/**
	 * Método que comprueba si un activo tiene reserva.
	 * 
	 * @param tareaExterna
	 * @return true si tiene reserva, false si no la tiene.
	 */
	public boolean checkReserva(Oferta oferta);
	
	/**
	 * Método que comprueba si el activo tiene derecho de tanteo por la Generalitat
	 * @param trabajo
	 * @return true si tiene derecho de tanteo, false si no lo tiene
	 */
	public boolean checkDerechoTanteo(Trabajo trabajo);
	
	/**
	 * Método que comprueba si el activo tiene derecho de tanteo por la Generalitat
	 * 
	 * @param tareaExterna
	 * @return true si tiene derecho de tanteo, false si lo tiene
	 */
	public boolean checkDerechoTanteo(TareaExterna tareaExterna);

	/**
	 * Método que comprueba si la oferta viene de una oferta de tanteo de la
	 * Generalitat
	 * 
	 * @param tareaExterna
	 * @return true si viene, false si es nueva
	 */
	public boolean checkDeDerechoTanteo(TareaExterna tareaExterna);

	
	/**
	 * Método que comprueba que la oferta no tenga riesgo reputacional
	 * @param tareaExterna
	 * @return si no tiene riesgo devuelve true, si tiene false
	 */
	public boolean checkRiesgoReputacional(TareaExterna tareaExterna);
	
	/**
	 * Método que comprueba si la oferta tiene importe
	 * @param tareaExterna
	 * @return si tiene importe devuelve true, en caso contrario devuelve false
	 */
	public boolean checkImporte(TareaExterna tareaExterna);
	
	/**
	 * Método que comprueba si la oferta tiene compradores
	 * @param tareaExterna
	 * @return si tiene compradores devuelve true, en caso contrario devuelve false
	 */
	public boolean checkCompradores(TareaExterna tareaExterna);
	
	/**
	 * Método que comprueba que la oferta no tenga conflicto de intereses
	 * @param tareaExterna
	 * @return si tiene conflicto de intereses devuelve true, en caso contrario devuelve false
	 */
	public boolean checkConflictoIntereses(TareaExterna tareaExterna);	
	
	/**
	 * Metodo que comprueba si la oferta tiene relleno el comite sancionador
	 * @param tareaExterna
	 * @return
	 */
	public boolean checkComiteSancionador(TareaExterna tareaExterna);
	

	/**
	 * Metodo que comprueba si la oferta tiene el comite sancionador alquiler HAYA
	 * @param tareaExterna
	 * @return
	 */
	public boolean checkComiteSancionadorAlquilerHaya(TareaExterna tareaExterna);

	/**
	 * Método que comprueba si el activo tiene atribuciones para sancionar el
	 * expediente
	 * 
	 * @param tareaExterna
	 * @return true si tiene atribuciones, false si no las tiene
	 */
	public boolean checkAtribuciones(TareaExterna tareaExterna);

	/**
	 * Método que comprueba si el activo tiene atribuciones para sancionar el
	 * expediente
	 * 
	 * @param trabajo
	 * @return true si tiene atribuciones, false si no las tiene
	 */
	public boolean checkAtribuciones(Trabajo trabajo);

	/**
	 * Método que da de alta el comité externo en Bankia
	 * @param tareaExterna
	 * @return
	 */
	public boolean altaComite(TareaExterna tareaExterna);
	
	/**
	 * Método que comprueba si existe conflicto de intereses y/o riesgo computacional
	 * @param tareaExterna
	 * @return true si el valor es NO en ambos combos, false en caso de que no estén rellenos o alguno tenga SI.
	 */
	public boolean checkPoliticaCorporativa(TareaExterna tareaExterna);
	
	/**
	 * Método que comprueba si el expediente tiene algún posicionamiento creado
	 * @param tareaExterna
	 * @return true si tiene algún posicionamiento, false en caso contrario.
	 */
	public boolean checkPosicionamiento(TareaExterna tareaExterna);

	/**
	 * Este método obtiene los detalles de una oferta por ID de oferta requeridos
	 * en la pestaña ofertas de un activo.
	 * 
	 * @param id identificador de la oferta a consultar.
	 * @return Devuelve un objeto detalle oferta.
	 */
	public DtoDetalleOferta getDetalleOfertaById(Long idOferta);

	/**
	 * Este método obtiene una lista de ofertantes para el ID de oferta dado, esto incluye
	 * el ofertante principal y los titulares adicionales.
	 * 
	 * @param idOferta id de la oferta a filtrar.
	 * @return Devuelve una lista de DtoOfertantesOferta por cada ofertante encontrado.
	 */
	public List<DtoOfertantesOferta> getOfertantesByOfertaId(Long idOferta);

	/**
	 * Este método obtiene una lista de honorarios para el ID de oferta dado.
	 *
	 * @param idActivo id del activo para filtrar.
	 * @param idOferta id de la oferta para filtrar.
	 * @return Devuelve una lista de DtoGastoExpediente.
	 */
	public List<DtoGastoExpediente> getHonorariosActivoByOfertaId(Long idActivo, Long idOferta);
	
	/**
	 * Este método obtiene una lista de honorarios para el ID de oferta dado.
	 *
	 * @param dtoHonorariosOferta : dto con el ID de la oferta a filtrar.
	 * @return Devuelve una lista de DtoHonorariosOferta por cada honorario encontrado.
	 */
	public List<DtoHonorariosOferta> getHonorariosByOfertaId(DtoHonorariosOferta dtoHonorariosOferta);
	

	/**
	 * Método que comprueba si se ejerce el tanteo
	 * @param tareaExterna
	 * @return
	 */
	public boolean checkEjerce(TareaExterna tareaExterna);
	
	
	
	/**
	 * Devuelve una lista de todas las ofertas pertenecientes a todos los titulares de una oferta
	 *
	 * @param oferta
	 * @return List<Oferta> Devuelve una lista de todas las ofertas pertenecientes a todos los titulares de un activo
	 */
	public List<Oferta> getOtrasOfertasTitularesOferta(Oferta oferta);

	/**
	 * Método que ratifica el comité de Bankia
	 * @param tareaExterna
	 * @return
	 */
	boolean ratificacionComite(TareaExterna tareaExterna);
	
	/**
	 * Método para comprobar que el ACTIVO tenga una oferta ACEPTADA con un expediente comercial con algunos
	 * de los estados finalizados del expediente
	 * @param activo
	 * @return
	 */
	public Boolean isActivoConOfertaYExpedienteBlocked(Activo activo);
	
	/**
	 * Método para comprobar que la AGRUPACION tenga una oferta ACEPTADA con un expediente comercial con algunos
	 * de los estados finalizados del expediente
	 * @param agrupacion
	 * @return
	 */
	public Boolean isAgrupacionConOfertaYExpedienteBlocked(ActivoAgrupacion agrupacion);
	
	/**
	 * Comprueba que la oferta y su expediente comercial esten aprobados
	 * @param of
	 * @return
	 */
	public Boolean isOfertaAceptadaConExpedienteBlocked(Oferta of);

	/**
	 * Este método resetea el PBC.
	 * 
	 * @param expediente : entidad expediente.
	 * @param fullReset, Booleano para indicar si reseteamos solo el estado o también la responsabilidad corporativa.
	 * @return Devuelve True si la operación ha sido satisfactoria, False si ha habido un error.
	 */
	public boolean resetPBC(ExpedienteComercial expediente, Boolean fullReset);
	
	/**
	 * Este método comprueba si hay impuestos.
	 * @param tareaExterna
	 * @return
	 */
	public boolean checkImpuestos(TareaExterna tareaExterna);
	
	/**
	 * Este método construye una lista de ActivoOferta para la creación de ofertas.
	 * @param activo a incluir en la oferta
	 * @param agrupacion a incluir en la oferta
	 * @param oferta con la información de la oferta
	 * @return List<ActivoOferta> 
	 */
	public List<ActivoOferta> buildListaActivoOferta(Activo activo, ActivoAgrupacion agrupacion, Oferta oferta) throws Exception;

	/**
	 * 
	 * @param oferta
	 * @param accion
	 * @param activo
	 * @return
	 */
	public DtoGastoExpediente calculaHonorario(Oferta oferta, String accion,Activo activo);

	/**
	 * Método que ratifica el comité de Bankia
	 * @param tareaExterna
	 * @param importeOfertante
	 * @return String Error o null
	 */
	String ratificacionComiteProcess(TareaExterna tareaExterna, String importeOfertante);

	/**
	 * Método que da de alta un comité
	 * @param tareaExterna
	 * @return String Error o null
	 */
	String altaComiteProcess(TareaExterna tareaExterna, String codigo);
	
	public boolean updateOfertantesByOfertaId(DtoOfertantesOferta dtoOfertantesOferta);
	
	/**
	 * Obtiene el listado de subtipos  de proveedor que pueden ser un canal de prescripción
	 * @return
	 */
	public List<DDTipoProveedor> getDiccionarioSubtipoProveedorCanal();

	
	/**
	 * Este método comprueba que todos los tanteos de los activos del expedientes tienen una resolucion renuncia
	 * @param tareaExterna
	 * @return
	 */
	boolean checkRenunciaTanteo(TareaExterna tareaExterna);

	/**
	 * Este método comprueba que alguno de los tanteos de los activos del expedientes tienen una resolucion ejercida
	 * @param tareaExterna
	 * @return
	 */
	boolean checkEjercidoTanteo(TareaExterna tareaExterna);

	/**
	 * Devuelve el primer Usuario asociado al preescritor de la oferta. En caso de no existir devuelve null.
	 * @param oferta
	 * @return Usuario
	 */
	Usuario getUsuarioPreescriptor(Oferta oferta);
	
	/**
	 * Devuelve el ActivoProveedor asociado al preescritor de la oferta. En caso de no existir devuelve null.
	 * @param oferta
	 * @return ActivoProveedor
	 */
	public ActivoProveedor getPreescriptor(Oferta oferta);

	public void desocultarActivoOferta(Oferta oferta) throws Exception;
	
	/**
	 * Método que comprueba para Bankia (excepto subcartera BH) si el estado de la reserva es firmada.
	 * @param tareaExterna
	 * @return true si el valor es NO en ambos combos, false en caso de que no estén rellenos o alguno tenga SI.
	 */
	public boolean checkReservaFirmada(TareaExterna tareaExterna);

	public void congelarExpedientesPorOfertaExpress(Oferta ofertaExpress) throws Exception;

	public Double getImporteOferta(Oferta oferta);

	boolean comprobarComiteLiberbankPlantillaPropuesta(TareaExterna tareaExterna);

	DDComiteSancion calculoComiteLiberbank(Oferta ofertaAceptada);

	Boolean checkProvinciaCompradores(TareaExterna tareaExterna);

	Boolean checkNifConyugueLBB(TareaExterna tareaExterna);

	/**
	 * Método que comprueba que la oferta está activa, es decir, el estado de la oferta es: Tramitada, Congelada o Pendiente.
	 */
	boolean estaViva(Oferta oferta);

	public List<Oferta> getListaOfertasByActivo(Activo activo);

	/**
	 * @param idActivo
	 * @param comprador
	 * @return TRUE ->NO hace falta pedir documentación. FALSE ->Sí hace falta.
	 */
	boolean checkPedirDoc(Long idActivo, Long idAgrupacion,Long idExpediente, String dniComprador, String codtipoDoc);

	DtoClienteComercial getClienteComercialByTipoDoc(String dniComprador, String codtipoDoc);

	DtoClienteComercial getClienteGDPRByTipoDoc(String dniComprador, String codtipoDoc);

	public void llamadaMaestroPersonas(String numDocCliente, String cartera);
	
	/**
	 * Devuelve el destino comercial segun el id del activo.
	 * @return String destino comercial del activo.
	 */
	public String getDestinoComercialActivo(Long idActivo, Long idAgrupacion, Long idExpediente);
}

