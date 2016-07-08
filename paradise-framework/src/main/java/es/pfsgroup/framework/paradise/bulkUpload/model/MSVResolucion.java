package es.pfsgroup.framework.paradise.bulkUpload.model;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;
import javax.persistence.CascadeType;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Type;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

/**
 * Clase que representa una resoluci�n.
 * @author manuel
 *
 */
@Entity
@Table(name = "RES_RESOLUCIONES_MASIVO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class MSVResolucion implements Auditable, Serializable{
	
	private static final long serialVersionUID = 3864955567532167361L;

	@Id
    @Column(name = "RES_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVResolucionGenerator")
    @SequenceGenerator(name = "MSVResolucionGenerator", sequenceName = "S_RES_RESOLUCIONES_MASIVO")
	private Long id;
	
    @ManyToOne
    @JoinColumn(name = "RES_TJU_ID")
    private MSVDDTipoJuicio tipoJuicio;
	
    @ManyToOne
    @JoinColumn(name = "RES_TRE_ID")
	private MSVDDTipoResolucion tipoResolucion;
	
    @ManyToOne
    @JoinColumn(name = "RES_EPF_ID")
	private MSVDDEstadoProceso estadoResolucion;
	
    @Embedded
	private Auditoria auditoria;
	
    @Version
    private Integer version;
	
    @Column(name = "RES_NOMBRE_FICHERO")
	private String nombreFichero;

	@Column(name = "RES_CONTENIDO_FICH")
	@Type(type = "es.capgemini.devon.hibernate.dao.BlobStreamType")
	private FileItem contenidoFichero;
	
	@ManyToOne
	@JoinColumn(name = "RES_ASU_ID")
	private EXTAsunto asunto;

	@ManyToOne
	@JoinColumn(name = "RES_PRC_ID")
	private MEJProcedimiento procedimiento;

	@Column(name = "RES_PLAZA")
	private String plaza;
	
	@Column(name = "RES_JUZGADO")
	private String juzgado;
	
	@Column(name = "RES_AUTOS")
	private String autos;
	
	@Column(name = "RES_PRINCIPAL")
	private Double principal;
	
	@Column(name = "RES_CAT_ID")
	private Long categoria;
	
	@ManyToOne
	@JoinColumn(name = "RES_TEX_ID")
	private EXTTareaExterna tarea;
	
    @OneToMany(mappedBy="resolucion",cascade={CascadeType.ALL})
    private Set<MSVCampoDinamico> camposDinamicos = new HashSet<MSVCampoDinamico>(0);
	
    @OneToOne
    @JoinColumn(name = "RES_MSV_TMP_ID")
    private MSVFileItem adjunto;
    
    @OneToOne
    @JoinColumn(name = "RES_ADA_ID")
    private EXTAdjuntoAsunto adjuntoFinal;
    
    @OneToOne
    @JoinColumn(name = "RES_TAR_ID")
    private TareaNotificacion tareaNotificacion;




	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}

	public MSVDDTipoJuicio getTipoJuicio() {
		return tipoJuicio;
	}

	public void setTipoJuicio(MSVDDTipoJuicio tipoJuicio) {
		this.tipoJuicio = tipoJuicio;
	}

	public MSVDDTipoResolucion getTipoResolucion() {
		return tipoResolucion;
	}

	public void setTipoResolucion(MSVDDTipoResolucion tipoResolucion) {
		this.tipoResolucion = tipoResolucion;
	}

	public MSVDDEstadoProceso getEstadoResolucion() {
		return estadoResolucion;
	}

	public void setEstadoResolucion(MSVDDEstadoProceso estadoResolucion) {
		this.estadoResolucion = estadoResolucion;
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

	public String getNombreFichero() {
		return nombreFichero;
	}

	public void setNombreFichero(String nombreFichero) {
		this.nombreFichero = nombreFichero;
	}
	
    public FileItem getContenidoFichero() {
		return contenidoFichero;
	}

	public void setContenidoFichero(FileItem contenidoFichero) {
		this.contenidoFichero = contenidoFichero;
	}

	public EXTAsunto getAsunto() {
		return asunto;
	}

	public void setAsunto(EXTAsunto asunto) {
		this.asunto = asunto;
	}

	public MEJProcedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(MEJProcedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	public String getPlaza() {
		return plaza;
	}

	public void setPlaza(String plaza) {
		this.plaza = plaza;
	}

	public String getJuzgado() {
		return juzgado;
	}

	public void setJuzgado(String juzgado) {
		this.juzgado = juzgado;
	}

	public String getAutos() {
		return autos;
	}

	public void setAutos(String autos) {
		this.autos = autos;
	}

	public Set<MSVCampoDinamico> getCamposDinamicos() {
		return camposDinamicos;
	}

	public void setCamposDinamicos(Set<MSVCampoDinamico> camposDinamicos) {
		this.camposDinamicos = camposDinamicos;
	}

	public Double getPrincipal() {
		return principal;
	}

	public void setPrincipal(Double principal) {
		this.principal = principal;
	}

	public EXTTareaExterna getTarea() {
		return tarea;
	}

	public void setTarea(EXTTareaExterna tarea) {
		this.tarea = tarea;
	}
	
	public MSVFileItem getAdjunto() {
		return adjunto;
	}

	public void setAdjunto(MSVFileItem adjunto) {
		this.adjunto = adjunto;
	}
	
	public EXTAdjuntoAsunto getAdjuntoFinal() {
		return adjuntoFinal;
	}

	public void setAdjuntoFinal(EXTAdjuntoAsunto adjuntoFinal) {
		this.adjuntoFinal = adjuntoFinal;
	}

	public String getNombreTipoAdjunto() {
		if (this.adjunto != null && this.adjunto.getTipoFichero() != null){
			return nombreFichero + " - " + this.adjunto.getTipoFichero().getDescripcion() +".";
		} 
		else {
			return nombreFichero;
		}

	}
	
	public TareaNotificacion getTareaNotificacion() {
		return tareaNotificacion;
	}

	public void setTareaNotificacion(TareaNotificacion tareaNotificacion) {
		this.tareaNotificacion = tareaNotificacion;
	}
	
	public Long getCategoria() {
		return categoria;
	}
	
	public void setCategoria(Long categoria) {
		this.categoria = categoria;
	}
	
}
