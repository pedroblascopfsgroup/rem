package es.pfsgroup.plugin.rem.api;

import java.lang.reflect.InvocationTargetException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.plugin.rem.model.*;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadFinanciera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoDocumentoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.rest.dto.DatosClienteDto;
import es.pfsgroup.plugin.rem.rest.dto.DatosClienteProblemasVentaDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaUVEMDto;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;
import es.pfsgroup.plugin.rem.rest.dto.TitularUVEMDto;
import es.pfsgroup.plugin.rem.restclient.caixabc.ReplicarOfertaDto;

public interface ExpedienteComercialApi {
	/**
	 * Recupera el ExpedienteComercial indicado.
	 *
	 * @param id Long
	 * @return ExpedienteComercial
	 */

	ExpedienteComercial findOne(Long id);

	ExpedienteComercial findOneTransactional(Long id);

	/**
	 * Método que recupera un conjunto de datos del expediente comercial según su id
	 * 
	 *
	 * @param numExpediente
	 * @return ExpedienteComercial
	 */
	ExpedienteComercial findOneByNumExpediente(Long numExpediente);

	/**
	 * Recupera el ExpedienteComercial indicado.
	 *
	 * @param trabajo
	 * @return ExpedienteComercial
	 */
	ExpedienteComercial findOneByTrabajo(Trabajo trabajo);

	/**
	 * Método que recupera un conjunto de datos del expediente comercial según su id
	 *
	 * @param id
	 * @param tab
	 * @return Object
	 */
	Object getTabExpediente(Long id, String tab);

	/**
	 * Método que recupera los textos de la oferta de un expediente
	 *
	 * @param id
	 * @return
	 */
	List<DtoTextosOferta> getListTextosOfertaById(Long id);

	/**
	 * Método que guarda un texto de oferta para un expediente comercial
	 *
	 * @param dto
	 * @param idEntidad id del expediente
	 * @return resultado de la operacion
	 */
	boolean saveTextoOferta(DtoTextosOferta dto, Long idEntidad) throws UserException;

	/**
	 * Método que guarda un Seguro de rentas del expediente comercial y en el historico de rentas
	 *
	 * @param dto
	 * @param idEntidad id del expediente
	 * @return resultado de la operacion
	 */
	boolean saveSeguroRentasExpediente(DtoSeguroRentas dto, Long idEntidad);

	/**
	 * Método que guarda la información de la pestaña datos básicos de la oferta
	 *
	 * @param dto
	 * @param idExpediente
	 * @return
	 * @throws InvocationTargetException 
	 * @throws IllegalAccessException 
	 */
	boolean saveDatosBasicosOferta(DtoDatosBasicosOferta dto, Long idExpediente) throws IllegalAccessException, InvocationTargetException;

	/**
	 * Metodo que guarda la informacion de la pestanya Tanteo y Retracto de la oferta
	 *
	 * @param dto
	 * @param idExpediente
	 * @return
	 */
	boolean saveOfertaTanteoYRetracto(DtoTanteoYRetractoOferta dto, Long idExpediente);

	/**
	 * Método que recupera las entregas de una reserva para un expediente
	 *
	 * @return
	 */
	List<DtoEntregaReserva> getListEntregasReserva(Long id);

	/**
	 * Añadir una Entrega Reserva a un Expediente Comercial
	 *
	 * @param entregaReserva
	 * @param idExpedienteComercial
	 * @return
	 * @throws Exception
	 */
	boolean addEntregaReserva(EntregaReserva entregaReserva, Long idExpedienteComercial) throws Exception;

	/**
	 * Actualizar los valores del Expediente Comercial
	 *
	 * @return
	 * @parame xpedienteComercial
	 */
	boolean update(ExpedienteComercial expedienteComercial,boolean pasaAVendido);

	/**
	 * Actualiza el estado de la dev reserva al codigo dado
	 *
	 * @param expedienteComercial
	 * @param codEstadoReserva
	 * @return
	 */
	boolean updateEstadoDevolucionReserva(ExpedienteComercial expedienteComercial, String codEstadoReserva) throws Exception;

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
	 * @param codEstadoExpedienteComercial
	 * @return
	 */
	boolean updateEstadoExpedienteComercial(ExpedienteComercial expedienteComercial,
			String codEstadoExpedienteComercial) throws Exception;

	/**
	 * Este método devuelve el Expediente Comercial junto con la Reserva al estado
	 * previo a la tarea Resolución Expediente
	 * 
	 * @param idTramite:
	 *            ID del trámite desde el cual se realiza la consulta.
	 * @return Devuelve True si el estado del expdiente comercial es distinto a
	 *         anulado, False si no lo es.
	 * @throws Exception
	 */
	boolean updateExpedienteComercialEstadoPrevioResolucionExpediente(ExpedienteComercial expedienteComercial, String codigoTareaActual, String codigoTareaSalto, Boolean botonDeshacerAnulacion) throws Exception;

	/**
	 * Método que recupera las observaciones del expediente comercial
	 *
	 * @return
	 */
	DtoPage getListObservaciones(Long idExpediente, WebDto dto);

	/**
	 * Actualiza una observacion
	 *
	 * @param dtoObservacion
	 * @return
	 */
	boolean saveObservacion(DtoObservacion dtoObservacion);

	/**
	 * Crea una observación
	 *
	 * @param dtoObservacion
	 * @param idExpediente
	 * @return
	 */
	boolean createObservacion(DtoObservacion dtoObservacion, Long idExpediente);

	/**
	 * Elimina una observación
	 *
	 * @param idObservacion
	 * @return
	 */
	boolean deleteObservacion(Long idObservacion);

	/**
	 * Método que recupera los activos del expediente comercial
	 *
	 * @return
	 */
	DtoPage getActivosExpediente(Long idExpediente);
	
	/**
	 * Método que recupera los activos del expediente comercial para adjuntar en Excel
	 *
	 * @return
	 */
	DtoPage getActivosExpedienteExcel(Long idExpediente, Boolean esExcelActivos);

	/**
	 * Método que recupera los tipos de documento del expediente comercial
	 *
	 * @return
	 */
	List<DtoTipoDocExpedientes> getTipoDocumentoExpediente(String tipoExpediente);

	/**
	 * Método que recupera los subtipos de documento posibles para adjuntar en el Expediente Comercial
	 * 	
	 * @param idExpediente, tipoExpediente
	 * @return listado de archivos adjuntos
	 */
	List <DtoTipoDocExpedientes> getSubtipoDocumentosExpedientes(Long idExpediente, String valorCombo);
		
	/**
	 * Recupera el adjunto del Expediente comercial
	 *
	 * @param dtoAdjunto
	 * @return
	 */
	FileItem getFileItemAdjunto(DtoAdjuntoExpediente dtoAdjunto);

	/**
	 * Recupera info de los adjuntos asociados al expediente comercial
	 *
	 * @param id
	 * @return
	 */
	List<DtoAdjuntoExpediente> getAdjuntos(Long id);

	/**
	 * @param fileItem
	 * @return
	 */
	String upload(WebFileItem fileItem) throws Exception;

	/**
	 * Sube un adjunto del expediente comercial
	 *
	 * @param dtoAdjunto
	 * @return
	 */
	boolean deleteAdjunto(DtoAdjunto dtoAdjunto);

	/**
	 * Recupera la lista de compradores asociados al expediente
	 *
	 * @param idExpediente
	 * @return
	 */
	Page getCompradoresByExpediente(Long idExpediente, WebDto dto);

	/**
	 * Recupera la informacion de un Comprador de un Expediente Comercial
	 *
	 * @param idCom
	 * @param idExp
	 * @return
	 */
	VBusquedaDatosCompradorExpediente getDatosCompradorById(Long idCom, Long idExp);

	/**
	 * Recupera la informacion de un Comprador independientemente del Expediente
	 * Comercial asociado
	 * 
	 * @param idCom
	 * @return
	 */
	VBusquedaDatosCompradorExpediente getDatCompradorById(Long idCom);

	/**
	 * Método que guarda la información de la pestaña Condicionantes del expediente
	 *
	 * @param dto
	 * @param idExpediente
	 * @return
	 */
	boolean saveCondicionesExpediente(DtoCondiciones dto, Long idExpediente);

	/**
	 * Método que guarda la información de la pestaña de un comprador del expediente
	 * 
	 * @param expediente
	 * @return
	 */
	Reserva createReservaExpediente(ExpedienteComercial expediente);

	/**
	 * Método que guarda la información de la pestaña de un comprador del expediente
	 *
	 * @param dto
	 * @return
	 */
	boolean saveFichaComprador(VBusquedaDatosCompradorExpediente dto);
	
	//boolean crearCompradorExpedienteComercial(VBusquedaDatosCompradorExpediente dto);

	/**
	 * Verificación de adjunto existente en el expediente comercial, buscando por subtipo de documento. Esta verificación está pensada para trámites (ya que se identifica el trabajo)
	 *
	 * @param idTrabajo
	 * @param codigoSubtipoDocumento
	 *            Código del subtipo de documento del expediente
	 * @return
	 */
	Boolean comprobarExisteAdjuntoExpedienteComercial(Long idTrabajo, String codigoSubtipoDocumento);

	/**
	 * Método que guarda el comprador como principal
	 *
	 * @param idComprador
	 * @param idExpedienteComercial
	 * @return
	 */
	boolean marcarCompradorPrincipal(Long idComprador, Long idExpedienteComercial);

	/**
	 * Método que obtiene el posicionamiento del expediente
	 *
	 * @param idExpedienteComercial
	 * @param webDto
	 * @return
	 */

	public DtoPage getPosicionamientosExpediente(Long idExpediente);


	/**
	 * Método que obtiene la tarea de definición oferta
	 *
	 * @param dto
	 * @param idExpediente
	 * @return
	 */
	String getTareaDefinicionDeOferta(Long idExpedienteComercial, WebDto webDto);

	/**
	 * Método que obtiene los comparecientes del expediente
	 *
	 * @param idExpediente
	 * @return
	 */
	DtoPage getComparecientesExpediente(Long idExpediente);

	/**
	 * Método que obtiene las subsanaciones del expediente
	 *
	 * @param idExpediente
	 * @return
	 */
	DtoPage getSubsanacionesExpediente(Long idExpediente);

	/**
	 * Método que obtiene los notarios del expediente
	 *
	 * @param idProveedor
	 * @return
	 */
	List<DtoNotarioContacto> getContactosNotario(Long idProveedor);

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
	 *
	 * @param oferta
	 * @param activo
	 * @return
	 */
	List<DtoGastoExpediente> getHonorariosActivoByOfertaAceptada(Oferta oferta, Activo activo);

	/**
	 * Método que obtiene los honorarios(gastos) del expediente
	 *
	 * @param idExpediente
	 * @return
	 */

	List<DtoHstcoSeguroRentas> getHstcoSeguroRentas(Long idExpediente);

	/**
	 * Método que obtiene los honorarios(gastos) del expediente
	 *
	 * @param idExpediente
	 * @return
	 */
	List<DtoGastoExpediente> getHonorarios(Long idExpediente, Long idActivo);

	/**
	 * Método que obtiene el historico de condiciones de un expediente comercial
	 *
	 * @param idExpediente
	 * @return
	 */
	List<DtoHistoricoCondiciones> getHistoricoCondiciones(Long idExpediente);

	/**
	 * Método que guarda los honorarios(gastos) del expediente
	 *
	 * @param dtoGastoExpediente
	 * @return
	 */
	boolean saveHonorario(DtoGastoExpediente dtoGastoExpediente);

	/**
	 * Método que obtiene el ExpedienteComercial relacionado con una determinada Oferta
	 *
	 * @param idOferta
	 * @return
	 */
	ExpedienteComercial expedienteComercialPorOferta(Long idOferta);

	/**
	 * Método que obtiene uno de los estados posibles del ExpedienteComercial relacionado con una determinado código
	 *
	 * @param codigo
	 * @return
	 */
	DDEstadosExpedienteComercial getDDEstadosExpedienteComercialByCodigo(String codigo);

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
	 * @param idEntidad
	 * @return
	 */
	boolean saveEntregaReserva(DtoEntregaReserva dto, Long idEntidad);

	/**
	 * Método que actualiza la información de una entrega de reserva
	 *
	 * @param dto
	 * @param id
	 * @return
	 */
	boolean updateEntregaReserva(DtoEntregaReserva dto, Long id);

	/**
	 * Método que elimina una entrega de reserva
	 *
	 * @param idEntrega
	 * @return
	 */
	boolean deleteEntregaReserva(Long idEntrega);

	/**
	 * Función que devuelve la propuesta de un comité para un expediente comercial de Bankia
	 *
	 * @param idExpediente
	 * @return
	 * @throws Exception
	 */
	String consultarComiteSancionador(Long idExpediente) throws Exception;

	/**
	 * Crea un registro de posicionamiento
	 *
	 * @param dto
	 * @param idEntidad
	 * @return
	 */
	boolean createPosicionamiento(DtoPosicionamiento dto, Long idEntidad);

	/**
	 * Actualiza un registro de posicionamiento
	 *
	 * @param dto
	 * @return
	 */
	boolean savePosicionamiento(DtoPosicionamiento dto);

	/**
	 * Elimina un registro de posicionamiento
	 *
	 * @param idPosicionamiento
	 * @return
	 */
	boolean deletePosicionamiento(Long idPosicionamiento);

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
	 *
	 * @param oferta
	 * @return
	 */

	OfertaUVEMDto createOfertaOVEM(Oferta oferta, ExpedienteComercial expedienteComercial) throws Exception;

	/**
	 * Obtiene la lista de titulares para uvem
	 *
	 * @param expedienteComercial
	 * @return
	 */
	ArrayList<TitularUVEMDto> obtenerListaTitularesUVEM(ExpedienteComercial expedienteComercial) throws Exception;

	/**
	 * Método que devuelve los datos de un comprador de Bankia (WebService Ursus) por número de comprador
	 *
	 * @param numCompradorUrsus
	 * @param idExpediente
	 * @return DatosClienteDto
	 */
	DatosClienteDto buscarNumeroUrsus(String numCompradorUrsus, String tipoDocumento, String idExpediente) throws Exception;

	/**
	 * Método que devuelve los proveedores filtrados por su tipo de proveedor
	 *
	 * @param codigoTipoProveedor
	 * @param nombreBusqueda
	 * @param idActivo
	 * @param dto
	 * @return Page
	 */
	Page getComboProveedoresExpediente(String codigoTipoProveedor, String nombreBusqueda, String idActivo, WebDto dto);

	/**
	 * Crea un registro de honorarios (gasto_expediente)
	 *
	 * @param dto
	 * @param idEntidad
	 * @return
	 */
	boolean createHonorario(DtoGastoExpediente dto, Long idEntidad);

	/**
	 * Crea un registro de historicoCondiciones
	 *
	 * @param dto
	 * @return
	 */
	boolean createHistoricoCondiciones(DtoHistoricoCondiciones dto, Long idEntidad);

	/**
	 * Elimina un registro de honorario (gasto_expediente)
	 *
	 * @param idHonorario
	 * @return
	 */
	boolean deleteHonorario(Long idHonorario);

	/**
	 * Elimina la relación entre un comprador y un expediente
	 *
	 * @param idExpediente
	 * @param idComprador
	 * @return
	 */
	boolean deleteCompradorExpediente(Long idExpediente, Long idComprador);

	/**
	 * Método que actualiza la información de los activos de un expediente
	 *
	 * @param dto
	 * @param id
	 * @return
	 */
	boolean updateActivoExpediente(DtoActivosExpediente dto, Long id);


	/**
	 * Método que construye un InstanciaDecisionDto para el envío de ofertas a Bankia a través de WS
	 *
	 * @param expediente expedienteComercial de la oferta
	 * @param porcentajeImpuesto del activo de la oferta.
	 * @param codComiteSuperior del expediente.
	 * @return
	 */
	InstanciaDecisionDto expedienteComercialToInstanciaDecisionList(ExpedienteComercial expediente, Double porcentajeImpuesto, String codComiteSuperior) throws Exception;

	/**
	 * Este método obtiene una lista de bloqueos formalización por el ID del expediente recibido.
	 *
	 * @param dto : dto con el ID de expediente a filtrar la lista de bloqueos.
	 * @return Devuelve una lista de 'DtoBloqueosFinalizacion' con los datos encontrados.
	 */
	List<DtoBloqueosFinalizacion> getBloqueosFormalizacion(DtoBloqueosFinalizacion dto);

	/**
	 * Este método genera un nuevo bloqueo formalización con los datos obtenidos.
	 *
	 * @param dto : dto con los datos del nuevo bloqueo.
	 * @return Devuelve True si la operación ha sido satisfactoria.
	 */
	boolean createBloqueoFormalizacion(DtoBloqueosFinalizacion dto, Long idActivo);

	/**
	 * Este método establece un bloqueo por el ID de bloqueo obtenido a borrado, así como el nombre de usuario que realiza la operación y la fecha.
	 *
	 * @param dto : dto con los datos del nuevo bloqueo.
	 * @return Devuelve True si la operación ha sido satisfactoria.
	 */
	boolean deleteBloqueoFormalizacion(DtoBloqueosFinalizacion dto);

	/**
	 * Devuelve el expediente de la oferta en caso de que exista.
	 * @param oferta
	 * @return
	 */
	ExpedienteComercial findOneByOferta(Oferta oferta);

	/**
	 * Devuelve la descripción de un comité dado su código
	 * @param codigo
	 * @return
	 */
	DDComiteSancion comiteSancionadorByCodigo(String codigo);

	/**
	 * Este método obtiene el expediente comercial del activo indicado, el cual no se encuentre en los siguientes estados: -En trámite. -Pendiente Sanción. -Contraorfertado. -Vendido. -Denegado.
	 * -Anulado.
	 *
	 * @param activo
	 * @return
	 */
	ExpedienteComercial getExpedienteComercialResetPBC(Activo activo);

	/**
	 * Este método recibe un expediente comercial, llama al WS para obtener los datos del préstamo y los guarda en el expediente.
	 *
	 * @param dto
	 */
	Double obtencionDatosPrestamo(DtoObtencionDatosFinanciacion dto) throws Exception;

	/**
	 * Este método obtiene los datos del apartado 'Financiación' de la tab 'Formalización' del expediente.
	 *
	 * @param dto : DTO con el ID de expediente a filtrar.
	 * @return
	 */
	DtoFormalizacionFinanciacion getFormalizacionFinanciacion(DtoFormalizacionFinanciacion dto);

	/**
	 * Este método guarda los cambios del apartado 'Financiación' de la tab 'Formalización' del expediente.
	 *
	 * @param dto : DTO con los cambios a guardar.
	 * @return Devuelve True si la operación ha sido satisfactoria.
	 */
	boolean saveFormalizacionFinanciacion(DtoFormalizacionFinanciacion dto);

	/**
	 * Devuelve un listado de usuarios según el tipo de gestor pasado por parámetro
	 *
	 * @param idTipoGestor
	 * @return
	 */
	List<DtoUsuario> getComboUsuarios(Long idTipoGestor);

	/**
	 * Inserta un gestor en el expediente comercial
	 *
	 * @param dto
	 * @return
	 */
	Boolean insertarGestorAdicional(GestorEntidadDto dto);

	/**
	 * Recupera los gestores del expediente
	 *
	 * @param idExpediente
	 * @return
	 */
	List<DtoListadoGestores> getGestores(Long idExpediente);

	/**
	 * Devuelve una lista de los tipos de gestor correspondientes a los expedientes comerciales
	 *
	 * @return
	 */
	List<EXTDDTipoGestor> getComboTipoGestor(Long idExpediente);

	/**
	 * Actualiza el importe con el que participa un activo en un expediente
	 *
	 * @param oferta Oferta
	 * @return
	 */
	boolean updateParticipacionActivosOferta(Oferta oferta);

	/**
	 * Comprueba si el activo tiene un expediente comercial vivo, es decir, que no tenga ninguna tarea activa.
	 *
	 * @param activo
	 * @return
	 */
	boolean isExpedienteComercialVivoByActivo(Activo activo);

	/**
	 * Crea un gasto expediente
	 *
	 * @param expediente
	 * @param oferta
	 * @param activo
	 * @param codigoColaboracion
	 * @return
	 * @throws InvocationTargetException 
	 * @throws IllegalAccessException 
	 */
	public List<GastosExpediente> creaGastoExpediente(ExpedienteComercial expediente, Oferta oferta, Activo activo) throws IllegalAccessException, InvocationTargetException;

	/**
	 * Devuelve los activos de un expediente dado, para mostrarlos en un combo
	 * 
	 * @param idExpediente
	 * @return
	 */
	List<DtoActivosExpediente> getComboActivos(Long idExpediente);

	/**
	 * Este método obtiene una lista de clientes URSUS en base al número de documento y el tipo de documento.
	 *
	 * @param numeroDocumento : número de documento del cliente.
	 * @param tipoDocumento : tipo de documento del cliente.
	 * @param idExpediente : idExpediente
	 * @return Devuelve una lista con los clientes encontrados por el servicio.
	 */
	public List<DatosClienteDto> buscarClientesUrsus(String numeroDocumento, String tipoDocumento, String idExpediente)
			throws Exception;

	/**
	 * Este método obtiene los detalles de cliente en base al número URSUS recibido.
	 *
	 * @param numeroUrsus : número URSUS del cliente.
	 * @param idExpediente : idExpediente
	 * @return Devuelve todos los detalles del cliente encontrados por el servicio.
	 * @throws Exception
	 *             Devuelve excepcion si la conexion no ha sido satisfactoria.
	 */
	DatosClienteDto buscarDatosClienteNumeroUrsus(String numeroUrsus, String idExpediente) throws Exception;

	/*
	 * Este método permite insertar una lista con los 'Problemas con la venta' en el grid de Cliente Ursus
	 * 
	 * @param numeroDocumento : número de documento del cliente.
	 * @param tipoDocumento : tipo de documento del cliente.
	 * @param idExpediente : idExpediente
	 * @return Devuelve una lista con los 'Problemas on la venta'
	 */
	public List<DatosClienteProblemasVentaDto> buscarProblemasVentaClienteUrsus(String numeroDocumento, String idExpediente) throws Exception;
	
	/**
	 * Este método calcula el importe de reserva para un expediente si se dan las condiciones: El expediente tiene reserva. La reserva tiene el cálculo de tipo porcentaje. Entonces mira si la oferta
	 * tiene importe contraoferta y utiliza éste importe, si no utiliza el importe de la oferta.
	 *
	 * @param expediente : expediente comercial.
	 */
	void actualizarImporteReservaPorExpediente(ExpedienteComercial expediente);

	/**
	 * Este método calcula y actualiza el importe por cada honorario(GastoExpediente) de un Expediente. Sólo se actualizan los honorarios cuyos tipos de cálculo es 'porcentaje'.
	 *
	 * @param idTramite: ID del trámite.
	 * @return devuelve la lista de los honorarios calculados
	 */
	List<GastosExpediente> actualizarHonorariosPorExpediente(Long idTramite);

	String uploadDocumento(WebFileItem fileItem, Long idDocRestClient, ExpedienteComercial expedienteComercialEntrada, String matricula) throws Exception;

	/**
	 * Este método devuelve True si la suma de todos los importes de participación de los activos involucrados en el expediente suman lo mismo que el importe total de expediente. False si no
	 * coinciden. El importe del expediente se saca en primer lugar del importe contra oferta, si no se encuentra establecido lo obtiene del importe de la oferta.
	 *
	 * @param idExpediente: ID del expediente comercial para comprobar su importe.
	 * @return Devuelve True si los importes coinciden, False si no.
	 */
	Boolean checkImporteParticipacion(Long idExpediente);

	/**
	 * Este método obtiene un expediente comercial en base a un Activo.
	 *
	 * @param activo: acivo al que buscar el expediente comercial al que pertenece.
	 * @return Devuelve un expediente comercial.
	 */
	ExpedienteComercial getExpedientePorActivo(Activo activo);

	/**
	 * Obtiene los tanteos para un activo en un expediente
	 *
	 * @param idExpediente
	 * @param idActivo
	 * @return
	 */
	List<DtoTanteoActivoExpediente> getTanteosPorActivoExpediente(Long idExpediente, Long idActivo);

	/**
	 * Guardar tanteo activo
	 *
	 * @param tanteoActivoDto
	 * @return
	 */
	boolean guardarTanteoActivo(DtoTanteoActivoExpediente tanteoActivoDto);

	/**
	 * Borrar tanteo activo
	 *
	 * @param idTanteo
	 * @return
	 */
	boolean deleteTanteoActivo(Long idTanteo);

	/**
	 * Obitene los condicionenates del activo en el exp comercial
	 *
	 * @param idExpediente
	 * @param idActivo
	 * @return
	 */
	DtoCondicionesActivoExpediente getCondicionesActivoExpediete(Long idExpediente, Long idActivo);

	/**
	 * Guarda las condiciones informadas de un activo en un expediente comercial
	 *
	 * @param condiciones
	 * @return
	 */
	boolean guardarCondicionesActivoExpediente(DtoCondicionesActivoExpediente condiciones);

	/**
	 * Obtiene la fecha de emisión del informe jurídico
	 *
	 * @param idExpediente
	 * @param idActivo
	 * @return
	 */
	DtoInformeJuridico getFechaEmisionInfJuridico(Long idExpediente, Long idActivo);

	/**
	 * Guarda el informe jurídico
	 *
	 * @param dto
	 * @return
	 */
	boolean guardarInformeJuridico(DtoInformeJuridico dto);

	boolean updateBloqueoFormalizacion(DtoBloqueosFinalizacion dto);
	
	/**
	 * Devuelve true si el expediente está bloqueado y false en caso contrario
	 *
	 * @param idTramite
	 * @return
	 */
	boolean checkExpedienteBloqueado(Long idTramite);

	/**
	 * Actualiza la Fecha vencimiento reserva con la Fecha resolucion + 40 días. Esto se hace en caso que algún activo esté sujeto a tanteo y todos los activos tengan resolución tanteo = Renunciado.
	 * Debe recibir al menos uno de los dos parámetros de entrada.
	 *
	 * @param tanteoActivo
	 * @param tanteosActivo
	 * @return
	 */
	public void actualizarFVencimientoReservaTanteosRenunciados(TanteoActivoExpediente tanteoActivo,
			List<TanteoActivoExpediente> tanteosActivo);

	/**
	 * Devuelve true si el expediente asociado al trabajo está sancionado por el comite de Haya_Sareb
	 *
	 * @param trabajo
	 * @return
	 */
	boolean isComiteSancionadorHaya(Trabajo trabajo);

	/**
	 * Comprueba que el precio mínimo del activo (o activos en agrupaciones) es inferior del importe del expediente para comite sancionador Haya. En tal caso devuelve un true
	 *
	 * @param idTramite
	 * @return
	 */
	boolean importeExpedienteMenorPreciosMinimosActivos(Long idTramite);

	/**
	 * Crea las condiciones iniciales para un Activo-Expediente. Se le pasa el activo por parametro porque no siempre coincidira con el activo principal de la oferta (relacionado con expediente)
	 *
	 * @param activo
	 * @param expediente
	 * @return
	 */
	CondicionesActivo crearCondicionesActivoExpediente(Activo activo, ExpedienteComercial expediente);
	
	/**
	 * Crea las condiciones iniciales para un Activo-Expediente. Se le pasa el activo por parametro porque no siempre coincidira con el activo principal de la oferta (relacionado con expediente)
	 *
	 * @param idActivo
	 * @param expediente
	 * @return
	 */
	CondicionesActivo crearCondicionesActivoExpediente(Long idActivo, ExpedienteComercial expediente);

	/**
	 * Comprueba que todos los compradores tengan numero URSUS
	 *
	 * @param idTramite
	 * @return boolean
	 */
	boolean checkCompradoresTienenNumeroUrsus(Long idTramite);

	/**
	 * Envia todos los compradores(titulares) a UVEM
	 *
	 * @param idExpediente
	 * @return void
	 */
	void enviarTitularesUvem(Long idExpediente) throws Exception;

	/**
	 * Envia todos los honorarios a UVEM
	 *
	 * @param idExpediente
	 * @return void
	 */
	void enviarHonorariosUvem(Long idExpediente) throws Exception;

	/**
	 * Actualiza la reserva y el expediente al recibir un resol de devolucion
	 *
	 * @param expedienteComercial
	 * @param dto ResolucionComiteDto
	 * @return
	 */
	boolean updateEstadosResolucionDevolucion(ExpedienteComercial expedienteComercial, ResolucionComiteDto dto);

	/**
	 * Actualiza la reserva y el expediente al recibir un resol de no devolucion
	 *
	 * @param expedienteComercial
	 * @param dto ResolucionComiteDto
	 * @return
	 */
	boolean updateEstadosResolucionNoDevolucion(ExpedienteComercial expedienteComercial, ResolucionComiteDto dto);

	/**
	 * Devuelve la subcartera del expediente Lo hace a través del primer activo del expediente
	 *
	 * @param idExpediente
	 * @return
	 */
	DDSubcartera getCodigoSubCarteraExpediente(Long idExpediente);

	/**
	 * Este método comprueba, desde un ID de trámite, si el expediente comercial se encuentra en un estado distinto a anulado.
	 *
	 * @param idTramite: ID del trámite desde el cual se realiza la consulta.
	 * @return Devuelve True si el estado del expdiente comercial es distinto a anulado, False si no lo es.
	 */
	boolean checkEstadoExpedienteDistintoAnulado(Long idTramite);

	void enviarCondicionantesEconomicosUvem(Long idExpediente) throws Exception;

	boolean checkExpedienteFechaChequeLiberbank(Long idTramite);

	boolean reservaFirmada(Long idTramite);

	Boolean checkInformeJuridicoFinalizado(Long idTramite);

	Boolean checkFechaVenta(Long idTramite);

	Boolean esBH(Long idExpediente);

	DtoModificarCompradores vistaADtoModCompradores(VBusquedaDatosCompradorExpediente vista);

	/**
	 * Este método envia un correo a los receptores Gestor comercial alquiler, Supervisor comercial alquiler y Prescriptor con el suerpo del mensaje que se recibe por parametro.
	 *
	 * @param cuerpoEmail:
	 *            Contenido del cuerpo del mensaje.
	 * @param idExpediente:
	 *            Id del expediente al que hace referencia.
	 * @return Devuelve True si el mensaje ha sido enviado y false si no ha sido
	 *         asi.
	 */
	boolean enviarCorreoComercializadora(String cuerpoEmail, Long idExpediente);

	List<DDTipoCalculo> getComboTipoCalculo(Long idExpediente);

	/**
	 * Este método comprueba si el expediente ya contiene un documento del tipo y
	 * subtipo indicado
	 *
	 * @param fileItem: Datos del documento.
	 * @param expedienteComercialEntrada: Expediente Comercial al que hace referencia.
	 * @return Devuelve True si existe el documento.
	 */

	Boolean existeDocSubtipo(WebFileItem fileItem, ExpedienteComercial expedienteComercialEntrada)
			throws Exception;

	/**
	 * Método que obtiene el histórico de scoring del expediente comercial de
	 * alquiler.
	 *
	 * @param idScoring
	 * @return
	 */
	List<DtoExpedienteHistScoring> getHistoricoScoring(Long idScoring);

	/**
	 * Método que guarda la pestaña Scoring el bloque detalle.
	 * 
	 * @param dto
	 * @param idEntidad
	 * @return
	 */
	boolean saveExpedienteScoring(DtoExpedienteScoring dto, Long idEntidad);

	/**
	 * Metodo que envia correo a a el asegurador informando de la firma de contrato de alquiler
	 *
	 * @param idExpediente
	 * @return
	 */
	boolean enviarCorreoAsegurador(Long idExpediente);

	/**
	 * Método que envía un correo para avisar de la fecha prevista para la entrega de llaves del alquiler
	 *
	 * @param idExpediente
	 * @param posicionamiento
	 * @param envio
	 * @return
	 */
	boolean enviarCorreoGestionLlaves(Long idExpediente, Posicionamiento posicionamiento, int envio);

	/**
	 * Método que saca una lista de estados del expediente segun si es de tipo venta o de tipo alquiler
	 *
	 * @param idEstado
	 * @return
	 */
	List<DtoDiccionario> getComboExpedienteComercialByEstado(String idEstado);

	/**
	 * Metodo que envia correo al gestor comercial notificándole que se ha posicionado una oferta
	 *
	 * @param idExpediente
	 * @param posicionamiento
	 * @return
	 */
	boolean enviarCorreoPosicionamientoFirma(Long idExpediente, Posicionamiento posicionamiento);

	/**
	 * Metodo que envia correo al prescriptor de la oferta notificándole que se han subido a REM los documentos necesarios para la firma del contrato.
	 *
	 * @param idExpediente
	 * @return
	 */
	boolean enviarCorreoSubidaDeContrato(Long idExpediente);

	/**
	 * Metodo que comprueba si el documento Precontrato está subido al expediente
	 *
	 * @param tareaExterna
	 * @return
	 */
	boolean checkPrecontratoSubido(TareaExterna tareaExterna);
	
	/**
	 * Método que saca el expediente comercial a partir de una tarea externa
	 *
	 * @param tareaExterna
	 * @return 
	 */
	ExpedienteComercial tareaExternaToExpedienteComercial(TareaExterna tareaExterna);

	String getCodigoCarteraExpediente(Long idExpediente);

	DtoPage getActivosExpedienteVista(Long idExpediente);

	Long getIdByNumExpOrNumOfr(Long numBusqueda, String campo);

	Long getNumExpByNumOfr(Long numBusqueda);

	boolean savePlusvaliaVenta(DtoPlusvaliaVenta dto, Long idExpediente);

	DtoExpedienteComercial getExpedienteComercialByOferta(Long numOferta);

	/**
	 * Metodo que comprueba si el documento Contrato está subido al expediente
	 *
	 * @param tareaExterna
	 * @return
	 */
	boolean checkContratoSubido(TareaExterna tareaExterna);

	/**
	 * @param idExpediente
	 * @return bool con el estado Ocupado SI/NO del tramite comercial de alquiler
	 */
	boolean checkEstadoOcupadoTramite(Long idExpediente);

	boolean checkConTituloTramite(Long idTramite);
	
	List<DtoPropuestaAlqBankia> getListaDtoPropuestaAlqBankiaByExpId (Long ecoId);

	DtoModificarCompradores vistaCrearComprador(VBusquedaDatosCompradorExpediente vista); //QUA

	boolean checkConOpcionCompra(TareaExterna tareaExterna);
	
	public DtoAviso getAvisosExpedienteById(Long id);

	Long getCompradorIdByDocumento(String dniComprador, String codtipoDoc);

	List<DtoActivosExpediente> getActivosPropagables(Long idExpediente);

	boolean guardarCondicionesActivosExpediente(DtoCondicionesActivoExpediente condiciones);

	boolean esAgora(TareaExterna tareaExterna);

	boolean checkDepositoRelleno(TareaExterna tareaExterna);

	boolean checkDepositoDespublicacionSubido(TareaExterna tareaExterna);

	boolean esApple(TareaExterna tareaExterna);
	/*
	 * Comprobación de los campos de los compradores en una oferta de venta para poder avanzar la tarea.
	 */
	boolean checkCamposComprador(TareaExterna tareaExterna);
	
	public Boolean checkPaseDirectoPendDevol(TareaExterna tareaExterna);

	boolean checkInquilinos(TareaExterna tareaExterna);

	FileItem getAdvisoryNote();

	boolean checkAmConUasConOfertasVivas(TareaExterna tareaExterna);

	boolean hayDiscrepanciasClientesURSUS(Long idExpediente);
	
	boolean hayProblemasURSUS(Long idExpediente);
	
	Boolean modificarDatosUnCompradorProblemasURSUS( DtoSlideDatosCompradores dto) throws Exception;
	
	public void finalizarTareaValidacionClientes (ExpedienteComercial expedienteComercial);

	boolean existeComprador(String numDoc);
	
	List<VListadoOfertasAgrupadasLbk> getListActivosAgrupacionById(Long idOferta);
	
	public List<DtoDiccionario> calcularGestorComercialPrescriptor(Long idExpediente);

	List<VReportAdvisoryNotes> getAdvisoryNotesByOferta(Oferta oferta);

	boolean esYubai(TareaExterna tareaExterna);
	
	boolean checkContabilizacionReserva(TareaExterna tareaExterna);

	/*
	 * Devuelve el comité propuesto a partir de un id de expediente
	 * @param idExpediente
	 * @return DDComiteSancion
	 */
	DDComiteSancion comitePropuestoByIdExpediente(Long idExpediente) throws Exception;

	/*
	 * Devuelve el comité propuesto a partir de un id de oferta comercial. Utiliza el método comitePropuestoByIdExpediente
	 * @param idOferta
	 * @return DDComiteSancion
	 */
	DDComiteSancion comitePropuestoByIdOferta(Long idOferta) throws Exception;

	boolean esOfertaDependiente(Long oferta);

	DtoOferta searchOfertaCodigo(String numOferta, String id, String esAgrupacion);
	
	boolean checkExpedienteFechaCheque(Long idTramite);

	boolean actualizarGastosExpediente(ExpedienteComercial expedienteComercial, Oferta oferta, Activo activo) throws IllegalAccessException, InvocationTargetException;

	List<GastosExpediente> getListaGastosExpedienteByIdExpediente(Long idExpediente);

	boolean esDivarian(TareaExterna tareaExterna);

	/**
	 * Metodo que comprueba si la entidad tiene subcartera Omega
	 *
	 * @param tareaExterna
	 * @return boolean
	 */
	boolean esOmega(TareaExterna tareaExterna);

	String doCalculateComiteByExpedienteId(Long idExpediente);
	
	DtoOrigenLead getOrigenLeadList(Long idExpediente);
	
	List<DtoAuditoriaDesbloqueo> getAuditoriaDesbloqueoList(Long idExpediente);
	
	void insertarRegistroAuditoriaDesbloqueo(Long expedienteId, String comentario, Long usuId);

	/*
	 * Devuelve si el expediente ha finalizado la tarea Cierre Económico
	 * @param idOferta
	 * @return DDComiteSancion
	 */
	boolean finalizadoCierreEconomico(ExpedienteComercial expediente);
	
	boolean cumpleCondicionesCrearHonorario(Long idEntidad);

	boolean finalizadoCierreEconomico(Long expedienteId);
	/**
	 * Método para activar compradores de la pestaña 'Compradores' del expediente comercial que están de baja 
	 * @param idExpediente 
	 * @param idCompradorExpediente
	 * @return boolean
	 */
	boolean activarCompradorExpediente(Long idCompradorExpediente, Long idExpediente);
	
	public Boolean getActivoExpedienteEpa(ExpedienteComercial expediente);
	public Boolean getActivoExpedienteAlquilado(ExpedienteComercial expediente);
	public Long uploadDocumentoGestorDocumental(ExpedienteComercial expedienteComercial, WebFileItem webFileItem,
			DDSubtipoDocumentoExpediente subtipoDocumento, String username) throws Exception;

	public void uploadDocumentosBulkGD(List<Long> listaIdsExpedientesCom, WebFileItem webFileItem, String codSubtipoDocumento,
			String username) throws Exception;

	boolean ofertasEnLaMismaTarea(BulkOferta blkOfr);
	
	List<DtoActivosAlquiladosGrid> getActivosAlquilados(Long idExpediente);

	boolean esBBVA(TareaExterna tareaExterna);

	boolean updateActivosAlquilados(DtoActivosAlquiladosGrid dto);

	boolean sacarBulk(Long idExpediente);
	
	String tipoTratamiento(TareaExterna tareaExterna);
	
	Float getPorcentajeCompra(Long idExpediente);
	
	public void getCierreOficinaBankiaById(Long idExpediente);

	/**
	 * Recalcula todos los honorarios
	 *
	 * @param idExpediente
	 * @return void
	 */
	void recalcularHonorarios(Long idExpediente) throws Exception;

	boolean compruebaEstadoNoSolicitadoPendiente(TareaExterna tareaExterna);
	boolean compruebaEstadoPositivoRealDenegado(TareaExterna tareaExterna);

	DtoListadoTramites ponerTareasCarteraCorrespondiente(DtoListadoTramites tramite, ExpedienteComercial expediente);

	boolean esBankia(TareaExterna tareaExterna);

	DtoGridFechaArras getFechaUltimaPropuestaSinContestar(Long idExpediente);

	DtoGridFechaArras getUltimaPropuestaEnviada(Long idExpediente);

	void createOrUpdateUltimaPropuestaEnviada(Long idExpediente, DtoGridFechaArras dto);

	List<DtoGridFechaArras> getFechaArras(Long idExpediente) throws IllegalAccessException, InvocationTargetException;

	Boolean saveFechaArras(DtoGridFechaArras dto) throws ParseException;

	Boolean updateFechaArras(DtoGridFechaArras dto) throws IllegalAccessException, InvocationTargetException;

	DtoPosicionamiento getUltimoPosicionamientoSinContestar(Long idExpediente);

	DtoPosicionamiento getUltimoPosicionamientoEnviado(Long idExpediente);

	void createOrUpdateUltimoPosicionamientoEnviado(Long idExpediente, DtoPosicionamiento dto);

	boolean checkVueltaAtras(Long idTramite);

	DtoRespuestaBCGenerica getUltimaResolucionComiteBC(Long idExpediente);

	WebDto devolverValoresTEB(Long idTarea, String codigoTarea) throws IllegalAccessException, InvocationTargetException;

	void tareaBloqueoScreening(DtoScreening dto) throws IllegalArgumentException, IllegalAccessException;

	void tareaDesbloqueoScreening(DtoScreening dto) throws IllegalArgumentException, IllegalAccessException, Exception;

	DtoScreening dataToDtoScreeningBloqueo(Long numOferta, String motivo, String observaciones);

	DtoScreening dataToDtoScreeningDesBloqueo(Long numOferta, String motivo, String observaciones);

	public void createOrUpdateUltimaPropuesta(Long idExpediente, DtoGridFechaArras dto);
	
	ExpedienteComercial getExpedienteByIdTramite(Long idTramite);

	Posicionamiento getUltimoPosicionamiento(Long idExpediente, Filter filter, boolean noMostrarAnulados);
	
	public FechaArrasExpediente getUltimaPropuesta(Long idExpediente, Filter filter);
	
	boolean isEmpleadoCaixa(Oferta oferta);
	
	boolean doTramitacionAsincrona(Activo activo, Oferta oferta);

	List<DDEntidadFinanciera> getListEntidadFinanciera(Long idExpediente);

	public void createReservaAndCondicionesReagendarArras(ExpedienteComercial expediente, Double importe, Integer mesesFianza, Oferta oferta);
	
	List<DtoActualizacionRenta> getActualizacionRenta(Long idExpediente)throws IllegalAccessException, InvocationTargetException;

	void deleteActualizacionRenta(Long id);

	void addActualizacionRenta(Long idExpediente, DtoActualizacionRenta dto)throws IllegalAccessException, InvocationTargetException;

	void updateActualizacionRenta(Long id, DtoActualizacionRenta dto) throws IllegalAccessException, InvocationTargetException;

	List<DtoRespuestaBCGenerica> getSancionesBk(Long idExpediente);
	
	boolean saveFormalizacionResolucion(DtoFormalizacionResolucion dto);

    ReplicarOfertaDto buildReplicarOfertaDtoFromExpediente(ExpedienteComercial eco);

    ReplicarOfertaDto buildReplicarOfertaDtoFromExpedienteAndArras(ExpedienteComercial eco, String fechaPropuesta);

	ReplicarOfertaDto buildReplicarOfertaDtoFromExpedienteAndCodEstadoAlquiler(ExpedienteComercial eco, String codEstadoAlquiler);

	ReplicarOfertaDto buildReplicarOfertaDtoFromExpedienteAndEstadoArras(ExpedienteComercial eco, String estadoArras);

	ReplicarOfertaDto buildReplicarOfertaDtoFromExpediente(ExpedienteComercial eco, ScoringAlquiler scoring);

    ReplicarOfertaDto buildReplicarOfertaDtoFromExpedienteAndCex(ExpedienteComercial eco, CompradorExpediente cex);

    ReplicarOfertaDto buildReplicarOfertaDtoFromExpedienteAndRespuestaComprador(ExpedienteComercial eco, String codRespuestaComprador);

	void setValoresTEB(WebDto dto, TareaExterna tarea, String codigoTarea)
			throws IllegalArgumentException, IllegalAccessException;
	
	boolean saveGarantiasExpediente(DtoGarantiasExpediente dto, Long idExpediente);
	/**
	 * Método que obtiene la Formalizacion relacionado con un determinado expediente
	 *
	 * @param idExpediente
	 * @return
	 */
	Formalizacion formalizacionPorExpedienteComercial(Long idExpediente);

	void createOrUpdateUltimoPosicionamiento(Long idExpediente, DtoPosicionamiento dto);

	Boolean checkExpedienteBloqueadoPorFuncion(Long idTramite);

	void createGastoRepercutido(DtoGastoRepercutido dto, Long idExpediente);

	List<DtoGastoRepercutido> getGastosRepercutidosList(Long idExpediente);

	void deleteGastoRepercutido(Long idGastoRepercutido);

	DtoScoringGarantias getScoringGarantias(Long idExpediente);

}
