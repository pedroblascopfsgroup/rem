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
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoActivosExpediente;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoExpediente;
import es.pfsgroup.plugin.rem.model.DtoBloqueosFinalizacion;
import es.pfsgroup.plugin.rem.model.DtoCondiciones;
import es.pfsgroup.plugin.rem.model.DtoDatosBasicosOferta;
import es.pfsgroup.plugin.rem.model.DtoEntregaReserva;
import es.pfsgroup.plugin.rem.model.DtoFichaExpediente;
import es.pfsgroup.plugin.rem.model.DtoFormalizacionFinanciacion;
import es.pfsgroup.plugin.rem.model.DtoGastoExpediente;
import es.pfsgroup.plugin.rem.model.DtoListadoGestores;
import es.pfsgroup.plugin.rem.model.DtoNotarioContacto;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoObtencionDatosFinanciacion;
import es.pfsgroup.plugin.rem.model.DtoPosicionamiento;
import es.pfsgroup.plugin.rem.model.DtoReserva;
import es.pfsgroup.plugin.rem.model.DtoTanteoYRetractoOferta;
import es.pfsgroup.plugin.rem.model.DtoTextosOferta;
import es.pfsgroup.plugin.rem.model.DtoUsuario;
import es.pfsgroup.plugin.rem.model.EntregaReserva;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VBusquedaDatosCompradorExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.rest.dto.DatosClienteDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaUVEMDto;
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
	 * Método que obtiene los honorarios(gastos) del expediente
	 * 
	 * @param idExpediente
	 * @return
	 */
	public DtoPage getHonorarios(Long idExpediente);

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
	 * 
	 * @param dto
	 * @param idExpediente
	 * @return
	 */
	public boolean deleteEntregaReserva(DtoEntregaReserva dto, Long idEntrega);

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
	public OfertaUVEMDto createOfertaOVEM(Oferta oferta,ExpedienteComercial expedienteComercial); 
	
	/**
	 * Obtiene la lista de titulares para uvem
	 * @param expedienteComercial
	 * @return
	 */
	public ArrayList<TitularUVEMDto> obtenerListaTitularesUVEM(ExpedienteComercial expedienteComercial);
	
	/**
	 * Método que devuelve los datos de un comprador de Bankia (WebService Ursus) por número de comprador
	 * @param numCompradorUrsus
	 * @return DatosClienteDto
	 */
	public DatosClienteDto buscarNumeroUrsus(String numCompradorUrsus, String tipoDocumento) throws Exception;
	
	/**
	 * Método que devuelve los proveedores filtrados por su tipo de proveedor
	 * @param codigoTipoProveedor
	 * @param nombreBusqueda
	 * @param idActivo
	 * @param dto
	 * @return List<ActivoProveedor>
	 */
	public List<ActivoProveedor> getComboProveedoresExpediente(String codigoTipoProveedor, String nombreBusqueda, String idActivo, WebDto dto);
	
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
	 * @return
	 */
	public InstanciaDecisionDto expedienteComercialToInstanciaDecisionList(ExpedienteComercial expediente, Long porcentajeImpuesto ) throws Exception;

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
	public boolean createBloqueoFormalizacion(DtoBloqueosFinalizacion dto);

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
	public boolean obtencionDatosPrestamo(DtoObtencionDatosFinanciacion dto);

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
	public List<EXTDDTipoGestor> getComboTipoGestor();
	
	/**
	 * Actualiza el importe con el que participa un activo en un expediente
	 * @param Oferta oferta
	 * @return
	 */
	public boolean updateParticipacionActivosOferta(Oferta oferta);
}