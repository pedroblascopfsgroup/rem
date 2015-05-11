package es.capgemini.pfs.titulo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.titulo.dao.DDTipoTituloGeneralDao;
import es.capgemini.pfs.titulo.model.DDTipoTituloGeneral;

/**
 * Clase que implementa los mÃ©todos de la interfaz DDTipoTituloGeneralDao.
 *
 */
@Repository("DDTipoTituloGeneralDao")
public class DDTipoTituloGeneralDaoImpl extends AbstractEntityDao<DDTipoTituloGeneral, Long> implements DDTipoTituloGeneralDao {

    /**
     * Retorna el tipo de título para un código determinado.
     * @param codigo String
     * @return DDTipoTitulo
     */
    @SuppressWarnings("unchecked")
    @Override
    public DDTipoTituloGeneral obtenerTipoTitulo(String codigo) {

        logger.debug("Buscando tipo título general con código: " + codigo);

        String hsql = "from DDTipoTituloGeneral where ";
        hsql += "UPPER(codigo) = UPPER(?) and auditoria.borrado = false";
        List<DDTipoTituloGeneral> listaTitulos = getHibernateTemplate().find(hsql, new Object[] {codigo});

        return listaTitulos.get(0);

    }
}
