package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

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
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;

@Entity
@Table(name = "APD_PODERADOS_BBVA", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ApoderadosBbva implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "APD_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ApoderadosBbvaGenerator")
    @SequenceGenerator(name = "ApoderadosBbvaGenerator", sequenceName = "S_APD_PODERADOS_BBVA")
    private Long id;
	
	@Column(name = "APD_NOMBRE")
   	private String nombre;
	
	@Column(name = "APD_APELLIDOS")
   	private String apellidos;
	
	@Column(name = "APD_DOCUMENTO")
   	private String documento;
	
	@Column(name = "APD_DOMICILIO")
   	private String domicilio;
	
	@Column(name = "APD_NACIONALIDAD")
   	private String nacionalidad;
	
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_ECV_ID")
	private DDEstadosCiviles estadoCivil;
    
    @Column(name = "APD_AREA")
   	private String area;
    
    @Column(name = "APD_CARGO")
   	private String cargo;
    
    @Column(name = "APD_TIPO_PODER")
   	private String tipoPoder;
    
    @Column(name = "APD_NOTARIA_EMISION_PODER")
   	private String notariaEmisionPoder;
    
    @Column(name = "APD_PROTOCOLO_PODER")
   	private String protocoloPoder;
    
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

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getApellidos() {
		return apellidos;
	}

	public void setApellidos(String apellidos) {
		this.apellidos = apellidos;
	}

	public String getDocumento() {
		return documento;
	}

	public void setDocumento(String documento) {
		this.documento = documento;
	}

	public String getDomicilio() {
		return domicilio;
	}

	public void setDomicilio(String domicilio) {
		this.domicilio = domicilio;
	}

	public String getNacionalidad() {
		return nacionalidad;
	}

	public void setNacionalidad(String nacionalidad) {
		this.nacionalidad = nacionalidad;
	}

	public DDEstadosCiviles getEstadoCivil() {
		return estadoCivil;
	}

	public void setEstadoCivil(DDEstadosCiviles estadoCivil) {
		this.estadoCivil = estadoCivil;
	}

	public String getArea() {
		return area;
	}

	public void setArea(String area) {
		this.area = area;
	}

	public String getCargo() {
		return cargo;
	}

	public void setCargo(String cargo) {
		this.cargo = cargo;
	}

	public String getTipoPoder() {
		return tipoPoder;
	}

	public void setTipoPoder(String tipoPoder) {
		this.tipoPoder = tipoPoder;
	}

	public String getNotariaEmisionPoder() {
		return notariaEmisionPoder;
	}

	public void setNotariaEmisionPoder(String notariaEmisionPoder) {
		this.notariaEmisionPoder = notariaEmisionPoder;
	}

	public String getProtocoloPoder() {
		return protocoloPoder;
	}

	public void setProtocoloPoder(String protocoloPoder) {
		this.protocoloPoder = protocoloPoder;
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

}
