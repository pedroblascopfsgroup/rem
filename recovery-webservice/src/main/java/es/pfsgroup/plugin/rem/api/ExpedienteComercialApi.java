package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoExpediente;
import es.pfsgroup.plugin.rem.model.DtoCondiciones;
import es.pfsgroup.plugin.rem.model.DtoDatosBasicosOferta;
import es.pfsgroup.plugin.rem.model.DtoEntregaReserva;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoReserva;
import es.pfsgroup.plugin.rem.model.DtoTextosOferta;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;


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
		 * Método que recupera las observaciones del expediente comercial
		 * @return
		 */
		public DtoPage getListObservaciones(Long idExpediente);
		
	    
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
		 * Método que guarda la información de la pestaña Condicionantes del expediente
		 * @param dto
		 * @param idExpediente
		 * @return
		 */
		boolean saveCondicionesExpediente(DtoCondiciones dto, Long idExpediente);
		
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
		 * Método que obtiene los gastos del expediente soportados por el propietario
		 * @param dto
		 * @param idExpediente
		 * @return
		 */
		public DtoPage getGastosSoportadoPropietario(Long idExpediente);
		
		/**
		 * Método que obtiene los gastos del expediente soportados por Haya
		 * @param dto
		 * @param idExpediente
		 * @return
		 */
		public DtoPage getGastosSoportadoHaya(Long idExpediente);

		
		/**
		 * Modifica los datos de una reserva
		 * @param dto
		 * @param idEntidad
		 * @return
		 */
		boolean saveReserva(DtoReserva dto, Long idEntidad);
			
		
	   
}

