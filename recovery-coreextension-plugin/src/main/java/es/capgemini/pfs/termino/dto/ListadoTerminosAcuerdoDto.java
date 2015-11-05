package es.capgemini.pfs.termino.dto;

import java.util.ArrayList;
import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.acuerdo.model.DDSubTipoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.capgemini.pfs.termino.model.DDEstadoGestionTermino;

public class ListadoTerminosAcuerdoDto extends WebDto{
	

	private static final long serialVersionUID = -3746399692512887715L;

	private Long id;
	
	private DDTipoAcuerdo tipoAcuerdo;
	
	private DDSubTipoAcuerdo  subTipoAcuerdo;
	
	private Float importe;
	
	private Float comisiones; 
	
	private List<EXTContrato> contratosTermino;
	
	private DDEstadoGestionTermino estadoGestion;

	public ListadoTerminosAcuerdoDto() {
		super();
		contratosTermino = new ArrayList<EXTContrato>();
	}
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public DDTipoAcuerdo getTipoAcuerdo() {
		return tipoAcuerdo;
	}

	public void setTipoAcuerdo(DDTipoAcuerdo tipoAcuerdo) {
		this.tipoAcuerdo = tipoAcuerdo;
	}

	public Float getImporte() {
		return importe;
	}

	public void setImporte(Float importe) {
		this.importe = importe;
	}

	public Float getComisiones() {
		return comisiones;
	}

	public void setComisiones(Float comisiones) {
		this.comisiones = comisiones;
	}

	public List<EXTContrato> getContratosTermino() {
		return contratosTermino;
	}

	public void setContratosTermino(List<EXTContrato> contratosTermino) {
		this.contratosTermino = contratosTermino;
	}

	public DDSubTipoAcuerdo getSubTipoAcuerdo() {
		return subTipoAcuerdo;
	}

	public void setSubTipoAcuerdo(DDSubTipoAcuerdo subTipoAcuerdo) {
		this.subTipoAcuerdo = subTipoAcuerdo;
	}
	
	public DDEstadoGestionTermino getEstadoGestion() {
		return estadoGestion;
	}

	public void setEstadoGestion(DDEstadoGestionTermino estadoGestion) {
		this.estadoGestion = estadoGestion;
	}


}
