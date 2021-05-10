package es.pfsgroup.plugin.rem.oferta.dao;


import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosAgrupacionIncAnuladas;


public interface VOfertaActivoDao extends AbstractDao<VGridOfertasActivosAgrupacionIncAnuladas, Long>{
	

	public List<VGridOfertasActivosAgrupacionIncAnuladas> getListOfertasFromView(DtoOfertasFilter dtoOfertasFilter);


}
