package es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;


import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Type;
import org.hibernate.annotations.Where;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.recobroCommon.core.model.RecobroAdjuntos;

/**
 * Clase que mapea la entidad de procesos de facturación
 * @author diana
 *
 */
@Entity
@Table(name = "PRF_PROCESO_FACTURACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroProcesoFacturacion implements Auditable, Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 8532818719790972070L;

	@Id
    @Column(name = "PRF_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ProcesoFacturacionGenerator")
	@SequenceGenerator(name = "ProcesoFacturacionGenerator", sequenceName = "S_PRF_PROCESO_FACTURACION")
    private Long id;

	@Column(name = "PRF_NOMBRE")
	private String nombre;
	
	@Column(name = "PRF_FECHA_DESDE")
	private Date fechaDesde;
	
	@Column(name = "PRF_FECHA_HASTA")
	private Date fechaHasta;
	
	@OneToMany(cascade = CascadeType.ALL)
	@JoinColumn(name="PRF_ID")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	private List<RecobroProcesoFacturacionSubcartera> procesoSubcarteras;
	
	@ManyToOne
	@JoinColumn(name = "USU_ID_CREAR")	
	private Usuario usuarioCreacion;
	
	@ManyToOne
	@JoinColumn(name = "USU_ID_LIBERAR")
	private Usuario usuarioLiberacion;
	
	@ManyToOne
	@JoinColumn(name = "USU_ID_CANCELAR")
	private Usuario usuarioCancelacion;
	
	@Column(name = "PRF_FECHA_CREAR")
	private Date fechaCreacion;
	
	@Column(name = "PRF_FECHA_LIBERAR")
	private Date fechaLiberacion;
	
	@Column(name = "PRF_FECHA_CANCELAR")
	private Date fechaCancelacion;
	
	@ManyToOne
	@JoinColumn(name = "RCF_DD_EPF_ID")	
	private RecobroDDEstadoProcesoFacturable estadoProcesoFacturable;
	
	@OneToOne
	@JoinColumn(name = "REA_ID")
	private RecobroAdjuntos fichero;
	
	@OneToOne
	@JoinColumn(name = "REA_ID_REDUCIDO")
	private RecobroAdjuntos ficheroReducido;

	@Column(name = "PRF_ERROR_BATCH")
	private String errorBatch;
	
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

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public Date getFechaDesde() {
		return fechaDesde;
	}

	public void setFechaDesde(Date fechaDesde) {
		this.fechaDesde = fechaDesde;
	}

	public Date getFechaHasta() {
		return fechaHasta;
	}

	public void setFechaHasta(Date fechaHasta) {
		this.fechaHasta = fechaHasta;
	}

	public List<RecobroProcesoFacturacionSubcartera> getProcesoSubcarteras() {
		return procesoSubcarteras;
	}

	public void setProcesoSubcarteras(
			List<RecobroProcesoFacturacionSubcartera> procesoSubcarteras) {
		this.procesoSubcarteras = procesoSubcarteras;
	}

	public Usuario getUsuarioCreacion() {
		return usuarioCreacion;
	}

	public void setUsuarioCreacion(Usuario usuarioCreacion) {
		this.usuarioCreacion = usuarioCreacion;
	}

	public RecobroDDEstadoProcesoFacturable getEstadoProcesoFacturable() {
		return estadoProcesoFacturable;
	}

	public void setEstadoProcesoFacturable(
			RecobroDDEstadoProcesoFacturable estadoProcesoFacturable) {
		this.estadoProcesoFacturable = estadoProcesoFacturable;
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
	
	public Double getTotalImporteCobros(){
		Double totalCobros=0D;
		for (RecobroProcesoFacturacionSubcartera subcartera : procesoSubcarteras){
			if (subcartera.getTotalImporteCobros()!=null)
				totalCobros = totalCobros+subcartera.getTotalImporteCobros();
		}
		
		return totalCobros;
	}
	
	public Double getTotalImporteFacturable(){
		Double totalImporte=0D;
		for (RecobroProcesoFacturacionSubcartera subcartera : procesoSubcarteras){
			if (subcartera.getTotalImporteFacturable()!=null)
				totalImporte = totalImporte+subcartera.getTotalImporteFacturable();
		}
		
		return totalImporte;
	}

	public Usuario getUsuarioLiberacion() {
		return usuarioLiberacion;
	}

	public void setUsuarioLiberacion(Usuario usuarioLiberacion) {
		this.usuarioLiberacion = usuarioLiberacion;
	}

	public Usuario getUsuarioCancelacion() {
		return usuarioCancelacion;
	}

	public void setUsuarioCancelacion(Usuario usuarioCancelacion) {
		this.usuarioCancelacion = usuarioCancelacion;
	}

	public Date getFechaCreacion() {
		return fechaCreacion;
	}

	public void setFechaCreacion(Date fechaCreacion) {
		this.fechaCreacion = fechaCreacion;
	}

	public Date getFechaLiberacion() {
		return fechaLiberacion;
	}

	public void setFechaLiberacion(Date fechaLiberacion) {
		this.fechaLiberacion = fechaLiberacion;
	}

	public Date getFechaCancelacion() {
		return fechaCancelacion;
	}

	public void setFechaCancelacion(Date fechaCancelacion) {
		this.fechaCancelacion = fechaCancelacion;
	}

	public RecobroAdjuntos getFichero() {
		return fichero;
	}

	public void setFichero(RecobroAdjuntos fichero) {
		this.fichero = fichero;
	}

	public String getErrorBatch() {
		return errorBatch;
	}

	public void setErrorBatch(String errorBatch) {
		this.errorBatch = errorBatch;
	}
	
	public RecobroAdjuntos getFicheroReducido() {
		return ficheroReducido;
	}

	public void setFicheroReducido(RecobroAdjuntos ficheroReducido) {
		this.ficheroReducido = ficheroReducido;
	}

}
