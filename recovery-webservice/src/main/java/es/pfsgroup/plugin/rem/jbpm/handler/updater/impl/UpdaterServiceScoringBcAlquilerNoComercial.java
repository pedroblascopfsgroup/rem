package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOfertaAlquiler;

@Component
public class UpdaterServiceScoringBcAlquilerNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private OfertaApi ofertaApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceScoringBcAlquilerNoComercial.class);
    
	private static final String COMBO_RESULTADO = "comboResultado";

	private static final String CODIGO_T018_SCORING_BC = "T018_ScoringBc";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		boolean aprueba = false;
		String estadoExpediente = null;
		String estadoBc = null;
		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		DDEstadoExpedienteBc estadoExpedienteBc = null;
		

		for(TareaExternaValor valor :  valores){
			
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDSiNo.SI.equals(valor.getValor())) {
					aprueba = true;
					
					ExpedienteComercial ecoAnt = expedienteComercial.getExpedienteAnterior();
					if(ecoAnt != null && ecoAnt.getOferta() != null && DDTipoOfertaAlquiler.isSubrogacion(ecoAnt.getOferta().getTipoOfertaAlquiler())) {
						estadoExpediente = DDEstadosExpedienteComercial.PTE_ANALISIS_TECNICO;
						estadoBc = DDEstadoExpedienteBc.PTE_ANALISIS_TECNICO;
					}else {
						estadoExpediente = DDEstadosExpedienteComercial.PENDIENTE_GARANTIAS_ADICIONALES;
						estadoBc = DDEstadoExpedienteBc.CODIGO_PENDIENTE_GARANTIAS_ADICIONALES_BC;
					}

				}else {
					estadoExpediente = DDEstadosExpedienteComercial.ANULADO;
					estadoBc = DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA;
				}
				

			}
		}
		
		estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", estadoExpediente));
		estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS,"codigo", estadoBc));
		
		expedienteComercial.setEstado(estadoExpedienteComercial);
		expedienteComercial.setEstadoBc(estadoExpedienteBc);
		
		if(!aprueba) {	
			ofertaApi.rechazarOferta(oferta);
		}
		

		expedienteComercialApi.update(expedienteComercial,false);	
		
		ofertaApi.replicateOfertaFlushDto(expedienteComercial.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expedienteComercial));

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_SCORING_BC};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
