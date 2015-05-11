package es.pfsgroup.plugin.recovery.masivo.dto;

import java.util.List;

import es.capgemini.pfs.core.api.asunto.HistoricoAsuntoInfo;
import es.capgemini.pfs.expediente.model.Evento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto.MEJHistoricoAsuntoViewDto;

public class MSVHistoricoTareaAsuntoDto extends MEJHistoricoAsuntoViewDto {
	
	public MSVHistoricoTareaAsuntoDto(HistoricoAsuntoInfo historicoAsunto, List<MSVHistoricoResolucionDto> resoluciones) {
		super(historicoAsunto);
		this.setResoluciones(resoluciones);		
	}

	public MSVHistoricoTareaAsuntoDto(HistoricoAsuntoInfo historicoAsunto, List<MSVHistoricoResolucionDto> resoluciones, Usuario usuario) {
		super(historicoAsunto);
		this.setResoluciones(resoluciones);		
		this.setUsuario(usuario);
	}

	public MSVHistoricoTareaAsuntoDto(Evento evento) {
		super(evento);
	}

	private static final long serialVersionUID = 2755229810433403044L;

	private List<MSVHistoricoResolucionDto> resoluciones;
	private Usuario usuario;

	public List<MSVHistoricoResolucionDto> getResoluciones() {
		return resoluciones;
	}

	public void setResoluciones(List<MSVHistoricoResolucionDto> resoluciones) {
		this.resoluciones = resoluciones;
	}

	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}
	
	
	
}
