package es.pfsgroup.recovery.geninformes;

import org.springframework.stereotype.Component;

import es.pfsgroup.recovery.geninformes.api.GENINFInformeEntidad;
import es.pfsgroup.recovery.geninformes.api.GENINFInformeEntidadGenerator;

@Component
public class GENInformeEntidadGeneratorImpl implements GENINFInformeEntidadGenerator{

	@Override
	public int getPrioridad() {
		return 0;
	}

	@Override
	public GENINFInformeEntidad getInformeEntidad(String tipoEntidad) {

		return new GENINFInformeEntidadImpl();
	}

}
