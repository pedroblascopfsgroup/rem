package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;

@Service("registroCambiosWSWebcom")
public class RegistroCambiosBD{
	
	@Autowired
	private CambiosBDDao dao;
	
	private final Log logger = LogFactory.getLog(getClass());
	

	public List<CambioBD> listPendientes() {
		return dao.listCambios();
	}

}
