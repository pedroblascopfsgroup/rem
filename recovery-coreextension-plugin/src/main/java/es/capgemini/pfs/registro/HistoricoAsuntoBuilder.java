package es.capgemini.pfs.registro;

import java.util.List;

public interface HistoricoAsuntoBuilder {

	public final static String SUBTIPO_TAREA = "subtipoTarea";
	public final static String TIPO_REGISTRO = "tipoRegistro";
	/**
	 * Devuelve elementos del histórico para un determinado asunto.
	 * @param idProcedimiento
	 * @return
	 */
	List<HistoricoAsuntoDto> getHistorico(long idAsunto);
	
}
