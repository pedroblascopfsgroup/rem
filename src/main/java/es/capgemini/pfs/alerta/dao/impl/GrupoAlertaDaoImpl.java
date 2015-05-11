package es.capgemini.pfs.alerta.dao.impl;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.alerta.dao.GrupoAlertaDao;
import es.capgemini.pfs.alerta.model.GrupoAlerta;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Andrés Esteban
 *
 */
@Repository("GrupoAlertaDao")
public class GrupoAlertaDaoImpl extends AbstractEntityDao<GrupoAlerta, Long> implements GrupoAlertaDao {


}
