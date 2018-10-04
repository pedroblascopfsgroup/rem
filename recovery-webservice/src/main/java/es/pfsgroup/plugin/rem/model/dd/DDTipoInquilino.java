package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;


@Entity
@Table(name = "DD_TPI_TIPO_INQUILINO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoInquilino implements Auditable, Dictionary{
	
		public final static String TIPO_INQUILINO_NORMAL= "01";
		public final static String TIPO_INQUILINO_ANTIGUO_DEUDOR = "02";
		public final static String TIPO_INQUILINO_EMPLEADO_PROPIETARIO = "03";
		public final static String TIPO_INQUILINO_EMPLEADO_HAYA = "04";

		private static final long serialVersionUID = 2429941762560843718L;

		@Id
		@Column(name = "DD_TPI_ID")
		@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoInquilinoGenerator")
		@SequenceGenerator(name = "DDTipoInquilinoGenerator", sequenceName = "DD_TPI_TIPO_INQUILINO")
		private Long id;
		    
		@Column(name = "DD_TPI_CODIGO")   
		private String codigo;
		 
		@Column(name = "DD_TPI_DESCRIPCION")   
		private String descripcion;
		    
		@Column(name = "DD_TPI_DESCRIPCION_LARGA")   
		private String descripcionLarga;	    

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

		public String getCodigo() {
			return codigo;
		}

		public void setCodigo(String codigo) {
			this.codigo = codigo;
		}

		public String getDescripcion() {
			return descripcion;
		}

		public void setDescripcion(String descripcion) {
			this.descripcion = descripcion;
		}

		public String getDescripcionLarga() {
			return descripcionLarga;
		}

		public void setDescripcionLarga(String descripcionLarga) {
			this.descripcionLarga = descripcionLarga;
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
