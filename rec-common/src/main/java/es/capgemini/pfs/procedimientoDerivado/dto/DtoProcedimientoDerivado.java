package es.capgemini.pfs.procedimientoDerivado.dto;

import java.math.BigDecimal;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.procedimientoDerivado.model.ProcedimientoDerivado;

/**
 * Dto para Procedimientos Derivados.
 *
 * @author Lisandro Medrano
 *
 */
public class DtoProcedimientoDerivado extends WebDto {
	/**
	 * serialVersionUID.
	 */
	private static final long serialVersionUID = 4378091696318488148L;
	private static final int N = 50;
	private Long[] personas;
	private Long id;
	private Long procedimientoPadre;
	private Long procedimientoHijo;
	private String tipoActuacion;
	private String tipoReclamacion;
	private String tipoProcedimiento;
	private Integer porcentajeRecuperacion;
	private Integer plazoRecuperacion;
	private BigDecimal saldoRecuperacion;
	private String guid;
	private ProcedimientoDerivado procedimientoDerivado;
	
	@Autowired
	private ProcedimientoManager prcManager;
	
	/**
	 * constructor.
	 */
	public DtoProcedimientoDerivado() {
		personas = new Long[N];
		for (int i = 0; i < N; i++) {
			personas[i] = new Long(0);
		}
	}

	/**
	 * @return the personas
	 */
	public Long[] getPersonas() {
		return personas;
	}

	/**
	 * @param personas the personas to set
	 */
	public void setPersonas(Long[] personas) {
		this.personas = personas;
	}

	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return the procedimientoPadre
	 */
	public Long getProcedimientoPadre() {
		return procedimientoPadre;
	}

	/**
	 * @param procedimientoPadre the procedimientoPadre to set
	 */
	public void setProcedimientoPadre(Long procedimientoPadre) {
		this.procedimientoPadre = procedimientoPadre;
	}

	/**
	 * @return the tipoActuacion
	 */
	public String getTipoActuacion() {
		return tipoActuacion;
	}

	/**
	 * @param tipoActuacion the tipoActuacion to set
	 */
	public void setTipoActuacion(String tipoActuacion) {
		this.tipoActuacion = tipoActuacion;
	}

	/**
	 * @return the tipoReclamacion
	 */
	public String getTipoReclamacion() {
		return tipoReclamacion;
	}

	/**
	 * @param tipoReclamacion the tipoReclamacion to set
	 */
	public void setTipoReclamacion(String tipoReclamacion) {
		this.tipoReclamacion = tipoReclamacion;
	}

	/**
	 * @return the tipoProcedimiento
	 */
	public String getTipoProcedimiento() {
		return tipoProcedimiento;
	}

	/**
	 * @param tipoProcedimiento the tipoProcedimiento to set
	 */
	public void setTipoProcedimiento(String tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}

	/**
	 * @return the porcentajeRecuperacion
	 */
	public Integer getPorcentajeRecuperacion() {
		return porcentajeRecuperacion;
	}

	/**
	 * @param porcentajeRecuperacion the porcentajeRecuperacion to set
	 */
	public void setPorcentajeRecuperacion(Integer porcentajeRecuperacion) {
		this.porcentajeRecuperacion = porcentajeRecuperacion;
	}

	/**
	 * @return the plazoRecuperacion
	 */
	public Integer getPlazoRecuperacion() {
		return plazoRecuperacion;
	}

	/**
	 * @param plazoRecuperacion the plazoRecuperacion to set
	 */
	public void setPlazoRecuperacion(Integer plazoRecuperacion) {
		this.plazoRecuperacion = plazoRecuperacion;
	}

	/**
	 * @return the saldoRecuperacion
	 */
	public BigDecimal getSaldoRecuperacion() {
		return saldoRecuperacion;
	}

	/**
	 * @param saldoRecuperacion the saldoRecuperacion to set
	 */
	public void setSaldoRecuperacion(BigDecimal saldoRecuperacion) {
		this.saldoRecuperacion = saldoRecuperacion;
	}

	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}

	public Long getProcedimientoHijo() {
		return procedimientoHijo;
	}

	public void setProcedimientoHijo(Long procedimientoHijo) {
		this.procedimientoHijo = procedimientoHijo;
	}

	public ProcedimientoDerivado getProcedimientoDerivado() {
		return procedimientoDerivado;
	}

	public void setProcedimientoDerivado(ProcedimientoDerivado procedimientoDerivado) {
		this.procedimientoDerivado = procedimientoDerivado;
	}
}