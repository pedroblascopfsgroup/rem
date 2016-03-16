package es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.bienes;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBInformacionRegistralBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBValoracionesBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.bienes.dto.BienCargaDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.bienes.dto.BienProcedimientoDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.bienes.dto.PropuestaCancelacionCargasDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDSituacionCarga;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdicionalBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdjudicacionBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienCargas;

@Component
public class InformePropuestaCancelacionBean {
	
	private static String TIPO_CARGA_ANTERIOR = "ANT";

	public List<Object> create(NMBBien bien) {
		// Dto para nutrir el reporte de informacion de diferntes tablas.
		PropuestaCancelacionCargasDto reportDto = new PropuestaCancelacionCargasDto();

		// NMBBien
		reportDto.setnActivo(bien.getNumeroActivo());
		reportDto.setFichaInmovilizado("");
		reportDto.setDescripcion(bien.getDescripcion());

		// NMBInformacionRegistralBienInfo
		NMBInformacionRegistralBienInfo infoRegistralBien = bien.getDatosRegistralesActivo();
		if (infoRegistralBien != null) {
			reportDto.setNumFinca(infoRegistralBien.getNumFinca());
			reportDto.setNumRegistro(infoRegistralBien.getNumRegistro());
			reportDto.setMunicipio(infoRegistralBien.getMunicipoLibro());
		}

		// NMBValoracionesBienInfo
		NMBValoracionesBienInfo valoracionesBien = bien.getValoracionActiva();
		if (valoracionesBien != null && !Checks.esNulo(valoracionesBien.getImporteValorTasacion())) {
			reportDto.setImporteTasacion(valoracionesBien.getImporteValorTasacion().floatValue());
		}

		// NMBAdjudicacionBien
		NMBAdjudicacionBien adjudicacionBien = bien.getAdjudicacion();
		if (adjudicacionBien != null) {
			reportDto.setImporteAdjudicacion(adjudicacionBien.getImporteAdjudicacion());
		}

		// NMBAdicionalBien
		NMBAdicionalBien adicionalBien = bien.getAdicional();
		if (adicionalBien != null) {
			reportDto.setObservaciones(adicionalBien.getObservaciones());
			reportDto.setResumen(adicionalBien.getCancelacionResumen());
			reportDto.setPropuesta(adicionalBien.getCancelacionPropuesta());
		}

		// NMBBienCargas
		reportDto.setCargas(obtenerCargasParaInforme(bien));
		reportDto.setProcedimientos(obtenerProcedimientosParaInforme(bien));

		return Arrays.asList((Object) reportDto);
	}

	private List<BienCargaDto> obtenerCargasParaInforme(NMBBien bien) {
		List<BienCargaDto> reportCargasDto = new ArrayList<BienCargaDto>();

		for (NMBBienCargas bienCarga : bien.getBienCargas()) {
			if (TIPO_CARGA_ANTERIOR.equals(bienCarga.getTipoCarga().getCodigo())) {
				// se crean varios objetos dependiendo del tipo de importe de la carga.
				if (bienCarga.getRegistral() && DDSituacionCarga.ACEPTADA.equals(bienCarga.getSituacionCarga().getCodigo())) {
					BienCargaDto cargaDto = new BienCargaDto();
					cargaDto.setTipoCarga(BienCargaDto.REGISTRAL);
					cargaDto.setAcreedor(bienCarga.getTitular());
					cargaDto.setImporte(bienCarga.getImporteRegistral());
					reportCargasDto.add(cargaDto);
				}

				if (bienCarga.isEconomica() && DDSituacionCarga.ACEPTADA.equals(bienCarga.getSituacionCargaEconomica().getCodigo())) {
					BienCargaDto cargaDto = new BienCargaDto();
					cargaDto.setTipoCarga(BienCargaDto.ECONOMICA);
					cargaDto.setAcreedor(bienCarga.getTitular());
					cargaDto.setImporte(bienCarga.getImporteEconomico());
					reportCargasDto.add(cargaDto);
				}
			}
		}
		return reportCargasDto;
	}

	private List<BienProcedimientoDto> obtenerProcedimientosParaInforme(NMBBien bien) {
		Set<BienProcedimientoDto> procedimientosParaInforme = new HashSet<BienProcedimientoDto>();

		for (ProcedimientoBien procedimientoBien : bien.getProcedimientos()) {
			BienProcedimientoDto bienProcedimientoDto = obtenerDatosProcedimientoBien(procedimientoBien);

			// Los procedimientos a incluir en el informe deben de ser unicos.
			if (bienProcedimientoDto != null && !procedimientosParaInforme.contains(bienProcedimientoDto)) {
				procedimientosParaInforme.add(bienProcedimientoDto);
			}
		}
		return new ArrayList<BienProcedimientoDto>(procedimientosParaInforme);
	}

	private BienProcedimientoDto obtenerDatosProcedimientoBien(ProcedimientoBien procedimientoBien) {
		Procedimiento procedimiento = procedimientoBien.getProcedimiento();

		// Se debe de mostrar un procedimiento siempre y cuando, el asunto este aceptado
		if (procedimiento != null && procedimiento.getAsunto() != null && procedimiento.getAsunto().getEstaAceptado()) {
			BienProcedimientoDto bienProcedimientoDto = new BienProcedimientoDto();

			bienProcedimientoDto.setAsunto(procedimiento.getAsunto().getId().toString());
			bienProcedimientoDto.setAutos(procedimiento.getCodigoProcedimientoEnJuzgado());

			if (procedimiento.getJuzgado() != null) {
				TipoJuzgado juzgado =  procedimiento.getJuzgado();
				bienProcedimientoDto.setJuzgado(juzgado.getDescripcion());
				bienProcedimientoDto.setPlaza(juzgado.getPlaza() != null ? juzgado.getPlaza().getDescripcion() : null);
			}
			return bienProcedimientoDto;
		}
		return null;
	}
}
