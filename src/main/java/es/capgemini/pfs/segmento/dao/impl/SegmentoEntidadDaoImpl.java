package es.capgemini.pfs.segmento.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.segmento.dao.SegmentoEntidadDao;
import es.capgemini.pfs.segmento.model.DDSegmentoEntidad;

/**
 * @author Mariano Ruiz
 *
 */
@Repository("SegmentoEntidadDao")
public class SegmentoEntidadDaoImpl extends AbstractEntityDao<DDSegmentoEntidad, Long> implements SegmentoEntidadDao {

}
