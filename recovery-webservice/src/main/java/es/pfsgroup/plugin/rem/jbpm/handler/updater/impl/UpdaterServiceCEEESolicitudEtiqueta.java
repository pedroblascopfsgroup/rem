package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

@Component
public class UpdaterServiceCEEESolicitudEtiqueta implements UpdaterService {
	
	@Autowired
    private GenericABMDao genericDao;
	
    
	private static final String CODIGO_T003_SOLICITUD_ETIQUETA = "T003_SolicitudEtiqueta";
	
	@Transactional
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		Trabajo trabajo = tramite.getTrabajo();
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo" , DDEstadoTrabajo.ESTADO_CEE_PENDIENTE_ETIQUETA);
		DDEstadoTrabajo estado = genericDao.get(DDEstadoTrabajo.class, filter);
		trabajo.setEstado(estado);
		Auditoria.save(trabajo);

	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos.
		return new String[]{CODIGO_T003_SOLICITUD_ETIQUETA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
