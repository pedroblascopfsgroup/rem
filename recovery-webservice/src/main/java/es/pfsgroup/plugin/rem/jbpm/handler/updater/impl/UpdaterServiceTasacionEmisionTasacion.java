package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

@Component
public class UpdaterServiceTasacionEmisionTasacion implements
		UpdaterService {

	private static final String FECHA_EMISION = "fechaEmision";
	private static final String CODIGO_T005_EMISION_TASACION = "T005_EmisionTasacion";
	
	@Autowired
	ActivoManager activoApi;

	@Autowired
	private GenericABMDao genericDao;

	
	@Transactional
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, 
			List<TareaExternaValor> valores) {

		Trabajo trabajo = tramite.getTrabajo();
		Filter filter;
		
		for (TareaExternaValor valor : valores) {
			
			// Fecha Emisión
			if (FECHA_EMISION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				// Si hay fecha emisión, estado del trabajo a "Emitida pendiente de pago"
				filter = genericDao.createFilter(FilterType.EQUALS, "codigo" , DDEstadoTrabajo.ESTADO_PENDIENTE_PAGO);
				DDEstadoTrabajo estado = genericDao.get(DDEstadoTrabajo.class, filter);
				trabajo.setEstado(estado);
				Auditoria.save(trabajo);
			}

		}
	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos que ejecutan este guardado adicional
		return new String[] {CODIGO_T005_EMISION_TASACION};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
