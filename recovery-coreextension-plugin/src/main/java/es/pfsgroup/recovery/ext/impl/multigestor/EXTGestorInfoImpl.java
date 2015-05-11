package es.pfsgroup.recovery.ext.impl.multigestor;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.ext.api.multigestor.EXTGestorInfo;

public class EXTGestorInfoImpl implements EXTGestorInfo {

	private Long id;
	private String idCompuesto;
	private EXTDDTipoGestor tipoGestor;
	
	private Usuario usuario;

	
	public void setTipoGestor(EXTDDTipoGestor tipoGestor){
		this.tipoGestor = tipoGestor;
	}
	@Override
	public EXTDDTipoGestor getTipoGestor() {
		return tipoGestor;
	}
	
	public void setUsuario(Usuario usuario){
		this.usuario = usuario;
	}

	@Override
	public Usuario getUsuario() {
		return usuario;
	}
	public void setId(Long id) {
		this.id = id;
	}
	
	@Override
	public Long getId() {
		return id;
	}
	@Override
	public String getIdCompuesto() {
		return usuario.getId()+"_"+tipoGestor.getId();
	}
	
	public void setIdCompuesto(String idCompuesto){
		this.idCompuesto = idCompuesto;
	}
	
	

}
