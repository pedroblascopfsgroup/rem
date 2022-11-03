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
import es.capgemini.pfs.users.domain.Usuario;

@Entity
@Table(name = "AEX_AUDITORIA_EXPORTACIONES", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class AuditoriaExportaciones implements Serializable, Auditable {

	/**
	 * Modelo que audita las exportaciones
	 * 
	 * @author juan.torrella@pfsgroup.es
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "AEX_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "AuditoriaExportacionesGenerator")
	@SequenceGenerator(name = "AuditoriaExportacionesGenerator", sequenceName = "S_AEX_AUDITORIA_EXPORTACIONES")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USU_ID")
	private Usuario usuario;
	
    @Column(name = "AEX_FECHA_EXPORTACION")
    private Date fechaExportacion;
     
    @Column(name = "AEX_BUSCADOR")
    private String buscador;
    
    @Column(name = "AEX_NUM_REGISTROS")
    private Long numRegistros;
    
	@Column(name = "AEX_ACCION")
	private Boolean accion;
	
	@Column(name = "AEX_FILTROS")
	private String filtros;
	
	@Column(name = "AEX_INDICA_BUSQUEDA")
	private Boolean isBusqueda;
	
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

	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}

	public Date getFechaExportacion() {
		return fechaExportacion;
	}

	public void setFechaExportacion(Date fechaExportacion) {
		this.fechaExportacion = fechaExportacion;
	}

	public String getBuscador() {
		return buscador;
	}

	public void setBuscador(String buscador) {
		this.buscador = buscador;
	}

	public Long getNumRegistros() {
		return numRegistros;
	}

	public void setNumRegistros(Long numRegistros) {
		this.numRegistros = numRegistros;
	}

	public Boolean getAccion() {
		return accion;
	}

	public void setAccion(Boolean accion) {
		this.accion = accion;
	}

	public String getFiltros() {
		return filtros;
	}

	public void setFiltros(String filtros) {
		this.filtros = filtros;
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

	public Boolean getIsBusqueda() {
		return isBusqueda;
	}

	public void setIsBusqueda(Boolean isBusqueda) {
		this.isBusqueda = isBusqueda;
	}
}
