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

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

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
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.ParamReportsApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoComprador;
import es.pfsgroup.plugin.rem.model.DtoDataSource;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionesPosesoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPorCuenta;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.utils.FileUtilsREM;

@Service("operacionVentaManager")
public class OperacionVentaManager implements ParamReportsApi{
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoDao activoDao;

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> paramsHojaDatos(ActivoOferta activoOferta, ModelMap model) {
		Activo activo = null;
		Oferta oferta = null;
		ExpedienteComercial expediente = null;
		Map<String, Object> mapaValores = new HashMap<String, Object>();

		try {
			if(!Checks.esNulo(activoOferta)){
				activo = activoOferta.getPrimaryKey().getActivo();
				oferta = activoOferta.getPrimaryKey().getOferta();
			}

			if(Checks.esNulo(activo)){
				model.put("error", RestApi.REST_NO_RELATED_ASSET);
				throw new Exception(RestApi.REST_NO_RELATED_ASSET);
			}
			
			if(Checks.esNulo(oferta)){
				model.put("error", RestApi.REST_NO_RELATED_OFFER);
				throw new Exception(RestApi.REST_NO_RELATED_OFFER);
			}

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
			expediente = (ExpedienteComercial) genericDao.get(ExpedienteComercial.class, filtro);

			if (expediente==null) {
				model.put("error", RestApi.REST_NO_RELATED_EXPEDIENT);
				throw new Exception(RestApi.REST_NO_RELATED_EXPEDIENT);					
			}

			mapaValores.put("Activo", activo.getNumActivoUvem().toString());
			mapaValores.put("NumOfProp", oferta.getNumOferta() + "/1");

			if (activo.getCartera()!=null && activo.getCartera().getCodigo()!=null) {
				mapaValores.put("Cartera", FileUtilsREM.stringify(activo.getCartera().getCodigo().toString()));
			} else {
				mapaValores.put("Cartera", FileUtilsREM.stringify(null));
			}
			
			Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", "GCOM");
			Long tipo = genericDao.get(EXTDDTipoGestor.class, filter).getId();		
			if (gestorActivoApi.getGestorByActivoYTipo(activo, tipo)!=null) {
				mapaValores.put("Gestor", gestorActivoApi.getGestorByActivoYTipo(activo, tipo).getApellidoNombre());
			} else {
				mapaValores.put("Gestor", FileUtilsREM.stringify(null));
			}
			
			mapaValores.put("FAprobacion",FileUtilsREM.stringify(expediente.getFechaSancion()));
			mapaValores.put("Referencia",FileUtilsREM.stringify(activo.getNumInmovilizadoBnk())); 
			mapaValores.put("Prescriptor",FileUtilsREM.stringify(oferta.getPrescriptor() != null ? oferta.getPrescriptor().getNombre() : ""));
			mapaValores.put("Sucursal",FileUtilsREM.stringify(null));
			
			
			mapaValores.put("Direccion",FileUtilsREM.stringify(activo.getDireccionCompleta()));
			if (activo.getTipoActivo()!=null) {
				mapaValores.put("Tipo",FileUtilsREM.stringify(activo.getTipoActivo().getDescripcionLarga()));
			} else {
				mapaValores.put("Tipo",FileUtilsREM.stringify(null));
			}
			if (activo.getSubtipoActivo()!=null) {
				mapaValores.put("Subtipo",FileUtilsREM.stringify(activo.getSubtipoActivo().getDescripcionLarga()));
			} else {
				mapaValores.put("Subtipo",FileUtilsREM.stringify(null));
			}

			List<ActivoAdmisionDocumento> listaAdmisionDocumento = activo.getAdmisionDocumento();
			boolean isFoundCalificacion = false;
			for (int m = 0; m < listaAdmisionDocumento.size(); m++) {
				ActivoAdmisionDocumento admisionDocumento = listaAdmisionDocumento.get(m);
				if (admisionDocumento.getTipoCalificacionEnergetica()!=null && 
					admisionDocumento.getEstadoDocumento()!=null && 
					DDEstadoDocumento.CODIGO_ESTADO_OBTENIDO.equals(admisionDocumento.getEstadoDocumento().getCodigo())) {
					mapaValores.put("CertificadoEnergetico", admisionDocumento.getTipoCalificacionEnergetica().getDescripcionLarga());
					isFoundCalificacion = true;
				} 				
			}
			if (!isFoundCalificacion) {
				mapaValores.put("CertificadoEnergetico",FileUtilsREM.stringify(null));
			}
			mapaValores.put("SuperficieConstruida",FileUtilsREM.stringify(activo.getTotalSuperficieConstruida()));
			mapaValores.put("SuperficieUtil",FileUtilsREM.stringify(activo.getTotalSuperficieUtil()));
			mapaValores.put("SuperficieRegistro",FileUtilsREM.stringify(activo.getTotalSuperficieSuelo()));
			
			List<ActivoPropietarioActivo> listaPropietarios = activo.getPropietariosActivo();
			if (listaPropietarios!=null && listaPropietarios.get(0).getPropietario()!=null && listaPropietarios.get(0).getPropietario().getFullName()!=null){
				mapaValores.put("SociedadPatrimonial",listaPropietarios.get(0).getPropietario().getFullName());
				Double porcentaje =  (double) (100/listaPropietarios.size());
				mapaValores.put("PorcentajePropiedad",FileUtilsREM.stringify(porcentaje));
			} else {
				mapaValores.put("SociedadPatrimonial",FileUtilsREM.stringify(null));
				mapaValores.put("PorcentajePropiedad",FileUtilsREM.stringify(null));
			}
			
			NMBBien bien =  activo.getBien();
			if (bien!=null) {
				if (bien.getDatosRegistrales()!=null) {
					mapaValores.put("FincaRegistral",FileUtilsREM.stringify(bien.getDatosRegistrales()));
				} else {
					mapaValores.put("FincaRegistral",FileUtilsREM.stringify(null));
				}
			} else {
				mapaValores.put("FincaRegistral",FileUtilsREM.stringify(null));
			}

//			Oferta ofertaAceptada = ofertaApi.getOfertaAceptadaByActivo(activo);
//			if (ofertaAceptada==null) {
//				model.put("error", RestApi.REST_NO_RELATED_OFFER_ACCEPTED);
//				throw new Exception(RestApi.REST_NO_RELATED_OFFER_ACCEPTED);					
//			}

			//Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id", ofertaAceptada.getId());
			
			CondicionanteExpediente condExp = expediente.getCondicionante();
			if (condExp==null) {
				model.put("error", RestApi.REST_NO_RELATED_COND_EXPEDIENT);
				throw new Exception(RestApi.REST_NO_RELATED_COND_EXPEDIENT);					
			}
//			Si con posesión inicial "sí": El ofertante requiere que haya posesión inicial.
//			Si con posesión inicial "no": El ofertante acepta que no haya posesión inicial.
//			Si con situación posesoria "vacío": El ofertante acepta cualquier situación posesoria.
//			Si con situación posesoria "libre": El ofertante requiere que el activo esté libre de ocupantes.
//			Si con situación posesoria "ocupado con título": El ofertante acepta que el activo esté arrendado.
			Integer poseInicial = condExp.getPosesionInicial();
			DDSituacionesPosesoria sitaPosesion = condExp.getSituacionPosesoria();
			String txtPosesion = "";
			if (poseInicial==null) {
				txtPosesion += "";
			} else {
				if (poseInicial.equals(new Integer(1))) {
					txtPosesion += "El ofertante requiere que haya posesión inicial.";
				} else {
					txtPosesion += "El ofertante acepta que no haya posesión inicial.";
				}
			}
			if (sitaPosesion==null) {
				txtPosesion += "El ofertante acepta cualquier situación posesoria.";
			} else {
				if (sitaPosesion.getCodigo().equals(DDSituacionesPosesoria.SITUACION_POSESORIA_LIBRE)) {
					txtPosesion += "El ofertante requiere que el activo esté libre de ocupantes.";
				} else if (sitaPosesion.getCodigo().equals(DDSituacionesPosesoria.SITUACION_POSESORIA_OCUPADO_CON_TITULO)) {
					txtPosesion += "El ofertante acepta que el activo esté arrendado.";
				}
			}
			mapaValores.put("Posesion", txtPosesion);
			
//			Si hay contenido en impuestos y en el combo "por cuenta de" pone "comprador": El comprador asume el pago de los impuestos pendientes.
//			Si hay contenido en comunidades y en el combo "por cuenta de" pone "vendedor": El comprador no asume el pago de los impuestos pendientes.
//			Si hay contenido en otros y en el combo "por cuenta de" pone "según ley": El comprador requiere que los gastos sean asumidos por quien corresponda según ley.
			DDTiposPorCuenta porCuentaImpuestos = condExp.getTipoPorCuentaImpuestos();
			DDTiposPorCuenta porCuentaComunidad = condExp.getTipoPorCuentaComunidad();
			DDTiposPorCuenta porCuentaOtros = condExp.getTipoPorCuentaCargasOtros();
			String txtCargas = "";
			if (condExp.getCargasImpuestos()!=null && porCuentaImpuestos!=null && porCuentaImpuestos.getCodigo().equals(DDTiposPorCuenta.TIPOS_POR_CUENTA_COMPRADOR)) {
				txtCargas += "El comprador asume el pago de los impuestos pendientes. ";
			}
			if (condExp.getCargasComunidad()!=null && porCuentaComunidad!=null && porCuentaComunidad.getCodigo().equals(DDTiposPorCuenta.TIPOS_POR_CUENTA_VENDEDOR)) {
				txtCargas += "El comprador no asume el pago de los impuestos pendientes. ";
			}
			if (condExp.getCargasOtros()!=null && porCuentaOtros!=null && porCuentaOtros.getCodigo().equals(DDTiposPorCuenta.TIPOS_POR_CUENTA_SEGUN_LEY)) {
				txtCargas += "El comprador requiere que los gastos sean asumidos por quien corresponda según ley. ";
			}
			mapaValores.put("Tratamientodecargas", txtCargas);

			if (activo.getInfoRegistral()!=null && activo.getInfoRegistral().getInfoRegistralBien()!=null) {
				if (activo.getInfoRegistral().getInfoRegistralBien().getFechaInscripcion()==null) {
					mapaValores.put("Inscripcion", "SI");
				} else {
					mapaValores.put("Inscripcion", "NO");
				}				
				mapaValores.put("Registro",FileUtilsREM.stringify(activo.getInfoRegistral().getInfoRegistralBien().getCodigoRegistro()));
				mapaValores.put("RegistroNo",FileUtilsREM.stringify(activo.getInfoRegistral().getInfoRegistralBien().getNumRegistro()));
				mapaValores.put("Tomo",FileUtilsREM.stringify(activo.getInfoRegistral().getInfoRegistralBien().getTomo()));
				mapaValores.put("Libro",FileUtilsREM.stringify(activo.getInfoRegistral().getInfoRegistralBien().getLibro()));
				mapaValores.put("Folio",FileUtilsREM.stringify(activo.getInfoRegistral().getInfoRegistralBien().getFolio()));
			} else {
				mapaValores.put("Inscripcion", FileUtilsREM.stringify(null));
				mapaValores.put("Registro",FileUtilsREM.stringify(null));
				mapaValores.put("RegistroNo",FileUtilsREM.stringify(null));
				mapaValores.put("Tomo",FileUtilsREM.stringify(null));
				mapaValores.put("Libro",FileUtilsREM.stringify(null));
				mapaValores.put("Folio",FileUtilsREM.stringify(null));
			}
			
			mapaValores.put("TipoPropiedad",FileUtilsREM.stringify(this.getTipoPropiedadActivo(activo)));

			Double participacion = activoOferta.getPorcentajeParticipacion();
			
			Double importeA;
			if(oferta.getImporteContraOferta() != null) {
				importeA = oferta.getImporteContraOferta();
			} else {
				importeA = oferta.getImporteOferta()*participacion;
			}

			if (importeA==null) {
				importeA = new Double(0);
			}
			Double impuestoB = new Double(0);
			if (condExp.getTipoAplicable()!=null) {
				impuestoB = condExp.getTipoAplicable()*importeA;
			}
			Double cobrada = new Double(0);
			
			mapaValores.put("importeA",FileUtilsREM.stringify(importeA));
			if (condExp.getTipoAplicable()!=null) {
				mapaValores.put("impuestoB",FileUtilsREM.stringify(impuestoB));
				mapaValores.put("importeAB",FileUtilsREM.stringify(importeA*(1+condExp.getTipoAplicable())));
			} else {
				mapaValores.put("impuestoB",FileUtilsREM.stringify(null));
				mapaValores.put("importeAB",FileUtilsREM.stringify(null));
			}
			if (DDTipoCalculo.TIPO_CALCULO_PORCENTAJE.equals(condExp.getTipoCalculoReserva()) ) {
				mapaValores.put("cobrada", FileUtilsREM.stringify(condExp.getPorcentajeReserva()*importeA));
				cobrada = condExp.getPorcentajeReserva()*importeA;
			} else {
				Double importeReserva = condExp.getImporteReserva();
				if (importeReserva!=null ) {
					mapaValores.put("cobrada", FileUtilsREM.stringify(importeReserva));
					cobrada = importeReserva;
				} else {
					mapaValores.put("cobrada", FileUtilsREM.stringify(null));					
				}
			}
			mapaValores.put("importeCobr",FileUtilsREM.stringify(importeA+impuestoB-cobrada));
			
			mapaValores.put("sujecion",FileUtilsREM.stringify(this.getSujecionDirecta(condExp)));
			
			mapaValores.put("renuncia",FileUtilsREM.stringify(condExp.getRenunciaExencion()));

			if(condExp.getSolicitaFinanciacion() != null) {
				mapaValores.put("financiacion",FileUtilsREM.stringify(condExp.getSolicitaFinanciacion() == 1 ? "Si" : "No"));
			}

			if (condExp.getTipoImpuesto()!=null) {
				mapaValores.put("tipoImpuesto",FileUtilsREM.stringify(condExp.getTipoImpuesto().getDescripcionLarga()));
			} else {
				mapaValores.put("tipoImpuesto",FileUtilsREM.stringify(null));
			}
			
			mapaValores.put("porcentajeImp",FileUtilsREM.stringify(condExp.getPorcentajeReserva()));
			
			
			List<ActivoTasacion> listActivoTasacion = activoDao.getListActivoTasacionByIdActivo(activo.getId());
			if (listActivoTasacion!=null &&
				listActivoTasacion.size()>0 &&
				listActivoTasacion.get(0)!=null &&
				listActivoTasacion.get(0).getFechaRecepcionTasacion()!=null) {
				mapaValores.put("tasacion716",FileUtilsREM.stringify(listActivoTasacion.get(0).getImporteTasacionFin()));
				mapaValores.put("fechaTasacion",FileUtilsREM.stringify(listActivoTasacion.get(0).getFechaRecepcionTasacion()));
			} else {
				mapaValores.put("tasacion716",FileUtilsREM.stringify(null));
				mapaValores.put("fechaTasacion",FileUtilsREM.stringify(null));
			}
			
			mapaValores.put("ImporteImpuestos", FileUtilsREM.stringify(condExp.getCargasImpuestos()));
			mapaValores.put("ImporteComunidades", FileUtilsREM.stringify(condExp.getCargasComunidad()));
			mapaValores.put("ImporteOtros", FileUtilsREM.stringify(condExp.getCargasOtros()));
			
			mapaValores.put("ImporteNotaria", FileUtilsREM.stringify(condExp.getGastosNotaria()));
			mapaValores.put("ImportePlusvalia", FileUtilsREM.stringify(condExp.getGastosPlusvalia()));
			mapaValores.put("ImporteCVOtros", FileUtilsREM.stringify(condExp.getGastosOtros()));
			
			DDTiposPorCuenta tipoImpuestos = condExp.getTipoPorCuentaImpuestos();
			if (tipoImpuestos!=null) {
				mapaValores.put("Impuestos", FileUtilsREM.stringify(tipoImpuestos.getDescripcionLarga()));
			} else {
				mapaValores.put("Impuestos", FileUtilsREM.stringify(null));
			}
			DDTiposPorCuenta tipoComunidades = condExp.getTipoPorCuentaComunidad();
			if (tipoComunidades!=null) {
				mapaValores.put("Comunidades", FileUtilsREM.stringify(tipoComunidades.getDescripcionLarga()));
			} else {
				mapaValores.put("Comunidades", FileUtilsREM.stringify(null));
			}
			DDTiposPorCuenta tipoOtros = condExp.getTipoPorCuentaGastosOtros();
			if (tipoOtros!=null) {
				mapaValores.put("Otros", FileUtilsREM.stringify(tipoOtros.getDescripcionLarga()));
			} else {
				mapaValores.put("Otros", FileUtilsREM.stringify(null));
			}
			DDTiposPorCuenta tipoPlusValia = condExp.getTipoPorCuentaPlusvalia();
			if (tipoPlusValia!=null) {
				mapaValores.put("Plusvalia", FileUtilsREM.stringify(tipoPlusValia.getDescripcionLarga()));
			} else {
				mapaValores.put("Plusvalia", FileUtilsREM.stringify(null));
			}
			DDTiposPorCuenta tipoNotaria = condExp.getTipoPorCuentaNotaria();
			if (tipoNotaria!=null) {
				mapaValores.put("Notaria", FileUtilsREM.stringify(tipoNotaria.getDescripcionLarga()));
			} else {
				mapaValores.put("Notaria", FileUtilsREM.stringify(null));
			}
			DDTiposPorCuenta tipoOtrosCV = condExp.getTipoPorCuentaGastosOtros();
			if (tipoOtrosCV!=null) {
				mapaValores.put("OtrosImporteOferta",  FileUtilsREM.stringify(tipoOtrosCV.getDescripcionLarga()));
			} else {
				mapaValores.put("OtrosImporteOferta", FileUtilsREM.stringify(null));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return mapaValores;
	}

	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> paramsCabeceraHojaDatos(ActivoOferta activoOferta, ModelMap model) {
		Oferta oferta = null;
		Activo activo = null;
		ExpedienteComercial expediente = null;
		Map<String, Object> mapaValores = new HashMap<String, Object>();

		try {
			
			if(!Checks.esNulo(activoOferta)){
				activo = activoOferta.getPrimaryKey().getActivo();
				oferta = activoOferta.getPrimaryKey().getOferta();
			}

			if(Checks.esNulo(activo)){
				model.put("error", RestApi.REST_NO_RELATED_ASSET);
				throw new Exception(RestApi.REST_NO_RELATED_ASSET);
			}
			
			if(Checks.esNulo(oferta)){
				model.put("error", RestApi.REST_NO_RELATED_OFFER);
				throw new Exception(RestApi.REST_NO_RELATED_OFFER);
			}

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
			expediente = (ExpedienteComercial) genericDao.get(ExpedienteComercial.class, filtro);

			if (expediente==null) {
				model.put("error", RestApi.REST_NO_RELATED_EXPEDIENT);
				throw new Exception(RestApi.REST_NO_RELATED_EXPEDIENT);					
			}
			
			CondicionanteExpediente condExp = expediente.getCondicionante();
			if (condExp==null) {
				model.put("error", RestApi.REST_NO_RELATED_COND_EXPEDIENT);
				throw new Exception(RestApi.REST_NO_RELATED_COND_EXPEDIENT);					
			}
			
			
			//Número total activos
			mapaValores.put("NoTotalActivos", String.valueOf(oferta.getActivosOferta().size()));
			
			if (activo.getCartera()!=null && activo.getCartera().getCodigo()!=null) {
				mapaValores.put("Cartera", FileUtilsREM.stringify(activo.getCartera().getCodigo().toString()));
				mapaValores.put("NomCartera", FileUtilsREM.stringify(activo.getCartera().getDescripcion()));
			} else {
				mapaValores.put("Cartera", FileUtilsREM.stringify(null));
				mapaValores.put("NomCartera", FileUtilsREM.stringify(null));
			}

			
//			Si con posesión inicial "sí": El ofertante requiere que haya posesión inicial.
//			Si con posesión inicial "no": El ofertante acepta que no haya posesión inicial.
//			Si con situación posesoria "vacío": El ofertante acepta cualquier situación posesoria.
//			Si con situación posesoria "libre": El ofertante requiere que el activo esté libre de ocupantes.
//			Si con situación posesoria "ocupado con título": El ofertante acepta que el activo esté arrendado.
			Integer poseInicial = condExp.getPosesionInicial();
			DDSituacionesPosesoria sitaPosesion = condExp.getSituacionPosesoria();
			String txtPosesion = "";
			if (poseInicial==null) {
				txtPosesion += "";
			} else {
				if (poseInicial.equals(new Integer(1))) {
					txtPosesion += "El ofertante requiere que haya posesión inicial.";
				} else {
					txtPosesion += "El ofertante acepta que no haya posesión inicial.";
				}
			}
			if (sitaPosesion==null) {
				txtPosesion += "El ofertante acepta cualquier situación posesoria.";
			} else {
				if (sitaPosesion.getCodigo().equals(DDSituacionesPosesoria.SITUACION_POSESORIA_LIBRE)) {
					txtPosesion += "El ofertante requiere que el activo esté libre de ocupantes.";
				} else if (sitaPosesion.getCodigo().equals(DDSituacionesPosesoria.SITUACION_POSESORIA_OCUPADO_CON_TITULO)) {
					txtPosesion += "El ofertante acepta que el activo esté arrendado.";
				}
			}
			mapaValores.put("Posesion", txtPosesion);
			
//			Si hay contenido en impuestos y en el combo "por cuenta de" pone "comprador": El comprador asume el pago de los impuestos pendientes.
//			Si hay contenido en comunidades y en el combo "por cuenta de" pone "vendedor": El comprador no asume el pago de los impuestos pendientes.
//			Si hay contenido en otros y en el combo "por cuenta de" pone "según ley": El comprador requiere que los gastos sean asumidos por quien corresponda según ley.
			DDTiposPorCuenta porCuentaImpuestos = condExp.getTipoPorCuentaImpuestos();
			DDTiposPorCuenta porCuentaComunidad = condExp.getTipoPorCuentaComunidad();
			DDTiposPorCuenta porCuentaOtros = condExp.getTipoPorCuentaCargasOtros();
			String txtCargas = "";
			if (condExp.getCargasImpuestos()!=null && porCuentaImpuestos!=null && porCuentaImpuestos.getCodigo().equals(DDTiposPorCuenta.TIPOS_POR_CUENTA_COMPRADOR)) {
				txtCargas += "El comprador asume el pago de los impuestos pendientes. ";
			}
			if (condExp.getCargasComunidad()!=null && porCuentaComunidad!=null && porCuentaComunidad.getCodigo().equals(DDTiposPorCuenta.TIPOS_POR_CUENTA_VENDEDOR)) {
				txtCargas += "El comprador no asume el pago de los impuestos pendientes. ";
			}
			if (condExp.getCargasOtros()!=null && porCuentaOtros!=null && porCuentaOtros.getCodigo().equals(DDTiposPorCuenta.TIPOS_POR_CUENTA_SEGUN_LEY)) {
				txtCargas += "El comprador requiere que los gastos sean asumidos por quien corresponda según ley. ";
			}
			mapaValores.put("Tratamientodecargas", txtCargas);
			
			mapaValores.put("TipoPropiedad",FileUtilsREM.stringify(this.getTipoPropiedadActivo(activo)));

			Double importeA;
			if(oferta.getImporteContraOferta() != null) {
				importeA = oferta.getImporteContraOferta();
			} else {
				importeA = oferta.getImporteOferta();
			}

			if (importeA==null) {
				importeA = new Double(0);
			}
			Double impuestoB = new Double(0);
			if (condExp.getTipoAplicable()!=null) {
				impuestoB = condExp.getTipoAplicable()*importeA;
			}
			Double cobrada = new Double(0);
			
			mapaValores.put("importeA",FileUtilsREM.stringify(importeA));
			if (condExp.getTipoAplicable()!=null) {
				mapaValores.put("impuestoB",FileUtilsREM.stringify(impuestoB));
				mapaValores.put("importeAB",FileUtilsREM.stringify(importeA*(1+condExp.getTipoAplicable())));
			} else {
				mapaValores.put("impuestoB",FileUtilsREM.stringify(null));
				mapaValores.put("importeAB",FileUtilsREM.stringify(null));
			}
			if (DDTipoCalculo.TIPO_CALCULO_PORCENTAJE.equals(condExp.getTipoCalculoReserva()) ) {
				mapaValores.put("cobrada", FileUtilsREM.stringify(condExp.getPorcentajeReserva()*importeA));
				cobrada = condExp.getPorcentajeReserva()*importeA;
			} else {
				Double importeReserva = condExp.getImporteReserva();
				if (importeReserva!=null ) {
					mapaValores.put("cobrada", FileUtilsREM.stringify(importeReserva));
					cobrada = importeReserva;
				} else {
					mapaValores.put("cobrada", FileUtilsREM.stringify(null));					
				}
			}
			mapaValores.put("importeCobr",FileUtilsREM.stringify(importeA+impuestoB-cobrada));
			
			mapaValores.put("sujecion",FileUtilsREM.stringify(this.getSujecionDirecta(condExp)));
			
			mapaValores.put("renuncia",FileUtilsREM.stringify(condExp.getRenunciaExencion()));

			if(condExp.getSolicitaFinanciacion() != null) {
				mapaValores.put("financiacion",FileUtilsREM.stringify(condExp.getSolicitaFinanciacion() == 1 ? "Si" : "No"));
			}

			if (condExp.getTipoImpuesto()!=null) {
				mapaValores.put("tipoImpuesto",FileUtilsREM.stringify(condExp.getTipoImpuesto().getDescripcionLarga()));
			} else {
				mapaValores.put("tipoImpuesto",FileUtilsREM.stringify(null));
			}
			
			mapaValores.put("porcentajeImp",FileUtilsREM.stringify(condExp.getPorcentajeReserva()));
			
			if (activo!=null) {
				List<ActivoTasacion> listActivoTasacion = activoDao.getListActivoTasacionByIdActivo(activo.getId());
				if (listActivoTasacion!=null &&
					listActivoTasacion.size()>0 &&
					listActivoTasacion.get(0)!=null &&
					listActivoTasacion.get(0).getFechaRecepcionTasacion()!=null) {
					mapaValores.put("tasacion716",FileUtilsREM.stringify(listActivoTasacion.get(0).getImporteTasacionFin()));
					mapaValores.put("fechaTasacion",FileUtilsREM.stringify(listActivoTasacion.get(0).getFechaRecepcionTasacion()));
				} else {
					mapaValores.put("tasacion716",FileUtilsREM.stringify(null));
					mapaValores.put("fechaTasacion",FileUtilsREM.stringify(null));
				}
			} else {
				mapaValores.put("tasacion716",FileUtilsREM.stringify(null));
				mapaValores.put("fechaTasacion",FileUtilsREM.stringify(null));
			}
			
			mapaValores.put("ImporteImpuestos", FileUtilsREM.stringify(condExp.getCargasImpuestos()));
			mapaValores.put("ImporteComunidades", FileUtilsREM.stringify(condExp.getCargasComunidad()));
			mapaValores.put("ImporteOtros", FileUtilsREM.stringify(condExp.getCargasOtros()));
			
			mapaValores.put("ImporteNotaria", FileUtilsREM.stringify(condExp.getGastosNotaria()));
			mapaValores.put("ImportePlusvalia", FileUtilsREM.stringify(condExp.getGastosPlusvalia()));
			mapaValores.put("ImporteCVOtros", FileUtilsREM.stringify(condExp.getGastosOtros()));
			
			DDTiposPorCuenta tipoImpuestos = condExp.getTipoPorCuentaImpuestos();
			if (tipoImpuestos!=null) {
				mapaValores.put("Impuestos", FileUtilsREM.stringify(tipoImpuestos.getDescripcionLarga()));
			} else {
				mapaValores.put("Impuestos", FileUtilsREM.stringify(null));
			}
			DDTiposPorCuenta tipoComunidades = condExp.getTipoPorCuentaComunidad();
			if (tipoComunidades!=null) {
				mapaValores.put("Comunidades", FileUtilsREM.stringify(tipoComunidades.getDescripcionLarga()));
			} else {
				mapaValores.put("Comunidades", FileUtilsREM.stringify(null));
			}
			DDTiposPorCuenta tipoOtros = condExp.getTipoPorCuentaGastosOtros();
			if (tipoOtros!=null) {
				mapaValores.put("Otros", FileUtilsREM.stringify(tipoOtros.getDescripcionLarga()));
			} else {
				mapaValores.put("Otros", FileUtilsREM.stringify(null));
			}
			DDTiposPorCuenta tipoPlusValia = condExp.getTipoPorCuentaPlusvalia();
			if (tipoPlusValia!=null) {
				mapaValores.put("Plusvalia", FileUtilsREM.stringify(tipoPlusValia.getDescripcionLarga()));
			} else {
				mapaValores.put("Plusvalia", FileUtilsREM.stringify(null));
			}
			DDTiposPorCuenta tipoNotaria = condExp.getTipoPorCuentaNotaria();
			if (tipoNotaria!=null) {
				mapaValores.put("Notaria", FileUtilsREM.stringify(tipoNotaria.getDescripcionLarga()));
			} else {
				mapaValores.put("Notaria", FileUtilsREM.stringify(null));
			}
			DDTiposPorCuenta tipoOtrosCV = condExp.getTipoPorCuentaGastosOtros();
			if (tipoOtrosCV!=null) {
				mapaValores.put("OtrosImporteOferta",  FileUtilsREM.stringify(tipoOtrosCV.getDescripcionLarga()));
			} else {
				mapaValores.put("OtrosImporteOferta", FileUtilsREM.stringify(null));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return mapaValores;
	}
	
	
	
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Object> dataSourceHojaDatos(ActivoOferta activoOferta, ModelMap model) {
		Activo activo = null;
		Oferta oferta = null;
		List<Object> array = new ArrayList<Object>();
		
		DtoDataSource dataSource = new DtoDataSource();
		
		List<Object> listaComprador = new ArrayList<Object>();
		try {
			
			if(!Checks.esNulo(activoOferta)){
				activo = activoOferta.getPrimaryKey().getActivo();
				oferta = activoOferta.getPrimaryKey().getOferta();
			}
			
			if(Checks.esNulo(activo)){
				model.put("error", RestApi.REST_NO_RELATED_ASSET);
				throw new Exception(RestApi.REST_NO_RELATED_ASSET);
			}
			
			if(Checks.esNulo(oferta)){
				model.put("error", RestApi.REST_NO_RELATED_ASSET);
				throw new Exception(RestApi.REST_NO_RELATED_ASSET);
			}
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
			ExpedienteComercial expediente = (ExpedienteComercial) genericDao.get(ExpedienteComercial.class, filtro);
			if (expediente==null) {
				model.put("error", RestApi.REST_NO_RELATED_EXPEDIENT);
				throw new Exception(RestApi.REST_NO_RELATED_EXPEDIENT);					
			} else {
				List<CompradorExpediente> listaCompradorExpediente = expediente.getCompradores();
				DtoComprador dtoComprador = null;
				for (int i = 0; i < listaCompradorExpediente.size(); i++) {
					CompradorExpediente compradorExpediente = listaCompradorExpediente.get(i);
					Comprador comprador = listaCompradorExpediente.get(i).getPrimaryKey().getComprador();
					dtoComprador = new DtoComprador();
					dtoComprador.setNombreComprador(FileUtilsREM.stringify(comprador.getFullName()));
					dtoComprador.setDireccionComprador(FileUtilsREM.stringify(comprador.getDireccion()));
					dtoComprador.setDniComprador(FileUtilsREM.stringify(comprador.getDocumento()));
					if (comprador.getTelefono2()==null) {
						dtoComprador.setTlfComprador(FileUtilsREM.stringify(comprador.getTelefono1()));
					} else {
						dtoComprador.setTlfComprador(FileUtilsREM.stringify(comprador.getTelefono1()+"/"+comprador.getTelefono2()));
					}
					dtoComprador.setrBienesComprador(FileUtilsREM.stringify(null));
					if (compradorExpediente.getEstadoCivil()!=null) {
						dtoComprador.seteCivilComprador(FileUtilsREM.stringify(compradorExpediente.getEstadoCivil().getDescripcionLarga()));
					} else  {
						dtoComprador.seteCivilComprador(FileUtilsREM.stringify(null));
					}
					dtoComprador.setPorcentajeComprador(FileUtilsREM.stringify(compradorExpediente.getPorcionCompra()));
					listaComprador.add(dtoComprador);
				}
				
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		dataSource.setListaComprador(listaComprador);
		array.add(dataSource);
		
		return array;
	}

	@SuppressWarnings("unchecked")
	@Override
	public File getPDFFile(Map<String, Object> params, List<Object> dataSource, String template, ModelMap model, Long numExpediente) {
				
		String ficheroPlantilla = "jasper/"+template+".jrxml";
		
		InputStream is = this.getClass().getClassLoader().getResourceAsStream(ficheroPlantilla);
		File fileSalidaTemporal = null;
		
		//Comprobar si existe el fichero de la plantilla
		if (is == null) {
			model.put("error","No existe el fichero de plantilla " + ficheroPlantilla);
		} else  {
			try {
				//Compilar la plantilla
				JasperReport report = JasperCompileManager.compileReport(is);	
				//JasperReport report = (JasperReport)JRLoader.loadObject(is);

				//Rellenar los datos del informe
				JasperPrint print = JasperFillManager.fillReport(report, params,  new JRBeanCollectionDataSource(dataSource));

				//Exportar el informe a PDF
				fileSalidaTemporal = File.createTempFile("Hoja Datos Exp." + String.valueOf(numExpediente) + " - ", ".pdf");
				fileSalidaTemporal.deleteOnExit();
				if (fileSalidaTemporal.exists()) {
					JasperExportManager.exportReportToPdfStream(print, new FileOutputStream(fileSalidaTemporal));
					FileItem fi = new FileItem();
					fi.setFileName(ficheroPlantilla + (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + ".pdf");
					fi.setFile(fileSalidaTemporal);
				} else {
					throw new IllegalStateException("Error al generar el fichero de salida " + fileSalidaTemporal);
				}
				
			} catch (JRException e) {
				model.put("error","Error al compilar el informe en JasperReports " + e.getLocalizedMessage());
			} catch (IOException e) {
				model.put("error","No se puede escribir el fichero de salida");
			} catch (Exception e) {
				model.put("error","Error al generar el informe en JasperReports " + e.getLocalizedMessage());
			};
		}
		
		return fileSalidaTemporal;

	}
	
	private String getTipoPropiedadActivo(Activo activo) {
		if ((activo != null) 
				&& (!Checks.estaVacio(activo.getPropietariosActivo())) 
				&& (!Checks.esNulo(activo.getPropietariosActivo().get(0).getTipoGradoPropiedad()))){
			
			return activo.getPropietariosActivo().get(0).getTipoGradoPropiedad().getDescripcion();
			
		} else {
			return null;
		}
	}
	
	private Boolean getSujecionDirecta (CondicionanteExpediente condExp) {
		if ((condExp != null) 
				&& (condExp.getTipoImpuesto() != null) 	
				&& (DDTiposImpuesto.TIPO_IMPUESTO_IVA.equals(condExp.getTipoImpuesto().getCodigo()))
				&& (! Boolean.TRUE.equals(condExp.getRenunciaExencion()))) {
				
			return true;
		} else {
			return false;
		}
	}

	
}
