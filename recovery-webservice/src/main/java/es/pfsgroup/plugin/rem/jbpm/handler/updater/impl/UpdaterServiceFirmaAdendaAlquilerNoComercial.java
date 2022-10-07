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
import es.pfsgroup.plugin.rem.api.FuncionesTramitesApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerNoComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoEstados;
import es.pfsgroup.plugin.rem.model.DtoTareasFormalizacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;

@Component
public class UpdaterServiceFirmaAdendaAlquilerNoComercial implements UpdaterService {
	
	@Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;
	 
    @Autowired
    private TramiteAlquilerNoComercialApi tramiteAlquilerNoComercialApi;
    
    @Autowired
    private FuncionesTramitesApi funcionesTramitesApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceFirmaAdendaAlquilerNoComercial.class);
    
	private static final String CODIGO_T018_FIRMA_ADENDA = "T018_FirmaAdenda";
	private static final String TEXTO_JUSTIFICACION ="justificacion";
	private static final String COMBO_ACEPTA_FIRMA = "comboResultado";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		DtoTareasFormalizacion dto = new DtoTareasFormalizacion();
		Oferta oferta = expedienteComercial.getOferta();
		
		for(TareaExternaValor valor :  valores){
			if(COMBO_ACEPTA_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				dto.setAdendaFirmada(DDSinSiNo.cambioStringtoBooleano(valor.getValor()));
			}
			if(TEXTO_JUSTIFICACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				dto.setMotivo(valor.getValor());
			}
		}
		
		DtoEstados dtoEstados = this.devolverEstados(dto.getAdendaFirmada(), tareaExternaActual);
		if(dtoEstados.getCodigoEstadoExpedienteBc() != null) {
			expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dtoEstados.getCodigoEstadoExpedienteBc())));
		}
		
		expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dtoEstados.getCodigoEstadoExpediente())));
		if(DDEstadosExpedienteComercial.isFirmado(expedienteComercial.getEstado())) {
			funcionesTramitesApi.actualizarEstadosPublicacionActivos(expedienteComercial);
		}
			
		
		tramiteAlquilerNoComercialApi.saveHistoricoFirmaAdenda(dto, oferta);
		
		genericDao.save(ExpedienteComercial.class, expedienteComercial);
		
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_FIRMA_ADENDA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}


	private DtoEstados devolverEstados(Boolean adendaFirmada,  TareaExterna tareaExterna) {
		DtoEstados dtoEstados = new DtoEstados();
		
		if(adendaFirmada != null && adendaFirmada) {
			dtoEstados.setCodigoEstadoExpedienteBc(DDEstadoExpedienteBc.CODIGO_CONTRATO_FIRMADO);
			dtoEstados.setCodigoEstadoExpediente(DDEstadosExpedienteComercial.FIRMADO);
		}else if(!tramiteAlquilerNoComercialApi.firmaMenosTresVeces(tareaExterna)) {
			dtoEstados.setCodigoEstadoExpedienteBc(DDEstadoExpedienteBc.CODIGO_IMPOSIBILIDAD_FIRMA);
			dtoEstados.setCodigoEstadoExpediente(DDEstadosExpedienteComercial.PTE_RESPUESTA_BC);
		}else {
			dtoEstados.setCodigoEstadoExpediente(DDEstadosExpedienteComercial.PTE_AGENDAR_FIRMA_ADENDA);
		}
		
		return dtoEstados;
	}
}
