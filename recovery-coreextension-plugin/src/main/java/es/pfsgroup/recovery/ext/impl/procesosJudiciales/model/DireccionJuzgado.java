package es.pfsgroup.recovery.ext.impl.procesosJudiciales.model;

import java.io.Serializable;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.Persona;

@Entity
@Table(name = "DIJ_DIRECCION_JUZGADO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DireccionJuzgado implements Serializable, Auditable {
	
	 	/**
	 * 
	 */
	private static final long serialVersionUID = -730261487754068033L;

		@Id
	    @Column(name = "DIJ_ID")
	 	 @GeneratedValue(strategy = GenerationType.AUTO, generator = "DireccionJuzgadoGenerator")
	    @SequenceGenerator(name = "DireccionJuzgadoGenerator", sequenceName = "S_DIJ_DIRECCION_JUZGADO")
	    private Long id;

	    @OneToOne
	    @JoinColumn(name = "DD_LOC_ID")
	    private Localidad localidad;

	    @Column(name = "DIJ_MUNICIPIO")
	    private String municipio;

	    @OneToOne
	    @JoinColumn(name = "DD_PRV_ID")
	    private DDProvincia provincia;

	    @Column(name = "DIJ_DOMICILIO")
	    private String domicilio;

	    @Column(name = "DIJ_DOM_N")
	    private String domicilio_n;

	    @Column(name = "DIJ_DOM_PISO")
	    private String piso;

	    @Column(name = "DIJ_DOM_PORTAL")
	    private String portal;

	    @Column(name = "DIJ_DOM_ESC")
	    private String escalera;

	    @Column(name = "DIJ_DOM_PUERTA")
	    private String puerta;

	    @Column(name = "DIJ_CODIGO_POSTAL")
	    private Integer codigoPostal;

	    @ManyToOne
	    @JoinColumn(name = "DD_TVI_ID")
	    private DDTipoVia tipoVia;

	    @Column(name = "DIJ_COD_DIRECCION")
	    private Long codDireccion;
	    
	    @Column(name = "DIJ_COD_POST_INTL")
		private String codigoPostalInternacional;
	    
	    @Column(name = "DIJ_PROVINCIA")
		private String nomProvincia;
	    
	    @Column(name = "DIJ_POBLACION")
		private String nomPoblacion;

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

		public Localidad getLocalidad() {
			return localidad;
		}

		public void setLocalidad(Localidad localidad) {
			this.localidad = localidad;
		}

		public String getMunicipio() {
			return municipio;
		}

		public void setMunicipio(String municipio) {
			this.municipio = municipio;
		}

		public DDProvincia getProvincia() {
			return provincia;
		}

		public void setProvincia(DDProvincia provincia) {
			this.provincia = provincia;
		}

		public String getDomicilio() {
			return domicilio;
		}

		public void setDomicilio(String domicilio) {
			this.domicilio = domicilio;
		}

		public String getDomicilio_n() {
			return domicilio_n;
		}

		public void setDomicilio_n(String domicilio_n) {
			this.domicilio_n = domicilio_n;
		}

		public String getPiso() {
			return piso;
		}

		public void setPiso(String piso) {
			this.piso = piso;
		}

		public String getPortal() {
			return portal;
		}

		public void setPortal(String portal) {
			this.portal = portal;
		}

		public String getEscalera() {
			return escalera;
		}

		public void setEscalera(String escalera) {
			this.escalera = escalera;
		}

		public String getPuerta() {
			return puerta;
		}

		public void setPuerta(String puerta) {
			this.puerta = puerta;
		}

		public Integer getCodigoPostal() {
			return codigoPostal;
		}

		public void setCodigoPostal(Integer codigoPostal) {
			this.codigoPostal = codigoPostal;
		}

		public DDTipoVia getTipoVia() {
			return tipoVia;
		}

		public void setTipoVia(DDTipoVia tipoVia) {
			this.tipoVia = tipoVia;
		}

		public Long getCodDireccion() {
			return codDireccion;
		}

		public void setCodDireccion(Long codDireccion) {
			this.codDireccion = codDireccion;
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

		public String getCodigoPostalInternacional() {
			return codigoPostalInternacional;
		}

		public void setCodigoPostalInternacional(String codigoPostalInternacional) {
			this.codigoPostalInternacional = codigoPostalInternacional;
		}

		public String getNomProvincia() {
			return nomProvincia;
		}

		public void setNomProvincia(String nomProvincia) {
			this.nomProvincia = nomProvincia;
		}

		public String getNomPoblacion() {
			return nomPoblacion;
		}

		public void setNomPoblacion(String nomPoblacion) {
			this.nomPoblacion = nomPoblacion;
		}

		

	    
}
