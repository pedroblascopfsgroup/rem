package es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.model.DtoTareasFormalizacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;

public interface TramiteAlquilerNoComercial {

	public Boolean isAdendaVacio(TareaExterna tareaExterna);
	
	public boolean firmaMenosTresVeces(TareaExterna tareaExterna);
	
	public void saveHistoricoFirmaAdenda(DtoTareasFormalizacion dto, Oferta oferta);

	boolean modificarFianza(ExpedienteComercial eco);
	
	boolean estanCamposRellenosParaFormalizacion(ExpedienteComercial eco);

	public boolean permiteClaseCondicion();

}