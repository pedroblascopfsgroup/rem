package es.pfsgroup.plugin.rem.oferta.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoVListadoOfertasAgrupadasLbk;
import es.pfsgroup.plugin.rem.model.VListadoOfertasAgrupadasLbk;

public interface VListadoOfertasAgrupadasLbkDao extends AbstractDao<VListadoOfertasAgrupadasLbk,Long>{
	public DtoPage getListOfertasAgrupadasLbk(DtoVListadoOfertasAgrupadasLbk dtoListadoOfertasAgrupadas);
	public DtoPage getListActivosOfertasAgrupadasLbk(DtoVListadoOfertasAgrupadasLbk dtoListadoOfertasAgrupadas);
}
