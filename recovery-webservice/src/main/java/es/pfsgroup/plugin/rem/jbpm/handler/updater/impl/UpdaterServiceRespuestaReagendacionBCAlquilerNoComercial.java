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
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerNoComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;

@Component
public class UpdaterServiceRespuestaReagendacionBCAlquilerNoComercial implements UpdaterService {
	
	@Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
	private TramiteAlquilerNoComercialApi tramiteAlquilerNoComercialApi;
    
    @Autowired
    private OfertaApi ofertaApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceRespuestaReagendacionBCAlquilerNoComercial.class);
    
    private static final String COMBO_RESULTADO = "comboResultado";
    private static final String COMBO_COMITE = "comboComite";
	private static final String CODIGO_T018_RESPUESTA_REAGENDACION_BC = "T018_RespuestaReagendacionBC";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		
		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		boolean reagendacion = false;
		boolean irComite = false;
 		boolean novacionRenovacion = tramiteAlquilerNoComercialApi.esRenovacion(tareaExternaActual);
 		
 		for(TareaExternaValor valor :  valores){
			
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if (DDSiNo.SI.equals(valor.getValor())) {					
					reagendacion = true;
				}
			}
			if(COMBO_COMITE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				irComite = DDSinSiNo.cambioStringaBooleanoNativo(valor.getValor());	
			}
		}
 		
 		String codigoEstadoBc = this.devolverEstadoBC(reagendacion, irComite, novacionRenovacion);
 		if(codigoEstadoBc != null) {
 			expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoEstadoBc)));
 		}
 		expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", this.devolverEstadoEco(reagendacion, irComite, novacionRenovacion))));

 		if(DDEstadoExpedienteBc.isCompromisoCancelado(expedienteComercial.getEstadoBc())) {
 			ofertaApi.finalizarOferta(expedienteComercial.getOferta());
 		}

		genericDao.save(ExpedienteComercial.class, expedienteComercial);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_RESPUESTA_REAGENDACION_BC};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
	
	private String devolverEstadoBC(boolean reagendacion, boolean irComite, boolean novacionRenovacion) {
		String estadoExpBC = DDEstadoExpedienteBc.CODIGO_BORRADOR_ACEPTADO;
		if (!reagendacion) {
			if(novacionRenovacion) {
				estadoExpBC = null;
			}else if(irComite) {
				estadoExpBC = DDEstadoExpedienteBc.CODIGO_PENDIENTE_CP_GED;
			}else {
				estadoExpBC = DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO;
			}
			
		}
		
		return estadoExpBC;
	}
	
	private String devolverEstadoEco(boolean reagendacion, boolean irComite, boolean novacionRenovacion) {
		String estadoEco = DDEstadosExpedienteComercial.PTE_AGENDAR_FIRMA;
		if (!reagendacion) {
			if(novacionRenovacion) {
				estadoEco = DDEstadosExpedienteComercial.PTE_PROPONER_RESCISION;
			}else if(irComite) {
				estadoEco = DDEstadosExpedienteComercial.PTE_COMITE;
			}else {
				estadoEco = DDEstadosExpedienteComercial.ANULADO;
			}
			
		}
		
		return estadoEco;
	}

}
