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
import es.pfsgroup.plugin.rem.api.TramiteAlquilerNoComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoTareasFormalizacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivoRescision;

@Component
public class UpdaterServiceProponerRescisionClienteAlquilerNoComercial implements UpdaterService {
	
	@Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;
	 
    @Autowired
    private TramiteAlquilerNoComercialApi tramiteAlquilerNoComercialApi;
    
    @Autowired
	private OfertaApi ofertaApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceDecisionComiteAlquilerNoComercial.class);
    
	private static final String CODIGO_T018_PROPONER_RESCISION_CLIENTE= "T018_ProponerRescisionCliente";
	private static final String COMBO_RESULTADO ="comboResultado";
	private static final String TIPO_ACTIVO_RESCISION ="tipoActivoRescision";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		DtoTareasFormalizacion dto = new DtoTareasFormalizacion();
		Oferta oferta = expedienteComercial.getOferta();
		
		for(TareaExternaValor valor :  valores){
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				dto.setComboResultado(DDSinSiNo.cambioStringtoBooleano(valor.getValor()));
			}
			if(TIPO_ACTIVO_RESCISION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				dto.setTipoActivoRescision(valor.getValor());
			}
		}
		
		String estadoExpBC = this.devolverEstadoBC(dto.getComboResultado(), dto.getTipoActivoRescision(), tareaExternaActual);
		
		if(estadoExpBC != null) {
			expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoExpBC)));
		}
		
		String estadoEco = this.devolverEstadoEco(dto.getComboResultado(), dto.getTipoActivoRescision(), tareaExternaActual);
		
		if(estadoEco != null) {
			expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoEco)));
		}
		
		if(DDEstadoExpedienteBc.isCompromisoCancelado(expedienteComercial.getEstadoBc())) {
			expedienteComercial.setMotivoAnulacion(genericDao.get(DDMotivoAnulacionExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivoAnulacionExpediente.COD_CAIXA_JUDICIALIZADO)));
			ofertaApi.finalizarOferta(oferta);
		}
	
		
		genericDao.save(ExpedienteComercial.class, expedienteComercial);
		
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_PROPONER_RESCISION_CLIENTE};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}


	private String devolverEstadoBC(Boolean comboResultado, String activoRescion, TareaExterna tareaExterna) {
		String estadoExpBC = null;
		if(comboResultado != null) {
			if(comboResultado) {
				estadoExpBC = DDEstadoExpedienteBc.CODIGO_RECESION_AGENDADA;
			}else {
				if(DDTipoActivoRescision.CODIGO_TERCIARIA.equals(activoRescion)) {
					estadoExpBC = DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO;
				}else {
					estadoExpBC = DDEstadoExpedienteBc.CODIGO_PENDIENTE_CP_GED;
				}
			}
		}
		
		return estadoExpBC;
	}
	
	private String devolverEstadoEco(Boolean comboResultado, String activoRescion, TareaExterna tareaExterna) {
		String estadoEco = null;
		
		if(comboResultado != null) {
			if(comboResultado) {
				estadoEco = DDEstadosExpedienteComercial.PTE_FIRMA_RESCISION;
			}else {
				if(DDTipoActivoRescision.CODIGO_TERCIARIA.equals(activoRescion)) {
					estadoEco = DDEstadosExpedienteComercial.ANULADO;
				}else {
					estadoEco = DDEstadosExpedienteComercial.PTE_COMITE;
				}
			}
		}
		
		return estadoEco;
	}

}
