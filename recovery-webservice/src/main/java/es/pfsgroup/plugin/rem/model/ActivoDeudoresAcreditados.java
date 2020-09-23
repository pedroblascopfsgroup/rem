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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDeDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVpo;


	@Entity
	@Table(name = "ACT_DEU_DEUDOR_ACREDITADO", schema = "${entity.schema}")
	@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	public class ActivoDeudoresAcreditados implements Serializable, Auditable{
		/**
		 * 
		 */
		private static final long serialVersionUID = 1L;

		@Id
	    @Column(name = "ACT_DEU_ID")
	    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoDeudorAcreditadoGenerator")
	    @SequenceGenerator(name = "ActivoDeudorAcreditadoGenerator", sequenceName = "S_ACT_DEU_DEUDOR_ACREDITADO")
	    private Long id;
		
		@ManyToOne(fetch = FetchType.LAZY)
	    @JoinColumn(name = "ACT_ID")
	    private Activo activo;
		
		@ManyToOne(fetch = FetchType.LAZY)
	    @JoinColumn(name = "DD_TDI_ID")
		private DDTipoDeDocumento tipoDocumento;
		
		@ManyToOne(fetch = FetchType.LAZY)
	    @JoinColumn(name = "USU_ID")
		private Usuario usuario;
		

		@Column(name = "DEU_NUM_DOC")
		private String numeroDocumentoDeudor;
		
		@Column(name = "DEU_NOMBRE")
		private String nombreDeudor;
		
		@Column(name = "DEU_APELLIDO1")
		private String apellido1Deudor;
		
		@Column(name = "DEU_APELLIDO2")
		private String apellido2Deudor;
		
		@Column(name = "DEU_FECHA_ALTA")
		private Date fechaAlta;
		
		
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

		public Activo getActivo() {
			return activo;
		}

		public void setActivo(Activo activo) {
			this.activo = activo;
		}

		public DDTipoDeDocumento getTipoDocumento() {
			return tipoDocumento;
		}

		public void setTipoDocumento(DDTipoDeDocumento tipoDocumento) {
			this.tipoDocumento = tipoDocumento;
		}

		public Usuario getUsuario() {
			return usuario;
		}

		public void setUsuario(Usuario usuario) {
			this.usuario = usuario;
		}

		public String getNumeroDocumentoDeudor() {
			return numeroDocumentoDeudor;
		}

		public void setNumeroDocumentoDeudor(String numeroDocumentoDeudor) {
			this.numeroDocumentoDeudor = numeroDocumentoDeudor;
		}

		public String getNombreDeudor() {
			return nombreDeudor;
		}

		public void setNombreDeudor(String nombreDeudor) {
			this.nombreDeudor = nombreDeudor;
		}

		public String getApellido1Deudor() {
			return apellido1Deudor;
		}

		public void setApellido1Deudor(String apellido1Deudor) {
			this.apellido1Deudor = apellido1Deudor;
		}

		public String getApellido2Deudor() {
			return apellido2Deudor;
		}

		public void setApellido2Deudor(String apellido2Deudor) {
			this.apellido2Deudor = apellido2Deudor;
		}

		public Date getFechaAlta() {
			return fechaAlta;
		}

		public void setFechaAlta(Date fechaAlta) {
			this.fechaAlta = fechaAlta;
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
