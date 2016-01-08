package es.pfsgroup.plugin.recovery.comites.asunto.dao;

import java.util.List;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.dao.AbstractDao;

public interface CMTAsuntoDao extends AbstractDao<Asunto, Long>{

	public List<Asunto> getAsuntosComite(Long id);

}
