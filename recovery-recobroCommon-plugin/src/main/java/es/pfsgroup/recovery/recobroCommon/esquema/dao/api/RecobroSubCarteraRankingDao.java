package es.pfsgroup.recovery.recobroCommon.esquema.dao.api;

import java.util.Date;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubcarteraAgencia;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubcarteraRanking;

/**
 * Interfaz de acceso a base de datos para la clase RecobroSubCarteraRanking
 * @author Carlos
 *
 */
public interface RecobroSubCarteraRankingDao extends AbstractDao<RecobroSubcarteraRanking, Long>{
	
	
	/**
	 * A partir de una subcartera y una subcareteraRanking, devuelve la subcarteraRanking de esa subcartera
	 * recibida que tiene la misma posicion en el ranking
	 */
	RecobroSubcarteraRanking getSubcarteraRankingPorPosicionYSubCartera(RecobroSubCartera subCartera,
			RecobroSubcarteraRanking subcarteraAgenciaRanking);
	
	/**
	 * Devuelve el porcentaje de una subcartera dada su posicion
	 * @param subCartera
	 * @param posicion
	 * @return
	 */
	public Integer getPorcentaje(RecobroSubCartera subCartera, Integer posicion);

}
