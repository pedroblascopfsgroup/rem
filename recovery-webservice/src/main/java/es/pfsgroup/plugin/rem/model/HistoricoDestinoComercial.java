package es.pfsgroup.plugin.rem.model;

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
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;


/**
 * Modelo que gestiona el historico del tipo de comercializacion de un activo
 *  
 * @author Ángel Pastelero
 */
@Entity
@Table(name = "HDC_HIST_DESTINO_COMERCIAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@PrimaryKeyJoinColumn(name="HDC_ID")
public class HistoricoDestinoComercial implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;
	
	public static final String GESTOR_ACTUALIZACION_DESCONOCIDO = "Desconocido";

	@Id
    @Column(name = "HDC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoDestinoComercialoGenerator")
    @SequenceGenerator(name = "HistoricoDestinoComercialoGenerator", sequenceName = "S_HDC_HIST_DESTINO_COMERCIAL")
    private Long id;
	
	@ManyToOne
	@JoinColumn(name = "ACT_ID")
	private Activo activo;

    @ManyToOne
    @JoinColumn(name = "DD_TCO_ID")
    private DDTipoComercializacion tipoComercializacion;
    
    @Column(name = "HDC_FECHA_INICIO")
	private Date fechaInicio;
    
    @Column(name = "HDC_FECHA_FIN")
   	private Date fechaFin;
    
    @Column(name = "HDC_GESTOR_ACTUALIZACION")
   	private String gestorActualizacion;
    
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

	public DDTipoComercializacion getTipoComercializacion() {
		return tipoComercializacion;
	}

	public void setTipoComercializacion(DDTipoComercializacion tipoComercializacion) {
		this.tipoComercializacion = tipoComercializacion;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public String getGestorActualizacion() {
		return gestorActualizacion;
	}

	public void setGestorActualizacion(String gestorActualizacion) {
		this.gestorActualizacion = gestorActualizacion;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

}
