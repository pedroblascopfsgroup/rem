package es.pfsgroup.plugin.rem.api.impl;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.HojaDatosApi;
import es.pfsgroup.plugin.rem.api.HojaDatosPDF;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionJudicial;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoAnejo;
import es.pfsgroup.plugin.rem.model.ActivoDistribucion;
import es.pfsgroup.plugin.rem.model.ActivoEdificio;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
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
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.TextosOferta;
import es.pfsgroup.plugin.rem.model.VBusquedaDatosCompradorExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionesPosesoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAnejo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoHabitaculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPorCuenta;
import es.pfsgroup.plugin.rem.model.dd.DDTiposTextoOferta;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.utils.FileUtilsREM;

@Service("propuestaOfertaManager")
public class PropuestaOfertaManager extends HojaDatosPDF implements HojaDatosApi {

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
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> paramsHojaDatos(Oferta oferta, ModelMap model) {
		
		Map<String, Object> mapaValores = new HashMap<String,Object>();
		try {

			mapaValores.put("NumOfProp", oferta.getNumOferta()+"/1");
			
			//Obteniedo el activo relacionado con la OFERTA
			Activo activo = oferta.getActivoPrincipal();
			if (activo == null) {
				model.put("error", RestApi.REST_NO_RELATED_ASSET);
				throw new Exception(RestApi.REST_NO_RELATED_ASSET);
			}
			mapaValores.put("Activo", activo.getNumActivoUvem().toString());
			
			mapaValores.put("FRecepOf", FileUtilsREM.stringify(oferta.getFechaAlta()) );
			mapaValores.put("FProp", FileUtilsREM.stringify(new Date()));

			Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", "GCOM");
			Long tipo = genericDao.get(EXTDDTipoGestor.class, filter).getId();		
			if (gestorActivoApi.getGestorByActivoYTipo(activo, tipo)!=null) {
				mapaValores.put("Gestor", gestorActivoApi.getGestorByActivoYTipo(activo, tipo).getApellidoNombre());
			} else {
				mapaValores.put("Gestor", FileUtilsREM.stringify(null));
			}
			
			mapaValores.put("FPublWeb", FileUtilsREM.stringify(activo.getFechaPublicable()));
			mapaValores.put("NumVisitasWeb", FileUtilsREM.stringify(activo.getVisitas().size()));
			
			mapaValores.put("Direccion",FileUtilsREM.stringify(activo.getDireccion()));
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
			if (activo.getTipoUsoDestino()!=null) {
				mapaValores.put("Residencia",activo.getTipoUsoDestino().getDescripcionLarga());
			} else {
				mapaValores.put("Residencia",FileUtilsREM.stringify(null)); 
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
			//mapaValores.put("SuperficieUtil",FileUtilsREM.stringify(activo.getTotalSuperficieUtil()));
			//mapaValores.put("SuperficieRegistro",FileUtilsREM.stringify(activo.getTotalSuperficieSuelo()));
			mapaValores.put("Parcela",FileUtilsREM.stringify(activo.getTotalSuperficieParcela()));
			List<ActivoPropietarioActivo> listaPropietarios = activo.getPropietariosActivo();
			if (listaPropietarios!=null && listaPropietarios.get(0).getPropietario()!=null && listaPropietarios.get(0).getPropietario().getFullName()!=null){
				mapaValores.put("SociedadPatrimonial",listaPropietarios.get(0).getPropietario().getFullName()); 
			} else {
				mapaValores.put("SociedadPatrimonial",FileUtilsREM.stringify(null)); 
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
			if (activo.getInfoComercial()!=null) {
				mapaValores.put("FRecepcionLlaves",FileUtilsREM.stringify(activo.getInfoComercial().getFechaRecepcionLlaves()));
			} else {
				mapaValores.put("FRecepcionLlaves",FileUtilsREM.stringify(null));
			}
			ActivoAdjudicacionJudicial adjudicacionJudicial = activo.getAdjJudicial();
			if (adjudicacionJudicial!=null) {
				mapaValores.put("FEntradaCartera",FileUtilsREM.stringify(adjudicacionJudicial.getFechaAdjudicacion()));
				if (adjudicacionJudicial.getEstadoAdjudicacion()!=null) {
					mapaValores.put("SituacionProcesal",FileUtilsREM.stringify(adjudicacionJudicial.getEstadoAdjudicacion().getDescripcion()));				
				} else {
					mapaValores.put("SituacionProcesal",FileUtilsREM.stringify(null));			
				}
			} else {
				mapaValores.put("FEntradaCartera",FileUtilsREM.stringify(null));		
				mapaValores.put("SituacionProcesal",FileUtilsREM.stringify(null));		
			}


			boolean estaInscrito = false;
			boolean estaLiquidado = false;
			if (activo.getAdjJudicial()!=null && activo.getAdjJudicial().getAdjudicacionBien()!=null) {
				estaInscrito = (activo.getAdjJudicial().getAdjudicacionBien().getFechaPresentacionIns()!=null);
				estaLiquidado = (activo.getAdjJudicial().getAdjudicacionBien().getFechaPresentacionHacienda()!=null);
				if (activo.getAdjJudicial().getAdjudicacionBien().getFechaRealizacionPosesion()!=null) {
					mapaValores.put("Disponibilidadjuridica","Disponible");
				} else {
					mapaValores.put("Disponibilidadjuridica","No disponible.");
				}
			} else {
				mapaValores.put("Disponibilidadjuridica",FileUtilsREM.stringify(null));
			}
			if (estaInscrito && estaLiquidado) {
				mapaValores.put("SituacionLiquidacionInscripcion","Titulo inscrito y liquidado.");
			} else if (!estaInscrito && estaLiquidado) {
				mapaValores.put("SituacionLiquidacionInscripcion","Titulo liquidado pero no inscrito.");
			} else if (estaInscrito && !estaLiquidado) {
				mapaValores.put("SituacionLiquidacionInscripcion","Titulo inscrito pero no liquidado.");
			} else if (!estaInscrito && !estaLiquidado) {
				mapaValores.put("SituacionLiquidacionInscripcion","Titulo sin inscribir ni liquidar.");
			} 
			
			if (new Integer(1).equals(activo.getConCargas())) {
				mapaValores.put("Situaciondecargas","CON CARGAS");
			} else {
				mapaValores.put("Situaciondecargas","SIN CARGAS");
			}
			PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activo.getId());
			if (new Integer(1).equals(perimetroActivo.getAplicaComercializar())) {
				mapaValores.put("Comercializacion","SI");
			} else {
				mapaValores.put("Comercializacion","NO");
			}
			if (activo.getTipoTitulo()!=null) {
				mapaValores.put("Entrada",FileUtilsREM.stringify(activo.getTipoTitulo().getDescripcionLarga()));
			} else {
				mapaValores.put("Entrada",FileUtilsREM.stringify(null));
			}
			mapaValores.put("CantidadOfertas", FileUtilsREM.stringify(activoApi.cantidadOfertas(activo)));
			Double mayorOfertaRecibida = activoApi.mayorOfertaRecibida(activo);
			mapaValores.put("MayorOfertaRecibida", FileUtilsREM.stringify(mayorOfertaRecibida));
			
			mapaValores.put("ImportePropuesta", FileUtilsREM.stringify(oferta.getImporteOfertaAprobado()));
			mapaValores.put("ImporteInicial", FileUtilsREM.stringify(oferta.getImporteOferta()));
			mapaValores.put("FechaContraoferta", FileUtilsREM.stringify(oferta.getFechaContraoferta()));
			mapaValores.put("Contraoferta", FileUtilsREM.stringify(oferta.getImporteContraOferta())); 
			
			Oferta ofertaAceptada = ofertaApi.getOfertaAceptadaByActivo(activo);
			if (ofertaAceptada==null) {
				model.put("error", RestApi.REST_NO_RELATED_OFFER_ACCEPTED);
				throw new Exception(RestApi.REST_NO_RELATED_OFFER_ACCEPTED);					
			}
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id", ofertaAceptada.getId());
			ExpedienteComercial expediente = (ExpedienteComercial) genericDao.get(ExpedienteComercial.class, filtro);
			if (expediente==null) {
				model.put("error", RestApi.REST_NO_RELATED_EXPEDIENT);
				throw new Exception(RestApi.REST_NO_RELATED_EXPEDIENT);					
			}
			CondicionanteExpediente condExp = expediente.getCondicionante();
			if (condExp==null) {
				model.put("error", RestApi.REST_NO_RELATED_COND_EXPEDIENT);
				throw new Exception(RestApi.REST_NO_RELATED_COND_EXPEDIENT);					
			}

			mapaValores.put("Contraoferta", FileUtilsREM.stringify(oferta.getImporteContraOferta()));	
			
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
			
			mapaValores.put("Impuestos", FileUtilsREM.stringify(condExp.getCargasImpuestos()));
			mapaValores.put("Comunidades", FileUtilsREM.stringify(condExp.getCargasComunidad()));
			mapaValores.put("Otros", FileUtilsREM.stringify(condExp.getCargasOtros()));
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
			
			mapaValores.put("Importe", FileUtilsREM.stringify(condExp.getGastosNotaria()));
			mapaValores.put("OpCondicionadaa", "-");
			
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
			DDTiposPorCuenta tipoOtros = condExp.getTipoPorCuentaGastosOtros();
			if (tipoOtros!=null) {
				mapaValores.put("OtrosImporteOferta",  FileUtilsREM.stringify(tipoOtros.getDescripcionLarga()));
			} else {
				mapaValores.put("OtrosImporteOferta", FileUtilsREM.stringify(null));
			}
			if (condExp!=null) {
				if (DDTipoCalculo.TIPO_CALCULO_PORCENTAJE.equals(condExp.getTipoCalculoReserva()) ) {
					mapaValores.put("Reserva", FileUtilsREM.stringify(condExp.getPorcentajeReserva()*oferta.getImporteOferta()));
				} else {
					Double importeReserva = condExp.getImporteReserva();
					Double importeOferta = oferta.getImporteOferta();
					if (importeOferta!= null && importeReserva!=null ) {
						mapaValores.put("Reserva", FileUtilsREM.stringify( 100*(importeReserva/importeOferta) ));
					} else {
						mapaValores.put("Reserva", FileUtilsREM.stringify(null));
					}
				}
			}
			//importe RESERVA/importe OFERTA duda COE_CONDICIONANTES_EXPEDIENTE -> RES_RESERVAS
			//sumatorio de ERE_ENTREGAS_RESERVA para el exp
			if (activo.getInfoRegistral()!=null && activo.getInfoRegistral().getInfoRegistralBien()!=null) {
				if (activo.getInfoRegistral().getInfoRegistralBien().getFechaInscripcion()==null) {
					mapaValores.put("Inscripcion", "SI");
				} else {
					mapaValores.put("Inscripcion", "NO");
				}
			}			
			
			
			if (!Checks.estaVacio(activo.getTasacion()))
			{
				//De la lista de tasaciones que tiene el activo cogemos la más reciente
				ActivoTasacion tasacionMasReciente = activo.getTasacion().get(0);
				if (tasacionMasReciente!=null) {
					Date fechaValorTasacionMasReciente = new Date();
					if (tasacionMasReciente.getValoracionBien().getFechaValorTasacion() != null)
					{
						fechaValorTasacionMasReciente = tasacionMasReciente.getValoracionBien().getFechaValorTasacion();
					}
					for (int i = 0; i < activo.getTasacion().size(); i++) {
						ActivoTasacion tas = activo.getTasacion().get(i);
						if (tas.getValoracionBien().getFechaValorTasacion() != null
								&& tas.getValoracionBien().getFechaValorTasacion().after(fechaValorTasacionMasReciente)) {
							fechaValorTasacionMasReciente = tas.getValoracionBien().getFechaValorTasacion();
							tasacionMasReciente = tas;
						}
					}
					mapaValores.put("ValorTasacion",  FileUtilsREM.stringify(tasacionMasReciente.getValoracionBien().getImporteValorTasacion()));
					mapaValores.put("ValorTasacionFecha", FileUtilsREM.stringify(tasacionMasReciente.getValoracionBien().getFechaValorTasacion()));
					Double importeTasacion = tasacionMasReciente.getValoracionBien().getImporteValorTasacion().doubleValue();
					if (tasacionMasReciente.getValoracionBien().getImporteValorTasacion()!=null && importeTasacion!=0) {						
						Double valorTasacionDto = 100*( (importeTasacion - mayorOfertaRecibida) / importeTasacion );
						mapaValores.put("ValorTasacionDto", FileUtilsREM.stringify(valorTasacionDto));
					} else {
						mapaValores.put("ValorTasacionDto", FileUtilsREM.stringify(null));
					}
				}  else {
					mapaValores.put("ValorTasacion",  FileUtilsREM.stringify(null));
					mapaValores.put("ValorTasacionFecha", FileUtilsREM.stringify(null));
					mapaValores.put("ValorTasacionDto", FileUtilsREM.stringify(null));
				}
				
				//De la lista de valoraciones del activo obtenemos aquella que tiene en el tipo de precio el valor ESTIMADO_VENTA
				Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
				Filter estimadoVentaTPCFilter = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_ESTIMADO_VENTA);
				ActivoValoraciones activoValoracion = (ActivoValoraciones) genericDao.get(ActivoValoraciones.class, activoFilter, estimadoVentaTPCFilter);
				if (activoValoracion!=null) {
					mapaValores.put("ValorEstColabor", FileUtilsREM.stringify(activoValoracion.getImporte()));
					mapaValores.put("ValorEstColaborFecha", FileUtilsREM.stringify(activoValoracion.getFechaInicio()));
					Double importeTasacion = activoValoracion.getImporte();
					if (importeTasacion!=0) {
						Double valorTasacionDto = 100*( (importeTasacion - mayorOfertaRecibida) / importeTasacion );
						mapaValores.put("ValorEstColaborDto", FileUtilsREM.stringify(valorTasacionDto));
					} else {
						mapaValores.put("ValorEstColaborDto", FileUtilsREM.stringify(null));
					}
				} else {
					mapaValores.put("ValorEstColabor", FileUtilsREM.stringify(null));
					mapaValores.put("ValorEstColaborFecha", FileUtilsREM.stringify(null));
					mapaValores.put("ValorEstColaborDto", FileUtilsREM.stringify(null));
				}
				
				Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
				Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "tipoTexto.codigo", DDTiposTextoOferta.TIPOS_TEXTO_OFERTA_INTERES);
				TextosOferta textoOfertaInteres = genericDao.get(TextosOferta.class, filtro1, filtro2);
				if (textoOfertaInteres!=null){
					mapaValores.put("ComentarioInteres", FileUtilsREM.stringify(textoOfertaInteres.getTexto()));
				} else {
					mapaValores.put("ComentarioInteres", FileUtilsREM.stringify(null));
				}
				filtro1 = genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
				filtro2 = genericDao.createFilter(FilterType.EQUALS, "tipoTexto.codigo", DDTiposTextoOferta.TIPOS_TEXTO_OFERTA_GESTOR);
				TextosOferta textoOfertaGestor = genericDao.get(TextosOferta.class, filtro1, filtro2);
				if (textoOfertaGestor!=null){
					mapaValores.put("ComentarioGestor", FileUtilsREM.stringify(textoOfertaGestor.getTexto()));
				} else {
					mapaValores.put("ComentarioGestor", FileUtilsREM.stringify(null));
				}
				filtro1 = genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
				filtro2 = genericDao.createFilter(FilterType.EQUALS, "tipoTexto.codigo", DDTiposTextoOferta.TIPOS_TEXTO_OFERTA_COMITE);
				TextosOferta textoOfertaComite = genericDao.get(TextosOferta.class, filtro1, filtro2);
				if (textoOfertaComite!=null){
					mapaValores.put("ComentarioComite", FileUtilsREM.stringify(textoOfertaComite.getTexto()));
				} else {
					mapaValores.put("ComentarioComite", FileUtilsREM.stringify(null));
				}
				
				//De la lista de valoraciones del activo obtenemos aquella que tiene el codigo APROVADO_VENTA
				List<ActivoValoraciones> listActivoValoracion = activo.getValoracion();
				if (listActivoValoracion!=null) {
					ActivoValoraciones activoAprobVenta = null;
					Boolean isAprobado = false;
					for (int j = 0; j < listActivoValoracion.size() && !isAprobado; j++)
					{
							ActivoValoraciones tmp = listActivoValoracion.get(j);
							if (DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA.equals(tmp.getTipoPrecio().getCodigo())) {
								activoAprobVenta = tmp;
								isAprobado = true;
							}
					}			
					if (activoAprobVenta!=null) {
						mapaValores.put("ValorAprobVenta", FileUtilsREM.stringify(activoAprobVenta.getImporte()));
						mapaValores.put("ValorAprobVentaFecha", FileUtilsREM.stringify(activoAprobVenta.getFechaInicio()));
						Double importeTasacion = activoAprobVenta.getImporte();
						if (importeTasacion!=0) {
							Double valorTasacionDto = 100*( (importeTasacion - mayorOfertaRecibida) / importeTasacion );
							mapaValores.put("ValorAprobVentaDto", FileUtilsREM.stringify(valorTasacionDto));
						} else {
							mapaValores.put("ValorAprobVentaDto", FileUtilsREM.stringify(null));
						}
					} else {
						mapaValores.put("ValorAprobVenta", FileUtilsREM.stringify(null));
						mapaValores.put("ValorAprobVentaFecha", FileUtilsREM.stringify(null));
						mapaValores.put("ValorAprobVentaDto", FileUtilsREM.stringify(null));
					}
				}
				
			}
			
			//Obtenemos la información de todas las tablas relacionadas con la DESCRIPCION FISICA DEL ACTIVO
			Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			ActivoInfoComercial infoComercial = (ActivoInfoComercial) genericDao.get(ActivoInfoComercial.class, activoFilter);
			
			Filter comercialFilter = genericDao.createFilter(FilterType.EQUALS, "id", infoComercial.getId());
			ActivoVivienda vivienda = (ActivoVivienda) genericDao.get(ActivoVivienda.class, comercialFilter);
			
			Filter infoComercialFilter = genericDao.createFilter(FilterType.EQUALS, "infoComercial.id", infoComercial.getId());
			List<ActivoAnejo> listAnejo = genericDao.getList(ActivoAnejo.class, infoComercialFilter);
			ActivoEdificio edificio = (ActivoEdificio) genericDao.get(ActivoEdificio.class, infoComercialFilter);
			
			//Descripción fisica del EDIFICIO
			if (edificio!=null) {
				mapaValores.put("ActivoEdificio",FileUtilsREM.stringify(edificio.getEdiDescripcion()));
			} else {
				mapaValores.put("ActivoEdificio",FileUtilsREM.stringify(null));
			}
			
			//Todo lo relacionado con la tabla VIVIENDA
			if (vivienda!=null) {
				mapaValores.put("ActivoInterior",FileUtilsREM.stringify(vivienda.getDistribucionTxt()));
				mapaValores.put("ActivoPlantas",FileUtilsREM.stringify(vivienda.getNumPlantasInter()));
				if (vivienda.getEstadoConservacion()!=null) {
					mapaValores.put("ActivoConservacion",FileUtilsREM.stringify(vivienda.getEstadoConservacion().getDescripcionLarga()));
				} else {
					mapaValores.put("ActivoConservacion",FileUtilsREM.stringify(null));
				}
				if (vivienda.getTipoOrientacion()!=null) {
					mapaValores.put("ActivoOrientacion",vivienda.getTipoOrientacion().getDescripcionLarga());
				} else {
					mapaValores.put("ActivoOrientacion",FileUtilsREM.stringify(null));
				}
				//Obtener cuantos habitaciones de cada tipo hay y
				//la superficie en m2 del salon
				Integer dormitorio = null;
				Integer aseo = null;
				Integer patio = null;
				Integer porche = null;
				Integer banyo = null;
				Float salon = null;
				Integer balcon = null;
				Integer hall = null;
				List<ActivoDistribucion> distribucion = vivienda.getDistribucion();
				if (distribucion!=null) {
					for (int i = 0; i < distribucion.size(); i++) {
						if (distribucion.get(i).getTipoHabitaculo().getCodigo().equals(DDTipoHabitaculo.TIPO_HABITACULO_DORMITORIO)) {
							if (dormitorio==null) {
								dormitorio=1;
							} else {
								dormitorio++;
							}
						}
						if (distribucion.get(i).getTipoHabitaculo().getCodigo().equals(DDTipoHabitaculo.TIPO_HABITACULO_ASEO)) {
							if (aseo==null) {
								aseo=1;
							} else {
								aseo++;
							}
						}	
						if (distribucion.get(i).getTipoHabitaculo().getCodigo().equals(DDTipoHabitaculo.TIPO_HABITACULO_PATIO)) {
							if (patio==null) {
								patio=1;
							} else {
								patio++;
							}
						}	
						if (distribucion.get(i).getTipoHabitaculo().getCodigo().equals(DDTipoHabitaculo.TIPO_HABITACULO_PORCHE)) {
							if (porche==null) {
								porche=1;
							} else {
								porche++;
							}
						}
						if (distribucion.get(i).getTipoHabitaculo().getCodigo().equals(DDTipoHabitaculo.TIPO_HABITACULO_SALON)) {
							if (salon==null) {
								salon=distribucion.get(i).getSuperficie();
							} else {
								salon+=distribucion.get(i).getSuperficie();
							}
						}	
						if (distribucion.get(i).getTipoHabitaculo().getCodigo().equals(DDTipoHabitaculo.TIPO_HABITACULO_BANYO)) {
							if (banyo==null) {
								banyo=1;
							} else {
								banyo++;
							}
						}
						if (distribucion.get(i).getTipoHabitaculo().getCodigo().equals(DDTipoHabitaculo.TIPO_HABITACULO_BALCON)) {
							if (balcon==null) {
								balcon=1;
							} else {
								balcon++;
							}
						}	
						if (distribucion.get(i).getTipoHabitaculo().getCodigo().equals(DDTipoHabitaculo.TIPO_HABITACULO_HALL)) {
							if (hall==null) {
								hall=1;
							} else {
								hall++;
							}
						}						
					}
					if (dormitorio!=null) {
						mapaValores.put("ActivoDormitorios", FileUtilsREM.stringify(dormitorio));
					} else {
						mapaValores.put("ActivoDormitorios", NOT_AVAILABLE_ROOM);
					}
					if (aseo!=null) {
						mapaValores.put("ActivoAseos", FileUtilsREM.stringify(aseo));
					} else {
						mapaValores.put("ActivoAseos", NOT_AVAILABLE_ROOM);
					}
					if (patio!=null) {
						mapaValores.put("ActivoPatio", FileUtilsREM.stringify(patio));
					} else {
						mapaValores.put("ActivoPatio", NOT_AVAILABLE_ROOM);
					}
					if (porche!=null) {
						mapaValores.put("ActivoPorche", FileUtilsREM.stringify(porche));
					} else {
						mapaValores.put("ActivoPorche", NOT_AVAILABLE_ROOM);
					}
					if (salon!=null) {
						mapaValores.put("ActivoSalon", FileUtilsREM.stringify(salon+" m2"));
					} else {
						mapaValores.put("ActivoSalon", NOT_AVAILABLE_ROOM);
					}
					if (banyo!=null) {
						mapaValores.put("ActivoBanyos", FileUtilsREM.stringify(banyo));
					} else {
						mapaValores.put("ActivoBanyos", NOT_AVAILABLE_ROOM);
					}
					if (balcon!=null) {
						mapaValores.put("ActivoBalcones", FileUtilsREM.stringify(balcon));
					} else {
						mapaValores.put("ActivoBalcones", NOT_AVAILABLE_ROOM);
					}
					if (hall!=null) {
						mapaValores.put("ActivoHall", FileUtilsREM.stringify(hall));
					} else {
						mapaValores.put("ActivoHall", NOT_AVAILABLE_ROOM);
					}					
				}
				if (vivienda.getUltimaPlanta()!=null) {
					if (vivienda.getUltimaPlanta().equals(new Integer(1))) {
						mapaValores.put("ActivoUltPlanta","SI");
					} else {
						mapaValores.put("ActivoUltPlanta","NO");
					}
				} else {
					mapaValores.put("ActivoUltPlanta",FileUtilsREM.stringify(null));
				}
				if (vivienda.getOcupado()!=null) {
					if (vivienda.getOcupado().equals(new Integer(1))) {
						mapaValores.put("ActivoOcupada","SI");
					} else {
						mapaValores.put("ActivoOcupada","NO");
					}
				} else {
					mapaValores.put("ActivoOcupada",FileUtilsREM.stringify(null));
				}
				if (vivienda.getUbicacionActivo()!=null) {
					mapaValores.put("ActivoUbicacion",FileUtilsREM.stringify(vivienda.getUbicacionActivo().getDescripcionLarga()));
				} else {
					mapaValores.put("ActivoUbicacion",FileUtilsREM.stringify(null));
				}				
				mapaValores.put("ActivoDistrito",FileUtilsREM.stringify(vivienda.getDistrito()));
				mapaValores.put("ActivoAntiguedad",FileUtilsREM.stringify(vivienda.getAnyoConstruccion()));
				mapaValores.put("ActivoRehabilitacion",FileUtilsREM.stringify(vivienda.getAnyoRehabilitacion()));
				if (vivienda.getTipoVivienda()!=null) {
					mapaValores.put("ActivoTipo",FileUtilsREM.stringify(vivienda.getTipoVivienda().getDescripcionLarga()));
				} else {
					mapaValores.put("ActivoTipo",FileUtilsREM.stringify(null));
				}				
			} else {
				mapaValores.put("ActivoInterior",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoPlantas",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoConservacion",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoOrientacion",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoDormitorios",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoAseos",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoPatio",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoPorche",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoSalon",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoBanyos",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoBalcones",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoHall",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoUltPlanta",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoOcupada",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoUbicacion",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoUbicacion",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoDistrito",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoAntiguedad",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoRehabilitacion",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoTipo",FileUtilsREM.stringify(null));
			}
			
			//Todo lo relacionado con la tabla INFORMACION COMERCIAL
			if (infoComercial!=null) {
				mapaValores.put("ActivoZona",FileUtilsREM.stringify(infoComercial.getZona()));
			} else {
				mapaValores.put("ActivoZona",FileUtilsREM.stringify(null));
			}

			//Todo lo relacionado con la tabla ANEJO
			if (listAnejo!=null) {
				Integer plazas = 0;
				Integer trastero = null;
				Integer garaje = null;
				Float superficie = new Float(0);
				String subtipo = null;
				for (int j = 0; j < listAnejo.size(); j++) {
					ActivoAnejo anejo = listAnejo.get(j);
					if (anejo.getTipoAnejo().getCodigo().equals(DDTipoAnejo.TIPO_ANEJO_GARAJE)) {
						if (garaje==null) {
							garaje = 1;
						} else {
							garaje++;
						}
						if (anejo.getSuperficie()!=null) {
							superficie+=anejo.getSuperficie();
						}
						if (plazas==null) {
							plazas = 1;
						} else {
							plazas++;
						}
						if (anejo.getSubTipo()!=null) {
							subtipo = FileUtilsREM.stringify(anejo.getSubTipo().getDescripcionLarga());
						} else {
							subtipo = FileUtilsREM.stringify(null);
						}						
					} else if (anejo.getTipoAnejo().getCodigo().equals(DDTipoAnejo.TIPO_ANEJO_TRASTERO)) {
						if (trastero==null) {
							trastero = 1;
						} else {
							trastero++;
						}
					} 				
				}
				mapaValores.put("ActivoPlazas",FileUtilsREM.stringify(plazas));
				mapaValores.put("ActivoTrastero",FileUtilsREM.stringify(trastero));
				mapaValores.put("ActivoGaraje",FileUtilsREM.stringify(garaje));
				mapaValores.put("ActivoSubtipologia",FileUtilsREM.stringify(subtipo));
				mapaValores.put("ActivoSuperficie",FileUtilsREM.stringify(superficie));
			} else {
				mapaValores.put("ActivoPlazas",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoTrastero",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoGaraje",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoSubtipologia",FileUtilsREM.stringify(null));
				mapaValores.put("ActivoSuperficie",FileUtilsREM.stringify(null));
			}

			
		} catch (JsonParseException e1) {
			e1.printStackTrace();
		} catch (JsonMappingException e1) {
			e1.printStackTrace();
		} catch (IOException e1) {
			e1.printStackTrace();
		} catch (Exception e1){
			e1.printStackTrace();
		} 
		
		return mapaValores;
	}

	@Override
	public List<Object> dataSourceHojaDatos(Oferta oferta, Activo activo, ModelMap model) {

		List<Object> array = new ArrayList<Object>();
		
		DtoDataSource propuestaOferta = new DtoDataSource();
		
		List<CompradorExpediente> clientes = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId()).getCompradores();
		List<Object> listaCliente = new ArrayList<Object>();
		DtoCliente cliente = null;
		for (int i = 0; i < clientes.size(); i++) {
			VBusquedaDatosCompradorExpediente datosComprador = expedienteComercialApi.getDatosCompradorById(clientes.get(i).getComprador()); 
			cliente = new DtoCliente();
			cliente.setNombreCliente(FileUtilsREM.stringify(datosComprador.getNombreRazonSocial()));
			String direccion = "";
			if (datosComprador.getDireccion() != null) {
				direccion += datosComprador.getDireccion();
			}
			if (datosComprador.getCodigoPostal() != null) {
				direccion += " ";
				direccion += datosComprador.getCodigoPostal();
			}
			if (datosComprador.getMunicipioDescripcion() != null) {
				direccion = direccion + "(" +datosComprador.getMunicipioDescripcion()+ ")";
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
		propuestaOferta.setListaCliente(listaCliente);
		
		List<Object> listaHonorario = new ArrayList<Object>();
		DtoHonorarios honorarios = null;
		Long idExpediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId()).getId();
		List<GastosExpediente> listaGastosExpediente = genericDao.getList(GastosExpediente.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente));
		for (int j = 0; j < listaGastosExpediente.size(); j++) {
			honorarios = new DtoHonorarios();
			if (listaGastosExpediente.get(j).getProveedor()!=null) {
				honorarios.setNombreHonorarios(FileUtilsREM.stringify(listaGastosExpediente.get(j).getProveedor().getNombre()));
			} else {
				honorarios.setNombreHonorarios(FileUtilsREM.stringify(null));
			}			
			honorarios.setConceptoHonorarios(FileUtilsREM.stringify(listaGastosExpediente.get(j).getAccionGastos().getDescripcion()));
			if (DDTipoCalculo.TIPO_CALCULO_PORCENTAJE.equals(listaGastosExpediente.get(j).getTipoCalculo().getCodigo())) {
				honorarios.setPorcentajeHonorarios(FileUtilsREM.stringify(listaGastosExpediente.get(j).getImporteCalculo()+"%"));
			} else {
				honorarios.setPorcentajeHonorarios("0");
			}
			honorarios.setImporteHonorarios(FileUtilsREM.stringify(listaGastosExpediente.get(j).getImporteFinal()));
			listaHonorario.add(honorarios);
		}
		propuestaOferta.setListaHonorario(listaHonorario);
		
		//Ofertas asociadas a las 
		List<ActivoOferta> listaOfertaPorActivo = activo.getOfertas();
		List<Object> listaOferta = new ArrayList<Object>();
		DtoOferta ofertaActivo =null;
		for (int k = 0; k < listaOfertaPorActivo.size(); k++) {
			Oferta tmpOferta = listaOfertaPorActivo.get(k).getPrimaryKey().getOferta();
			ofertaActivo = new DtoOferta();
			ofertaActivo.setNumOferta(FileUtilsREM.stringify(tmpOferta.getNumOferta()));
			if (tmpOferta.getCliente()!=null) {
				ofertaActivo.setTitularOferta(FileUtilsREM.stringify(tmpOferta.getCliente().getNombreCompleto()));
			} else {
				ofertaActivo.setTitularOferta(FileUtilsREM.stringify(null));
			}
			ofertaActivo.setImporteOferta(FileUtilsREM.stringify(tmpOferta.getImporteOferta()));
			ofertaActivo.setFechaOferta(FileUtilsREM.stringify(tmpOferta.getFechaAlta()));
			if (tmpOferta.getEstadoOferta()!=null) {
				ofertaActivo.setSituacionOferta(FileUtilsREM.stringify(tmpOferta.getEstadoOferta().getDescripcionLarga()));
			} else {
				ofertaActivo.setSituacionOferta(FileUtilsREM.stringify(null));
			}
			listaOferta.add(ofertaActivo);
		}
		propuestaOferta.setListaOferta(listaOferta);

		DtoTasacionInforme tasacion = null;
		List<Object> listaTasacion = new ArrayList<Object>();
		List<ActivoTasacion> listActivoTasacion = activoDao.getListActivoTasacionByIdActivo(activo.getId());
		if (listActivoTasacion!=null) {
			for (int k = 0; k < listActivoTasacion.size(); k++) {
				tasacion = new DtoTasacionInforme();
				tasacion.setNumTasacion(FileUtilsREM.stringify(listActivoTasacion.get(k).getIdExterno()));
				tasacion.setTipoTasacion(FileUtilsREM.stringify(listActivoTasacion.get(k).getTipoTasacion().getDescripcion()));
				tasacion.setImporteTasacion(FileUtilsREM.stringify(listActivoTasacion.get(k).getImporteTasacionFin()));
				tasacion.setFechaTasacion(FileUtilsREM.stringify(listActivoTasacion.get(k).getFechaRecepcionTasacion()));
				tasacion.setFirmaTasacion(FileUtilsREM.stringify(listActivoTasacion.get(k).getCodigoFirma()));
				listaTasacion.add(tasacion);
			}
		}
		propuestaOferta.setListaTasacion(listaTasacion);
		
		array.add(propuestaOferta);
		
		return array;
	}
	
	public void sendFileBase64(HttpServletResponse response, File file, ModelMap model){
		
		FileUtilsREM.sendFileBase64(response, file, model, "HojaPresentacionPropuesta.pdf");
		
	}


    
}
