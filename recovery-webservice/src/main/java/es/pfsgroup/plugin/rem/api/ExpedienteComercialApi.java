package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.plugin.rem.model.DtoCondiciones;
import es.pfsgroup.plugin.rem.model.DtoDatosBasicosOferta;
import es.pfsgroup.plugin.rem.model.DtoEntregaReserva;
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
		 * Método que guarda la información de la pestaña Condicionantes del expediente
		 * @param dto
		 * @param idExpediente
		 * @return
		 */
		boolean saveCondicionesExpediente(DtoCondiciones dto, Long idExpediente);
		
	    
	    
	    
	   
}

