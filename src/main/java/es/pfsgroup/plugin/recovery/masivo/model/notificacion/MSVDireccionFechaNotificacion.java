package es.pfsgroup.plugin.recovery.masivo.model.notificacion;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.persona.model.Persona;

/**
 * Clase que representa el objeto DFN_DIRECCIONES_FECHA_NOTIFICACION
 * 
 * Almacena las fechas relativas al proceso de notificación de cada dirección 
 * de los demandados de un procedimiento. 
 * 
 * @author manuel
 *
 */

@Entity
@Table(name = "DFN_DIRECCIONES_FECHA_NOT", schema = "${entity.schema}")@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class MSVDireccionFechaNotificacion implements Auditable, Serializable{
	
	private static final long serialVersionUID = -5534010307116418300L;
	
	public final static String RESULTADO_POSITIVO = "POSITIVO";

	public final static String RESULTADO_NEGATIVO = "NEGATIVO";

	public static final String CODIGO_TIPO_FECHA_AVERIGUACION = "AVG";

	public static final String CODIGO_TIPO_FECHA_REQUERIMIENTO = "REC";

	public static final String CODIGO_TIPO_FECHA_HORARIO_NOCTURNO = "HNO";

	public static final String CODIGO_TIPO_FECHA_EDICTOS = "EDI";
	
	@Id
    @Column(name = "DFN_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVDireccionFechaNotificacion")
    @SequenceGenerator(name = "MSVDireccionFechaNotificacion", sequenceName = "S_DFN_DIRECCIONES_FECHA_NOT")	
	Long id;
	
    @ManyToOne
    @JoinColumn(name = "DFN_PRC_ID")	
	Procedimiento procedimiento;
	
    @ManyToOne
    @JoinColumn(name = "DFN_PER_ID")
	Persona persona;
	
    @ManyToOne
	@JoinColumn(name = "DFN_COD_DIRECCION", referencedColumnName="DIR_COD_DIRECCION")
	Direccion direccion;

    //TODO actualmente se esta utilizando la entity de las direccionesFechas 
	//para almacenar el campo excluido, se deberá cambiar a un objeto propio de demandados
	@Column(name= "DFN_EXCLUIDO")
	Boolean excluido;

	@Column(name= "DFN_TIPO_FECHA")
	private String tipoFecha;

	@Column(name = "DFN_FECHA_SOLICITUD")
	private Date fechaSolicitud;

	@Column(name = "DFN_FECHA_RESULTADO")
	private Date fechaResultado;

	@Column(name = "DFN_RESULTADO")
	private String resultado;
	
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

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	public Persona getPersona() {
		return persona;
	}

	public void setPersona(Persona persona) {
		this.persona = persona;
	}

	public Direccion getDireccion() {
		return direccion;
	}

	public void setDireccion(Direccion direccion) {
		this.direccion = direccion;
	}
	
	public String getTipoFecha() {
		return tipoFecha;
	}

	public void setTipoFecha(String tipoFecha) {
		this.tipoFecha = tipoFecha;
	}

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public Date getFechaResultado() {
		return fechaResultado;
	}

	public void setFechaResultado(Date fechaResultado) {
		this.fechaResultado = fechaResultado;
	}

	public String getResultado() {
		return resultado;
	}

	public void setResultado(String resultado) {
		this.resultado = resultado;
	}
	
	public Boolean getExcluido() {
		return excluido;
	}

	public void setExcluido(Boolean excluido) {
		this.excluido = excluido;
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
}
