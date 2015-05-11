package es.pfsgroup.plugin.recovery.config.despachoExterno.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
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

		HQLBuilder.addFiltroLikeSiNotNull(hb, "gd.usuario.username", dto
				.getUsername(), true);

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

	@Override
	public DespachoExterno buscarPorGestor(Long idUsuario) {
		HQLBuilder b = new HQLBuilder(
				"select d from GestorDespacho gd join gd.despachoExterno d");

		b.appendWhere("gd.auditoria.borrado = 0");

		b.appendWhere("gd.supervisor = false");

		b.appendWhere("gd.usuario.usuarioExterno = true");

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

}
