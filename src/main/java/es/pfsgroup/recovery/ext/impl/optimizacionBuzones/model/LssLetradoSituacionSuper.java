//package es.pfsgroup.recovery.ext.impl.optimizacionBuzones.model;
//
//import javax.persistence.Column;
//import javax.persistence.Entity;
//import javax.persistence.Id;
//import javax.persistence.Table;
//
//import org.hibernate.annotations.Cache;
//import org.hibernate.annotations.CacheConcurrencyStrategy;
//
///**
// * Tabla que contiene los letrados activos/inactivos
// * 
// * @author bruno
// * 
// */
//@Entity
//@Table(name = "LSS_LETRADO_SITUACION_SUPER", schema = "${entity.schema}")
//@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
//public class LssLetradoSituacionSuper {
//
//	@Id
//	@Column(name = "LET_ID")
//	private Long idLetrado;
//
//	@Column(name = "LET_ACTIVO")
//	private Integer letradoActivo;
//
//	@Column(name = "SUP_ID")
//	private Long idSupervisor;
//
//	public Long getIdidLetrado() {
//		return idLetrado;
//	}
//
//	public void setIdidLetrado(Long idLetrado) {
//		this.idLetrado = idLetrado;
//	}
//
//	public Integer getLetradoActivo() {
//		return letradoActivo;
//	}
//
//	public void setLetradoActivo(Integer letradoActivo) {
//		this.letradoActivo = letradoActivo;
//	}
//
//	public Long getIdSupervisor() {
//		return idSupervisor;
//	}
//
//	public void setIdSupervisor(Long idSupervisor) {
//		this.idSupervisor = idSupervisor;
//	}
//}
