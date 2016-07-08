package es.pfsgroup.framework.paradise.agenda.formulario.dao;
import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
//import es.capgemini.pfs.web.genericForm.GenericFormItem;

public interface ParadiseFormItemDao extends AbstractDao<GenericFormItem, Long>{

	List<GenericFormItem> getByIdTareaProcedimiento(Long id);
	
}