package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
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
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoScoringAlquiler;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.ScoringAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDRatingScoringServicer;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoCampo;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoScoring;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoScoringServicer;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;

@Component
public class UpdaterServiceSancionOfertaAlquileresVerificarScoring implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	@Autowired
	private OfertaApi ofertaApi;
        
    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresVerificarScoring.class);
    
    private static final String RESULTADO_SCORING = "resultadoScoring";
    private static final String FECHA_SANCION_SCORING = "fechaSancScoring";
	private static final String MOTIVO_RECHAZO = "motivoRechazo";
	private static final String N_EXPEDIENTE = "nExpediente";
	private static final String RATING_HAYA = "ratingHaya";
	private static final String N_MESES_FIANZA = "nMesesFianza";
	private static final String IMPORTE_FIANZA = "importeFianza";
	private static final String DEPOSITO = "deposito";
	private static final String N_MESES = "nMeses";
	private static final String IMPORTE_DEPOSITO = "importeDeposito";
	private static final String FIADOR_SOLIDARIO = "fiadorSolidario";
	private static final String NOMBRE_FS = "nombreFS";
	private static final String DOCUMENTO = "documento";
	private static final String TIPO_IMPUESTO = "tipoImpuesto";
	private static final String PORCENTAJE_IMPUESTO = "porcentajeImpuesto";
	private static final String OBSERVACIONES = "observaciones";
	
	private static final String CODIGO_T015_VERIFICAR_SCORING = "T015_VerificarScoring";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		CondicionanteExpediente condiciones = expedienteComercial.getCondicionante();
		Oferta oferta = expedienteComercial.getOferta();

		Boolean checkDepositoMarcado = false;
		Boolean checkFiadorSolidarioMarcado = false;
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", expedienteComercial.getId());
		ScoringAlquiler scoringAlquiler = genericDao.get(ScoringAlquiler.class, filtro);
		
		HistoricoScoringAlquiler histScoringAlquiler = new HistoricoScoringAlquiler();
		
		if(Checks.esNulo(scoringAlquiler)) {
			scoringAlquiler = new ScoringAlquiler();
			scoringAlquiler.setExpediente(expedienteComercial);
			if(condiciones != null) {
				condiciones.setScoringBc(true);
				genericDao.save(CondicionanteExpediente.class, condiciones);
			}
		}
		DDResultadoCampo resultadoCampo = null;
		boolean isBk = false;
		if(DDCartera.isCarteraBk(oferta.getActivoPrincipal().getCartera())) {
			isBk = true;
		}
		
		
		for(TareaExternaValor valor :  valores){
			
			if(RESULTADO_SCORING.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				@SuppressWarnings("unused")
				Filter filtroResultadoScoring = null;
				DDEstadosExpedienteComercial estadoExpedienteComercial = null;
				if(DDResultadoScoring.RESULTADO_APROBADO.equals(valor.getValor())) {
					filtroResultadoScoring = genericDao.createFilter(FilterType.EQUALS, "codigo", DDResultadoCampo.RESULTADO_APROBADO);
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.PTE_ELEVAR_SANCION));
					resultadoCampo = (DDResultadoCampo) utilDiccionarioApi.dameValorDiccionarioByCod(DDResultadoCampo.class, DDResultadoCampo.RESULTADO_APROBADO);
					histScoringAlquiler.setResultadoScoring(resultadoCampo);
					scoringAlquiler.setResultadoScoring(resultadoCampo);
					if(isBk) {
						estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.PENDIENTE_GARANTIAS_ADICIONALES));
						expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadoExpedienteBc.CODIGO_PTE_GARANTIAS_ADICIONALES)));
						DDResultadoScoringServicer resultadoScoringServicer = genericDao.get(DDResultadoScoringServicer.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDResultadoScoringServicer.COD_FAVORABLE));
						scoringAlquiler.setResultadoScoringServicer(resultadoScoringServicer);
						DDResultadoScoring resultadoScoringBc = genericDao.get(DDResultadoScoring.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDResultadoScoring.RESULTADO_APROBADO));
						scoringAlquiler.setResultadoScoringBc(resultadoScoringBc);
						scoringAlquiler.setResultadoScoring(null);
					}
					expedienteComercial.setEstado(estadoExpedienteComercial);
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);
				}else if(DDResultadoScoring.RESULTADO_DUDAS.equals(valor.getValor())) {
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.PTE_SCORING));
					expedienteComercial.setEstado(estadoExpedienteComercial);
					expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadoExpedienteBc.CODIGO_SCORING_A_REVISAR_POR_BC)));
					DDResultadoScoringServicer resultadoScoringServicer = genericDao.get(DDResultadoScoringServicer.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDResultadoScoringServicer.COD_FAVORABLE));
					scoringAlquiler.setResultadoScoringServicer(resultadoScoringServicer);
					DDResultadoScoring resultadoScoringBc = genericDao.get(DDResultadoScoring.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDResultadoScoring.RESULTADO_DUDAS));
					scoringAlquiler.setResultadoScoringBc(resultadoScoringBc);
					
				}else{
					filtroResultadoScoring = genericDao.createFilter(FilterType.EQUALS, "codigo", DDResultadoCampo.RESULTADO_RECHAZADO);
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.ANULADO));
					expedienteComercial.setEstado(estadoExpedienteComercial);
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);

					DDEstadoOferta estadoOferta = (DDEstadoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoOferta.class, DDEstadoOferta.CODIGO_RECHAZADA);
					oferta.setEstadoOferta(estadoOferta);
					resultadoCampo = (DDResultadoCampo) utilDiccionarioApi.dameValorDiccionarioByCod(DDResultadoCampo.class, DDResultadoCampo.RESULTADO_RECHAZADO);
					histScoringAlquiler.setResultadoScoring(resultadoCampo);
					scoringAlquiler.setResultadoScoring(resultadoCampo);
					
					if(isBk) {
						expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO)));
						DDResultadoScoringServicer resultadoScoringServicer = genericDao.get(DDResultadoScoringServicer.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDResultadoScoringServicer.COD_DESFAVORABLE));
						scoringAlquiler.setResultadoScoringServicer(resultadoScoringServicer);
						DDResultadoScoring resultadoScoringBc = genericDao.get(DDResultadoScoring.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDResultadoScoring.RESULTADO_RECHAZADO));
						scoringAlquiler.setResultadoScoringBc(resultadoScoringBc);
						scoringAlquiler.setResultadoScoring(null);
					}
				}
			}
			
			if(FECHA_SANCION_SCORING.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				try {
					scoringAlquiler.setFechaSancionBc(ft.parse((valor.getValor())));
					histScoringAlquiler.setFechaSancion(ft.parse((valor.getValor())));
				} catch (ParseException e) {
					logger.error("Error insertando Fecha sanción scoring.", e);
				}
			}
			
			if(MOTIVO_RECHAZO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				
				Filter filtroMotivoRezhazo = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());;
				DDMotivoRechazoAlquiler motivoRechazo = genericDao.get(DDMotivoRechazoAlquiler.class, filtroMotivoRezhazo);
					
				if (!Checks.esNulo(scoringAlquiler)) {
					scoringAlquiler.setMotivoRechazo(motivoRechazo.getDescripcion());
				}				
			}
			
			if(N_EXPEDIENTE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				scoringAlquiler.setNumeroExpedienteBc(valor.getValor());
				histScoringAlquiler.setIdSolicitud("" + valor.getValor()); 
			}
			
			if (RATING_HAYA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				Filter filtroRating = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());
				DDRatingScoringServicer rating = genericDao.get(DDRatingScoringServicer.class, filtroRating);
				scoringAlquiler.setRatingScoringServicer(rating);
			}
			
			if(N_MESES_FIANZA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				condiciones.setMesesFianza(Integer.parseInt(valor.getValor()));
				histScoringAlquiler.setMesesFianza(Integer.parseInt(valor.getValor()));
			}
				
			if(IMPORTE_FIANZA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				condiciones.setImporteFianza(Double.parseDouble(valor.getValor()));
				histScoringAlquiler.setImportFianza(Long.parseLong(valor.getValor()));
			}
				
			if(DEPOSITO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				checkDepositoMarcado = Boolean.parseBoolean(valor.getValor());
			}
				
			if(checkDepositoMarcado) {
				if(N_MESES.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					condiciones.setMesesDeposito(Integer.parseInt(valor.getValor()));
				}
					
				if(IMPORTE_DEPOSITO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					condiciones.setImporteDeposito(Double.parseDouble(valor.getValor()));
				}
			}
				
			if(FIADOR_SOLIDARIO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				checkFiadorSolidarioMarcado = Boolean.parseBoolean(valor.getValor());
			}
				
			if(checkFiadorSolidarioMarcado) {
				if(NOMBRE_FS.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					condiciones.setAvalista(valor.getValor());
				}
					
				if(DOCUMENTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					condiciones.setDocumentoFiador(valor.getValor());
				}
			}
				
			if(TIPO_IMPUESTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				Filter filtroTipoImpuesto = null;
				
				if(DDTiposImpuesto.TIPO_IMPUESTO_IVA.equals(valor.getValor())) {
					filtroTipoImpuesto = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTiposImpuesto.TIPO_IMPUESTO_IVA);
				}else if(DDTiposImpuesto.TIPO_IMPUESTO_ITP.equals(valor.getValor())) {
					filtroTipoImpuesto = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTiposImpuesto.TIPO_IMPUESTO_ITP);
				}else if(DDTiposImpuesto.TIPO_IMPUESTO_IGIC.equals(valor.getValor())) {
					filtroTipoImpuesto = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTiposImpuesto.TIPO_IMPUESTO_IGIC);
				}else if(DDTiposImpuesto.TIPO_IMPUESTO_IPSI.equals(valor.getValor())) {
					filtroTipoImpuesto = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTiposImpuesto.TIPO_IMPUESTO_IPSI);
				}
					
				if(!Checks.esNulo(filtroTipoImpuesto)) {
					DDTiposImpuesto tipoImpuesto = genericDao.get(DDTiposImpuesto.class, filtroTipoImpuesto);
					condiciones.setTipoImpuesto(tipoImpuesto);
				}
			}
				
			if(PORCENTAJE_IMPUESTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				condiciones.setTipoAplicable(Double.parseDouble(valor.getValor()));
			}
				
			if(OBSERVACIONES.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				scoringAlquiler.setComentarios(valor.getValor());
			}
		}
		expedienteComercial.setOferta(oferta);
		expedienteComercialApi.update(expedienteComercial,false);
		genericDao.save(ScoringAlquiler.class, scoringAlquiler);
		histScoringAlquiler.setScoringAlquiler(scoringAlquiler);
		genericDao.save(HistoricoScoringAlquiler.class, histScoringAlquiler);

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_VERIFICAR_SCORING};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
