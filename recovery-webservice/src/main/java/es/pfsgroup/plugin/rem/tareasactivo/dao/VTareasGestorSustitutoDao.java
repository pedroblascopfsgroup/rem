package es.pfsgroup.plugin.rem.tareasactivo.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.DtoTareaGestorSustitutoFilter;
import es.pfsgroup.plugin.rem.model.VTramitesGestorSustituto;

public interface VTareasGestorSustitutoDao extends AbstractDao<VTramitesGestorSustituto, Long>{

	Page getListTareasGS(DtoTareaGestorSustitutoFilter dto);
}
