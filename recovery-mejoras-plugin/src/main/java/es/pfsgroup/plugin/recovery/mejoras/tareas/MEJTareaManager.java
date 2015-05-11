package es.pfsgroup.plugin.recovery.mejoras.tareas;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJInfoRegistro;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJRegistro;
import es.pfsgroup.recovery.api.TareaNotificacionApi;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;

@Component
public class MEJTareaManager implements MEJTareaApi{
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	
	private final Log logger = LogFactory.getLog(getClass());

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_TAREAS_PTES_BUTTONS_LEFT)
	public List<DynamicElement> getButtonsTareasPendientesLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
		.getDynamicElements(
				"plugin.mejoras.web.tareas.buttons.tareasPendientes.left",
				null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_TAREAS_PTES_BUTTONS_RIGHT)
	public List<DynamicElement> getButtonsTareasPendientesRight() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
		.getDynamicElements(
				"plugin.mejoras.web.tareas.buttons.tareasPendientes.right",
				null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_PANEL_TAREAS_BUTTONS_LEFT)
	public List<DynamicElement> getButtonsPanelTareasLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
		.getDynamicElements(
				"plugin.mejoras.web.tareas.buttons.panelTareas.left",
				null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_PANEL_TAREAS_BUTTONS_RIGHT)
	public List<DynamicElement> getButtonsPanelTareasRight() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
		.getDynamicElements(
				"plugin.mejoras.web.tareas.buttons.panelTareas.right",
				null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_TAR_ESPERA_BUTTONS_LEFT)
	public List<DynamicElement> getButtonsTareasEsperaLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
		.getDynamicElements(
				"plugin.mejoras.web.tareas.buttons.tareasEspera.left",
				null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_TAR_ESPERA_BUTTONS_RIGHT)
	public List<DynamicElement> getButtonsTareasEsperaRight() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
		.getDynamicElements(
				"plugin.mejoras.web.tareas.buttons.tareasEspera.right",
				null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_NOTIFICACION_BUTTONS_LEFT)
	public List<DynamicElement> getButtonsNotificacionLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
		.getDynamicElements(
				"plugin.mejoras.web.tareas.buttons.notificacion.left",
				null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_NOTIFICACION_BUTTONS_RIGHT)
	public List<DynamicElement> getButtonsNotificacionRight() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
		.getDynamicElements(
				"plugin.mejoras.web.tareas.buttons.notificacion.right",
				null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_ALERTAS_BUTTONS_LEFT)
	public List<DynamicElement> getButtonsAlertasLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
		.getDynamicElements(
				"plugin.mejoras.web.tareas.buttons.alertas.left",
				null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_ALERTAS_BUTTONS_RIGHT)
	public List<DynamicElement> getButtonsAlertasRight() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
		.getDynamicElements(
				"plugin.mejoras.web.tareas.buttons.alertas.right",
				null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}
	
	@Transactional(readOnly=false)
	@Override
	@BusinessOperation(PluginMejorasBOConstants.BO_EVENTO_BORRAR_TAREA_ASUNTO)
	public void borrarTareaAsunto(Long idTraza) {
		List<MEJInfoRegistro> ls = null;
		try {
			String idTareaPregunta = "";
			ls = genericDao.getList(MEJInfoRegistro.class, genericDao.createFilter(FilterType.EQUALS, "registro.id", idTraza));
			if (!Checks.estaVacio(ls)) {
				for (MEJInfoRegistro listado : ls) {
					genericDao.deleteById(MEJInfoRegistro.class, listado.getId());
					if ("ID_TAREA".equals(listado.getClave())) {
						idTareaPregunta = listado.getValor();
					}
				}
				if (!Checks.esNulo(idTareaPregunta) && !idTareaPregunta.isEmpty()){
					// Buscar si existe tarea de respuesta.
			        Filter fClave = genericDao.createFilter(FilterType.EQUALS, "clave", "ID_TAREA_ORIGINAL");
			        Filter fValor = genericDao.createFilter(FilterType.EQUALS, "valorCorto", idTareaPregunta);
			        Filter fBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			        MEJInfoRegistro infoRegResp = genericDao.get(MEJInfoRegistro.class, fClave, fValor, fBorrado);
			        // Si existe borrarla.
			        if(!Checks.esNulo(infoRegResp) && !Checks.esNulo(infoRegResp.getRegistro())){			        	
			        	Filter f1 = genericDao.createFilter(FilterType.EQUALS, "clave", "ID_TAREA_RESP");
			        	Filter f2 = genericDao.createFilter(FilterType.EQUALS, "registro.id", infoRegResp.getRegistro().getId());
			        	MEJInfoRegistro infoRegPreg = genericDao.get(MEJInfoRegistro.class, f1, f2);
			        	
				        if(!Checks.esNulo(infoRegPreg) && !Checks.esNulo(infoRegPreg.getValor()) && !"null".equals(infoRegPreg.getValor())){
				        	proxyFactory.proxy(TareaNotificacionApi.class).borrarNotificacionTarea(Long.parseLong(infoRegPreg.getValor()));			        
				        }
				        
				        borrarTareaAsunto(infoRegResp.getRegistro().getId());			        	
			        }
				}
			}
			genericDao.deleteById(MEJRegistro.class, idTraza);

		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e);
		}
		
	}

}
