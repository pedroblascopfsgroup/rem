package es.pfsgroup.concursal.convenio.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;


@Entity
@Table(name = "COV_CONVENIOS", schema = "${entity.schema}")
public class Convenio implements Serializable, Auditable{

	private static final long serialVersionUID = 3081237368306184428L;

	@Id
	@Column(name = "COV_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ConvenioGenerator")
	@SequenceGenerator(name = "ConvenioGenerator", sequenceName = "S_COV_CONVENIOS")
	private Long id;
	
	@ManyToOne
    @JoinColumn(name = "PRC_ID")
	private Procedimiento procedimiento;
	
	@OneToMany(mappedBy = "convenio", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "COV_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ConvenioCredito> convenioCreditos;
   
	@Column(name = "COV_FECHA")
	private Date fecha;
	
	@Column(name = "COV_NUMPROPONENTES")
	private Long numProponentes;
	
	@Column(name = "COV_TOTALMASA")
	private Float totalMasa;
	
	@Column(name = "COV_PORCENTAJE")
	private Float porcentaje;

	@ManyToOne
    @JoinColumn(name = "DD_COV_ADHERIRSE_ID")
	private DDSiNo adherirse;
	
	@ManyToOne
    @JoinColumn(name = "DD_COV_TIPO_ID")
	private DDTipoConvenio tipoConvenio;
	
	@ManyToOne
    @JoinColumn(name = "DD_COV_INCIO_ID")
	private DDInicioConvenio inicioConvenio;
	
	@ManyToOne
    @JoinColumn(name = "DD_COV_ESTADO_ID")
	private DDEstadoConvenio estadoConvenio;
	
	@ManyToOne
    @JoinColumn(name = "DD_COV_POSTURA_ID")
	private DDPosturaConvenio posturaConvenio;
	
	@Column(name = "COV_OBSERVACIONES")
	private String descripcion; 

	@Column(name = "COV_DES_TERCEROS")
	private String descripcionTerceros; 

	@Column(name = "COV_DES_ANTICIPADO")
	private String descripcionAnticipado; 
	
	@Column(name = "COV_DES_ADHESIONES")
	private String descripcionAdhesiones; 
	
	@ManyToOne
    @JoinColumn(name = "DD_COV_ALTERNATIVA_ID")
	private DDTipoAlternativa tipoAlternativa;
	
	@ManyToOne
    @JoinColumn(name = "DD_COV_ADHESION_ID")
	private DDTipoAdhesion tipoAdhesion;
	
	@Column(name="COV_DES_CONVENIO")
	private String descripcionConvenio;

	@Column(name = "COV_TOTALMASA_ORD")
	private Float totalMasaOrd;
	
	@Column(name = "COV_PORCENTAJE_ORD")
	private Float porcentajeOrd;

	@Column(name = "SYS_GUID")
	private String guid;

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

	public Date getFecha() {
		return fecha;
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}

	public Long getNumProponentes() {
		return numProponentes;
	}

	public void setNumProponentes(Long numProponentes) {
		this.numProponentes = numProponentes;
	}

	public Float getTotalMasa() {
		return totalMasa;
	}

	public void setTotalMasa(Float totalMasa) {
		this.totalMasa = totalMasa;
	}

	public Float getPorcentaje() {
		return porcentaje;
	}

	public void setPorcentaje(Float porcentaje) {
		this.porcentaje = porcentaje;
	}

	public DDEstadoConvenio getEstadoConvenio() {
		return estadoConvenio;
	}

	public void setEstadoConvenio(DDEstadoConvenio estadoConvenio) {
		this.estadoConvenio = estadoConvenio;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
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

	public void setPosturaConvenio(DDPosturaConvenio posturaConvenio) {
		this.posturaConvenio = posturaConvenio;
	}

	public DDPosturaConvenio getPosturaConvenio() {
		return posturaConvenio;
	}

	public void setConvenioCreditos(List<ConvenioCredito> convenioCreditos) {
		this.convenioCreditos = convenioCreditos;
	}

	public List<ConvenioCredito> getConvenioCreditos() {
		return convenioCreditos;
	}

	public void setInicioConvenio(DDInicioConvenio inicioConvenio) {
		this.inicioConvenio = inicioConvenio;
	}

	public DDInicioConvenio getInicioConvenio() {
		return inicioConvenio;
	}

	public void setTipoConvenio(DDTipoConvenio tipoConvenio) {
		this.tipoConvenio = tipoConvenio;
	}

	public DDTipoConvenio getTipoConvenio() {
		return tipoConvenio;
	}

	public void setAdherirse(DDSiNo adherirse) {
		this.adherirse = adherirse;
	}

	public DDSiNo getAdherirse() {
		return adherirse;
	}

	public void setDescripcionTerceros(String descripcionTerceros) {
		this.descripcionTerceros = descripcionTerceros;
	}

	public String getDescripcionTerceros() {
		return descripcionTerceros;
	}

	public void setDescripcionAdhesiones(String descripcionAdhesiones) {
		this.descripcionAdhesiones = descripcionAdhesiones;
	}

	public String getDescripcionAdhesiones() {
		return descripcionAdhesiones;
	}

	public void setDescripcionAnticipado(String descripcionAnticipado) {
		this.descripcionAnticipado = descripcionAnticipado;
	}

	public String getDescripcionAnticipado() {
		return descripcionAnticipado;
	}
	
	public DDTipoAlternativa getTipoAlternativa() {
		return tipoAlternativa;
	}

	public void setTipoAlternativa(DDTipoAlternativa tipoAlternativa) {
		this.tipoAlternativa = tipoAlternativa;
	}

	public void setTipoAdhesion(DDTipoAdhesion tipoAdhesion) {
		this.tipoAdhesion = tipoAdhesion;
	}

	public DDTipoAdhesion getTipoAdhesion() {
		return tipoAdhesion;
	}

	public void setDescripcionConvenio(String descripcionConvenio) {
		this.descripcionConvenio = descripcionConvenio;
	}

	public String getDescripcionConvenio() {
		return descripcionConvenio;
	}

	public void setTotalMasaOrd(Float totalMasaOrd) {
		this.totalMasaOrd = totalMasaOrd;
	}

	public Float getTotalMasaOrd() {
		return totalMasaOrd;
	}

	public void setPorcentajeOrd(Float porcentajeOrd) {
		this.porcentajeOrd = porcentajeOrd;
	}

	public Float getPorcentajeOrd() {
		return porcentajeOrd;
	}

	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}

}
