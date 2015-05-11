package es.capgemini.pfs.grupoCliente.dao.impl;

import java.util.HashMap;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.grupoCliente.dao.PersonaGrupoDao;
import es.capgemini.pfs.grupoCliente.dto.DtoPersonasDelGrupo;
import es.capgemini.pfs.grupoCliente.model.PersonaGrupo;

/**
 * @author marruiz
 */
@Repository("PersonaGrupoDao")
public class PersonaGrupoDaoImpl extends AbstractEntityDao<PersonaGrupo, Long> implements PersonaGrupoDao {

    @Resource
    private PaginationManager paginationManager;

    /**
     * {@inheritDoc}
     */
    @Override
    public Page getPersonasGrupo(DtoPersonasDelGrupo dto) {
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("idGrupo", dto.getIdGrupo());

        String hql = "select pg from PersonaGrupo pg where pg.grupoCliente.auditoria." + Auditoria.UNDELETED_RESTICTION
                + " and pg.grupoCliente.id = :idGrupo";
        return paginationManager.getHibernatePage(getHibernateTemplate(), hql, dto, param);
    }
}
