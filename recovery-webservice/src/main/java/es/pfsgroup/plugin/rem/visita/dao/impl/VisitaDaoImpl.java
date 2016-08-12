package es.pfsgroup.plugin.rem.visita.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.visita.dao.VisitaDao;

@Repository("VisitaDao")
public class VisitaDaoImpl extends AbstractEntityDao<Visita, Long> implements VisitaDao{

}
