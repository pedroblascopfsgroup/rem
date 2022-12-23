package es.pfsgroup.plugin.rem.tramite.alquiler.no.comercial;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.model.ActivoTramite;

@Component
public class TramiteAlquilerNoComercialSubrogacionDacion extends TramiteAlquilerNoComercialAbstract implements TramiteAlquilerNoComercial {

	private final Log logger = LogFactory.getLog(TramiteAlquilerNoComercialSubrogacionDacion.class);
	
	@Override
	public boolean cumpleCondiciones(ActivoTramite tramite){	
		return false;
	}
	
	@Override
	public boolean permiteClaseCondicion() {
		return true;
	}

}
