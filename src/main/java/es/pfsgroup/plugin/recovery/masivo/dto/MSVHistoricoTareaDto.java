package es.pfsgroup.plugin.recovery.masivo.dto;

import java.util.List;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.ext.api.asunto.EXTHistoricoProcedimiento;

public class MSVHistoricoTareaDto extends EXTHistoricoProcedimiento {
	
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
