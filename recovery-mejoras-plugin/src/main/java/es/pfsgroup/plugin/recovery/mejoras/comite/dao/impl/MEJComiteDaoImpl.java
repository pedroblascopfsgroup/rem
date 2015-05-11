package es.pfsgroup.plugin.recovery.mejoras.comite.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.persona.dao.impl.PageSql;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.mejoras.comite.dao.MEJComiteDao;
import es.pfsgroup.plugin.recovery.mejoras.comite.dto.MEJDtoBusquedaPreAsuntosComite;
import es.pfsgroup.plugin.recovery.mejoras.comite.model.MEJComite;

@Repository("MejComiteDao")
public class MEJComiteDaoImpl extends AbstractEntityDao<MEJComite, Long>
		implements MEJComiteDao {

	@SuppressWarnings("unchecked")
	@Override
	public List<MEJComite> findComitesValidosCurrentUser(Usuario usuario) {

		StringBuilder sb = new StringBuilder();

		sb
				.append("select distinct c from ZonaUsuarioPerfil zpu, PuestosComite pco, MEJComite c ");
		sb
				.append("WHERE c.auditoria.borrado = false and pco.auditoria.borrado = false and zpu.auditoria.borrado = false ");
		sb
				.append("and zpu.zona.id = pco.zona.id and pco.comite.id = c.id and zpu.usuario.id = ? ");

		List<MEJComite> lista = new ArrayList<MEJComite>();
		try {
			lista = (List<MEJComite>) getHibernateTemplate().find(
					sb.toString(), usuario.getId());
		} catch (Exception e) {
			
			e.printStackTrace();

		}
		
		return lista;
	}

	@Override
	public void clear() {
		getHibernateTemplate().getSessionFactory().getCurrentSession().clear();

	}

	@Override
	public void flush() {
		getHibernateTemplate().getSessionFactory().getCurrentSession().flush();

	}

	@Override
	public Page getPreAsuntosComite(MEJDtoBusquedaPreAsuntosComite dto) {
		
		Long idComite = new Long(dto.getIdComite());
		List<Asunto> listaPreAsuntos = new ArrayList<Asunto>();
		
		 PageSql page = new PageSql();
		
		MEJComite comite = get(idComite);
		if(comite != null)
			listaPreAsuntos =  comite.getPreAsuntos();
		
		int size = listaPreAsuntos.size();

        int fromIndex = dto.getStart();
        int toIndex = dto.getStart() + dto.getLimit();

        //Paginado, si no existe, creamos la paginación nosotros
        if (fromIndex < 0 || toIndex < 0) {
            fromIndex = 0;
            toIndex = 5;
        }
        if (listaPreAsuntos.size() >= dto.getStart() + dto.getLimit())
        	listaPreAsuntos = listaPreAsuntos.subList(dto.getStart(), dto.getStart() + dto.getLimit());
        else
        	listaPreAsuntos = listaPreAsuntos.subList(dto.getStart(), listaPreAsuntos.size());
		
        page.setTotalCount(size);
        page.setResults(listaPreAsuntos);
		return page;
	}

}
