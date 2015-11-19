package es.capgemini.pfs.asunto.dto;

import java.util.ArrayList;
import java.util.List;

import es.capgemini.pfs.asunto.model.DDTiposAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.Contrato;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;


public class DtoReportAsunto {

	private final EXTAsunto asunto;
	private String juzgado;
	private String numAuto;
	private String garantia;
	private String actuacionVigente;
	private String tareaPendiente;
	
	public EXTAsunto getAsunto() {
		return asunto;
	}

	public String getJuzgado() {
		return juzgado;
	}

	public void setJuzgado(String juzgado) {
		this.juzgado = juzgado;
	}

	public String getNumAuto() {
		return numAuto;
	}

	public void setNumAuto(String numAuto) {
		this.numAuto = numAuto;
	}

	public String getGarantia() {
		return garantia;
	}

	public void setGarantia(String garantia) {
		this.garantia = garantia;
	}
	
	public String getActuacionVigente() {
		return actuacionVigente;
	}

	public void setActuacionVigente(String actuacionVigente) {
		this.actuacionVigente = actuacionVigente;
	}

	public String getTareaPendiente() {
		return tareaPendiente;
	}

	public void setTareaPendiente(String tareaPendiente) {
		this.tareaPendiente = tareaPendiente;
	}
	
	/**
	 * Constructor.
	 * 
	 * @param asunto
	 */
	public DtoReportAsunto(EXTAsunto asunto) {
		this.asunto = asunto;
	
		if (asunto!=null) {
			Procedimiento ultimoPrc = asunto.getUltimoProcedimiento();
			if (ultimoPrc != null && ultimoPrc.getJuzgado() != null) {
				String juzgado = ultimoPrc.getJuzgado().getDescripcion();	
				this.setJuzgado(juzgado);
			}
			if (ultimoPrc != null && ultimoPrc.getCodigoProcedimientoEnJuzgado() != null) {
				String numAuto = ultimoPrc.getCodigoProcedimientoEnJuzgado();
				this.setNumAuto(numAuto);
			}
			//for (final Contrato c : contratos) {
			List<Contrato> contratos = new ArrayList<Contrato>();
			contratos.addAll(asunto.getContratos());
			if (contratos.size()>0) {
				Contrato contrato = contratos.get(0);
				
				if (DDTiposAsunto.LITIGIO.equals(asunto.getTipoAsunto().getCodigo()) && contrato.getGarantia1() != null) {
					garantia = contrato.getGarantia1().getDescripcion();
				}
			}
			
		}
		
	}

}
