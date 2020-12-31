package es.pfsgroup.plugin.rem.propietario.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;

import es.pfsgroup.plugin.rem.model.ActivoPropietario;



public interface ActivoPropietarioDao extends AbstractDao<ActivoPropietario, Long>{
	
	List<ActivoPropietario> getPropietarioIdDescripcionCodigo();
	
	
	
}
