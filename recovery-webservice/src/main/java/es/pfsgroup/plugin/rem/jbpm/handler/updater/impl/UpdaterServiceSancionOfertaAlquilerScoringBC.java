package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.auditoria.model.Auditoria;
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
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoRespuestaBCGenerica;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoSancionesBc;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.ScoringAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDApruebaDeniega;
import es.pfsgroup.plugin.rem.model.dd.DDComiteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoCampo;

@Component
public class UpdaterServiceSancionOfertaAlquilerScoringBC implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
    private OfertaApi ofertaApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquilerScoringBC.class);
    
	private static final String COMBO_RESULTADO = "comboResolucion";
	private static final String FECHA_SANCION = "fechaSancion";
	
	private static final String OBSERVACIONESBC = "observacionesBC";
	
	private static final String CODIGO_T015_SCORING_BC = "T015_ScoringBC";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		boolean estadoBcModificado = false;
		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		String estadoExp = null;
		String estadoBc = null;
		String resultadoScoring = null;
		String fechaSancion = null;
		boolean aprueba = false;
		
		DtoRespuestaBCGenerica dtoHistoricoBC = new DtoRespuestaBCGenerica();
		dtoHistoricoBC.setComiteBc(DDComiteBc.CODIGO_COMITE_COMERCIAL);
		dtoHistoricoBC.setRespuestaBC(DDApruebaDeniega.CODIGO_APRUEBA);

		for(TareaExternaValor valor :  valores){
			
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if (DDSiNo.SI.equals(valor.getValor())) {
					aprueba = true;		
				}
			}
			if(FECHA_SANCION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				fechaSancion = valor.getValor();
			}

			if(OBSERVACIONESBC.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				dtoHistoricoBC.setObservacionesBC(valor.getValor());
			}
		}
		
		if (aprueba) {
			estadoExp =  DDEstadosExpedienteComercial.PENDIENTE_GARANTIAS_ADICIONALES;
			estadoBc =  DDEstadoExpedienteBc.CODIGO_PTE_GARANTIAS_ADICIONALES;
			resultadoScoring = DDResultadoCampo.RESULTADO_APROBADO;
			
		} else{
			estadoExp =  DDEstadosExpedienteComercial.DENEGADO;
			estadoBc =  DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO;
			resultadoScoring = DDResultadoCampo.RESULTADO_RECHAZADO;
			Oferta oferta = expedienteComercial.getOferta();
			dtoHistoricoBC.setRespuestaBC(DDApruebaDeniega.CODIGO_DENIEGA);
			if(oferta != null) {
				try {
					expedienteComercial.setFechaAnulacion(ft.parse(fechaSancion));
				} catch (ParseException e) {
					e.printStackTrace();
				}
				
				ofertaApi.finalizarOferta(oferta);
			}

		}

		ScoringAlquiler scoring = genericDao.get(ScoringAlquiler.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id", expedienteComercial.getId()));
		
		if (scoring == null ) {
			scoring = new ScoringAlquiler();
			scoring.setAuditoria(Auditoria.getNewInstance());
			scoring.setExpediente(expedienteComercial);	
			CondicionanteExpediente coe = expedienteComercial.getCondicionante();
			if(coe != null) {
				coe.setScoringBc(true);
				genericDao.save(CondicionanteExpediente.class, coe);
			}
			
			
		}
		scoring.setResultadoScoring(genericDao.get(DDResultadoCampo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", resultadoScoring))); 
		genericDao.save(ScoringAlquiler.class, scoring);
		
		expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoExp)));
		expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBc)));
		estadoBcModificado = true;
		genericDao.save(ExpedienteComercial.class, expedienteComercial);	
		
		HistoricoSancionesBc historico = expedienteComercialApi.dtoRespuestaToHistoricoSancionesBc(dtoHistoricoBC, expedienteComercial);
		
		genericDao.save(HistoricoSancionesBc.class, historico);
		
		if(estadoBcModificado) {
			ofertaApi.replicateOfertaFlushDto(expedienteComercial.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpedienteAndScoringBc(expedienteComercial, resultadoScoring, fechaSancion));
		}
	}


	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_SCORING_BC};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
}
