package es.pfsgroup.plugin.rem.api;

import org.springframework.ui.ModelMap;

import java.util.Map;

import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.rest.dto.ComunicacionBoardingResponse;

public interface BoardingComunicacionApi {
	
	public final static int TIMEOUT_1_MINUTO =60;
	
	public final static int TIMEOUT_30_SEGUNDOS =30;
	
	public ComunicacionBoardingResponse actualizarOfertaBoarding(Long numExpediente, Long numOferta, ModelMap model,int segundosTimeout);

	public boolean modoRestClientBoardingActivado();

	public boolean comunicacionBoardingActivada();

	public ComunicacionBoardingResponse enviarBloqueoCompradoresCFV(Oferta oferta, Map<String, Boolean> valores,int segundosTimeout);

	public boolean modoRestClientBloqueoCompradoresActivado();

}
