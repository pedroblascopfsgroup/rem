package es.pfsgroup.plugin.recovery.comites.comite.web;

import java.util.List;

import es.capgemini.devon.dto.AbstractDto;
import es.pfsgroup.plugin.recovery.comites.itinerario.dto.CMTDtoItinerario;

public class CMTFormItinerariosComite extends AbstractDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -8143115257227895667L;
	
	private List<CMTDtoItinerario> dtoItinerario;

	public void setDtoItinerario(List<CMTDtoItinerario> dtoItinerario) {
		this.dtoItinerario = dtoItinerario;
	}

	public List<CMTDtoItinerario> getDtoItinerario() {
		return dtoItinerario;
	}

}
