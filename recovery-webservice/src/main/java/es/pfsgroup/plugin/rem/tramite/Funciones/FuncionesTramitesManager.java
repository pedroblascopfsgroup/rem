package es.pfsgroup.plugin.rem.tramite.Funciones;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.FuncionesTramitesApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerNoComercialApi;
import es.pfsgroup.plugin.rem.api.TramiteVentaApi;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;

@Service("funcionesTramitesManager")
public class FuncionesTramitesManager implements FuncionesTramitesApi {
	
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private TramiteVentaApi tramiteVentaApi;
	
	@Autowired
	private TramiteAlquilerApi tramiteAlquilerApi;
		
	@Autowired
	private TramiteAlquilerNoComercialApi tramiteAlquilerNoComercialApi;
	
	@Override
	public boolean tieneRellenosCamposAnulacion(TareaExterna tareaExterna){
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		
		return tieneRellenosCamposAnulacion(eco);
	}
	
	@Override
	public boolean tieneRellenosCamposAnulacion(ExpedienteComercial eco){
		boolean camposRellenos = false;
		Oferta oferta = eco.getOferta();
		if(oferta != null) {
			if(DDTipoOferta.isTipoVenta(oferta.getTipoOferta())){
				camposRellenos = tramiteVentaApi.tieneRellenosCamposAnulacion(eco);
			}else if(DDTipoOferta.isTipoAlquiler(oferta.getTipoOferta())){
				camposRellenos = tramiteAlquilerApi.tieneRellenosCamposAnulacion(eco);
			}else if(DDTipoOferta.isTipoAlquilerNoComercial(oferta.getTipoOferta())){
				camposRellenos = tramiteAlquilerNoComercialApi.tieneRellenosCamposAnulacion(eco);
			}	
		}	
				
		return camposRellenos;
	}
}