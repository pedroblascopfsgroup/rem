package es.pfsgroup.plugin.rem.activo.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.rem.activo.dao.VisitaGencatDao;
import es.pfsgroup.plugin.rem.model.VisitaGencat;

@Repository("VisitaGencat")
public class VisitaGencatDaoImpl extends AbstractEntityDao<VisitaGencat, Long> implements VisitaGencatDao {

}
