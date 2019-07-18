package es.pfsgroup.plugin.rem.activoJuntaPropietarios.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.activoJuntaPropietarios.dao.ActivoJuntaPropietariosDao;
import es.pfsgroup.plugin.rem.model.ActivoJuntaPropietarios;
import es.pfsgroup.plugin.rem.model.DtoActivoJuntaPropietarios;
import es.pfsgroup.plugin.rem.model.VActivoJuntaPropietarios;

@Repository("ActivoJuntaPropietariosDao")
public class ActivoJuntaPropietariosDaoImpl extends AbstractEntityDao<ActivoJuntaPropietarios, Long>
		implements ActivoJuntaPropietariosDao {

	public DtoPage getListJuntas(DtoActivoJuntaPropietarios dtoActivoJuntaPropietarios) {

		HQLBuilder hb = this.rellenarFiltrosBusquedaJuntas(dtoActivoJuntaPropietarios);
		return this.getListadoJuntasCompleto(dtoActivoJuntaPropietarios, hb);
	}

	private HQLBuilder rellenarFiltrosBusquedaJuntas(DtoActivoJuntaPropietarios dtoActivoJuntaPropietarios) {
		String select = "select vjunta ";
		String from = "from VActivoJuntaPropietarios vjunta";

		String where = "";
		boolean hasWhere = false;
		HQLBuilder hb = null;

		hb = new HQLBuilder(select + from + where);
		if (hasWhere) {
			hb.setHasWhere(true);
		}

		//HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vjunta.numActivo", dtoActivoJuntaPropietarios.getNumActivo());

		return hb;
	}

	@SuppressWarnings("unchecked")
	private DtoPage getListadoJuntasCompleto(DtoActivoJuntaPropietarios dtoActivoJuntaPropietarios, HQLBuilder hb) {

		Page pageJuntas = HibernateQueryUtils.page(this, hb, dtoActivoJuntaPropietarios);
		List<VActivoJuntaPropietarios> juntas = (List<VActivoJuntaPropietarios>) pageJuntas.getResults();

		return new DtoPage(juntas, pageJuntas.getTotalCount());
	}

}
