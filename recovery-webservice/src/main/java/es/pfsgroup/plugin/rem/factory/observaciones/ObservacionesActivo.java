package es.pfsgroup.plugin.rem.factory.observaciones;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.model.ActivoObservacion;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoObservacionActivo;

@Component
public class ObservacionesActivo extends GridObservaciones implements GridObservacionesApi {
	
	@Override
	public String getCode() {
		return ACTIVO;
	}
	
	@Override
	public String[] tiposObservacion() {
		return new String[] {
				DDTipoObservacionActivo.CODIGO_STOCK,
				DDTipoObservacionActivo.CODIGO_POSESION,
				DDTipoObservacionActivo.CODIGO_INSCRIPCION,
				DDTipoObservacionActivo.CODIGO_CARGAS,
				DDTipoObservacionActivo.CODIGO_LLAVES
			};
	}
	// Se anyaden dos tipos mas dado que para listar las 
	// observaciones si que se muestran aunque no se puede hacer nada con estos tipos desde este grid.
	private String[] tiposValidosObservacionListado() {
		return new String[] {
				DDTipoObservacionActivo.CODIGO_STOCK,
				DDTipoObservacionActivo.CODIGO_POSESION,
				DDTipoObservacionActivo.CODIGO_INSCRIPCION,
				DDTipoObservacionActivo.CODIGO_CARGAS,
				DDTipoObservacionActivo.CODIGO_LLAVES,
				DDTipoObservacionActivo.CODIGO_SANEAMIENTO,
				DDTipoObservacionActivo.CODIGO_REVISION_TITULO
			};
	}
	
	@Override
	public List<DtoObservacion> getObservacionesById(Long id) {
		try {
			return getObservacionesListByIdAndCodes(id, tiposValidosObservacionListado());
		}catch( Exception e) {
			logger.error(e);
			return new ArrayList<DtoObservacion>();
		}
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
		}catch(Exception e) {
			logger.error(e);
			return false;
		}
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveObservacion(DtoObservacion observacion) {
		try {
			String codigo =  observacion.getTipoObservacionCodigo();
			if ( codigo == null ) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(observacion.getId()));
				ActivoObservacion tipoObservacion = genericDao.get(ActivoObservacion.class, filtro);
				if ( tipoObservacion != null && tipoObservacion.getTipoObservacion() != null ) {
					codigo = tipoObservacion.getTipoObservacion().getCodigo();
				}
			}
			
			if (Arrays.asList(tiposObservacion()).contains(codigo)) {
				return saveObservacionByDto(observacion);
			} else {
				throw new Exception("No se puede modificar ese tipo de observacion en este grid.");
			}
		}catch(Exception e) {
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
