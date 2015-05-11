package es.capgemini.pfs.registro;

import java.util.List;


public interface HistoricoProcedimientoBuilder {
	
	/**
	 * Devuelve elementos del histórico para un determinado procedimiento.
	 * @param idProcedimiento
	 * @return
	 */
	List<HistoricoProcedimientoDto> getHistorico(long idProcedimiento);

}
