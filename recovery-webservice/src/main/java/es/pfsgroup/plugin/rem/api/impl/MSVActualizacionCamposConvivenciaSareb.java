package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.BooleanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.procesosJudiciales.model.DDFavorable;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
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
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoCarga;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdjudicacionBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienCargas;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBInformacionRegistralBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBValoracionesBien;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionJudicial;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionNoJudicial;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.ActivoCargas;
import es.pfsgroup.plugin.rem.model.ActivoConfigDocumento;
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
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoTramitacionTitulo;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.dd.DDAdecuacionAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDCamposConvivenciaSareb;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAdecucionSareb;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoCarga;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoInclusionExclusionPerimetro;
import es.pfsgroup.plugin.rem.model.dd.DDPortal;
import es.pfsgroup.plugin.rem.model.dd.DDSegmentoSareb;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoCarga;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCargaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCuotaComunidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCorrectivoSareb;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGradoPropiedad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTasacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUsoDestino;

@Component
public class MSVActualizacionCamposConvivenciaSareb extends AbstractMSVActualizador implements MSVLiberator {
	
	private static final int DATOS_PRIMERA_FILA = 1;
	private static final int NUM_ACTIVO = 0;
	private static final int ID_SUB_REGISTRO = 2;
	private static final int CAMPO_CAMBIO = 3;
	private static final int VALOR_NUEVO = 5;
	private static final int NUEVO = 7;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoDao activoDao;
		
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZACION_CAMPOS_ESPARTAR_CONVIVENCIA_SAREB;
	}
	
	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		
		//Aqui empieza la persistencia.
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		SimpleDateFormat sdfOri = new SimpleDateFormat("yyyy/MM/dd"); 
		SimpleDateFormat sdfSal = new SimpleDateFormat("dd/MM/yyyy"); 
		if(exc.dameCelda(fila, NUM_ACTIVO) != null) {
			String campo;
			DDCamposConvivenciaSareb convivencia = null;
			campo = exc.dameCelda(fila, CAMPO_CAMBIO);
			Filter filtroCampo = genericDao.createFilter(FilterType.EQUALS, "cos.codigo",campo);
			List<DDCamposConvivenciaSareb> convivencias = genericDao.getList(DDCamposConvivenciaSareb.class, filtroCampo);
			if (!convivencias.isEmpty() && convivencias != null) {
				convivencia = convivencias.get(0);
			} else {
				convivencia = new DDCamposConvivenciaSareb();
				convivencia.setTabla("CampoNoIncluido");
			}
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
				}else if ("173".equals(campo)) {
					Boolean res = Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)) == 1 ? true : false;
					activo.setTieneOkTecnico(res);
				}
				genericDao.save(Activo.class, activo);
			}else if("ACT_AGR_AGRUPACION".equalsIgnoreCase(convivencia.getTabla())) {
				//Pone en la el CCS que agrupa por agrupacion Id
				ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class,genericDao.createFilter(FilterType.EQUALS, "numAgrupRem" ,Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("091".equals(campo)) {
					agrupacion.setCodigoOnSareb(exc.dameCelda(fila, VALOR_NUEVO));
				}
				genericDao.save(ActivoAgrupacion.class, agrupacion);
			}else if("ACT_AJD_ADJJUDICIAL".equalsIgnoreCase(convivencia.getTabla())){
				ActivoAdjudicacionJudicial activoAdjJudicial = genericDao.get(ActivoAdjudicacionJudicial.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("025".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fechaAdj = sdfSal.parse(fechaString);
					activoAdjJudicial.setFechaAdjudicacion(fechaAdj);	
				}else if("145".equalsIgnoreCase(campo)) {
					activoAdjJudicial.setNumAuto(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("146".equalsIgnoreCase(campo)) {
					activoAdjJudicial.setProcurador(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("147".equalsIgnoreCase(campo)) {
					activoAdjJudicial.setLetrado(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("148".equalsIgnoreCase(campo)) {
					activoAdjJudicial.setIdAsunto(Long.parseLong(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if ("168".equalsIgnoreCase(campo)) {
					TipoJuzgado juzgado = genericDao.get(TipoJuzgado.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoAdjJudicial.setJuzgado(juzgado);
				}else if ("169".equalsIgnoreCase(campo)) {
					TipoPlaza plaza = genericDao.get(TipoPlaza.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoAdjJudicial.setPlazaJuzgado(plaza);
				}
				genericDao.save(ActivoAdjudicacionJudicial.class, activoAdjJudicial);
			}else if("ACT_ADN_ADJNOJUDICIAL".equalsIgnoreCase(convivencia.getTabla())){
				ActivoAdjudicacionNoJudicial activoAdjNoJudicial = genericDao.get(ActivoAdjudicacionNoJudicial.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo", Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("156".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fechaAdjNo = sdfSal.parse(fechaString);
					activoAdjNoJudicial.setFechaTitulo(fechaAdjNo);	
				}else if("021".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					activoAdjNoJudicial.setFechaPosesion(fecha);
				}
				genericDao.save(ActivoAdjudicacionNoJudicial.class, activoAdjNoJudicial);
			}else if("ACT_APU_ACTIVO_PUBLICACION".equalsIgnoreCase(convivencia.getTabla())) {
				ActivoPublicacion activoPub = genericDao.get(ActivoPublicacion.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("085".equalsIgnoreCase(campo)) {
					DDPortal portal = genericDao.get(DDPortal.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoPub.setPortal(portal);
				}else if ("175".equalsIgnoreCase(campo)) {
					Boolean res = Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)) == 1 ? true : false;
					activoPub.setCheckOcultarPrecioVenta(res);
				}else if ("177".equals(campo)) {
					Boolean res = Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)) == 1 ? true : false;
					activoPub.setCheckSinPrecioVenta(res);
				}
				genericDao.save(ActivoPublicacion.class, activoPub);
			}else if("ACT_CAN_CALIFICACION_NEG".equalsIgnoreCase(convivencia.getTabla())) {
				ActivoCalificacionNegativa activoCalNeg = genericDao.get(ActivoCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("140".equalsIgnoreCase(campo)) {
					DDMotivoCalificacionNegativa motivo = genericDao.get(DDMotivoCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoCalNeg.setMotivoCalificacionNegativa(motivo);
				}else if ("162".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					activoCalNeg.setFechaSubsanacion(fecha);	
				}
				genericDao.save(ActivoCalificacionNegativa.class, activoCalNeg);
			}else if("ACT_CRG_CARGAS".equalsIgnoreCase(convivencia.getTabla()) && Integer.parseInt(exc.dameCelda(fila, NUEVO)) == 0) {
				Long idCarga = activoDao.getCarga(exc.dameCelda(fila, ID_SUB_REGISTRO));
				if (idCarga != null) {
					ActivoCargas activoCargas = genericDao.get(ActivoCargas.class, genericDao.createFilter(FilterType.EQUALS, "id", idCarga));
					if("031".equalsIgnoreCase(campo)) {
						DDTipoCargaActivo tipoCarga = genericDao.get(DDTipoCargaActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
						activoCargas.setTipoCargaActivo(tipoCarga);
					}else if("032".equalsIgnoreCase(campo)) {
						DDSubtipoCarga subtipoCarga = genericDao.get(DDSubtipoCarga.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
						activoCargas.setSubtipoCarga(subtipoCarga);
					}else if("035".equalsIgnoreCase(campo) || "036".equalsIgnoreCase(campo)) {
						DDEstadoCarga estadoCarga = genericDao.get(DDEstadoCarga.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
						activoCargas.setEstadoCarga(estadoCarga);
					}else if("039".equalsIgnoreCase(campo)) {
						Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
						String fechaString = sdfSal.format(fechaOri);
						Date fecha = sdfSal.parse(fechaString);
						activoCargas.setFechaCancelacionRegistral(fecha);
					}
					genericDao.save(ActivoCargas.class, activoCargas);
				}
			} else if("ACT_EDI_EDIFICIO".equalsIgnoreCase(convivencia.getTabla())) {
				ActivoEdificio activoEdi = genericDao.get(ActivoEdificio.class, genericDao.createFilter(FilterType.EQUALS, "infoComercial.activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("029".equalsIgnoreCase(campo)) {
					activoEdi.setAscensorEdificio(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
				}
				genericDao.save(ActivoEdificio.class, activoEdi);
			}else if("ACT_LOC_LOCALIZACION".equalsIgnoreCase(convivencia.getTabla())) {
				ActivoLocalizacion activoLoc = genericDao.get(ActivoLocalizacion.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("060".equalsIgnoreCase(campo)) {
					BigDecimal bd = getBigDecimal(exc.dameCelda(fila, VALOR_NUEVO));
					activoLoc.setLatitud(bd);
				}else if("062".equalsIgnoreCase(campo)) {
					BigDecimal bd = getBigDecimal(exc.dameCelda(fila, VALOR_NUEVO));
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
					Boolean res = Integer.parseInt(exc.dameCelda(fila, NUEVO)) == 1 ? true : false;
					activoPatrimonio.setCheckSubrogado(res);
				}else if("123".equalsIgnoreCase(campo)) {
					DDAdecuacionAlquiler ada = genericDao.get(DDAdecuacionAlquiler.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoPatrimonio.setAdecuacionAlquiler(ada);
				}
				genericDao.save(ActivoPatrimonio.class, activoPatrimonio);
			}else if("ACT_REG_INFO_REGISTRAL".equalsIgnoreCase(convivencia.getTabla()) && !"093".equalsIgnoreCase(campo)) {
				ActivoInfoRegistral infoRegistral = genericDao.get(ActivoInfoRegistral.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("064".equalsIgnoreCase(campo)) {
					infoRegistral.setDivHorInscrito(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("073".equalsIgnoreCase(campo)) {
					infoRegistral.setIdufir(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("076".equalsIgnoreCase(campo)) {
					infoRegistral.setSuperficieUtil(Float.parseFloat(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("077".equalsIgnoreCase(campo)) {
					infoRegistral.setSuperficieParcela(Float.parseFloat(exc.dameCelda(fila, VALOR_NUEVO)));
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
				}else if("061".equalsIgnoreCase(campo)) {
					BigDecimal bd = getBigDecimal(exc.dameCelda(fila, VALOR_NUEVO));
					activoSareb.setLatitudOE(bd);
				}else if("063".equalsIgnoreCase(campo)) {
					BigDecimal bd = getBigDecimal(exc.dameCelda(fila, VALOR_NUEVO));
					activoSareb.setLongitudOE(bd);
				}else if("097".equalsIgnoreCase(campo)) {
					DDEstadoAdecucionSareb adecuacion = genericDao.get(DDEstadoAdecucionSareb.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoSareb.setEstadoAdecuacionSareb(adecuacion);
				}else if("098".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					activoSareb.setFechaFinPrevistaAdecuacion(fecha);
				}else if("141".equalsIgnoreCase(campo)) {
					DDSinSiNo res = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoSareb.setReoContabilizado(res);
				}else if ("172".equalsIgnoreCase(campo)) {
					DDSegmentoSareb segmento = genericDao.get(DDSegmentoSareb.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoSareb.setSegmentoSareb(segmento);
				}else if ("174".equals(campo)) {
					DDSinSiNo res = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoSareb.setGgaaSareb(res);
				}else if ("176".equals(campo)) {
					DDTipoCuotaComunidad tipoComunidad = genericDao.get(DDTipoCuotaComunidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoSareb.setTipoCuotaComunidad(tipoComunidad);
				}else if("143".equalsIgnoreCase(campo)) {
					DDTipoCorrectivoSareb tipoCorrectivo = genericDao.get(DDTipoCorrectivoSareb.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoSareb.setTipoCorrectivoSareb(tipoCorrectivo);
				}else if("144".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fechaFinCor = sdfSal.parse(fechaString);
					activoSareb.setFechaFinCorrectivoSareb(fechaFinCor);
				}
				genericDao.save(ActivoSareb.class, activoSareb);
			}else if("ACT_SPS_SIT_POSESORIA".equalsIgnoreCase(convivencia.getTabla())) {
				ActivoSituacionPosesoria situacionPosesioria = genericDao.get(ActivoSituacionPosesoria.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("007".equalsIgnoreCase(campo)) {
					DDTipoTituloActivoTPA tipoTituloActivo = null;
					situacionPosesioria.setOcupado(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
					if (Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)) == 1) {
						tipoTituloActivo = genericDao.get(DDTipoTituloActivoTPA.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoTituloActivoTPA.tipoTituloSi));
					}
					situacionPosesioria.setConTitulo(tipoTituloActivo);
					situacionPosesioria.setFechaUltCambioTit(new Date());
				}else if("009".equalsIgnoreCase(campo)) {
					DDTipoTituloActivoTPA tipoTituloActivo = null;
					situacionPosesioria.setOcupado(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
					if (Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)) == 1) {
						tipoTituloActivo = genericDao.get(DDTipoTituloActivoTPA.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoTituloActivoTPA.tipoTituloNo));
					}
					situacionPosesioria.setConTitulo(tipoTituloActivo);
					situacionPosesioria.setFechaUltCambioTit(new Date());
				}else if("012".equalsIgnoreCase(campo)) {
					situacionPosesioria.setRiesgoOcupacion(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("013".equalsIgnoreCase(campo)) {
					situacionPosesioria.setAccesoAntiocupa(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
					if (Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)) == 1) {
						situacionPosesioria.setFechaAccesoAntiocupa(new Date());
					} else {
						situacionPosesioria.setFechaAccesoAntiocupa(null);
					}					
				}else if("021".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					situacionPosesioria.setFechaTomaPosesion(fecha);
				}else if("096".equalsIgnoreCase(campo)) {
					situacionPosesioria.setAccesoTapiado(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
					if (Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)) == 1) {
						situacionPosesioria.setFechaAccesoTapiado(new Date());
					} else {
						situacionPosesioria.setFechaAccesoTapiado(null);
					}
					situacionPosesioria.setFechaUltCambioTapiado(new Date());
				}else if("014".equalsIgnoreCase(campo)) {
					situacionPosesioria.setConVigilancia(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("015".equalsIgnoreCase(campo)) {
					situacionPosesioria.setConAlarma(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
				}
				genericDao.save(ActivoSituacionPosesoria.class, situacionPosesioria);
			}else if("ACT_TAS_TASACION".equalsIgnoreCase(convivencia.getTabla()) && Integer.parseInt(exc.dameCelda(fila, NUEVO)) == 0) {
				ActivoTasacion tasacion = genericDao.get(ActivoTasacion.class, genericDao.createFilter(FilterType.EQUALS, "idExterno",Long.parseLong(exc.dameCelda(fila, ID_SUB_REGISTRO))));
				if("105".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					tasacion.setFechaRecepcionTasacion(fecha);
				}else if("107".equalsIgnoreCase(campo)) {
					tasacion.setImporteTasacionFin(getDouble(exc.dameCelda(fila, VALOR_NUEVO)));
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
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					activoTitulo.setFechaInscripcionReg(fecha);
				}else if ("157".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					activoTitulo.setFechaEntregaGestoria(fecha);
				}else if ("158".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					activoTitulo.setFechaPresHacienda(fecha);
				}else if ("159".equalsIgnoreCase(campo) || "163".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					activoTitulo.setFechaPres2Registro(fecha);
				}else if ("160".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					activoTitulo.setFechaPres1Registro(fecha);
				}else if ("161".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					activoTitulo.setFechaRetiradaReg(fecha);
				}
				genericDao.save(ActivoTitulo.class, activoTitulo);
			}else if("ACT_VAL_VALORACIONES".equalsIgnoreCase(convivencia.getTabla()) || "115".equalsIgnoreCase(campo)) {
				ActivoValoraciones activoVal = null;
				if("099".equalsIgnoreCase(campo)) {
					activoVal = genericDao.get(ActivoValoraciones.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO)))
							, genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA));
					activoVal.setImporte(getDouble(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("100".equalsIgnoreCase(campo)) {
					activoVal = genericDao.get(ActivoValoraciones.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO)))
							, genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA));
					activoVal.setImporte(getDouble(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("101".equalsIgnoreCase(campo)) {
					activoVal = genericDao.get(ActivoValoraciones.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO)))
							, genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO));
					activoVal.setImporte(getDouble(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("109".equalsIgnoreCase(campo)) {
					activoVal = genericDao.get(ActivoValoraciones.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO)))
							, genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA));
					activoVal.setImporte(getDouble(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("110".equalsIgnoreCase(campo)) {
					activoVal = genericDao.get(ActivoValoraciones.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO)))
							, genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA));
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					activoVal.setFechaInicio(fecha);
				}else if("111".equalsIgnoreCase(campo)) {
					activoVal = genericDao.get(ActivoValoraciones.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO)))
							, genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA));
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					activoVal.setFechaFin(fecha);
				}else if("112".equalsIgnoreCase(campo)) {
					activoVal = genericDao.get(ActivoValoraciones.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO)))
							, genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA));
					activoVal.setImporte(getDouble(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("113".equalsIgnoreCase(campo)) {
					activoVal = genericDao.get(ActivoValoraciones.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO)))
							, genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA));
					activoVal.setImporte(getDouble(exc.dameCelda(fila, VALOR_NUEVO)));
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					activoVal.setFechaInicio(fecha);
				}else if("114".equalsIgnoreCase(campo)) {
					activoVal = genericDao.get(ActivoValoraciones.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO)))
							, genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA));
					activoVal.setImporte(getDouble(exc.dameCelda(fila, VALOR_NUEVO)));
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					activoVal.setFechaFin(fecha);
				}else if("115".equalsIgnoreCase(campo)) {
					activoVal = genericDao.get(ActivoValoraciones.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO)))
							, genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_MIN_AUT_PROP_RENTA));
					activoVal.setImporte(getDouble(exc.dameCelda(fila, VALOR_NUEVO)));
				}
				genericDao.save(ActivoValoraciones.class, activoVal);
			}else if("ACT_PAC_PERIMETRO_ACTIVO".equalsIgnoreCase(convivencia.getTabla())) {
				PerimetroActivo activoPerimetro = genericDao.get(PerimetroActivo.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("178".equalsIgnoreCase(campo)) {
					activoPerimetro.setIncluidoEnPerimetro(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if ("179".equals(campo)) {
					activoPerimetro.setAplicaGestion(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if ("180".equals(campo)) {
					DDMotivoInclusionExclusionPerimetro motivoIncExcl = genericDao.get(DDMotivoInclusionExclusionPerimetro.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					String descripMot = motivoIncExcl.getDescripcion();
					activoPerimetro.setMotivoAplicaGestion(descripMot);
				}else if ("181".equals(campo)) {
					Boolean res = Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)) == 1 ? true : false;
					activoPerimetro.setAplicaPublicar(res);
				}else if ("182".equals(campo)) {
					DDMotivoInclusionExclusionPerimetro motivoIncExcl = genericDao.get(DDMotivoInclusionExclusionPerimetro.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					String descripMot = motivoIncExcl.getDescripcion();
					activoPerimetro.setMotivoAplicaPublicar(descripMot);
				}else if ("183".equals(campo)) {
					activoPerimetro.setAplicaComercializar(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
					activoPerimetro.setCheckGestorComercial(BooleanUtils.toBoolean(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)),1,0));
					if(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)) == 1) {
						activoPerimetro.setFechaGestionComercial(new Date());
					}else {
						activoPerimetro.setFechaGestionComercial(null);
					}
				}else if ("184".equals(campo)) {
					if (activoPerimetro.getAplicaComercializar() == 1) {
						DDMotivoComercializacion motivoComercializacion = genericDao.get(DDMotivoComercializacion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
						activoPerimetro.setMotivoAplicaComercializar(motivoComercializacion);
					} else {
						DDMotivoInclusionExclusionPerimetro motivoIncExcl = genericDao.get(DDMotivoInclusionExclusionPerimetro.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
						String descripMot = motivoIncExcl.getDescripcion();
						activoPerimetro.setMotivoNoAplicaComercializar(descripMot);
					}
				}else if ("185".equals(campo)) {
					activoPerimetro.setAplicaFormalizar(Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if ("186".equals(campo)) {
					DDMotivoInclusionExclusionPerimetro motivoIncExcl = genericDao.get(DDMotivoInclusionExclusionPerimetro.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					String descripMot = motivoIncExcl.getDescripcion();
					activoPerimetro.setMotivoAplicaFormalizar(descripMot);
				}
				genericDao.save(PerimetroActivo.class, activoPerimetro);
			}else if("ACT_AHT_HIST_TRAM_TITULO".equalsIgnoreCase(convivencia.getTabla())){
				HistoricoTramitacionTitulo historicoTramitacionTitulo = genericDao.get(HistoricoTramitacionTitulo.class, genericDao.createFilter(FilterType.EQUALS, "titulo.activo.numActivo", Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("164".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fechaAdjNo = sdfSal.parse(fechaString);
					historicoTramitacionTitulo.setFechaCalificacion(fechaAdjNo);	
				}
				genericDao.save(HistoricoTramitacionTitulo.class, historicoTramitacionTitulo);
			}else if("ACT_ABA_ACTIVO_BANCARIO".equalsIgnoreCase(convivencia.getTabla())){
				ActivoBancario activoBancario = genericDao.get(ActivoBancario.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo", Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
				if("166".equalsIgnoreCase(campo)) {
					activoBancario.setNumExpRiesgo(exc.dameCelda(fila, VALOR_NUEVO));
				}
				genericDao.save(ActivoBancario.class, activoBancario);
			}else if("BIE_ADJ_ADJUDICACION".equalsIgnoreCase(convivencia.getTabla())) {
				NMBAdjudicacionBien nmbAdj = genericDao.get(NMBAdjudicacionBien.class,genericDao.createFilter(FilterType.EQUALS, "bien",activo.getBien()));
				if("026".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					nmbAdj.setFechaDecretoFirme(fecha);
				}else if("027".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					nmbAdj.setFechaSenalamientoLanzamiento(fecha);
				}else if("149".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					nmbAdj.setFechaSolicitudMoratoria(fecha);
				}else if("150".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					nmbAdj.setFechaResolucionMoratoria(fecha);
				}else if("151".equalsIgnoreCase(campo)) {
					DDFavorable favorable = genericDao.get(DDFavorable.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					nmbAdj.setResolucionMoratoria(favorable);
				}else if ("152".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					nmbAdj.setFechaSenalamientoPosesion(fecha);
				}else if ("153".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					nmbAdj.setFechaRealizacionPosesion(fecha);
				}else if ("154".equalsIgnoreCase(campo)) {
					Boolean res = Integer.parseInt(exc.dameCelda(fila, VALOR_NUEVO)) == 1 ? true : false;
					nmbAdj.setLanzamientoNecesario(res);
				}else if ("155".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					nmbAdj.setFechaRealizacionLanzamiento(fecha);
				}else if ("167".equalsIgnoreCase(campo)) {
					BigDecimal bd = getBigDecimal(exc.dameCelda(fila, VALOR_NUEVO));
					nmbAdj.setImporteAdjudicacion(bd);
				}
				genericDao.save(NMBAdjudicacionBien.class,nmbAdj);
			}else if("BIE_CAR_CARGAS".equalsIgnoreCase(convivencia.getTabla()) && Integer.parseInt(exc.dameCelda(fila, NUEVO)) == 0) {
				NMBBienCargas bienCargas = null;
				ActivoCargas activoCargas = null;
				Long idCarga = activoDao.getCarga(exc.dameCelda(fila, ID_SUB_REGISTRO));
				if (idCarga != null) {
					activoCargas = genericDao.get(ActivoCargas.class, genericDao.createFilter(FilterType.EQUALS, "id", idCarga));
					bienCargas = activoCargas.getCargaBien();
					if("033".equalsIgnoreCase(campo)) {
						bienCargas.setTitular(exc.dameCelda(fila, VALOR_NUEVO));
					}else if("034".equalsIgnoreCase(campo)) {
						bienCargas.setImporteRegistral(Float.parseFloat(exc.dameCelda(fila, VALOR_NUEVO)));
					}else if("037".equalsIgnoreCase(campo)) {
						Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
						String fechaString = sdfSal.format(fechaOri);
						Date fecha = sdfSal.parse(fechaString);
						bienCargas.setFechaCancelacion(fecha);
					}else if("038".equalsIgnoreCase(campo)) {
						Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
						String fechaString = sdfSal.format(fechaOri);
						Date fecha = sdfSal.parse(fechaString);
						bienCargas.setFechaPresentacion(fecha);
					}
					genericDao.save(NMBBienCargas.class, bienCargas);
				}
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
					BigDecimal bd = getBigDecimal(exc.dameCelda(fila, VALOR_NUEVO));
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
			}else if("BIE_VALORACIONES".equalsIgnoreCase(convivencia.getTabla()) && exc.dameCelda(fila, NUEVO) == null) {
				NMBValoracionesBien valoraciones = genericDao.get(NMBValoracionesBien.class, genericDao.createFilter(FilterType.EQUALS, "bien",activo.getBien()));
				if("103".equalsIgnoreCase(campo)){
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					valoraciones.setFechaValorTasacion(fecha);
				}else if("104".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					valoraciones.setFechaSolicitudTasacion(fecha);
				}else if("106".equalsIgnoreCase(campo)) {
					DDTasadora tasadora = genericDao.get(DDTasadora.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					valoraciones.setTasadora(tasadora);
				}
				genericDao.save(NMBValoracionesBien.class, valoraciones);
			}else if("BIE_VALORACIONES".equalsIgnoreCase(convivencia.getTabla()) && Integer.parseInt(exc.dameCelda(fila, NUEVO)) == 0) {
				NMBValoracionesBien valoraciones = genericDao.get(NMBValoracionesBien.class, genericDao.createFilter(FilterType.EQUALS, "bien",activo.getBien()));
				if("103".equalsIgnoreCase(campo)){
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					valoraciones.setFechaValorTasacion(fecha);
				}else if("104".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					valoraciones.setFechaSolicitudTasacion(fecha);
				}else if("106".equalsIgnoreCase(campo)) {
					DDTasadora tasadora = genericDao.get(DDTasadora.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					valoraciones.setTasadora(tasadora);
				}
				genericDao.save(NMBValoracionesBien.class, valoraciones);
			}else if("ECO_EXPEDIENTE_COMERCIAL".equalsIgnoreCase(convivencia.getTabla())) {
				List<ActivoOferta> ofertas = activo.getOfertas();
				Oferta oferta = null;
				for (ActivoOferta ofertaIter : ofertas) {
					if (ofertaIter.getPrimaryKey() != null 
							&& ofertaIter.getPrimaryKey().getOferta() != null
							&& DDEstadoOferta.CODIGO_ACEPTADA.equals(ofertaIter.getPrimaryKey().getOferta().getEstadoOferta().getCodigo())) {
						oferta = ofertaIter.getPrimaryKey().getOferta();
					}
				}
				
				if("127".equalsIgnoreCase(campo) && oferta != null) {
					if(oferta != null ) {
						ExpedienteComercial exp = genericDao.get(ExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId()));
						if(exp != null) {
							Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
							String fechaString = sdfSal.format(fechaOri);
							Date fecha = sdfSal.parse(fechaString);
							exp.setFechaDevolucionEntregas(fecha);
							genericDao.save(ExpedienteComercial.class, exp);
						}
					}
				}
			}else if("RES_RESERVAS".equalsIgnoreCase(convivencia.getTabla())) {
				List<ActivoOferta> ofertas = activo.getOfertas();
				Oferta oferta = null;
				for (ActivoOferta ofertaIter : ofertas) {
					if (ofertaIter.getPrimaryKey() != null 
							&& ofertaIter.getPrimaryKey().getOferta() != null
							&& DDEstadoOferta.CODIGO_ACEPTADA.equals(ofertaIter.getPrimaryKey().getOferta().getEstadoOferta().getCodigo())) {
						oferta = ofertaIter.getPrimaryKey().getOferta();
					}
				}
				
				if(oferta != null){
					ExpedienteComercial exp = genericDao.get(ExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId()));
					if(exp != null) {
						Reserva reserva = genericDao.get(Reserva.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id", exp.getId()));
						if(reserva != null) {
							if("126".equalsIgnoreCase(campo)){
								Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
								String fechaString = sdfSal.format(fechaOri);
								Date fecha = sdfSal.parse(fechaString);
								reserva.setFechaFirma(fecha);
							}else if("125".equalsIgnoreCase(campo)) {
								reserva.setNumReserva(Long.parseLong(exc.dameCelda(fila, VALOR_NUEVO)));
							}
							genericDao.save(Reserva.class, reserva);
						}
					}
				}
			// Creación de registros nuevos
			}else if((("078".equalsIgnoreCase(campo) || "079".equalsIgnoreCase(campo) || "080".equalsIgnoreCase(campo)
					|| "081".equalsIgnoreCase(campo) || "083".equalsIgnoreCase(campo) || "084".equalsIgnoreCase(campo)
					|| "092".equalsIgnoreCase(campo) || "093".equalsIgnoreCase(campo) ) && "1".equals(exc.dameCelda(fila, VALOR_NUEVO)))
					|| "093".equalsIgnoreCase(campo) || "095".equalsIgnoreCase(campo) || "082".equalsIgnoreCase(campo)) {
				String tipoDocumento = null;
				if ("078".equalsIgnoreCase(campo)) {
					tipoDocumento = "15";
				} else if ("079".equalsIgnoreCase(campo)) {
					tipoDocumento = "16";
				} else if ("080".equalsIgnoreCase(campo)) {
					tipoDocumento = "17";
				} else if ("081".equalsIgnoreCase(campo) || "082".equalsIgnoreCase(campo)) {
					tipoDocumento = "13";
				} else if ("083".equalsIgnoreCase(campo)) {
					tipoDocumento = "11";
				} else if ("084".equalsIgnoreCase(campo)) {
					tipoDocumento = "19";
				} else if ("092".equalsIgnoreCase(campo) || "093".equalsIgnoreCase(campo)) {
					tipoDocumento = "14";
				} else if ("094".equalsIgnoreCase(campo) || "095".equalsIgnoreCase(campo)) {
					tipoDocumento = "12";
				}
				
				if (tipoDocumento != null) {
					DDTipoDocumentoActivo tipoDocumentoActivo = genericDao.get(DDTipoDocumentoActivo.class,genericDao.createFilter(FilterType.EQUALS, "codigo", tipoDocumento));
					if (tipoDocumentoActivo != null) {
						List<ActivoConfigDocumento> configDocumento = genericDao.getList(ActivoConfigDocumento.class, genericDao.createFilter(FilterType.EQUALS, "tipoActivo.codigo", activo.getTipoActivo().getCodigo())
								,genericDao.createFilter(FilterType.EQUALS, "tipoDocumentoActivo.codigo", tipoDocumentoActivo.getCodigo()));
						if (configDocumento != null) {
							ActivoAdmisionDocumento activoAdmisionDoc = genericDao.get(ActivoAdmisionDocumento.class,genericDao.createFilter(FilterType.EQUALS, "activo.numActivo", Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO)))
									,genericDao.createFilter(FilterType.EQUALS, "configDocumento.id", configDocumento.get(0).getId()));
							if (activoAdmisionDoc == null) {
								activoAdmisionDoc = new ActivoAdmisionDocumento();
								activoAdmisionDoc.setActivo(activo);
								activoAdmisionDoc.setConfigDocumento(configDocumento.get(0));
								DDEstadoDocumento estadoDocumento = genericDao.get(DDEstadoDocumento.class,genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoDocumento.CODIGO_ESTADO_OBTENIDO));
								activoAdmisionDoc.setEstadoDocumento(estadoDocumento);
							}
							if("082".equals(campo)) {
								Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
								String fechaString = sdfSal.format(fechaOri);
								Date fechaCaducidad = sdfSal.parse(fechaString);
								activoAdmisionDoc.setFechaCaducidad(fechaCaducidad);
								DDEstadoDocumento estadoDocumento = genericDao.get(DDEstadoDocumento.class,genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoDocumento.CODIGO_ESTADO_OBTENIDO));
								activoAdmisionDoc.setEstadoDocumento(estadoDocumento);
							}else if("095".equals(campo)) {
								Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
								String fechaString = sdfSal.format(fechaOri);
								Date fechaCaducidad = sdfSal.parse(fechaString);
								activoAdmisionDoc.setFechaCaducidad(fechaCaducidad);
								DDEstadoDocumento estadoDocumento = genericDao.get(DDEstadoDocumento.class,genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoDocumento.CODIGO_ESTADO_OBTENIDO));
								activoAdmisionDoc.setEstadoDocumento(estadoDocumento);
							} else if ("093".equals(campo)) {
								ActivoInfoRegistral infoRegistral = genericDao.get(ActivoInfoRegistral.class, genericDao.createFilter(FilterType.EQUALS, "activo.numActivo",Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO))));
								Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
								String fechaString = sdfSal.format(fechaOri);
								Date fechaCfo = sdfSal.parse(fechaString);
								infoRegistral.setFechaCfo(fechaCfo);
								genericDao.save(ActivoInfoRegistral.class, infoRegistral);
								activoAdmisionDoc.setFechaCaducidad(fechaCfo);
								DDEstadoDocumento estadoDocumento = genericDao.get(DDEstadoDocumento.class,genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoDocumento.CODIGO_ESTADO_OBTENIDO));
								activoAdmisionDoc.setEstadoDocumento(estadoDocumento);
							}else {
								activoAdmisionDoc.setFechaObtencion(new Date());
							}
							genericDao.save(ActivoAdmisionDocumento.class, activoAdmisionDoc);
						}
					}
				}
			}else if((("078".equalsIgnoreCase(campo) || "079".equalsIgnoreCase(campo) || "080".equalsIgnoreCase(campo)
					|| "081".equalsIgnoreCase(campo) || "083".equalsIgnoreCase(campo) || "084".equalsIgnoreCase(campo)) && "0".equals(exc.dameCelda(fila, VALOR_NUEVO)))) {
				String tipoDocumento = null;
				if ("078".equalsIgnoreCase(campo)) {
					tipoDocumento = "15";
				} else if ("079".equalsIgnoreCase(campo)) {
					tipoDocumento = "16";
				} else if ("080".equalsIgnoreCase(campo)) {
					tipoDocumento = "17";
				} else if ("081".equalsIgnoreCase(campo)) {
					tipoDocumento = "13";
				} else if ("083".equalsIgnoreCase(campo)) {
					tipoDocumento = "11";
				} else if ("084".equalsIgnoreCase(campo)) {
					tipoDocumento = "19";
				} else if ("092".equalsIgnoreCase(campo)) {
					tipoDocumento = "14";
				} else if ("094".equalsIgnoreCase(campo)) {
					tipoDocumento = "12";
				}
				
				if (tipoDocumento != null) {
					DDTipoDocumentoActivo tipoDocumentoActivo = genericDao.get(DDTipoDocumentoActivo.class,genericDao.createFilter(FilterType.EQUALS, "codigo", tipoDocumento));
					if (tipoDocumentoActivo != null) {
						ActivoConfigDocumento configDocumento = genericDao.get(ActivoConfigDocumento.class,genericDao.createFilter(FilterType.EQUALS, "tipoActivo.codigo", activo.getTipoActivo().getCodigo())
								,genericDao.createFilter(FilterType.EQUALS, "tipoDocumentoActivo.codigo", tipoDocumentoActivo.getCodigo()));
						if (configDocumento != null) {
							ActivoAdmisionDocumento activoAdmisionDoc = genericDao.get(ActivoAdmisionDocumento.class,genericDao.createFilter(FilterType.EQUALS, "activo.numActivo", Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO)))
									,genericDao.createFilter(FilterType.EQUALS, "configDocumento.id", configDocumento.getId()));
							if (activoAdmisionDoc != null) {
								activoAdmisionDoc.setFechaObtencion(null);
								activoAdmisionDoc.setEstadoDocumento(null);
							}
							genericDao.save(ActivoAdmisionDocumento.class, activoAdmisionDoc);
						}
					}
				}
			}else if(("033".equalsIgnoreCase(campo) || "034".equalsIgnoreCase(campo) || "037".equalsIgnoreCase(campo)
					|| "038".equalsIgnoreCase(campo) || "031".equalsIgnoreCase(campo) || "032".equalsIgnoreCase(campo)
					|| "035".equalsIgnoreCase(campo) || "039".equalsIgnoreCase(campo)) && Integer.parseInt(exc.dameCelda(fila, NUEVO)) == 1) {
				boolean crearBieCar = false;
				NMBBienCargas bienCargas = null;
				ActivoCargas activoCargas = null;
				Long idCarga = activoDao.getCarga(exc.dameCelda(fila, ID_SUB_REGISTRO));
				if (idCarga != null) {
					activoCargas = genericDao.get(ActivoCargas.class, genericDao.createFilter(FilterType.EQUALS, "id", idCarga));
				}
				
				if (activoCargas != null) {
					bienCargas = activoCargas.getCargaBien();
				}
				
				if (bienCargas == null) {
					bienCargas = new NMBBienCargas();
					bienCargas.setBien(activo.getBien());
					DDTipoCarga tipoCargaBien = genericDao.get(DDTipoCarga.class, genericDao.createFilter(FilterType.EQUALS, "codigo", "0"));
					bienCargas.setTipoCarga(tipoCargaBien);
					bienCargas.setEconomica(false);
					crearBieCar = true;
				}
				
				if("033".equalsIgnoreCase(campo)) {
					bienCargas.setTitular(exc.dameCelda(fila, VALOR_NUEVO));
				}else if("034".equalsIgnoreCase(campo)) {
					bienCargas.setImporteRegistral(Float.parseFloat(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("037".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					bienCargas.setFechaCancelacion(fecha);
				}else if("038".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					bienCargas.setFechaPresentacion(fecha);
				}
				
				if (activoCargas == null) {
					genericDao.save(NMBBienCargas.class, bienCargas);
					activoCargas = new ActivoCargas();
					activoCargas.setActivo(activo);
					activoCargas.setCargaBien(bienCargas);
					activoCargas.setCargaRecoveryId(Long.parseLong(exc.dameCelda(fila, ID_SUB_REGISTRO)));
					DDSiNo impideVenta = genericDao.get(DDSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSiNo.NO));
					activoCargas.setImpideVenta(impideVenta);
				}
				
				if("031".equalsIgnoreCase(campo)) {
					DDTipoCargaActivo tipoCarga = genericDao.get(DDTipoCargaActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoCargas.setTipoCargaActivo(tipoCarga);
				}else if("032".equalsIgnoreCase(campo)) {
					DDSubtipoCarga subtipoCarga = genericDao.get(DDSubtipoCarga.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoCargas.setSubtipoCarga(subtipoCarga);
				}else if("035".equalsIgnoreCase(campo) || "036".equalsIgnoreCase(campo)) {
					DDEstadoCarga estadoCarga = genericDao.get(DDEstadoCarga.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					activoCargas.setEstadoCarga(estadoCarga);
				}else if("039".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					activoCargas.setFechaCancelacionRegistral(fecha);
				}
				genericDao.save(ActivoCargas.class, activoCargas);
				if (crearBieCar) {
					activoDao.actualizaBieCarIdRecovery(activoCargas.getCargaBien().getIdCarga(), Long.parseLong(exc.dameCelda(fila, ID_SUB_REGISTRO)));
				}
			}else if(("103".equalsIgnoreCase(campo) || "104".equalsIgnoreCase(campo) || "106".equalsIgnoreCase(campo)
					|| "105".equalsIgnoreCase(campo) || "107".equalsIgnoreCase(campo) || "108".equalsIgnoreCase(campo)) 
					&& Integer.parseInt(exc.dameCelda(fila, NUEVO)) == 1) {
				ActivoTasacion tasacion = genericDao.get(ActivoTasacion.class, genericDao.createFilter(FilterType.EQUALS, "idExterno",Long.parseLong(exc.dameCelda(fila, ID_SUB_REGISTRO))));
				NMBValoracionesBien valoracion = null;
				if (tasacion != null) {
					valoracion = tasacion.getValoracionBien();
				} else {
					valoracion = new NMBValoracionesBien();
					valoracion.setBien(activo.getBien());
				}
				
				if("103".equalsIgnoreCase(campo)){
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					valoracion.setFechaValorTasacion(fecha);
				}else if("104".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					valoracion.setFechaSolicitudTasacion(fecha);
				}else if("106".equalsIgnoreCase(campo)) {
					DDTasadora tasadora = genericDao.get(DDTasadora.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					valoracion.setTasadora(tasadora);
				}
				
				if (tasacion == null) {
					genericDao.save(NMBValoracionesBien.class, valoracion);
					tasacion = new ActivoTasacion();
					tasacion.setActivo(activo);
					tasacion.setIdExterno(Long.parseLong(exc.dameCelda(fila, ID_SUB_REGISTRO)));
					tasacion.setValoracionBien(valoracion);
				}

				if("105".equalsIgnoreCase(campo)) {
					Date fechaOri = sdfOri.parse(exc.dameCelda(fila, VALOR_NUEVO));
					String fechaString = sdfSal.format(fechaOri);
					Date fecha = sdfSal.parse(fechaString);
					tasacion.setFechaRecepcionTasacion(fecha);
				}else if("107".equalsIgnoreCase(campo)) {
					tasacion.setImporteTasacionFin(getDouble(exc.dameCelda(fila, VALOR_NUEVO)));
				}else if("108".equalsIgnoreCase(campo)) {
					DDTipoTasacion tipoTasacion = genericDao.get(DDTipoTasacion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, VALOR_NUEVO)));
					tasacion.setTipoTasacion(tipoTasacion);
				}				
				genericDao.save(ActivoTasacion.class, tasacion);
			}
			
		}
		
		return resultado;
	}

	
	@Override
	public int getFilaInicial() {
		return DATOS_PRIMERA_FILA;
	}

	private Double getDouble (String doubleString) {
			
			return Double.valueOf(doubleString.replaceAll(",","."));
		
	}
	
	private BigDecimal getBigDecimal (String bigDecimalString) {
		return new BigDecimal(bigDecimalString.replaceAll(",","."));
	}
}
