package es.capgemini.pfs.expediente.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.dao.ExpedientePersonaDao;
import es.capgemini.pfs.expediente.model.DDAmbitoExpediente;
import es.capgemini.pfs.expediente.model.ExpedientePersona;
import es.capgemini.pfs.persona.model.Persona;

/**
 * Clase que agrupa método para la creación y acceso de datos de las
 * personas del expedientes.
 *
 * @author pajimene
 */
@Repository("ExpedientePersonaDao")
public class ExpedientePersonaDaoImpl extends AbstractEntityDao<ExpedientePersona, Long> implements ExpedientePersonaDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public ExpedientePersona get(Long idExpediente, Long idPersona) {
        String hql = "from ExpedientePersona pex where pex.expediente.id = ? and pex.persona.id = ?" + "     and cex.auditoria."
                + Auditoria.UNDELETED_RESTICTION;
        List<ExpedientePersona> l = getHibernateTemplate().find(hql, new Object[] { idExpediente, idPersona });
        if (l.size() == 0) { return null; }
        return l.get(0);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<ExpedientePersona> getListadoExpedientePersonaAmbito(Long idExpediente, DDAmbitoExpediente ambitoExpediente) {

        //Filtramos las personas que están excluidas
        StringBuilder hqlPersonas = new StringBuilder();
        hqlPersonas.append(" select distinct see.personas ");
        hqlPersonas.append(" from ExclusionExpedienteCliente see ");
        hqlPersonas.append(" where see.auditoria.borrado = false and see.expediente.id = ? ");
        List<Persona> personas = getHibernateTemplate().find(hqlPersonas.toString(), new Object[] { idExpediente });

        StringBuilder hql = new StringBuilder();

        String[] vAmbitos = DDAmbitoExpediente.getListadoAmbitos(ambitoExpediente);
        if (vAmbitos == null) { return null; }

        hql.append("select pex from ExpedientePersona pex ");
        hql.append(" where pex.expediente.id = ? and pex.auditoria.borrado = false ");
        hql.append(" and pex.ambitoExpediente.codigo IN (");

        boolean isSeparador = false;
        for (String amb : vAmbitos) {
            if (isSeparador) {
                hql.append(",");
            }
            isSeparador = true;

            hql.append("'" + amb + "'");
        }
        hql.append(")");
        
        if(ambitoExpediente.getCodigo().equals(DDAmbitoExpediente.PERSONA_PASE)){
        	hql.append(" and pex.pase = 1 ");
        }
        
        

        //Filtramos las personas que están excluidas
        if (personas != null && personas.size() > 0) {
            hql.append("and pex.persona.id NOT IN (");
            for (Persona per : personas) {
                hql.append(per.getId()).append(",");
            }
            hql.deleteCharAt(hql.length() - 1);
            hql.append(")");
        }

        return getHibernateTemplate().find(hql.toString(), new Object[] { idExpediente });
    }
}
