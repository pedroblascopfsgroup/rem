package es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial;

import org.springframework.stereotype.Component;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.model.DtoTareasFormalizacion;
import es.pfsgroup.plugin.rem.model.Oferta;

@Component
public abstract class TramiteAlquilerNoComercialAbstract implements TramiteAlquilerNoComercial {

	public Boolean isAdendaVacio(TareaExterna tareaExterna) {
		// TODO Auto-generated method stub
		return null;
	}
	
	public boolean firmaMenosTresVeces(TareaExterna tareaExterna) {
		// TODO Auto-generated method stub
		return true;
	}

	public void saveHistoricoFirmaAdenda(DtoTareasFormalizacion dto, Oferta oferta) {
		// TODO Auto-generated method stub
	}
	
}
