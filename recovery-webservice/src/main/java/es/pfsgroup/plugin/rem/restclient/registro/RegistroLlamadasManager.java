package es.pfsgroup.plugin.rem.restclient.registro;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.WordUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.logTrust.LogTrustWebService;
import es.pfsgroup.plugin.rem.restclient.registro.dao.RestDatoRechazadoDao;
import es.pfsgroup.plugin.rem.restclient.registro.dao.RestLlamadaDao;
import es.pfsgroup.plugin.rem.restclient.registro.model.DatosRechazados;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.DeteccionCambiosBDTask;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import net.sf.json.JSONObject;

@Service
public class RegistroLlamadasManager {
	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private RestLlamadaDao llamadaDao;

	@Autowired
	private RestDatoRechazadoDao datosRechazadosDao;

	@Resource
	private Properties appProperties;

	@Autowired
	private LogTrustWebService trustMe;

	@Transactional(readOnly = false, noRollbackFor = ErrorServicioWebcom.class, propagation = Propagation.NEVER)
	public void guardaRegistroLlamada(RestLlamada llamada, @SuppressWarnings("rawtypes") DetectorCambiosBD handler,Integer contError) {
		logger.trace("Guardando traza de la llamada en BD");
		
		Integer MAXIMO_INTENTOS = DeteccionCambiosBDTask.MAXIMO_INTENTOS_DEFAULT;
		String maximoIntentosProperties = !Checks.esNulo(appProperties.getProperty("rest.client.webcom.maximo.intentos"))
						? appProperties.getProperty("rest.client.webcom.maximo.intentos") : null;
		try {
			if (maximoIntentosProperties != null) {
				MAXIMO_INTENTOS = Integer.parseInt(maximoIntentosProperties);
			}

		} catch (Exception e) {
			MAXIMO_INTENTOS = DeteccionCambiosBDTask.MAXIMO_INTENTOS_DEFAULT;
		}

		llamadaDao.guardaRegistro(llamada);
		trustMe.registrarLlamadaServicioWeb(llamada);

		// trazamos registros erroneos
		String jsonStyleName = this.obtenerJsonStyleName(handler.clavePrimariaJson());
		if (llamada.getDatosErroneos() != null && llamada.getDatosErroneos().size() > 0 && jsonStyleName != null && !jsonStyleName.isEmpty()) {
			for (JSONObject jsonObject : llamada.getDatosErroneos()) {
				boolean isHttp= false;
				try {
					if (jsonObject.containsKey(jsonStyleName) && handler.nombreVistaDatosActuales() != null) {
						String id = jsonObject.getString(jsonStyleName);

						if (id != null && StringUtils.isNumeric(id)) {
							DatosRechazados datoRechazado = new DatosRechazados();
							datoRechazado.setVista(handler.nombreVistaDatosActuales());
							datoRechazado.setIdObjeto(Long.valueOf(id));

							if (jsonObject.containsKey("invalidFields")) {
								String invalidFields = jsonObject.getJSONObject("invalidFields").toString();
								if(invalidFields.length() > 99){
									invalidFields = invalidFields.substring(0,99);
								}
								datoRechazado.setDatosInvalidos(invalidFields);

							}else{
								datoRechazado.setDatosInvalidos("error http");
								isHttp= true;
							}

							datoRechazado.setIteracion(llamada.getIteracion());
							
							if(!isHttp || contError == MAXIMO_INTENTOS){
								datosRechazadosDao.guardaRegistro(datoRechazado);
							}
						}
					}
				} catch (Exception e) {
					logger.error("error al guardar traza sobre objeto rechazado: ".concat(e.getMessage()));
					logger.error("Objeto rechazado: ".concat(jsonObject.toString()));
				}
			}
		}
	}

	private String obtenerJsonStyleName(String ddbbStringName) {
		String jsonStyleName = "";
		try {
			String[] parts = ddbbStringName.split("_");

			boolean first = true;
			for (String part : parts) {
				part = part.toLowerCase().toLowerCase();
				if (first) {
					first = false;
				} else {
					part = WordUtils.capitalize(part);
				}
				jsonStyleName = jsonStyleName.concat(part);
			}
		} catch (Exception e) {
			logger.error(e);
		}

		return jsonStyleName;
	}

	@Transactional(readOnly = false, noRollbackFor = ErrorServicioWebcom.class, propagation = Propagation.NEVER)
	public void guardaRegistroLlamada(List<RestLlamada> llamadas) {
		logger.trace("Guardando traza de la llamada en BD");

		for (RestLlamada llamada : llamadas) {
			llamadaDao.guardaRegistro(llamada);
			trustMe.registrarLlamadaServicioWeb(llamada);
		}

	}

}
