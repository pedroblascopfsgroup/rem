package es.pfsgroup.plugin.rem.api.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.output.ByteArrayOutputStream;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.PropuestaOfertaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAnejo;
import es.pfsgroup.plugin.rem.model.ActivoDistribucion;
import es.pfsgroup.plugin.rem.model.ActivoEdificio;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.ActivoVivienda;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoCliente;
import es.pfsgroup.plugin.rem.model.DtoHonorarios;
import es.pfsgroup.plugin.rem.model.DtoOferta;
import es.pfsgroup.plugin.rem.model.DtoPropuestaOferta;
import es.pfsgroup.plugin.rem.model.DtoTasacionInforme;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.TextosOferta;
import es.pfsgroup.plugin.rem.model.VBusquedaDatosCompradorExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionesPosesoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAnejo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoHabitaculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPorCuenta;
import es.pfsgroup.plugin.rem.model.dd.DDTiposTextoOferta;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.recovery.api.ExpedienteApi;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

@Service("propuestaOfertaManager")
public class PropuestaOfertaManager implements PropuestaOfertaApi{

	private final String CODES = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	private final String NOT_AVAILABLE_ROOM = "NO";

	@Autowired 
	private OfertaApi ofertaApi;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
	private ActivoApi activoApi;
	
//	@Autowired
//	private ExpedienteApi expedienteApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoDao activoDao;
	
	private String formatDate (Date date) {
		if (date==null) return "-";
		DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		return dateFormat.format(date).toString();
	}
	
	private String notNull (Object obj) {
		if (obj==null) return "-";
		if (obj instanceof Date) {
			return formatDate ((Date) obj);
		}
		//TODO: obj instanceof Double --> formatear con un par de decimales.
		return obj.toString();
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> paramsPropuestaSimple(Oferta oferta, ModelMap model) {
		
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
			
			mapaValores.put("FRecepOf", notNull(oferta.getFechaAlta()) );
			mapaValores.put("FProp", notNull(new Date()));

			Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", "GCOM");
			Long tipo = genericDao.get(EXTDDTipoGestor.class, filter).getId();		
			if (gestorActivoApi.getGestorByActivoYTipo(activo, tipo)!=null) {
				mapaValores.put("Gestor", gestorActivoApi.getGestorByActivoYTipo(activo, tipo).getApellidoNombre());
			} else {
				mapaValores.put("Gestor", notNull(null));
			}
			
			mapaValores.put("FPublWeb", notNull(activo.getFechaPublicable()));
			mapaValores.put("NumVisitasWeb", notNull(activo.getVisitas().size()));
			
			mapaValores.put("Direccion",notNull(activo.getDireccion()));
			if (activo.getTipoActivo()!=null) {
				mapaValores.put("Tipo",notNull(activo.getTipoActivo().getDescripcionLarga()));
			}
			if (activo.getSubtipoActivo()!=null) {
				mapaValores.put("Subtipo",notNull(activo.getSubtipoActivo().getDescripcionLarga()));
			}
			mapaValores.put("Residencia","-");
			mapaValores.put("CertificadoEnergetico","-");
			mapaValores.put("SuperficieConstruida",notNull(activo.getTotalSuperficieConstruida()));
			mapaValores.put("Parcela",notNull(activo.getTotalSuperficieParcela()));
			mapaValores.put("Sociedadpatrimonial","-");
			mapaValores.put("FEntradaCartera","-");
			mapaValores.put("FincaRegistral","-");
			mapaValores.put("FRecepcionLlaves","-");
			mapaValores.put("Disponibilidadjuridica","-");
			mapaValores.put("SituacionProcesal","-");
			mapaValores.put("SituacionLiquidacionInscripcion","-");
			mapaValores.put("Situaciondecargas","-"); //?? -> activo.getCargas().getCargaBien());
			mapaValores.put("Comercializacion","-");
			mapaValores.put("Entrada","-");
			mapaValores.put("CantidadOfertas", notNull(activoApi.cantidadOfertas(activo)));
			Double mayorOfertaRecibida = activoApi.mayorOfertaRecibida(activo);
			mapaValores.put("MayorOfertaRecibida", notNull(mayorOfertaRecibida));
			
			mapaValores.put("ImportePropuesta", notNull(oferta.getImporteOfertaAprobado()));
			mapaValores.put("ImporteInicial", notNull(oferta.getImporteOferta()));
			mapaValores.put("FechaContraoferta", notNull(oferta.getFechaContraoferta()));
			mapaValores.put("GastosCompraventa", "-");
			
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

			mapaValores.put("Contraoferta", notNull(oferta.getImporteContraOferta()));	
			
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
			
			mapaValores.put("Impuestos", notNull(condExp.getCargasImpuestos()));
			mapaValores.put("Comunidades", notNull(condExp.getCargasComunidad()));
			mapaValores.put("Otros", notNull(condExp.getCargasOtros()));
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
			
			mapaValores.put("Importe", notNull(condExp.getGastosNotaria()));
			mapaValores.put("OpCondicionadaa", "-");
			
			
			DDTiposPorCuenta tipoPlusValia = condExp.getTipoPorCuentaPlusvalia();
			if (tipoPlusValia!=null) {
				mapaValores.put("Plusvalia", notNull(tipoPlusValia.getDescripcionLarga()));
			} else {
				mapaValores.put("Plusvalia", notNull(null));
			}
			DDTiposPorCuenta tipoNotaria = condExp.getTipoPorCuentaNotaria();
			if (tipoNotaria!=null) {
				mapaValores.put("Notaria", notNull(tipoNotaria.getDescripcionLarga()));
			} else {
				mapaValores.put("Notaria", notNull(null));
			}
			DDTiposPorCuenta tipoOtros = condExp.getTipoPorCuentaGastosOtros();
			if (tipoOtros!=null) {
				mapaValores.put("OtrosImporteOferta",  notNull(tipoOtros.getDescripcionLarga()));
			} else {
				mapaValores.put("OtrosImporteOferta", notNull(null));
			}
			mapaValores.put("Reserva", "-");
			if (activo.getInfoRegistral()!=null && activo.getInfoRegistral().getInfoRegistralBien()!=null) {
				if (activo.getInfoRegistral().getInfoRegistralBien().getFechaInscripcion()==null) {
					mapaValores.put("Inscripcion", "SI");
				} else {
					mapaValores.put("Inscripcion", "NO");
				}
			}			
			
			
			if (!Checks.estaVacio(activo.getTasacion()))
			{
				//De la lista de tasaciones que tiene el activo cojemos la más reciente
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
					mapaValores.put("ValorTasacion",  notNull(tasacionMasReciente.getValoracionBien().getImporteValorTasacion()));
					mapaValores.put("ValorTasacionFecha", notNull(tasacionMasReciente.getValoracionBien().getFechaValorTasacion()));
					Double importeTasacion = tasacionMasReciente.getValoracionBien().getImporteValorTasacion().doubleValue();
					if (tasacionMasReciente.getValoracionBien().getImporteValorTasacion()!=null && importeTasacion!=0) {						
						Double valorTasacionDto = 100*( (importeTasacion - mayorOfertaRecibida) / importeTasacion );
						mapaValores.put("ValorTasacionDto", notNull(valorTasacionDto));
					} else {
						mapaValores.put("ValorTasacionDto", notNull(null));
					}
				}  else {
					mapaValores.put("ValorTasacion",  notNull(null));
					mapaValores.put("ValorTasacionFecha", notNull(null));
					mapaValores.put("ValorTasacionDto", notNull(null));
				}
				
				//De la lista de valoraciones del activo obtenemos aquella que tiene en el tipo de precio el valor ESTIMADO_VENTA
				Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
				Filter estimadoVentaTPCFilter = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_ESTIMADO_VENTA);
				ActivoValoraciones activoValoracion = (ActivoValoraciones) genericDao.get(ActivoValoraciones.class, activoFilter, estimadoVentaTPCFilter);
				if (activoValoracion!=null) {
					mapaValores.put("ValorEstColabor", notNull(activoValoracion.getImporte()));
					mapaValores.put("ValorEstColaborFecha", notNull(activoValoracion.getFechaInicio()));
					Double importeTasacion = activoValoracion.getImporte();
					if (importeTasacion!=0) {
						Double valorTasacionDto = 100*( (importeTasacion - mayorOfertaRecibida) / importeTasacion );
						mapaValores.put("ValorEstColaborDto", notNull(valorTasacionDto));
					} else {
						mapaValores.put("ValorEstColaborDto", notNull(null));
					}
				} else {
					mapaValores.put("ValorEstColabor", notNull(null));
					mapaValores.put("ValorEstColaborFecha", notNull(null));
					mapaValores.put("ValorEstColaborDto", notNull(null));
				}
				
				Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
				Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "tipoTexto.codigo", DDTiposTextoOferta.TIPOS_TEXTO_OFERTA_INTERES);
				TextosOferta textoOfertaInteres = genericDao.get(TextosOferta.class, filtro1, filtro2);
				if (textoOfertaInteres!=null){
					mapaValores.put("ComentarioInteres", notNull(textoOfertaInteres.getTexto()));
				} else {
					mapaValores.put("ComentarioInteres", notNull(null));
				}
				filtro1 = genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
				filtro2 = genericDao.createFilter(FilterType.EQUALS, "tipoTexto.codigo", DDTiposTextoOferta.TIPOS_TEXTO_OFERTA_GESTOR);
				TextosOferta textoOfertaGestor = genericDao.get(TextosOferta.class, filtro1, filtro2);
				if (textoOfertaGestor!=null){
					mapaValores.put("ComentarioGestor", notNull(textoOfertaGestor.getTexto()));
				} else {
					mapaValores.put("ComentarioGestor", notNull(null));
				}
				filtro1 = genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
				filtro2 = genericDao.createFilter(FilterType.EQUALS, "tipoTexto.codigo", DDTiposTextoOferta.TIPOS_TEXTO_OFERTA_COMITE);
				TextosOferta textoOfertaComite = genericDao.get(TextosOferta.class, filtro1, filtro2);
				if (textoOfertaComite!=null){
					mapaValores.put("ComentarioComite", notNull(textoOfertaComite.getTexto()));
				} else {
					mapaValores.put("ComentarioComite", notNull(null));
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
						mapaValores.put("ValorAprobVenta", notNull(activoAprobVenta.getImporte()));
						mapaValores.put("ValorAprobVentaFecha", notNull(activoAprobVenta.getFechaInicio()));
						Double importeTasacion = activoAprobVenta.getImporte();
						if (importeTasacion!=0) {
							Double valorTasacionDto = 100*( (importeTasacion - mayorOfertaRecibida) / importeTasacion );
							mapaValores.put("ValorAprobVentaDto", notNull(valorTasacionDto));
						} else {
							mapaValores.put("ValorAprobVentaDto", notNull(null));
						}
					} else {
						mapaValores.put("ValorAprobVenta", notNull(null));
						mapaValores.put("ValorAprobVentaFecha", notNull(null));
						mapaValores.put("ValorAprobVentaDto", notNull(null));
					}
				}
				
			}
			
			Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			ActivoInfoComercial infoComercial = (ActivoInfoComercial) genericDao.get(ActivoInfoComercial.class, activoFilter);
			
			Filter comercialFilter = genericDao.createFilter(FilterType.EQUALS, "id", infoComercial.getId());
			ActivoVivienda vivienda = (ActivoVivienda) genericDao.get(ActivoVivienda.class, comercialFilter);
			
			Filter infoComercialFilter = genericDao.createFilter(FilterType.EQUALS, "infoComercial.id", infoComercial.getId());
			List<ActivoAnejo> listAnejo = genericDao.getList(ActivoAnejo.class, infoComercialFilter);
			ActivoEdificio edificio = (ActivoEdificio) genericDao.get(ActivoEdificio.class, infoComercialFilter);
			
			//Descripción fisica del ACTIVO
			if (edificio!=null) {
				mapaValores.put("ActivoEdificio",notNull(edificio.getEdiDescripcion()));
			} else {
				mapaValores.put("ActivoEdificio",notNull(null));
			}
			
			//Todo lo relacionado con la tabla VIVIENDA
			if (vivienda!=null) {
				mapaValores.put("ActivoInterior",notNull(vivienda.getDistribucionTxt()));
				mapaValores.put("ActivoPlantas",notNull(vivienda.getNumPlantasInter()));
				if (vivienda.getEstadoConservacion()!=null) {
					mapaValores.put("ActivoConservacion",notNull(vivienda.getEstadoConservacion().getDescripcionLarga()));
				} else {
					mapaValores.put("ActivoConservacion",notNull(null));
				}
				if (vivienda.getTipoOrientacion()!=null) {
					mapaValores.put("ActivoOrientacion",vivienda.getTipoOrientacion().getDescripcionLarga());
				} else {
					mapaValores.put("ActivoOrientacion",notNull(null));
				}
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
						mapaValores.put("ActivoDormitorios", notNull(dormitorio));
					} else {
						mapaValores.put("ActivoDormitorios", NOT_AVAILABLE_ROOM);
					}
					if (aseo!=null) {
						mapaValores.put("ActivoAseos", notNull(aseo));
					} else {
						mapaValores.put("ActivoAseos", NOT_AVAILABLE_ROOM);
					}
					if (patio!=null) {
						mapaValores.put("ActivoPatio", notNull(patio));
					} else {
						mapaValores.put("ActivoPatio", NOT_AVAILABLE_ROOM);
					}
					if (porche!=null) {
						mapaValores.put("ActivoPorche", notNull(porche));
					} else {
						mapaValores.put("ActivoPorche", NOT_AVAILABLE_ROOM);
					}
					if (salon!=null) {
						mapaValores.put("ActivoSalon", notNull(salon+" m2"));
					} else {
						mapaValores.put("ActivoSalon", NOT_AVAILABLE_ROOM);
					}
					if (banyo!=null) {
						mapaValores.put("ActivoBanyos", notNull(banyo));
					} else {
						mapaValores.put("ActivoBanyos", NOT_AVAILABLE_ROOM);
					}
					if (balcon!=null) {
						mapaValores.put("ActivoBalcones", notNull(balcon));
					} else {
						mapaValores.put("ActivoBalcones", NOT_AVAILABLE_ROOM);
					}
					if (hall!=null) {
						mapaValores.put("ActivoHall", notNull(hall));
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
					mapaValores.put("ActivoUltPlanta",notNull(null));
				}
				if (vivienda.getOcupado()!=null) {
					if (vivienda.getOcupado().equals(new Integer(1))) {
						mapaValores.put("ActivoOcupada","SI");
					} else {
						mapaValores.put("ActivoOcupada","NO");
					}
				} else {
					mapaValores.put("ActivoOcupada",notNull(null));
				}
				if (vivienda.getUbicacionActivo()!=null) {
					mapaValores.put("ActivoUbicacion",notNull(vivienda.getUbicacionActivo().getDescripcionLarga()));
				} else {
					mapaValores.put("ActivoUbicacion",notNull(null));
				}				
				mapaValores.put("ActivoDistrito",notNull(vivienda.getDistrito()));
				mapaValores.put("ActivoAntiguedad",notNull(vivienda.getAnyoConstruccion()));
				mapaValores.put("ActivoRehabilitacion",notNull(vivienda.getAnyoRehabilitacion()));
				if (vivienda.getTipoVivienda()!=null) {
					mapaValores.put("ActivoTipo",notNull(vivienda.getTipoVivienda().getDescripcionLarga()));
				} else {
					mapaValores.put("ActivoTipo",notNull(null));
				}				
			} else {
				mapaValores.put("ActivoInterior",notNull(null));
				mapaValores.put("ActivoConservacion",notNull(null));
				mapaValores.put("ActivoOrientacion",notNull(null));
				mapaValores.put("ActivoDormitorios",notNull(null));
				mapaValores.put("ActivoAseos",notNull(null));
				mapaValores.put("ActivoPatio",notNull(null));
				mapaValores.put("ActivoPorche",notNull(null));
				mapaValores.put("ActivoSalon",notNull(null));
				mapaValores.put("ActivoBanyos",notNull(null));
				mapaValores.put("ActivoBalcones",notNull(null));
				mapaValores.put("ActivoHall",notNull(null));
				mapaValores.put("ActivoUltPlanta",notNull(null));
				mapaValores.put("ActivoOcupada",notNull(null));
				mapaValores.put("ActivoUbicacion",notNull(null));
				mapaValores.put("ActivoUbicacion",notNull(null));
				mapaValores.put("ActivoDistrito",notNull(null));
				mapaValores.put("ActivoAntiguedad",notNull(null));
				mapaValores.put("ActivoRehabilitacion",notNull(null));
				mapaValores.put("ActivoTipo",notNull(null));
			}
			
			//Todo lo relacionado con la tabla INFORMACION COMERCIAL
			if (infoComercial!=null) {
				mapaValores.put("ActivoZona",notNull(infoComercial.getZona()));
			} else {
				mapaValores.put("ActivoZona",notNull(null));
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
							subtipo = notNull(anejo.getSubTipo().getDescripcionLarga());
						} else {
							subtipo = notNull(null);
						}						
					} else if (anejo.getTipoAnejo().getCodigo().equals(DDTipoAnejo.TIPO_ANEJO_TRASTERO)) {
						if (trastero==null) {
							trastero = 1;
						} else {
							trastero++;
						}
					} 				
				}
				mapaValores.put("ActivoPlazas",notNull(plazas));
				mapaValores.put("ActivoTrastero",notNull(trastero));
				mapaValores.put("ActivoGaraje",notNull(garaje));
				mapaValores.put("ActivoSubtipologia",notNull(subtipo));
				mapaValores.put("ActivoSuperficie",notNull(superficie));
			} else {
				mapaValores.put("ActivoPlazas",notNull(null));
				mapaValores.put("ActivoTrastero",notNull(null));
				mapaValores.put("ActivoGaraje",notNull(null));
				mapaValores.put("ActivoSubtipologia",notNull(null));
				mapaValores.put("ActivoSuperficie",notNull(null));
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
	public List<Object> dataSourcePropuestaSimple(Oferta oferta, Activo activo, ModelMap model) {

		List<Object> array = new ArrayList();
		
		DtoPropuestaOferta propuestaOferta = new DtoPropuestaOferta();
		
		List<CompradorExpediente> clientes = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId()).getCompradores();
		List<Object> listaCliente = new ArrayList<Object>();
		DtoCliente cliente = null;
		for (int i = 0; i < clientes.size(); i++) {
			VBusquedaDatosCompradorExpediente datosComprador = expedienteComercialApi.getDatosCompradorById(clientes.get(i).getComprador()); 
			cliente = new DtoCliente();
			cliente.setNombreCliente(notNull(datosComprador.getNombreRazonSocial()));
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
			cliente.setDniCliente(notNull(datosComprador.getNumDocumento()));
			cliente.setTlfCliente(notNull(datosComprador.getTelefono1()));
			if (datosComprador.getAntiguoDeudor() != null) {
				if (datosComprador.getAntiguoDeudor() == 1) {
					cliente.setDeudor("SI");
				} else {
					cliente.setDeudor("NO");
				}
			} else {
				cliente.setDeudor(notNull(null));
			}
			if (datosComprador.getRelacionAntDeudor() != null) {
				if (datosComprador.getRelacionAntDeudor() == 1) {
					cliente.setrBienes("SI");
				} else {
					cliente.setrBienes("NO");
				}
			} else {
				cliente.setrBienes(notNull(null));
			}
			listaCliente.add(cliente);
		}
		propuestaOferta.setListaCliente(listaCliente);
		
		List<Object> listaHonorarios = new ArrayList<Object>();
		DtoHonorarios honorarios = null;
		Long idExpediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId()).getId();
		List<GastosExpediente> listaGastosExpediente = genericDao.getList(GastosExpediente.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente));
		for (int j = 0; j < listaGastosExpediente.size(); j++) {
			honorarios = new DtoHonorarios();
			honorarios.setNombreHonorarios(notNull(listaGastosExpediente.get(j).getNombre()));
			honorarios.setConceptoHonorarios(notNull(listaGastosExpediente.get(j).getAccionGastos().getDescripcion()));
			honorarios.setPorcentajeHonorarios(notNull(listaGastosExpediente.get(j).getImporteCalculo()));
			honorarios.setImporteHonorarios(notNull(listaGastosExpediente.get(j).getImporteFinal()));
			listaHonorarios.add(honorarios);
		}
		listaHonorarios.add(honorarios);
		propuestaOferta.setListaHonorarios(listaHonorarios);
		
		DtoOferta ofertaActivo = new DtoOferta();
		ofertaActivo.setNumOferta("-");
		ofertaActivo.setTitularOferta("-");
		ofertaActivo.setImporteOferta("-");
		ofertaActivo.setFechaOferta("-");
		ofertaActivo.setSituacionOferta("-");
		
		DtoOferta ofertaActivo2 = new DtoOferta();
		ofertaActivo2.setNumOferta("-");
		ofertaActivo2.setTitularOferta("-");
		ofertaActivo2.setImporteOferta("-");
		ofertaActivo2.setFechaOferta("-");
		ofertaActivo2.setSituacionOferta("-");
		
		List<Object> listaOferta = new ArrayList<Object>();
		listaOferta.add(ofertaActivo);
		listaOferta.add(ofertaActivo2);
		propuestaOferta.setListaOferta(listaOferta);

		DtoTasacionInforme tasacion = null;
		List<Object> listaTasacion = new ArrayList<Object>();
		List<ActivoTasacion> listActivoTasacion = activoDao.getListActivoTasacionByIdActivo(activo.getId());
		if (listActivoTasacion!=null) {
			for (int k = 0; k < listActivoTasacion.size(); k++) {
				tasacion = new DtoTasacionInforme();
				tasacion.setNumTasacion(notNull(listActivoTasacion.get(k).getIdExterno()));
				tasacion.setTipoTasacion(notNull(listActivoTasacion.get(k).getTipoTasacion().getDescripcion()));
				tasacion.setImporteTasacion(notNull(listActivoTasacion.get(k).getImporteTasacionFin()));
				tasacion.setFechaTasacion(notNull(listActivoTasacion.get(k).getFechaRecepcionTasacion()));
				tasacion.setFirmaTasacion(notNull(listActivoTasacion.get(k).getNomTasador()));
				listaTasacion.add(tasacion);
			}
		}
		propuestaOferta.setListaTasacion(listaTasacion);
		
		array.add(propuestaOferta);
		
		return array;
	}

	@Override
	public File getPDFFilePropuestaSimple(Map<String, Object> params, List<Object> dataSource, ModelMap model) {
		
		String namePropuestaSimple = "PropuestaResolucion001";
		String ficheroPlantilla = "jasper/"+namePropuestaSimple+".jrxml";
		
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
				fileSalidaTemporal = File.createTempFile("jasper", ".pdf");
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

	@Override
	public void sendFileBase64(HttpServletResponse response, File file, ModelMap model) {
		
		Map<String, Object> dataResponse = new HashMap<String, Object>();
		
		try {
			byte[] bytes = read(file);
			dataResponse.put("contentType", "application/pdf");
			dataResponse.put("fileName", "HojaPresentacionPropuesta.pdf");
			dataResponse.put("hojaPropuesta",base64Encode(bytes));
			model.put("data", dataResponse);
			
//       		ServletOutputStream salida = response.getOutputStream(); 
//       		FileInputStream fileInputStream = new FileInputStream(file.getAbsolutePath());
// 
//       		if(fileInputStream!= null) {       		
//	       		response.setHeader("Content-disposition", "attachment; filename=PropuestaOferta.pdf");
//	       		response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
//	       		response.setHeader("Cache-Control", "max-age=0");
//	       		response.setHeader("Expires", "0");
//	       		response.setHeader("Pragma", "public");
//	       		response.setDateHeader("Expires", 0); //prevents caching at the proxy
//	       		response.setContentType("application/pdf");		
//	       		FileUtils.copy(fileInputStream, salida);// Write
//	       		salida.flush();
//	       		salida.close();
//       		}
       		
       	} catch (Exception e) { 
       		e.printStackTrace();
       	}
	}

    private String base64Encode(byte[] in)       {
        StringBuilder out = new StringBuilder((in.length * 4) / 3);
        int b;
        for (int i = 0; i < in.length; i += 3)  {
            b = (in[i] & 0xFC) >> 2;
            out.append(CODES.charAt(b));
            b = (in[i] & 0x03) << 4;
            if (i + 1 < in.length)      {
                b |= (in[i + 1] & 0xF0) >> 4;
                out.append(CODES.charAt(b));
                b = (in[i + 1] & 0x0F) << 2;
                if (i + 2 < in.length)  {
                    b |= (in[i + 2] & 0xC0) >> 6;
                    out.append(CODES.charAt(b));
                    b = in[i + 2] & 0x3F;
                    out.append(CODES.charAt(b));
                } else  {
                    out.append(CODES.charAt(b));
                    out.append('=');
                }
            } else      {
                out.append(CODES.charAt(b));
                out.append("==");
            }
        }

        return out.toString();
    }

    
    private byte[] read(File file) throws IOException {
	    ByteArrayOutputStream ous = null;
	    InputStream ios = null;
	    try {
	        byte[] buffer = new byte[4096];
	        ous = new ByteArrayOutputStream();
	        ios = new FileInputStream(file);
	        int read = 0;
	        while ((read = ios.read(buffer)) != -1) {
	            ous.write(buffer, 0, read);
	        }
	    }finally {
			try {
				if (ous != null)
					ous.close();
			} catch (IOException e) {
			}
			try {
				if (ios != null)
					ios.close();
			} catch (IOException e) {
			}
	    }
	    return ous.toByteArray();
	}
    
}
