package es.pfsgroup.plugin.rem.gestorSustituto.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.DtoGestoresSustitutosFilter;
import es.pfsgroup.plugin.rem.model.GestorSustituto;

public interface GestorSustitutoDao extends AbstractDao<GestorSustituto, Long>{

	Page getListGestoresSustitutos(DtoGestoresSustitutosFilter dto);

}
