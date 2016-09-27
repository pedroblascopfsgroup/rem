package es.pfsgroup.plugin.rem.restclient.registro;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.plugin.rem.restclient.registro.dao.RestLlamadaDao;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;

@Service
public class RegistroLlamadasManager {
	
	@Autowired
	private RestLlamadaDao llamadaDao;
	
	@Transactional(readOnly = false)
	public void guardaRegistroLlamada(RestLlamada llamada){
		llamadaDao.saveOrUpdate(llamada);
	}

}
