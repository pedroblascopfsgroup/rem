package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
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
import es.pfsgroup.plugin.rem.api.FuncionesTramitesApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoRespuestaBCGenerica;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoTareaPbc;
import es.pfsgroup.plugin.rem.model.HistoricoSancionesBc;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDApruebaDeniega;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDComiteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoCampo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTareaPbc;

@Component
public class UpdaterServiceSancionOfertaAlquileresSancionBc implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private TramiteAlquilerApi tramiteAlquilerApi;
	
	@Autowired
	private FuncionesTramitesApi funcionesTramitesApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresSancionBc.class);
    
	private static final String RESULTADO_PBC = "comboResolucion";
	private static final String OBSERVACIONESBC = "observacionesBc";

	private static final String CODIGO_T015_SANCION_BC = "T015_SancionBC";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		boolean aprueba = false;
		boolean estadoBcModificado = false;
		String estadoExp = null;
		String estadoBc = null;
		DtoRespuestaBCGenerica dtoHistoricoBC = new DtoRespuestaBCGenerica();
		dtoHistoricoBC.setComiteBc(DDComiteBc.CODIGO_COMITE_COMERCIAL);
		
		for(TareaExternaValor valor :  valores){
			
			if(RESULTADO_PBC.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if (DDSiNo.SI.equals(valor.getValor())) {
					aprueba = true;
				}
			}
			
			if(OBSERVACIONESBC.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				dtoHistoricoBC.setObservacionesBC(valor.getValor());
			}
		}

		if (aprueba) {
			estadoExp = DDEstadosExpedienteComercial.PTE_PBC;
			estadoBc =  DDEstadoExpedienteBc.CODIGO_SCORING_APROBADO;
			dtoHistoricoBC.setRespuestaBC(DDApruebaDeniega.CODIGO_APRUEBA);
		} else{
			estadoExp =  DDEstadosExpedienteComercial.DENEGADO;
			estadoBc =  DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO;
			Oferta oferta = expedienteComercial.getOferta();
			
			if(oferta != null) {
				expedienteComercial.setFechaAnulacion(new Date());
				ofertaApi.finalizarOferta(oferta);
			}
			dtoHistoricoBC.setRespuestaBC(DDApruebaDeniega.CODIGO_DENIEGA);
		}
		
		expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoExp)));
		expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBc)));
		estadoBcModificado = true;
		genericDao.save(ExpedienteComercial.class, expedienteComercial);	
		if(estadoBcModificado) {
			ofertaApi.replicateOfertaFlushDto(expedienteComercial.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expedienteComercial));
		}
		
		funcionesTramitesApi.desactivarHistoricoPbc(expedienteComercial.getOferta().getId(), DDTipoTareaPbc.CODIGO_PBC);
		genericDao.save(HistoricoTareaPbc.class, funcionesTramitesApi.createHistoricoPbc(expedienteComercial.getOferta().getId(), DDTipoTareaPbc.CODIGO_PBC));
		
		HistoricoSancionesBc historicoBc = expedienteComercialApi.dtoRespuestaToHistoricoSancionesBc(dtoHistoricoBC, expedienteComercial);
				
		genericDao.save(HistoricoSancionesBc.class, historicoBc);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_SANCION_BC};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
}
