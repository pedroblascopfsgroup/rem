package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDCicCodigoIsoCirbeBKP;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTasadora;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdjudicacionBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienCargas;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBInformacionRegistralBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBValoracionesBien;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionJudicial;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.ActivoCargas;
import es.pfsgroup.plugin.rem.model.ActivoEdificio;
import es.pfsgroup.plugin.rem.model.ActivoInfoRegistral;
import es.pfsgroup.plugin.rem.model.ActivoLocalizacion;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.ActivoSareb;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.ActivoTitulo;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.ActivoZonaComun;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.dd.DDAdecuacionAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDCamposConvivenciaSareb;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAdecucionSareb;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoCarga;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.dd.DDPortal;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoCarga;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCargaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGradoPropiedad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTasacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUsoDestino;

public class MSVActualizacionCamposConvivenciaSareb extends AbstractMSVActualizador implements MSVLiberator {
	
	private static final int DATOS_PRIMERA_FILA = 2;
	private static final int NUM_ACTIVO = 0;
	private static final int CAMPO_CAMBIO = 3;
	private static final int VALOR_NUEVO = 5;
	
	@Autowired
	private GenericABMDao genericDao;
		
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_TRABAJOS;
	}
	
	@Autowired
	private TrabajoApi trabajoApi;
	
	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		
		//Aqui empieza la persistencia.
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		if(exc.dameCelda(fila, NUM_ACTIVO) != null) {
			String campo;
			campo = exc.dameCelda(fila, CAMPO_CAMBIO);
			Filter filtroCampo = genericDao.createFilter(FilterType.EQUALS, "cos.codigo",campo);
			DDCamposConvivenciaSareb convivencia = genericDao.get(DDCamposConvivenciaSareb.class, filtroCampo);
			Activo activo = genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
			if("ACT_ACTIVO".equalsIgnoreCase(convivencia.getTabla())) {
				if("001".equalsIgnoreCase(campo)){
					activo.setIdSareb(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("002".equals(campo)) {
					DDTipoActivo tipoActivo = genericDao.get(DDTipoActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activo.setTipoActivo(tipoActivo);
				}else if("004".equals(campo)) {
					DDSubtipoActivo subtipo = genericDao.get(DDSubtipoActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activo.setSubtipoActivo(subtipo);
				}else if("006".equals(campo)) {
					DDTipoUsoDestino tipoUsoDestino = genericDao.get(DDTipoUsoDestino.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activo.setTipoUsoDestino(tipoUsoDestino);
				}else if("019".equals(campo)) {
					DDTipoTituloActivo tipoTitulo = genericDao.get(DDTipoTituloActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo",exc.dameCelda(fila, VALOR_NUEVO)));
					activo.setTipoTitulo(tipoTitulo);
				}else if("020".equals(campo)) {
					DDSubtipoTituloActivo subtipoTitulo = genericDao.get(DDSubtipoTituloActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activo.setSubtipoTitulo(subtipoTitulo);
				}else if("024".equals(campo)) {
					activo.setVpo(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("086".equals(campo)) {
					DDSituacionComercial situacionComercial = genericDao.get(DDSituacionComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activo.setSituacionComercial(situacionComercial);
				}else if("128".equals(campo)) {
					DDCartera cartera = genericDao.get(DDCartera.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activo.setCartera(cartera);
				}else if("129".equals(campo)) {
					DDSubcartera subCartera = genericDao.get(DDSubcartera.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activo.setSubcartera(subCartera);
				}else if("137".equals(campo) || "138".equals(campo) || "011".equals(campo)) {
					DDEstadoActivo estadoActivo = genericDao.get(DDEstadoActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activo.setEstadoActivo(estadoActivo);
				}
				genericDao.save(Activo.class, activo);
			}else if("ACT_ADO_ADMISION_DOCUMENTO".equalsIgnoreCase(convivencia.getTabla())) {
				ActivoAdmisionDocumento activoAdmisionDoc = genericDao.get(ActivoAdmisionDocumento.class,genericDao.createFilter(FilterType.EQUALS, "activo.numActivo" ,Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("082".equals(campo)) {
					SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
					Date fechaObtener = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
					activoAdmisionDoc.setFechaObtencion(fechaObtener);
				}else if("095".equals(campo)) {
					SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
					Date fechaObtener = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
					activoAdmisionDoc.setFechaObtencion(fechaObtener);
				}
				genericDao.save(ActivoAdmisionDocumento.class, activoAdmisionDoc);
			}else if("ACT_AGR_AGRUPACION".equalsIgnoreCase(convivencia.getTabla())) {
				//Pone en la el CCS que agrupa por agrupacion Id
				ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class,genericDao.createFilter(FilterType.EQUALS, "numAgrupRem" ,Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("091".equals(campo)) {
					agrupacion.setCodigoOnSareb(exc.dameCelda(fila, VALOR_NUEVO));
					genericDao.save(ActivoAgrupacion.class, agrupacion);
				}
			}else if("ACT_AJD_ADJJUDICIAL".equalsIgnoreCase(convivencia.getTabla())){
				ActivoAdjudicacionJudicial activoAdjJudicial = genericDao.get(ActivoAdjudicacionJudicial.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("025".equalsIgnoreCase(campo)) {
					SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
					Date fechaAdj = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
					activoAdjJudicial.setFechaAdjudicacion(fechaAdj);
					genericDao.save(ActivoAdjudicacionJudicial.class, activoAdjJudicial);
				}
			}else if("ACT_APU_ACTIVO_PUBLICACION".equalsIgnoreCase(convivencia.getTabla())) {
				ActivoPublicacion activoPub = genericDao.get(ActivoPublicacion.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("085".equalsIgnoreCase(campo)) {
					DDPortal portal = genericDao.get(DDPortal.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoPub.setPortal(portal);
					genericDao.save(ActivoPublicacion.class, activoPub);
				}
			}else if("ACT_CAN_CALIFICACION_NEG".equalsIgnoreCase(convivencia.getTabla())) {
				ActivoCalificacionNegativa activoCalNeg = genericDao.get(ActivoCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("140".equalsIgnoreCase(campo)) {
					DDMotivoCalificacionNegativa motivo = genericDao.get(DDMotivoCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoCalNeg.setMotivoCalificacionNegativa(motivo);
					genericDao.save(ActivoCalificacionNegativa.class, activoCalNeg);
				}
			}else if("ACT_CRG_CARGAS".equalsIgnoreCase(convivencia.getTabla())) {
				ActivoCargas activoCargas = genericDao.get(ActivoCargas.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("029".equalsIgnoreCase(campo)) {
					//Setear el id del activo cargas ?????
//					activoCargas.setId(Long.parseLong(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("031".equalsIgnoreCase(campo)) {
					DDTipoCargaActivo tipoCarga = genericDao.get(DDTipoCargaActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoCargas.setTipoCargaActivo(tipoCarga);
				}else if("032".equalsIgnoreCase(campo)) {
					DDSubtipoCarga subtipoCarga = genericDao.get(DDSubtipoCarga.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoCargas.setSubtipoCarga(subtipoCarga);
				}else if("035".equalsIgnoreCase(campo) || "036".equalsIgnoreCase(campo)) {
					DDEstadoCarga estadoCarga = genericDao.get(DDEstadoCarga.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoCargas.setEstadoCarga(estadoCarga);
				}else if("039".equalsIgnoreCase(campo)) {
					SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
					Date fecha = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
					activoCargas.setFechaCancelacionRegistral(fecha);
				}
				genericDao.save(ActivoCargas.class, activoCargas);
			} else if("ACT_EDI_EDIFICIO".equalsIgnoreCase(convivencia.getTabla())) {
				ActivoEdificio activoEdi = genericDao.get(ActivoEdificio.class, genericDao.createFilter(FilterType.EQUALS, "infoComercial.activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("029".equalsIgnoreCase(campo)) {
					activoEdi.setAscensorEdificio(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
					genericDao.save(ActivoEdificio.class, activoEdi);
				}
			}else if("ACT_LOC_LOCALIZACION".equalsIgnoreCase(convivencia.getTabla())) {
				ActivoLocalizacion activoLoc = genericDao.get(ActivoLocalizacion.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("060".equalsIgnoreCase(campo)) {
					BigDecimal bd = new BigDecimal(exc.dameCelda(fila, VALOR_NUEVO));
					activoLoc.setLatitud(bd);
				}else if("062".equalsIgnoreCase(campo)) {
					BigDecimal bd = new BigDecimal(exc.dameCelda(fila, VALOR_NUEVO));
					activoLoc.setLongitud(bd);
				}
				genericDao.save(ActivoLocalizacion.class, activoLoc);
			}else if("ACT_PAC_PROPIETARIO_ACTIVO".equalsIgnoreCase(convivencia.getTabla())) {
				ActivoPropietarioActivo activoProp = genericDao.get(ActivoPropietarioActivo.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("022".equalsIgnoreCase(campo)) {
					activoProp.setPorcPropiedad(Float.parseFloat(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("023".equalsIgnoreCase(campo)) {
					DDTipoGradoPropiedad tipoGradoPropiedad = genericDao.get(DDTipoGradoPropiedad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoProp.setTipoGradoPropiedad(tipoGradoPropiedad);
				}else if("028".equalsIgnoreCase(campo)) {
					ActivoPropietario propietario = genericDao.get(ActivoPropietario.class, genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", exc.dameCelda(fila, VALOR_NUEVO))); 
					activoProp.setPropietario(propietario);
				}
				genericDao.save(ActivoPropietarioActivo.class, activoProp);
			}else if("ACT_PTA_PATRIMONIO_ACTIVO".equalsIgnoreCase(convivencia.getTabla())) {
				ActivoPatrimonio activoPatrimonio = genericDao.get(ActivoPatrimonio.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("008".equalsIgnoreCase(campo)) {
					Boolean res = Boolean.parseBoolean(exc.dameCelda(fila, VALOR_NUEVO));
					activoPatrimonio.setCheckSubrogado(res);
				}else if("123".equalsIgnoreCase(campo)) {
					DDAdecuacionAlquiler ada = genericDao.get(DDAdecuacionAlquiler.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoPatrimonio.setAdecuacionAlquiler(ada);
				}
				genericDao.save(ActivoPatrimonio.class, activoPatrimonio);
			}else if("ACT_REG_INFO_REGISTRAL".equalsIgnoreCase(convivencia.getTabla())) {
				ActivoInfoRegistral infoRegistral = genericDao.get(ActivoInfoRegistral.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("064".equalsIgnoreCase(campo)) {
					infoRegistral.setDivHorInscrito(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("073".equalsIgnoreCase(campo)) {
					infoRegistral.setIdufir(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("076".equalsIgnoreCase(campo)) {
					infoRegistral.setSuperficieUtil(Float.parseFloat(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("077".equalsIgnoreCase(campo)) {
					infoRegistral.setSuperficieParcela(Float.parseFloat(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("093".equalsIgnoreCase(campo)) {
					SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
					Date fechaCfo = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
					infoRegistral.setFechaCfo(fechaCfo);
				}else if("119".equalsIgnoreCase(campo)) {
					DDSinSiNo res = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					infoRegistral.setTieneAnejosRegistrales(res);
				}
				genericDao.save(ActivoInfoRegistral.class, infoRegistral);
			}else if("ACT_SAREB_ACTIVOS".equalsIgnoreCase(convivencia.getTabla())) {
				ActivoSareb activoSareb = genericDao.get(ActivoSareb.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("003".equalsIgnoreCase(campo)) {
					DDTipoActivo tipoActivo = genericDao.get(DDTipoActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoSareb.setTipoActivoOE(tipoActivo);
				}else if("005".equalsIgnoreCase(campo)) {
					DDSubtipoActivo subtipoActivo = genericDao.get(DDSubtipoActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoSareb.setSubtipoActivoOE(subtipoActivo);
				}else if("041".equalsIgnoreCase(campo)) {
					DDTipoVia tipoVia = genericDao.get(DDTipoVia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoSareb.setTipoViaOE(tipoVia);
				}else if("043".equalsIgnoreCase(campo)) {
					activoSareb.setNombreViaOE(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("045".equalsIgnoreCase(campo)) {
					activoSareb.setNumeroDomicilioOE(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("047".equalsIgnoreCase(campo)) {
					activoSareb.setEscaleraOE(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("049".equalsIgnoreCase(campo)) {
					activoSareb.setPisoOE(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("051".equalsIgnoreCase(campo)) {
					activoSareb.setPuertaOE(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("053".equalsIgnoreCase(campo)) {
					DDProvincia provincia = genericDao.get(DDProvincia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoSareb.setProvinciaOE(provincia);
				}else if("055".equalsIgnoreCase(campo)) {
					Localidad localidad = genericDao.get(Localidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoSareb.setLocalidadOE(localidad);
				}else if("059".equalsIgnoreCase(campo)) {
					activoSareb.setCodPostalOE(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("061".equalsIgnoreCase(campo) || "063".equalsIgnoreCase(campo)) {
					BigDecimal bd = new BigDecimal(exc.dameCelda(fila, VALOR_NUEVO));
					activoSareb.setLatitudOE(bd);
				}else if("141".equalsIgnoreCase(campo)) {
					DDSinSiNo res = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoSareb.setReoContabilizado(res);
				}else if("097".equalsIgnoreCase(campo)) {
					DDEstadoAdecucionSareb adecuacion = genericDao.get(DDEstadoAdecucionSareb.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoSareb.setEstadoAdecuacionSareb(adecuacion);
				}else if("098".equalsIgnoreCase(campo)) {
					SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
					Date fecha = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
					activoSareb.setFechaFinPrevistaAdecuacion(fecha);
				}
				genericDao.save(ActivoSareb.class, activoSareb);
			}else if("ACT_SPS_SIT_POSESORIA".equalsIgnoreCase(convivencia.getTabla())) {
				ActivoSituacionPosesoria situacionPosesioria = genericDao.get(ActivoSituacionPosesoria.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("007".equalsIgnoreCase(campo)) {
					//Un mismo numero actualiza dos campos ???
					situacionPosesioria.setOcupado(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
					DDTipoTituloActivoTPA tipoTituloActivo = genericDao.get(DDTipoTituloActivoTPA.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					situacionPosesioria.setConTitulo(tipoTituloActivo);
				}else if("009".equalsIgnoreCase(campo)) {
					//Un mismo numero actualiza dos campos ???
					situacionPosesioria.setOcupado(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
					DDTipoTituloActivoTPA tipoTituloActivo = genericDao.get(DDTipoTituloActivoTPA.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					situacionPosesioria.setConTitulo(tipoTituloActivo);
				}else if("012".equalsIgnoreCase(campo)) {
					situacionPosesioria.setRiesgoOcupacion(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("013".equalsIgnoreCase(campo)) {
					situacionPosesioria.setAccesoAntiocupa(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("021".equalsIgnoreCase(campo)) {
					SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
					Date fecha = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
					situacionPosesioria.setFechaTomaPosesion(fecha);
				}else if("096".equalsIgnoreCase(campo)) {
					situacionPosesioria.setAccesoTapiado(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
				}
				genericDao.save(ActivoSituacionPosesoria.class, situacionPosesioria);
			}else if("ACT_TAS_TASACION".equalsIgnoreCase(convivencia.getTabla())) {
				ActivoTasacion tasacion = genericDao.get(ActivoTasacion.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("105".equalsIgnoreCase(campo)) {
					SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
					Date fecha = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
					tasacion.setFechaRecepcionTasacion(fecha);
				}else if("107".equalsIgnoreCase(campo)) {
					tasacion.setImporteTasacionFin(Double.parseDouble(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("108".equalsIgnoreCase(campo)) {
					DDTipoTasacion tipoTasacion = genericDao.get(DDTipoTasacion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					tasacion.setTipoTasacion(tipoTasacion);
				}
				genericDao.save(ActivoTasacion.class, tasacion);
			}else if("ACT_TIT_TITULO".equalsIgnoreCase(convivencia.getTabla())) {
				ActivoTitulo activoTitulo = genericDao.get(ActivoTitulo.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("017".equalsIgnoreCase(campo)) {
					DDEstadoTitulo estadoTitulo = genericDao.get(DDEstadoTitulo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoTitulo.setEstado(estadoTitulo);
				}else if("018".equalsIgnoreCase(campo)) {
					SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
					Date fecha = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
					activoTitulo.setFechaInscripcionReg(fecha);
				}
				genericDao.save(ActivoTitulo.class, activoTitulo);
			}else if("ACT_VAL_VALORACIONES".equalsIgnoreCase(convivencia.getTabla())) {
				ActivoValoraciones activoVal = genericDao.get(ActivoValoraciones.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("099".equalsIgnoreCase(campo)) {
					DDTipoPrecio tipoPrecio = genericDao.get(DDTipoPrecio.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoVal.setTipoPrecio(tipoPrecio);
				}else if("100".equalsIgnoreCase(campo)) {
					DDTipoPrecio tipoPrecio = genericDao.get(DDTipoPrecio.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoVal.setTipoPrecio(tipoPrecio);
				}else if("101".equalsIgnoreCase(campo)) {
					DDTipoPrecio tipoPrecio = genericDao.get(DDTipoPrecio.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoVal.setTipoPrecio(tipoPrecio);
				}else if("109".equalsIgnoreCase(campo)) {
					DDTipoPrecio tipoPrecio = genericDao.get(DDTipoPrecio.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoVal.setTipoPrecio(tipoPrecio);
				}else if("110".equalsIgnoreCase(campo)) {
					SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
					Date fecha = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
					activoVal.setFechaInicio(fecha);
				}else if("111".equalsIgnoreCase(campo)) {
					SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
					Date fecha = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
					activoVal.setFechaFin(fecha);
				}else if("112".equalsIgnoreCase(campo)) {
					DDTipoPrecio tipoPrecio = genericDao.get(DDTipoPrecio.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoVal.setTipoPrecio(tipoPrecio);
				}else if("113".equalsIgnoreCase(campo)) {
					SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
					Date fecha = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
					activoVal.setFechaInicio(fecha);
				}else if("114".equalsIgnoreCase(campo)) {
					SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
					Date fecha = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
					activoVal.setFechaFin(fecha);
				}
				genericDao.save(ActivoValoraciones.class, activoVal);
			}else if("ACT_ZCO_ZONA_COMUN".equalsIgnoreCase(convivencia.getTabla())) {
				ActivoZonaComun activoZonaComun = genericDao.get(ActivoZonaComun.class, genericDao.createFilter(FilterType.EQUALS, "infoComercial.activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("014".equalsIgnoreCase(campo)) {
					activoZonaComun.setConserjeVigilancia(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
					genericDao.save(ActivoZonaComun.class, activoZonaComun);
				}
			}else if("BIE_ADJ_ADJUDICACION".equalsIgnoreCase(convivencia.getTabla())) {
				NMBAdjudicacionBien nmbAdj = genericDao.get(NMBAdjudicacionBien.class,genericDao.createFilter(FilterType.EQUALS, "bien",activo.getBien()));
				if("026".equalsIgnoreCase(campo)) {
					SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
					Date fecha = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
					nmbAdj.setFechaDecretoFirme(fecha);
				}else if("027".equalsIgnoreCase(campo)) {
					SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
					Date fecha = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
					nmbAdj.setFechaSenalamientoLanzamiento(fecha);
				}
				genericDao.save(NMBAdjudicacionBien.class,nmbAdj);
			}else if("BIE_CAR_CARGAS".equalsIgnoreCase(convivencia.getTabla())) {
				NMBBienCargas bienCargas = genericDao.get(NMBBienCargas.class, genericDao.createFilter(FilterType.EQUALS, "bien",activo.getBien()));
				if("030".equalsIgnoreCase(campo)){
					//BIE_CAR_ID_RECOVERY no aparece en el class
				}else if("033".equalsIgnoreCase(campo)) {
					bienCargas.setTitular(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("034".equalsIgnoreCase(campo)) {
					bienCargas.setImporteRegistral(Float.parseFloat(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("037".equalsIgnoreCase(campo)) {
					SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
					Date fecha = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
					bienCargas.setFechaCancelacion(fecha);
				}else if("038".equalsIgnoreCase(campo)) {
					SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
					Date fecha = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
					bienCargas.setFechaPresentacion(fecha);
				}
				genericDao.save(NMBBienCargas.class, bienCargas);
			}else if("BIE_DATOS_REGISTRALES".equalsIgnoreCase(convivencia.getTabla())) {
				NMBInformacionRegistralBien datos = genericDao.get(NMBInformacionRegistralBien.class, genericDao.createFilter(FilterType.EQUALS, "bien",activo.getBien()));
				if("065".equalsIgnoreCase(campo)){
					DDProvincia provincia = genericDao.get(DDProvincia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					datos.setProvincia(provincia);
				}else if("066".equalsIgnoreCase(campo)) {
					Localidad loc = genericDao.get(Localidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					datos.setLocalidad(loc);
				}else if("067".equalsIgnoreCase(campo)) {
					datos.setNumRegistro(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("068".equalsIgnoreCase(campo)) {
					datos.setTomo(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("069".equalsIgnoreCase(campo)) {
					datos.setLibro(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("070".equalsIgnoreCase(campo)) {
					datos.setFolio(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("071".equalsIgnoreCase(campo)) {
					datos.setNumFinca(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("074".equalsIgnoreCase(campo)) {
					datos.setReferenciaCatastralBien(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("075".equalsIgnoreCase(campo)) {
					BigDecimal bd = new BigDecimal(exc.dameCelda(fila, VALOR_NUEVO));
					datos.setSuperficieConstruida(bd);
				}
				genericDao.save(NMBInformacionRegistralBien.class, datos);
			}else if("BIE_LOCALIZACION".equalsIgnoreCase(convivencia.getTabla())) {
				NMBLocalizacionesBien localizacion = genericDao.get(NMBLocalizacionesBien.class, genericDao.createFilter(FilterType.EQUALS, "bien",activo.getBien()));
				if("040".equalsIgnoreCase(campo)){
					DDTipoVia tipoVia = genericDao.get(DDTipoVia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					localizacion.setTipoVia(tipoVia);
				}else if("042".equalsIgnoreCase(campo)) {
					localizacion.setNombreVia(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("044".equalsIgnoreCase(campo)) {
					localizacion.setNumeroDomicilio(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("046".equalsIgnoreCase(campo)) {
					localizacion.setEscalera(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("048".equalsIgnoreCase(campo)) {
					localizacion.setPiso(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("050".equalsIgnoreCase(campo)) {
					localizacion.setPuerta(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("052".equalsIgnoreCase(campo)) {
					DDProvincia provincia = genericDao.get(DDProvincia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					localizacion.setProvincia(provincia);
				}else if("054".equalsIgnoreCase(campo)) {
					Localidad loc = genericDao.get(Localidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					localizacion.setLocalidad(loc);
				}else if("056".equalsIgnoreCase(campo)) {
					DDProvincia provincia = genericDao.get(DDProvincia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					localizacion.setProvincia(provincia);
				}else if("057".equalsIgnoreCase(campo)) {
					DDCicCodigoIsoCirbeBKP codIso = genericDao.get(DDCicCodigoIsoCirbeBKP.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					localizacion.setPais(codIso);
				}else if("058".equalsIgnoreCase(campo)) {
					localizacion.setCodPostal(exc.dameCelda(fila, VALOR_NUEVO));
				}
				genericDao.save(NMBLocalizacionesBien.class, localizacion);
			}else if("BIE_VALORACIONES".equalsIgnoreCase(convivencia.getTabla())) {
				NMBValoracionesBien valoraciones = genericDao.get(NMBValoracionesBien.class, genericDao.createFilter(FilterType.EQUALS, "bien",activo.getBien()));
				if("103".equalsIgnoreCase(campo)){
					SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
					Date fecha = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
					valoraciones.setFechaValorTasacion(fecha);
				}else if("104".equalsIgnoreCase(campo)) {
					SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
					Date fecha = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
					valoraciones.setFechaSolicitudTasacion(fecha);
				}else if("106".equalsIgnoreCase(campo)) {
					DDTasadora tasadora = genericDao.get(DDTasadora.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					valoraciones.setTasadora(tasadora);
				}
				genericDao.save(NMBValoracionesBien.class, valoraciones);
			}else if("ECO_EXPEDIENTE_COMERCIAL".equalsIgnoreCase(convivencia.getTabla())) {
				//LA clase Activo Oferta tiene una codificacion diferente de los modelos nuevos.
				List<ActivoOferta> actOferta = genericDao.getList(ActivoOferta.class, genericDao.createFilter(FilterType.EQUALS, "activo",activo.getId()));
				if("127".equalsIgnoreCase(campo) && actOferta.size() > 0) {
					Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "activosOferta",actOferta));
					if(oferta != null ) {
						ExpedienteComercial exp = genericDao.get(ExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "oferta",oferta));
						if(exp != null) {
							SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
							Date fecha = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
							exp.setFechaDevolucionEntregas(fecha);
							genericDao.save(ExpedienteComercial.class, exp);
						}
					}
				}
			}else if("RES_RESERVAS".equalsIgnoreCase(convivencia.getTabla())) {
				List<ActivoOferta> actOferta = genericDao.getList(ActivoOferta.class, genericDao.createFilter(FilterType.EQUALS, "activo",activo.getId()));
				if(actOferta.size() > 0){
					Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "activosOferta",actOferta));
					if(oferta != null) {
						ExpedienteComercial exp = genericDao.get(ExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "oferta",oferta));
						if(exp != null) {
							Reserva reserva = genericDao.get(Reserva.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id",exp.getId()));
							if(reserva != null) {
								if("126".equalsIgnoreCase(campo)){
									SimpleDateFormat sdf = new SimpleDateFormat("DD/MM/YYYY");
									Date fecha = sdf.parse(exc.dameCelda(fila, VALOR_NUEVO));
									reserva.setFechaContabilizacionReserva(fecha);
									reserva.setFechaFirma(fecha);
								}else if("125".equalsIgnoreCase(campo)) {
									reserva.setNumReserva(Long.parseLong(exc.dameCelda(fila, VALOR_NUEVO)));
								}
								genericDao.save(Reserva.class, reserva);
							}
						}
					}
				}
			}
			
		}
		
		return new ResultadoProcesarFila();
	}

	
	@Override
	public int getFilaInicial() {
		return DATOS_PRIMERA_FILA;
	}

}
