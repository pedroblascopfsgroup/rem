package es.pfsgroup.recovery.recobroCommon.ranking.model;

import java.util.Comparator;

public class RecobroRankingSubcarteraDetalleComparator implements Comparator<RecobroRankingSubcarteraDetalle> {

	/**
	 * Ordena los RecobroRankingSubcarteraDetalle de forma descendente por el valor Resultado
	 */
	@Override
	public int compare(RecobroRankingSubcarteraDetalle o1,	RecobroRankingSubcarteraDetalle o2) {
		if (o1.getResultado()>o2.getResultado())
			return -1;
		if (o1.getResultado()<o2.getResultado())
			return 1;
		return 0;
	}
	
}
