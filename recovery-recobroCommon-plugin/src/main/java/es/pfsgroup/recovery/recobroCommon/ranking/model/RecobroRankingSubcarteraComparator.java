package es.pfsgroup.recovery.recobroCommon.ranking.model;

import java.util.Comparator;

public class RecobroRankingSubcarteraComparator implements Comparator<RecobroRankingSubcartera> {

	/**
	 * Ordena de forma descendente los RecobroRankingSubcartera por el valor Porcentaje
	 */
	@Override
	public int compare(RecobroRankingSubcartera o1, RecobroRankingSubcartera o2) {
		if (o1.getPorcentaje()>o2.getPorcentaje())
			return -1;
		if (o1.getPorcentaje()<o2.getPorcentaje())
			return 1;
		return 0;
	}

}
