package es.pfsgroup.plugin.rem.rest.dao.impl;

import java.io.Serializable;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.rem.rest.dao.GenericRestDao;

@Repository("genericaRestDaoImp")
public class GenericaRestDaoImp extends AbstractEntityDao<Serializable, Serializable> implements GenericRestDao{

}
