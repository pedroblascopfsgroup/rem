package es.pfsgroup.plugin.recovery.config.despachoExterno.dao.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.users.dao.UsuarioDao;
import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMDespachoExternoDao;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dto.ADMDtoBusquedaDespachoExterno;

@Repository("ADMDespachoExternoDao")
public class ADMDespachoExternoDaoImpl extends
		AbstractEntityDao<DespachoExterno, Long> implements
		ADMDespachoExternoDao {

	@Autowired
	UsuarioDao usuarioDao;
	
	@Override
	@SuppressWarnings("unchecked")
	public List<GestorDespacho> buscarSupervisoresDespacho(Long idDespacho) {
		String hql = "from GestorDespacho gd where gd.despachoExterno.id = ? and gd.supervisor=true and gd.auditoria.borrado=false and gd.usuario.auditoria.borrado=false";
		return getHibernateTemplate().find(hql, new Object[] { idDespacho });
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GestorDespacho> buscarGestoresDespacho(Long idDespacho) {
		String hql = "from GestorDespacho gd where gd.despachoExterno.id = ? and gd.supervisor=false and gd.auditoria.borrado=false and gd.usuario.auditoria.borrado=false";
		return getHibernateTemplate().find(hql, new Object[] { idDespacho });
	}

	@Override
	public Page findDespachosExternos(ADMDtoBusquedaDespachoExterno dto) {

		HQLBuilder hb;
		if (soloDatosDespacho(dto)) {
			hb = new HQLBuilder("from DespachoExterno desp");
		} else {
			hb = new HQLBuilder(
					"select distinct desp from GestorDespacho gd join gd.despachoExterno desp");
			hb.appendWhere("gd.usuario.auditoria.borrado=false");
			hb.appendWhere("gd.auditoria.borrado=false");
		}

		hb.appendWhere("desp.auditoria.borrado = 0");

		HQLBuilder.addFiltroLikeSiNotNull(hb, "desp.despacho", dto
				.getDespacho(), true);

		HQLBuilder.addFiltroLikeSiNotNull(hb, "desp.codigoPostal", dto
				.getCodigoPostal(), true);

		HQLBuilder.addFiltroLikeSiNotNull(hb, "desp.domicilioPlaza", dto
				.getDomicilioPlaza(), true);

		HQLBuilder.addFiltroLikeSiNotNull(hb, "desp.personaContacto", dto
				.getPersonaContacto(), true);

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "desp.tipoDespacho.id", dto
				.getTipoDespacho());

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gd.usuario.username", dto
				.getUsername());

		HQLBuilder.addFiltroLikeSiNotNull(hb, "gd.usuario.nombre", dto
				.getNombre(), true);

		HQLBuilder.addFiltroLikeSiNotNull(hb, "gd.usuario.apellido1", dto
				.getApellido1(), true);

		HQLBuilder.addFiltroLikeSiNotNull(hb, "gd.usuario.apellido2", dto
				.getApellido2(), true);

		if (dto.getSupervisor() != null) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gd.supervisor",
					Boolean.TRUE);
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gd.usuario.id", dto
					.getSupervisor());
		}

//		return paginationManager.getHibernatePage(getHibernateTemplate(), hb
//				.toString(), dto, hb.getParameters());
		
		return HibernateQueryUtils.page(this, hb, dto);
		
//		PageHibernate page = new PageHibernate("from DespachoExterno desp", dto);
//		getHibernateTemplate().execute(page);
//		return page;
	}
	

	private boolean soloDatosDespacho(ADMDtoBusquedaDespachoExterno dto) {
		return Checks.esNulo(dto.getUsername())
				&& Checks.esNulo(dto.getNombre())
				&& Checks.esNulo(dto.getApellido1())
				&& Checks.esNulo(dto.getApellido2())
				&& Checks.esNulo(dto.getSupervisor());
	}

	@SuppressWarnings("rawtypes")
	@Override
	public DespachoExterno buscarPorGestor(Long idUsuario) {
		HQLBuilder b = new HQLBuilder(
				"select d from GestorDespacho gd join gd.despachoExterno d");

		b.appendWhere("gd.auditoria.borrado = 0");

		b.appendWhere("gd.supervisor = false");

		//b.appendWhere("gd.usuario.usuarioExterno = true");
		tieneFuncionDependenciaUsuExterno(idUsuario,b);

		HQLBuilder.addFiltroIgualQue(b, "gd.usuario.id", idUsuario);

		List l = getHibernateTemplate().findByNamedParam(b.toString(),
				b.getParamNames(), b.getParamValues());

		if (l.isEmpty()) {
			return null;
		}

		return (DespachoExterno) l.get(0);
	}

	@Override
	public DespachoExterno createNewDespachoExterno() {
		return new DespachoExterno();
	}

	public void setPaginationManager(PaginationManager bean) {

	}

	@Override
	public List<DespachoExterno> getByTipo(Long idTipo) {
		Assertions.assertNotNull(idTipo, "idTipo: No puede ser NULL");
		HQLBuilder b = new HQLBuilder("from DespachoExterno d");
		b.appendWhere(Auditoria.UNDELETED_RESTICTION);
		HQLBuilder.addFiltroIgualQue(b, "d.tipoDespacho.id", idTipo);
		
		return HibernateQueryUtils.list(this, b);
	}

	/**
	 * Si el usuario logado no tiene el ROL, se requiere usuarioExterno=true para mostrar los despachos.
	 * Si se tiene el ROL, entonces da igual que el campo usuarioExterno sea true o falso, por tanto no se incluye
	 * en la consulta HQL.
	 * @param idUsuario
	 * @param b
	 */
	private void tieneFuncionDependenciaUsuExterno(Long idUsuario, HQLBuilder b) {
        Usuario usuario = usuarioDao.get(idUsuario);
		List<Perfil> perfiles = usuario.getPerfiles();
		Boolean enc = false;
		for (Perfil per : perfiles) {
		    for (Funcion fun : per.getFunciones()) {
		        if ("ROLE_DESACTIVAR_DEPENDENCIA_USU_EXTERNO".equals(fun.getDescripcion())) {  
		            enc = true;
		        }
		    }
		}
		if(!enc){
			b.appendWhere("gd.usuario.usuarioExterno = true");
		}
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<DespachoExterno> getListByNombre(String filtro) {
		
		filtro = filtro.toUpperCase();
		String hql = " from DespachoExterno des where des.auditoria.borrado = 0 and upper(des.despacho) like upper('%"+filtro+"%')";
		
		return getHibernateTemplate().find(hql);
	}
}
