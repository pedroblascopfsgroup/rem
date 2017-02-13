package es.pfsgroup.plugin.rem.gestor.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.plugin.rem.gestor.dao.GestorExpedienteComercialDao;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GestorExpedienteComercial;

@Repository("GestorExpedienteComercialDao")
public class GestorExpedienteComercialDaoImpl extends AbstractEntityDao<GestorExpedienteComercial, Long> implements GestorExpedienteComercialDao {

	@SuppressWarnings("unchecked")
	@Override
	public Usuario getUsuarioGestorBycodigoTipoYExpedienteComercial(String codigoTipoGestor, ExpedienteComercial expediente) {
		
		HQLBuilder hb = new HQLBuilder("select distinct(gec.usuario) from GestorExpedienteComercial gec");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gec.auditoria.borrado", false);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb,  "gec.expedienteComercial.id", expediente.getId());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gec.tipoGestor.codigo", codigoTipoGestor);
		
		Query query = getSession().createQuery(hb.toString());
		HQLBuilder.parametrizaQuery(query, hb);
		List<Usuario> listado = query.list();
		
		if(!Checks.estaVacio(listado))
			return listado.get(0);
		else
			return null;
	}
}
