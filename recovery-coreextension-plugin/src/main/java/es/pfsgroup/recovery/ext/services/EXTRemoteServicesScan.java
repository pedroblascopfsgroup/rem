package es.pfsgroup.recovery.ext.services;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;

@Service
public class EXTRemoteServicesScan {

	@Autowired
	private EXTTareasService tareasService;

	public EXTTareasService getTareasService() {
		return tareasService;
	}

	public void setTareasService(EXTTareasService tareasService) {
		this.tareasService = tareasService;
	}

}
