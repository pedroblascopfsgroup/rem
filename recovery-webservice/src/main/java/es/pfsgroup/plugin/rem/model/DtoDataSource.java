package es.pfsgroup.plugin.rem.model;

import java.util.List;

public class DtoDataSource {
	
	private List<Object> listaCliente;
	private List<Object> listaOferta;
	private List<Object> listaTasacion;
	private List<Object> listaHonorario;
	private List<Object> listaComprador;

	public List<Object> getListaCliente() {
		return listaCliente;
	}

	public void setListaCliente(List<Object> listaCliente) {
		this.listaCliente = listaCliente;
	}

	public List<Object> getListaOferta() {
		return listaOferta;
	}

	public void setListaOferta(List<Object> listaOferta) {
		this.listaOferta = listaOferta;
	}

	public List<Object> getListaTasacion() {
		return listaTasacion;
	}

	public void setListaTasacion(List<Object> listaTasacion) {
		this.listaTasacion = listaTasacion;
	}

	public List<Object> getListaHonorario() {
		return listaHonorario;
	}

	public void setListaHonorario(List<Object> listaHonorario) {
		this.listaHonorario = listaHonorario;
	}

	public List<Object> getListaComprador() {
		return listaComprador;
	}

	public void setListaComprador(List<Object> listaComprador) {
		this.listaComprador = listaComprador;
	}
}
