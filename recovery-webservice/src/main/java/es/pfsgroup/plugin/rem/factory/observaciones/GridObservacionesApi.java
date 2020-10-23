package es.pfsgroup.plugin.rem.factory.observaciones;

import java.util.List;

import es.pfsgroup.plugin.rem.model.DtoObservacion;

public interface GridObservacionesApi {
	String getCode();

	String[] tiposObservacion();

	List<DtoObservacion> getObservacionesById(Long id);

	boolean createObservacion(DtoObservacion observacion, Long idActivo);

	boolean saveObservacion(DtoObservacion observacion);

	boolean deleteObservacion(Long idObservacion);
}
