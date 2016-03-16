package es.pfsgroup.plugin.recovery.mejoras.tareaNotificacion.controller;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.tareaNotificacion.dao.TareaNotificacionDao;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.NFADDTipoRevisionAlerta;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;

@Controller
public class TareaNotificacionController {
	
	private static final String JSON_PLUGIN_MEJORAS_TAREAS_CONSULTA_NOTIF_SIN_RESP = "plugin/mejoras/tareas/consultaNotificacionSinRespuestaJSON";
	
	@Resource
	Properties appProperties;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
    private Executor executor;
	
	@Autowired
	private GenericABMDao genericDao;
	
    @Autowired
    private TareaNotificacionDao tareaNotificacionDao;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String editarAlertaTarea(@RequestParam(value = "id", required = true) Long id, ModelMap map) {
			
		Filter filtroIdTarea=genericDao.createFilter(FilterType.EQUALS, "id", id);
		EXTTareaNotificacion tarea = genericDao.get(EXTTareaNotificacion.class, filtroIdTarea);
		
		List<NFADDTipoRevisionAlerta> tiposRevision= genericDao.getList(NFADDTipoRevisionAlerta.class);
		
		map.put("tarea", tarea);
		map.put("tiposRevision", tiposRevision);
		
		return "plugin/mejoras/tareas/formulario/editaAlertaTarea";
	}
	
	@RequestMapping
	public String guardarModificacionAlerta(@RequestParam(value = "id", required = true) Long id,
			@RequestParam(value = "revisada", required = true) Boolean revisada,
			@RequestParam(value="tipoRevision", required=false) Long tipoRevision,
			@RequestParam(value = "comentariosAlerta", required = true) String comentariosAlerta){
		proxyFactory.proxy(TareaNotificacionApi.class).editarAlertaTarea(id, revisada,tipoRevision,comentariosAlerta );
		return "default";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	@Transactional(readOnly = false)
	public String finalizarNotificacion(@RequestParam(value = "idTarea", required = true) Long idTarea, ModelMap model){
        TareaNotificacion tarea = tareaNotificacionDao.get(idTarea);
        tarea.setTareaFinalizada(true);
        genericDao.readWrite(TareaNotificacion.class).update(tarea);
        model.put("idTarea", idTarea);
		return JSON_PLUGIN_MEJORAS_TAREAS_CONSULTA_NOTIF_SIN_RESP;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
    public String exportacionTareasExcelCount(@RequestParam(value = "codigoTipoTarea", required = true) String codigoTipoTarea,
    		@RequestParam(value = "perfilUsuario", required = true) Long perfilUsuario,
    		@RequestParam(value = "enEspera", required = true) Boolean enEspera,
    		@RequestParam(value = "esAlerta", required = true) Boolean esAlerta,
    		@RequestParam(value = "limit", required = true) Integer limit,
    		@RequestParam(value = "nombreTarea", required = true) String nombreTarea,
    		@RequestParam(value = "descripcionTarea", required = true) String descripcionTarea,
    		@RequestParam(value = "fechaVencimientoDesde", required = true) String fechaVencimientoDesde,
    		@RequestParam(value = "fechaVencDesdeOperador", required = true) String fechaVencDesdeOperador,
    		@RequestParam(value = "fechaVencimientoHasta", required = true) String fechaVencimientoHasta,
    		@RequestParam(value = "fechaVencimientoHastaOperador", required = true) String fechaVencimientoHastaOperador, ModelMap model) {	
		
		
		DtoBuscarTareaNotificacion dto = new DtoBuscarTareaNotificacion();
		dto.setCodigoTipoTarea(codigoTipoTarea);
		dto.setPerfilUsuario(perfilUsuario);
		dto.setEnEspera(enEspera);
		dto.setEsAlerta(esAlerta);
		Parametrizacion param = (Parametrizacion) executor.execute(ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
                Parametrizacion.LIMITE_EXPORT_EXCEL_BUSCADOR_TAREAS);
        int limite = Integer.parseInt(param.getValor());
		dto.setLimit(limite);
		dto.setBusqueda(true);
		dto.setStart(0);
		dto.setNombreTarea(nombreTarea);
		dto.setDescripcionTarea(descripcionTarea);
		dto.setFechaVencimientoDesde(fechaVencimientoDesde);
		dto.setFechaVencDesdeOperador(fechaVencDesdeOperador);
		dto.setFechaVencimientoHasta(fechaVencimientoHasta);
		dto.setFechaVencimientoHastaOperador(fechaVencimientoHastaOperador);
    	
		model.put("count", proxyFactory.proxy(TareaNotificacionApi.class).buscarTareasParaExcelCount(dto));
		model.put("limit", limite);
    	
		return "plugin/mejoras/tareas/exportacionTareasCountJSON";
    }

	@SuppressWarnings("unchecked")
	@RequestMapping
    public String exportacionTareasPaginaDescarga(@RequestParam(value = "codigoTipoTarea", required = true) String codigoTipoTarea,
    		@RequestParam(value = "perfilUsuario", required = true) Long perfilUsuario,
    		@RequestParam(value = "enEspera", required = true) Boolean enEspera,
    		@RequestParam(value = "esAlerta", required = true) Boolean esAlerta,
    		@RequestParam(value = "limit", required = true) Integer limit,
    		@RequestParam(value = "nombreTarea", required = true) String nombreTarea,
    		@RequestParam(value = "descripcionTarea", required = true) String descripcionTarea,
    		@RequestParam(value = "fechaVencimientoDesde", required = true) String fechaVencimientoDesde,
    		@RequestParam(value = "fechaVencDesdeOperador", required = true) String fechaVencDesdeOperador,
    		@RequestParam(value = "fechaVencimientoHasta", required = true) String fechaVencimientoHasta,
    		@RequestParam(value = "fechaVencimientoHastaOperador", required = true) String fechaVencimientoHastaOperador, ModelMap model) {	
		
		
		DtoBuscarTareaNotificacion dto = new DtoBuscarTareaNotificacion();
		dto.setCodigoTipoTarea(codigoTipoTarea);
		dto.setPerfilUsuario(perfilUsuario);
		dto.setEnEspera(enEspera);
		dto.setEsAlerta(esAlerta);
		dto.setLimit(limit);
		dto.setBusqueda(true);
		dto.setStart(0);
		dto.setNombreTarea(nombreTarea);
		dto.setDescripcionTarea(descripcionTarea);
		dto.setFechaVencimientoDesde(fechaVencimientoDesde);
		dto.setFechaVencDesdeOperador(fechaVencDesdeOperador);
		dto.setFechaVencimientoHasta(fechaVencimientoHasta);
		dto.setFechaVencimientoHastaOperador(fechaVencimientoHastaOperador);    	
		model.put("dto", dto);
    	
		return "plugin/mejoras/tareas/listaTareasExcel";
    }

}
