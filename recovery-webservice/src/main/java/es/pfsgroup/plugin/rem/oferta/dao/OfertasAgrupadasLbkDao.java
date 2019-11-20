package es.pfsgroup.plugin.rem.oferta.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.OfertasAgrupadasLbk;


public interface OfertasAgrupadasLbkDao extends AbstractDao<OfertasAgrupadasLbk, Long>{	

	Long getIdOfertaAgrupadaLBK(Long idOferta);

	boolean suprimeOfertaDependiente(Long idOferta);

	void actualizaPrincipalId(Long nuevoPrincipalId, Long dependienteId);

}
