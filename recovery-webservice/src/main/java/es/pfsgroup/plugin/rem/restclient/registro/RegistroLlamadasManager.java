package es.pfsgroup.plugin.rem.restclient.registro;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.restclient.registro.dao.RestLlamadaDao;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;

@Service
public class RegistroLlamadasManager {
	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private RestLlamadaDao llamadaDao;
	
	
	
	@Transactional(readOnly = false, noRollbackFor=ErrorServicioWebcom.class,propagation=Propagation.NEVER)
	public void guardaRegistroLlamada(RestLlamada llamada){
		logger.debug("Guardando traza de la llamada en BD");
		
		
		llamadaDao.guardaRegistro(llamada);
		
		
	}
	@Transactional(readOnly = false, noRollbackFor=ErrorServicioWebcom.class,propagation=Propagation.NEVER)
	public void guardaRegistroLlamada(List<RestLlamada> llamadas){
		logger.debug("Guardando traza de la llamada en BD");
		
		for(RestLlamada llamada: llamadas){
			llamadaDao.guardaRegistro(llamada);
		}
		
	}

}
