package es.pfsgroup.plugin.recovery.mejoras.asunto.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;





import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.core.api.asunto.HistoricoAsuntoInfo;
import es.capgemini.pfs.core.api.expediente.EventoApi;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.expediente.model.Evento;
import es.capgemini.pfs.persona.dao.impl.PageSql;
import es.capgemini.pfs.tareaNotificacion.EXTDtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto.MEJHistoricoAsuntoViewDto;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto.MEJHistoricoAsuntoViewDtoComparator;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto.MEJHistoricoAsuntoViewDtoComparator.DateSortOrder;
import es.pfsgroup.plugin.recovery.mejoras.tareas.MEJTareaApi;

@Controller
public class HistoricoAsuntoController {

	private static final String DEFAULT_ABRE_DETALLE_JSP = "plugin/coreextension/tareas/generarNotificacionHistorico";

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private HistoricoAsuntoAbrirDetalleFactory abrirDetalleFactory;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private Executor executor;

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abreDetalleHistorico(String tipoTraza, Long idTarea, Long idTraza, ModelMap model, WebRequest request) {

		Long idEntidad = Long.parseLong(request.getParameter("idEntidad"));

		HistoricoAsuntoAbrirDetalleHandler handler = abrirDetalleFactory.getForTipoTraza(tipoTraza);
		
		if (handler == null) {
			return getDefaultOpenHistoryView(model, request);
		} else {
			Object o = handler.getViewData(idTarea, idTraza, idEntidad);

			model.put("data", o);
			if (o instanceof HashMap<?, ?>) {
				HashMap<String, Object> params = (HashMap<String, Object>) o;
				for (String key : params.keySet()) {

					model.put(key, params.get(key));
				}
			}
			return handler.getJspName();
		}
	}

	private String getDefaultOpenHistoryView(ModelMap model, WebRequest request) {

		EXTDtoGenerarTarea dto = new EXTDtoGenerarTarea();
		boolean puedeResponder = false;
		boolean muestraPreguntaOrigen = false;
		dto.setDescripcion(request.getParameter("descripcion"));
		if (!Checks.esNulo(request.getParameter("idEntidad"))) {
			dto.setIdEntidad(Long.parseLong(request.getParameter("idEntidad")));
			
			EXTTareaNotificacion tarea = genericDao.get(EXTTareaNotificacion.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(request.getParameter("idEntidad"))));
			if (!Checks.esNulo(tarea) && !Checks.esNulo(tarea.getTareaId())){
				EXTTareaNotificacion tareaOrigen = genericDao.get(EXTTareaNotificacion.class, genericDao.createFilter(FilterType.EQUALS, "id", tarea.getTareaId().getId()));
				dto.setDescripcionTareaAsociada(tareaOrigen.getDescripcionTarea());
				muestraPreguntaOrigen = true;	
			}
		}
		dto.setCodigoTipoEntidad(request.getParameter("codigoTipoEntidad"));
		if (!Checks.esNulo(request.getParameter("idTareaAsociada"))) {
			dto.setIdTareaAsociada(Long.parseLong(request.getParameter("idTareaAsociada")));
			puedeResponder = (Boolean) executor.execute("tareaNotificacionManager.puedeResponder", dto);
		}
		dto.setSubtipoTarea(request.getParameter("subtipoTarea"));

		model.put("data", dto);
		model.put("puedeResponder", puedeResponder);
		model.put("muestraPreguntaOrigen", muestraPreguntaOrigen);
		model.put("situacion", request.getParameter("situacion"));
		model.put("isConsulta", request.getParameter("isConsulta"));
		model.put("fecha", request.getParameter("fecha"));

		return DEFAULT_ABRE_DETALLE_JSP;
	}

	@RequestMapping
	public String getHistoricoAgregadoAsunto(@RequestParam(value = "id", required = true) Long id, int limit, int start, String sort, ModelMap map) {

		try {
			List<? extends HistoricoAsuntoInfo> tareas = (List<? extends HistoricoAsuntoInfo>) executor.execute(AsuntoApi.BO_CORE_ASUNTO_GET_EXT_HISTORICO_ASUNTO, id);
			List<Evento> eventos = proxyFactory.proxy(EventoApi.class).getEventosAsunto(id);

			List<MEJHistoricoAsuntoViewDto> historico = juntaYOrdena(tareas, eventos);
			List<MEJHistoricoAsuntoViewDto> historicos = new ArrayList<MEJHistoricoAsuntoViewDto>();

			PageSql page = new PageSql();

			int fromIndex = start;
			int toIndex = start + limit;

			int size = historico.size();

			if (fromIndex < 0 || toIndex < 0) {
				fromIndex = 0;
				toIndex = 25;
			}

			for(MEJHistoricoAsuntoViewDto mhaw : historico){
				mhaw.setAgenda(false);
				if(mhaw.getGroup().equals("D")){
					SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
					
					mhaw.setFechaIni(sdf.format(mhaw.getFechaInicio()));
					mhaw.setAgenda(true);
				}
				
				historicos.add(mhaw);
			}
			if (historicos.size() >= start + limit) {
				historicos = historicos.subList(start, start + limit);
			} else
				historicos = historicos.subList(start, historico.size());

			page.setTotalCount(size);
			page.setResults(historicos);

			map.put("tareas", page);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e);
		}

		return "plugin/mejoras/asuntos/formulario/listaHistoricoTareasJSON";
	}

	private List<MEJHistoricoAsuntoViewDto> juntaYOrdena(List<? extends HistoricoAsuntoInfo> tareas, List<Evento> eventos) {
		ArrayList<MEJHistoricoAsuntoViewDto> lista = new ArrayList<MEJHistoricoAsuntoViewDto>();
		if (!Checks.estaVacio(tareas)) {
			lista.addAll(transfoma(tareas));
		}

		if (!Checks.estaVacio(eventos)) {
			lista.addAll(transforma(eventos));
		}

		Collections.sort(lista, new MEJHistoricoAsuntoViewDtoComparator(DateSortOrder.DESCENDING));
		return lista;
	}

	private Collection<? extends MEJHistoricoAsuntoViewDto> transforma(List<Evento> eventos) {
		ArrayList<MEJHistoricoAsuntoViewDto> result = new ArrayList<MEJHistoricoAsuntoViewDto>();

		for (Evento e : eventos) {
			result.add(new MEJHistoricoAsuntoViewDto(e));
		}

		return result;
	}

	private Collection<? extends MEJHistoricoAsuntoViewDto> transfoma(List<? extends HistoricoAsuntoInfo> tareas) {
		ArrayList<MEJHistoricoAsuntoViewDto> result = new ArrayList<MEJHistoricoAsuntoViewDto>();

		for (HistoricoAsuntoInfo t : tareas) {
			result.add(new MEJHistoricoAsuntoViewDto(t));
		}

		return result;
	}

	/**
	 * Metodo para borrar una tarea asociada a un asunto desde el historico de
	 * asuntos
	 * 
	 * @param id
	 *            Identificador de la traza
	 * @return
	 */
	@RequestMapping
	public String borrarTareaAsunto(Long id, Long idTarea) {

		try {
			proxyFactory.proxy(MEJTareaApi.class).borrarTareaAsunto(id);

			if (!Checks.esNulo(idTarea)) {
				proxyFactory.proxy(TareaNotificacionApi.class).borrarNotificacionTarea(idTarea);
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e);
		}

		return "plugin/mejoras/asuntos/formulario/listaHistoricoTareasJSON";
	}

}
