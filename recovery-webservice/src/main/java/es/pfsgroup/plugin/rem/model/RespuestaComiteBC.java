package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDApruebaDeniega;
import es.pfsgroup.plugin.rem.model.dd.DDResolucionComite;

/**
 * Modelo que gestiona los activos.
 */
@Entity
@Table(name = "RBC_RESPUESTA_RES_COMITE_BC", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class RespuestaComiteBC implements Serializable, Auditable {

    /**
	 * 
	 */
	public static final String COMITE_COMERCIAL = "Comercial";
	public static final String COMITE_CL_ROD = "CL/ROD";
	
	
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "RBC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "RespuestaComiteBCGenerator")
    @SequenceGenerator(name = "RespuestaComiteBCGenerator", sequenceName = "S_RBC_RESPUESTA_RES_COMITE_BC")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    private ExpedienteComercial expedienteComercial;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "RBC_VALIDACION_BC")
    private DDResolucionComite validacionBcRBC;
     
    @Column(name = "RBC_FECHA_RESP_BC")
    private Date fechaRespuestaBcRBC;
    
    @Column(name = "RBC_OBSERVACIONES_BC")
    private String observacionesBcRBC;
    
    @Column(name = "RBC_SANCION_CL_ROD")
    private String sancionClRod;
    
    @Column(name = "RBC_COMITE")
    private Boolean comiteRBC;
    
    @Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public ExpedienteComercial getExpedienteComercial() {
		return expedienteComercial;
	}

	public void setExpedienteComercial(ExpedienteComercial expedienteComercial) {
		this.expedienteComercial = expedienteComercial;
	}

	public DDResolucionComite getValidacionBcRBC() {
		return validacionBcRBC;
	}

	public void setValidacionBcRBC(DDResolucionComite validacionBcRBC) {
		this.validacionBcRBC = validacionBcRBC;
	}

	public Date getFechaRespuestaBcRBC() {
		return fechaRespuestaBcRBC;
	}

	public void setFechaRespuestaBcRBC(Date fechaRespuestaBcRBC) {
		this.fechaRespuestaBcRBC = fechaRespuestaBcRBC;
	}

	public String getObservacionesBcRBC() {
		return observacionesBcRBC;
	}

	public void setObservacionesBcRBC(String observacionesBcRBC) {
		this.observacionesBcRBC = observacionesBcRBC;
	}

	public String getSancionClRod() {
		return sancionClRod;
	}

	public void setSancionClRod(String sancionClRod) {
		this.sancionClRod = sancionClRod;
	}

	public Boolean getComiteRBC() {
		return comiteRBC;
	}

	public void setComiteRBC(Boolean comiteRBC) {
		this.comiteRBC = comiteRBC;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}