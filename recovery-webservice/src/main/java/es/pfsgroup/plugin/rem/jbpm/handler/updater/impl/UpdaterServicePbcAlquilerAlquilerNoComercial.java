package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;

@Component
public class UpdaterServicePbcAlquilerAlquilerNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private OfertaApi ofertaApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServicePbcAlquilerAlquilerNoComercial.class);
    
	private static final String COMBO_RESULTADO = "comboResultado";
	private static final String CAMPO_OBSERVACIONES = "observaciones";

	private static final String CODIGO_T018_PBC_ALQUILER = "T018_PbcAlquiler";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		boolean aprueba = false;
		String estado = null;
		String estadoBc = null;
		String observaciones = null;
		
		for(TareaExternaValor valor :  valores){
			
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDSiNo.SI.equals(valor.getValor())) {
					aprueba = true;
				}
			}
			if(CAMPO_OBSERVACIONES.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				observaciones = valor.getValor();
			}
		}
		
		if(aprueba) {
			estado = DDEstadosExpedienteComercial.PTE_AGENDAR_ARRAS;
			estadoBc = DDEstadoExpedienteBc.CODIGO_IMPORTE_FINAL_APROBADO;
		}else {
			estado = DDEstadosExpedienteComercial.ANULADO;
			estadoBc = DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA;
			expedienteComercial.setFechaAnulacion(new Date());
			expedienteComercial.setMotivoAnulacion(genericDao.get(DDMotivoAnulacionExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivoAnulacionExpediente.COD_CAIXA_RECHAZADO_PBC)));
			expedienteComercial.setDetalleAnulacionCntAlquiler(observaciones);
		}

		expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", estado)));
		expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS,"codigo", estadoBc)));
		
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
