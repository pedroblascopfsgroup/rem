package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de las resoluciones del expediente.
 *  
 * @author Ivan Rubio
 *
 */
public class DtoExpedienteHistScoring extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3846508929652655678L;
	
	private Date fechaSancion;
	private String resultadoScoring;
	private Long nSolicitud;
	private String docScoring;
	private Integer nMesesFianza;
	private Long importeFianza;
	
	
	public Date getFechaSancion() {
		return fechaSancion;
	}
	public void setFechaSancion(Date fechaSancion) {
		this.fechaSancion = fechaSancion;
	}
	public String getResultadoScoring() {
		return resultadoScoring;
	}
	public void setResultadoScoring(String resultadoScoring) {
		this.resultadoScoring = resultadoScoring;
	}
	public Long getnSolicitud() {
		return nSolicitud;
	}
	public void setnSolicitud(Long nSolicitud) {
		this.nSolicitud = nSolicitud;
	}
	public String getDocScoring() {
		return docScoring;
	}
	public void setDocScoring(String docScoring) {
		this.docScoring = docScoring;
	}
	public Integer getnMesesFianza() {
		return nMesesFianza;
	}
	public void setnMesesFianza(Integer nMesesFianza) {
		this.nMesesFianza = nMesesFianza;
	}
	public Long getImporteFianza() {
		return importeFianza;
	}
	public void setImporteFianza(Long importeFianza) {
		this.importeFianza = importeFianza;
	}
	
	
}
