package es.pfsgroup.plugin.rem.restclient.registro;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.logTrust.LogTrustWebService;
import es.pfsgroup.plugin.rem.restclient.registro.dao.RestLlamadaDao;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;

@Service
public class RegistroLlamadasManager {
	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private RestLlamadaDao llamadaDao;

	@Resource
	private Properties appProperties;

	@Autowired
	private LogTrustWebService trustMe;

	@Transactional(readOnly = false, noRollbackFor = ErrorServicioWebcom.class, propagation = Propagation.NEVER)
	public void guardaRegistroLlamada(RestLlamada llamada, @SuppressWarnings("rawtypes") DetectorCambiosBD handler) {
		try{
			llamadaDao.guardaRegistro(llamada);
		}catch(Exception e){
			logger.error("error al guardar traza sobre objeto rechazado: ".concat(e.getMessage()));
		}
		
		trustMe.registrarLlamadaServicioWeb(llamada);	
	}

	
	@Transactional(readOnly = false, noRollbackFor = ErrorServicioWebcom.class, propagation = Propagation.NEVER)
	public void guardaRegistroLlamada(List<RestLlamada> llamadas) {
		logger.trace("Guardando traza de la llamada en BD");

		for (RestLlamada llamada : llamadas) {
			try{
				llamadaDao.guardaRegistro(llamada);
			}catch(Exception e){
				logger.error("error al guardar traza sobre objeto rechazado: ".concat(e.getMessage()));
			}
			trustMe.registrarLlamadaServicioWeb(llamada);
		}

	}

}
