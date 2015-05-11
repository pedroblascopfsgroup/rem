package es.pfsgroup.recovery.recobroCommon.esquema.dao.api;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroCarteraEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;

public interface RecobroCarteraEsquemaDao extends AbstractDao<RecobroCarteraEsquema, Long> {

		/**
		 * Reorganiza todas las prioridades a partir de la prioridad indicada 
		 * sumandole uno al resto de prioridades excepto la pasada por el id de la cartera del esquema
		 * 
		 * @param idEsquema	   = Esquema que se actualizará
		 * @param id   		   = id de la cartera del esquema que no se actualizará
		 * @param prioridad    = Prioridad nueva
		 * @param prioridadAnt = prioridad anterior
		 */
		public void reorganizaPrioridades(Long idEsquema, Long id, int prioridad, int prioridadAnt);
		
		/**
		 * Obtiene la última prioridad de las carteras del esquema
		 * @param idEsquema
		 * @return
		 */
		public Integer getMaxPrioridad(Long idEsquema);

		
		public RecobroCarteraEsquema getCarteraEsquemaPorNombreYEsquema(
				RecobroEsquema esquema, RecobroCarteraEsquema carteraEsquema);	
		
		/**
		 * Obtiene la cartera esquema de un idEsquema y un idCartera
		 * @param idEsquema
		 * @param idCartera
		 * @return
		 */
		public RecobroCarteraEsquema getCarteraEsquema(Long idEsquema, Long idCartera);

}
