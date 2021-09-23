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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOfertaAlquiler;

@Component
public class UpdaterServiceRevisionBcYCondicionesAlquilerNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private OfertaApi ofertaApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceRevisionBcYCondicionesAlquilerNoComercial.class);
    
	private static final String COMBO_RESULTADO= "comboResultado";

	private static final String CODIGO_T018_REVISION_BC_Y_CONDICIONES = "T018_RevisionBcYCondiciones";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		boolean aprueba = false;
		String estado = null;
		String estadoBc = null;
		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		DDEstadoExpedienteBc estadoExpedienteBc = null;
		
		CondicionanteExpediente coe = expedienteComercial.getCondicionante();

		for(TareaExternaValor valor :  valores){
			
			if(COMBO_RESULTADO.equals(valor.getNombre()) && valor.getValor() != null) {
				if(DDSiNo.SI.equals(valor.getValor())) {
					aprueba = true;
					if(DDTipoOfertaAlquiler.isAlquilerSocial(oferta.getTipoOfertaAlquiler()) && (coe.getVulnerabilidadDetectada() == null || !coe.getVulnerabilidadDetectada())) {
						estado = DDEstadosExpedienteComercial.PTE_CL_ROD;
						estadoBc = DDEstadoExpedienteBc.PTE_CL_ROD;
					}else {
						estado = DDEstadosExpedienteComercial.PENDIENTE_GARANTIAS_ADICIONALES;
						estadoBc = DDEstadoExpedienteBc.CODIGO_PENDIENTE_GARANTIAS_ADICIONALES_BC;
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
		return new String[]{CODIGO_T018_REVISION_BC_Y_CONDICIONES};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
