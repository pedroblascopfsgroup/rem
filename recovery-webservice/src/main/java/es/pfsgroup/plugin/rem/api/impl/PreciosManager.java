package es.pfsgroup.plugin.rem.api.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.PreciosApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.PropuestaPreciosExcelReport;
import es.pfsgroup.plugin.rem.factory.PropuestaPreciosExcelFactoryApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoPropuesta;
import es.pfsgroup.plugin.rem.model.ActivoPropuesta.ActivoPropuestaPk;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPrecios;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPropuesta;
import es.pfsgroup.plugin.rem.model.VBusquedaNumActivosTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPropuestaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPropuestaPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPropuestaPrecio;
import es.pfsgroup.plugin.rem.propuestaprecios.dao.PropuestaPrecioDao;
import es.pfsgroup.plugin.rem.propuestaprecios.dao.VActivosPropuestaDao;
import es.pfsgroup.plugin.rem.propuestaprecios.dao.VNumActivosTipoPrecioDao;
import es.pfsgroup.plugin.rem.service.PropuestaPreciosExcelService;

@Service("preciosManager")
public class PreciosManager extends BusinessOperationOverrider<PreciosApi> implements  PreciosApi {
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private PropuestaPrecioDao propuestaPrecioDao;
	
	@Autowired
	private VActivosPropuestaDao vActivosPropuestaDao;
	
	@Autowired
	private VNumActivosTipoPrecioDao vNumActivosTipoPrecioDao;
	
	@Autowired
	private PropuestaPreciosExcelFactoryApi propuestaPreciosExcelFactory;

	@Autowired
	private TrabajoApi trabajoApi;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

		
	@Override
	public String managerName() {
		return "preciosManager";
	}
	
	@Override
	public Page getActivos(DtoActivoFilter dtoActivoFiltro) {
		
		return activoDao.getListActivosPrecios(dtoActivoFiltro);
		
	}	
	
	@Override
	public Page getPropuestas(DtoPropuestaFilter dtoPropuestaFiltro) {

		return propuestaPrecioDao.getListPropuestasPrecio(dtoPropuestaFiltro);
	}
	
	@Override
	public Page getHistoricoPropuestasPrecios(DtoHistoricoPropuestaFilter dtoPropuestaFiltro) {
		
		return propuestaPrecioDao.getListHistoricoPropuestasPrecios(dtoPropuestaFiltro);
	}
	
	@Override
	@Transactional(readOnly = false)
	public PropuestaPrecio createPropuestaPreciosManual(List<VBusquedaActivosPrecios> activosPrecios, String nombrePropuesta, String tipoPropuestaCodigo){

		// Se instancia una lista de Activos, usando los id's de activos de la lista del buscador
		List<Activo> activos = new ArrayList<Activo>();
		for(VBusquedaActivosPrecios activoPrecio : activosPrecios){
			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(activoPrecio.getId()));
			Activo activo = (Activo) genericDao.get(Activo.class, filtroActivo);
			activos.add(activo);
		}

		// Se toman precauciones para crear una lista con activos unicos ya que proveniendo de una vista,
		// pueden haberse creado filas multiples del mismo activo
		Set<Activo> uniqueSetActivos =  new HashSet<Activo>(activos);
		List<Activo> uniqueListActivos = new ArrayList<Activo>(uniqueSetActivos);
		
		// Nueva propuesta de precios con activos asociados
		Boolean esPropManual = true;
		PropuestaPrecio propuestaPrecio = createPropuestaPrecios(uniqueListActivos, nombrePropuesta, tipoPropuestaCodigo, esPropManual);
		
		// Nuevo trabajo+tramite de propuesta de precios: La propuesta es necesaria para crear la relacion con el nuevo trabajo.
		DDSubtipoTrabajo subtipoTrabajoPropuestaPrecios = (DDSubtipoTrabajo) utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoTrabajo.class, DDSubtipoTrabajo.CODIGO_TRAMITAR_PROPUESTA_PRECIOS);
		Trabajo trabajo = trabajoApi.create(subtipoTrabajoPropuestaPrecios, uniqueListActivos, propuestaPrecio);
		
		// Relacion nuevo trabajo con nueva propuesta
		propuestaPrecio.setTrabajo(trabajo);
		
		propuestaPrecioDao.saveOrUpdate(propuestaPrecio);
		
		return propuestaPrecio;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public PropuestaPrecio createPropuestaPrecios(List<Activo> activos, String nombrePropuesta, String tipoPropuestaCodigo, Boolean esPropManual){

		PropuestaPrecio propuestaPrecio = new PropuestaPrecio();
		
		propuestaPrecio.setNombrePropuesta(nombrePropuesta);

		// Las propuestas se generan con activos de una misma cartera
		// Para extraer la cartera de una propuesta, se toma de la cartera del 1er activo
		if(!Checks.esNulo(activos) && !Checks.esNulo(activos.get(0))){
			DDCartera cartera = (DDCartera) utilDiccionarioApi.dameValorDiccionarioByCod(DDCartera.class, activos.get(0).getCartera().getCodigo());
			propuestaPrecio.setCartera(cartera);
		}
		
		propuestaPrecio.setGestor(genericAdapter.getUsuarioLogado());
		propuestaPrecio.setFechaEmision(new Date());
		propuestaPrecio.setNumPropuesta(propuestaPrecioDao.getNextNumPropuestaPrecio());
		
		DDEstadoPropuestaPrecio estadoPropuestaPrecios = (DDEstadoPropuestaPrecio) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoPropuestaPrecio.class, DDEstadoPropuestaPrecio.ESTADO_GENERADA);
		propuestaPrecio.setEstado(estadoPropuestaPrecios);
		DDTipoPropuestaPrecio tipoPropuestaPrecio = (DDTipoPropuestaPrecio) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoPropuestaPrecio.class, tipoPropuestaCodigo);
		propuestaPrecio.setTipoPropuesta(tipoPropuestaPrecio);
		propuestaPrecio.setEsPropuestaManual(esPropManual);
		
		propuestaPrecio.setActivosPropuesta(listaActivosToActivosPropuesta(activos, propuestaPrecio));
		
		propuestaPrecioDao.saveOrUpdate(propuestaPrecio);
		
		return propuestaPrecio;
		
	}

	private List<ActivoPropuesta> listaActivosToActivosPropuesta(List<Activo> activos, PropuestaPrecio propuestaPrecio){
		List<ActivoPropuesta> listaActivosPropuesta = new ArrayList<ActivoPropuesta>();
		
		for(Activo activo : activos){
			ActivoPropuesta activoPropuesta = createActivoPropuesta(activo, propuestaPrecio);
			listaActivosPropuesta.add(activoPropuesta);
		}
		
		return listaActivosPropuesta;
	}
	
	private ActivoPropuesta createActivoPropuesta(Activo activo, PropuestaPrecio propuestaPrecio){
		ActivoPropuesta activoPropuesta = new ActivoPropuesta();
		ActivoPropuestaPk activoPropuestaPK = new ActivoPropuestaPk();

		activoPropuestaPK.setActivo(activo);
		activoPropuestaPK.setPropuestaPrecio(propuestaPrecio);
		activoPropuesta.setPrimaryKey(activoPropuestaPK);
		activoPropuesta.setEstado((DDEstadoPropuestaActivo) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoPropuestaActivo.class, DDEstadoPropuestaActivo.ESTADO_PENDIENTE));

		return activoPropuesta;
	}
	
	@Override
	public ExcelReport createExcelPropuestaPrecios(List<VBusquedaActivosPrecios> activosPrecios, String entidadPropietariaCodigo, String nombrePropuesta) {
		
		PropuestaPreciosExcelService propuestaPreciosService = propuestaPreciosExcelFactory.getService(entidadPropietariaCodigo);
		
		List<Map<String,String>> lista = propuestaPreciosService.getExcelData(activosPrecios);
		
		return new PropuestaPreciosExcelReport(lista, nombrePropuesta);			
		
	}
	
	@Override
	public List<VBusquedaActivosPropuesta> getActivosByIdPropuesta(Long idPropuesta) {
		
		return vActivosPropuestaDao.getListActivosByPropuestaPrecio(idPropuesta);
	}
	
	@Override
	public List<VBusquedaNumActivosTipoPrecio> getNumActivosByTipoPrecioAndCartera() {
		
		return vNumActivosTipoPrecioDao.getNumActivosByTipoPrecioAndCartera();
	}

}
