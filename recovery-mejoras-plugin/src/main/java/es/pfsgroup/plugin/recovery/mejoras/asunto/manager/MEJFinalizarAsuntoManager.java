package es.pfsgroup.plugin.recovery.mejoras.asunto.manager;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Asunto;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto.MEJFinalizarAsuntoDto;
import es.pfsgroup.recovery.ext.api.asunto.EXTAsuntoApi;

@Component
public class MEJFinalizarAsuntoManager {

    public static final String MEJ_FINALIZAR_ASUNTO = "plugin.mejoras.finalizarAsunto";
    public static final String MEJ_CANCELAR_ASUNTO = "plugin.mejoras.cancelaAsunto";
    public static final String MEJ_PARALIZAR_ASUNTO = "plugin.mejoras.paralizaAsunto";
    	
	@Autowired
	private EXTAsuntoApi extAsuntoApi;

	@BusinessOperation(MEJ_FINALIZAR_ASUNTO)
	public void finalizarAsunto(MEJFinalizarAsuntoDto dto) {
		extAsuntoApi.finalizarAsunto(dto);
	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.mejoras.asunto.api.MEJFinalizarAsuntoApi#cancelaAsunto(es.capgemini.pfs.asunto.model.Asunto, java.util.Date)
	 */
	@BusinessOperation(MEJ_CANCELAR_ASUNTO)
	public void cancelaAsunto(Asunto asunto, Date fechaCancelacion) {
		extAsuntoApi.cancelaAsunto(asunto,fechaCancelacion);
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.mejoras.asunto.api.MEJFinalizarAsuntoApi#paralizaAsunto(es.capgemini.pfs.asunto.model.Asunto, java.util.Date)
	 */
	@BusinessOperation(MEJ_PARALIZAR_ASUNTO)
	public void paralizaAsunto(Asunto asunto, Date fechaParalizacion) {
		extAsuntoApi.paralizaAsunto(asunto,fechaParalizacion);
	}	
	
}
