package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.plugin.rem.model.DtoMantenimientoFilter;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoTrabajos;

public class MantenimientoExcelReport extends AbstractExcelReport implements ExcelReport{
	
	private List<DtoMantenimientoFilter> listDtoMantenimiento;
	

	public MantenimientoExcelReport(List<DtoMantenimientoFilter> listDtoMantenimiento) {
		
		this.listDtoMantenimiento = listDtoMantenimiento;
	}

	@Override
	public List<String> getCabeceras() {
		List<String> listaCabeceras = new ArrayList<String>();
		//listaCabeceras.add("Id");
		listaCabeceras.add("Cartera");
		listaCabeceras.add("Subcartera");
		listaCabeceras.add("Nombre Propietario");
		listaCabeceras.add("Cartera Macc");
		listaCabeceras.add("Fecha alta");
		listaCabeceras.add("Usuario Alta");	
				
		return listaCabeceras;
	}

	@Override
	public List<List<String>> getData() {
		
		List<List<String>> valores = new ArrayList<List<String>>();
		List<String> fila;
		for (DtoMantenimientoFilter listaDto: listDtoMantenimiento) {
			fila = new ArrayList<String>();
			/*if (listaDto.getId() != null) {
				fila.add(listaDto.getId().toString());
			}else {
				fila.add("");
			}*/
			if (listaDto.getCodCartera() != null) {
				fila.add(listaDto.getCodCartera());
			}else {
				fila.add("");
			}
			if (listaDto.getCodSubCartera() != null) {
				fila.add(listaDto.getCodSubCartera());
			}else {
				fila.add("");
			}
			if (listaDto.getNombrePropietario() != null) {
				fila.add(listaDto.getNombrePropietario());
			}else {
				fila.add("");
			}
			if (listaDto.getCarteraMacc() != null) {
				fila.add(listaDto.getCarteraMacc());
			}else {
				fila.add("");
			}
			if (listaDto.getFechaCrear() != null) {
				fila.add(df.format(listaDto.getFechaCrear()));
			}else {
				fila.add("");
			}
			if (listaDto.getUsuarioCrear() != null) {
				fila.add(listaDto.getUsuarioCrear());
			}else {
				fila.add("");
			}
			
			valores.add(fila);	
		}
		
		return valores;
		
	}

	@Override
	public String getReportName() {
		return LISTA_MANTENIMIENTO_CONFIGURACION_XLS;
	}

}
