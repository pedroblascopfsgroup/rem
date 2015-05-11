package es.pfsgroup.plugin.recovery.config.perfiles.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.FuncionPerfil;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.config.perfiles.dao.ADMFuncionPerfilDao;

@Repository("ADMFuncionPerfilDao")
public class ADMFuncionPerfilDaoImpl extends AbstractEntityDao<FuncionPerfil, Long> implements ADMFuncionPerfilDao{

	@Override
	public FuncionPerfil createNewObject() {
		return new FuncionPerfil();
	}

	@Override
	public List<FuncionPerfil> find(Long idFuncion, Long idPerfil) {
		Assertions.assertNotNull(idFuncion, "idFuncion no puede ser null");
		Assertions.assertNotNull(idPerfil, "idPerfil no puede ser null");
		HQLBuilder b = new HQLBuilder("from FuncionPerfil");
		b.appendWhere(Auditoria.UNDELETED_RESTICTION);
		HQLBuilder.addFiltroIgualQue(b, "funcion.id", idFuncion);
		HQLBuilder.addFiltroIgualQue(b, "perfil.id", idPerfil);
		return HibernateQueryUtils.list(this, b);
		
	}

}
