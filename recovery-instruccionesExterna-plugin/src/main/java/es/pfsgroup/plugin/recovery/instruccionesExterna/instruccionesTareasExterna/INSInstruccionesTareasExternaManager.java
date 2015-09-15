package es.pfsgroup.plugin.recovery.instruccionesExterna.instruccionesTareasExterna;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.util.HtmlUtils;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.instruccionesExterna.PluginInstruccionesExternaBusinessOperations;
import es.pfsgroup.plugin.recovery.instruccionesExterna.api.web.DynamicElementApi;
import es.pfsgroup.plugin.recovery.instruccionesExterna.instruccionesTareasExterna.dao.INSInstruccionesTareasExternaDao;
import es.pfsgroup.plugin.recovery.instruccionesExterna.instruccionesTareasExterna.dto.INSDtoBusquedaInstrucciones;
import es.pfsgroup.plugin.recovery.instruccionesExterna.instruccionesTareasExterna.model.INSInstruccionesTareasExterna;

@Service("ITEInstruccionesTareasExternaManager")
public class INSInstruccionesTareasExternaManager {
	
	@Autowired
	GenericABMDao genericDao;
	
	@Autowired
	INSInstruccionesTareasExternaDao instruccionDao;
	
	@Autowired
	ApiProxyFactory proxyFactory;
	
	@BusinessOperation(PluginInstruccionesExternaBusinessOperations.INS_MGR_LISTAPROCEDIMIENTOS)
	public List<TipoProcedimiento> listaProcedimientos(){
		List<TipoProcedimiento> lista = genericDao.getList(TipoProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		return lista;
	}
	
	@BusinessOperation(PluginInstruccionesExternaBusinessOperations.INS_MGR_LISTATAREAS)
	public List<TareaProcedimiento> listaTareasProcedimiento(Long idProcedimiento){
		Filter filtroTareas = genericDao.createFilter(FilterType.EQUALS, "tipoProcedimiento.id", idProcedimiento);
		List<TareaProcedimiento> lista = genericDao.getList(TareaProcedimiento.class, filtroTareas, genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		return lista;
	}
	
	@BusinessOperation(PluginInstruccionesExternaBusinessOperations.INS_MGR_BUSCAINSTRUCCIONES)
	public Page buscaInstrucciones(INSDtoBusquedaInstrucciones dto){
		EventFactory.onMethodStart(this.getClass());
		return instruccionDao.findInstruciones(dto);
	}
	
	@BusinessOperation(PluginInstruccionesExternaBusinessOperations.INS_MGR_GETINSTRUCCIONES)
	public INSInstruccionesTareasExterna getInstrucciones(Long id){
		EventFactory.onMethodStart(this.getClass());
		Filter filtroInstruccion = genericDao.createFilter(FilterType.EQUALS, "id", id);
		INSInstruccionesTareasExterna instruccion = genericDao.get(INSInstruccionesTareasExterna.class, filtroInstruccion);
		
		EventFactory.onMethodStop(this.getClass());
		return instruccion;
	}
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginInstruccionesExternaBusinessOperations.INS_MGR_SAVEINSTRUCCIONES)
	public void guardaInstrucciones(INSDtoBusquedaInstrucciones dto){
		if(Checks.esNulo(dto.getId())){
			throw new IllegalArgumentException(
					"No existe la tarea elegida");
		}
		INSInstruccionesTareasExterna instruccion= getInstrucciones(dto.getId());
		String label = HtmlUtils.htmlUnescape(dto.getLabel());
		instruccion.setLabel(label);
		genericDao.save(INSInstruccionesTareasExterna.class, instruccion);
		
	}
	
	@BusinessOperation(PluginInstruccionesExternaBusinessOperations.INS_MGR_PUNTO_ENGANCHE_BUTTONS_LEFT)
	List<DynamicElement> getButtonInstruccionesTareasLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.instruccionesExterna.web.buttons.left",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation(PluginInstruccionesExternaBusinessOperations.INS_MGR_PUNTO_ENGANCHE_BUTTONS_RIGHT)
	List<DynamicElement> getButtonsIntruccionesTareasRight() {
		List<DynamicElement> l =  proxyFactory.proxy(DynamicElementApi.class).getDynamicElements(
				"plugin.instruccionesExterna.web.buttons.right", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}


}
