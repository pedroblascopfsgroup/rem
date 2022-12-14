package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

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
import es.pfsgroup.plugin.rem.api.TramiteAlquilerNoComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoTareasFormalizacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;

@Component
public class UpdaterServiceRespuestaContraofertaBCAlquilerNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
	private TramiteAlquilerNoComercialApi tramiteAlquilerNoComercialApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceRespuestaContraofertaBCAlquilerNoComercial.class);
    
	private static final String COMBO_RESULTADO = "comboResultado";
	private static final String CODIGO_T018_RESPUESTA_CONTRAOFERTA_BC = "T018_RespuestaContraofertaBC";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		DtoTareasFormalizacion dto = new DtoTareasFormalizacion();
		boolean novacionRenovacion = tramiteAlquilerNoComercialApi.esRenovacion(tareaExternaActual);
		boolean alquilerSocial = tramiteAlquilerNoComercialApi.esAlquilerSocial(tareaExternaActual);
		
		for(TareaExternaValor valor :  valores){
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				dto.setComboResultado(DDSinSiNo.cambioStringaBooleanoNativo(valor.getValor()));
			}
		}
		
		String estadoExpBC = this.devolverEstadoBC(dto.getComboResultado(), alquilerSocial, novacionRenovacion, tareaExternaActual);
		if(estadoExpBC != null) {
			expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoExpBC)));
		}
		
		String estadoEco = this.devolverEstadoEco(dto.getComboResultado(), alquilerSocial, novacionRenovacion, tareaExternaActual);
		
		if(estadoEco != null) {
			expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoEco)));
		}

		genericDao.save(ExpedienteComercial.class, expedienteComercial);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_RESPUESTA_CONTRAOFERTA_BC};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
	
	private String devolverEstadoBC(boolean comboResultado, Boolean alquilerSocial, Boolean novacionRenovacion, TareaExterna tareaExterna) {
		String estadoExpBC = null;
		if(comboResultado) {
			if(alquilerSocial) {
				estadoExpBC = DDEstadoExpedienteBc.CODIGO_CONTRAOFERTADO;
			}else if(novacionRenovacion) {
				estadoExpBC = DDEstadoExpedienteBc.CODIGO_IMPORTE_FINAL_APROBADO;
			}
		}else {
			if(alquilerSocial) {
				estadoExpBC = DDEstadoExpedienteBc.CODIGO_PENDIENTE_CP_GED;
			}
		}
		
		return estadoExpBC;
	}
	
	private String devolverEstadoEco(boolean comboResultado, Boolean alquilerSocial, Boolean novacionRenovacion, TareaExterna tareaExterna) {
		String estadoEco = null;
		if(comboResultado) {
			if(alquilerSocial || novacionRenovacion) {
				estadoEco = DDEstadosExpedienteComercial.PTE_TRASLADAR_OFERTA_AL_CLIENTE;
			}
		}else {
			if(alquilerSocial) {
				estadoEco = DDEstadosExpedienteComercial.PTE_COMITE;
			}else if(novacionRenovacion) {
				estadoEco = DDEstadosExpedienteComercial.PTE_PROPONER_RESCISION;
			}
		}
		
		return estadoEco;
	}

}
