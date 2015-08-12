package es.pfsgroup.recovery.integration.jdbc.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "MSQ_COLA_MENSAJERIA", schema = "${master.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class MensajeIntegracion implements Serializable, Auditable {
	
	public final static String ESTADO_PENDIENTE = "P";
	public static final String ESTADO_PROCESANDO = "R";
	public final static String ESTADO_OK = "O";
	public final static String ESTADO_ERROR = "E";
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 2095862929644946805L;

	public MensajeIntegracion() {
		this.estado = ESTADO_PENDIENTE;
	}
	
	@Id
    @Column(name = "MSQ_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MensajeIntegracionGenerator")
    @SequenceGenerator(name = "MensajeIntegracionGenerator", sequenceName = "${master.schema}.S_MSQ_COLA_MENSAJERIA")
    private Long id;
	
    @Column(name = "MSQ_COLA")
    private String cola;
    
    @Column(name = "MSQ_ESTADO")
    private String estado;
    
    @Column(name = "MSQ_TIPO")
    private String tipo;
    
    @Column(name = "SYS_GUID_GRP")
    private String guidGrp;
    
    @Column(name = "MSQ_MENSAJE")
    private String mensaje;

    @Column(name = "MSQ_LOG")
    private String log;

	@Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;
    
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	
	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public String getCola() {
		return cola;
	}

	public void setCola(String cola) {
		this.cola = cola;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

	public String getGuidGrp() {
		return guidGrp;
	}

	public void setGuidGrp(String guidGrp) {
		this.guidGrp = guidGrp;
	}

	public String getMensaje() {
		return mensaje;
	}

	public void setMensaje(String mensaje) {
		this.mensaje = mensaje;
	}

	public String getLog() {
		return log;
	}

	public void setLog(String log) {
		this.log = log;
	}


}
