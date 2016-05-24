package es.pfsgroup.recovery.ext.impl.bienes.dto;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.bien.model.DDTipoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBDDOrigenBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBInformacionRegistralBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;

/**
 * @author mmejias
 */
public class DTOBusquedaExportBienes extends WebDto {

	private static final long serialVersionUID = 7265317907766018054L;
	
	private NMBBien bien;
	private NMBDDOrigenBien origenBien;
	private DDTipoBien tipoBien;
	private NMBInformacionRegistralBien informacionRegistralBien;
	private NMBLocalizacionesBien localizacion;

	public NMBBien getBien() {
		return bien;
	}

	public void setBien(NMBBien bien) {
		this.bien = bien;
	}

	public NMBDDOrigenBien getOrigenBien() {
		return origenBien;
	}

	public void setOrigenBien(NMBDDOrigenBien origenBien) {
		this.origenBien = origenBien;
	}

	public DDTipoBien getTipoBien() {
		return tipoBien;
	}

	public void setTipoBien(DDTipoBien tipoBien) {
		this.tipoBien = tipoBien;
	}

	public NMBInformacionRegistralBien getInformacionRegistralBien() {
		return informacionRegistralBien;
	}

	public void setInformacionRegistralBien(
			NMBInformacionRegistralBien informacionRegistralBien) {
		this.informacionRegistralBien = informacionRegistralBien;
	}

	public NMBLocalizacionesBien getLocalizacion() {
		return localizacion;
	}

	public void setLocalizacion(NMBLocalizacionesBien localizacion) {
		this.localizacion = localizacion;
	}

}
