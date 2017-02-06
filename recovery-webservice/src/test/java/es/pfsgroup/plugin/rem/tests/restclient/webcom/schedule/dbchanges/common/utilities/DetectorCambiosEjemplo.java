package es.pfsgroup.plugin.rem.tests.restclient.webcom.schedule.dbchanges.common.utilities;

import java.util.List;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.tests.restclient.webcom.examples.ExampleDto;

/**
 * Implementación de detector de cambios para testing.
 * @author bruno
 *
 */
public class DetectorCambiosEjemplo extends DetectorCambiosBD<ExampleDto>{

	@Override
	public String nombreVistaDatosActuales() {
		return null;
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return null;
	}

	@Override
	public String clavePrimaria() {
		return null;
	}

	@Override
	protected ExampleDto createDtoInstance() {
		return new ExampleDto();
	}

	@Override
	public void invocaServicio(List<ExampleDto> data, RestLlamada registro) throws ErrorServicioWebcom {
	}

	@Override
	public String clavePrimariaJson() {
		return null;
	}

	@Override
	protected Integer getWeight() {
		return null;
	}

	@Override
	public boolean isActivo() {
		return false;
	}

}
