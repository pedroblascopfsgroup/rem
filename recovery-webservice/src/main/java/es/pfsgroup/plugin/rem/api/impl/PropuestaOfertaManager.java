package es.pfsgroup.plugin.rem.api.impl;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import es.pfsgroup.plugin.rem.api.*;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionJudicial;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoDistribucion;
import es.pfsgroup.plugin.rem.model.ActivoEdificio;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.ActivoVivienda;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoCliente;
import es.pfsgroup.plugin.rem.model.DtoDataSource;
import es.pfsgroup.plugin.rem.model.DtoHonorarios;
import es.pfsgroup.plugin.rem.model.DtoOferta;
import es.pfsgroup.plugin.rem.model.DtoTasacionInforme;
import es.pfsgroup.plugin.rem.model.DtoVisita;
import es.pfsgroup.plugin.rem.model.DtoVisitasFilter;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.TextosOferta;
import es.pfsgroup.plugin.rem.model.VBusquedaDatosCompradorExpediente;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionesPosesoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoFoto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoHabitaculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPorCuenta;
import es.pfsgroup.plugin.rem.model.dd.DDTiposTextoOferta;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.OfertaSimpleDto;
import es.pfsgroup.plugin.rem.utils.FileUtilsREM;

@Service("propuestaOfertaManager")
public class PropuestaOfertaManager implements PropuestaOfertaApi {

	private final Log logger = LogFactory.getLog(getClass());

	private final String NOT_AVAILABLE_ROOM = "NO";

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ActivoDao activoDao;

	@Autowired
	private RestApi restApi;

	@Autowired
	private VisitaApi visitaApi;

	@Autowired
	private ActivoAdapter activoAdapter;

	@Autowired
	private ActivoEstadoPublicacionApi activoEstadoPublicacionApi;

	@Override
	public HashMap<String, String> validatePropuestaOfertaRequestData(OfertaSimpleDto ofertaSimpleDto,
			Object jsonFields) throws Exception {
		HashMap<String, String> errorsList = null;
		Oferta oferta = null;
		ExpedienteComercial expediente = null;
		CondicionanteExpediente condExp = null;
		List<ActivoOferta> listaActivos = null;

		errorsList = restApi.validateRequestObject(ofertaSimpleDto, TIPO_VALIDACION.INSERT);

		oferta = ofertaApi.getOfertaByNumOfertaRem(ofertaSimpleDto.getOfertaHRE());
		if (Checks.esNulo(oferta)) {
			errorsList.put("ofertaHRE", RestApi.REST_MSG_UNKNOWN_KEY);
		} else {
			listaActivos = oferta.getActivosOferta();
			if (Checks.esNulo(listaActivos) || (!Checks.esNulo(listaActivos) && listaActivos.size() < 1)) {
				errorsList.put("ofertaHRE", RestApi.REST_NO_RELATED_ASSET);
			}
			if (Checks.esNulo(oferta.getEstadoOferta()) || (!Checks.esNulo(oferta.getEstadoOferta())
					&& !oferta.getEstadoOferta().getCodigo().equalsIgnoreCase(DDEstadoOferta.CODIGO_ACEPTADA))) {
				errorsList.put("ofertaHRE", RestApi.REST_NO_RELATED_OFFER_ACCEPTED);
			}
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
			expediente = (ExpedienteComercial) genericDao.get(ExpedienteComercial.class, filtro);
			if (Checks.esNulo(expediente)) {
				errorsList.put("ofertaHRE", RestApi.REST_NO_RELATED_EXPEDIENT);
			} else {
				condExp = expediente.getCondicionante();
				if (Checks.esNulo(condExp)) {
					errorsList.put("ofertaHRE", RestApi.REST_NO_RELATED_COND_EXPEDIENT);
				}
			}

		}
		return errorsList;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> paramsHojaDatos(ActivoOferta activoOferta, ModelMap model) throws Exception {
		logger.debug("------------ Llamada paramsHojaDatos-----------------");

		Activo activo = null;
		Oferta oferta = null;
		List<ActivoOferta> listaActivos = null;
		int contEdi = 0;
		int contViv = 0;
		int contCom = 0;
		int contInd = 0;
		int contSue = 0;
		int contVar = 0;
		int contDispJur = 0;
		Map<String, Object> mapaValores = new HashMap<String, Object>();

		if (!Checks.esNulo(activoOferta)) {
			activo = activoOferta.getPrimaryKey().getActivo();
			oferta = activoOferta.getPrimaryKey().getOferta();
		}
		if (Checks.esNulo(activo)) {
			model.put("error", RestApi.REST_NO_RELATED_ASSET);
			throw new Exception(RestApi.REST_NO_RELATED_ASSET);
		}
		if (Checks.esNulo(oferta)) {
			model.put("error", RestApi.REST_NO_RELATED_ASSET);
			throw new Exception(RestApi.REST_NO_RELATED_ASSET);
		}
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
		ExpedienteComercial expediente = (ExpedienteComercial) genericDao.get(ExpedienteComercial.class, filtro);
		if (Checks.esNulo(expediente)) {
			model.put("error", RestApi.REST_NO_RELATED_EXPEDIENT);
			throw new Exception(RestApi.REST_NO_RELATED_EXPEDIENT);
		}

		CondicionanteExpediente condExp = expediente.getCondicionante();
		if (Checks.esNulo(condExp)) {
			model.put("error", RestApi.REST_NO_RELATED_EXPEDIENT);
			throw new Exception(RestApi.REST_NO_RELATED_EXPEDIENT);
		}

		// HEADER
		mapaValores.put("NumOfProp", oferta.getNumOferta() + "/1");
		mapaValores.put("Activo", activo.getNumActivo().toString());
		mapaValores.put("FRecepOf", FileUtilsREM.stringify(oferta.getFechaAlta()));
		mapaValores.put("FProp", FileUtilsREM.stringify(new Date()));

		// Si el tipo es nulo, por defecto, se entiende como tipo RETAIL
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTOR_COMERCIAL);

		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
		if (Checks.esNulo(tipoGestor)) {
			mapaValores.put("Gestor", FileUtilsREM.stringify(null));
		} else if (gestorActivoApi.getGestorByActivoYTipo(activo, tipoGestor.getId()) != null) {
			mapaValores.put("Gestor",
					gestorActivoApi.getGestorByActivoYTipo(activo, tipoGestor.getId()).getApellidoNombre());
		} else {
			mapaValores.put("Gestor", FileUtilsREM.stringify(null));
		}

		mapaValores.put("FPublWeb", FileUtilsREM.stringify(activoEstadoPublicacionApi.getFechaInicioEstadoActualPublicacionVenta(activo.getId())));

		mapaValores.put("NumVisitasWeb", FileUtilsREM.stringify(activo.getVisitas().size()));

		// CARACTERISTICAS INMUEBLE
		mapaValores.put("Direccion", FileUtilsREM.stringify(activo.getDireccion()));
		if (activo.getTipoActivo() != null) {
			mapaValores.put("Tipo", FileUtilsREM.stringify(activo.getTipoActivo().getDescripcionLarga()));
		} else {
			mapaValores.put("Tipo", FileUtilsREM.stringify(null));
		}
		if (activo.getSubtipoActivo() != null) {
			mapaValores.put("Subtipo", FileUtilsREM.stringify(activo.getSubtipoActivo().getDescripcionLarga()));
		} else {
			mapaValores.put("Subtipo", FileUtilsREM.stringify(null));
		}
		if (activo.getTipoUsoDestino() != null) {
			mapaValores.put("Residencia", activo.getTipoUsoDestino().getDescripcionLarga());
		} else {
			mapaValores.put("Residencia", FileUtilsREM.stringify(null));
		}
		List<ActivoAdmisionDocumento> listaAdmisionDocumento = activo.getAdmisionDocumento();
		boolean isFoundCalificacion = false;
		if (!Checks.esNulo(listaAdmisionDocumento)) {
			for (int m = 0; m < listaAdmisionDocumento.size(); m++) {
				ActivoAdmisionDocumento admisionDocumento = listaAdmisionDocumento.get(m);
				if (!Checks.esNulo(admisionDocumento)
						&& !Checks.esNulo(admisionDocumento.getTipoCalificacionEnergetica())
						&& !Checks.esNulo(admisionDocumento.getEstadoDocumento())
						&& (DDEstadoDocumento.CODIGO_ESTADO_OBTENIDO
								.equals(admisionDocumento.getEstadoDocumento().getCodigo())
								|| DDEstadoDocumento.CODIGO_ESTADO_EN_TRAMITE
										.equals(admisionDocumento.getEstadoDocumento().getCodigo()))) {
					mapaValores.put("CertificadoEnergetico",
							admisionDocumento.getTipoCalificacionEnergetica().getDescripcionLarga());
					isFoundCalificacion = true;
				}
			}
		}
		if (!isFoundCalificacion) {
			mapaValores.put("CertificadoEnergetico", FileUtilsREM.stringify(null));
		}
		mapaValores.put("SuperficieConstruida", FileUtilsREM.stringify(activo.getTotalSuperficieConstruida()));
		// mapaValores.put("SuperficieUtil",FileUtilsREM.stringify(activo.getTotalSuperficieUtil()));
		// mapaValores.put("SuperficieRegistro",FileUtilsREM.stringify(activo.getTotalSuperficieSuelo()));
		mapaValores.put("Parcela", FileUtilsREM.stringify(activo.getTotalSuperficieParcela()));
		List<ActivoPropietarioActivo> listaPropietarios = activo.getPropietariosActivo();
		if (!Checks.esNulo(listaPropietarios) && listaPropietarios.size() > 0
				&& !Checks.esNulo(listaPropietarios.get(0)) && !Checks.esNulo(listaPropietarios.get(0).getPropietario())
				&& !Checks.esNulo(listaPropietarios.get(0).getPropietario().getFullName())) {
			mapaValores.put("SociedadPatrimonial", listaPropietarios.get(0).getPropietario().getFullName());
		} else {
			mapaValores.put("SociedadPatrimonial", FileUtilsREM.stringify(null));
		}

		// NEGOCIACION URBANISTICA
		if (!Checks.esNulo(activo.getInfoAdministrativa())
				&& !Checks.esNulo(activo.getInfoAdministrativa().getTipoVpo())) {
			mapaValores.put("regimenProteccion",
					FileUtilsREM.stringify(activo.getInfoAdministrativa().getTipoVpo().getDescripcion()));
		} else {
			mapaValores.put("regimenProteccion", FileUtilsREM.stringify(null));
		}

		if (condExp.getProcedeDescalificacion() != null && condExp.getProcedeDescalificacion().equals(new Integer(1))) {
			mapaValores.put("procederDescalificacion", "si");
		} else {
			mapaValores.put("procederDescalificacion", "no");
		}
		mapaValores.put("licencia", FileUtilsREM.stringify(condExp.getLicencia()));
		if (condExp.getTipoPorCuentaLicencia() != null) {
			mapaValores.put("cargo", FileUtilsREM.stringify(condExp.getTipoPorCuentaLicencia().getDescripcion()));
		} else {
			mapaValores.put("cargo", FileUtilsREM.stringify(null));
		}

		NMBBien bien = activo.getBien();
		if (!Checks.esNulo(bien) && !Checks.esNulo(bien.getDatosRegistrales())) {
			mapaValores.put("FincaRegistral", FileUtilsREM.stringify(bien.getDatosRegistrales()));
		} else {
			mapaValores.put("FincaRegistral", FileUtilsREM.stringify(null));
		}

		if (activo.getInfoComercial() != null) {
			mapaValores.put("FRecepcionLlaves",
					FileUtilsREM.stringify(activo.getInfoComercial().getFechaRecepcionLlaves()));
		} else {
			mapaValores.put("FRecepcionLlaves", FileUtilsREM.stringify(null));
		}
		ActivoAdjudicacionJudicial adjudicacionJudicial = activo.getAdjJudicial();
		if (adjudicacionJudicial != null) {
			mapaValores.put("FEntradaCartera", FileUtilsREM.stringify(adjudicacionJudicial.getFechaAdjudicacion()));
			if (adjudicacionJudicial.getEstadoAdjudicacion() != null) {
				mapaValores.put("SituacionProcesal",
						FileUtilsREM.stringify(adjudicacionJudicial.getEstadoAdjudicacion().getDescripcion()));
			} else {
				mapaValores.put("SituacionProcesal", FileUtilsREM.stringify(null));
			}
		} else {
			mapaValores.put("FEntradaCartera", FileUtilsREM.stringify(null));
			mapaValores.put("SituacionProcesal", FileUtilsREM.stringify(null));
		}

		boolean estaInscrito = false;
		boolean estaLiquidado = false;
		if (activo.getAdjJudicial() != null && activo.getAdjJudicial().getAdjudicacionBien() != null) {
			estaInscrito = (activo.getAdjJudicial().getAdjudicacionBien().getFechaPresentacionIns() != null);
			estaLiquidado = (activo.getAdjJudicial().getAdjudicacionBien().getFechaPresentacionHacienda() != null);
			if (activo.getAdjJudicial().getAdjudicacionBien().getFechaRealizacionPosesion() != null) {
				mapaValores.put("Disponibilidadjuridica", "Disponible");
			} else {
				mapaValores.put("Disponibilidadjuridica", "No disponible.");
			}
		} else {
			mapaValores.put("Disponibilidadjuridica", FileUtilsREM.stringify(null));
		}
		if (estaInscrito && estaLiquidado) {
			mapaValores.put("SituacionLiquidacionInscripcion", "Titulo inscrito y liquidado.");
		} else if (!estaInscrito && estaLiquidado) {
			mapaValores.put("SituacionLiquidacionInscripcion", "Titulo liquidado pero no inscrito.");
		} else if (estaInscrito && !estaLiquidado) {
			mapaValores.put("SituacionLiquidacionInscripcion", "Titulo inscrito pero no liquidado.");
		} else if (!estaInscrito && !estaLiquidado) {
			mapaValores.put("SituacionLiquidacionInscripcion", "Titulo sin inscribir ni liquidar.");
		}

		if (!Checks.esNulo(activo.getConCargas()) && activo.getConCargas().equals(Integer.valueOf(1))) {
			mapaValores.put("Situaciondecargas", "CON CARGAS");
		} else {
			mapaValores.put("Situaciondecargas", "SIN CARGAS");
		}

		PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activo.getId());
		if (!Checks.esNulo(perimetroActivo) && !Checks.esNulo(perimetroActivo.getAplicaComercializar())
				&& perimetroActivo.getAplicaComercializar().equals(Integer.valueOf(1))) {
			mapaValores.put("Comercializacion", "SI");
		} else {
			mapaValores.put("Comercializacion", "NO");
		}
		if (!Checks.esNulo(activo.getTipoTitulo())) {
			mapaValores.put("Entrada", FileUtilsREM.stringify(activo.getTipoTitulo().getDescripcionLarga()));
		} else {
			mapaValores.put("Entrada", FileUtilsREM.stringify(null));
		}
		if (!Checks.esNulo(activoApi.cantidadOfertas(activo))) {
			mapaValores.put("CantidadOfertas", FileUtilsREM.stringify(activoApi.cantidadOfertas(activo)));
		} else {
			mapaValores.put("CantidadOfertas", FileUtilsREM.stringify(null));
		}
		Double mayorOfertaRecibida = activoApi.mayorOfertaRecibida(activo);
		if (!Checks.esNulo(mayorOfertaRecibida)) {
			mapaValores.put("MayorOfertaRecibida", FileUtilsREM.stringify(mayorOfertaRecibida) + "€");
		} else {
			mapaValores.put("MayorOfertaRecibida", FileUtilsREM.stringify(null));
		}
		if (!Checks.esNulo(oferta.getImporteOfertaAprobado())) {
			mapaValores.put("ImportePropuesta", FileUtilsREM.stringify(oferta.getImporteOfertaAprobado()) + "€");
		} else {
			mapaValores.put("ImportePropuesta", FileUtilsREM.stringify(null));
		}
		if (!Checks.esNulo(oferta.getImporteOferta())) {
			mapaValores.put("ImporteInicial", FileUtilsREM.stringify(oferta.getImporteOferta()) + "€");
			mapaValores.put("ImportePropuesta", FileUtilsREM.stringify(oferta.getImporteOferta()) + "€");
		} else {
			mapaValores.put("ImporteInicial", FileUtilsREM.stringify(null));
			mapaValores.put("ImportePropuesta", FileUtilsREM.stringify(null));
		}
		if (!Checks.esNulo(oferta.getFechaContraoferta())) {
			mapaValores.put("FechaContraoferta", FileUtilsREM.stringify(oferta.getFechaContraoferta()));
		} else {
			mapaValores.put("FechaContraoferta", FileUtilsREM.stringify(null));
		}
		if (!Checks.esNulo(oferta.getImporteContraOferta())) {
			mapaValores.put("Contraoferta", FileUtilsREM.stringify(oferta.getImporteContraOferta()) + "€");
		} else {
			mapaValores.put("Contraoferta", FileUtilsREM.stringify(null));
		}

		// Si con posesión inicial "sí": El ofertante requiere que haya posesión
		// inicial.
		// Si con posesión inicial "no": El ofertante acepta que no haya
		// posesión inicial.
		// Si con situación posesoria "vacío": El ofertante acepta cualquier
		// situación posesoria.
		// Si con situación posesoria "libre": El ofertante requiere que el
		// activo esté libre de ocupantes.
		// Si con situación posesoria "ocupado con título": El ofertante acepta
		// que el activo esté arrendado.
		Integer poseInicial = condExp.getPosesionInicial();
		if (!Checks.esNulo(condExp)) {
			String txtPosesion = "";
			if (Checks.esNulo(poseInicial)) {
				txtPosesion += "";
			} else {
				if (poseInicial.equals(new Integer(1))) {
					txtPosesion += "El ofertante requiere que haya posesión inicial.";
				} else {
					txtPosesion += "El ofertante acepta que no haya posesión inicial.";
				}
			}
			DDSituacionesPosesoria sitaPosesion = condExp.getSituacionPosesoria();
			if (Checks.esNulo(sitaPosesion)) {
				txtPosesion += "El ofertante acepta cualquier situación posesoria.";
			} else {
				if (!Checks.esNulo(sitaPosesion.getCodigo())
						&& sitaPosesion.getCodigo().equals(DDSituacionesPosesoria.SITUACION_POSESORIA_LIBRE)) {
					txtPosesion += "El ofertante requiere que el activo esté libre de ocupantes.";
				} else if (!Checks.esNulo(sitaPosesion.getCodigo()) && sitaPosesion.getCodigo()
						.equals(DDSituacionesPosesoria.SITUACION_POSESORIA_OCUPADO_CON_TITULO)) {
					txtPosesion += "El ofertante acepta que el activo esté arrendado.";
				}
			}
			mapaValores.put("Posesion", txtPosesion);
		} else {
			mapaValores.put("Posesion", FileUtilsREM.stringify(null));
		}

		if (!Checks.esNulo(condExp) && !Checks.esNulo(condExp.getCargasImpuestos())) {
			mapaValores.put("Impuestos", FileUtilsREM.stringify(condExp.getCargasImpuestos()) + "€");
		} else {
			mapaValores.put("Impuestos", FileUtilsREM.stringify(null));
		}
		if (!Checks.esNulo(condExp) && !Checks.esNulo(condExp.getCargasComunidad())) {
			mapaValores.put("Comunidades", FileUtilsREM.stringify(condExp.getCargasComunidad()) + "€");
		} else {
			mapaValores.put("Comunidades", FileUtilsREM.stringify(null));
		}
		if (!Checks.esNulo(condExp) && !Checks.esNulo(condExp.getCargasComunidad())) {
			mapaValores.put("Otros", FileUtilsREM.stringify(condExp.getCargasOtros()) + "€");
		} else {
			mapaValores.put("Otros", FileUtilsREM.stringify(null));
		}
		// Si hay contenido en impuestos y en el combo "por cuenta de" pone
		// "comprador": El comprador asume el pago de los impuestos pendientes.
		// Si hay contenido en comunidades y en el combo "por cuenta de" pone
		// "vendedor": El comprador no asume el pago de los impuestos
		// pendientes.
		// Si hay contenido en otros y en el combo "por cuenta de" pone "según
		// ley": El comprador requiere que los gastos sean asumidos por quien
		// corresponda según ley.
		if (!Checks.esNulo(condExp)) {
			DDTiposPorCuenta porCuentaImpuestos = condExp.getTipoPorCuentaImpuestos();
			DDTiposPorCuenta porCuentaComunidad = condExp.getTipoPorCuentaComunidad();
			DDTiposPorCuenta porCuentaOtros = condExp.getTipoPorCuentaCargasOtros();
			String txtCargas = "";
			if (condExp.getCargasImpuestos() != null && porCuentaImpuestos != null
					&& porCuentaImpuestos.getCodigo().equals(DDTiposPorCuenta.TIPOS_POR_CUENTA_COMPRADOR)) {
				txtCargas += "El comprador asume el pago de los impuestos pendientes. ";
			}
			if (condExp.getCargasComunidad() != null && porCuentaComunidad != null
					&& porCuentaComunidad.getCodigo().equals(DDTiposPorCuenta.TIPOS_POR_CUENTA_VENDEDOR)) {
				txtCargas += "El comprador no asume el pago de los impuestos pendientes. ";
			}
			if (condExp.getCargasOtros() != null && porCuentaOtros != null
					&& porCuentaOtros.getCodigo().equals(DDTiposPorCuenta.TIPOS_POR_CUENTA_SEGUN_LEY)) {
				txtCargas += "El comprador requiere que los gastos sean asumidos por quien corresponda según ley. ";
			}
			mapaValores.put("Tratamientodecargas", txtCargas);
		} else {
			mapaValores.put("Tratamientodecargas", FileUtilsREM.stringify(null));
		}

		if (!Checks.esNulo(condExp) && !Checks.esNulo(condExp.getGastosNotaria())) {
			mapaValores.put("Importe", FileUtilsREM.stringify(condExp.getGastosNotaria()));
		} else {
			mapaValores.put("Importe", FileUtilsREM.stringify(null));
		}
		mapaValores.put("OpCondicionadaa", "-");

		if (!Checks.esNulo(condExp) && !Checks.esNulo(condExp.getTipoPorCuentaPlusvalia())) {
			mapaValores.put("Plusvalia",
					FileUtilsREM.stringify(condExp.getTipoPorCuentaPlusvalia().getDescripcionLarga()));
		} else {
			mapaValores.put("Plusvalia", FileUtilsREM.stringify(null));
		}
		if (!Checks.esNulo(condExp) && !Checks.esNulo(condExp.getTipoPorCuentaNotaria())) {
			mapaValores.put("Notaria", FileUtilsREM.stringify(condExp.getTipoPorCuentaNotaria().getDescripcionLarga()));
		} else {
			mapaValores.put("Notaria", FileUtilsREM.stringify(null));
		}
		if (!Checks.esNulo(condExp) && !Checks.esNulo(condExp.getTipoPorCuentaGastosOtros())) {
			mapaValores.put("OtrosImporteOferta",
					FileUtilsREM.stringify(condExp.getTipoPorCuentaGastosOtros().getDescripcionLarga()));
		} else {
			mapaValores.put("OtrosImporteOferta", FileUtilsREM.stringify(null));
		}
		if (!Checks.esNulo(condExp) && !Checks.esNulo(condExp.getPorcentajeReserva())) {
			mapaValores.put("Reserva", FileUtilsREM.stringify(condExp.getPorcentajeReserva()) + "%");
		} else {
			if (!Checks.esNulo(condExp) && !Checks.esNulo(condExp.getImporteReserva())) {
				mapaValores.put("Reserva", FileUtilsREM.stringify(condExp.getImporteReserva()) + "€");
			} else {
				mapaValores.put("Reserva", FileUtilsREM.stringify(null));
			}
		}

		// importe RESERVA/importe OFERTA duda COE_CONDICIONANTES_EXPEDIENTE ->
		// RES_RESERVAS
		// sumatorio de ERE_ENTREGAS_RESERVA para el exp
		if (!Checks.esNulo(activo.getInfoRegistral())
				&& !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien())
				&& !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien().getFechaInscripcion())) {
			mapaValores.put("Inscripcion", "SI");
		} else {
			mapaValores.put("Inscripcion", "NO");
		}

		if (!Checks.estaVacio(activo.getTasacion())) {
			// De la lista de tasaciones que tiene el activo cogemos la más
			// reciente
			ActivoTasacion tasacionMasReciente = activoApi.getTasacionMasReciente(activo);
			if (tasacionMasReciente != null) {
				if (!Checks.esNulo(tasacionMasReciente.getValoracionBien())) {
					if (!Checks.esNulo(tasacionMasReciente.getImporteTasacionFin())) {
						mapaValores.put("ValorTasacion",
								FileUtilsREM.stringify(tasacionMasReciente.getImporteTasacionFin()) + "€");
					} else {
						mapaValores.put("ValorTasacion", FileUtilsREM.stringify(null));
					}
					if (!Checks.esNulo(tasacionMasReciente.getValoracionBien().getFechaValorTasacion())) {
						mapaValores.put("ValorTasacionFecha", FileUtilsREM
								.stringify(tasacionMasReciente.getValoracionBien().getFechaValorTasacion()));
					} else {
						mapaValores.put("ValorTasacionFecha", FileUtilsREM.stringify(null));
					}

					if (!Checks.esNulo(oferta.getImporteOferta())
							&& !Checks.esNulo(tasacionMasReciente.getImporteTasacionFin())
							&& !tasacionMasReciente.getImporteTasacionFin().equals(Double.valueOf(0.0))) {

						Double importeTasacion = tasacionMasReciente.getImporteTasacionFin().doubleValue();
						Double valorTasacionDto = 100 * (1 - (oferta.getImporteOferta() / importeTasacion));
						if (!Checks.esNulo(valorTasacionDto)) {
							mapaValores.put("ValorTasacionDto", FileUtilsREM.stringify(valorTasacionDto) + "%");
						} else {
							mapaValores.put("ValorTasacionDto", FileUtilsREM.stringify(null));
						}
					} else {
						mapaValores.put("ValorTasacionDto", FileUtilsREM.stringify(null));
					}
				}

			} else {
				mapaValores.put("ValorTasacion", FileUtilsREM.stringify(null));
				mapaValores.put("ValorTasacionFecha", FileUtilsREM.stringify(null));
				mapaValores.put("ValorTasacionDto", FileUtilsREM.stringify(null));
			}

			// De la lista de valoraciones del activo obtenemos aquella que
			// tiene en el tipo de precio el valor ESTIMADO_VENTA
			Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			Filter estimadoVentaTPCFilter = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo",
					DDTipoPrecio.CODIGO_TPC_ESTIMADO_VENTA);
			ActivoValoraciones activoValoracion = (ActivoValoraciones) genericDao.get(ActivoValoraciones.class,
					activoFilter, estimadoVentaTPCFilter);
			if (activoValoracion != null) {
				if (!Checks.esNulo(activoValoracion.getImporte())) {
					mapaValores.put("ValorEstColabor", FileUtilsREM.stringify(activoValoracion.getImporte()) + "€");
				} else {
					mapaValores.put("ValorEstColabor", FileUtilsREM.stringify(null));
				}
				mapaValores.put("ValorEstColaborFecha", FileUtilsREM.stringify(activoValoracion.getFechaInicio()));
				Double importeTasacion = activoValoracion.getImporte();
				if (!Checks.esNulo(importeTasacion) && importeTasacion != 0) {
					Double valorTasacionDto = 100 * (1 - (oferta.getImporteOferta() / importeTasacion));
					if (!Checks.esNulo(valorTasacionDto)) {
						mapaValores.put("ValorEstColaborDto", FileUtilsREM.stringify(valorTasacionDto) + "%");
					} else {
						mapaValores.put("ValorEstColaborDto", FileUtilsREM.stringify(null));
					}
				} else {
					mapaValores.put("ValorEstColaborDto", FileUtilsREM.stringify(null));
				}
			} else {
				mapaValores.put("ValorEstColabor", FileUtilsREM.stringify(null));
				mapaValores.put("ValorEstColaborFecha", FileUtilsREM.stringify(null));
				mapaValores.put("ValorEstColaborDto", FileUtilsREM.stringify(null));
			}

			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
			Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "tipoTexto.codigo",
					DDTiposTextoOferta.TIPOS_TEXTO_OFERTA_INTERES);
			TextosOferta textoOfertaInteres = genericDao.get(TextosOferta.class, filtro1, filtro2);
			if (textoOfertaInteres != null) {
				mapaValores.put("ComentarioInteres", FileUtilsREM.stringify(textoOfertaInteres.getTexto()));
			} else {
				mapaValores.put("ComentarioInteres", FileUtilsREM.stringify(null));
			}
			filtro1 = genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
			filtro2 = genericDao.createFilter(FilterType.EQUALS, "tipoTexto.codigo",
					DDTiposTextoOferta.TIPOS_TEXTO_OFERTA_GESTOR);
			TextosOferta textoOfertaGestor = genericDao.get(TextosOferta.class, filtro1, filtro2);
			if (textoOfertaGestor != null) {
				mapaValores.put("ComentarioGestor", FileUtilsREM.stringify(textoOfertaGestor.getTexto()));
			} else {
				mapaValores.put("ComentarioGestor", FileUtilsREM.stringify(null));
			}
			filtro1 = genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
			filtro2 = genericDao.createFilter(FilterType.EQUALS, "tipoTexto.codigo",
					DDTiposTextoOferta.TIPOS_TEXTO_OFERTA_COMITE);
			TextosOferta textoOfertaComite = genericDao.get(TextosOferta.class, filtro1, filtro2);
			if (textoOfertaComite != null) {
				mapaValores.put("ComentarioComite", FileUtilsREM.stringify(textoOfertaComite.getTexto()));
			} else {
				mapaValores.put("ComentarioComite", FileUtilsREM.stringify(null));
			}

			// De la lista de valoraciones del activo obtenemos aquella que
			// tiene el codigo APROVADO_VENTA
			List<ActivoValoraciones> listActivoValoracion = activo.getValoracion();
			if (!Checks.estaVacio(listActivoValoracion)) {
				ActivoValoraciones activoAprobVenta = null;
				Boolean isAprobado = false;
				for (int j = 0; j < listActivoValoracion.size() && !isAprobado; j++) {
					ActivoValoraciones tmp = listActivoValoracion.get(j);
					if (!Checks.esNulo(tmp) && !Checks.esNulo(tmp.getTipoPrecio())
							&& DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA.equals(tmp.getTipoPrecio().getCodigo())) {
						activoAprobVenta = tmp;
						isAprobado = true;
					}
				}
				if (activoAprobVenta != null) {
					if (Checks.esNulo(activoAprobVenta.getImporte())) {
						mapaValores.put("ValorAprobVenta", FileUtilsREM.stringify(activoAprobVenta.getImporte()) + "€");
					} else {
						mapaValores.put("ValorAprobVenta", FileUtilsREM.stringify(null));
					}
					if (Checks.esNulo(activoAprobVenta.getFechaInicio())) {
						mapaValores.put("ValorAprobVentaFecha",
								FileUtilsREM.stringify(activoAprobVenta.getFechaInicio()) + "€");
					} else {
						mapaValores.put("ValorAprobVentaFecha", FileUtilsREM.stringify(null));
					}
					Double importeTasacion = activoAprobVenta.getImporte();
					if (!Checks.esNulo(oferta.getImporteOferta()) && !Checks.esNulo(importeTasacion)
							&& !importeTasacion.equals(Double.valueOf(0.0))) {

						Double valorTasacionDto = 100 * (1 - (oferta.getImporteOferta() / importeTasacion));
						if (!Checks.esNulo(valorTasacionDto)) {
							mapaValores.put("ValorAprobVentaDto", FileUtilsREM.stringify(valorTasacionDto) + "%");
						} else {
							mapaValores.put("ValorAprobVentaDto", FileUtilsREM.stringify(null));
						}
					} else {
						mapaValores.put("ValorAprobVentaDto", FileUtilsREM.stringify(null));
					}
				} else {
					mapaValores.put("ValorAprobVenta", FileUtilsREM.stringify(null));
					mapaValores.put("ValorAprobVentaFecha", FileUtilsREM.stringify(null));
					mapaValores.put("ValorAprobVentaDto", FileUtilsREM.stringify(null));
				}
			} else {
				mapaValores.put("ValorAprobVenta", FileUtilsREM.stringify(null));
				mapaValores.put("ValorAprobVentaFecha", FileUtilsREM.stringify(null));
				mapaValores.put("ValorAprobVentaDto", FileUtilsREM.stringify(null));
			}

		}

		/***********************************
		 * INFORMACION COMERCIAL
		 **********************************************/
		// Obtenemos la información de todas las tablas relacionadas con la
		// DESCRIPCION FISICA DEL ACTIVO
		Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoInfoComercial infoComercial = (ActivoInfoComercial) genericDao.get(ActivoInfoComercial.class,
				activoFilter);
		if (!Checks.esNulo(infoComercial)) {

			// Descripción fisica del EDIFICIO
			Filter infoComercialFilter = genericDao.createFilter(FilterType.EQUALS, "infoComercial.id",
					infoComercial.getId());
			ActivoEdificio edificio = (ActivoEdificio) genericDao.get(ActivoEdificio.class, infoComercialFilter);
			if (!Checks.esNulo(edificio)) {
				mapaValores.put("ActivoEdificio", FileUtilsREM.stringify(edificio.getEdiDescripcion()));
			} else {
				mapaValores.put("ActivoEdificio", FileUtilsREM.stringify(null));
			}

			// Todo lo relacionado con la tabla VIVIENDA
			Filter comercialFilter = genericDao.createFilter(FilterType.EQUALS, "informeComercial.id", infoComercial.getId());
			ActivoVivienda vivienda = (ActivoVivienda) genericDao.get(ActivoVivienda.class, comercialFilter);
			if (!Checks.esNulo(vivienda)) {
				mapaValores.put("ActivoInterior", FileUtilsREM.stringify(vivienda.getDistribucionTxt()));
				mapaValores.put("ActivoPlantas", FileUtilsREM.stringify(vivienda.getNumPlantasInter()));
				if (vivienda.getInformeComercial().getEstadoConservacion() != null) {
					mapaValores.put("ActivoConservacion",
							FileUtilsREM.stringify(vivienda.getInformeComercial().getEstadoConservacion().getDescripcionLarga()));
				} else {
					mapaValores.put("ActivoConservacion", FileUtilsREM.stringify(null));
				}
				if (vivienda.getTipoOrientacion() != null) {
					mapaValores.put("ActivoOrientacion", vivienda.getTipoOrientacion().getDescripcionLarga());
				} else {
					mapaValores.put("ActivoOrientacion", FileUtilsREM.stringify(null));
				}
				// Obtener cuantos habitaciones de cada tipo hay y
				// la superficie en m2 del salon
				Integer dormitorio = null;
				Integer aseo = null;
				Integer patio = null;
				Integer porche = null;
				Integer banyo = null;
				Float salon = null;
				Integer balcon = null;
				Integer hall = null;
				List<ActivoDistribucion> distribucion = null;//vivienda.getInformeComercial().getDistribucion();
				if (!Checks.estaVacio(distribucion)) {
					for (int i = 0; i < distribucion.size(); i++) {
						ActivoDistribucion dist = distribucion.get(i);
						if (!Checks.esNulo(dist) && !Checks.esNulo(dist.getTipoHabitaculo())) {
							if (dist.getTipoHabitaculo().getCodigo()
									.equals(DDTipoHabitaculo.TIPO_HABITACULO_DORMITORIO)) {
								if (dormitorio == null) {
									dormitorio = 1;
								} else {
									dormitorio++;
								}
							}
							if (dist.getTipoHabitaculo().getCodigo().equals(DDTipoHabitaculo.TIPO_HABITACULO_ASEO)) {
								if (aseo == null) {
									aseo = 1;
								} else {
									aseo++;
								}
							}
							if (dist.getTipoHabitaculo().getCodigo().equals(DDTipoHabitaculo.TIPO_HABITACULO_PATIO)) {
								if (patio == null) {
									patio = 1;
								} else {
									patio++;
								}
							}
							if (dist.getTipoHabitaculo().getCodigo().equals(DDTipoHabitaculo.TIPO_HABITACULO_PORCHE)) {
								if (porche == null) {
									porche = 1;
								} else {
									porche++;
								}
							}
							if (dist.getTipoHabitaculo().getCodigo().equals(DDTipoHabitaculo.TIPO_HABITACULO_SALON)) {
								if (salon == null) {
									salon = distribucion.get(i).getSuperficie();
								} else {
									salon += distribucion.get(i).getSuperficie();
								}
							}
							if (dist.getTipoHabitaculo().getCodigo().equals(DDTipoHabitaculo.TIPO_HABITACULO_BANYO)) {
								if (banyo == null) {
									banyo = 1;
								} else {
									banyo++;
								}
							}
							if (dist.getTipoHabitaculo().getCodigo().equals(DDTipoHabitaculo.TIPO_HABITACULO_BALCON)) {
								if (balcon == null) {
									balcon = 1;
								} else {
									balcon++;
								}
							}
							if (dist.getTipoHabitaculo().getCodigo().equals(DDTipoHabitaculo.TIPO_HABITACULO_HALL)) {
								if (hall == null) {
									hall = 1;
								} else {
									hall++;
								}
							}
						}
					}
					if (dormitorio != null) {
						mapaValores.put("ActivoDormitorios", FileUtilsREM.stringify(dormitorio));
					} else {
						mapaValores.put("ActivoDormitorios", NOT_AVAILABLE_ROOM);
					}
					if (aseo != null) {
						mapaValores.put("ActivoAseos", FileUtilsREM.stringify(aseo));
					} else {
						mapaValores.put("ActivoAseos", NOT_AVAILABLE_ROOM);
					}
					if (patio != null) {
						mapaValores.put("ActivoPatio", FileUtilsREM.stringify(patio));
					} else {
						mapaValores.put("ActivoPatio", NOT_AVAILABLE_ROOM);
					}
					if (porche != null) {
						mapaValores.put("ActivoPorche", FileUtilsREM.stringify(porche));
					} else {
						mapaValores.put("ActivoPorche", NOT_AVAILABLE_ROOM);
					}
					if (salon != null) {
						mapaValores.put("ActivoSalon", FileUtilsREM.stringify(salon).concat(" m2"));
					} else {
						mapaValores.put("ActivoSalon", NOT_AVAILABLE_ROOM);
					}
					if (banyo != null) {
						mapaValores.put("ActivoBanyos", FileUtilsREM.stringify(banyo));
					} else {
						mapaValores.put("ActivoBanyos", NOT_AVAILABLE_ROOM);
					}
					if (balcon != null) {
						mapaValores.put("ActivoBalcones", FileUtilsREM.stringify(balcon));
					} else {
						mapaValores.put("ActivoBalcones", NOT_AVAILABLE_ROOM);
					}
					if (hall != null) {
						mapaValores.put("ActivoHall", FileUtilsREM.stringify(hall));
					} else {
						mapaValores.put("ActivoHall", NOT_AVAILABLE_ROOM);
					}
				}
				if (vivienda.getUltimaPlanta() != null) {
					if (vivienda.getUltimaPlanta().equals(new Integer(1))) {
						mapaValores.put("ActivoUltPlanta", "SI");
					} else {
						mapaValores.put("ActivoUltPlanta", "NO");
					}
				} else {
					mapaValores.put("ActivoUltPlanta", FileUtilsREM.stringify(null));
				}
				if (vivienda.getInformeComercial().getOcupado() != null) {
					if (vivienda.getInformeComercial().getOcupado().equals(new Integer(1))) {
						mapaValores.put("ActivoOcupada", "SI");
					} else {
						mapaValores.put("ActivoOcupada", "NO");
					}
				} else {
					mapaValores.put("ActivoOcupada", FileUtilsREM.stringify(null));
				}
				if (vivienda.getInformeComercial().getUbicacionActivo() != null) {
					mapaValores.put("ActivoUbicacion",
							FileUtilsREM.stringify(vivienda.getInformeComercial().getUbicacionActivo().getDescripcionLarga()));
				} else {
					mapaValores.put("ActivoUbicacion", FileUtilsREM.stringify(null));
				}
				//mapaValores.put("ActivoDistrito", FileUtilsREM.stringify(vivienda.getInformeComercial().getDistrito()));
				mapaValores.put("ActivoAntiguedad", FileUtilsREM.stringify(vivienda.getInformeComercial().getAnyoConstruccion()));
				mapaValores.put("ActivoRehabilitacion", FileUtilsREM.stringify(vivienda.getInformeComercial().getAnyoRehabilitacion()));
				if (vivienda.getTipoVivienda() != null) {
					mapaValores.put("ActivoTipo",
							FileUtilsREM.stringify(vivienda.getTipoVivienda().getDescripcionLarga()));
				} else {
					mapaValores.put("ActivoTipo", FileUtilsREM.stringify(null));
				}
			} else {
				mapaValores.put("ActivoInterior", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoPlantas", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoConservacion", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoOrientacion", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoDormitorios", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoAseos", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoPatio", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoPorche", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoSalon", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoBanyos", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoBalcones", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoHall", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoUltPlanta", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoOcupada", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoUbicacion", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoDistrito", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoAntiguedad", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoRehabilitacion", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoTipo", FileUtilsREM.stringify(null));
			}

			// Todo lo relacionado con la tabla INFORMACION COMERCIAL
			//mapaValores.put("ActivoZona", FileUtilsREM.stringify(infoComercial.getZona()));

			// Todo lo relacionado con la tabla ANEJO
			ActivoDistribucion activoDistribucion = genericDao.get(ActivoDistribucion.class,
					genericDao.createFilter(FilterType.EQUALS, "numPlanta", Integer.valueOf(0)),
					genericDao.createFilter(FilterType.EQUALS, "tipoHabitaculo.codigo",
							DDTipoHabitaculo.TIPO_HABITACULO_GARAJE),
					genericDao.createFilter(FilterType.EQUALS, "infoComercial", infoComercial));
			if (!Checks.esNulo(activoDistribucion)) {
				if (activoDistribucion.getCantidad() != null && activoDistribucion.getCantidad() > 0) {
					mapaValores.put("ActivoGaraje", FileUtilsREM.stringify(true));
				} else {
					mapaValores.put("ActivoGaraje", FileUtilsREM.stringify(false));
				}
				if (activoDistribucion.getCantidad() != null && activoDistribucion.getCantidad() > 0) {
					mapaValores.put("ActivoPlazas", FileUtilsREM.stringify(activoDistribucion.getCantidad()));
				}else{
					mapaValores.put("ActivoPlazas", FileUtilsREM.stringify(0));
				}
				
				mapaValores.put("ActivoSuperficie", FileUtilsREM.stringify(activoDistribucion.getSuperficie()));
			} else {
				mapaValores.put("ActivoGaraje", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoPlazas", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoSuperficie", FileUtilsREM.stringify(null));
				mapaValores.put("ActivoSubtipologia", FileUtilsREM.stringify(null));
			}

			activoDistribucion = genericDao.get(ActivoDistribucion.class,
					genericDao.createFilter(FilterType.EQUALS, "numPlanta", Integer.valueOf(0)),
					genericDao.createFilter(FilterType.EQUALS, "tipoHabitaculo.codigo",
							DDTipoHabitaculo.TIPO_HABITACULO_TRASTERO),
					genericDao.createFilter(FilterType.EQUALS, "infoComercial", infoComercial));
			if (!Checks.esNulo(activoDistribucion)) {
				if (activoDistribucion.getCantidad() != null && activoDistribucion.getCantidad() > 0) {
					mapaValores.put("ActivoTrastero", FileUtilsREM.stringify(true));
				} else {
					mapaValores.put("ActivoTrastero", FileUtilsREM.stringify(false));
				}
			} else {
				mapaValores.put("ActivoTrastero", FileUtilsREM.stringify(null));
			}
		}

		/**************************************** LOTE **********************************************/
		if (!Checks.esNulo(oferta.getAgrupacion())) {
			mapaValores.put("Lote", FileUtilsREM.stringify(oferta.getAgrupacion().getNumAgrupRem()));
			mapaValores.put("nombreAgrupacion", FileUtilsREM.stringify(oferta.getAgrupacion().getNombre()));

			listaActivos = oferta.getActivosOferta();
			if (!Checks.esNulo(listaActivos)) {
				mapaValores.put("numActivos", FileUtilsREM.stringify(listaActivos.size()));
				for (int i = 0; i < listaActivos.size(); i++) {
					Activo act = listaActivos.get(0).getPrimaryKey().getActivo();
					if (!Checks.esNulo(act) && !Checks.esNulo(act.getTipoActivo())
							&& act.getTipoActivo().getCodigo().equalsIgnoreCase(DDTipoActivo.COD_EDIFICIO_COMPLETO)) {
						contEdi++;
					}
					if (!Checks.esNulo(act) && !Checks.esNulo(act.getTipoActivo())
							&& act.getTipoActivo().getCodigo().equalsIgnoreCase(DDTipoActivo.COD_VIVIENDA)) {
						contViv++;
					}
					if (!Checks.esNulo(act) && !Checks.esNulo(act.getTipoActivo())
							&& act.getTipoActivo().getCodigo().equalsIgnoreCase(DDTipoActivo.COD_COMERCIAL)) {
						contCom++;
					}
					if (!Checks.esNulo(act) && !Checks.esNulo(act.getTipoActivo())
							&& act.getTipoActivo().getCodigo().equalsIgnoreCase(DDTipoActivo.COD_INDUSTRIAL)) {
						contInd++;
					}
					if (!Checks.esNulo(act) && !Checks.esNulo(act.getTipoActivo())
							&& act.getTipoActivo().getCodigo().equalsIgnoreCase(DDTipoActivo.COD_SUELO)) {
						contSue++;
					}
					if (!Checks.esNulo(act) && !Checks.esNulo(act.getTipoActivo())
							&& act.getTipoActivo().getCodigo().equalsIgnoreCase(DDTipoActivo.COD_OTROS)) {
						contVar++;
					}
				}
				mapaValores.put("numActEdi", FileUtilsREM.stringify(contEdi));
				mapaValores.put("numActViv", FileUtilsREM.stringify(contViv));
				mapaValores.put("numActCom", FileUtilsREM.stringify(contCom));
				mapaValores.put("numActInd", FileUtilsREM.stringify(contInd));
				mapaValores.put("numActSue", FileUtilsREM.stringify(contSue));
				mapaValores.put("numActVar", FileUtilsREM.stringify(contVar));

				if (!Checks.esNulo(activo.getAdjJudicial())
						&& !Checks.esNulo(activo.getAdjJudicial().getAdjudicacionBien())) {
					if (!Checks.esNulo(activo.getAdjJudicial().getAdjudicacionBien().getFechaRealizacionPosesion())) {
						contDispJur++;
					}
				}
				if (contDispJur > 0) {
					mapaValores.put("Disponibilidadjuridica", "DISPONIBLE");
					mapaValores.put("numDispJuridica", FileUtilsREM.stringify(contDispJur));
				} else {
					mapaValores.put("Disponibilidadjuridica", "NO DISPONIBLE");
					mapaValores.put("numDispJuridica", FileUtilsREM.stringify(contDispJur));
				}

			} else {
				mapaValores.put("numActivos", FileUtilsREM.stringify(Integer.valueOf(0)));
				mapaValores.put("numActEdi", FileUtilsREM.stringify(Integer.valueOf(0)));
				mapaValores.put("numActViv", FileUtilsREM.stringify(Integer.valueOf(0)));
				mapaValores.put("numActCom", FileUtilsREM.stringify(Integer.valueOf(0)));
				mapaValores.put("numActInd", FileUtilsREM.stringify(Integer.valueOf(0)));
				mapaValores.put("numActSue", FileUtilsREM.stringify(Integer.valueOf(0)));
				mapaValores.put("numActVar", FileUtilsREM.stringify(Integer.valueOf(0)));
			}

			if (!Checks.esNulo(activo.getAdjJudicial())
					&& !Checks.esNulo(activo.getAdjJudicial().getAdjudicacionBien())) {
				if (activo.getAdjJudicial().getAdjudicacionBien().getFechaRealizacionPosesion() != null) {
					mapaValores.put("Disponibilidadjuridica", "Disponible");
				} else {
					mapaValores.put("Disponibilidadjuridica", "No disponible.");
				}
			} else {
				mapaValores.put("Disponibilidadjuridica", FileUtilsREM.stringify(null));
			}
		}

		return mapaValores;
	}

	@Override
	public List<Object> dataSourceHojaDatos(ActivoOferta activoOferta, ModelMap model, String selfUrl)
			throws Exception {
		logger.debug("------------ Llamada dataSourceHojaDatos-----------------");

		Activo activo = null;
		Oferta oferta = null;
		List<Object> array = new ArrayList<Object>();
		DtoDataSource propuestaOferta = new DtoDataSource();

		if (!Checks.esNulo(activoOferta)) {
			activo = activoOferta.getPrimaryKey().getActivo();
			oferta = activoOferta.getPrimaryKey().getOferta();
		}

		if (Checks.esNulo(activo)) {
			throw new Exception(RestApi.REST_NO_RELATED_ASSET);
		}

		if (Checks.esNulo(oferta)) {
			throw new Exception(RestApi.REST_NO_RELATED_ASSET);
		}

		ExpedienteComercial expCom = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());

		// *********************************listaCliente**************************************************/
		if (!Checks.esNulo(expCom)) {
			List<CompradorExpediente> clientes = expCom.getCompradores();

			if (!Checks.estaVacio(clientes)) {
				List<Object> listaCliente = new ArrayList<Object>();
				DtoCliente cliente = null;
				for (int i = 0; i < clientes.size(); i++) {
					CompradorExpediente comp = clientes.get(i);

					if (!Checks.esNulo(comp)) {

						VBusquedaDatosCompradorExpediente datosComprador = expedienteComercialApi
								.getDatosCompradorById(comp.getComprador(), expCom.getId());

						if (!Checks.esNulo(datosComprador)) {
							cliente = new DtoCliente();
							String nombreCompleto = datosComprador.getNombreRazonSocial();
							if (!Checks.esNulo(nombreCompleto) && !nombreCompleto.equalsIgnoreCase("")
									&& !Checks.esNulo(datosComprador.getApellidos())
									&& !datosComprador.getApellidos().equalsIgnoreCase("")) {
								nombreCompleto = nombreCompleto.concat(" ").concat(datosComprador.getApellidos());
							}
							cliente.setNombreCliente(FileUtilsREM.stringify(nombreCompleto));
							String direccion = "";
							if (datosComprador.getDireccion() != null) {
								direccion += datosComprador.getDireccion();
							}
							if (datosComprador.getCodigoPostal() != null) {
								direccion += " ";
								direccion += datosComprador.getCodigoPostal();
							}
							if (datosComprador.getMunicipioDescripcion() != null) {
								direccion += " ";
								direccion += datosComprador.getMunicipioDescripcion();
							}
							if (datosComprador.getProvinciaDescripcion() != null) {
								direccion = direccion + " (" + datosComprador.getProvinciaDescripcion() + ")";
							}
							cliente.setDireccionCliente(direccion);
							cliente.setDniCliente(FileUtilsREM.stringify(datosComprador.getNumDocumento()));
							cliente.setTlfCliente(FileUtilsREM.stringify(datosComprador.getTelefono1()));
							if (datosComprador.getAntiguoDeudor() != null) {
								if (datosComprador.getAntiguoDeudor() == 1) {
									cliente.setDeudor("SI");
								} else {
									cliente.setDeudor("NO");
								}
							} else {
								cliente.setDeudor(FileUtilsREM.stringify(null));
							}
							if (datosComprador.getRelacionAntDeudor() != null) {
								if (datosComprador.getRelacionAntDeudor() == 1) {
									cliente.setrBienes("SI");
								} else {
									cliente.setrBienes("NO");
								}
							} else {
								cliente.setrBienes(FileUtilsREM.stringify(null));
							}
							listaCliente.add(cliente);
						}
					}
				}
				propuestaOferta.setListaCliente(listaCliente);
			}
		}

		// *********************************listaHonorario**************************************************/

		if (!Checks.esNulo(expCom)) {
			List<GastosExpediente> listaGastosExpediente = genericDao.getList(GastosExpediente.class,
					genericDao.createFilter(FilterType.EQUALS, "expediente.id", expCom.getId()));

			if (!Checks.estaVacio(listaGastosExpediente)) {
				List<Object> listaHonorario = new ArrayList<Object>();
				for (int j = 0; j < listaGastosExpediente.size(); j++) {
					GastosExpediente gasto = listaGastosExpediente.get(j);

					if (!Checks.esNulo(gasto)) {
						DtoHonorarios honorarios = new DtoHonorarios();
						if (gasto.getProveedor() != null) {
							honorarios.setNombreHonorarios(FileUtilsREM.stringify(gasto.getProveedor().getNombre()));
						} else {
							honorarios.setNombreHonorarios(FileUtilsREM.stringify(null));
						}
						if (gasto.getAccionGastos() != null) {
							honorarios.setConceptoHonorarios(
									FileUtilsREM.stringify(gasto.getAccionGastos().getDescripcion()));
						} else {
							honorarios.setConceptoHonorarios(FileUtilsREM.stringify(null));
						}
						if (!Checks.esNulo(gasto.getTipoCalculo())
								&& DDTipoCalculo.TIPO_CALCULO_PORCENTAJE.equals(gasto.getTipoCalculo().getCodigo())) {
							if (!Checks.esNulo(gasto.getImporteCalculo())) {
								honorarios.setPorcentajeHonorarios(
										FileUtilsREM.stringify(gasto.getImporteCalculo()) + "%");
							} else {
								honorarios.setPorcentajeHonorarios(FileUtilsREM.stringify(null));
							}
						} else {
							honorarios.setPorcentajeHonorarios(FileUtilsREM.stringify(null));
						}
						if (!Checks.esNulo(gasto.getImporteFinal())) {
							honorarios.setImporteHonorarios(FileUtilsREM.stringify(gasto.getImporteFinal()) + "€");
						} else {
							honorarios.setImporteHonorarios(FileUtilsREM.stringify(null));
						}
						listaHonorario.add(honorarios);
					}
				}
				propuestaOferta.setListaHonorario(listaHonorario);
			}
		}

		// *********************************listaOfertasPorActivo*************************************************/
		List<ActivoOferta> listaOfertaPorActivo = activo.getOfertas();

		if (!Checks.estaVacio(listaOfertaPorActivo)) {
			List<Object> listaOferta = new ArrayList<Object>();
			DtoOferta ofertaActivo = null;
			for (int k = 0; k < listaOfertaPorActivo.size(); k++) {
				Oferta tmpOferta = listaOfertaPorActivo.get(k).getPrimaryKey().getOferta();

				if (!Checks.esNulo(tmpOferta)) {
					ofertaActivo = new DtoOferta();
					if (tmpOferta.getNumOferta() != null) {
						ofertaActivo.setNumOferta(FileUtilsREM.stringify(tmpOferta.getNumOferta()));
					} else {
						ofertaActivo.setNumOferta(FileUtilsREM.stringify(null));
					}
					if (tmpOferta.getCliente() != null && !Checks.esNulo(tmpOferta.getCliente().getNombreCompleto())) {
						ofertaActivo
								.setTitularOferta(FileUtilsREM.stringify(tmpOferta.getCliente().getNombreCompleto()));
					} else {
						ofertaActivo.setTitularOferta(FileUtilsREM.stringify(null));
					}
					if (!Checks.esNulo(tmpOferta.getImporteOferta())) {
						ofertaActivo.setImporteOferta(FileUtilsREM.stringify(tmpOferta.getImporteOferta()) + "€");
					} else {
						ofertaActivo.setImporteOferta(FileUtilsREM.stringify(null));
					}
					if (!Checks.esNulo(tmpOferta.getFechaAlta())) {
						ofertaActivo.setFechaOferta(FileUtilsREM.stringify(tmpOferta.getFechaAlta()));
					} else {
						ofertaActivo.setFechaOferta(FileUtilsREM.stringify(null));
					}
					if (tmpOferta.getEstadoOferta() != null) {
						ofertaActivo.setSituacionOferta(
								FileUtilsREM.stringify(tmpOferta.getEstadoOferta().getDescripcionLarga()));
					} else {
						ofertaActivo.setSituacionOferta(FileUtilsREM.stringify(null));
					}
					listaOferta.add(ofertaActivo);
				}
			}
			propuestaOferta.setListaOferta(listaOferta);
		}

		// *********************************listaOtrasOfertasPorTitulares*************************************************/
		List<Oferta> listaOtrasOfertasPorTitulares = ofertaApi.getOtrasOfertasTitularesOferta(oferta);

		if (!Checks.estaVacio(listaOtrasOfertasPorTitulares)) {
			List<Object> listaOtrasOferta = new ArrayList<Object>();
			DtoOferta ofertaOtroActivo = null;
			for (int k = 0; k < listaOtrasOfertasPorTitulares.size(); k++) {
				Oferta tmpOferta = listaOtrasOfertasPorTitulares.get(k);

				if (!Checks.esNulo(tmpOferta)) {
					ofertaOtroActivo = new DtoOferta();

					if (tmpOferta.getNumOferta() != null) {
						ofertaOtroActivo.setNumOferta(FileUtilsREM.stringify(tmpOferta.getNumOferta()));
					} else {
						ofertaOtroActivo.setNumOferta(FileUtilsREM.stringify(null));
					}
					if (tmpOferta.getAgrupacion() != null) {
						ofertaOtroActivo
								.setNumAgrup(FileUtilsREM.stringify(tmpOferta.getAgrupacion().getNumAgrupRem()));
					} else {
						ofertaOtroActivo.setNumAgrup(FileUtilsREM.stringify(null));
					}
					if (tmpOferta.getActivoPrincipal() != null) {
						ofertaOtroActivo
								.setNumActivo(FileUtilsREM.stringify(tmpOferta.getActivoPrincipal().getNumActivo()));
					} else {
						ofertaOtroActivo.setNumActivo(FileUtilsREM.stringify(null));
					}
					if (tmpOferta.getCliente() != null && tmpOferta.getCliente().getNombreCompleto() != null) {
						ofertaOtroActivo
								.setTitularOferta(FileUtilsREM.stringify(tmpOferta.getCliente().getNombreCompleto()));
					} else {
						ofertaOtroActivo.setTitularOferta(FileUtilsREM.stringify(null));
					}
					if (!Checks.esNulo(tmpOferta.getImporteOferta())) {
						ofertaOtroActivo.setImporteOferta(FileUtilsREM.stringify(tmpOferta.getImporteOferta()) + "€");
					} else {
						ofertaOtroActivo.setImporteOferta(FileUtilsREM.stringify(null));
					}
					if (!Checks.esNulo(tmpOferta.getFechaAlta())) {
						ofertaOtroActivo.setFechaOferta(FileUtilsREM.stringify(tmpOferta.getFechaAlta()));
					} else {
						ofertaOtroActivo.setFechaOferta(FileUtilsREM.stringify(null));
					}
					if (tmpOferta.getEstadoOferta() != null) {
						ofertaOtroActivo.setSituacionOferta(
								FileUtilsREM.stringify(tmpOferta.getEstadoOferta().getDescripcionLarga()));
					} else {
						ofertaOtroActivo.setSituacionOferta(FileUtilsREM.stringify(null));
					}
					listaOtrasOferta.add(ofertaOtroActivo);
				}
			}
			propuestaOferta.setListaOtrasOfertas(listaOtrasOferta);
		}

		// *********************************listaVisitas*************************************************/
		DtoVisitasFilter dtoVisitasFilter = new DtoVisitasFilter();
		dtoVisitasFilter.setNumActivo(activo.getNumActivo());
		List<Visita> listaVisitas = visitaApi.getListaVisitasOrdenada(dtoVisitasFilter);

		if (!Checks.estaVacio(listaVisitas)) {
			List<Object> lista = new ArrayList<Object>();
			DtoVisita visitaActivo = null;
			for (int k = 0; k < listaVisitas.size() && k < 10; k++) {
				Visita visita = listaVisitas.get(k);

				if (!Checks.esNulo(visita)) {
					visitaActivo = new DtoVisita();
					visitaActivo.setFechaSolicitud(FileUtilsREM.stringify(visita.getFechaSolicitud()));

					if (!Checks.esNulo(visita.getCliente())) {
						visitaActivo.setSolicitante(FileUtilsREM.stringify(visita.getCliente().getNombreCompleto()));
						visitaActivo.setNifSolicitante(FileUtilsREM.stringify(visita.getCliente().getDocumento()));
					} else {
						visitaActivo.setSolicitante(FileUtilsREM.stringify(null));
						visitaActivo.setNifSolicitante(FileUtilsREM.stringify(null));
					}
					if (!Checks.esNulo(visita.getEstadoVisita())) {
						visitaActivo
								.setSituacionVisita(FileUtilsREM.stringify(visita.getEstadoVisita().getDescripcion()));
					} else {
						visitaActivo.setSituacionVisita(FileUtilsREM.stringify(null));
					}

					visitaActivo.setFechaVisita(FileUtilsREM.stringify(visita.getFechaVisita()));

					lista.add(visitaActivo);
				}
			}
			propuestaOferta.setListaVisitas(lista);
		}

		// *********************************listaTasacion**************************************************/
		List<ActivoTasacion> listActivoTasacion = activoDao.getListActivoTasacionByIdActivo(activo.getId());

		if (!Checks.estaVacio(listActivoTasacion)) {
			List<Object> listaTasacion = new ArrayList<Object>();
			for (int k = 0; k < listActivoTasacion.size(); k++) {
				ActivoTasacion tas = listActivoTasacion.get(k);

				if (!Checks.esNulo(tas)) {
					DtoTasacionInforme tasacion = new DtoTasacionInforme();
					tasacion.setNumTasacion(FileUtilsREM.stringify(tas.getIdExterno()));
					if (!Checks.esNulo(tas.getTipoTasacion())) {
						tasacion.setTipoTasacion(FileUtilsREM.stringify(tas.getTipoTasacion().getDescripcion()));
					} else {
						tasacion.setTipoTasacion(FileUtilsREM.stringify(null));
					}
					if (!Checks.esNulo(tas.getImporteTasacionFin())) {
						tasacion.setImporteTasacion(FileUtilsREM.stringify(tas.getImporteTasacionFin()) + "€");
					} else {
						tasacion.setImporteTasacion(FileUtilsREM.stringify(null));
					}
					tasacion.setFechaTasacion(FileUtilsREM.stringify(tas.getValoracionBien().getFechaValorTasacion()));

					if (!Checks.esNulo(tas.getCodigoFirma())) {
						ActivoProveedor tasadora = activoAdapter
								.getTasadoraByCodProveedorUvem(tas.getCodigoFirma().toString());
						if (!Checks.esNulo(tasadora)) {
							tasacion.setFirmaTasacion(FileUtilsREM.stringify(tasadora.getNombre()));
						} else {
							tasacion.setFirmaTasacion(FileUtilsREM.stringify(null));
						}

					} else {
						tasacion.setFirmaTasacion(FileUtilsREM.stringify(null));
					}
					listaTasacion.add(tasacion);
				}
			}
			propuestaOferta.setListaTasacion(listaTasacion);
		}

		List<ActivoFoto> listaActivoFoto = activoAdapter.getListFotosActivoById(activo.getId());
		ArrayList<Object> fotosWebPrimera = new ArrayList<Object>();
		ArrayList<Object> fotosWebSegunda = new ArrayList<Object>();
		ArrayList<Object> fotosWebTercera = new ArrayList<Object>();
		ArrayList<Object> fotosTecnicasPrimera = new ArrayList<Object>();
		ArrayList<Object> fotosTecnicasSegunda = new ArrayList<Object>();
		ArrayList<Object> fotosTecnicasTercera = new ArrayList<Object>();
		int fotowebCont = 1;
		int fotoTecnicaCont = 1;
		if (listaActivoFoto != null && !listaActivoFoto.isEmpty()) {
			for (ActivoFoto foto : listaActivoFoto) {
				if (foto.getUrlThumbnail() == null || foto.getUrlThumbnail().isEmpty()) {
					foto.setUrlThumbnail(
							selfUrl.concat("/webhook/fotos/download?idFoto=").concat(String.valueOf(foto.getId())));
				}
				if (foto.getTipoFoto() != null && foto.getTipoFoto().getCodigo().equals(DDTipoFoto.COD_WEB)) {
					switch (fotowebCont) {
					case 1:
						fotosWebPrimera.add(foto);
						fotowebCont++;
						break;
					case 2:
						fotosWebSegunda.add(foto);
						fotowebCont++;
						break;
					case 3:
						fotosWebTercera.add(foto);
						fotowebCont = 1;
						break;
					}

				} else if (foto.getTipoFoto() != null
						&& foto.getTipoFoto().getCodigo().equals(DDTipoFoto.COD_TECNICA)) {
					// fotosTecnicas.add(foto);
					switch (fotoTecnicaCont) {
					case 1:
						fotosTecnicasPrimera.add(foto);
						fotoTecnicaCont++;
						break;
					case 2:
						fotosTecnicasSegunda.add(foto);
						fotoTecnicaCont++;
						break;
					case 3:
						fotosTecnicasTercera.add(foto);
						fotoTecnicaCont = 1;
						break;
					}
				}
			}
		}
		propuestaOferta.setListaFotosWebPrimera(fotosWebPrimera);
		propuestaOferta.setListaFotosWebSegunda(fotosWebSegunda);
		propuestaOferta.setListaFotosWebTercera(fotosWebTercera);
		propuestaOferta.setListaFotosTecnicasPrimera(fotosTecnicasPrimera);
		propuestaOferta.setListaFotosTecnicasSegunda(fotosTecnicasSegunda);
		propuestaOferta.setListaFotosTecnicasTercera(fotosTecnicasTercera);

		array.add(propuestaOferta);

		return array;

	}

	@Override
	public Map<String, Object> sendFileBase64(HttpServletResponse response, File file, ModelMap model)
			throws Exception {
		logger.debug("------------ Llamada sendFileBase64-----------------");

		Map<String, Object> dataResponse = new HashMap<String, Object>();

		dataResponse.put("contentType", "application/pdf");
		dataResponse.put("fileName", "HojaPresentacionPropuesta.pdf");
		dataResponse.put("hojaPropuesta", FileUtilsREM.base64Encode(file));

		return dataResponse;
	}

	@Override
	public File getPDFFile(Map<String, Object> params, List<Object> dataSource, String template, ModelMap model)
			throws JRException, IOException, Exception {
		logger.debug("------------ Llamada getPDFFile-----------------");

		String ficheroPlantilla = "jasper/" + template + ".jrxml";

		InputStream is = this.getClass().getClassLoader().getResourceAsStream(ficheroPlantilla);
		File fileSalidaTemporal = null;

		// Comprobar si existe el fichero de la plantilla
		if (is == null) {
			throw new Exception("No existe el fichero de plantilla " + ficheroPlantilla);
		}

		// Compilar la plantilla
		JasperReport report = JasperCompileManager.compileReport(is);
		// JasperReport report = (JasperReport)JRLoader.loadObject(is);

		// Rellenar los datos del informe
		JasperPrint print = JasperFillManager.fillReport(report, params, new JRBeanCollectionDataSource(dataSource));

		// Exportar el informe a PDF
		fileSalidaTemporal = File.createTempFile("jasper", ".pdf");
		fileSalidaTemporal.deleteOnExit();
		if (fileSalidaTemporal.exists()) {
			JasperExportManager.exportReportToPdfStream(print, new FileOutputStream(fileSalidaTemporal));
			FileItem fi = new FileItem();
			fi.setFileName(ficheroPlantilla + (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + ".pdf");
			fi.setFile(fileSalidaTemporal);
		} else {
			throw new Exception("Error al generar el fichero de salida " + fileSalidaTemporal);
		}

		return fileSalidaTemporal;

	}

}
