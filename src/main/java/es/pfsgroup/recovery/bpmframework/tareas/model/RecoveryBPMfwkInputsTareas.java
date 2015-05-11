package es.pfsgroup.recovery.bpmframework.tareas.model;

import java.io.Serializable;

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

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;

@Entity
@Table(name = "ITA_INPUTS_TAREAS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class RecoveryBPMfwkInputsTareas implements Serializable{
    
  
	private static final long serialVersionUID = -4826831110362385761L;

    @Id
    @Column(name = "ITA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "RecoveryBPMfwkInputsTareasGenerator")
    @SequenceGenerator(name = "RecoveryBPMfwkInputsTareasGenerator", sequenceName = "S_ITA_INPUTS_TAREAS")
    private Long id;
    
    @OneToOne
    @JoinColumn(name = "BPM_IPT_ID", nullable = false)
    private RecoveryBPMfwkInput input;

    @OneToOne
    @JoinColumn(name = "TEX_ID", nullable = false)
    private TareaExterna tarea;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public RecoveryBPMfwkInput getInput() {
		return input;
	}

	public void setInput(RecoveryBPMfwkInput input) {
		this.input = input;
	}

	public TareaExterna getTarea() {
		return tarea;
	}

	public void setTarea(TareaExterna tarea) {
		this.tarea = tarea;
	}

}