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
import es.pfsgroup.plugin.rem.api.FuncionesTramitesApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Fianzas;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Component
public class UpdaterServiceEntregaFianzasAlquilerNoComercial implements UpdaterService {
	
	@Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private FuncionesTramitesApi funcionesTramitesApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceEntregaFianzasAlquilerNoComercial.class);
    
    private static final String COMBO_RESULTADO = "comboResultado";
	private static final String CODIGO_T018_ENTREGA_FIANZAS = "T018_EntregaFianzas";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		
		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		boolean fianzaAbonada = false;
 		
 		for(TareaExternaValor valor :  valores){
			
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if (DDSiNo.SI.equals(valor.getValor())) {					
					fianzaAbonada = true;
				}
			}
		}
 		
 		String estadoBC = this.devolverEstadoBC(fianzaAbonada, tareaExternaActual);
		
		if(estadoBC != null) {
			expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBC)));
		}
		
		String estadoEco = this.devolverEstadoEco(fianzaAbonada, tareaExternaActual);
		
		if(estadoEco != null) {
			expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoEco)));
		}
		
		if(fianzaAbonada) {
			this.saveFechaIngresoFianza(expedienteComercial);
		}
 		
		genericDao.save(ExpedienteComercial.class, expedienteComercial);			
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_ENTREGA_FIANZAS};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
	
	private String devolverEstadoBC(Boolean fianzaAbonada, TareaExterna tareaExternaActual) {
		String estadoExpBC = null;
		if (fianzaAbonada) {
			estadoExpBC = DDEstadoExpedienteBc.CODIGO_FIRMA_DE_CONTRATO_AGENDADO;
		} else {
			if(funcionesTramitesApi.seHaReagendado2VecesOMas(tareaExternaActual)) {
				estadoExpBC = DDEstadoExpedienteBc.CODIGO_VALIDACION_DE_FIRMA_DE_CONTRATO_POR_BC;
			}else {
				estadoExpBC = DDEstadoExpedienteBc.CODIGO_BORRADOR_ACEPTADO;
			}
		}
		
		return estadoExpBC;
	}
	
	private String devolverEstadoEco(Boolean fianzaAbonada, TareaExterna tareaExternaActual) {
		String estadoEco = null;
		if (fianzaAbonada) {
			estadoEco = DDEstadosExpedienteComercial.PTE_FIRMA;
		} else {
			if(funcionesTramitesApi.seHaReagendado2VecesOMas(tareaExternaActual)) {
				estadoEco = DDEstadosExpedienteComercial.PTE_RESPUESTA_BC;
			}else {
				estadoEco = DDEstadosExpedienteComercial.PTE_AGENDAR_FIRMA;
			}
		}
		
		return estadoEco;
	}
	
	private void saveFechaIngresoFianza(ExpedienteComercial expedienteComercial) {
		Fianzas fianza = genericDao.get(Fianzas.class, genericDao.createFilter(FilterType.EQUALS, "oferta.id", expedienteComercial.getOferta().getId()));
		CondicionanteExpediente coe = expedienteComercial.getCondicionante();
		if(fianza != null) {
			fianza.setFechaIngreso(new Date());
			genericDao.save(Fianzas.class, fianza);
		}
		if(coe != null) {
			coe.setFechaIngresoFianzaArrendatario(new Date());
			genericDao.save(CondicionanteExpediente.class, coe);
		}	
	}

}
