package es.pfsgroup.plugin.rem.api.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.PreciosApi;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.PropuestaPreciosExcelReport;
import es.pfsgroup.plugin.rem.factory.PropuestaPreciosExcelFactoryApi;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPrecios;
import es.pfsgroup.plugin.rem.propuestaprecios.dao.PropuestaPrecioDao;
import es.pfsgroup.plugin.rem.service.PropuestaPreciosExcelService;

@Service("preciosManager")
public class PreciosManager extends BusinessOperationOverrider<PreciosApi> implements  PreciosApi {
	
	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private PropuestaPrecioDao propuestaPrecioDao;
	
	@Autowired
	private PropuestaPreciosExcelFactoryApi propuestaPreciosExcelFactory;
	
	
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
	public ExcelReport createPropuestaPrecios(DtoActivoFilter dto, String nombre) {
		
		@SuppressWarnings("unchecked")
		List<VBusquedaActivosPrecios> listaActivos = (List<VBusquedaActivosPrecios>) getActivos(dto).getResults();
		
		PropuestaPreciosExcelService propuestaPreciosService = propuestaPreciosExcelFactory.getService(dto.getEntidadPropietariaCodigo());
		
		List<Map<String,String>> lista = propuestaPreciosService.getExcelData(listaActivos);
		
		// TODO  Guardar propuesta. Crear trabajo/trámite.
		
		return new PropuestaPreciosExcelReport(lista, nombre);			
		
	}	

}
