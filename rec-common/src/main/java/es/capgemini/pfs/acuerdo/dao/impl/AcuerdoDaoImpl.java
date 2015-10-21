package es.capgemini.pfs.acuerdo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.dao.AcuerdoDao;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;

/**
 * @author Mariano Ruiz
 *
 */
@Repository("AcuerdoDao")
public class AcuerdoDaoImpl extends AbstractEntityDao<Acuerdo, Long> implements AcuerdoDao {

    /**
     * Busca Acuerdos de un asunto.
     * @param idAsunto id del asunto
     * @return lista Acuerdo.
     */
    @SuppressWarnings("unchecked")
    public List<Acuerdo> getAcuerdosDelAsunto(Long idAsunto) {
        String hql = "from Acuerdo a where a.asunto.id = ?";
        List<Acuerdo> acuerdos = getHibernateTemplate().find(hql, idAsunto);
        return acuerdos;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public Acuerdo getUltimoAcuerdoUsuario(Usuario usuario) {
        String hql = "from Acuerdo a where a.auditoria.usuarioCrear = ?"
                + " and a.id = (select max(a1.id) from Acuerdo a1 where a1.auditoria.usuarioCrear = ?)";
        List<Acuerdo> acuerdos = getHibernateTemplate().find(hql, new Object[] { usuario.getUsername(), usuario.getUsername() });
        if (acuerdos.size() > 0) { return acuerdos.get(0); }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Acuerdo> getAcuerdosDelExpediente(Long idExpediente) {
        String hql = "from Acuerdo a where a.expediente.id = ? and a.auditoria.borrado = 0";
        List<Acuerdo> acuerdos = getHibernateTemplate().find(hql, idExpediente);
        return acuerdos;
    }
    
    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Acuerdo> getAcuerdosDelExpedienteDespacho(Long idExpediente, List<Long> idsDespacho) {
        String hql = "from Acuerdo a where a.expediente.id = ? and a.auditoria.borrado = 0";
        if (!Checks.estaVacio(idsDespacho)) {
        	if (idsDespacho.size()==1) {
        		hql += " and a.despacho.id="+idsDespacho.get(0);
        	} else {
        		hql += " and a.despacho.id in ("+convertirEnStringComas(idsDespacho)+")";
        	}
        }
        List<Acuerdo> acuerdos = getHibernateTemplate().find(hql, idExpediente);
        return acuerdos;
    }
    
    
	private Object convertirEnStringComas(List<Long> cadena) {
		String r = null;
		for (Long cad : cadena){
			if (!Checks.esNulo(r)){
				r = r + ',' + cad.toString();
			}else{
				r = cad.toString();
			}
		}
		return r;
	}
    /**
     * Buscar otros Acuerdos vigentes para el mismo Asunto.
     * @param idAsunto el id del asunto.
     * @param idAcuerdo el id del acuerdo que se quiere guardar.
     * @return boolean
     */
    @SuppressWarnings("unchecked")
    public boolean hayAcuerdosVigentes(Long idAsunto, Long idAcuerdo) {
        String hql = "from Acuerdo ac where ac.asunto.id = ? and ac.estadoAcuerdo.codigo = " + DDEstadoAcuerdo.ACUERDO_ACEPTADO;
        List<Acuerdo> acuerdos;
        if (idAcuerdo != null) {
            hql += " and ac.id != ? ";
            acuerdos = getHibernateTemplate().find(hql, new Object[] { idAsunto, idAcuerdo });
        } else {
            acuerdos = getHibernateTemplate().find(hql, new Object[] { idAsunto });
        }
        if (acuerdos != null) { return acuerdos.size() > 0; }
        return false;
    }
}
