package es.pfsgroup.plugin.recovery.config.perfiles.dao.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.Conversiones;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.config.perfiles.dao.ADMPerfilDao;
import es.pfsgroup.plugin.recovery.config.perfiles.dto.ADMDtoBuscaPerfil;
import es.pfsgroup.recovery.ext.impl.perfil.model.EXTPerfil;

@Repository("ADMPerfilDao")
public class ADMPerfilDaoImpl extends AbstractEntityDao<EXTPerfil, Long> implements
		ADMPerfilDao {

	@Autowired
	private PaginationManager paginationManager;

	@Override
	public Page findPerfiles(ADMDtoBuscaPerfil dto) {

		if (Checks.esNulo(dto)) {
			throw new IllegalArgumentException("dto no puede ser null");
		}
		HQLBuilder hb = new HQLBuilder(
				"select distinct p from Perfil p left join p.funcionesPerfil f");

		hb.appendWhere("p.auditoria.borrado = 0");

		HQLBuilder.addFiltroLikeSiNotNull(hb, "p.id", dto.getId());

		HQLBuilder.addFiltroLikeSiNotNull(hb, "p.descripcion", dto
				.getDescripcion(),true);

		HQLBuilder.addFiltroLikeSiNotNull(hb, "p.descripcionLarga", dto
				.getDescripcionLarga(),true);

		HQLBuilder.addFiltroWhereInSiNotNull(hb, "f.funcion.id", Conversiones
				.createLongCollection(dto.getFunciones(), ","));

		return paginationManager.getHibernatePage(getHibernateTemplate(), hb
				.toString(), dto, hb.getParameters());
	}

	@Override
	public EXTPerfil createNew() {
		return new EXTPerfil();
	}

	public void setPaginationManager(PaginationManager o) {
		this.paginationManager = o;

	}

	@Override
	public Long getLastCodigo() {
		HQLBuilder b = new HQLBuilder("select max(id) from Perfil");
		Long id = (Long) getSession().createQuery(b.toString()).uniqueResult();
		return id != null ? id : 0L;
	}

	@Override
	public Long save(EXTPerfil t) {
		Assertions.assertNotNull(t.getCodigo(), "El codigo no puede ser NULL");
		String c = t.getCodigo();
		if (c.equals(c.replaceAll("[^0-9]", ""))) {
			return super.save(t);
		} else {
			throw new BusinessOperationException("plugin.config.perfiles.admperfildaoimpl.save.codigononumerico");
		}
	}

	@Override
	public void saveOrUpdate(EXTPerfil t) {
		Assertions.assertNotNull(t.getCodigo(), "El codigo no puede ser NULL");
		String c = t.getCodigo();
		if (c.equals(c.replaceAll("[^0-9]", ""))) {
			super.saveOrUpdate(t);
		} else {
			throw new BusinessOperationException("plugin.config.perfiles.admperfildaoimpl.save.codigononumerico");
		}
	}

	@Override
	public List<EXTPerfil> getListUndeleted() {
		HQLBuilder hb = new HQLBuilder("from Perfil ");
		HQLBuilder.addFiltroIgualQue(hb, "borrado", 0);
		
		return HibernateQueryUtils.list(this, hb);
	}
	
	

}
