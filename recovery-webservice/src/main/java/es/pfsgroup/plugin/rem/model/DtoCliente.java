package es.pfsgroup.plugin.rem.model;

public class DtoCliente {
	
	private String nombreCliente;
	private String direccionCliente;
	private String dniCliente;
	private String tlfCliente;
	private String deudor;
	private String rBienes;
	
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getDireccionCliente() {
		return direccionCliente;
	}
	public void setDireccionCliente(String direccionCliente) {
		this.direccionCliente = direccionCliente;
	}
	public String getDniCliente() {
		return dniCliente;
	}
	public void setDniCliente(String dniCliente) {
		this.dniCliente = dniCliente;
	}
	public String getTlfCliente() {
		return tlfCliente;
	}
	public void setTlfCliente(String tlfCliente) {
		this.tlfCliente = tlfCliente;
	}
	public String getDeudor() {
		return deudor;
	}
	public void setDeudor(String deudor) {
		this.deudor = deudor;
	}
	public String getrBienes() {
		return rBienes;
	}
	public void setrBienes(String rBienes) {
		this.rBienes = rBienes;
	}
}
