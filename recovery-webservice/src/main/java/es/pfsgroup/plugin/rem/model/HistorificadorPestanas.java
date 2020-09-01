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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDPestanas;


@Entity
@Table(name = "TBJ_HPE_HISTORIFICADOR_PESTANAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class HistorificadorPestanas  implements Serializable, Auditable{
	
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "HPE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "HistorificadorPestanasGenerator")
    @SequenceGenerator(name = "HistorificadorPestanasGenerator", sequenceName = "S_TBJ_HPE_HISTORIFICADOR_PESTANAS")
	private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TBJ_ID")
	private Trabajo trabajo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PES_ID")
	private DDPestanas pestana;
	
	@Column(name = "CAMPO")
	private String campo;
	
	@Column(name = "TABLA")
	private String tabla;
	
	@Column(name = "COLUMNA")
	private String columna;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "USU_ID")
	private Usuario usuario;
	
	@Column(name = "FECHA_MODICACION")
	private Date fechaModificacion;
	
	@Column(name = "VALOR_ANTERIOR")
	private String valorAnterior;
	
	@Column(name = "VALOR_NUEVO")
	private String valorNuevo;
	
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

	public Trabajo getTrabajo() {
		return trabajo;
	}

	public void setTrabajo(Trabajo trabajo) {
		this.trabajo = trabajo;
	}

	public DDPestanas getPestana() {
		return pestana;
	}

	public void setPestana(DDPestanas pestana) {
		this.pestana = pestana;
	}

	public String getCampo() {
		return campo;
	}

	public void setCampo(String campo) {
		this.campo = campo;
	}

	public String getTabla() {
		return tabla;
	}

	public void setTabla(String tabla) {
		this.tabla = tabla;
	}

	public String getColumna() {
		return columna;
	}

	public void setColumna(String columna) {
		this.columna = columna;
	}

	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}

	public Date getFechaModificacion() {
		return fechaModificacion;
	}

	public void setFechaModificacion(Date fechaModificacion) {
		this.fechaModificacion = fechaModificacion;
	}

	public String getValorAnterior() {
		return valorAnterior;
	}

	public void setValorAnterior(String valorAnterior) {
		this.valorAnterior = valorAnterior;
	}

	public String getValorNuevo() {
		return valorNuevo;
	}

	public void setValorNuevo(String valorNuevo) {
		this.valorNuevo = valorNuevo;
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
