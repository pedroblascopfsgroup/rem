package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

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
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ComercialUserAssigantionService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Component
public class UpdaterServicePbcAlquilerAlquilerNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ActivoTramiteApi activoTramiteApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServicePbcAlquilerAlquilerNoComercial.class);
    
	private static final String COMBO_RESULTADO = "comboResultado";
	
	private static final String COMBO_REQ_ANALISIS_TECNICO = "comboReqAnalisisTec";

	private static final String CODIGO_T018_PBC_ALQUILER = "T018_PbcAlquiler";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		boolean aprueba = false;
		String estado = null;
		String estadoBc = null;
		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		DDEstadoExpedienteBc estadoExpedienteBc = null;
		
		for(TareaExternaValor valor :  valores){
			
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDSiNo.SI.equals(valor.getValor())) {
					aprueba = true;
				}
			}
		}
		
		TareaExterna tareaExternaAnterior = activoTramiteApi.getTareaAnteriorByCodigoTarea(tramite.getId(), ComercialUserAssigantionService.TramiteAlquilerNoComercialT018.CODIGO_T018_PBC_ALQUILER);
		
		if(tareaExternaAnterior == null && aprueba) {
			estado = DDEstadosExpedienteComercial.PENDIENTE_GARANTIAS_ADICIONALES;
			estadoBc = DDEstadoExpedienteBc.PTE_NEGOCIACION;
		}else {
			List <TareaExternaValor> listTex = tareaExternaAnterior.getValores();
			for (TareaExternaValor tareaExternaValor : listTex) {
				
				if(aprueba) {
					if(COMBO_REQ_ANALISIS_TECNICO.equals(tareaExternaValor.getNombre()) && !Checks.esNulo(tareaExternaValor.getValor())) {
						if(DDSiNo.SI.equals(tareaExternaValor.getValor())) {
							estado = DDEstadosExpedienteComercial.PTE_ANALISIS_TECNICO;
							estadoBc = DDEstadoExpedienteBc.PTE_ANALISIS_TECNICO;
						}else{
							estado = DDEstadosExpedienteComercial.PTE_ELEVAR_SANCION;
							estadoBc = DDEstadoExpedienteBc.PTE_SANCION_BC;
						}
					}
				}else {
					estado = DDEstadosExpedienteComercial.ANULADO;
					estadoBc = DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA;
				}
			}	
		}
		
		estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", estado));
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
		return new String[]{CODIGO_T018_PBC_ALQUILER};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
