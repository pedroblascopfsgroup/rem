package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.rem.model.ActivoCargas;


public interface ActivoCargasApi {

	    @BusinessOperationDefinition("activoCargasManager.get")
	    public ActivoCargas get(Long id);
	    
	    @BusinessOperationDefinition("activoCargasManager.saveOrUpdate")
	    public boolean saveOrUpdate(ActivoCargas activoCargas);
	    
	    /**
	     * Este método obtiene el estado de las cargas del activo que no estén
	     * canceladas.
	     * 
	     * @param idActivo : ID del activo al que corresponden las cargas.
	     * @return Devuelve True si el activo posee cargas no canceladas,
	     * False si no posee cargas o están canceladas.
	     */
	    public boolean esActivoConCargasNoCanceladas(Long idActivo);

		public boolean esActivoConCargasNoCanceladasRegistral(Long idActivo);
		
		public boolean esActivoConCargasNoCanceladasEconomica(Long idActivo);

		boolean esCargasOcultasCargaMasivaEsparta(Long idActivo);

		boolean tieneCargasOcultasCargaMasivaEsparta(Long idActivo);
	    
    }


