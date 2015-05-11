package es.capgemini.pfs.multigestor.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.multigestor.dao.EXTGestorAdicionalAsuntoDao;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;

@Repository("EXTGestorAdicionalAsunto")
public class EXTGestorAdicionalAsuntoDaoImpl extends
		AbstractEntityDao<EXTGestorAdicionalAsunto, Long> implements
		EXTGestorAdicionalAsuntoDao {

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public List<Usuario> findGestoresByAsunto(Long idAsunto, String tipoGestor) {
		List<Usuario> listUsuario = new ArrayList<Usuario>();

		HQLBuilder hb = new HQLBuilder("from EXTGestorAdicionalAsunto p");
		hb.appendWhere("p.auditoria.borrado=false");
		if (!Checks.esNulo(idAsunto)) {
			hb.appendWhere("asunto.id=" + idAsunto);
		}
		if (!Checks.esNulo(tipoGestor)) {
			hb.appendWhere("tipoGestor.codigo='" + tipoGestor + "'");
		}
		List<EXTGestorAdicionalAsunto> listGestorAdicionalAsuntos = HibernateQueryUtils
				.list(this, hb);
		for (EXTGestorAdicionalAsunto gestorAA : listGestorAdicionalAsuntos) {
			listUsuario.add(gestorAA.getGestor().getUsuario());
		}
		return listUsuario;
	}

}
