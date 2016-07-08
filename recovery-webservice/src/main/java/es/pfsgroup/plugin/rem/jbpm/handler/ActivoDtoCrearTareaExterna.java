package es.pfsgroup.plugin.rem.jbpm.handler;

import java.util.HashMap;

import es.capgemini.pfs.core.api.procesosJudiciales.dto.EXTDtoCrearTareaExterna;
import es.capgemini.pfs.tareaNotificacion.VencimientoUtils.TipoCalculo;

public class ActivoDtoCrearTareaExterna implements EXTDtoCrearTareaExterna {
			
	private HashMap<String, Object> valores;

	public ActivoDtoCrearTareaExterna(HashMap<String, Object> valores) {
		if (valores != null)
			this.valores = valores;
	}

	@Override
	public String getCodigoSubtipoTarea() {
		return (String)valores.get("codigoSubtipoTarea");
	}

	@Override
	public Long getPlazo() {
		return (Long)valores.get("plazo");
	}

	@Override
	public String getDescripcion() {
		return (String)valores.get("descripcion");
	}

	@Override
	public Long getIdProcedimiento() {
		return (Long)valores.get("idProcedimiento");
	}

	@Override
	public Long getIdTareaProcedimiento() {
		return (Long)valores.get("idTareaProcedimiento");
	}

	@Override
	public Long getTokenIdBpm() {
		return (Long)valores.get("tokenIdBpm");
	}

	@Override
	public TipoCalculo getTipoCalculo() {
		return (TipoCalculo)valores.get("tipoCalculo");
	}

}
