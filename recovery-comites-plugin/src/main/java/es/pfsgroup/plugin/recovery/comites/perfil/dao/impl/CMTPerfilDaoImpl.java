package es.pfsgroup.plugin.recovery.comites.perfil.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Perfil;
import es.pfsgroup.plugin.recovery.comites.perfil.dao.CMTPerfilDao;

@Repository("CMTPerfilDao")
public class CMTPerfilDaoImpl extends AbstractEntityDao<Perfil, Long> implements CMTPerfilDao{

}
