package es.pfsgroup.plugin.recovery.masivo.dao;

import java.util.List;

import es.capgemini.pfs.procesosJudiciales.model.EXTTareaExterna;

public interface MSVProcesoImpulsoDao {

	String getPropietario(Long idContrato);
	
	List<EXTTareaExterna> obtenerListaTareasExternasAImpulsar(Long idTipoProcedimiento,
			Long idTareaProcedimiento, Long idDespacho);
	
	String getInputPorDefecto(String descTarea);
}
