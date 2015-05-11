package es.capgemini.pfs.asunto;

import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.ext.api.asunto.EXTUsuarioRelacionadoInfo;
import es.pfsgroup.recovery.ext.api.multigestor.EXTGestorInfo;

public class EXTUsuarioRelacionadoAsunto implements EXTUsuarioRelacionadoInfo {

	private String idCompuesto;
	private Dictionary tipoGestor;

	private Usuario usuario;

	public EXTUsuarioRelacionadoAsunto(GestorDespacho gestor,
			EXTDDTipoGestor tipoGestor) {
		if (Checks.esNulo(gestor)) {
			throw new IllegalArgumentException("'gestor' no puede ser null");
		}
		if (Checks.esNulo(tipoGestor)) {
			throw new IllegalArgumentException("'tipoGestor' no puede ser null");
		}

		this.tipoGestor = tipoGestor;
		this.usuario = gestor.getUsuario();
		this.idCompuesto = usuario.getId() +"_" + tipoGestor.getCodigo();
	}

	public EXTUsuarioRelacionadoAsunto(EXTGestorInfo gestorInfo) {
		if (Checks.esNulo(gestorInfo)) {
			throw new IllegalArgumentException("'gestorInfo' no puede ser null");
		}

		if (Checks.esNulo(gestorInfo.getUsuario())) {
			throw new IllegalStateException(
					"'gestorInfo.usuario' no puede ser null");
		}

		if (Checks.esNulo(gestorInfo.getTipoGestor())) {
			throw new IllegalStateException(
					"'gestorInfo.tipoGestor' no puede ser null");
		}

		this.usuario = gestorInfo.getUsuario();
		this.tipoGestor = gestorInfo.getTipoGestor();
		this.idCompuesto = usuario.getId() +"_" + tipoGestor.getCodigo();
	}

	public EXTUsuarioRelacionadoAsunto(Usuario usuario,
			EXTDDTipoGestor tipoGestor) {
		if (Checks.esNulo(usuario)) {
			throw new IllegalArgumentException("'usuario' no puede ser null");
		}
		if (Checks.esNulo(tipoGestor)) {
			throw new IllegalArgumentException("'tipoGestor' no puede ser null");
		}

		this.tipoGestor = tipoGestor;
		this.usuario = usuario;
		this.idCompuesto = usuario.getId() +"_" + tipoGestor.getCodigo();
	}

	@Override
	public int hashCode() {
		return usuario.getId().hashCode() + tipoGestor.getId().hashCode();
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		EXTUsuarioRelacionadoAsunto other = (EXTUsuarioRelacionadoAsunto) obj;
		if (usuario == null || tipoGestor == null) {
			if(usuario == null){
				if (other.usuario != null)
					return false;
				else
					return true;
			}
			if(tipoGestor == null){
				if (other.tipoGestor != null)
					return false;
				else
					return true;
			}
		} else if (!(usuario.getId().equals(other.usuario.getId()) && tipoGestor.getCodigo().equals(other.tipoGestor.getCodigo())))
			return false;
		return true;
	}

	@Override
	public Dictionary getTipoGestor() {
		return this.tipoGestor;
	}

	@Override
	public Usuario getUsuario() {
		return this.usuario;
	}

	public void setIdCompuesto(String idCompuesto) {
		this.idCompuesto = idCompuesto;
	}

	@Override
	public String getIdCompuesto() {
		return idCompuesto;
	}

}
