package es.pfsgroup.plugin.recovery.mejoras.registro.model;

import java.io.Serializable;

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
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJDDTipoRegistroInfo;

@Entity
@Table(name = "MEJ_DD_TRG_TIPO_REGISTRO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class MEJDDTipoRegistro implements Serializable,Auditable, Dictionary,MEJDDTipoRegistroInfo{
	
	public static final String CODIGO_ENVIO_EMAILS = "EML";
	public static final String CODIGO_EDICION_ASUNTO = "ECA";
	public static final String CODIGO_EDICION_PROCEDIMIENTO = "ECP";
	public static final String CODIGO_AUTO_PRORROGA = "AP";
	public static final String CODIGO_ACEPTACION_PRORROGA = "PRO";
	public static final String CODIGO_CUMPLIMIENTO_ACUERDO="ACU";
	public static final String CODIGO_REVISION_RECURSO="REVREC";
	
	
	public static final class RegistroEmail{
		public static final String CLAVE_CUERPO = "emailBody";
		public static final String CLAVE_DESTINATARIO = "emailReceiver";
		public static final String CLAVE_ASUNTO = "emailSubject";
		public static final String CLAVE_EMAIL_DESTINO = "emailTo";
		public static final String CLAVE_EMAIL_CC = "emailCC";
		public static final String CLAVE_EMAIL_ORIGEN = "emailFrom";
		public static final String CLAVE_SUPERVISOR = "emailSupervisor";
		public static final String CLAVE_ADJUNTOS = "emailAdjuntos";
	}
	/*
	public static final class TrazaEdicionCabecera{ 
        public static final String CLAVE_NOMBRE_ANTERIOR = "nameOld"; 
        public static final String CLAVE_NOMBRE_POSTERIOR = "nameNew"; 
        public static final String CLAVE_GESTOR_EXTERNO_ANTERIOR = "gexOld"; 
        public static final String CLAVE_GESTOR_EXTERNO_POSTERIOR = "gexNew"; 
        public static final String CLAVE_DESPACHO_ANTERIOR = "dcOld"; 
        public static final String CLAVE_DESPACHO_POSTERIOR = "dcNew";
		public static final String CLAVE_CAMBIO_GESTOR_INTERNO = "gintNew";
		public static final String CLAVE_CAMBIO_SUPERVISOR = "supNew";
		public static final String CLAVE_CAMBIO_PROCURADOR = "procuNew";
		
    }*/
	/*
	public static final class TrazaEdicionCabeceraProcedimiento{ 
        public static final String CLAVE_TIPO_RECLAMACION_ANTERIOR = "treOld"; 
        public static final String CLAVE_TIPO_RECLAMACION_POSTERIOR = "treNew";
		public static final String CLAVE_JUZGADO_ANTERIOR = "juzOld";
		public static final String CLAVE_JUZGADO_POSTERIOR = "juzNew";
		public static final String CLAVE_PRINCIPAL_ANTERIOR = "pplOld";
		public static final String CLAVE_PRINCIPAL_POSTERIOR = "pplNew";
		public static final String CLAVE_PLAZO_ANTERIOR = "plaOld";
		public static final String CLAVE_PLAZO_POSTERIOR = "plaNew";
		public static final String CLAVE_ESTIMACION_ANTERIOR = "estOld";
		public static final String CLAVE_ESTIMACION_POSTERIOR = "estNew"; 
    }*/
	
	public static final class TrazaAutoProrroga {
		public static final String CLAVE_ID_TAREA_NOTIFICACION = "tarId";
		public static final String CLAVE_FECHA_VENCIMIENTO_ORIGINAL = "tarFecVencOld";
		public static final String CLAVE_FECHA_VENCIMIENTO_PROPUESTA = "tarFecVencNew";
		public static final String CLAVE_MOTIVO = "motivo";
		public static final String CLAVE_DETALLE = "detalle";
	}
	
	public static final class TrazaRevisionRecurso {
		public static final String CLAVE_ID_RECURSO = "regId";
		public static final String CLAVE_ID_TAREA_NOTIFICACION = "tarId";
		public static final String CLAVE_FECHA_VENCIMIENTO_INICIAL = "tarFecVencIni";
		public static final String CLAVE_FECHA_VENCIMIENTO_FINAL = "tarFecVencFinal";
		public static final String CLAVE_FECHA_REVISION_RECURSO = "tarFecRevRecurso";
		
	}
	
	private static final long serialVersionUID = -2348943703013010629L;

	@Id
	@Column(name = "DD_TRG_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "MEJDDTipoRegistroGenerator")
	@SequenceGenerator(name = "MEJDDTipoRegistroGenerator", sequenceName = "S_MEJ_DD_TRG_TIPO_REGISTRO")
	private Long id;

	@Column(name = "DD_TRG_CODIGO")
	private String codigo;

	@Column(name = "DD_TRG_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_TRG_DESCRIPCION_LARGA")
	private String descripcionLarga;

	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria=auditoria;
	}

	@Override
	public String getCodigo() {
		return codigo;
	}
	
	public void setCodigo(String codigo){
		this.codigo=codigo;
	}

	@Override
	public String getDescripcion() {
		return descripcion;
	}
	
	public void setDescripcion(String descripcion){
		this.descripcion=descripcion;
	}

	@Override
	public String getDescripcionLarga() {
		return descripcionLarga;
	}
	
	public void setDescripcionLarga(String descripcionLarga){
		this.descripcionLarga=descripcionLarga;
	}

	@Override
	public Long getId() {
		return id;
	}
	
	public void setId(Long id){
		this.id=id;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Integer getVersion() {
		return version;
	}


}
