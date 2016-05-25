package es.pfsgroup.plugin.recovery.coreextension.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.persona.dao.impl.PageSql;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.coreextension.api.UsuarioDto;
import es.pfsgroup.plugin.recovery.coreextension.dao.EXTGestoresDao;

@Repository("EXTGestoresDao")
public class EXTGestoresDaoImpl extends AbstractEntityDao<Usuario, Long> implements EXTGestoresDao{

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.coreextension.dao.EXTGestoresDao#getGestoresByDespacho(long)
	 */
	@Override
	public List<Usuario> getGestoresByDespacho(long idTipoDespacho) {
				
		return getGestoresByDespacho(idTipoDespacho, true);		
	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.coreextension.dao.EXTGestoresDao#getGestoresByDespacho(long)
	 */
	@Override
	public List<Usuario> getGestoresByDespacho(long idTipoDespacho, boolean incluirBorrados) {
		HQLBuilder hb = new HQLBuilder(" select gd.usuario from GestorDespacho gd");
		
		HQLBuilder.addFiltroIgualQue(hb, "gd.despachoExterno.id", idTipoDespacho);
		
		if(!incluirBorrados) {
			HQLBuilder.addFiltroIgualQue(hb, "gd.auditoria.borrado", false);
		}
		
		return HibernateQueryUtils.list(this, hb);
		
	}
	
	@Override
	public List<Usuario> getGestoresPorDefectoByDespacho(long idTipoDespacho, boolean incluirBorrados) {
		HQLBuilder hb = new HQLBuilder(" select gd.usuario from GestorDespacho gd");
		
		HQLBuilder.addFiltroIgualQue(hb, "gd.despachoExterno.id", idTipoDespacho);
		HQLBuilder.addFiltroIgualQue(hb, "gd.gestorPorDefecto", true);
		
		if(!incluirBorrados) {
			HQLBuilder.addFiltroIgualQue(hb, "gd.auditoria.borrado", false);
		}
		
		return HibernateQueryUtils.list(this, hb);
		
	}
	
	@Override
	public List<Usuario> getGestorOficinaExpedienteGestorDeuda(long idExpediente, String codigoPerfil){
		List<Usuario> listUsuarios= new ArrayList<Usuario>();
		StringBuilder sqlUsuarios = new StringBuilder();
		sqlUsuarios.append("select zon_pef.usuario from ZonaUsuarioPerfil zon_pef,Perfil per, DDZona zon, Expediente exp");
		sqlUsuarios.append(" where zon_pef.zona.id = zon.id");
		sqlUsuarios.append(" and zon.oficina.id = exp.oficina.id");
		sqlUsuarios.append(" and per.codigo = '"+codigoPerfil+"'");
		sqlUsuarios.append(" and exp.id = :idExpediente");
		
		Query query = getSession().createQuery(sqlUsuarios.toString());
		query.setParameter("idExpediente", idExpediente);
		
		listUsuarios= (List<Usuario>) query.list();
		
		return listUsuarios;
		
	}
	

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.coreextension.dao.EXTGestoresDao#getGestoresByDespacho(es.pfsgroup.plugin.recovery.coreextension.api.UsuarioDto)
	 */
	@Override
	public Page getGestoresByDespacho(UsuarioDto usuarioDto) {

		PageSql page = new PageSql();
		int totalCount = this.getCountGestoresByDespacho(usuarioDto);
		
		StringBuilder sqlUsuarios = new StringBuilder();
		sqlUsuarios.append("select gd.usuario from GestorDespacho gd ");
		sqlUsuarios.append("where gd.despachoExterno.id = :idTipoDespacho ");
		sqlUsuarios.append(" and gd.auditoria.borrado = false ");
		if (StringUtils.hasText(usuarioDto.getQuery())){
			String[] palabras = usuarioDto.getQuery().split(" ");
			for (String palabra : palabras) {
				sqlUsuarios.append(" and (upper(gd.usuario.apellido1) like '%" + palabra.toUpperCase() + "%' ");
				sqlUsuarios.append(" or upper(gd.usuario.apellido2) like '%" + palabra.toUpperCase() + "%' ");
				sqlUsuarios.append(" or upper(gd.usuario.nombre) like '%" + palabra.toUpperCase() + "%' ) ");
			}
		}
		sqlUsuarios.append(" order by gd.usuario.apellido1 asc, gd.usuario.apellido2 asc, gd.usuario.nombre asc ");
		
		Query query = getSession().createQuery(sqlUsuarios.toString());
		query.setParameter("idTipoDespacho", usuarioDto.getIdTipoDespacho());
		query.setFirstResult(usuarioDto.getStart());
		query.setMaxResults(usuarioDto.getLimit());
		List<Usuario> lista = query.list();
		
		page.setTotalCount(totalCount);
		page.setResults(lista);
		return page;
	}
	
	private int getCountGestoresByDespacho(UsuarioDto usuarioDto){
		StringBuilder sqlUsuarios = new StringBuilder();
		sqlUsuarios.append("select count(gd.id) from GestorDespacho gd ");
		sqlUsuarios.append("where gd.despachoExterno.id = :idTipoDespacho ");
		sqlUsuarios.append(" and gd.auditoria.borrado = false ");
		if (StringUtils.hasText(usuarioDto.getQuery())){
			String[] palabras = usuarioDto.getQuery().split(" ");
			for (String palabra : palabras) {
				sqlUsuarios.append(" and (upper(gd.usuario.apellido1) like '%" + palabra.toUpperCase() + "%' ");
				sqlUsuarios.append(" or upper(gd.usuario.apellido2) like '%" + palabra.toUpperCase() + "%' ");
				sqlUsuarios.append(" or upper(gd.usuario.nombre) like '%" + palabra.toUpperCase() + "%' ) ");
			}
		}
		
		Query query = getSession().createQuery(sqlUsuarios.toString());
		query.setParameter("idTipoDespacho", usuarioDto.getIdTipoDespacho());
		int totalCount = Integer.parseInt(query.uniqueResult().toString());
		return totalCount;
	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.coreextension.dao.EXTGestoresDao#getGestoresByDespacho(es.pfsgroup.plugin.recovery.coreextension.api.UsuarioDto)
	 */
	public Page getGestoresByDespachoDefecto(UsuarioDto usuarioDto) {

		PageSql page = new PageSql();
		int totalCount = this.getCountGestoresByDespacho(usuarioDto);
		
		StringBuilder sqlUsuarios = new StringBuilder();
		sqlUsuarios.append("select gd from GestorDespacho gd ");
		sqlUsuarios.append("where gd.despachoExterno.id = :idTipoDespacho ");
		sqlUsuarios.append(" and gd.auditoria.borrado = false ");
		if (StringUtils.hasText(usuarioDto.getQuery())){
			String[] palabras = usuarioDto.getQuery().split(" ");
			for (String palabra : palabras) {
				sqlUsuarios.append(" and (upper(gd.usuario.apellido1) like '%" + palabra.toUpperCase() + "%' ");
				sqlUsuarios.append(" or upper(gd.usuario.apellido2) like '%" + palabra.toUpperCase() + "%' ");
				sqlUsuarios.append(" or upper(gd.usuario.nombre) like '%" + palabra.toUpperCase() + "%' ) ");
			}
		}
		sqlUsuarios.append("order by ");
		sqlUsuarios.append("gd.gestorPorDefecto desc, ");
		sqlUsuarios.append("gd.usuario.apellido1 asc, gd.usuario.apellido2 asc, gd.usuario.nombre asc ");
		
		Query query = getSession().createQuery(sqlUsuarios.toString());
		query.setParameter("idTipoDespacho", usuarioDto.getIdTipoDespacho());
		query.setFirstResult(usuarioDto.getStart());
		query.setMaxResults(usuarioDto.getLimit());
		List<Usuario> lista = query.list();
		
		page.setTotalCount(totalCount);
		page.setResults(lista);
		return page;
	}

}
