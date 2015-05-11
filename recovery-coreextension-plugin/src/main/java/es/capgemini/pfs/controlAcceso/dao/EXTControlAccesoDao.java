package es.capgemini.pfs.controlAcceso.dao;

import java.util.List;

import es.capgemini.pfs.controlAcceso.model.EXTControlAcceso;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;

public interface EXTControlAccesoDao extends AbstractDao<EXTControlAcceso, Long>{
	
	EXTControlAcceso createNewControlAcceso();

	List<EXTControlAcceso> buscaAccesoHoy(Usuario usuarioLogado);

}
