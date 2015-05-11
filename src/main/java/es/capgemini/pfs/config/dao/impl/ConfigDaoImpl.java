package es.capgemini.pfs.config.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.config.Config;
import es.capgemini.pfs.config.dao.ConfigDao;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Nicolás Cornaglia
 */
@Repository("ConfigDao")
public class ConfigDaoImpl extends AbstractEntityDao<Config, String> implements ConfigDao {

}
