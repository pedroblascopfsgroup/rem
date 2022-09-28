package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerNoComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoTareasFormalizacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDDecisionComite;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;

@Component
public class UpdaterServiceDecisionComiteAlquilerNoComercial implements UpdaterService {
	
	@Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;
	 
    @Autowired
    private TramiteAlquilerNoComercialApi tramiteAlquilerNoComercialApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceDecisionComiteAlquilerNoComercial.class);
    
	private static final String CODIGO_T018_DECISION_COMITE = "T018_DecisionComite";
	private static final String DECISION_COMITE ="decisionComite";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		DtoTareasFormalizacion dto = new DtoTareasFormalizacion();
		Oferta oferta = expedienteComercial.getOferta();
		
		for(TareaExternaValor valor :  valores){
			if(DECISION_COMITE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				dto.setDecisionComite(valor.getValor());
			}
		}
		
		String estadoExpBC = this.devolverEstadoBC(dto.getDecisionComite(), tareaExternaActual);
		if(estadoExpBC != null) {
			expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigoC4C", estadoExpBC)));
		}
		
		if(DDDecisionComite.CODIGO_CANCELAR.equals(dto.getDecisionComite())) {
			expedienteComercial.setMotivoAnulacion(genericDao.get(DDMotivoAnulacionExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivoAnulacionExpediente.COD_CAIXA_JUDICIALIZADO)));
		}
		
		tramiteAlquilerNoComercialApi.saveHistoricoFirmaAdenda(dto, oferta);
		
		genericDao.save(ExpedienteComercial.class, expedienteComercial);
		
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_DECISION_COMITE};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}


	private String devolverEstadoBC(String decisionComite,  TareaExterna tareaExterna) {
		String estadoExpBC = null;
		if(decisionComite != null) {
			if(DDDecisionComite.CODIGO_NUEVAS_CONDICIONES.equals(decisionComite)) {
				estadoExpBC = DDEstadoExpedienteBc.CODIGO_NUEVAS_CONDICIONES_COMITE_POSESIONES;
			}else if(DDDecisionComite.CODIGO_REAGENDAR.equals(decisionComite)) {
				estadoExpBC = DDEstadoExpedienteBc.CODIGO_BORRADOR_ACEPTADO;
			}else if(DDDecisionComite.CODIGO_CANCELAR.equals(decisionComite)) {
				estadoExpBC = DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO;
			}
		}
		
		return estadoExpBC;
	}
}
