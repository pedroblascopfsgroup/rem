package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;

@Component
public class UpdaterServiceSancionOfertaCierreEconomico implements UpdaterService {

   	private static final String CODIGO_T013_CIERRE_ECONOMICO = "T013_CierreEconomico";
   	private static final String CODIGO_T017_CIERRE_ECONOMICO = "T017_CierreEconomico";
	private static final String CODIGO_TRAMITE_FINALIZADO = "11";
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	ActivoManager activoApi;
	
	@Autowired
	private ActivoAdapter activoAdapter;
	
    @Autowired
    private OfertaApi ofertaApi;
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		// Finaliza el trámite
		Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
		tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
		
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
