package es.pfsgroup.plugin.rem.excel;

import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcel;

public class ExcelActivosPropuestaPrecios {

	private HojaExcel hoja = new HojaExcel();
	
	public void cargarPlantilla(String ruta) {
		hoja.setRuta(ruta);
	}
}
