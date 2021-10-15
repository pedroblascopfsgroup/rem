package es.pfsgroup.plugin.rem.tramite.Funciones;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.FuncionesTramitesApi;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;

@Service("funcionesTramitesManager")
public class FuncionesTramitesManager implements FuncionesTramitesApi {
	
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
		
	@Override
	public boolean tieneRellenosCamposAnulacion(TareaExterna tareaExterna){
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		
		return tieneRellenosCamposAnulacion(eco);
	}
	
	@Override
	public boolean tieneRellenosCamposAnulacion(ExpedienteComercial eco){
		boolean camposRellenos = false;
		if(eco.getDetalleAnulacionCntAlquiler() != null && eco.getMotivoAnulacion() != null && !Checks.isFechaNula(eco.getFechaAnulacion())) {
			camposRellenos = true;
		}
		
		return camposRellenos;
	}
}