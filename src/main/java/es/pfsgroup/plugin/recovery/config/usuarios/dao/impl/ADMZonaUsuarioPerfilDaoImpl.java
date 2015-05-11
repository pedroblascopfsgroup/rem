package es.pfsgroup.plugin.recovery.config.usuarios.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.config.usuarios.dao.ADMZonaUsuarioPerfilDao;

@Repository("ADMZonaUsuarioPerfilDao")

public class ADMZonaUsuarioPerfilDaoImpl extends AbstractEntityDao<ZonaUsuarioPerfil, Long> implements ADMZonaUsuarioPerfilDao{

	@Override
	public void borrar(Long zonid, Long pefid, Long usuid) {
		if (Checks.esNulo(zonid)) throw new IllegalArgumentException("zonid es NULL");
		if (Checks.esNulo(pefid)) throw new IllegalArgumentException("pefid es NULL");
		if (Checks.esNulo(usuid)) throw new IllegalArgumentException("usuid es NULL");
		HQLBuilder b = new HQLBuilder("from ZonaUsuarioPerfil zup");
		b.appendWhere("zup.zona=" + zonid);
		b.appendWhere("zup.usuario=" + usuid);
		b.appendWhere("zup.perfil=" + pefid);
		//HQLBuilder.addFiltroIgualQueSiNotNull(b, "zup.zona.id", zonid);
		//HQLBuilder.addFiltroIgualQueSiNotNull(b, "zup.perfil.id", pefid);
		//HQLBuilder.addFiltroIgualQueSiNotNull(b, "zup.usuario.id", usuid);
		List l = getHibernateTemplate().findByNamedParam(b.toString(), b.getParamNames(), b.getParamValues());
		delete(l.get(0));
	}

	@Override
	public ZonaUsuarioPerfil buscaZonPefUsu(Long z, Long idUsuario,
			Long idPerfil) {
		HQLBuilder b = new HQLBuilder("from ZonaUsuarioPerfil zup");
		b.appendWhere("zup.auditoria.borrado = false");
		HQLBuilder.addFiltroIgualQue(b, "zup.zona.id", z);
		HQLBuilder.addFiltroIgualQue(b, "zup.perfil.id", idPerfil);
		HQLBuilder.addFiltroIgualQue(b, "zup.usuario.id", idUsuario);
		
		return HibernateQueryUtils.uniqueResult(this, b);
	}
	
	

}
