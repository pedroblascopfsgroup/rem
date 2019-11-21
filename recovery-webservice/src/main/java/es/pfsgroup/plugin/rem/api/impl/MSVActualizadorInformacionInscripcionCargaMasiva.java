package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.DDFavorable;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdjudicacionBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionJudicial;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionNoJudicial;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadEjecutante;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAdjudicacion;

/***
 * Clase que procesa el fichero de carga masiva documentación administrativa
 */

@Component
public class MSVActualizadorInformacionInscripcionCargaMasiva extends AbstractMSVActualizador implements MSVLiberator {

	private final String VALID_OPERATION = MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_TOMA_POSESION;

	public static final class COL_NUM {

		static final int FILA_CABECERA = 0;
		static final int FILA_DATOS = 1;

		static final int NUM_COLS = 28;

		static final int ID_ACTIVO = 0;
		static final int TIPO_ADJ = 1;
		static final int F_TITULO = 2;
		static final int F_FIRMEZA_TITULO = 3;
		static final int VALOR_ADQ = 4;
		static final int NOMBRE = 5;
		static final int NUM_EXP = 6;
		static final int EXP_DEFECTOS = 7;
		static final int ENT_EJEC_HIPOTECARIA = 8;
		static final int EST_ADJ = 9;
		static final int F_AUTOADJ = 10;
		static final int F_FIRMEZA_AUTOADJ = 11;
		static final int F_SENYAL_ADJ = 12;
		static final int F_REALIZ_POS = 13;
		static final int LANZ_NECESARIO = 14;
		static final int F_SENYAL_LANZ = 15;
		static final int F_LANZ_EFECTUADO = 16;
		static final int F_SOL_MORATORIA = 17;
		static final int RES_MORATORIA = 18;
		static final int F_RES_MORATORIA = 19;
		static final int IMPORTE_ADJ = 20;
		static final int TIPO_JUZGADO = 21;
		static final int POBLACION_JUZGADO = 22;
		static final int NUM_AUTOS = 23;
		static final int PROCURADOR = 24;
		static final int LETRADO = 25;
		static final int ID_ASUNTOS = 26;
		static final int EXP_JUD_DEFECTO = 27;

	}

	@Autowired
	ProcessAdapter processAdapter;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public String getValidOperation() {
		return VALID_OPERATION;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException {

		final String ES_BORRAR = "X";

		final String celdaActivo = exc.dameCelda(fila, COL_NUM.ID_ACTIVO);
		final String celdaTipoAdjudicacion = exc.dameCelda(fila, COL_NUM.TIPO_ADJ);
		final String celdaFtitulo = exc.dameCelda(fila, COL_NUM.F_TITULO);
		final String celdaFirmezaTitulo = exc.dameCelda(fila, COL_NUM.F_FIRMEZA_TITULO);
		final String celdaValorAdquisicion = exc.dameCelda(fila, COL_NUM.VALOR_ADQ);
		final String celdaNombre = exc.dameCelda(fila, COL_NUM.NOMBRE);
		final String celdaNumExpediente = exc.dameCelda(fila, COL_NUM.NUM_EXP);
		final String celdaExpedienteDefectos = exc.dameCelda(fila, COL_NUM.EXP_DEFECTOS);
		final String celdaEntidadEjecHipotecaria = exc.dameCelda(fila, COL_NUM.ENT_EJEC_HIPOTECARIA);
		final String celdaEstadoAdj = exc.dameCelda(fila, COL_NUM.EST_ADJ);
		final String celdaFautoadj = exc.dameCelda(fila, COL_NUM.F_AUTOADJ);
		final String celdaFfirmezaAutoadj = exc.dameCelda(fila, COL_NUM.F_FIRMEZA_AUTOADJ);
		final String celdaFsenyalAdj = exc.dameCelda(fila, COL_NUM.F_SENYAL_ADJ);
		final String celdaFRealizacionPosesion = exc.dameCelda(fila, COL_NUM.F_REALIZ_POS);
		final String celdaLanzNecesario = exc.dameCelda(fila, COL_NUM.LANZ_NECESARIO);
		final String celdafSenyalLanz = exc.dameCelda(fila, COL_NUM.F_SENYAL_LANZ);
		final String celdaFlanzEfectuado = exc.dameCelda(fila, COL_NUM.F_LANZ_EFECTUADO);
		final String celdaFsolMoratoria = exc.dameCelda(fila, COL_NUM.F_SOL_MORATORIA);
		final String celdaResolucionMoratoria = exc.dameCelda(fila, COL_NUM.RES_MORATORIA);
		final String celdaFresMoratoria = exc.dameCelda(fila, COL_NUM.F_RES_MORATORIA);
		final String celdaImporteAdj = exc.dameCelda(fila, COL_NUM.IMPORTE_ADJ);
		final String celdaTipoJuzgado = exc.dameCelda(fila, COL_NUM.TIPO_JUZGADO);
		final String celdaPoblacionJuzgado = exc.dameCelda(fila, COL_NUM.POBLACION_JUZGADO);
		final String celdaNumAutos = exc.dameCelda(fila, COL_NUM.NUM_AUTOS);
		final String celdaProcurador = exc.dameCelda(fila, COL_NUM.PROCURADOR);
		final String celdaLetrado = exc.dameCelda(fila, COL_NUM.LETRADO);
		final String celdaIdAsuntos = exc.dameCelda(fila, COL_NUM.ID_ASUNTOS);
		final String celdaExpedienteJudicialDefectos = exc.dameCelda(fila, COL_NUM.EXP_JUD_DEFECTO);

		final String FILTRO_CODIGO = "codigo";
		SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy");

		// Activo
		Activo activo = activoApi.getByNumActivo(Long.parseLong(celdaActivo));
		NMBBien bien = activo.getBien();
		NMBAdjudicacionBien adjudicacionBien;

		// Tipo Adjudicacion
		Filter filtroTipoAdjudicacion = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());

		// 01-JUDICIAL
		if ("01".equals(celdaTipoAdjudicacion)) {
			ActivoAdjudicacionJudicial taJudicial = genericDao.get(ActivoAdjudicacionJudicial.class, filtroTipoAdjudicacion);

			if (Checks.esNulo(taJudicial)) {
				taJudicial = new ActivoAdjudicacionJudicial();
				taJudicial.setActivo(activo);
				taJudicial.setAuditoria(Auditoria.getNewInstance());
			}

			Filter filtroEntEjec = genericDao.createFilter(FilterType.EQUALS, FILTRO_CODIGO, celdaEntidadEjecHipotecaria);
			DDEntidadEjecutante entEjec = genericDao.get(DDEntidadEjecutante.class, filtroEntEjec);
			
			if (!Checks.esNulo(celdaEntidadEjecHipotecaria))
				taJudicial.setEntidadEjecutante(ES_BORRAR.equalsIgnoreCase(celdaImporteAdj) ? null : entEjec);

			Filter filtroEstAdj = genericDao.createFilter(FilterType.EQUALS, FILTRO_CODIGO, celdaEstadoAdj);
			DDEstadoAdjudicacion estAdj = genericDao.get(DDEstadoAdjudicacion.class, filtroEstAdj);
			
			if (!Checks.esNulo(celdaEstadoAdj))
				taJudicial.setEstadoAdjudicacion(ES_BORRAR.equalsIgnoreCase(celdaEstadoAdj) ? null : estAdj);

			if (Checks.esNulo(bien)) {
				bien = new NMBBien();
				bien.setAuditoria(Auditoria.getNewInstance());
				genericDao.save(NMBBien.class, bien);

				adjudicacionBien = new NMBAdjudicacionBien();
				adjudicacionBien.setAuditoria(Auditoria.getNewInstance());
				adjudicacionBien.setBien(bien);
				genericDao.save(NMBAdjudicacionBien.class, adjudicacionBien);
				//seteamos los campos not nullables de adjudicacion bien
				taJudicial.setAdjudicacionBien(adjudicacionBien);

			} else if (Checks.esNulo(bien.getAdjudicacion())) {
				adjudicacionBien = new NMBAdjudicacionBien();
				adjudicacionBien.setAuditoria(Auditoria.getNewInstance());
				adjudicacionBien.setBien(bien);
				genericDao.save(NMBAdjudicacionBien.class, adjudicacionBien);
				//seteamos los campos not nullables de adjudicacion bien
				taJudicial.setAdjudicacionBien(adjudicacionBien);
			} else {
				adjudicacionBien = bien.getAdjudicacion();
			}

			if (!Checks.esNulo(celdaImporteAdj))
				adjudicacionBien.setImporteAdjudicacion(ES_BORRAR.equalsIgnoreCase(celdaImporteAdj) ? BigDecimal.ZERO : new BigDecimal(celdaImporteAdj));

			if (!Checks.esNulo(celdaLanzNecesario))
				adjudicacionBien.setLanzamientoNecesario(ES_BORRAR.equalsIgnoreCase(celdaLanzNecesario) ? null : "SI".equalsIgnoreCase(celdaLanzNecesario));

			// FECHAS
			if (!Checks.esNulo(celdaFsolMoratoria))
				adjudicacionBien.setFechaSolicitudMoratoria(ES_BORRAR.equalsIgnoreCase(celdaFsolMoratoria) ? null : formato.parse(celdaFsolMoratoria));

			if (!Checks.esNulo(celdaFresMoratoria))
				adjudicacionBien.setFechaResolucionMoratoria(ES_BORRAR.equalsIgnoreCase(celdaFresMoratoria) ? null : formato.parse(celdaFresMoratoria));

			if (!Checks.esNulo(celdafSenyalLanz))
				adjudicacionBien.setFechaSenalamientoLanzamiento(ES_BORRAR.equalsIgnoreCase(celdafSenyalLanz) ? null : formato.parse(celdafSenyalLanz));

			if (!Checks.esNulo(celdaFsenyalAdj))
				adjudicacionBien.setFechaSenalamientoPosesion(ES_BORRAR.equalsIgnoreCase(celdaFsenyalAdj) ? null : formato.parse(celdaFsenyalAdj));

			if (!Checks.esNulo(celdaFfirmezaAutoadj))
				adjudicacionBien.setFechaDecretoFirme(ES_BORRAR.equalsIgnoreCase(celdaFfirmezaAutoadj) ? null : formato.parse(celdaFfirmezaAutoadj));

			if (!Checks.esNulo(celdaFRealizacionPosesion))
				adjudicacionBien.setFechaRealizacionPosesion(ES_BORRAR.equalsIgnoreCase(celdaFRealizacionPosesion) ? null : formato.parse(celdaFRealizacionPosesion));

			if (!Checks.esNulo(celdaFlanzEfectuado))
				adjudicacionBien.setFechaRealizacionLanzamiento(ES_BORRAR.equalsIgnoreCase(celdaFlanzEfectuado) ? null : formato.parse(celdaFlanzEfectuado));

			if (!Checks.esNulo(celdaResolucionMoratoria)) {
				Filter filtroResMor = genericDao.createFilter(FilterType.EQUALS, FILTRO_CODIGO, celdaResolucionMoratoria);
				DDFavorable resMor = genericDao.get(DDFavorable.class, filtroResMor);
				adjudicacionBien.setResolucionMoratoria(ES_BORRAR.equalsIgnoreCase(celdaResolucionMoratoria) ? null : resMor);
			}
			
			//SETEAMOS TODOS LOS CAMPOS REQUERIDOS EN LA TABLA BIE_AJD_ADJUDICACION
			taJudicial.setAdjudicacionBien(adjudicacionBien);

			if (!Checks.esNulo(celdaPoblacionJuzgado)) {
				Filter filtroPob = genericDao.createFilter(FilterType.EQUALS, FILTRO_CODIGO, celdaPoblacionJuzgado);
				TipoPlaza poblacion = genericDao.get(TipoPlaza.class, filtroPob);
				taJudicial.setPlazaJuzgado(ES_BORRAR.equalsIgnoreCase(celdaPoblacionJuzgado) ? null : poblacion);
			}
			
			if (!Checks.esNulo(celdaTipoJuzgado)) {
				Filter filtroTipoJuz = genericDao.createFilter(FilterType.EQUALS, FILTRO_CODIGO, celdaTipoJuzgado);
				TipoJuzgado tipoJuzgado = genericDao.get(TipoJuzgado.class, filtroTipoJuz);
				taJudicial.setJuzgado(ES_BORRAR.equalsIgnoreCase(celdaTipoJuzgado) ? null : tipoJuzgado);
			}
			
			if (!Checks.esNulo(celdaNumAutos))
				taJudicial.setNumAuto(ES_BORRAR.equalsIgnoreCase(celdaNumAutos) ? null : celdaNumAutos);

			if (!Checks.esNulo(celdaProcurador))
				taJudicial.setProcurador(ES_BORRAR.equalsIgnoreCase(celdaProcurador) ? null : celdaProcurador);

			if (!Checks.esNulo(celdaLetrado))
				taJudicial.setLetrado(ES_BORRAR.equalsIgnoreCase(celdaLetrado) ? null : celdaLetrado);

			if (!Checks.esNulo(celdaIdAsuntos))
				taJudicial.setIdAsunto(
						ES_BORRAR.equalsIgnoreCase(celdaIdAsuntos) ? null : Long.parseLong(celdaIdAsuntos));

			if (!Checks.esNulo(celdaExpedienteJudicialDefectos))
				taJudicial.setDefectosTestimonio(ES_BORRAR.equalsIgnoreCase(celdaExpedienteJudicialDefectos) ? null : "SI".equalsIgnoreCase(celdaExpedienteJudicialDefectos) ? 1L : 0);

			if (!Checks.esNulo(celdaFautoadj))
				taJudicial.setFechaAdjudicacion(ES_BORRAR.equalsIgnoreCase(celdaFautoadj) ? null : formato.parse(celdaFautoadj));

			genericDao.save(ActivoAdjudicacionJudicial.class, taJudicial);

			//02 NOTARIAL
		} else if ("02".equals(celdaTipoAdjudicacion)) {
			ActivoAdjudicacionNoJudicial taNotarial = genericDao.get(ActivoAdjudicacionNoJudicial.class, filtroTipoAdjudicacion);

			if (Checks.esNulo(taNotarial)) {
				taNotarial = new ActivoAdjudicacionNoJudicial();
				taNotarial.setActivo(activo);
				taNotarial.setAuditoria(Auditoria.getNewInstance());
			}

			if (!Checks.esNulo(celdaFtitulo))
				taNotarial.setFechaTitulo(ES_BORRAR.equalsIgnoreCase(celdaFtitulo) ? null : formato.parse(celdaFtitulo));

			if (!Checks.esNulo(celdaFirmezaTitulo))
				taNotarial.setFechaFirmaTitulo(ES_BORRAR.equalsIgnoreCase(celdaFirmezaTitulo) ? null : formato.parse(celdaFirmezaTitulo));

			if (!Checks.esNulo(celdaValorAdquisicion))
				taNotarial.setValorAdquisicion(ES_BORRAR.equalsIgnoreCase(celdaValorAdquisicion) ? null : Double.valueOf(celdaValorAdquisicion.replace(",", ".")));

			if (!Checks.esNulo(celdaNombre))
				taNotarial.setTramitadorTitulo(ES_BORRAR.equalsIgnoreCase(celdaNombre) ? null : celdaNombre);

			if (!Checks.esNulo(celdaNumExpediente))
				taNotarial.setNumReferencia(ES_BORRAR.equalsIgnoreCase(celdaNumExpediente) ? null : celdaNumExpediente);

			if (!Checks.esNulo(celdaExpedienteDefectos))
				taNotarial.setDefectosTestimonio(ES_BORRAR.equalsIgnoreCase(celdaExpedienteDefectos) ? null : "SI".equalsIgnoreCase(celdaExpedienteDefectos) ? 1L : 0);

			genericDao.save(ActivoAdjudicacionNoJudicial.class, taNotarial);
		}

		return new ResultadoProcesarFila();
	}

}
