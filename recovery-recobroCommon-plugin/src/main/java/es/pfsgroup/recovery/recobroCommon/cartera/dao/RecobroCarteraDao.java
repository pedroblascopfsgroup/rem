package es.pfsgroup.recovery.recobroCommon.cartera.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.cartera.dto.RecobroDtoCartera;
import es.pfsgroup.recovery.recobroCommon.cartera.model.RecobroCartera;

public interface RecobroCarteraDao  extends AbstractDao<RecobroCartera, Long>  {

	public Page buscaCarteras(RecobroDtoCartera dto);

	public Page buscaCarterasDisponibles(RecobroDtoCartera dto);
}
