package es.pfsgroup.plugin.recovery.mejoras.gestorDespacho.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.plugin.recovery.mejoras.gestorDespacho.dto.MEJDtoComboGestores;

public interface MEJGestorDespachoDao extends AbstractDao<GestorDespacho, Long>{

	Page findByDescyDesp(MEJDtoComboGestores dto);

	List<GestorDespacho>  findByDescyDespComboPaginado(MEJDtoComboGestores dto);
}
