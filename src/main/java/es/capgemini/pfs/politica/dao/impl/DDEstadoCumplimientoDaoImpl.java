package es.capgemini.pfs.politica.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.politica.dao.DDEstadoCumplimientoDao;
import es.capgemini.pfs.politica.model.DDEstadoCumplimiento;

/**
 * Implementación de DDEstadoCumplimientoDao.
 * @author aesteban
 *
 */
@Repository("DDEstadoCumplimientoDao")
public class DDEstadoCumplimientoDaoImpl extends AbstractEntityDao<DDEstadoCumplimiento, Long> implements DDEstadoCumplimientoDao {

    /**
     * Devuelve el DDEstadoCumplimiento correspondiente a ese código.
     * @param codigo el codigo del estado de cumplimiento
     * @return el estado de cumplimiento
     */
    @SuppressWarnings("unchecked")
    @Override
    public DDEstadoCumplimiento buscarPorCodigo(String codigo) {
        List<DDEstadoCumplimiento> lista = getHibernateTemplate().find("from DDEstadoCumplimiento where codigo = ?",codigo);
        if (lista.size() > 0) {
            return lista.get(0);
        }
        return null;
    }

}
