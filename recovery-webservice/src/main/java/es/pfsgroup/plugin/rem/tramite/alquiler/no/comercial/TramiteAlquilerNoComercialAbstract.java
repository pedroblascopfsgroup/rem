package es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.activo.dao.ActivoTramiteDao;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoTareasFormalizacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;

@Component
public abstract class TramiteAlquilerNoComercialAbstract implements TramiteAlquilerNoComercial {
	
	@Autowired
	private ActivoTramiteDao tramiteDao;
	
	@Autowired
	ExpedienteComercialApi expedienteComercialApi;

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

	public boolean estanCamposRellenosParaFormalizacion(ExpedienteComercial eco) {
		
		Oferta oferta = eco.getOferta();
		CondicionanteExpediente condiciones = eco.getCondicionante();
		if(oferta == null || condiciones == null)
			return false;
		
		if(oferta.getClaseContratoAlquiler() == null || oferta.getGrupoContratoCBK() == null || condiciones.getTipoImpuesto() == null 
				|| condiciones.getTipoAplicable() == null || condiciones.getTipoGrupoImpuesto() == null)
			return false;
		else
			return true;
		
	}
	
	public boolean permiteClaseCondicion() {
		return true;
	}
}
