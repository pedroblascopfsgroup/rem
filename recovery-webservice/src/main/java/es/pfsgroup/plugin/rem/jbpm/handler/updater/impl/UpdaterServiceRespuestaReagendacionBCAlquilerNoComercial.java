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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerNoComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Component
public class UpdaterServiceRespuestaReagendacionBCAlquilerNoComercial implements UpdaterService {
	
	@Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
	private TramiteAlquilerNoComercialApi tramiteAlquilerNoComercialApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceRespuestaReagendacionBCAlquilerNoComercial.class);
    
    private static final String COMBO_RESULTADO = "comboResultado";
	private static final String CODIGO_T018_RESPUESTA_REAGENDACION_BC = "T018_RespuestaReagendacionBC";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		
		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		boolean reagendacion = false;
		boolean estadoBcModificado = false;
		boolean estadoModificado = false;
 		boolean novacionRenovacion = tramiteAlquilerNoComercialApi.esRenovacion(tareaExternaActual);
		boolean alquilerSocial = tramiteAlquilerNoComercialApi.esAlquilerSocial(tareaExternaActual);
 		
 		for(TareaExternaValor valor :  valores){
			
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if (DDSiNo.SI.equals(valor.getValor())) {					
					reagendacion = true;
				}
			}
		}
 		
 		String estadoBC = this.devolverEstadoBC(reagendacion);
		
		if(estadoBC != null) {
			expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBC)));
		}
		
		String estadoEco = this.devolverEstadoEco(reagendacion, novacionRenovacion, alquilerSocial);
		
		if(estadoEco != null) {
			expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoEco)));
		}
 		
		estadoBcModificado = true;
		estadoModificado = true;
		genericDao.save(ExpedienteComercial.class, expedienteComercial);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_RESPUESTA_REAGENDACION_BC};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
	
	private String devolverEstadoBC(Boolean reagendacion) {
		String estadoExpBC = null;
		if (reagendacion) {
			estadoExpBC = DDEstadoExpedienteBc.CODIGO_BORRADOR_ACEPTADO;
		} else {
			estadoExpBC = DDEstadoExpedienteBc.CODIGO_RECESION_CONTRATO;
		}
		
		return estadoExpBC;
	}
	
	private String devolverEstadoEco(Boolean reagendacion, Boolean novacionRenovacion, Boolean alquilerSocial) {
		String estadoEco = null;
		
		if(novacionRenovacion) {
			if (reagendacion) {
				estadoEco = DDEstadosExpedienteComercial.PTE_AGENDAR_FIRMA;
			} else {
				estadoEco = DDEstadosExpedienteComercial.PTE_PROPONER_RESCISION;
			}
		}
		
		return estadoEco;
	}

}
