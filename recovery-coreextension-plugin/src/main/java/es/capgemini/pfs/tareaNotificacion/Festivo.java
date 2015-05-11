package es.capgemini.pfs.tareaNotificacion;

import java.io.Serializable;
import java.util.Date;
import java.util.GregorianCalendar;

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

import com.sun.istack.NotNull;


import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "FES_FESTIVOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Festivo implements Serializable, Auditable{

	private static final long serialVersionUID = 4322133892318301762L;

	@Id
	@Column(name = "FES_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "FestivoGenerator")
	@SequenceGenerator(name = "FestivoGenerator", sequenceName = "S_FES_FESTIVOS")
	private Long id;

	@Column(name = "FES_YEAR")
	@NotNull
	private Integer year;

	@Column(name = "FES_MONTH")
	@NotNull
	private Integer month;

	@Column(name = "FES_DAY_START")
	@NotNull
	private Integer dayStart;

	@Column(name = "FES_DAY_END")
	@NotNull
	private Integer dayEnd;

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

	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public void setYear(Integer year) {
		this.year = year;
	}

	public Integer getYear() {
		return year;
	}

	public void setMonth(Integer month) {
		this.month = month;
	}

	public Integer getMonth() {
		return month;
	}

	public void setDayStart(Integer dayStart) {
		this.dayStart = dayStart;
	}

	public Integer getDayStart() {
		return dayStart;
	}

	public void setDayEnd(Integer dayEnd) {
		this.dayEnd = dayEnd;
	}

	public Integer getDayEnd() {
		return dayEnd;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Integer getVersion() {
		return version;
	}
	
	/**
	 * Devuelve el siguiente Día hábil
	 * 
	 * @return
	 */
	public Date siguienteHabil() {
		GregorianCalendar cal = new GregorianCalendar(year, month - 1,
				dayEnd + 1);
		return cal.getTime();
	}

}
