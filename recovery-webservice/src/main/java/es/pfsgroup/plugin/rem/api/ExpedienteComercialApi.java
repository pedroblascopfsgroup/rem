package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoExpediente;
import es.pfsgroup.plugin.rem.model.DtoCondiciones;
import es.pfsgroup.plugin.rem.model.DtoDatosBasicosOferta;
import es.pfsgroup.plugin.rem.model.DtoEntregaReserva;
import es.pfsgroup.plugin.rem.model.DtoFichaExpediente;
import es.pfsgroup.plugin.rem.model.DtoGastoExpediente;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoReserva;
import es.pfsgroup.plugin.rem.model.DtoTextosOferta;
import es.pfsgroup.plugin.rem.model.EntregaReserva;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.VBusquedaDatosCompradorExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;


public interface ExpedienteComercialApi {
    
		/**
	     * Recupera el ExpedienteComercial indicado.
	     * @param id Long
	     * @return ExpedienteComercial
	     */
	    public ExpedienteComercial findOne(Long id);
	    

		/**
		 * Método que recupera un conjunto de datos del expediente comercial según su id 
		 * @param id
		 * @param tab
		 * @return Object
		 */
	    public Object getTabExpediente(Long id, String tab);


	    /**
	     * Método que recupera los textos de la oferta de un expediente
	     * @param id
	     * @return
	     */
		public List<DtoTextosOferta> getListTextosOfertaById(Long id);

		
		/**
		 * Método que guarda un texto de oferta para un expediente comercial
		 * @param dto
		 * @param idEntidad id del expediente
		 * @return resultado de la operacion
		 */
		public boolean saveTextoOferta(DtoTextosOferta dto, Long idEntidad);


		/**
		 * Método que guarda la información de la pestaña datos básicos de la oferta
		 * @param dto
		 * @param idExpediente
		 * @return
		 */
		boolean saveDatosBasicosOferta(DtoDatosBasicosOferta dto, Long idExpediente);


		/**
		 * Método que recupera las entregas de una reserva para un expediente
		 * @return
		 */
		public List<DtoEntregaReserva> getListEntregasReserva(Long id);
		
		
		/**
	     * Añadir una Entrega Reserva a un Expediente Comercial
	     * @param entregaReserva
	     * @param idExpedienteComercial
	     * @return
		 * @throws Exception 
	     */
		public boolean addEntregaReserva(EntregaReserva entregaReserva, Long idExpedienteComercial) throws Exception;
		
		/**
	     * Actualizar los valores del Expediente Comercial
	     * @parame xpedienteComercial
	     * @return
	     */
		public boolean update(ExpedienteComercial expedienteComercial);

		/**
		 * Método que recupera las observaciones del expediente comercial
		 * @return
		 */
		public DtoPage getListObservaciones(Long idExpediente, WebDto dto);
		
	    
		/**
	     * Actualiza una observacion
	     * @param dtoObservacion
	     * @return
	     */
		public boolean saveObservacion(DtoObservacion dtoObservacion);

	    /**
	     * Crea una observación
	     * @param dtoObservacion
	     * @param idTrabajo
	     * @return
	     */
		public boolean createObservacion(DtoObservacion dtoObservacion, Long idExpediente);

	    /**
	     * Elimina una observación
	     * @param idObservacion
	     * @return
	     */
		public boolean deleteObservacion(Long idObservacion);
		
		/**
		 * Método que recupera los activos del expediente comercial
		 * @return
		 */
		public DtoPage getActivosExpediente(Long idExpediente);

		/**
		 * Recupera el adjunto del Expediente comercial
		 * @param dtoAdjunto
		 * @return
		 */
		public FileItem getFileItemAdjunto(DtoAdjuntoExpediente dtoAdjunto);
		
		/**
		 * Recupera info de los adjuntos asociados al expediente comercial
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
	     * @param dtoAdjunto
	     * @return
	     */
		public boolean deleteAdjunto(DtoAdjuntoExpediente dtoAdjunto);

		
		/**
		 * Recupera la lista de compradores asociados al expediente
		 * @param idExpediente
		 * @return
		 */
		public Page getCompradoresByExpediente(Long idExpediente, WebDto dto);
		
		/**
		 * Recupera la informacion de un Comprador de un Expediente Comercial
		 * @param idComprador
		 * @return
		 */
		public VBusquedaDatosCompradorExpediente getDatosCompradorById(Long idComprador);

		/**
		 * Método que guarda la información de la pestaña Condicionantes del expediente
		 * @param dto
		 * @param idExpediente
		 * @return
		 */
		boolean saveCondicionesExpediente(DtoCondiciones dto, Long idExpediente);
		
		/**
		 * Método que guarda la información de la pestaña de un comprador del expediente
		 * @param dto
		 * @param idExpediente
		 * @return
		 */
		boolean saveFichaComprador(VBusquedaDatosCompradorExpediente dto);
		
		/**
		 * Método que guarda el comprador como principal
		 * @param idComercial
		 * @param idExpedienteComercial
		 * @return
		 */
		boolean marcarCompradorPrincipal(Long idComprador, Long idExpedienteComercial);

		/**
		 * Método que obtiene el posicionamiento del expediente
		 * @param dto
		 * @param idExpediente
		 * @return
		 */
		public DtoPage getPosicionamientosExpediente(Long idExpediente);
		
		/**
		 * Método que obtiene los comparecientes del expediente
		 * @param dto
		 * @param idExpediente
		 * @return
		 */
		public DtoPage getComparecientesExpediente(Long idExpediente);
		
		/**
		 * Método que obtiene las subsanaciones del expediente
		 * @param dto
		 * @param idExpediente
		 * @return
		 */
		public DtoPage getSubsanacionesExpediente(Long idExpediente);
		
		/**
		 * Método que obtiene los notarios del expediente
		 * @param dto
		 * @param idExpediente
		 * @return
		 */
		public DtoPage getNotariosExpediente(Long idExpediente);

		
		/**
		 * Modifica los datos de una reserva
		 * @param dto
		 * @param idEntidad
		 * @return
		 */
		boolean saveReserva(DtoReserva dto, Long idEntidad);
		
		/**
		 * Método que obtiene los honorarios(gastos) del expediente
		 * @param idExpediente
		 * @return
		 */
		public DtoPage getHonorarios(Long idExpediente);
		
		/**
		 * Método que guarda los honorarios(gastos) del expediente
		 * @param dtoGastoExpediente
		 * @return
		 */
		public boolean saveHonorario(DtoGastoExpediente dtoGastoExpediente);

		
		/**
		 * Método que obtiene el ExpedienteComercial relacionado con una determinada Oferta 
		 * @param idOferta
		 * @return
		 */		
		public ExpedienteComercial expedienteComercialPorOferta (Long idOferta);
	   

		/**
		 * Método que obtiene uno de los estados posibles del ExpedienteComercial 
		 * relacionado con una determinado código
		 * @param codigo
		 * @return
		 */	
		public DDEstadosExpedienteComercial getDDEstadosExpedienteComercialByCodigo (String codigo);
		
		/**
		 * Método que guarda la información de la pestaña Ficha del expediente
		 * @param dto
		 * @param idExpediente
		 * @return
		 */
		boolean saveFichaExpediente(DtoFichaExpediente dto, Long idExpediente);
		
		/**
		 * Método que guarda la información de una entrega de reserva
		 * @param dto
		 * @param idExpediente
		 * @return
		 */
		public boolean saveEntregaReserva(DtoEntregaReserva dto, Long idEntidad);
		
		/**
		 * Método que actualiza la información de una entrega de reserva
		 * @param dto
		 * @param idExpediente
		 * @return
		 */
		public boolean updateEntregaReserva(DtoEntregaReserva dto, Long id);
		
		/**
		 * Método que elimina una entrega de reserva
		 * @param dto
		 * @param idExpediente
		 * @return
		 */
		public boolean deleteEntregaReserva(DtoEntregaReserva dto, Long idEntrega);


		/**
		 * Función que devuelve la propuesta de un comité para un expediente comercial de Bankia
		 * @param idExpediente
		 * @return
		 * @throws Exception 
		 */
		public String consultarComiteSancionador(Long idExpediente) throws Exception;
		
}

