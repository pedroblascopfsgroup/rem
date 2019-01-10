package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = "CPE_CORREOS_PENDIENTES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class CorreoSaliente implements Serializable {

	private static final long serialVersionUID = -8792459363840611652L;
	
	public static final boolean PROCESADO = true;
	public static final boolean NO_PROCESADO = false;
	
    @Id
    @Column(name = "CPE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "CorreoPendienteGenerator")
    @SequenceGenerator(name = "CorreoPendienteGenerator", sequenceName = "S_CPE_CORREOS_PENDIENTES")
    private Long id;
	
    @Column(name = "CPE_TO")
    private String to;

    @Column(name = "CPE_FROM")
    private String from;

    @Column(name = "CPE_ASUNTO")
    private String asunto;

    @Column(name = "CPE_CUERPO")
    private String cuerpo;

    @Column(name = "CPE_ID_ADJUNTO")
    private Long idAdjunto;

    @Column(name = "CPE_NOMBRE")
    private String nombre;

    @Column(name = "CPE_FECHA_ENVIO")
    private Date fechaEnvio;

    @Column(name = "CPE_PROCESADO")
    private boolean procesado;
    
    @Column(name = "CPE_RESULTADO")
    private boolean resultado;
    
    @Column(name = "CPE_ERROR_DESC")
    private String error;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getTo() {
		return to;
	}

	public void setTo(String to) {
		this.to = to;
	}

	public String getFrom() {
		return from;
	}

	public void setFrom(String from) {
		this.from = from;
	}

	public String getAsunto() {
		return asunto;
	}

	public void setAsunto(String asunto) {
		this.asunto = asunto;
	}

	public String getCuerpo() {
		return cuerpo;
	}

	public void setCuerpo(String cuerpo) {
		this.cuerpo = cuerpo;
	}

	public Long getIdAdjunto() {
		return idAdjunto;
	}

	public void setIdAdjunto(Long idAdjunto) {
		this.idAdjunto = idAdjunto;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public Date getFechaEnvio() {
		return fechaEnvio == null ? null : (Date) fechaEnvio.clone();
	}

	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio == null ? null : (Date) fechaEnvio.clone();
	}

	public boolean isProcesado() {
		return procesado;
	}

	public void setProcesado(boolean procesado) {
		this.procesado = procesado;
	}

	public boolean isResultado() {
		return resultado;
	}

	public void setResultado(boolean resultado) {
		this.resultado = resultado;
	}

	public String isError() {
		return error;
	}

	public void setError(String error) {
		this.error = error;
	}
	
	

}
