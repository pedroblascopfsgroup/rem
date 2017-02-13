package es.pfsgroup.plugin.rem.gestor.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GestorExpedienteComercial;

public interface GestorExpedienteComercialDao  extends AbstractDao<GestorExpedienteComercial, Long> {

	public Usuario getUsuarioGestorBycodigoTipoYExpedienteComercial(String codigoTipoGestor, ExpedienteComercial expediente);
}
