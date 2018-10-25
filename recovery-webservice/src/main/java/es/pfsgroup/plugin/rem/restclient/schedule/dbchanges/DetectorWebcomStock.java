package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambiosBDDao;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

@Component
public class DetectorWebcomStock extends DetectorCambiosBD<StockDto> {

	private static String TABLA_MODIFICADOS = "ACT_AMO_ACTIVOS_MOD";

	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Autowired
	private CambiosBDDao dao;
	
	@Resource
	private Properties appProperties;
	
	private Boolean procesarSoloCambiosMarcados = null;
	
	private Boolean forzarSoloCambiosMarcados = null;

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
		//vistasAuxiliares.add("REM01.VI_STOCK_PIVOT_AGRUP_ACTIVO");
		//vistasAuxiliares.add("REM01.VI_STOCK_ACTIVOS_SUBDIVISON");
		vistasAuxiliares.add("REM01.VI_STOCK_PIVOT_PRECIOS");
		vistasAuxiliares.add("REM01.VI_STOCK_PIVOT_PRECIOS_ANT");
		vistasAuxiliares.add("REM01.VI_STOCK_ACTIVO_CONDICIONANTE");
		vistasAuxiliares.add("REM01.VI_STOCK_ACTIVO_REFCATASTRAL");
		vistasAuxiliares.add("REM01.VI_STOCK_ACTIVO_FECHAPUBLICA");
		vistasAuxiliares.add("REM01.VI_STOCK_ACTIVO_PROV_ANT");
		vistasAuxiliares.add("REM01.VI_STOCK_ACTIVO_GCOM");
		return vistasAuxiliares;
	}

	@Override
	public Boolean procesarSoloCambiosMarcados() {
		if(forzarSoloCambiosMarcados != null){
			return forzarSoloCambiosMarcados;
		}else{
			if(procesarSoloCambiosMarcados==null){
				procesarSoloCambiosMarcados = !Checks.esNulo(appProperties.getProperty("rest.client.webcom.optimizado"))
						? Boolean.valueOf(appProperties.getProperty("rest.client.webcom.optimizado")) : false;
			}
			return procesarSoloCambiosMarcados;
		}
		
	}
	
	/**
	 * Fuerza la ejecución del modo optimizado
	 */
	public void setSoloCambiosMarcados(Boolean procesar){
		this.forzarSoloCambiosMarcados = procesar;
	}

	@Override
	public void marcarComoEnviadosMarcadosEspecifico(Date fechaEjecucion) throws Exception {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		String fechaEjecucionString = df.format(fechaEjecucion);

		String querydelete = "DELETE FROM " + TABLA_MODIFICADOS + CambiosBDDao.WHERE + "FECHAMODIFICAR < TO_DATE('"
				+ fechaEjecucionString + "','YYYY-MM-DD HH24:MI:SS')";

		dao.excuteQuery(querydelete);

	}
	

}
