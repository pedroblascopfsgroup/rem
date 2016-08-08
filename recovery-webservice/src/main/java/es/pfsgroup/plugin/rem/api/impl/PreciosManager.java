package es.pfsgroup.plugin.rem.api.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

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
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.PropuestaPreciosExcelReport;
import es.pfsgroup.plugin.rem.factory.PropuestaPreciosExcelFactoryApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoPropuesta;
import es.pfsgroup.plugin.rem.model.ActivoPropuesta.ActivoPropuestaPk;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.DtoPropuestaPrecioFilter;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPrecios;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPropuestaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPropuestaPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.propuestaprecios.dao.PropuestaPrecioDao;
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
	private PropuestaPreciosExcelFactoryApi propuestaPreciosExcelFactory;
	
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
	public Page getPropuestasPrecios(DtoPropuestaPrecioFilter dtoPropuestaFiltro) {
		
		return propuestaPrecioDao.getListPropuestasPreciosBySearch(dtoPropuestaFiltro);
	}
	
	@Override
	@Transactional(readOnly = false)
	public PropuestaPrecio createPropuestaPreciosManual(List<VBusquedaActivosPrecios> activosPrecios, String nombrePropuesta){

		// Nueva propuesta de precios
		PropuestaPrecio propuestaPrecio = createPropuestaPrecios(activosPrecios, nombrePropuesta);
		
		return propuestaPrecio;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public PropuestaPrecio createPropuestaPrecios(List<VBusquedaActivosPrecios> activosPrecios, String nombrePropuesta){

		PropuestaPrecio propuestaPrecio = new PropuestaPrecio();
		
		propuestaPrecio.setNombrePropuesta(nombrePropuesta);

		if(!Checks.esNulo(activosPrecios) && !Checks.esNulo(activosPrecios.get(0))){
//			Filter filtroCarteraCodigo = genericDao.createFilter(FilterType.EQUALS, "codigo", activosPrecios.get(0).getEntidadPropietariaCodigo());
//			DDCartera cartera = (DDCartera) genericDao.get(DDCartera.class, filtroCarteraCodigo);
			DDCartera cartera = (DDCartera) utilDiccionarioApi.dameValorDiccionarioByCod(DDCartera.class, activosPrecios.get(0).getEntidadPropietariaCodigo());
			propuestaPrecio.setCartera(cartera);
		}
		
		propuestaPrecio.setGestor(genericAdapter.getUsuarioLogado());
		propuestaPrecio.setFechaEmision(new Date());
		propuestaPrecio.setNumPropuesta(propuestaPrecioDao.getNextNumPropuestaPrecio());
		
//		Filter filtroPropuestaPrecios = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPropuestaPrecio.ESTADO_GENERADA);
//		DDEstadoPropuestaPrecio estadoPropuestaPrecios = (DDEstadoPropuestaPrecio) genericDao.get(DDEstadoPropuestaPrecio.class, filtroPropuestaPrecios);
		DDEstadoPropuestaPrecio estadoPropuestaPrecios = (DDEstadoPropuestaPrecio) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoPropuestaPrecio.class, DDEstadoPropuestaPrecio.ESTADO_GENERADA);
		propuestaPrecio.setEstado(estadoPropuestaPrecios);
		
		propuestaPrecio.setActivosPropuesta(listaActivosPreciosToActivosPropuesta(activosPrecios, propuestaPrecio));
		
//		genericDao.update(PropuestaPrecio.class, propuestaPrecio);

		propuestaPrecioDao.saveOrUpdate(propuestaPrecio);
		
		return propuestaPrecio;
		
	}

	@Transactional(readOnly = false)
	private List<ActivoPropuesta> listaActivosPreciosToActivosPropuesta(List<VBusquedaActivosPrecios> activosPrecios, PropuestaPrecio propuestaPrecio){
		List<ActivoPropuesta> listaActivosPropuesta = new ArrayList<ActivoPropuesta>();
		
		for(VBusquedaActivosPrecios activoPrecio : activosPrecios){
			
			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "numActivo", Long.parseLong(activoPrecio.getNumActivo()));
			Activo activo = (Activo) genericDao.get(Activo.class, filtroActivo);
			ActivoPropuesta activoPropuesta = createActivoPropuesta(activo, propuestaPrecio);
			
			listaActivosPropuesta.add(activoPropuesta);
			
		}
		
		return listaActivosPropuesta;
	}
	
	@Transactional(readOnly = false)
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

}
