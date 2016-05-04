package es.pfsgroup.plugin.recovery.config.usuarios.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.Conversiones;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.config.usuarios.dao.ADMUsuarioDao;
import es.pfsgroup.plugin.recovery.config.usuarios.dto.ADMDtoBusquedaUsuario;

@Repository("ADMUsuarioDao")
public class ADMUsuarioDaoImpl extends AbstractEntityDao<Usuario, Long>
		implements ADMUsuarioDao {

	public Page findUsuarios(ADMDtoBusquedaUsuario dtoBusquedaUsuario) {
		
		Assertions.assertNotNull(dtoBusquedaUsuario, "dtoBusquedaUsuario: No puede ser NULL");
		if (Checks.esNulo(dtoBusquedaUsuario.getIdEntidad())){
			throw new BusinessOperationException("plugin.config.perfiles.admusuariodaoimpl.findusuarios.entidadesconocida");
		}
		
		if (!Checks.esNulo(dtoBusquedaUsuario.getSort())){
			dtoBusquedaUsuario.setSort("u.".concat(dtoBusquedaUsuario.getSort()));
		}
		
		HQLBuilder hb = new HQLBuilder("select distinct u from Usuario u left join u.zonaPerfil z");
		hb.appendWhere("u.auditoria.borrado = 0");
		
		HQLBuilder.addFiltroIgualQue(hb, "u.entidad.id", dtoBusquedaUsuario.getIdEntidad());
		

		HQLBuilder.addFiltroLikeSiNotNull(hb, "u.username", dtoBusquedaUsuario.getUsername(),true);
		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "u.nombre", dtoBusquedaUsuario.getNombre(),true);
		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "u.apellido1", dtoBusquedaUsuario.getApellido1(),true);
		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "u.apellido2", dtoBusquedaUsuario.getApellido2(),true);
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "u.usuarioExterno", dtoBusquedaUsuario.getUsuarioExterno());
		
		if (!Checks.esNulo(dtoBusquedaUsuario.getDespachosExternos())){
			//if ((dtoBusquedaUsuario.getUsuarioExterno() != null) && (dtoBusquedaUsuario.getUsuarioExterno()) ) {
				hb.appendWhere("u in (select gd.usuario from GestorDespacho gd where gd.despachoExterno.id in (" + dtoBusquedaUsuario.getDespachosExternos() + "))");
			//}
		}
		

		HQLBuilder.addFiltroWhereInSiNotNull(hb, "z.perfil",Conversiones.createLongCollection(dtoBusquedaUsuario.getPerfiles(), ",") );
		
		HQLBuilder.addFiltroWhereInSiNotNull(hb, "z.zona", Conversiones.createLongCollection(dtoBusquedaUsuario.getCentros(), ","));

		return HibernateQueryUtils.page(this, hb, dtoBusquedaUsuario);
	}

	@Override
	public List<DespachoExterno> findDespachoSupervisor(Long idUsuario, Long idEntidad) {
		Assertions.assertNotNull(idUsuario, "idUsuario: no puede ser NULL");
		Assertions.assertNotNull(idEntidad, "idEntidad: no puede ser NULL");
		HQLBuilder hb = new HQLBuilder("select distinct de from GestorDespacho gd left join gd.despachoExterno de");
		
		hb.appendWhere("gd.auditoria.borrado = 0");
		hb.appendWhere("gd.supervisor = true");
		
		HQLBuilder.addFiltroIgualQue(hb, "gd.usuario.id", idUsuario);	
		HQLBuilder.addFiltroIgualQue(hb, "gd.usuario.entidad.id", idEntidad);
		
		return getHibernateTemplate().findByNamedParam(
				hb.toString(), hb.getParamNames(), hb.getParamValues());
				
	}

	@Override
	public List<Usuario> getUsuariosNoExternos(Long idEntidad) {
		Assertions.assertNotNull(idEntidad, "idEntidad: no puede ser NULL");
		HQLBuilder hb = new HQLBuilder("select u from Usuario u");
		hb.appendWhere("u.auditoria.borrado=false");
		HQLBuilder.addFiltroIgualQue(hb, "u.entidad.id", idEntidad);
		HQLBuilder.addFiltroIgualQue(hb, "u.usuarioExterno", Boolean.FALSE);
		List <Usuario> l = getHibernateTemplate().findByNamedParam(
				hb.toString(), hb.getParamNames(), hb.getParamValues());
		return l;
		
	}

	@Override
	public List<Usuario> getUsuariosExternos(Long idEntidad) {
		Assertions.assertNotNull(idEntidad, "idEntidad: no puede ser NULL");
		HQLBuilder hb = new HQLBuilder("select u from Usuario u");
		hb.appendWhere("u.auditoria.borrado=false");
		HQLBuilder.addFiltroIgualQue(hb, "u.entidad.id", idEntidad);
		HQLBuilder.addFiltroIgualQue(hb, "u.usuarioExterno", Boolean.TRUE);
		List <Usuario> l = getHibernateTemplate().findByNamedParam(
				hb.toString(), hb.getParamNames(), hb.getParamValues());
		return l;
	}

	@Override
	public Usuario createNewUsuario() {
		return new Usuario();
	}

	@Override
	public List<Usuario> getListByEntidad(Long idEntidad) {
		Assertions.assertNotNull(idEntidad, "idEntidad: no puede ser NULL");
		HQLBuilder hb = new HQLBuilder("select u from Usuario u");
		hb.appendWhere("u.auditoria.borrado=false");
		HQLBuilder.addFiltroIgualQue(hb, "u.entidad.id", idEntidad);
		return HibernateQueryUtils.list(this, hb);
	}

	@Override
	public Usuario getByEntidad(Long idUsuario, Long idEntidad) {
		Assertions.assertNotNull(idUsuario, "idUsuario: no puede ser NULL");
		Assertions.assertNotNull(idEntidad, "idEntidad: no puede ser NULL");
		HQLBuilder hb = new HQLBuilder("from Usuario u");
		hb.appendWhere(Auditoria.UNDELETED_RESTICTION);
		HQLBuilder.addFiltroIgualQue(hb, "u.id", idUsuario);
		HQLBuilder.addFiltroIgualQue(hb, "u.entidad.id", idEntidad);
		return HibernateQueryUtils.uniqueResult(this, hb);
	}

	@Override
	public Usuario findByUsername(String username) {
		HQLBuilder hb = new HQLBuilder("from Usuario u");
		hb.appendWhere(Auditoria.UNDELETED_RESTICTION);
		
		HQLBuilder.addFiltroIgualQue(hb, "u.username", username);
		return HibernateQueryUtils.uniqueResult(this, hb);
	}

}
