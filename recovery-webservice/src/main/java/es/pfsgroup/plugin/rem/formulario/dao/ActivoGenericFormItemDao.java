package es.pfsgroup.plugin.rem.formulario.dao;
import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;

public interface ActivoGenericFormItemDao extends AbstractDao<GenericFormItem, Long>{

	List<GenericFormItem> getByIdTareaProcedimiento(Long id);
	
}