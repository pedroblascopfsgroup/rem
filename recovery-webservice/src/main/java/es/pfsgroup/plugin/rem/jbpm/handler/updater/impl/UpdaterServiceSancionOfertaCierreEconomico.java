package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Component
public class UpdaterServiceSancionOfertaCierreEconomico implements UpdaterService {

   	private static final String CODIGO_T013_CIERRE_ECONOMICO = "T013_CierreEconomico";
   	private static final String CODIGO_T017_CIERRE_ECONOMICO = "T017_CierreEconomico";
	private static final String CODIGO_TRAMITE_FINALIZADO = "11";
	private static final String CODIGO_SUBCARTERA_OMEGA = "65";
	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaCierreEconomico.class);
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	ActivoApi activoApi;
	
	@Autowired
	ActivoDao activoDao;
	
	@Autowired
	private ActivoAdapter activoAdapter;
	
    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
    
    
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		// Finaliza el trámite
		Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
		tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		Activo activo = ofertaAceptada.getActivoPrincipal();
		
		if(!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());

			if (!Checks.esNulo(expediente)) { 
				String codSubCartera = null;
				if (!Checks.esNulo(activo.getSubcartera())) {
					codSubCartera = activo.getSubcartera().getCodigo();
				}
				if (CODIGO_SUBCARTERA_OMEGA.equals(codSubCartera)) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.VENDIDO);
					DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
					expediente.setEstado(estado);
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

					expedienteComercialApi.update(expediente, true);
				}
			}
		}
		
		genericDao.save(ActivoTramite.class, tramite);
		
		activoApi.actualizarOfertasTrabajosVivos(tramite.getActivo());
		
		if(!Checks.esNulo(tramite.getActivo())){
			activoAdapter.actualizarEstadoPublicacionActivo(tramite.getActivo().getId(), true);
		}
		
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_CIERRE_ECONOMICO, CODIGO_T017_CIERRE_ECONOMICO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
