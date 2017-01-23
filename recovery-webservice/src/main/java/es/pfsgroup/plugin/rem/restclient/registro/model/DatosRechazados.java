package es.pfsgroup.plugin.rem.restclient.registro.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "RST_DATOS_RECHAZADOS", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class DatosRechazados implements Serializable, Auditable {

	private static final long serialVersionUID = 6883711571546595188L;

	@Embedded
	private Auditoria auditoria;
	
	@Id
	@Column(name = "RDR_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "datoRechazadoGenerator")
	@SequenceGenerator(name = "datoRechazadoGenerator", sequenceName = "S_RST_DATOS_RECHAZADOS")
	private Long id;
	
	@Column(name = "RDR_VISTA")
	private String vista;
	
	@Column(name = "RDR_ID_OBJETO")
	private Long idObjeto;
	
	@Column(name = "RDR_DATOS_INVALIDOS")
	private String datosInvalidos;
	
	@Column(name = "RST_ITERACION")
	private Long iteracion;
	
	

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getVista() {
		return vista;
	}

	public void setVista(String vista) {
		this.vista = vista;
	}

	public Long getIdObjeto() {
		return idObjeto;
	}

	public void setIdObjeto(Long idObjeto) {
		this.idObjeto = idObjeto;
	}

	public String getDatosInvalidos() {
		return datosInvalidos;
	}

	public void setDatosInvalidos(String datosInvalidos) {
		this.datosInvalidos = datosInvalidos;
	}
	
	public Long getIteracion() {
		return iteracion;
	}

	public void setIteracion(Long iteracion) {
		this.iteracion = iteracion;
	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;

	}

}
