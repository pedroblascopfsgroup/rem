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
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoTareasFormalizacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;

@Component
public class UpdaterServiceConfirmacionBCAlquilerNoComercial implements UpdaterService {
	
	@Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceConfirmacionBCAlquilerNoComercial.class);
    
	private static final String CODIGO_T018_CONFIRMACION_BC = "T018_ConfirmacionBC";
	private static final String COMBO_CONFIRMA = "confirma";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		DtoTareasFormalizacion dto = new DtoTareasFormalizacion();
		
		for(TareaExternaValor valor :  valores){
			if(COMBO_CONFIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				dto.setComboResultado(DDSinSiNo.cambioStringtoBooleano(valor.getValor()));
			}
		}
		
		String estadoExpBC = this.devolverEstadoBC(dto.getComboResultado(), tareaExternaActual);
		
		if(estadoExpBC != null) {
			expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigoC4C", estadoExpBC)));
		}
		
		String estadoEco = this.devolverEstadoEco(dto.getComboResultado(), tareaExternaActual);
		
		if(estadoEco != null) {
			expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoEco)));
		}
				
		genericDao.save(ExpedienteComercial.class, expedienteComercial);
		
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_CONFIRMACION_BC};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}


	private String devolverEstadoBC(Boolean comboResultado,  TareaExterna tareaExterna) {
		String estadoExpBC = null;
		if(comboResultado != null) {
			if(comboResultado) {
				estadoExpBC = DDEstadoExpedienteBc.CODIGO_IMPORTE_FINAL_APROBADO;
			}
		}
		
		return estadoExpBC;
	}
	
	private String devolverEstadoEco(Boolean comboResultado,  TareaExterna tareaExterna) {
		String estadoEco = null;
		
		if(comboResultado != null) {
			if(comboResultado) {
				estadoEco = DDEstadosExpedienteComercial.PTE_TRASLADAR_OFERTA_AL_CLIENTE;
			}
		
		}
		return estadoEco;
	}
}
