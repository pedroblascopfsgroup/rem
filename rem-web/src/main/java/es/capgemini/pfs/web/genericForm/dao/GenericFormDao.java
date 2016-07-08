package es.capgemini.pfs.web.genericForm.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.web.genericForm.GenericForm;

public interface GenericFormDao extends AbstractDao<GenericForm,Long> {
	
	GenericForm getByTipoProcedimiento(Long tipoProcedimiento);
	GenericForm getByCodigoTipoProcedimiento(String codigoTipoProcedimiento);
	List<GenericForm> getByTipoProcedimiento(String codigoTipoProcedimiento);
}
