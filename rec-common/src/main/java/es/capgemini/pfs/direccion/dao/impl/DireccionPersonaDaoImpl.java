package es.capgemini.pfs.direccion.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.direccion.dao.DireccionPersonaDao;
import es.capgemini.pfs.direccion.model.DireccionPersona;
import es.capgemini.pfs.direccion.model.DireccionPersonaId;

@Repository("DireccionPersonaDao")
public class DireccionPersonaDaoImpl  extends AbstractEntityDao<DireccionPersona, DireccionPersonaId> implements DireccionPersonaDao  {

}
