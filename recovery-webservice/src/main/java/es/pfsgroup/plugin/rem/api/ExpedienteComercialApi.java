package es.pfsgroup.plugin.rem.api;

import java.util.ArrayList;
import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.CondicionesActivo;
import es.pfsgroup.plugin.rem.model.DtoActivosExpediente;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoExpediente;
import es.pfsgroup.plugin.rem.model.DtoBloqueosFinalizacion;
import es.pfsgroup.plugin.rem.model.DtoCondiciones;
import es.pfsgroup.plugin.rem.model.DtoCondicionesActivoExpediente;
import es.pfsgroup.plugin.rem.model.DtoDatosBasicosOferta;
import es.pfsgroup.plugin.rem.model.DtoEntregaReserva;
import es.pfsgroup.plugin.rem.model.DtoExpedienteHistScoring;
import es.pfsgroup.plugin.rem.model.DtoExpedienteScoring;
import es.pfsgroup.plugin.rem.model.DtoFichaExpediente;
import es.pfsgroup.plugin.rem.model.DtoFormalizacionFinanciacion;
import es.pfsgroup.plugin.rem.model.DtoGastoExpediente;
import es.pfsgroup.plugin.rem.model.DtoHstcoSeguroRentas;
import es.pfsgroup.plugin.rem.model.DtoInformeJuridico;
import es.pfsgroup.plugin.rem.model.DtoListadoGestores;
import es.pfsgroup.plugin.rem.model.DtoModificarCompradores;
import es.pfsgroup.plugin.rem.model.DtoNotarioContacto;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoObtencionDatosFinanciacion;
import es.pfsgroup.plugin.rem.model.DtoPosicionamiento;
import es.pfsgroup.plugin.rem.model.DtoReserva;
import es.pfsgroup.plugin.rem.model.DtoSeguroRentas;
import es.pfsgroup.plugin.rem.model.DtoTanteoActivoExpediente;
import es.pfsgroup.plugin.rem.model.DtoTanteoYRetractoOferta;
import es.pfsgroup.plugin.rem.model.DtoTextosOferta;
import es.pfsgroup.plugin.rem.model.DtoTipoDocExpedientes;
import es.pfsgroup.plugin.rem.model.DtoUsuario;
import es.pfsgroup.plugin.rem.model.EntregaReserva;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.TanteoActivoExpediente;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VBusquedaDatosCompradorExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.rest.dto.DatosClienteDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaUVEMDto;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;
import es.pfsgroup.plugin.rem.rest.dto.TitularUVEMDto;

public interface ExpedienteComercialApi {
	/**
	 * Recupera el ExpedienteComercial indicado.
	 * 
	 * @param id
	 *            Long
	 * @return ExpedienteComercial
	 */
	public ExpedienteComercial findOne(Long id);

	/**
	 * Recupera el ExpedienteComercial indicado.
	 * @param numExpediente
	 * @return ExpedienteComercial
	 */
	public ExpedienteComercial findOneByNumExpediente(Long numExpediente);
	
	/**
	 * Recupera el ExpedienteComercial indicado.
	 * @param trabajo
	 * @return ExpedienteComercial
	 */
	public ExpedienteComercial findOneByTrabajo(Trabajo trabajo);
	
	/**
	 * Método que recupera un conjunto de datos del expediente comercial según
	 * su id
	 * 
	 * @param id
	 * @param tab
	 * @return Object
	 */
	public Object getTabExpediente(Long id, String tab);

	/**
	 * Método que recupera los textos de la oferta de un expediente
	 * 
	 * @param id
	 * @return
	 */
	public List<DtoTextosOferta> getListTextosOfertaById(Long id);

	/**
	 * Método que guarda un texto de oferta para un expediente comercial
	 * 
	 * @param dto
	 * @param idEntidad
	 *            id del expediente
	 * @return resultado de la operacion
	 */
	public boolean saveTextoOferta(DtoTextosOferta dto, Long idEntidad);
	
	
	/**
	 * Método que guarda un Seguro de rentas del expediente comercial
	 * y en el historico de rentas
	 * 
	 * @param dto
	 * @param idEntidad
	 *            id del expediente
	 * @return resultado de la operacion
	 */
	public boolean saveSeguroRentasExpediente(DtoSeguroRentas dto, Long idEntidad);

	/**
	 * Método que guarda la información de la pestaña datos básicos de la oferta
	 * 
	 * @param dto
	 * @param idExpediente
	 * @return
	 */
	boolean saveDatosBasicosOferta(DtoDatosBasicosOferta dto, Long idExpediente);

	/**
	 * Metodo que guarda la informacion de la pestanya Tanteo y Retracto de la oferta
	 * @param dto
	 * @param idExpediente
	 * @return
	 */
	public boolean saveOfertaTanteoYRetracto(DtoTanteoYRetractoOferta dto, Long idExpediente);
	
	/**
	 * Método que recupera las entregas de una reserva para un expediente
	 * 
	 * @return
	 */
	public List<DtoEntregaReserva> getListEntregasReserva(Long id);

	/**
	 * Añadir una Entrega Reserva a un Expediente Comercial
	 * 
	 * @param entregaReserva
	 * @param idExpedienteComercial
	 * @return
	 * @throws Exception
	 */
	public boolean addEntregaReserva(EntregaReserva entregaReserva, Long idExpedienteComercial) throws Exception;

	/**
	 * Actualizar los valores del Expediente Comercial
	 * 
	 * @parame xpedienteComercial
	 * @return
	 */
	public boolean update(ExpedienteComercial expedienteComercial);
	
	
	/**
	 * Actualiza el estado de la dev reserva al codigo dado
	 * 
	 * @param expedienteComercial
	 * @param codEstadoReserva
	 * @return
	 */
	public boolean updateEstadoDevolucionReserva(ExpedienteComercial expedienteComercial, String codEstadoReserva) throws Exception;
	
	/**
	 * Actualiza el estado de la reserva al codigo dado
	 * 
	 * @param expedienteComercial
	 * @param codEstadoReserva
	 * @return
	 */
	boolean updateEstadoReserva(ExpedienteComercial expedienteComercial, String codEstadoReserva) throws Exception;
	
	/**
	 * Actualiza el estado del expediente comercial con el codigo dado
	 * 
	 * @param expedienteComercial
	 * @param codEstadoReserva
	 * @return
	 */
	boolean updateEstadoExpedienteComercial(ExpedienteComercial expedienteComercial, String codEstadoExpedienteComercial) throws Exception;

	/**
	 * Este método devuelve el Expediente Comercial junto con la Reserva al estado previo a la tarea Resolución Expediente
	 * 
	 * @param idTramite: ID del trámite desde el cual se realiza la consulta.
	 * @return Devuelve True si el estado del expdiente comercial es distinto a anulado, False si no lo es.
	 * @throws Exception 
	 */
	public boolean updateExpedienteComercialEstadoPrevioResolucionExpediente(ExpedienteComercial expedienteComercial, String codigoTareaActual, String codigoTareaSalto, Boolean botonDeshacerAnulacion) throws Exception;

	/**
	 * Método que recupera las observaciones del expediente comercial
	 * 
	 * @return
	 */
	public DtoPage getListObservaciones(Long idExpediente, WebDto dto);

	/**
	 * Actualiza una observacion
	 * 
	 * @param dtoObservacion
	 * @return
	 */
	public boolean saveObservacion(DtoObservacion dtoObservacion);

	/**
	 * Crea una observación
	 * 
	 * @param dtoObservacion
	 * @param idTrabajo
	 * @return
	 */
	public boolean createObservacion(DtoObservacion dtoObservacion, Long idExpediente);

	/**
	 * Elimina una observación
	 * 
	 * @param idObservacion
	 * @return
	 */
	public boolean deleteObservacion(Long idObservacion);

	/**
	 * Método que recupera los activos del expediente comercial
	 * 
	 * @return
	 */

	public DtoPage getActivosExpediente(Long idExpediente);
	
	/**
	 * Método que recupera los tipos de documento del expediente comercial
	 * 
	 * @return
	 */
	
	public List <DtoTipoDocExpedientes> getTipoDocumentoExpediente(String tipoExpediente);

	/**
	 * Recupera el adjunto del Expediente comercial
	 * 
	 * @param dtoAdjunto
	 * @return
	 */
	public FileItem getFileItemAdjunto(DtoAdjuntoExpediente dtoAdjunto);

	/**
	 * Recupera info de los adjuntos asociados al expediente comercial
	 * 
	 * @param id
	 * @return
	 */
	public List<DtoAdjuntoExpediente> getAdjuntos(Long id);

	/**
	 * 
	 * @param fileItem
	 * @return
	 */
	public String upload(WebFileItem fileItem) throws Exception;

	/**
	 * Sube un adjunto del expediente comercial
	 * 
	 * @param dtoAdjunto
	 * @return
	 */
	public boolean deleteAdjunto(DtoAdjunto dtoAdjunto);

	/**
	 * Recupera la lista de compradores asociados al expediente
	 * 
	 * @param idExpediente
	 * @return
	 */
	public Page getCompradoresByExpediente(Long idExpediente, WebDto dto);

	/**
	 * Recupera la informacion de un Comprador de un Expediente Comercial
	 * 
	 * @param idCom
	 * @param idExp
	 * @return
	 */
	public VBusquedaDatosCompradorExpediente getDatosCompradorById(String idCom, String idExp);
	/**
	 * Método que guarda la información de la pestaña Condicionantes del
	 * expediente
	 * 
	 * @param dto
	 * @param idExpediente
	 * @return
	 */
	boolean saveCondicionesExpediente(DtoCondiciones dto, Long idExpediente);

	/**
	 * Metodo que crea la reserva para un expediente comercial
	 * @param expediente
	 * @return
	 */
	public Reserva createReservaExpediente(ExpedienteComercial expediente);
	
	/**
	 * Método que guarda la información de la pestaña de un comprador del
	 * expediente
	 * 
	 * @param dto
	 * @param idExpediente
	 * @return
	 */
	boolean saveFichaComprador(VBusquedaDatosCompradorExpediente dto);

	/**
	 * Verificación de adjunto existente en el expediente comercial, buscando por subtipo de documento.
	 * Esta verificación está pensada para trámites (ya que se identifica el trabajo)
	 * @param idTrabajo
	 * @param codigoSubtipoDocumento Código del subtipo de documento del expediente
	 * @return
	 */
	public Boolean comprobarExisteAdjuntoExpedienteComercial(Long idTrabajo, String codigoSubtipoDocumento);
		


	/**
	 * Método que guarda el comprador como principal
	 * 
	 * @param idComercial
	 * @param idExpedienteComercial
	 * @return
	 */
	boolean marcarCompradorPrincipal(Long idComprador, Long idExpedienteComercial);

	/**
	 * Método que obtiene el posicionamiento del expediente
	 * 
	 * @param dto
	 * @param idExpediente
	 * @return
	 */
	
	String getTareaDefinicionDeOferta(Long idExpedienteComercial, WebDto webDto);

	/**
	 * Método que obtiene la tarea de definición oferta
	 * 
	 * @param dto
	 * @param idExpediente
	 * @return
	 */
	public DtoPage getPosicionamientosExpediente(Long idExpediente);

	/**
	 * Método que obtiene los comparecientes del expediente
	 * 
	 * @param dto
	 * @param idExpediente
	 * @return
	 */
	public DtoPage getComparecientesExpediente(Long idExpediente);

	/**
	 * Método que obtiene las subsanaciones del expediente
	 * 
	 * @param dto
	 * @param idExpediente
	 * @return
	 */
	public DtoPage getSubsanacionesExpediente(Long idExpediente);

	/**
	 * Método que obtiene los notarios del expediente
	 * 
	 * @param dto
	 * @param idExpediente
	 * @return
	 */
	public List<DtoNotarioContacto> getContactosNotario(Long idProveedor);

	/**
	 * Modifica los datos de una reserva
	 * 
	 * @param dto
	 * @param idEntidad
	 * @return
	 */
	boolean saveReserva(DtoReserva dto, Long idEntidad);
	
	
	/**
	 * Método que obtiene los honorarios(gastos) por activo y oferta aceptada
	 * @param idOferta
	 * @return
	 */
	public List<DtoGastoExpediente> getHonorariosActivoByOfertaAceptada(Oferta oferta, Activo activo);
	
	/**
	 * Método que obtiene los honorarios(gastos) del expediente
	 * 
	 * @param idExpediente
	 * @return
	 */
	
	public List<DtoHstcoSeguroRentas> getHstcoSeguroRentas(Long idExpediente);
	
	/**
	 * Método que obtiene los honorarios(gastos) del expediente
	 * 
	 * @param idExpediente
	 * @return
	 */
	public List<DtoGastoExpediente> getHonorarios(Long idExpediente, Long idActivo);

	/**
	 * Método que guarda los honorarios(gastos) del expediente
	 * 
	 * @param dtoGastoExpediente
	 * @return
	 */
	public boolean saveHonorario(DtoGastoExpediente dtoGastoExpediente);

	/**
	 * Método que obtiene el ExpedienteComercial relacionado con una determinada
	 * Oferta
	 * 
	 * @param idOferta
	 * @return
	 */
	public ExpedienteComercial expedienteComercialPorOferta(Long idOferta);

	/**
	 * Método que obtiene uno de los estados posibles del ExpedienteComercial
	 * relacionado con una determinado código
	 * 
	 * @param codigo
	 * @return
	 */
	public DDEstadosExpedienteComercial getDDEstadosExpedienteComercialByCodigo(String codigo);

	/**
	 * Método que guarda la información de la pestaña Ficha del expediente
	 * 
	 * @param dto
	 * @param idExpediente
	 * @return
	 */
	boolean saveFichaExpediente(DtoFichaExpediente dto, Long idExpediente);

	/**
	 * Método que guarda la información de una entrega de reserva
	 * 
	 * @param dto
	 * @param idExpediente
	 * @return
	 */
	public boolean saveEntregaReserva(DtoEntregaReserva dto, Long idEntidad);

	/**
	 * Método que actualiza la información de una entrega de reserva
	 * 
	 * @param dto
	 * @param idExpediente
	 * @return
	 */
	public boolean updateEntregaReserva(DtoEntregaReserva dto, Long id);

	/**
	 * Método que elimina una entrega de reserva
	 * @param idExpediente
	 * @return
	 */
	public boolean deleteEntregaReserva(Long idEntrega);

	/**
	 * Función que devuelve la propuesta de un comité para un expediente
	 * comercial de Bankia
	 * 
	 * @param idExpediente
	 * @return
	 * @throws Exception
	 */
	public String consultarComiteSancionador(Long idExpediente) throws Exception;

	/**
	 * Crea un registro de posicionamiento
	 * 
	 * @param dto
	 * @param idEntidad
	 * @return
	 */
	public boolean createPosicionamiento(DtoPosicionamiento dto, Long idEntidad);

	/**
	 * Actualiza un registro de posicionamiento
	 * 
	 * @param dto
	 * @return
	 */
	public boolean savePosicionamiento(DtoPosicionamiento dto);

	/**
	 * Elimina un registro de posicionamiento
	 * 
	 * @param idPosicionamiento
	 * @return
	 */
	public boolean deletePosicionamiento(Long idPosicionamiento);

	/**
	 * Método que crea un comprador desde la pestaña compradores del expediente
	 * 
	 * @param dto
	 * @param idExpediente
	 * @return
	 */
	boolean createComprador(VBusquedaDatosCompradorExpediente dto, Long idExpediente);

	/**
	 * Crea un objeto de tipo OfertaUVEMDto
	 * @param oferta
	 * @return
	 */
	public OfertaUVEMDto createOfertaOVEM(Oferta oferta,ExpedienteComercial expedienteComercial) throws Exception; 
	
	/**
	 * Obtiene la lista de titulares para uvem
	 * @param expedienteComercial
	 * @return
	 */
	public ArrayList<TitularUVEMDto> obtenerListaTitularesUVEM(ExpedienteComercial expedienteComercial) throws Exception;
	
	/**
	 * Método que devuelve los datos de un comprador de Bankia (WebService Ursus) por número de comprador
	 * @param numCompradorUrsus
	 * @param idExpediente
	 * @return DatosClienteDto
	 */
	public DatosClienteDto buscarNumeroUrsus(String numCompradorUrsus, String tipoDocumento, String idExpediente) throws Exception;
	
	/**
	 * Método que devuelve los proveedores filtrados por su tipo de proveedor
	 * @param codigoTipoProveedor
	 * @param nombreBusqueda
	 * @param idActivo
	 * @param dto
	 * @return Page
	 */
	public Page getComboProveedoresExpediente(String codigoTipoProveedor, String nombreBusqueda, String idActivo, WebDto dto);
	
	/**
	 * Crea un registro de honorarios (gasto_expediente)
	 * @param dto
	 * @param idEntidad
	 * @return
	 */
	public boolean createHonorario(DtoGastoExpediente dto, Long idEntidad);
	
	/**
	 * Elimina un registro de honorario (gasto_expediente)
	 * @param idPosicionamiento
	 * @return
	 */
	public boolean deleteHonorario(Long idHonorario);
	
	/**
	 * Elimina la relación entre un comprador y un expediente
	 * @param idPosicionamiento
	 * @return
	 */
	public boolean deleteCompradorExpediente(Long idExpediente, Long idComprador);
	
	/**
	 * Método que actualiza la información de los activos de un expediente
	 * 
	 * @param dto
	 * @param idExpediente
	 * @return
	 */
	public boolean updateActivoExpediente(DtoActivosExpediente dto, Long id);
	
	
	/**
	 * Método que construye un InstanciaDecisionDto para el envío de ofertas a Bankia a través de WS 
	 * 
	 * @param expediente expedienteComercial de la oferta
	 * @param porcentajeImpuesto del activo de la oferta.
	 * @param codComiteSuperior del expediente.
	 * @return
	 */
	public InstanciaDecisionDto expedienteComercialToInstanciaDecisionList(ExpedienteComercial expediente, Long porcentajeImpuesto, String codComiteSuperior) throws Exception;

	/**
	 * Este método obtiene una lista de bloqueos formalización por el ID del expediente recibido.
	 * 
	 * @param dto : dto con el ID de expediente a filtrar la lista de bloqueos.
	 * @return Devuelve una lista de 'DtoBloqueosFinalizacion' con los datos encontrados.
	 */
	public List<DtoBloqueosFinalizacion> getBloqueosFormalizacion(DtoBloqueosFinalizacion dto);

	/**
	 * Este método genera un nuevo bloqueo formalización con los datos obtenidos.
	 * 
	 * @param dto : dto con los datos del nuevo bloqueo.
	 * @return Devuelve True si la operación ha sido satisfactoria.
	 */
	public boolean createBloqueoFormalizacion(DtoBloqueosFinalizacion dto, Long idActivo);

	/**
	 * Este método establece un bloqueo por el ID de bloqueo obtenido a borrado, así como el nombre de usuario
	 * que realiza la operación y la fecha.
	 * 
	 * @param dto : dto con los datos del nuevo bloqueo.
	 * @return Devuelve True si la operación ha sido satisfactoria.
	 */
	public boolean deleteBloqueoFormalizacion(DtoBloqueosFinalizacion dto);

	/**
	 * Devuelve el expediente de la oferta en caso de que exista.
	 * @param oferta
	 * @return
	 */
	public ExpedienteComercial findOneByOferta(Oferta oferta);

	/**
	 * Devuelve la descripción de un comité dado su código
	 * @param codigo
	 * @return
	 */
	public DDComiteSancion comiteSancionadorByCodigo(String codigo);

	/** 
	 * Este método obtiene el expediente comercial del activo indicado, el cual
	 * no se encuentre en los siguientes estados:
	 * -En trámite.
	 * -Pendiente Sanción.
	 * -Contraorfertado.
	 * -Vendido.
	 * -Denegado.
	 * -Anulado.
	 * 
	 * @param activo
	 * @return
	 */
	public ExpedienteComercial getExpedienteComercialResetPBC(Activo activo);
	
	/**
	 * Este método recibe un expediente comercial, llama al WS para obtener los datos del préstamo y los guarda en el expediente.
	 * @param dto
	 */
	public boolean obtencionDatosPrestamo(DtoObtencionDatosFinanciacion dto) throws Exception;

	/**
	 * Este método obtiene los datos del apartado 'Financiación' de la tab 'Formalización' del expediente.
	 * @param dto : DTO con el ID de expediente a filtrar.
	 * @return
	 */
	public DtoFormalizacionFinanciacion getFormalizacionFinanciacion(DtoFormalizacionFinanciacion dto);

	/**
	 * Este método guarda los cambios del apartado 'Financiación' de la tab 'Formalización' del expediente.
	 * @param dto : DTO con los cambios a guardar.
	 * @return Devuelve True si la operación ha sido satisfactoria.
	 */
	public boolean saveFormalizacionFinanciacion(DtoFormalizacionFinanciacion dto);
	
	/**
	 * Devuelve un listado de usuarios según el tipo de gestor pasado por parámetro
	 * @param idTipoGestor
	 * @return
	 */
	public List<DtoUsuario> getComboUsuarios(long idTipoGestor);

	/**
	 * Inserta un gestor en el expediente comercial
	 * @param dto
	 * @return
	 */
	public Boolean insertarGestorAdicional(GestorEntidadDto dto);
	
	/**
	 * Recupera los gestores del expediente
	 * @param idExpediente
	 * @return
	 */
	public List<DtoListadoGestores> getGestores(Long idExpediente);
	
	/**
	 * Devuelve una lista de los tipos de gestor correspondientes a los expedientes comerciales
	 * @return
	 */
	public List<EXTDDTipoGestor> getComboTipoGestor(Long idExpediente);
	
	/**
	 * Actualiza el importe con el que participa un activo en un expediente
	 * @param Oferta oferta
	 * @return
	 */
	public boolean updateParticipacionActivosOferta(Oferta oferta);
	
	/**
	 * Comprueba si el activo tiene un expediente comercial vivo, es decir,
	 * que no tenga ninguna tarea activa.
	 * @param activo
	 * @return
	 */
	public boolean isExpedienteComercialVivoByActivo(Activo activo);

	/**
	 * Crea un gasto expediente
	 * @param expediente
	 * @param oferta
	 * @param activo
	 * @param codigoColaboracion
	 * @return
	 */
	public GastosExpediente creaGastoExpediente(ExpedienteComercial expediente,  Oferta oferta, Activo activo, String codigoColaboracion);

	/**
	 * Devuelve los activos de un expediente dado, para mostrarlos en un combo
	 * @param idExpediente
	 * @return
	 */
	public List<DtoActivosExpediente> getComboActivos(Long idExpediente);

	/**
	 * Este método obtiene una lista de clientes URSUS en base al número de documento
	 * y el tipo de documento.
	 * 
	 * @param numeroDocumento : número de documento del cliente.
	 * @param tipoDocumento : tipo de documento del cliente.
	 * @param idExpediente : idExpediente
	 * @return Devuelve una lista con los clientes encontrados por el servicio.
	 */
	public List<DatosClienteDto> buscarClientesUrsus(String numeroDocumento, String tipoDocumento, String idExpediente) throws Exception;

	/**
	 * Este método obtiene los detalles de cliente en base al número URSUS recibido.
	 * 
	 * @param numeroUrsus : número URSUS del cliente.
	 * @param idExpediente : idExpediente
	 * @return Devuelve todos los detalles del cliente encontrados por el servicio.
	 * @throws Exception Devuelve excepcion si la conexion no ha sido satisfactoria.
	 */
	public DatosClienteDto buscarDatosClienteNumeroUrsus(String numeroUrsus, String idExpediente) throws Exception;
	
	/**
	 * Este método calcula el importe de reserva para un expediente si se dan las condiciones:
	 * El expediente tiene reserva.
	 * La reserva tiene el cálculo de tipo porcentaje.
	 * Entonces mira si la oferta tiene importe contraoferta y utiliza éste importe, si no
	 * utiliza el importe de la oferta.
	 * 
	 * @param expediente : expediente comercial.
	 */
	public void actualizarImporteReservaPorExpediente(ExpedienteComercial expediente);

	/**
	 * Este método calcula y actualiza el importe por cada honorario(GastoExpediente) de un Expediente.
	 * Sólo se actualizan los honorarios cuyos tipos de cálculo es 'porcentaje'.
	 * 
	 * @param idTramite: ID del trámite.
	 */
	public void actualizarHonorariosPorExpediente(Long idTramite);

	String uploadDocumento(WebFileItem fileItem, Long idDocRestClient, ExpedienteComercial expedienteComercialEntrada,
			String matricula) throws Exception;

	/**
	 * Este método devuelve True si la suma de todos los importes de participación de los activos
	 * involucrados en el expediente suman lo mismo que el importe total de expediente. False si no
	 * coinciden. El importe del expediente se saca en primer lugar del importe contra oferta, si no
	 * se encuentra establecido lo obtiene del importe de la oferta.
	 * 
	 * @param idExpediente: ID del expediente comercial para comprobar su importe.
	 * @return  Devuelve True si los importes coinciden, False si no.
	 */
	public Boolean checkImporteParticipacion(Long idExpediente);

	/**
	 * Este método obtiene un expediente comercial en base a un Activo.
	 * 
	 * @param activo: acivo al que buscar el expediente comercial al que pertenece.
	 * @return Devuelve un expediente comercial.
	 */
	public ExpedienteComercial getExpedientePorActivo(Activo activo);
	
	/**
	 * Obtiene los tanteos para un activo en un expediente
	 * 
	 * @param idExpediente
	 * @param idActivo
	 * @return
	 */
	public List<DtoTanteoActivoExpediente> getTanteosPorActivoExpediente(Long idExpediente, Long idActivo);
	
	/**
	 * Guardar tanteo activo
	 * 
	 * @param tanteoActivo
	 * @return
	 */
	public boolean guardarTanteoActivo(DtoTanteoActivoExpediente tanteoActivoDto);
	
	/**
	 * Borrar tanteo activo
	 * 
	 * @param tanteoActivoDto
	 * @return
	 */
	public boolean deleteTanteoActivo(Long idTanteo);
	
	/**
	 * Obitene los condicionenates del activo en el exp comercial
	 * @param idExpediente
	 * @param idActivo
	 * @return
	 */
	public DtoCondicionesActivoExpediente getCondicionesActivoExpediete(Long idExpediente, Long idActivo);
	
	/**
	 * Guarda las condiciones informadas de un activo en un expediente comercial
	 * @param condiciones
	 * @return
	 */
	public boolean guardarCondicionesActivoExpediente(DtoCondicionesActivoExpediente condiciones);

	/**
	 * Obtiene la fecha de emisión del informe jurídico
	 * @param idExpediente
	 * @param idActivo
	 * @return
	 */
	public DtoInformeJuridico getFechaEmisionInfJuridico(Long idExpediente, Long idActivo);

	/**
	 * Guarda el informe jurídico
	 * @param dto
	 * @return
	 */
	public boolean guardarInformeJuridico(DtoInformeJuridico dto);
	
	/**
	 * Valida la posibilidad de bloquear un expediente comercial. Si no es posible devuelve codigo error. Si lo es cadena vacía 
	 * @param idExpediente
	 * @return
	 */
	public String validaBloqueoExpediente(Long idExpediente);
	
	
	/**
	 * Bloquea el expediente comercial
	 * 
	 * @param idExpediente
	 * @return
	 */
	public void bloquearExpediente(Long idExpediente);
	
	/**
	 * Valida la posibilidad de desbloquear un expediente comercial. Si no es posible devuelve codigo error. Si lo es cadena vacía 
	 * @param idExpediente
	 * @return
	 */
	public String validaDesbloqueoExpediente(Long idExpediente);
	
	
	/**
	 * Desbloquea el expediente comercial
	 * 
	 * @param idExpediente
	 * @return
	 */
	public void desbloquearExpediente(Long idExpediente, String motivoCodigo, String motivoDescLibre);

	public boolean updateBloqueoFormalizacion(DtoBloqueosFinalizacion dto);

	/**
	 * Devuelve true si el expediente está bloqueado y false en caso contrario
	 * @param idTramite
	 * @return
	 */
	public boolean checkExpedienteBloqueado(Long idTramite) ;
	
	/**
	 * Actualiza la Fecha vencimiento reserva con la Fecha resolucion + 40 días.
	 * Esto se hace en caso que algún activo esté sujeto a tanteo y todos los activos tengan resolución tanteo = Renunciado.
	 * Debe recibir al menos uno de los dos parámetros de entrada.
	 * @param tanteoActivo
	 * @param tanteosActivo
	 * @return
	 */
	public void actualizarFVencimientoReservaTanteosRenunciados(TanteoActivoExpediente tanteoActivo,List<TanteoActivoExpediente> tanteosActivo);

	/**
	 * Devuelve true si el expediente asociado al trabajo está sancionado por el comite de Haya_Sareb
	 * @param trabajo
	 * @return
	 */
	public boolean isComiteSancionadorHaya(Trabajo trabajo);
	
	/**
	 * Comprueba que el precio mínimo del activo (o activos en agrupaciones) es inferior del importe del expediente para comite sancionador Haya.
	 * En tal caso devuelve un true
	 * @param idTramite
	 * @return
	 */
	public boolean importeExpedienteMenorPreciosMinimosActivos(Long idTramite);

	/**
	 * Crea las condiciones iniciales para un Activo-Expediente. Se le pasa el activo por parametro porque no 
	 * siempre coincidira con el activo principal de la oferta (relacionado con expediente)
	 * @param activo
	 * @param expediente
	 * @return
	 */
	CondicionesActivo crearCondicionesActivoExpediente(Activo activo, ExpedienteComercial expediente);

	/**
	 * Comprueba que todos los compradores tengan numero URSUS
	 * @param expedienteComercial
	 * @return boolean
	 */
	public boolean checkCompradoresTienenNumeroUrsus(Long idTramite);

	/**
	 * Envia todos los compradores(titulares) a UVEM
	 * @param expedienteComercial
	 * @return void
	 */
	public void enviarTitularesUvem(Long idExpediente) throws Exception;
	
	/**
	 * Envia todos los honorarios a UVEM
	 * @param idExpediente
	 * @return void
	 */
	public void enviarHonorariosUvem(Long idExpediente) throws Exception;
	
	/**
	 * Actualiza la reserva y el expediente al recibir un resol de devolucion
	 * 
	 * @param expedienteComercial
	 * @param ResolucionComiteDto dto
	 * @return
	 */
	public boolean updateEstadosResolucionDevolucion(ExpedienteComercial expedienteComercial,ResolucionComiteDto dto);
	
	/**
	 * Actualiza la reserva y el expediente al recibir un resol de no devolucion
	 * 
	 * @param expedienteComercial
	 * @param ResolucionComiteDto dto
	 * @return
	 */
	public boolean updateEstadosResolucionNoDevolucion(ExpedienteComercial expedienteComercial,ResolucionComiteDto dto);
	
	/**
	 * Devuelve la subcartera del expediente
	 * Lo hace a través del primer activo del expediente
	 * 
	 * @param expedienteComercial
	 * @param ResolucionComiteDto dto
	 * @return
	 */
	public DDSubcartera getCodigoSubCarteraExpediente(Long idExpediente);

	/**
	 * Este método comprueba, desde un ID de trámite, si el expediente comercial se encuentra en un estado
	 * distinto a anulado.
	 * 
	 * @param idTramite: ID del trámite desde el cual se realiza la consulta.
	 * @return Devuelve True si el estado del expdiente comercial es distinto a anulado, False si no lo es.
	 */
	public boolean checkEstadoExpedienteDistintoAnulado(Long idTramite);

	public void enviarCondicionantesEconomicosUvem(Long idExpediente) throws Exception;

	boolean checkExpedienteFechaChequeLiberbank(Long idTramite);	
	
	boolean reservaFirmada(Long idTramite);

	public Boolean checkInformeJuridicoFinalizado(Long idTramite);	
	
	public Boolean checkFechaVenta(Long idTramite);

	public Boolean esBH(String idExpediente);

	DtoModificarCompradores vistaADtoModCompradores(VBusquedaDatosCompradorExpediente vista);

	/**
	 * Este método envia un correo a los receptores Gestor comercial alquiler, Supervisor comercial alquiler y Prescriptor
	 * con el suerpo del mensaje que se recibe por parametro.
	 * 
	 * @param cuerpoEmail: Contenido del cuerpo del mensaje.
	 * @param idExpediente: Id del expediente al que hace referencia.
	 * @return Devuelve True si el mensaje ha sido enviado y false si no ha sido asi.
	 */
	boolean enviarCorreoComercializadora(String cuerpoEmail, Long idExpediente);	
	
	public List<DDTipoCalculo> getComboTipoCalculo(Long idExpediente);
	
	/**
	 * Este método comprueba si el expediente ya contiene un documento del tipo y subtipo indicado
	 * 
	 * @param WebFileItem: Datos del documento.
	 * @param ExpedienteComercial: Expediente Comercial al que hace referencia.
	 * @return Devuelve True si existe el documento.
	 */
	
	public Boolean existeDocSubtipo(WebFileItem fileItem, ExpedienteComercial expedienteComercialEntrada) throws Exception;
	
	/**
	 * Método que obtiene el histórico de scoring del expediente comercial de alquiler.
	 * 
	 * @param idExpediente
	 * @return
	 */
	public List<DtoExpedienteHistScoring> getHistoricoScoring(Long idScoring);
	
	/**
	 * Método que guarda la pestaña Scoring el bloque detalle.
	 * @param dto
	 * @param idEntidad
	 * @return
	 */
	public boolean saveExpedienteScoring(DtoExpedienteScoring dto, Long idEntidad);

	/**
	 * Metodo que envia correo a a el asegurador informando de la firma de contrato de alquiler
	 * @param idExpediente
	 * @return
	 */
	public boolean enviarCorreoAsegurador(Long idExpediente);
	
	
	/**
	 * Método que envía un correo para avisar de la fecha prevista para la entrega de llaves del alquiler
	 * @param idExpediente
	 * @return
	 */
	public boolean enviarCorreoGestionLlaves(Long idExpediente);
	
}