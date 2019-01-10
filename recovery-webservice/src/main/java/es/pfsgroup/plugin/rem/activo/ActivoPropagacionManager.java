package es.pfsgroup.plugin.rem.activo;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.api.ActivoPropagacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

@Service
public class ActivoPropagacionManager implements ActivoPropagacionApi {

	@Autowired
	private ActivoDao activoDao;

	@Autowired
	private AgrupacionAdapter agrupacionAdapter;

	public List<?> getAllActivosAgrupacionPorActivo(Activo activo) {

		//Activo activo = activoDao.get(idActivo);

		if (activo != null) {

			for (ActivoAgrupacionActivo activoAgrupacionActivo : activo.getAgrupaciones()) {
				if (activoAgrupacionActivo.getAgrupacion() != null
						&& isActivoAgrupacionTipo(activoAgrupacionActivo, DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA, DDTipoAgrupacion.AGRUPACION_ASISTIDA)) {
					DtoAgrupacionFilter filter = new DtoAgrupacionFilter();
					filter.setLimit(1000);
					filter.setStart(0);
					Page page = agrupacionAdapter.getListActivosAgrupacionById(filter, activoAgrupacionActivo.getAgrupacion().getId());
					return page.getResults(); // "teoricamente" solo puede haber una agrupacion de esos tipos en el activo.
				}
			}
		}

		return new ArrayList<String>();
	}

	private boolean isActivoAgrupacionTipo(ActivoAgrupacionActivo activoAgrupacionActivo, String... codigosTipoAgrupacion) {

		for (String codigo : codigosTipoAgrupacion) {

			if (activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion() != null && codigo.equals(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo())) {

				return true;
			}
		}

		return false;
	}
}