package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.InformeMediadorDto;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambiosBDDao;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;
import net.sf.json.JSONObject;

@Component
public class DetectorWebcomEstadoInformeMediador extends DetectorCambiosBD<InformeMediadorDto> {

	private static String TABLA_MODIFICADOS = "ACT_IMO_INFO_MOD";
	private Boolean procesarSoloCambiosMarcados = null;
	private Boolean forzarSoloCambiosMarcados = null;

	@Autowired
	private ServiciosWebcomManager serviciosWebcom;
	
	@Resource
	private Properties appProperties;

	@Override
	public String nombreVistaDatosActuales() {
		return "REM01.VI_INFORME_WEBCOM";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "REM01.IWH_INFORME_WEBCOM_HIST";
	}

	@Override
	public String clavePrimaria() {
		return "ID_INFORME_COMERCIAL";
	}

	@Autowired
	private CambiosBDDao dao;

	@Override
	protected InformeMediadorDto createDtoInstance() {
		return new InformeMediadorDto();
	}

	@Override
	public JSONObject invocaServicio(List<InformeMediadorDto> data, RestLlamada registro) throws ErrorServicioWebcom {
		return this.serviciosWebcom.webcomRestEstadoInformeMediador(data, registro);

	}

	@Override
	protected Integer getWeight() {
		return 9990;
	}

	@Override
	public boolean isActivo() {
		return true;
	}

	@Override
	public String clavePrimariaJson() {
		return "ID_INFORME_MEDIADOR_REM";
	}

	@Override
	public List<String> vistasAuxiliares() {
		return null;
	}

	@Override
	public Boolean procesarSoloCambiosMarcados() {
		if (forzarSoloCambiosMarcados != null) {
			return forzarSoloCambiosMarcados;
		} else {
			if (procesarSoloCambiosMarcados == null) {
				procesarSoloCambiosMarcados = !Checks.esNulo(appProperties.getProperty("rest.client.webcom.optimizado"))
						? Boolean.valueOf(appProperties.getProperty("rest.client.webcom.optimizado")) : false;
			}
			return procesarSoloCambiosMarcados;
		}
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
