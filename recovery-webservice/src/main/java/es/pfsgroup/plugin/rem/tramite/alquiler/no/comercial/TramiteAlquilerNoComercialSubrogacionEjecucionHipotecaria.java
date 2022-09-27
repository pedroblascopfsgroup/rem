package es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.DtoTareasFormalizacion;
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
	public boolean firmaMenosTresVeces(TareaExterna tareaExterna) {
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		boolean firmaMenosTresVeces =  true;

		List<HistoricoFirmaAdenda> historicosFirmasAdendas = genericDao.getList(HistoricoFirmaAdenda.class, genericDao.createFilter(FilterType.EQUALS, "oferta", eco.getOferta()));
		
		if(historicosFirmasAdendas != null && !historicosFirmasAdendas.isEmpty() && historicosFirmasAdendas.size() > 2) {
			firmaMenosTresVeces =  false;
		}	
		
		return firmaMenosTresVeces;
	}

	@Override
	public void saveHistoricoFirmaAdenda(DtoTareasFormalizacion dto, Oferta oferta) {
		HistoricoFirmaAdenda historicoFirmaAdenda = new HistoricoFirmaAdenda();

		historicoFirmaAdenda.setFechaAdenda(new Date());
		historicoFirmaAdenda.setOferta(oferta);
		historicoFirmaAdenda.setFirmadoAdenda(dto.getAdendaFirmada());
		historicoFirmaAdenda.setMotivoAdenda(dto.getMotivo());
		
		genericDao.save(HistoricoFirmaAdenda.class, historicoFirmaAdenda);
	}
	
}
