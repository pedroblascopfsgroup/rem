package es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.dao.DespachoExtrasAmbitoDao;
import es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.model.DespachoExtrasAmbito;

@Repository("DespachoExtrasAmbitoDao")
public class DespachoExtrasAmbitoDaoImpl extends AbstractEntityDao<DespachoExtrasAmbito, Long> implements DespachoExtrasAmbitoDao {

	public DespachoExtrasAmbito getDespachoExtrasAmbitoByCodigoPrv(String codProvincia, Long idDespacho) {
		
		Assertions.assertNotNull(idDespacho, "idDespacho: No puede ser NULL");
		Assertions.assertNotNull(codProvincia, "codigoProvincia: No puede ser NULL");
		
		HQLBuilder b = new HQLBuilder("from DespachoExtrasAmbito d");
		b.appendWhere("d.auditoria." + Auditoria.UNDELETED_RESTICTION);
		HQLBuilder.addFiltroIgualQue(b, "d.despacho.id", idDespacho);
		HQLBuilder.addFiltroIgualQue(b, "d.provincia.codigo", codProvincia);
		return HibernateQueryUtils.uniqueResult(this, b);
	}
	
	public boolean isDespachoEnProvincia(String codProvincia, Long idDespacho) {
		
		if(Checks.esNulo(getDespachoExtrasAmbitoByCodigoPrv(codProvincia,idDespacho))) {
			return false;
		}
		else {
			return true;
		}
	}
}
