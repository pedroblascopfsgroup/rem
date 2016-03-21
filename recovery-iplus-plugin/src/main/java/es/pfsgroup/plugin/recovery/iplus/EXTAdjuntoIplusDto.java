package es.pfsgroup.plugin.recovery.iplus;

import java.io.File;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.core.api.asunto.EXTAdjuntoDto;

public class EXTAdjuntoIplusDto implements EXTAdjuntoDto {

	private Boolean puedeBorrar = true;
	private AdjuntoAsunto adjunto;
	private String tipoDocumento;
	private Long prcId;
	private String refCentera;
	private String nombreTipoDoc;
	
	@Override
	public Boolean getPuedeBorrar() {
		return true;
	}

	@Override
	public AdjuntoAsunto getAdjunto() {
		return adjunto;
	}

	@Override
	public String getTipoDocumento() {
		return tipoDocumento;
	}

	@Override
	public Long prcId() {
		return prcId;
	}
	
	public void setTipoDocumento(String tipoDoc) {
		this.tipoDocumento = tipoDoc;
	}
	
	public void setPrcId(Long prcId) {
		this.prcId = prcId;
	}
	
	public void setAdjunto(File file, String nombre) {
		FileItem fi = new FileItem();
		fi.setFile(file);
		fi.setLength(file.length());
		fi.setFileName(nombre);
		this.adjunto = new AdjuntoAsunto(fi);
		adjunto.setNombre(nombre);
	}

	@Override
	public String getRefCentera() {
		return refCentera;
	}
	public void setRefCentera(String refCentera) {
		this.refCentera = refCentera;
	}

	@Override
	public String getNombreTipoDoc() {
		return null;
	}
	
	public void setNombreTipoDoc(String nombreTipoDoc) {
		this.nombreTipoDoc = nombreTipoDoc;
	}

}
