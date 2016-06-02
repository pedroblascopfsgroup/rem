package es.pfsgroup.plugin.precontencioso;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.precontencioso.liquidacion.dto.DDPropietarioPCODto;

public class PrecontenciosoProjectContextImpl implements PrecontenciosoProjectContext {
	
	public static final String RECOVERY_HAYA = "HAYA";
	public static final String RECOVERY_BANKIA = "BANKIA";
	public static final String RECOVERY_CAJAMAR = "CAJAMAR";
	
	private String codigoFaseComun;
	private String recovery;
	private boolean generarArchivoBurofax;
	private List<String> variablesBurofax;
	
	private Map<String,Map<String,Map<String,Boolean>>> visibilidadBotones;
	
	@Override
	public String getCodigoFaseComun() {
		return codigoFaseComun;
	}

	public void setCodigoFaseComun(String codigoFaseComun) {
		this.codigoFaseComun = codigoFaseComun;
	}

	public boolean isGenerarArchivoBurofax() {
		return generarArchivoBurofax;
	}

	public void setGenerarArchivoBurofax(boolean generarArchivoBurofax) {
		this.generarArchivoBurofax = generarArchivoBurofax;
	}

	@Override
	public String getRecovery() {
		return recovery;
	}

	public void setRecovery(String recovery) {
		this.recovery = recovery;
	}

	@Override
	public List<String> getVariablesBurofax() {
		return variablesBurofax;
	}

	public void setVariablesBurofax(List<String> variablesBurofax) {
		this.variablesBurofax = variablesBurofax;
	}

	public Map<String,Map<String,Map<String,Boolean>>> getVisibilidadBotones() {
		return visibilidadBotones;
	}

	public void setVisibilidadBotones(Map<String,Map<String,Map<String,Boolean>>> visibilidadBotones) {
		this.visibilidadBotones = visibilidadBotones;
	}

	@Override
	public Map<String, Boolean> getVisibilidadBotonesPorSeccionYUsuario(
			String seccion, Usuario usuario) {
		
		final String DEFECTO="defecto";
		
		String entidadUsuario = usuario.getEntidad().getDescripcion();
		if (this.visibilidadBotones.containsKey(entidadUsuario) && 
				this.visibilidadBotones.get(entidadUsuario).containsKey(seccion)) {
			return this.visibilidadBotones.get(entidadUsuario).get(seccion);
		} else if (this.visibilidadBotones.containsKey(DEFECTO) && this.visibilidadBotones.get(DEFECTO).containsKey(seccion)) {
			return this.visibilidadBotones.get(DEFECTO).get(seccion);
		} else {
			return new HashMap<String, Boolean>();
		}
	}
	
}