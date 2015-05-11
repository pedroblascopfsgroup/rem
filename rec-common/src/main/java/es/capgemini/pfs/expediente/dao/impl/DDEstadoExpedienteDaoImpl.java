package es.capgemini.pfs.expediente.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.dao.DDEstadoExpedienteDao;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;

/**
 * Clase que agrupa m�todo para la creaci�n y acceso de datos de los
 * contratos del expedientes.
 *
 * @author jbosnjak
 */
@Repository("DDEstadoExpedienteDao")
public class DDEstadoExpedienteDaoImpl extends AbstractEntityDao<DDEstadoExpediente, Long> implements DDEstadoExpedienteDao {

    /**
     * Devuelve un tipo de estado expediente por su código.
     * @param codigo el codigo
     * @return el estado expediente.
     */
    @SuppressWarnings("unchecked")
    public DDEstadoExpediente getByCodigo(String codigo) {
        String hql = "from DDEstadoExpediente where codigo = ?";
        List<DDEstadoExpediente> lista = getHibernateTemplate().find(hql, new Object[] { codigo });
        if (lista.size() > 0) {
            return lista.get(0);
        }
        return null;
    }
}
