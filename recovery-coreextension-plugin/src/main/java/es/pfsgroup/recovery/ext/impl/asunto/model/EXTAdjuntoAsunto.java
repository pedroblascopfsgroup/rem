package es.pfsgroup.recovery.ext.impl.asunto.model;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

/**
 * Clase que representa a un fichero.
 * @author Nicol�s Cornaglia
 */
@Entity
public class EXTAdjuntoAsunto extends AdjuntoAsunto {
		
    private static final long serialVersionUID = 1L;
    
    public EXTAdjuntoAsunto() {
		super();
	}
    
    public EXTAdjuntoAsunto(FileItem fileItem) {
		super(fileItem);
	}

    @ManyToOne
	@JoinColumn(name = "DD_TFA_ID", nullable = true)
	private DDTipoFicheroAdjunto tipoFichero;

    
    @Column(name = "BPM_IPT_ID")
	private Long bpmInputId;
    
	public DDTipoFicheroAdjunto getTipoFichero() {
		return tipoFichero;
	}

	public void setTipoFichero(DDTipoFicheroAdjunto tipoFichero) {
		this.tipoFichero = tipoFichero;
	}
	
    public Long getIdResolucion() {
		return super.getIdResolucion();
	}

	public void setIdResolucion(Long idResolucion) {
		super.setIdResolucion(idResolucion);
	}

	public Long getBpmInputId() {
		return super.getBpmInputId();
	}

	public void setBpmInputId(Long bpmInputId) {
		super.setBpmInputId(bpmInputId);
	}

	public Long getBpmInputId() {
		return bpmInputId;
	}

	public void setBpmInputId(Long bpmInputId) {
		this.bpmInputId = bpmInputId;
	}
    
 }
