package es.pfsgroup.recovery.cajamar.integration;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;
import es.pfsgroup.recovery.integration.bpm.TransformerHelper;
import es.pfsgroup.recovery.integration.bpm.payload.ProcedimientoPayload;

/**
 * Ayuda a transformar los mensajes de salida.
 * @author gonzalo
 *
 */
public class BPMTransformHelper implements TransformerHelper {

	private static final String CODIGO_TIPO_PROCEDIMIENTO = "HCJ002";
	
	@Autowired
	private GenericABMDao genericDao;

    @Autowired
    private TareaExternaManager tareaExternaManager;
	
    private String tareaParaEnviar;
			
	public String getTareaParaEnviar() {
		return tareaParaEnviar;
	}

	public void setTareaParaEnviar(String tareaParaEnviar) {
		this.tareaParaEnviar = tareaParaEnviar;
	}

	@Override
	public void ampliar(DataContainerPayload dataPayload) {
		
		// Comprueba que es un mensaje que debe realizar.
		if (!dataPayload.getTipo().equals(IntegracionBpmService.TIPO_FIN_BPM)) {
			return;
		}

		ProcedimientoPayload proc = new ProcedimientoPayload(dataPayload);
		
		// No es el procedimiento que buscamos.
		if (proc.getTipoProcedimiento()==null || !proc.getTipoProcedimiento().equals(CODIGO_TIPO_PROCEDIMIENTO)) {
			return;
		}
		
		// Recuperamos las tareas con los códigos indicados para enviar.
		Long idProcedimiento = proc.getIdOrigen();
        List<TareaExterna> tareas = tareaExternaManager.obtenerTareasPorProcedimiento(idProcedimiento);
        if (tareas != null && !Checks.esNulo(tareaParaEnviar)) {
            for (TareaExterna tarea : tareas) {
                String codigo = tarea.getTareaProcedimiento().getCodigo();
                if (tareaParaEnviar.equals(codigo)) {
                	loadValores(dataPayload, tarea);
                    //List<TareaExternaValor> vValores = tareaExternaManager.obtenerValoresTarea(tarea.getId());
                    break;
                }
            }
        }
        
	}

	protected void loadValores(DataContainerPayload payload, TareaExterna tareaExterna) {
		for (TareaExternaValor valor : tareaExterna.getValores()) {
			String key = String.format("%s.%s", ProcedimientoPayload.EXTRA_FIELD, valor.getNombre());
			String valorStr = valor.getValor();
			payload.addExtraInfo(key, valorStr);
		}
	}
	
}
