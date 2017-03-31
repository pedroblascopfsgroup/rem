package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

@Component
public class DetectorWebcomStock extends DetectorCambiosBD<StockDto> {
	
	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Override
	public StockDto createDtoInstance() {
		return new StockDto();
	}

	@Override
	public void invocaServicio(List<StockDto> data, RestLlamada registro) throws ErrorServicioWebcom {
		serviciosWebcom.webcomRestStock(data, registro);
		
	}

	@Override
	public String nombreVistaDatosActuales() {
		return "REM01.VI_STOCK_ACTIVOS_WEBCOM";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "REM01.SWH_STOCK_ACT_WEBCOM_HIST";
	}

	@Override
	public String clavePrimaria() {
		return "ID_ACTIVO_HAYA";
	}

	@Override
	protected Integer getWeight() {
		return 9995;
	}
	
	@Override
	public boolean isActivo() {
		return true;
	}

	@Override
	public String clavePrimariaJson() {
		return "ID_ACTIVO_HAYA";
	}

	@Override
	public List<String> vistasAuxiliares() {
		ArrayList<String> vistasAuxiliares = new ArrayList<String>();
		vistasAuxiliares.add("REM01.VI_STOCK_PIVOT_AGRUP_ACTIVO");
		vistasAuxiliares.add("REM01.VI_STOCK_ACTIVOS_SUBDIVISON");
		vistasAuxiliares.add("REM01.VI_STOCK_PIVOT_PRECIOS");
		vistasAuxiliares.add("REM01.VI_STOCK_PIVOT_PRECIOS_ANT");
		vistasAuxiliares.add("REM01.VI_STOCK_ACTIVO_CONDICIONANTE");
		vistasAuxiliares.add("REM01.VI_STOCK_ACTIVO_REFCATASTRAL");
		vistasAuxiliares.add("REM01.VI_STOCK_ACTIVO_FECHAPUBLICA");
		vistasAuxiliares.add("REM01.VI_STOCK_ACTIVO_PROV_ANT");
		vistasAuxiliares.add("REM01.VI_STOCK_ACTIVO_GCOM");
		return vistasAuxiliares;
	}

}
