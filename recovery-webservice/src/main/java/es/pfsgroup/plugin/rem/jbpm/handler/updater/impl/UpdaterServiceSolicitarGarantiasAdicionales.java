package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;

@Component
public class UpdaterServiceSolicitarGarantiasAdicionales implements UpdaterService {

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private TramiteAlquilerApi tramiteAlquilerApi;
	
	
	@Autowired
	private GenericABMDao genericDao;


	private static final String CODIGO_T015_SOLICITAR_GARANTIAS_ADICIONALES = "T015_SolicitarGarantiasAdicionales";
	private static final String COMBO_RESPUESTA_COMPRADOR = "comboResultado";


	protected static final Log logger = LogFactory.getLog(UpdaterServiceSolicitarGarantiasAdicionales.class);

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		Boolean haPasadoScoringBC = tramiteAlquilerApi.haPasadoScoringBC(tramite.getId());
		String respuestaComprador = null;
	
		if (ofertaAceptada != null) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			for(TareaExternaValor valor :  valores){
				if(COMBO_RESPUESTA_COMPRADOR.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					respuestaComprador = valor.getValor();
					break;
				}
			}

			if(!Checks.esNulo(respuestaComprador)) {
				Boolean acepta = DDSinSiNo.cambioStringtoBooleano(respuestaComprador);
				String estadoCodigo = null;
				String estadoBcCodigo = null;
				if(!haPasadoScoringBC && acepta) {
					estadoCodigo = DDEstadosExpedienteComercial.PTE_PBC;
					estadoBcCodigo = DDEstadoExpedienteBc.CODIGO_SCORING_APROBADO;
				}else if((haPasadoScoringBC && acepta)|| (!haPasadoScoringBC && !acepta)){
					estadoBcCodigo = DDEstadoExpedienteBc.CODIGO_VALORAR_ACUERDO_SIN_GARANTIAS_ADICIONALES;
				}else{
					estadoCodigo = DDEstadosExpedienteComercial.DENEGADO;
					estadoBcCodigo = DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA;
					ofertaApi.finalizarOferta(ofertaAceptada);
				}
				
				if(estadoBcCodigo != null) {
					DDEstadoExpedienteBc estadoBc = genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBcCodigo));
					expediente.setEstadoBc(estadoBc);
				}
				
				if(estadoCodigo != null) {
					DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoCodigo));
					expediente.setEstado(estado);
				}
				genericDao.save(ExpedienteComercial.class, expediente);
			}

		}
	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T015_SOLICITAR_GARANTIAS_ADICIONALES };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
