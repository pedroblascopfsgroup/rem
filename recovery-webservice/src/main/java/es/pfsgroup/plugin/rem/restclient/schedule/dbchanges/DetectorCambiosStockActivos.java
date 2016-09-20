package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

@Component
public class DetectorCambiosStockActivos extends DetectorCambiosBD<StockDto> {
	
	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Override
	public StockDto createDtoInstance() {
		return new StockDto();
	}

	@Override
	public void invocaServicio(List<StockDto> data) {
		serviciosWebcom.enviarStock(data);
		
	}

	@Override
	public String nombreVistaDatosActuales() {
		return "REM01.REM_WEBCOM_STOCK_ACTUAL";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "REM01.REM_WEBCOM_STOCK_HISTORICO";
	}

	@Override
	public String clavePrimaria() {
		return "ID_ACTIVO_HAYA";
	}

}
