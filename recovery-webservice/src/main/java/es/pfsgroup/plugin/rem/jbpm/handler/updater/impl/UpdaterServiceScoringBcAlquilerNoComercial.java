package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
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
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoRespuestaBCGenerica;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoSancionesBc;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDApruebaDeniega;
import es.pfsgroup.plugin.rem.model.dd.DDComiteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAccionNoComercial;

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
	private static final String FECHA_RESOLUCION = "fechaResolucion";

	private static final String CODIGO_T018_SCORING_BC = "T018_ScoringBc";
	private static final String OBSERVACIONES = "observaciones";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		boolean aprueba = false;
		String estadoExpediente = null;
		String estadoBc = null;
		String fechaResolucion = null;
		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		DDEstadoExpedienteBc estadoExpedienteBc = null;
		
		DtoRespuestaBCGenerica dtoHistoricoBC = new DtoRespuestaBCGenerica();
		dtoHistoricoBC.setRespuestaBC(DDApruebaDeniega.CODIGO_APRUEBA);
		dtoHistoricoBC.setComiteBc(DDComiteBc.CODIGO_COMITE_COMERCIAL);
		
		for(TareaExternaValor valor :  valores){
			
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDTipoAccionNoComercial.COD_PTE_ANALISIS_TECNICO.equals(valor.getValor())) {
					aprueba = true;
					estadoExpediente = DDEstadosExpedienteComercial.PTE_ANALISIS_TECNICO;
					estadoBc = DDEstadoExpedienteBc.PTE_ANALISIS_TECNICO;
				}else if(DDTipoAccionNoComercial.COD_PTE_NEGOCIACION.equals(valor.getValor())){
					aprueba = true;
					estadoExpediente = DDEstadosExpedienteComercial.PENDIENTE_GARANTIAS_ADICIONALES;
					estadoBc = DDEstadoExpedienteBc.PTE_NEGOCIACION;
				}else if(DDTipoAccionNoComercial.COD_RECHAZO_COMERCIAL.equals(valor.getValor())){
					estadoExpediente = DDEstadosExpedienteComercial.ANULADO;
					estadoBc = DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA;
					dtoHistoricoBC.setRespuestaBC(DDApruebaDeniega.CODIGO_DENIEGA);
				}
			}
			
			if(FECHA_RESOLUCION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				fechaResolucion = valor.getValor();
			}	
			
			if(OBSERVACIONES.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				dtoHistoricoBC.setObservacionesBC(valor.getValor());
			}
		}
		
		HistoricoSancionesBc historico = expedienteComercialApi.dtoRespuestaToHistoricoSancionesBc(dtoHistoricoBC, expedienteComercial);
		
		genericDao.save(HistoricoSancionesBc.class, historico);
		
		estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", estadoExpediente));
		estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS,"codigo", estadoBc));
		
		expedienteComercial.setEstado(estadoExpedienteComercial);
		expedienteComercial.setEstadoBc(estadoExpedienteBc);
		
		if(!aprueba) {
			try {
				if(fechaResolucion != null && !fechaResolucion.isEmpty()) {
					expedienteComercial.setFechaAnulacion(ft.parse(fechaResolucion));
				}
			} catch (ParseException e) {
				e.printStackTrace();
			}
			ofertaApi.finalizarOferta(oferta);
		}

		expedienteComercialApi.update(expedienteComercial,false);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_SCORING_BC};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
