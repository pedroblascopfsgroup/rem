package es.pfsgroup.plugin.recovery.masivo.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = "V_MSV_BUSQUEDA_ASUNTOS_USUARIO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class MSVAsunto implements Serializable {

	private static final long serialVersionUID = -439719528066680157L;

	@Id
	@Column(name = "ID_")
	private Long id;
	
    @Column(name = "ASU_ID")
	private Long idAsunto;
	
	@Column(name = "PRC_ID")
	private Long idProcedimiento;
	
    @Column(name = "ASU_NOMBRE")
	private String nombre;
	
    @Column(name = "PLAZA")
	private String plaza;
	
    @Column(name = "JUZGADO")
	private String juzgado;
	
    @Column(name = "AUTO")
	private String auto;
    
    @Column(name = "PRINCIPAL")
	private Double principal;
    
    @Column(name = "TIPO_PRC")
    private String tipoPrc;
    
    @Column(name ="TEX_ID")
    private Long idTarea;

    @Column(name ="USU_ID")
    private Long idUsuario;

    @Column(name = "DES_ESTADO_PRC")
    private String desEstadoPrc;
    
    @Column(name = "COD_ESTADO_PRC")
    private String codEstadoPrc;
    
    @Column(name = "TAR_TAREA")
    private String tarTarea;
    
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdAsunto() {
		return idAsunto;
	}

	public void setIdAsunto(Long idAsunto) {
		this.idAsunto = idAsunto;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
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

	public String getAuto() {
		return auto;
	}

	public void setAuto(String auto) {
		this.auto = auto;
	}

	public Long getIdProcedimiento() {
		return idProcedimiento;
	}

	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}

	public Double getPrincipal() {
		return principal;
	}

	public void setPrincipal(Double principal) {
		this.principal = principal;
	}

	public String getTipoPrc() {
		return tipoPrc;
	}

	public void setTipoPrc(String tipoPrc) {
		this.tipoPrc = tipoPrc;
	}

	public Long getIdTarea() {
		return idTarea;
	}

	public void setIdTarea(Long idTarea) {
		this.idTarea = idTarea;
	}

	public Long getIdUsuario() {
		return idUsuario;
	}

	public void setIdUsuario(Long idUsuario) {
		this.idUsuario = idUsuario;
	}

	public String getDesEstadoPrc() {
		return desEstadoPrc;
	}

	public void setDesEstadoPrc(String desEstadoPrc) {
		this.desEstadoPrc = desEstadoPrc;
	}

	public String getCodEstadoPrc() {
		return codEstadoPrc;
	}

	public void setCodEstadoPrc(String codEstadoPrc) {
		this.codEstadoPrc = codEstadoPrc;
	}
	
	public String getTarTarea() {
		return tarTarea;
	}

	public void setTarTarea(String tarTarea) {
		this.tarTarea = tarTarea;
	}


}