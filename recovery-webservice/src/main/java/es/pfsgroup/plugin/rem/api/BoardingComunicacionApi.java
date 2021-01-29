package es.pfsgroup.plugin.rem.api;

import org.springframework.ui.ModelMap;

public interface BoardingComunicacionApi {
	
	public void datosCliente(Long numExpediente, Long numOferta, ModelMap model);

}
