package es.pfsgroup.plugin.recovery.coreextension.subasta.model;

import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

public class MEJAdjuntoAsunto extends AdjuntoAsunto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 273462728024758302L;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PRC_ID")
	private Procedimiento procedimiento;
	
	@ManyToOne
	@JoinColumn(name = "DD_TFA_ID", nullable = true)
	private DDTipoFicheroAdjunto tipoFichero;
    
    @Column(name = "ADA_CLAVE_DOCUMENTO")
    private String idDocumento;

	public String getIdDocumento() {
		return idDocumento;
	}

	public void setIdDocumento(String idDocumento) {
		this.idDocumento = idDocumento;
	}


	public DDTipoFicheroAdjunto getTipoFichero() {
		return tipoFichero;
	}

	public void setTipoFichero(DDTipoFicheroAdjunto tipoFichero) {
		this.tipoFichero = tipoFichero;
	}

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

}
