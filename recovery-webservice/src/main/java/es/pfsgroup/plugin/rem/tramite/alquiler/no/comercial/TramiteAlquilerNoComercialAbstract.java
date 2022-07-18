package es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;

@Component
public abstract class TramiteAlquilerNoComercialAbstract implements TramiteAlquilerNoComercial {

	private final Log logger = LogFactory.getLog(TramiteAlquilerNoComercialAbstract.class);
	
}
