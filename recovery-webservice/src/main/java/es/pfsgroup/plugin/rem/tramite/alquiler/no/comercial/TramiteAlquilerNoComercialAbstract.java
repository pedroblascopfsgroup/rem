package es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.activo.dao.ActivoTramiteDao;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoTareasFormalizacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;

@Component
public abstract class TramiteAlquilerNoComercialAbstract implements TramiteAlquilerNoComercial {
	
	@Autowired
	private ActivoTramiteDao tramiteDao;

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
	
	@Override
	public boolean modificarFianza(ExpedienteComercial eco) {
		boolean modificar = false;
		
		modificar = this.cumpleCondiciones(tramiteDao.getTramiteComercialVigenteByTrabajoAllTramites(eco.getTrabajo().getId()));
		
		return modificar;
	}

	public boolean cumpleCondiciones(ActivoTramite tramite) {
		// TODO Auto-generated method stub
		return false;
	}
}
