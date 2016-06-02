package es.pfsgroup.recovery.bpmframework.run.process.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkDDTipoAccion;

@Entity
@Table(name = "IPI_INFO_PROCESADO_INPUTS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class RecoveryBPMfwkInfoProcInputs implements Serializable{
    
  //TODO - Evaluar si usamos esta clase
	private static final long serialVersionUID = -4826831110362385761L;

    @Id
    @Column(name = "IPI_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "RecoveryBPMfwkInfoProcInputsGenerator")
    @SequenceGenerator(name = "RecoveryBPMfwkInfoProcInputsGenerator", sequenceName = "S_IPI_INFO_PROCESADO_INPUTS")
    private Long id;
    
    @Column(name = "IPI_FECHA_PROCESADO")
    private Date fecha;
    
    @OneToOne
    @JoinColumn(name = "BPM_DD_TAC_ID", nullable = false)
    private RecoveryBPMfwkDDTipoAccion tipo_accion;
    
    @Column(name = "IPI_NODO_ORIGEN")
    private String nodo_origen;
    
    @Column(name = "IPI_NODO_DESTINO")
    private String nodo_destino;
    
    @Column(name = "IPI_TRANSICION")
    private String transicion;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Date getFecha() {
		return fecha == null ? null : ((Date) fecha.clone());
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha == null ? null : ((Date) fecha.clone());
	}

	public RecoveryBPMfwkDDTipoAccion getTipo_accion() {
		return tipo_accion;
	}

	public void setTipo_accion(RecoveryBPMfwkDDTipoAccion tipo_accion) {
		this.tipo_accion = tipo_accion;
	}

	public String getNodo_origen() {
		return nodo_origen;
	}

	public void setNodo_origen(String nodo_origen) {
		this.nodo_origen = nodo_origen;
	}

	public String getNodo_destino() {
		return nodo_destino;
	}

	public void setNodo_destino(String nodo_destino) {
		this.nodo_destino = nodo_destino;
	}

	public String getTransicion() {
		return transicion;
	}

	public void setTransicion(String transicion) {
		this.transicion = transicion;
	}
    

}
