package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.framework.paradise.utils.DtoPage;
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
	     * Método que recupera una página de textos de la oferta de un expediente
	     * @param dto
	     * @param id
	     * @return
	     */
		public DtoPage getListTextosOfertaById(DtoTextosOferta dto, Long id);
	    
	    
	    
	   
}

