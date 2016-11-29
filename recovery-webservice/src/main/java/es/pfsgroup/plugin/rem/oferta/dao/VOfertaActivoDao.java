package es.pfsgroup.plugin.rem.oferta.dao;


import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;


public interface VOfertaActivoDao extends AbstractDao<VOfertasActivosAgrupacion, Long>{
	

	public List<VOfertasActivosAgrupacion> getListOfertasFromView(DtoOfertasFilter dtoOfertasFilter);


}
