package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoScoringAlquiler;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.ScoringAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDRatingScoringServicer;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoScoring;

@Component
public class UpdaterServiceScoringAlquilerNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private OfertaApi ofertaApi;


    protected static final Log logger = LogFactory.getLog(UpdaterServiceScoringAlquilerNoComercial.class);
    
	private static final String COMBO_RESULTADO = "comboResultado";
	private static final String COMBO_RATING_SCORING = "ratingHaya";

	private static final String CODIGO_T018_SCORING = "T018_Scoring";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		String estadoEcoCodigo = null;
		String estadoEcoBcCodigo = null;
		String ratingScoringCodigo = null;
		

		for(TareaExternaValor valor :  valores){
			
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDResultadoScoring.RESULTADO_APROBADO.equals(valor.getValor())) {
					 estadoEcoCodigo =  DDEstadosExpedienteComercial.PTE_PBC_ALQUILER_HRE;
					 estadoEcoBcCodigo = DDEstadoExpedienteBc.PTE_PBC_ALQUILER_HRE;
				}else {
					estadoEcoCodigo =  DDEstadosExpedienteComercial.PTE_SCORING;
					estadoEcoBcCodigo = DDEstadoExpedienteBc.CODIGO_SCORING_A_REVISAR_POR_BC;
				}
			}
			
			if(COMBO_RATING_SCORING.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				ratingScoringCodigo = valor.getValor();
			}
		}
		
		
		ScoringAlquiler scoringAlquiler = genericDao.get(ScoringAlquiler.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id", expedienteComercial.getId()));
		
		
		if(Checks.esNulo(scoringAlquiler)) {
			scoringAlquiler = new ScoringAlquiler();
			scoringAlquiler.setExpediente(expedienteComercial);
			CondicionanteExpediente coe = expedienteComercial.getCondicionante();
			if(coe != null) {
				coe.setScoringBc(true);
				genericDao.save(CondicionanteExpediente.class, coe);
			}
		}

		if(ratingScoringCodigo != null) {
			scoringAlquiler.setRatingScoringServicer(genericDao.get(DDRatingScoringServicer.class, genericDao.createFilter(FilterType.EQUALS, "codigo", ratingScoringCodigo)));
		}
		genericDao.save(ScoringAlquiler.class, scoringAlquiler);
		
		expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", estadoEcoCodigo)));
		expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS,"codigo", estadoEcoBcCodigo)));

		expedienteComercialApi.update(expedienteComercial,false);	
		
		ofertaApi.replicateOfertaFlushDto(expedienteComercial.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expedienteComercial));

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_SCORING};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
