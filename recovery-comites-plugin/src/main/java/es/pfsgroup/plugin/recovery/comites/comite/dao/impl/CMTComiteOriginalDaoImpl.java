package es.pfsgroup.plugin.recovery.comites.comite.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.comites.comite.dao.CMTComiteOriginalDao;

@Repository("CMTComiteOriginalDao")
public class CMTComiteOriginalDaoImpl extends AbstractEntityDao<Comite, Long> 
 implements CMTComiteOriginalDao{

}
