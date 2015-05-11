package es.pfsgroup.recovery.ext.impl.tareas;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.tareaNotificacion.VencimientoUtils.TipoCalculo;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.pfsgroup.recovery.ext.api.tareas.EXTDtoGenerarTareaIdividualizada;

public class EXTDtoGenerarTareaIdividualizadaImpl extends WebDto implements
		EXTDtoGenerarTareaIdividualizada {


	private static final long serialVersionUID = 2841349960094447467L;

	private Long destinatario;
	private DtoGenerarTarea tarea;
	private TipoCalculo tipoCalculo;
	
	@Override
	public Long getDestinatario() {
		return destinatario;
	}
	
	@Override
	public DtoGenerarTarea getTarea() {
		return tarea;
	}
	@Override
	public TipoCalculo getTipoCalculo() {
		return tipoCalculo;
	}
	public void setDestinatario(Long destinatario) {
		this.destinatario = destinatario;
	}
	
	
	public void setTarea(DtoGenerarTarea tarea) {
		this.tarea = tarea;
	}

	public void setTipoCalculo(TipoCalculo tipoCalculo) {
		this.tipoCalculo = tipoCalculo;
	}

	

	
}
