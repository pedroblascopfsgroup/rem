package es.pfsgroup.plugin.rem.oferta.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.oferta.dao.VOfertaActivoDao;

@Repository("VOfertasActivosAgrupacionDao")
public class VOfertaActivoDaoImpl extends AbstractEntityDao<VOfertasActivosAgrupacion, Long> implements VOfertaActivoDao {

	
	
	@Override
	public List<VOfertasActivosAgrupacion> getListOfertasFromView(DtoOfertasFilter dtoOfertasFilter) {

		HQLBuilder hb = new HQLBuilder(" from VOfertasActivosAgrupacion voferta");

		if (!Checks.esNulo(dtoOfertasFilter.getNumOferta())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.numOferta", dtoOfertasFilter.getNumOferta().toString());
		}

		if (!Checks.esNulo(dtoOfertasFilter.getNumAgrupacion())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.numActivoAgrupacion", dtoOfertasFilter.getNumAgrupacion().toString());
		}
		if (!Checks.esNulo(dtoOfertasFilter.getIdActivo())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.idActivo", dtoOfertasFilter.getIdActivo().toString());
		}
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.codigoTipoOferta", dtoOfertasFilter.getTipoOferta());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.codigoEstadoOferta", dtoOfertasFilter.getEstadoOferta());
		
		if (!Checks.esNulo(dtoOfertasFilter.getIdOferta())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.idOferta", dtoOfertasFilter.getIdOferta().toString());
		}

		hb.orderBy("voferta.fechaModificar", HQLBuilder.ORDER_DESC);

		return HibernateQueryUtils.list(this, hb);

	}


}
