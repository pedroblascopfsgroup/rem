package es.pfsgroup.plugin.rem.excel;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.DtoAgrupaciones;
import es.pfsgroup.plugin.rem.model.VActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

public class AgrupacionListadoActivosExcelReport extends AbstractExcelReport implements ExcelReport {

	private List<VActivosAgrupacion> listaActivosAgrupacion;
	
	private DtoAgrupaciones agrupacionDto;

	public AgrupacionListadoActivosExcelReport(List<VActivosAgrupacion> listaActivosAgrupacion) {
		this.listaActivosAgrupacion = listaActivosAgrupacion;
		this.agrupacionDto = null;
	}
	
	public AgrupacionListadoActivosExcelReport(List<VActivosAgrupacion> listaActivosAgrupacion,DtoAgrupaciones agruDto) {
		this.listaActivosAgrupacion = listaActivosAgrupacion;
		this.agrupacionDto = agruDto;
	}

	public List<String> getCabeceras() {

		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add("Nº activo HAYA");
		listaCabeceras.add("Fecha alta");
		listaCabeceras.add("Tipo");
		listaCabeceras.add("Subtipo");
		listaCabeceras.add("Dirección");
		listaCabeceras.add("Publicado");
		listaCabeceras.add("Disponibilidad comercial");
		listaCabeceras.add("Mínimo autorizado");
		listaCabeceras.add("Aprobado de venta (web)");
		listaCabeceras.add("Descuento publicado (web)");
		listaCabeceras.add("Superficie construida");
		
		if(!Checks.esNulo(agrupacionDto)) {
			if(DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA.equals(agrupacionDto.getTipoAgrupacionCodigo()) 
					|| DDTipoAgrupacion.AGRUPACION_ASISTIDA.equals(agrupacionDto.getTipoAgrupacionCodigo()) ) {
				
				listaCabeceras.add("Subdivisión");
				listaCabeceras.add("Finca registral");
			}
			
		}
		
		return listaCabeceras;
	}

	public List<List<String>> getData() {

		List<List<String>> valores = new ArrayList<List<String>>();
		
		

		for(VActivosAgrupacion activoAgrupacion: listaActivosAgrupacion){
			List<String> fila = new ArrayList<String>();

			fila.add(activoAgrupacion.getNumActivo().toString());
			fila.add(this.getDateStringValue(activoAgrupacion.getFechaInclusion()));
			fila.add(activoAgrupacion.getTipoActivoDescripcion());
			fila.add(this.getDictionaryValue(activoAgrupacion.getSubtipoActivo()));
			fila.add(activoAgrupacion.getDireccion());
			fila.add(activoAgrupacion.getPublicado());
			fila.add(activoAgrupacion.getSituacionComercial());
			if(activoAgrupacion.getImporteMinimoAutorizado() != null) {
				fila.add(activoAgrupacion.getImporteMinimoAutorizado().toString());
			} else {
				fila.add(null);
			}
			if(activoAgrupacion.getImporteAprobadoVenta() != null) {
				fila.add(activoAgrupacion.getImporteAprobadoVenta().toString());
			} else {
				fila.add(null);
			}
			if(activoAgrupacion.getImporteDescuentoPublicado() != null) {
				fila.add(activoAgrupacion.getImporteDescuentoPublicado().toString());
			} else {
				fila.add(null);
			}
			if(activoAgrupacion.getSuperficieConstruida() != null) {
				fila.add(activoAgrupacion.getSuperficieConstruida().toString());
			} else {
				fila.add(null);
			}
			if(!Checks.esNulo(agrupacionDto)) {
				
				if(DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA.equals(agrupacionDto.getTipoAgrupacionCodigo())
						|| DDTipoAgrupacion.AGRUPACION_ASISTIDA.equals(agrupacionDto.getTipoAgrupacionCodigo()) ) {
					
					if(!Checks.esNulo(activoAgrupacion.getSubdivision())) {
						fila.add(activoAgrupacion.getSubdivision());
					}else {
						fila.add(null);
					}
					
					if(!Checks.esNulo(activoAgrupacion.getNumFinca())) {
						fila.add(activoAgrupacion.getNumFinca());
					}else {
						fila.add(null);
					}
					
				}else {
					fila.add(null);
					fila.add(null);
				}
			}
			
			valores.add(fila);
		}

		return valores;
	}

	public String getReportName() {
		return LISTA_DE_ACTIVOS_AGRUPACION_XLS;
	}
}