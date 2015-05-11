package es.capgemini.pfs.web.genericForm.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.web.genericForm.GenericFormItem;

public interface GenericFormItemDao extends AbstractDao<GenericFormItem, Long> {

	List<GenericFormItem> getByIdTareaProcedimiento(Long id);
}
