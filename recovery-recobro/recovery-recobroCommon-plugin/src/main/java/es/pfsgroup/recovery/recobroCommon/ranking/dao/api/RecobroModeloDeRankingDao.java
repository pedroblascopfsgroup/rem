package es.pfsgroup.recovery.recobroCommon.ranking.dao.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.ranking.dto.RecobroModeloDeRankingDto;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroModeloDeRanking;

public interface RecobroModeloDeRankingDao extends AbstractDao<RecobroModeloDeRanking, Long>{

	Page buscarModelosRanking(RecobroModeloDeRankingDto dto);

	/**
	 * Metodo que devuelve los modelos en estado Disponible o bloqueado
	 * @author Sergio
	 */
	List<RecobroModeloDeRanking> getModelosDSPoBLQ();

}
