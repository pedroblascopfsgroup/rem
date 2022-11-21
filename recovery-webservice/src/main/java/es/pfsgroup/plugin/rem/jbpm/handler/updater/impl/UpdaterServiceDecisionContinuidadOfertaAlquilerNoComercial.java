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
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoEstados;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;

@Component
public class UpdaterServiceDecisionContinuidadOfertaAlquilerNoComercial implements UpdaterService {
	
	@Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
    private FuncionesTramitesApi funcionesTramitesApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceDecisionContinuidadOfertaAlquilerNoComercial.class);
    
	private static final String CODIGO_T018_DECISION_CONTINUIDAD_OFERTA = "T018_DecisionContinuidadOferta";
	private static final String COMBO_SEGUIR_OFERTA = "seguirOferta";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		boolean seguir = false;
				
		for(TareaExternaValor valor :  valores){
			if(COMBO_SEGUIR_OFERTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				seguir = DDSinSiNo.cambioStringaBooleanoNativo(valor.getValor());
			}
		}

		if(!seguir) {
			expedienteComercial.setMotivoAnulacion(genericDao.get(DDMotivoAnulacionExpediente.class,genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivoAnulacionExpediente.COD_CAIXA_JUDICIALIZADO)));
		}
		
		DtoEstados dtoEstados = this.devolverEstados(seguir);
		
		expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dtoEstados.getCodigoEstadoExpedienteBc())));
		expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dtoEstados.getCodigoEstadoExpediente())));
		
		if(DDEstadosExpedienteComercial.isFirmado(expedienteComercial.getEstado())) {
			funcionesTramitesApi.actualizarEstadosPublicacionActivos(expedienteComercial);
		}
			
		
		genericDao.save(ExpedienteComercial.class, expedienteComercial);
		
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_DECISION_CONTINUIDAD_OFERTA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
	
	private DtoEstados devolverEstados(boolean seguir) {
		DtoEstados dtoEstados = new DtoEstados();
		if(seguir) {
			dtoEstados.setCodigoEstadoExpedienteBc(DDEstadoExpedienteBc.CODIGO_CONTRATO_FIRMADO);
			dtoEstados.setCodigoEstadoExpediente(DDEstadosExpedienteComercial.FIRMADO);
		}else {
			dtoEstados.setCodigoEstadoExpedienteBc(DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO);
			dtoEstados.setCodigoEstadoExpediente(DDEstadosExpedienteComercial.ANULADO);
		}
		
		return dtoEstados;
	}
}
