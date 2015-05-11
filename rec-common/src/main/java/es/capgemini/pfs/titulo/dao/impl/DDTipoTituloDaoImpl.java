package es.capgemini.pfs.titulo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.titulo.dao.DDTipoTituloDao;
import es.capgemini.pfs.titulo.model.DDTipoTitulo;

/**
 * Clase que implementa los métodos de la interfaz DDTipoTituloDao.
 */
@Repository("DDTipoTituloDao")
public class DDTipoTituloDaoImpl extends AbstractEntityDao<DDTipoTitulo, Long> implements DDTipoTituloDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public DDTipoTitulo obtenerTipoTitulo(String codigo) {

        logger.debug("Buscando tipo título con código: " + codigo);

        String hsql = "from DDTipoTitulo where ";
        hsql += "UPPER(codigo) = UPPER(?) and auditoria.borrado = false";
        List<DDTipoTitulo> listaTitulos = getHibernateTemplate().find(hsql, new Object[] {codigo});

        if (listaTitulos!=null && listaTitulos.size()>0){
        	return listaTitulos.get(0);
        }
        return null;

    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<DDTipoTitulo> buscarPorTipoGeneral(String codigoTipoDocGen) {
        String hsql = "from DDTipoTitulo where ";
        hsql += "UPPER(tipoTituloGeneral.codigo) = UPPER(?) and auditoria.borrado = false";
        return getHibernateTemplate().find(hsql,new Object[] {codigoTipoDocGen});
    }
}
