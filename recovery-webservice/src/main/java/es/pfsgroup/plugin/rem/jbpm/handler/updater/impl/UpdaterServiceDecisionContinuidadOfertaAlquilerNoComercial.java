package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoFirmaAdenda;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;

@Component
public class UpdaterServiceDecisionContinuidadOfertaAlquilerNoComercial implements UpdaterService {
	
	@Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceDecisionContinuidadOfertaAlquilerNoComercial.class);
    
	private static final String CODIGO_T018_DECISION_CONTINUIDAD_OFERTA = "T018_DecisionContinuidadOferta";
	private static final String COMBO_SEGUIR_OFERTA = "seguirOferta";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		DDEstadoExpedienteBc estadoExpBC = null;
		DDMotivoAnulacionExpediente motivoAnulacion = null;
				
		for(TareaExternaValor valor :  valores){
			if(COMBO_SEGUIR_OFERTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDSiNo.SI.equals(valor.getValor())) { 
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", "130");
					estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
				}else {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", "150");
					estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
					
					Filter filtroAnulacion = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", "400");
					motivoAnulacion = genericDao.get(DDMotivoAnulacionExpediente.class,filtroAnulacion);
				}
			}
		}

		expedienteComercial.setEstadoBc(estadoExpBC);
		expedienteComercial.setMotivoAnulacion(motivoAnulacion);

		genericDao.save(ExpedienteComercial.class, expedienteComercial);
		
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_DECISION_CONTINUIDAD_OFERTA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
