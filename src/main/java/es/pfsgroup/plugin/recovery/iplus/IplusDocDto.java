package es.pfsgroup.plugin.recovery.iplus;

import java.io.File;
import java.io.Serializable;
import java.util.Date;

public class IplusDocDto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8664407744173831282L;
	
	private String idProcedi;
	private int numOrden;
	private String codigoTipoProc;
	private String codigoTipoDoc;
	private String nombreFichero;
	private File file;
	private Date fechaCrear;
	private String usuarioCrear;

	public String getIdProcedi() {
		return idProcedi;
	}

	public void setIdProcedi(String idProcedi) {
		this.idProcedi = idProcedi;
	}

	public int getNumOrden() {
		return numOrden;
	}

	public void setNumOrden(int numOrden) {
		this.numOrden = numOrden;
	}

	public String getCodigoTipoProc() {
		return codigoTipoProc;
	}

	public void setCodigoTipoProc(String codigoTipoProc) {
		this.codigoTipoProc = codigoTipoProc;
	}

	public String getCodigoTipoDoc() {
		return codigoTipoDoc;
	}

	public void setCodigoTipoDoc(String codigoTipoDoc) {
		this.codigoTipoDoc = codigoTipoDoc;
	}

	public String getNombreFichero() {
		return nombreFichero;
	}

	public void setNombreFichero(String nombreFichero) {
		this.nombreFichero = nombreFichero;
	}

	public File getFile() {
		return file;
	}

	public void setFile(File file) {
		this.file = file;
	}

	public Date getFechaCrear() {
		return fechaCrear;
	}

	public void setFechaCrear(Date fechaCrear) {
		this.fechaCrear = fechaCrear;
	}

	public String getUsuarioCrear() {
		return usuarioCrear;
	}

	public void setUsuarioCrear(String usuarioCrear) {
		this.usuarioCrear = usuarioCrear;
	}

}
