package es.pfsgroup.plugin.recovery.itinerarios.perfil.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Perfil;
import es.pfsgroup.plugin.recovery.itinerarios.perfil.dao.ITIPerfilDao;


@Repository("ITIPerfilDao")
public class ITIPerfilDaoImpl extends AbstractEntityDao<Perfil, Long> implements ITIPerfilDao {

}
