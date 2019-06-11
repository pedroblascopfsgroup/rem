package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

@Component
public class UpdaterServiceSancionOfertaCierreEconomico implements UpdaterService {

   	private static final String CODIGO_T013_CIERRE_ECONOMICO = "T013_CierreEconomico";
   	private static final String CODIGO_T017_CIERRE_ECONOMICO = "T017_CierreEconomico";
	private static final String CODIGO_TRAMITE_FINALIZADO = "11";
	
	@Autowired
	private GenericABMDao genericDao;
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		// Finaliza el trámite
		Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
		tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
		genericDao.save(ActivoTramite.class, tramite);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_CIERRE_ECONOMICO, CODIGO_T017_CIERRE_ECONOMICO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
