package es.pfsgroup.recovery.ext.impl.multigestor.dao;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.SQLQuery;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.ext.api.multigestor.dao.EXTGrupoUsuariosDao;
import es.pfsgroup.recovery.ext.impl.multigestor.model.EXTGrupoUsuarios;

@Repository
public class EXTGrupoUsuariosDaoImpl extends AbstractEntityDao<EXTGrupoUsuarios, Long> implements EXTGrupoUsuariosDao{

	@Override
	public List<Long> buscaGruposUsuario(Usuario usuario) {
		String queryString = "Select distinct usu_id_grupo from ${master.schema}.gru_grupos_usuarios gru "
				+ " WHERE usu_id_usuario = "
				+ usuario.getId()
				+ " and gru.borrado=0 ";

		SQLQuery sqlQuery = getHibernateTemplate().getSessionFactory()
				.getCurrentSession().createSQLQuery(queryString);

		List<Long> listado = new ArrayList<Long>();

		List<Object> lista = sqlQuery.list();
		for (Object obj : lista) {
			listado.add(Long.parseLong(obj.toString()));
		}

		return listado;
	}
	
	@Override
	public List<Long> getIdsUsuariosGrupoUsuario(Usuario usuario) {
		List<Long> idsGrupo = this.buscaGruposUsuario(usuario);
		
		if (idsGrupo.size()==0)
			return new ArrayList<Long>();
		
		String queryString = "Select distinct usu_id_usuario from ${master.schema}.gru_grupos_usuarios gru "
				+ " WHERE usu_id_grupo IN (";
		StringBuilder listaidsGrupo = new StringBuilder();
		for (Long idGrupo : idsGrupo) {
			listaidsGrupo.append("," + idGrupo.toString());
		}
		if (listaidsGrupo.length()>1)
			queryString += listaidsGrupo.deleteCharAt(0).toString(); 
		queryString += ") and gru.borrado=0 ";
		
		SQLQuery sqlQuery = getHibernateTemplate().getSessionFactory().getCurrentSession().createSQLQuery(queryString);
		
		List<Long> listado = new ArrayList<Long>();
		
		List<Object> lista = sqlQuery.list();
		for (Object obj : lista) {
			listado.add(Long.parseLong(obj.toString()));
		}
		// Y agregamos tambien los usuarios grupo
		for (Long idGrupo : idsGrupo) {
			listado.add(idGrupo);
		}
		
		return listado;
	}

}
