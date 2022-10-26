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
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoTareasFormalizacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivoRescision;

@Component
public class UpdaterServiceFirmaRescisionContratoAlquilerNoComercial implements UpdaterService {
	
	@Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
	private OfertaApi ofertaApi;
    
    protected static final Log logger = LogFactory.getLog(UpdaterServiceFirmaRescisionContratoAlquilerNoComercial.class);
    
    private static final String COMBO_RESULTADO = "comboResultado";
    
	private static final String CODIGO_T018_FIRMA_RESCISION_CONTRATO = "T018_FirmaRescisionContrato";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		DtoTareasFormalizacion dto = new DtoTareasFormalizacion();

		for(TareaExternaValor valor :  valores){
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setComboResultado(DDSinSiNo.cambioStringtoBooleano(valor.getValor()));
				}
			}
		}
		
		String estadoExpBC = this.devolverEstadoBC(dto.getComboResultado(), tareaExternaActual);
		
		if(estadoExpBC != null) {
			expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoExpBC)));
		}
		
		String estadoEco = this.devolverEstadoEco(dto.getComboResultado(), tareaExternaActual);
		
		if(estadoEco != null) {
			expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoEco)));
		}
		
		if(oferta != null) {
			ofertaApi.finalizarOferta(oferta);
		}
				
		genericDao.save(ExpedienteComercial.class, expedienteComercial);
			
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_FIRMA_RESCISION_CONTRATO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
	
	private String devolverEstadoBC(Boolean comboResultado, TareaExterna tareaExterna) {
		String estadoExpBC = null;
		if(comboResultado != null) {
			if(comboResultado) {
				estadoExpBC = DDEstadoExpedienteBc.CODIGO_RECESION_CONTRATO;
			}
		}
		
		return estadoExpBC;
	}
	
	private String devolverEstadoEco(Boolean comboResultado, TareaExterna tareaExterna) {
		String estadoEco = null;
		
		if(comboResultado != null) {
			if(comboResultado) {
				estadoEco = DDEstadosExpedienteComercial.ANULADO;
			}
		}
		
		return estadoEco;
	}

}
