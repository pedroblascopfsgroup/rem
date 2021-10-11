package es.pfsgroup.plugin.rem.api;

import org.springframework.ui.ModelMap;

import es.pfsgroup.plugin.rem.rest.dto.ComunicacionBoardingResponse;

public interface BoardingComunicacionApi {
	
	public final static int TIMEOUT_2_MINUTOS =120;
	
	public final static int TIMEOUT_1_MINUTO =60;
	
	public final static int TIMEOUT_30_SEGUNDOS =30;
	
	public ComunicacionBoardingResponse actualizarOfertaBoarding(Long numExpediente, Long numOferta, ModelMap model,int segundosTimeout);

	public boolean modoRestClientBoardingActivado();

	public boolean comunicacionBoardingActivada();

}
