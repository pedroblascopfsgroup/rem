package es.pfsgroup.plugin.rem.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.excel.PropuestaPreciosExcelReport;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPrecios;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;

@Component
public class PropuestaPreciosExcelEntidad02 implements PropuestaPreciosExcelService {
    


	@Override
	public String[] getKeys() {
		return this.getCodigoCartera();
	}

	@Override
	public String[] getCodigoCartera() {
		return new String[]{DDCartera.CODIGO_CARTERA_02};
	}

	@Override
	public List<Map<String,String>> getExcelData(List<VBusquedaActivosPrecios> lista) {
		
		List<Map<String,String>> datos = new ArrayList<Map<String,String>>();
		
		for (VBusquedaActivosPrecios activo : lista) {
			
			Map<String,String> rowMap = new HashMap<String, String>();
			
			rowMap.put(PropuestaPreciosExcelReport.CAB_CARTERA, activo.getEntidadPropietariaDescripcion());
			rowMap.put(PropuestaPreciosExcelReport.CAB_NUM_ACTIVO, activo.getNumActivo());
			rowMap.put(PropuestaPreciosExcelReport.CAB_TIPO, activo.getTipoActivoDescripcion());
			rowMap.put(PropuestaPreciosExcelReport.CAB_SUBTIPO, activo.getSubtipoActivoDescripcion());
			rowMap.put(PropuestaPreciosExcelReport.CAB_ORIGEN, activo.getTipoTituloActivoDescripcion());
			rowMap.put(PropuestaPreciosExcelReport.CAB_DIRECCION, activo.getDireccion());
			rowMap.put(PropuestaPreciosExcelReport.CAB_MUNICIPIO, activo.getMunicipio());
			rowMap.put(PropuestaPreciosExcelReport.CAB_CP, activo.getCodigoPostal());
			rowMap.put(PropuestaPreciosExcelReport.CAB_PROVINCIA, activo.getProvincia());		
			
			datos.add(rowMap);
		}
		
	
		return datos;

	}

}
