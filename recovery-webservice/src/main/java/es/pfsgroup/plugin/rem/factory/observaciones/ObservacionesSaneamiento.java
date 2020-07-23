package es.pfsgroup.plugin.rem.factory.observaciones;

import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoObservacionActivo;

@Component
public class ObservacionesSaneamiento extends GridObservaciones implements GridObservacionesApi {

	@Override
	public String getCode() {
		return SANEAMIENTO;
	}

	@Override
	public String[] tiposObservacion() {
		return new String[] { DDTipoObservacionActivo.CODIGO_SANEAMIENTO };
	}

	@Override
	public List<DtoObservacion> getObservacionesById(Long id) {
		return getObservacionesListByIdAndCodes(id, tiposObservacion());
	}

	@Override
	@Transactional(readOnly = false)
	public boolean createObservacion(DtoObservacion observacion, Long idActivo) {
		try {
			if (Arrays.asList(tiposObservacion()).contains(observacion.getTipoObservacionCodigo())) {
				return createObservacionByDto(observacion, idActivo);
			} else {
				throw new Exception("No se puede crear ese tipo de observacion en este grid.");
			}
		} catch (Exception e) {
			logger.error(e);
			return false;
		}
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveObservacion(DtoObservacion observacion) {
		try {
			if (Arrays.asList(tiposObservacion()).contains(observacion.getTipoObservacionCodigo())) {
				return saveObservacionByDto(observacion);
			} else {
				throw new Exception("No se puede modificar ese tipo de observacion en este grid.");
			}
		} catch (Exception e) {
			logger.error(e);
			return false;
		}
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deleteObservacion(Long idObservacion) {
		try {
			if (Arrays.asList(tiposObservacion()).contains(getTipoObservacion(idObservacion))) {
				deleteObservacionById(idObservacion);
				return true;
			} else {
				throw new Exception("No se puede dar de baja ese tipo de observacion en este grid.");
			}
		} catch (Exception e) {
			logger.error(e);
			return false;
		}
	}
}
