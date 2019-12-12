package es.pfsgroup.plugin.rem.gestorSustituto.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.DtoGestoresSustitutosFilter;
import es.pfsgroup.plugin.rem.model.GestorSustituto;
import es.pfsgroup.plugin.rem.model.VBusquedaGestoresSustitutos;

public interface GestorSustitutoDao extends AbstractDao<GestorSustituto, Long>{

	Page getPageGestoresSustitutos(DtoGestoresSustitutosFilter dto);
	String accionGestoresSustitutos(DtoGestoresSustitutosFilter dto);

}
