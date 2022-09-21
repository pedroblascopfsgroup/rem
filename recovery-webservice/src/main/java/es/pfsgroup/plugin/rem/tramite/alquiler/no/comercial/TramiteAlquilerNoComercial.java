package es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;

public interface TramiteAlquilerNoComercial {

	public Boolean isAdendaVacio(TareaExterna tareaExterna);
	
	public Boolean noFirmaMenosTresVeces(TareaExterna tareaExterna);
}