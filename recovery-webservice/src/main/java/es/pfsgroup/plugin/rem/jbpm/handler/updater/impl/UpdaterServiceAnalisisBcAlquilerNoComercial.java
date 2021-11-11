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
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAccionNoComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOfertaAlquiler;

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

		for(TareaExternaValor valor :  valores){
			
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				codigoResultado = valor.getValor();
			}
		}
		
		if(codigoResultado != null) {
			if(DDTipoAccionNoComercial.COD_PTE_ANALISIS_TECNICO.equals(codigoResultado)) {
				estadoExpediente =  DDEstadosExpedienteComercial.PTE_ANALISIS_TECNICO;
				estadoBc =  DDEstadoExpedienteBc.PTE_ANALISIS_TECNICO;
			}
			if(DDTipoAccionNoComercial.COD_PTE_CLROD.equals(codigoResultado)) {
				estadoExpediente =  DDEstadosExpedienteComercial.PTE_CL_ROD;
				estadoBc =  DDEstadoExpedienteBc.PTE_CL_ROD;
			}
			if(DDTipoAccionNoComercial.COD_PTE_NEGOCIACION.equals(codigoResultado)) {
				estadoExpediente =  DDEstadosExpedienteComercial.PTE_PBC_ALQUILER_HRE;
				estadoBc =  DDEstadoExpedienteBc.PTE_PBC_ALQUILER_HRE;
			}
			if(DDTipoAccionNoComercial.COD_PTE_SCORING.equals(codigoResultado)) {
				estadoExpediente=  DDEstadosExpedienteComercial.PTE_SCORING;
				estadoBc = DDEstadoExpedienteBc.CODIGO_OFERTA_PDTE_SCORING;
			}
			if(DDTipoAccionNoComercial.COD_RECHAZO_COMERCIAL.equals(codigoResultado)) {
				estadoExpediente =  DDEstadosExpedienteComercial.ANULADO;
				estadoBc =  DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA;
				ofertaApi.rechazarOferta(oferta);
			}
		}
		
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
