package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
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
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoTareaPbc;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoCampo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTareaPbc;

@Component
public class UpdaterServiceSancionOfertaAlquileresSancionBc implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private TramiteAlquilerApi tramiteAlquilerApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresSancionBc.class);
    
	private static final String RESULTADO_PBC = "comboResolucion";

	private static final String CODIGO_T015_SANCION_BC = "T015_SancionBC";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		boolean estadoBcModificado = false;
		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		boolean aprueba = false;
		String estadoExp = null;
		String estadoBc = null;
		
		for(TareaExternaValor valor :  valores){
			
			if(RESULTADO_PBC.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if (DDSiNo.SI.equals(valor.getValor())) {
					aprueba = true;
				}
			}
		}

		if (aprueba) {
			
			if(tramiteAlquilerApi.isOfertaContraOfertaMayor10K(tareaExternaActual)) {
				estadoExp = DDEstadosExpedienteComercial.PTE_PBC;
			}else {
				estadoExp =  DDEstadosExpedienteComercial.PTE_ENVIO;
			}
			estadoBc =  DDEstadoExpedienteBc.CODIGO_SCORING_APROBADO;
			
		} else{
			estadoExp =  DDEstadosExpedienteComercial.DENEGADO;
			estadoBc =  DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO;
			Oferta oferta = expedienteComercial.getOferta();
			
			if(oferta != null) {
				ofertaApi.finalizarOferta(oferta);
			}

		}
		
		expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoExp)));
		expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBc)));
		estadoBcModificado = true;
		genericDao.save(ExpedienteComercial.class, expedienteComercial);	
		if(estadoBcModificado) {
			ofertaApi.replicateOfertaFlushDto(expedienteComercial.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expedienteComercial));
		}
		
		Filter filterOferta =  genericDao.createFilter(FilterType.EQUALS, "oferta.id", expedienteComercial.getOferta().getId());
		Filter filterTipoPbc =  genericDao.createFilter(FilterType.EQUALS, "tipoTareaPbc.codigo", DDTipoTareaPbc.CODIGO_PBC);
		Filter filterActiva =  genericDao.createFilter(FilterType.EQUALS, "activa", true);
		HistoricoTareaPbc historico = genericDao.get(HistoricoTareaPbc.class, filterOferta, filterTipoPbc, filterActiva);
		
		if (historico != null) {
			historico.setActiva(false);
			
			genericDao.save(HistoricoTareaPbc.class, historico);
		}
		
		Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoTareaPbc.CODIGO_PBC);
		DDTipoTareaPbc tpb = genericDao.get(DDTipoTareaPbc.class, filtroTipo);
		
		HistoricoTareaPbc htp = new HistoricoTareaPbc();
		htp.setOferta(expedienteComercial.getOferta());
		htp.setTipoTareaPbc(!Checks.esNulo(tpb) ? tpb : null);
		
		genericDao.save(HistoricoTareaPbc.class, htp);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_SANCION_BC};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
}
