package es.capgemini.pfs.cliente.dao.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.hibernate.pagination.PageHibernate;
import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.pagination.PaginationParams;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cliente.dao.ClienteDao;
import es.capgemini.pfs.cliente.dto.DtoBuscarClientes;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.persona.model.Persona;

/**
 * DAO de clientes.
 */
@Repository("ClienteDao")
public class ClienteDaoImpl extends AbstractEntityDao<Cliente, Long> implements ClienteDao {

    @Resource
    private PaginationManager paginationManager;

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Cliente> findClientes(DtoBuscarClientes dto) {
        List<Object> params = new ArrayList<Object>();
        String hql = "from Cliente c where c.auditoria.borrado = false";
        hql += " and (c.persona.nombre like '%?%' or c.persona.nombre is null)";
        if (dto.getNombre() != null) {
            params.add(dto.getNombre());
        } else {
            params.add("");
        }
        hql += " and (c.persona.apellido1 like '%%' or c.persona.apellido1 is null)";
        if (dto.getApellido1() != null) {
            params.add(dto.getApellido1());
        } else {
            params.add("");
        }

        if (dto.getSegmento() != null && !dto.getSegmento().equals("")) {
            hql += " and c.persona.segmentoEntidad.codigo like '%?%'";
            params.add(dto.getSegmento());
        }

        if (dto.getSituacion() != null && !dto.getSituacion().equals("")) {
            hql += " and c.estadoItinerario.codigo = '?'";
            params.add(dto.getSituacion());
        }
        if (dto.getDocId() != null) {
            hql += " and c.persona.docId = ?";
            params.add(dto.getDocId());
        }
        if (dto.getCodigoEntidad() != null) {
            hql += " and c.persona.codClienteEntidad = ?";
            params.add(dto.getCodigoEntidad());
        }

        return getHibernateTemplate().find(hql, params.toArray());
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Cliente> findClientesByContrato(Long idContrato) {
        String hql = "select c from Cliente c, ClienteContrato cc where ";
        hql += " c.id = cc.cliente.id and cc.contrato.id = ?";
        hql += " and c.auditoria.borrado = false and cc.auditoria.borrado = false ";
        return getHibernateTemplate().find(hql, idContrato);
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public List<Cliente> findClientesTitularesByContrato(Long idContrato) {

        String hql = "select cli from Cliente cli, ContratoPersona rel, DDTipoIntervencion tip_int where ";
        hql += " rel.contrato.id = ?";
        hql += " and rel.persona.id = cli.persona.id";
        hql += " and rel.tipoIntervencion.id = tip_int.id";
        hql += " and tip_int.titular = true ";
        hql += " and cli.auditoria.borrado = false";
        hql += " and rel.auditoria.borrado = false";
        hql += " and tip_int.auditoria.borrado = false";

        return getHibernateTemplate().find(hql, new Object[] { idContrato });
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Page findClientesPaginated(DtoBuscarClientes clientes) {
        Page page = paginationManager.getHibernatePage(getHibernateTemplate(), findClientesHsql(clientes), clientes);
        return page;
    }

    /**
     * Query de búsqueda usada en findClientesPaginated.
     * @param clientes DtoBuscarClientes
     * @return String
     */
    private String findClientesHsql(DtoBuscarClientes clientes) {
        String hql = "from Cliente c where c.auditoria.borrado = false";
        hql += " and (c.persona.nombre like '%";
        if (clientes.getNombre() != null) {
            hql += clientes.getNombre();
        }
        hql += "%' or c.persona.nombre is null)";
        hql += " and (c.persona.apellido1 like '%";
        if (clientes.getApellido1() != null) {
            hql += clientes.getApellido1();
        }
        hql += "%' or c.persona.apellido1 is null)";
        if (clientes.getSegmento() != null && !clientes.getSegmento().equals("")) {
            hql += " and c.persona.segmentoEntidad.codigo like '%" + clientes.getSegmento() + "%'";
        }

        if (clientes.getSituacion() != null && !clientes.getSituacion().equals("")) {
            hql += " and c.estadoItinerario.codigo = '" + clientes.getSituacion() + "'";
        }
        hql += " and c.persona.docId = " + Integer.parseInt(clientes.getDocId());
        hql += " and c.persona.codClienteEntidad = " + Integer.parseInt(clientes.getCodigoEntidad());

        return hql;
    }

    /**
     * {@inheritDoc}
     */
    public PageHibernate findByName(String clientToFind, PaginationParams tableParams) {
        PageHibernate p = new PageHibernate();
        //FIXME PARA QUE PASA PARÁMETROS???
        List<Cliente> results = new ArrayList<Cliente>();
        for (int i = 0; i < 10; i++) {
            Cliente c = new Cliente();
            c.setId((long) i);
            Persona per = new Persona();
            per.setNombre("cliente" + i);
            per.setApellido1("apellido" + i);
            c.setPersona(per);
            c.setId((long) i);
            results.add(c);
        }
        p.setResults(results);
        p.setTotalCount(50);

        return p;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public Cliente findClienteByContratoPaseId(Long idContrato) {
    	//RECOVERY-15
    	String hql = "select ccl.cliente from ClienteContrato ccl, Cliente cli " + " where ccl.pase=1 and ccl.contrato.id = "
    			+ idContrato + " and ccl.cliente.id = cli.id and ccl.auditoria." + Auditoria.UNDELETED_RESTICTION + " and cli.auditoria." 
    			+ Auditoria.UNDELETED_RESTICTION;
        List<Cliente> cliente = getHibernateTemplate().find(hql);
        if (cliente.size() == 0) {
            return null;
        } else if (cliente.size() == 1) { return cliente.get(0); }
        throw new UserException("expediente.incluircontrato.clientesactivos");
    }
}
