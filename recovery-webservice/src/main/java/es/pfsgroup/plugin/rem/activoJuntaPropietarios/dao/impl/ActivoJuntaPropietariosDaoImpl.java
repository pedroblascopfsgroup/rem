package es.pfsgroup.plugin.rem.activoJuntaPropietarios.dao.impl;


import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormatter;
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
		
		HQLBuilder hb = null;
		Long numActivo = dtoActivoJuntaPropietarios.getNumActivo();
		String codProveedor = dtoActivoJuntaPropietarios.getCodProveedor();
		String fechaDesde = dtoActivoJuntaPropietarios.getFechaDesde();
		String fechaHasta = dtoActivoJuntaPropietarios.getFechaHasta();
		Date fechaDesdeDate = DateFormatter.toDate(fechaDesde, "dd/MM/yy");
		Date fechaHastaDate = DateFormatter.toDate(fechaHasta, "dd/MM/yy");
				

		hb = new HQLBuilder("select vjunta from VActivoJuntaPropietarios vjunta" );		

		HQLBuilder.addFiltroIgualQue(hb, "vjunta.numActivo", numActivo);
		HQLBuilder.addFiltroIgualQue(hb, "vjunta.codProveedor", codProveedor);
		if(fechaDesdeDate != null && fechaHastaDate != null) {
			hb.appendWhere("vjunta.fechaJunta >= :fechaDesdeDate",HQLBuilder.QUIERE_OR_TRUE);
			hb.appendWhere("vjunta.fechaJunta <= :fechaHastaDate");
			hb.getParameters().put("fechaDesdeDate", fechaDesdeDate);
			hb.getParameters().put("fechaHastaDate", fechaHastaDate);
		}else {
			HQLBuilder.addFiltroIgualOMayorQueSiNotNull(hb, "vjunta.fechaJunta", fechaDesdeDate);
			HQLBuilder.addFiltroIgualOMenorQueSiNotNull(hb, "vjunta.fechaJunta", fechaHastaDate);
		}

				
		return hb;
	}

	@SuppressWarnings("unchecked")
	private DtoPage getListadoJuntasCompleto(DtoActivoJuntaPropietarios dtoActivoJuntaPropietarios, HQLBuilder hb) {

		Page pageJuntas = HibernateQueryUtils.page(this, hb, dtoActivoJuntaPropietarios);
		List<VActivoJuntaPropietarios> juntas = (List<VActivoJuntaPropietarios>) pageJuntas.getResults();

		return new DtoPage(juntas, pageJuntas.getTotalCount());
	}

}
