package es.pfsgroup.plugin.rem.api;

import org.springframework.ui.ModelMap;

public interface BoardingComunicacionApi {
	
	public String actualizarOfertaBoarding(Long numExpediente, Long numOferta, ModelMap model);

	public boolean modoRestClientBoardingActivado();

	public boolean comunicacionBoardingActivada();

}
