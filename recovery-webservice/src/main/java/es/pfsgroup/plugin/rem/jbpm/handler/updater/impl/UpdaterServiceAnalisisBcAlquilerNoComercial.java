package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

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
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoRespuestaBCGenerica;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoSancionesBc;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDApruebaDeniega;
import es.pfsgroup.plugin.rem.model.dd.DDComiteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAccionNoComercial;

@Component
public class UpdaterServiceAnalisisBcAlquilerNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private OfertaApi ofertaApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceAnalisisBcAlquilerNoComercial.class);
    
	private static final String COMBO_RESULTADO = "comboResultado";
	private static final String REQUIERE_ANALISIS_T = "isVulnerableAnalisisT";

	private static final String CODIGO_T018_ANALISIS_BC = "T018_AnalisisBc";
	
	private static final String OBSERVACIONESBC = "observacionesBC";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		DDEstadoExpedienteBc estadoExpedienteBc = null;
		String estadoExpediente = null;
		String estadoBc = null;
		String codigoResultado = null;
		
		CondicionanteExpediente coe = expedienteComercial.getCondicionante();
		
		DtoRespuestaBCGenerica dtoHistoricoBC = new DtoRespuestaBCGenerica();
		
		for(TareaExternaValor valor :  valores){
			
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				codigoResultado = valor.getValor();
			}
			if(OBSERVACIONESBC.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				dtoHistoricoBC.setObservacionesBC(valor.getValor());
			}
		}
		
		if(codigoResultado != null) {
			dtoHistoricoBC.setComiteBc(DDComiteBc.CODIGO_COMITE_COMERCIAL);
			dtoHistoricoBC.setRespuestaBC(DDApruebaDeniega.CODIGO_APRUEBA);
			
			
			if(DDTipoAccionNoComercial.COD_PTE_ANALISIS_TECNICO.equals(codigoResultado)) {
				estadoExpediente =  DDEstadosExpedienteComercial.PTE_ANALISIS_TECNICO;
				estadoBc =  DDEstadoExpedienteBc.PTE_ANALISIS_TECNICO;
			}
			if(DDTipoAccionNoComercial.COD_PTE_CLROD.equals(codigoResultado)) {
				estadoExpediente =  DDEstadosExpedienteComercial.PTE_CL_ROD;
				estadoBc =  DDEstadoExpedienteBc.PTE_CL_ROD;
			}
			if(DDTipoAccionNoComercial.COD_PTE_NEGOCIACION.equals(codigoResultado)) {
				estadoExpediente = DDEstadosExpedienteComercial.PENDIENTE_GARANTIAS_ADICIONALES;
				estadoBc = DDEstadoExpedienteBc.PTE_NEGOCIACION;
			}
			if(DDTipoAccionNoComercial.COD_PTE_SCORING.equals(codigoResultado)) {
				estadoExpediente=  DDEstadosExpedienteComercial.PTE_SCORING;
				estadoBc = DDEstadoExpedienteBc.CODIGO_OFERTA_PDTE_SCORING;
			}
			if(DDTipoAccionNoComercial.COD_RECHAZO_COMERCIAL.equals(codigoResultado)) {
				estadoExpediente =  DDEstadosExpedienteComercial.ANULADO;
				estadoBc =  DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA;
				dtoHistoricoBC.setRespuestaBC(DDApruebaDeniega.CODIGO_DENIEGA);
				expedienteComercial.setFechaAnulacion(new Date());
				ofertaApi.finalizarOferta(oferta);
			}
		}
		
		HistoricoSancionesBc historico = expedienteComercialApi.dtoRespuestaToHistoricoSancionesBc(dtoHistoricoBC, expedienteComercial);
		
		genericDao.save(HistoricoSancionesBc.class, historico);
		
		estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", estadoExpediente));
		estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS,"codigo", estadoBc));

		expedienteComercial.setEstado(estadoExpedienteComercial);
		expedienteComercial.setEstadoBc(estadoExpedienteBc);
	
		expedienteComercialApi.update(expedienteComercial,false);

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_ANALISIS_BC};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
