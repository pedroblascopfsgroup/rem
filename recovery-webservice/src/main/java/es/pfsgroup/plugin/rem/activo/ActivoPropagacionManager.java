package es.pfsgroup.plugin.rem.activo;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoPropagacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.rest.dto.ActivoPropagacionDto;

@Service
public class ActivoPropagacionManager implements ActivoPropagacionApi {

	private final Log logger = LogFactory.getLog(this.getClass());
	private final BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Autowired
	private ActivoDao activoDao;

	public List<ActivoPropagacionDto> getAllActivosAgrupacionPorActivo(final Long idActivo) {

		Activo activo = activoDao.get(idActivo);

		if (activo == null) {
			return new ArrayList<ActivoPropagacionDto>();
		}

		// Collect activos por subdivision
		List<Activo> activosPorSubdivision = new ArrayList<Activo>();
		if (activo.getSubdivision() != null && activo.getSubdivision().getActivos() != null && !activo.getSubdivision().getActivos().isEmpty()) {
			activosPorSubdivision.addAll(activo.getSubdivision().getActivos());
		}

		// Collect activos por agrupacion 
		List<Activo> activosPorAgrupacion = new ArrayList<Activo>();
		activosPorAgrupacion.addAll(getActivosPorAgrupacion(activo));

		// Return data
		List<ActivoPropagacionDto> out = new ArrayList<ActivoPropagacionDto>();

		out.addAll(ensamblarDto(activosPorAgrupacion, "AGRUPACION"));
		out.addAll(ensamblarDto(activosPorSubdivision, "SUBDIVISION"));

		return out;
	}

	private List<ActivoPropagacionDto> ensamblarDto(List<Activo> list, String parentesco) {
		
		List<ActivoPropagacionDto> out = new ArrayList<ActivoPropagacionDto>();

		for (Activo a : list) {

			ActivoPropagacionDto dto = new ActivoPropagacionDto(parentesco);

			try {

				beanUtilNotNull.copyProperties(dto, a);

			} catch (IllegalAccessException e) {
				logger.error(e);
				throw new RuntimeException(e);
			} catch (InvocationTargetException e) {
				logger.error(e);
				throw new RuntimeException(e);
			}

			out.add(dto);
		}

		return out;
	}

	private List<Activo> getActivosPorAgrupacion(final Activo activo) {

		List<Activo> activosPorAgrupacion = new ArrayList<Activo>();
		List<ActivoAgrupacionActivo> agrupacionesDelActivo = activo.getAgrupaciones();

		for (ActivoAgrupacionActivo activoAgrupacionActivo : agrupacionesDelActivo) {
			if (activoAgrupacionActivo.getAgrupacion() != null 
					&& isActivoAgrupacionTipo(activoAgrupacionActivo, DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA, DDTipoAgrupacion.AGRUPACION_ASISTIDA)) {

				// por cada agrupacion sobre el activo original se recuperan los activos de dicha agrupacion
				for (ActivoAgrupacionActivo agrupacionActivo : activoAgrupacionActivo.getAgrupacion().getActivos()) {
					activosPorAgrupacion.add(agrupacionActivo.getActivo());
				}
			}
		}

		return activosPorAgrupacion;
	}

	private boolean isActivoAgrupacionTipo(ActivoAgrupacionActivo activoAgrupacionActivo, String... codigosTipoAgrupacion) {

		for (String codigo : codigosTipoAgrupacion) {

			if (activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion() != null 
					&& codigo.equals(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo())) {

				return true;
			}
		}

		return false;
	}
}