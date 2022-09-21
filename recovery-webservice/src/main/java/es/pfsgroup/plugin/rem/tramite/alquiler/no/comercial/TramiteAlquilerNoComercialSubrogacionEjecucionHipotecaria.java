package es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoFirmaAdenda;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAdenda;

@Component
public class TramiteAlquilerNoComercialSubrogacionEjecucionHipotecaria extends TramiteAlquilerNoComercialAbstract implements TramiteAlquilerNoComercial {
	
	@Autowired
	ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;

	@Override
	public Boolean isAdendaVacio(TareaExterna tareaExterna) {
		
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		
		Oferta ofr = eco.getOferta();
		
		DDTipoAdenda tipoAdenda = ofr.getTipoAdenda();
		
		if(tipoAdenda != null) {
			return false;
		}else {
			return true;
		}
		
	}
	
	@Override
	public Boolean noFirmaMenosTresVeces(TareaExterna tareaExterna) {
		
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		
		Oferta ofr = eco.getOferta();
		
		Filter filtroOferta = genericDao.createFilter(FilterType.EQUALS, "oferta", ofr);
		List<HistoricoFirmaAdenda> historicosFirmasAdendas = genericDao.getList(HistoricoFirmaAdenda.class, filtroOferta);
		
		if(historicosFirmasAdendas != null && !historicosFirmasAdendas.isEmpty()) {
			if(historicosFirmasAdendas.size() > 2) {
				return false;
			}else {
				return true;
			}
		}else {
			return true;
		}
		
	}
	
}
