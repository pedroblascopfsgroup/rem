package es.pfsgroup.plugin.rem.model;

public class DtoCondicionEspecificaAgrupacion extends DtoCondicionEspecifica {

	private Long idAgrupacion;	

    @Override
	public void setIdActivo(Long idActivo) {
		super.setIdActivo(idActivo);
	}
	public Long getIdAgrupacion() {
		return idAgrupacion;
	}
	public void setIdAgrupacion(Long idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}
	@Override
	public void setIdEntidad(Long idEntidad) {
		this.idAgrupacion = idEntidad;
	}
	@Override
	public String getTexto() {
		return super.getTexto();
	}
	@Override
	public void setTexto(String texto) {
		super.setTexto(texto);
	}
}
