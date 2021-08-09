package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDCicCodigoIsoCirbeBKP;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioContratoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioDao;
import es.pfsgroup.plugin.rem.activo.publicacion.dao.ActivoPublicacionDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoBbvaActivos;
import es.pfsgroup.plugin.rem.model.ActivoCaixa;
import es.pfsgroup.plugin.rem.model.ActivoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.ActivoInfoLiberbank;
import es.pfsgroup.plugin.rem.model.ActivoLocalizacion;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonioContrato;
import es.pfsgroup.plugin.rem.model.ActivoPrinexActivos;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.ActivoSareb;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.DtoActivoFichaCabecera;
import es.pfsgroup.plugin.rem.model.DtoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.DtoListadoGestores;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoFasePublicacionActivo;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.VAdmisionDocumentos;
import es.pfsgroup.plugin.rem.model.VPreciosVigentes;
import es.pfsgroup.plugin.rem.model.VPreciosVigentesCaixa;
import es.pfsgroup.plugin.rem.model.VTramitacionOfertaActivo;
import es.pfsgroup.plugin.rem.model.dd.ActivoAdmisionRevisionTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDCategoriaComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDCesionSaneamiento;
import es.pfsgroup.plugin.rem.model.dd.DDCesionUso;
import es.pfsgroup.plugin.rem.model.dd.DDClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDDistritoCaixa;
import es.pfsgroup.plugin.rem.model.dd.DDDisponibleAdministracion;
import es.pfsgroup.plugin.rem.model.dd.DDDisponibleTecnico;
import es.pfsgroup.plugin.rem.model.dd.DDEntradaActivoBankia;
import es.pfsgroup.plugin.rem.model.dd.DDEquipoGestion;
import es.pfsgroup.plugin.rem.model.dd.DDEscaleraEdificio;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAdecucionSareb;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpIncorrienteBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpRiesgoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoInformeComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionVenta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoRegistralActivo;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoGestionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDPlantaEdificio;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoTecnico;
import es.pfsgroup.plugin.rem.model.dd.DDPromocionBBVA;
import es.pfsgroup.plugin.rem.model.dd.DDServicerActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSociedadPagoAnterior;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivoBDE;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivoBDE;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProductoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSegmento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTransmision;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUsoDestino;
import es.pfsgroup.plugin.rem.notificacion.api.AnotacionApi;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;

@Component
public class TabActivoDatosBasicos implements TabActivoService {
	
	private static final String MSG_ERROR_PERIMETRO_COMERCIALIZACION_OFERTAS_VIVAS = "activo.aviso.demsarcar.comercializar.ofertas.vivas";
	private static final String MSG_ERROR_PERIMETRO_FORMALIZACION_EXPEDIENTE_VIVO = "activo.aviso.demsarcar.formalizar.expediente.vivo";
	private static final String MSG_ERROR_PERIMETRO_COMERCIALIZACION_AGR_RESTRINGIDA_NO_PRINCIPAL = "activo.aviso.demsarcar.comercializar.agr.restringida.no.principal";
	private static final String AVISO_TITULO_GESTOR_COMERCIAL = "activo.aviso.titulo.cambio.gestor.comercial";
	private static final String AVISO_MENSAJE_GESTOR_COMERCIAL = "activo.aviso.descripcion.cambio.gestor.comercial";
	private static final String MSG_ERROR_DESTINO_COMERCIAL_OFERTAS_VIVAS_VENTA = "msg.error.tipo.comercializacion.ofertas.vivas";
	private static final String MSG_ERROR_DESTINO_COMERCIAL_OFERTAS_VIVAS_ALQUILER = "msg.error.tipo.comercializacion.ofertas.vivas";
	private static final String ERROR_PORCENTAJE_PARTICIPACION="msg.error.porcentaje.participacion";
	private static final String CESION_USO_ERROR= "msg.error.activo.patrimonio.en.cesion.uso";
	private static final String NO_GESTIONADO_POR_ADMISION = "msg.no.gestionado.admision";
	private static final String Ecoarenys = "B63442974";
	private static final String JaleProcam = "B11819935";
	private static final String PromocionesMiesdelValle = "B39488549";
	private static final String PORCENTAJE_CONTRUCCION_FUERA_LIMITES = "msg.porcentaje.construccion.fuera.limites";
	
	private static String CODIGO_SUPER = "HAYASUPER";
	private static String CODIGO_GESTOR_ACTIVO = "HAYAGESACT";

	private static final String ID_HAYA_NO_EXISTE= "msg.error.activo.hre.no.existe";
	private static final String ACTIVO_NO_BBVA = "msg.error.activo.hre.bbva.no.existe";
	private static final String ACTIVO_VENDIDO_FUERA_DE_PERIMETRO_HAYA= "msg.error.activo.vendido.perimetro";
	private static final String ACTIVO_NO_DIVARIAN_BBVA= "msg.error.activo.no.bbva.divarian";
	//
	private static final String ACTIVO_NO_EXISTE= "msg.error.activo.hre.bbva.no.existe.en.rem";
	private static final String ACTIVO_VENDIDO= "msg.error.activo.vendido";
	private static final String ACTIVO_FUERA_DE_PERIMETRO_HAYA= "msg.error.activo.fuera.perimetro";
	private static final String ACTIVO_NO_COINCIDE_CON_CERBERUS_BBVA= "msg.error.activo.no.bbva.divarian";
	private static final String PERFIL_CHECKCOMERCIALIZAR = "CHECKCOMERCIALIZAR";

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private UpdaterStateApi updaterState;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ActivoAdapter activoAdapter;

	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;
	
	@Autowired
	private AnotacionApi anotacionApi;
	

	
	@Autowired
	private ActivoPatrimonioDao activoPatrimonioDao;

	@Autowired
	private ActivoEstadoPublicacionApi activoEstadoPublicacionApi;
	
	@Autowired
	private ParticularValidatorApi particularValidator;

	@Autowired
	private ActivoAdapter adapter;
	
	@Autowired
	private TareaActivoApi tareaActivoApi;

	@Autowired
	private ActivoPatrimonioContratoDao activoPatrimonioContratoDao;
	
	@Resource
	private MessageService messageServices;
	
	@Autowired
	private ActivoAgrupacionDao activoAgrupacionDao;
	
	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;
	
	@Autowired
	private ActivoPublicacionDao activoPublicacionDao;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	protected static final Log logger = LogFactory.getLog(TabActivoDatosBasicos.class);	

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_DATOS_BASICOS};
	}
	
	
	public DtoActivoFichaCabecera getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {

		DtoActivoFichaCabecera activoDto = new DtoActivoFichaCabecera();

		BeanUtils.copyProperties(activoDto, activo);

		if (activo.getLocalizacion() != null) {
			BeanUtils.copyProperties(activoDto, activo.getLocalizacion().getLocalizacionBien());
			BeanUtils.copyProperties(activoDto, activo.getLocalizacion());
			
			if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getTipoVia() != null) {
				BeanUtils.copyProperty(activoDto, "tipoViaCodigo", activo.getLocalizacion().getLocalizacionBien().getTipoVia().getCodigo());
				BeanUtils.copyProperty(activoDto, "tipoViaDescripcion", activo.getLocalizacion().getLocalizacionBien().getTipoVia().getDescripcion());
			}
			
			if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getPais() != null) {
				BeanUtils.copyProperty(activoDto, "paisCodigo", activo.getLocalizacion().getLocalizacionBien().getPais().getCodigo());
				BeanUtils.copyProperty(activoDto, "paisDescripcion", activo.getLocalizacion().getLocalizacionBien().getPais().getDescripcion());
			}
			if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getLocalidad() != null) {
				BeanUtils.copyProperty(activoDto, "municipioCodigo", activo.getLocalizacion().getLocalizacionBien().getLocalidad().getCodigo());
				BeanUtils.copyProperty(activoDto, "municipioDescripcion", activo.getLocalizacion().getLocalizacionBien().getLocalidad().getDescripcion());
			}
			if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getUnidadPoblacional() != null) {
				BeanUtils.copyProperty(activoDto, "inferiorMunicipioCodigo", activo.getLocalizacion().getLocalizacionBien().getUnidadPoblacional().getCodigo());
				BeanUtils.copyProperty(activoDto, "inferiorMunicipioDescripcion", activo.getLocalizacion().getLocalizacionBien().getUnidadPoblacional().getDescripcion());
			}
			if (activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() != null
					&& activo.getLocalizacion().getLocalizacionBien().getProvincia() != null) {
				BeanUtils.copyProperty(activoDto, "provinciaCodigo", activo.getLocalizacion().getLocalizacionBien().getProvincia().getCodigo());
				BeanUtils.copyProperty(activoDto, "provinciaDescripcion", activo.getLocalizacion().getLocalizacionBien().getProvincia().getDescripcion());

			}
			
			if (activo.getLocalizacion() != null && activo.getLocalizacion().getDistritoCaixa() != null) {
				activoDto.setTipoDistritoCodigoPostalCod(activo.getLocalizacion().getDistritoCaixa().getCodigo());
				activoDto.setTipoDistritoCodigoPostalDesc(activo.getLocalizacion().getDistritoCaixa().getDescripcion());
			}
			
		}	 
		
		if(!Checks.esNulo(activo.getInfoComercial()) && !Checks.esNulo(activo.getInfoComercial().getMediadorInforme())) {
			BeanUtils.copyProperty(activoDto, "nombreMediador", activo.getInfoComercial().getMediadorInforme().getNombre());
		}
			
		if (activo.getMotivoActivo() != null) {
			BeanUtils.copyProperty(activoDto, "motivoActivo", activo.getMotivoActivo());
		}

		if (activo.getCartera() != null) {
			BeanUtils.copyProperty(activoDto, "entidadPropietariaCodigo", activo.getCartera().getCodigo());
			BeanUtils.copyProperty(activoDto, "entidadPropietariaDescripcion", activo.getCartera().getDescripcion());
		}
		if(!Checks.esNulo(activo.getSubcartera())) {
			BeanUtils.copyProperty(activoDto, "subcarteraCodigo", activo.getSubcartera().getCodigo());
			BeanUtils.copyProperty(activoDto, "subcarteraDescripcion", activo.getSubcartera().getDescripcion());
		}
		if (activo.getRating() != null ) {
			BeanUtils.copyProperty(activoDto, "rating", activo.getRating().getCodigo());
		}
		
		BeanUtils.copyProperty(activoDto, "propietario", activo.getFullNamePropietario());	
		
		BeanUtils.copyProperty(activoDto, "tieneOkTecnico", activo.getTieneOkTecnico());

		if(activo.getTipoActivo() != null ) {
			BeanUtils.copyProperty(activoDto, "tipoActivoCodigo", activo.getTipoActivo().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoActivoDescripcion", activo.getTipoActivo().getDescripcion());
			
			if(!Checks.esNulo(activo.getInfoComercial()) && !Checks.esNulo(activo.getInfoComercial().getTipoActivo())) {
				// Comprobar si el tipo de activo es el mismo tanto en el activo como en el informe comercial.
				BeanUtils.copyProperty(activoDto, "tipoActivoAdmisionMediadorCorresponde", activo.getTipoActivo().getCodigo().equals(activo.getInfoComercial().getTipoActivo().getCodigo()));
			}
		}
		Filter filterLbk = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoInfoLiberbank actInfLiber = genericDao.get(ActivoInfoLiberbank.class, filterLbk);

		if (!Checks.esNulo(actInfLiber)){
			if (!Checks.esNulo(actInfLiber.getTipoActivoBde())){
				BeanUtils.copyProperty(activoDto, "tipoActivoCodigoBde", actInfLiber.getTipoActivoBde().getCodigo());
				BeanUtils.copyProperty(activoDto, "tipoActivoDescripcionBde", actInfLiber.getTipoActivoBde().getDescripcion());
			}
			if (!Checks.esNulo(actInfLiber.getSubtipoActivoBde())){
				BeanUtils.copyProperty(activoDto, "subtipoActivoCodigoBde", actInfLiber.getSubtipoActivoBde().getCodigo());
				BeanUtils.copyProperty(activoDto, "subtipoActivoDescripcionBde", actInfLiber.getSubtipoActivoBde().getDescripcion());
			}
			if (!Checks.esNulo(actInfLiber.getCodPromocion())){
				BeanUtils.copyProperty(activoDto, "codPromocionFinal", actInfLiber.getCodPromocion());
			}
			if (!Checks.esNulo(actInfLiber.getCategoriaContable())){
				BeanUtils.copyProperty(activoDto, "catContableDescripcion", actInfLiber.getCategoriaContable().getDescripcion());
			}
		}

		if (activo.getSubtipoActivo() != null ) {
			BeanUtils.copyProperty(activoDto, "subtipoActivoCodigo", activo.getSubtipoActivo().getCodigo());	
			BeanUtils.copyProperty(activoDto, "subtipoActivoDescripcion", activo.getSubtipoActivo().getDescripcion());	
		}
		
		if (activo.getTipoTitulo() != null) {
			BeanUtils.copyProperty(activoDto, "tipoTitulo", activo.getTipoTitulo().getDescripcion());
			BeanUtils.copyProperty(activoDto, "tipoTituloCodigo", activo.getTipoTitulo().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoTituloDescripcion", activo.getTipoTitulo().getDescripcion());
		}
		
		if (activo.getSubtipoTitulo() != null) {
			BeanUtils.copyProperty(activoDto, "subtipoTitulo", activo.getSubtipoTitulo().getDescripcion());
			BeanUtils.copyProperty(activoDto, "subtipoTituloCodigo", activo.getSubtipoTitulo().getCodigo());
			BeanUtils.copyProperty(activoDto, "subtipoTituloDescripcion", activo.getSubtipoTitulo().getDescripcion());
		}
		
		if (activo.getCartera() != null) {
			BeanUtils.copyProperty(activoDto, "entidadPropietariaCodigo", activo.getCartera().getCodigo());
			BeanUtils.copyProperty(activoDto, "entidadPropietariaDescripcion", activo.getCartera().getDescripcion());
		}
		
		if (activo.getBien().getLocalizaciones() != null && activo.getBien().getLocalizaciones().get(0).getLocalidad() != null) {
			BeanUtils.copyProperty(activoDto, "municipioDescripcion", activo.getBien().getLocalizaciones().get(0).getLocalidad().getDescripcion());
		}
		
		if (activo.getEstadoActivo() != null) {
			BeanUtils.copyProperty(activoDto, "estadoActivoCodigo", activo.getEstadoActivo().getCodigo());
			BeanUtils.copyProperty(activoDto, "estadoActivoDescripcion", activo.getEstadoActivo().getDescripcion());
			if(DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())){
				
				if(!Checks.esNulo(activo.getFechaUltCambioTipoActivo())) {
						Date fechaInicial=activo.getFechaUltCambioTipoActivo();
						Date fechaFinal=new Date();
						Integer dias=(int) ((fechaFinal.getTime()-fechaInicial.getTime())/86400000);
						activoDto.setDiasCambioEstadoActivo(dias);
				}
			}
		}
		
		if (activo.getTipoUsoDestino() != null) {
			BeanUtils.copyProperty(activoDto, "tipoUsoDestinoCodigo", activo.getTipoUsoDestino().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoUsoDestinoDescripcion", activo.getTipoUsoDestino().getDescripcion());
		}
		
		if (activo.getInfoComercial() != null && activo.getInfoComercial().getTipoInfoComercial() != null) {
			BeanUtils.copyProperty(activoDto, "tipoInfoComercialCodigo", activo.getInfoComercial().getTipoInfoComercial().getCodigo());
		}

		if(activo.getTipoComercializar() != null){
			BeanUtils.copyProperty(activoDto, "tipoComercializarCodigo", activo.getTipoComercializar().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoComercializarDescripcion", activo.getTipoComercializar().getDescripcion());
		}
		//Hace referencia a Destino Comercial (Si te lía el nombre, habla con Fernando)
		if(!Checks.esNulo(activo.getActivoPublicacion()) && !Checks.esNulo(activo.getActivoPublicacion().getTipoComercializacion())){
				BeanUtils.copyProperty(activoDto, "tipoComercializacionCodigo", activo.getActivoPublicacion().getTipoComercializacion().getCodigo());
				BeanUtils.copyProperty(activoDto, "tipoComercializacionDescripcion", activo.getActivoPublicacion().getTipoComercializacion().getDescripcion());
		}
		
		if(activo.getTipoAlquiler() != null){
			BeanUtils.copyProperty(activoDto, "tipoAlquilerCodigo", activo.getTipoAlquiler().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoAlquilerDescripcion", activo.getTipoAlquiler().getDescripcion());
		}
		
		//Hace referencia a Equipo gestion
		if(activo.getEquipoGestion() != null){
			BeanUtils.copyProperty(activoDto, "tipoEquipoGestionCodigo", activo.getEquipoGestion().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoEquipoGestionDescripcion", activo.getEquipoGestion().getDescripcion());
		}
		
		if(!activo.getAgrupaciones().isEmpty()) {
			Boolean pertenceAgrupacionRestringida = false;
			for(ActivoAgrupacionActivo agrupaciones: activo.getAgrupaciones()){
				if(Checks.esNulo(agrupaciones.getAgrupacion().getFechaBaja())) {
					if(!Checks.esNulo(agrupaciones.getAgrupacion().getTipoAgrupacion()) && DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(agrupaciones.getAgrupacion().getTipoAgrupacion().getCodigo())){
						pertenceAgrupacionRestringida = true;
						break;
					}
				}
			}

			Boolean perteneceAgrupacionRestringidaVigente = false;
			Date currentDate = new Date();
			for(ActivoAgrupacionActivo agrupaciones: activo.getAgrupaciones()){
				if(Checks.esNulo(agrupaciones.getAgrupacion().getFechaBaja())) {
					if(!Checks.esNulo(agrupaciones.getAgrupacion().getTipoAgrupacion())
							&& DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(agrupaciones.getAgrupacion().getTipoAgrupacion().getCodigo())
							&& (Checks.esNulo(agrupaciones.getAgrupacion().getFechaFinVigencia())
									|| (!Checks.esNulo(agrupaciones.getAgrupacion().getFechaFinVigencia())
											&& (agrupaciones.getAgrupacion().getFechaFinVigencia().before(currentDate)
											|| agrupaciones.getAgrupacion().getFechaFinVigencia().equals(currentDate))))
					){
						perteneceAgrupacionRestringidaVigente = true;
						if (!Checks.esNulo(agrupaciones.getAgrupacion().getActivoPrincipal())) {
							BeanUtils.copyProperty(activoDto, "activoPrincipalRestringida",
									agrupaciones.getAgrupacion().getActivoPrincipal().getNumActivo());
						}
						break;
					}
				}
			}
			Boolean pertenceAgrupacionComercial = false;
			for(ActivoAgrupacionActivo agrupaciones: activo.getAgrupaciones()){
				if(Checks.esNulo(agrupaciones.getAgrupacion().getFechaBaja())) {
					if(!Checks.esNulo(agrupaciones.getAgrupacion().getTipoAgrupacion()) && DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(agrupaciones.getAgrupacion().getTipoAgrupacion().getCodigo())){
						pertenceAgrupacionComercial = true;
						break;
					}
				}
			}
			Boolean pertenceAgrupacionAsistida = false;
			for(ActivoAgrupacionActivo agrupaciones: activo.getAgrupaciones()){
				if(Checks.esNulo(agrupaciones.getAgrupacion().getFechaBaja()) && !Checks.esNulo(agrupaciones.getAgrupacion().getTipoAgrupacion()) &&
						DDTipoAgrupacion.AGRUPACION_ASISTIDA.equals(agrupaciones.getAgrupacion().getTipoAgrupacion().getCodigo())) {
					pertenceAgrupacionAsistida = true;
					break;
				}
			}
			Boolean pertenceAgrupacionObraNueva = false;
			for(ActivoAgrupacionActivo agrupaciones: activo.getAgrupaciones()){
				if(Checks.esNulo(agrupaciones.getAgrupacion().getFechaBaja()) && !Checks.esNulo(agrupaciones.getAgrupacion().getTipoAgrupacion()) &&
						DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA.equals(agrupaciones.getAgrupacion().getTipoAgrupacion().getCodigo())) {
					pertenceAgrupacionObraNueva = true;
					break;
				}
			}

			Boolean pertenceAgrupacionProyecto = false;
			for(ActivoAgrupacionActivo agrupaciones: activo.getAgrupaciones()){
				if(Checks.esNulo(agrupaciones.getAgrupacion().getFechaBaja()) && !Checks.esNulo(agrupaciones.getAgrupacion().getTipoAgrupacion()) &&
						DDTipoAgrupacion.AGRUPACION_PROYECTO.equals(agrupaciones.getAgrupacion().getTipoAgrupacion().getCodigo())) {
					pertenceAgrupacionProyecto = true;
					break;
				}
			}
			
			BeanUtils.copyProperty(activoDto, "pertenceAgrupacionRestringida", pertenceAgrupacionRestringida);
			BeanUtils.copyProperty(activoDto, "perteneceAgrupacionRestringidaVigente", perteneceAgrupacionRestringidaVigente);
			BeanUtils.copyProperty(activoDto, "pertenceAgrupacionComercial", pertenceAgrupacionComercial);
			BeanUtils.copyProperty(activoDto, "pertenceAgrupacionAsistida", pertenceAgrupacionAsistida);
			BeanUtils.copyProperty(activoDto, "pertenceAgrupacionObraNueva", pertenceAgrupacionObraNueva);
			BeanUtils.copyProperty(activoDto, "pertenceAgrupacionProyecto", pertenceAgrupacionProyecto);
			
			if(pertenceAgrupacionProyecto && !Checks.esNulo(activo.getCartera()) && DDCartera.CODIGO_CARTERA_SAREB.equals(activo.getCartera().getCodigo())) {
				activoDto.setEsSarebProyecto(true);
			}else {
				activoDto.setEsSarebProyecto(false);
			}
		}

		for(ActivoAgrupacionActivo agrupaciones: activo.getAgrupaciones()){
			if(Checks.esNulo(agrupaciones.getAgrupacion().getFechaBaja()) && !Checks.esNulo(agrupaciones.getAgrupacion().getId())) {
				BeanUtils.copyProperty(activoDto,"idAgrupacion", agrupaciones.getAgrupacion().getId());
				break;
			}
		}

		BeanUtils.copyProperty(activoDto, "informeComercialAceptado", activoApi.isInformeComercialAceptado(activo));

		//Obtener si tiene posible informe mediador
		if (!Checks.esNulo(activo.getInfoComercial())) {
			if (!Checks.esNulo(activo.getInfoComercial().getPosibleInforme())){
				if (activo.getInfoComercial().getPosibleInforme() == 1){
					BeanUtils.copyProperty(activoDto, "tienePosibleInformeMediador", true);
				} else {
					BeanUtils.copyProperty(activoDto, "tienePosibleInformeMediador", false);
				}
			} else {
				BeanUtils.copyProperty(activoDto, "tienePosibleInformeMediador", true);
			}
		}
		else {
			BeanUtils.copyProperty(activoDto, "tienePosibleInformeMediador", true);
		}


		if(!Checks.esNulo(activo.getSituacionComercial())) {
			BeanUtils.copyProperty(activoDto, "situacionComercialCodigo", activo.getSituacionComercial().getCodigo());
			BeanUtils.copyProperty(activoDto, "situacionComercialDescripcion", activo.getSituacionComercial().getDescripcion());
		}

		// Perimetros ------------------		
		// Datos de perimetro del activo al Dto de datos basicos
		// - Puede no existir registro de perimetros en la tabla. Esto no producira errores de carga/guardado
		// - En caso de no haber registro relacionado con el activo, no se habilitaran validaciones/bloqueos 
		//   relacionados con el perimetro.
		// - Aunque no haya registro de perimetros, en estos activos aparecerán todos los checks activos de la pantalla
		//   de datos basicos (para indicar que se incluyen todos los modulos del activo y no hay bloqueos)
		PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activo.getId());
		BeanUtils.copyProperties(activoDto, perimetroActivo);
		
		// Si no esta en el perimetro, el activo se considera SOLO CONSULTA
		BeanUtils.copyProperty(activoDto, "incluidoEnPerimetro", perimetroActivo.getIncluidoEnPerimetro() == 1);
		
		if(!Checks.esNulo(activo.getAuditoria()) && !Checks.esNulo(activo.getAuditoria().getFechaCrear())) {
			BeanUtils.copyProperty(activoDto, "fechaAltaActivoRem", activo.getAuditoria().getFechaCrear());
		}
		
		if(!Checks.esNulo(perimetroActivo) && !Checks.esNulo(perimetroActivo.getMotivoAplicaComercializar())) {
			BeanUtils.copyProperty(activoDto, "motivoAplicaComercializarCodigo", perimetroActivo.getMotivoAplicaComercializar().getCodigo());
			BeanUtils.copyProperty(activoDto, "motivoAplicaComercializarDescripcion", perimetroActivo.getMotivoAplicaComercializar().getDescripcion());
		}
		
		if(!Checks.esNulo(perimetroActivo) && !Checks.esNulo(perimetroActivo.getMotivoNoAplicaComercializar())) {
			BeanUtils.copyProperty(activoDto, "motivoNoAplicaComercializar", perimetroActivo.getMotivoNoAplicaComercializar());
		}
		if(!Checks.esNulo(perimetroActivo) && !Checks.esNulo(perimetroActivo.getMotivoGestionComercial())) {
			BeanUtils.copyProperty(activoDto, "motivoGestionComercialCodigo", perimetroActivo.getMotivoGestionComercial().getCodigo());
			BeanUtils.copyProperty(activoDto, "motivoGestionComercialDescripcion", perimetroActivo.getMotivoGestionComercial().getDescripcion());
		}
		
		// Si no exite perimetro en BBDD, se crea una nueva instancia PerimetroActivo, con todas las condiciones marcadas
		// y por tanto, por defecto se marcan los checkbox.
		
		BeanUtils.copyProperty(activoDto,"aplicaTramiteAdmision", new Integer(1).equals( perimetroActivo.getAplicaTramiteAdmision())? true: false);
		
		BeanUtils.copyProperty(activoDto,"aplicaGestion", new Integer(1).equals( perimetroActivo.getAplicaGestion())? true: false);
		BeanUtils.copyProperty(activoDto,"aplicaAsignarMediador", new Integer(1).equals(perimetroActivo.getAplicaAsignarMediador())? true: false);

		if(!Checks.esNulo(perimetroActivo.getAplicaComercializar())) {
			BeanUtils.copyProperty(activoDto,"aplicaComercializar", new Integer(1).equals(perimetroActivo.getAplicaComercializar())? true: false);
		}
		
		BeanUtils.copyProperty(activoDto,"aplicaFormalizar", new Integer(1).equals(perimetroActivo.getAplicaFormalizar())? true: false);
		BeanUtils.copyProperty(activoDto,"enTramite", activo.getEnTramite());
		
		
		if(!Checks.esNulo(perimetroActivo.getAplicaPublicar()))
			BeanUtils.copyProperty(activoDto,"aplicaPublicar", new Integer(1).equals(perimetroActivo.getAplicaPublicar() ? 1 : 0));
		
		if(perimetroActivo.getCheckGestorComercial() != null) {
			BeanUtils.copyProperty(activoDto,"checkGestorComercial", new Integer(1).equals(perimetroActivo.getCheckGestorComercial() ? 1 : 0));
		}
		
		
		DDSiNo si = genericDao.get(DDSiNo.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDSiNo.SI));
		DDSiNo no = genericDao.get(DDSiNo.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDSiNo.NO));
		
		if(!Checks.esNulo(perimetroActivo.getOfertasVivas())) {
			
			if( perimetroActivo.getOfertasVivas()) {
				BeanUtils.copyProperty(activoDto, "ofertasVivas",si.getDescripcion());
			}
			else {
				BeanUtils.copyProperty(activoDto, "ofertasVivas", no.getDescripcion());
			}
		}
		if(!Checks.esNulo(perimetroActivo.getTrabajosVivos())) {
			if(perimetroActivo.getTrabajosVivos())
				
				BeanUtils.copyProperty(activoDto, "trabajosVivos",si.getDescripcion());
			else {
				BeanUtils.copyProperty(activoDto, "trabajosVivos", no.getDescripcion());
			}
		}

		// Indicador del estado de publicación para venta y alquiler.
		activoDto.setEstadoVenta(activoEstadoPublicacionApi.getEstadoIndicadorPublicacionVenta(activo));
		activoDto.setEstadoAlquiler(activoEstadoPublicacionApi.getEstadoIndicadorPublicacionAlquiler(activo));

		// Datos de activo bancario del activo al Dto de datos basicos
		boolean esUA = activoDao.isUnidadAlquilable(activo);
		ActivoBancario activoBancario = activoApi.getActivoBancarioByIdActivo(activo.getId());
		
		if(esUA) {
			//Cuando es una UA, cargamos los datos de su AM
			ActivoAgrupacion agrupacion = activoDao.getAgrupacionPAByIdActivo(activo.getId());
			if (!Checks.esNulo(agrupacion)) {
				Activo activoMatriz = activoAgrupacionActivoDao.getActivoMatrizByIdAgrupacion(agrupacion.getId());
				if (!Checks.esNulo(activoMatriz)) {
					activoBancario = activoApi.getActivoBancarioByIdActivo(activoMatriz.getId());
				}
			}
		}
		
		if(!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getClaseActivo())) {
			BeanUtils.copyProperty(activoDto, "claseActivoCodigo", activoBancario.getClaseActivo().getCodigo());
			BeanUtils.copyProperty(activoDto, "claseActivoDescripcion", activoBancario.getClaseActivo().getDescripcion());
		}
		
		if(!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getSubtipoClaseActivo())) {
			BeanUtils.copyProperty(activoDto, "subtipoClaseActivoCodigo", activoBancario.getSubtipoClaseActivo().getCodigo());
			BeanUtils.copyProperty(activoDto, "subtipoClaseActivoDescripcion", activoBancario.getSubtipoClaseActivo().getDescripcion());
		}

		//Como no envian el diccionario de tipoProducto, lo hemos sustituido por texto libre
		if(!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getProductoDescripcion())) {
			BeanUtils.copyProperty(activoDto, "productoDescripcion", activoBancario.getProductoDescripcion());
		}

		if(!Checks.esNulo(activoBancario)) {
			BeanUtils.copyProperty(activoDto, "numExpRiesgo", activoBancario.getNumExpRiesgo());
		}

		if(!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getEstadoExpRiesgo())) {
			BeanUtils.copyProperty(activoDto, "estadoExpRiesgoCodigo", activoBancario.getEstadoExpRiesgo().getCodigo());
			BeanUtils.copyProperty(activoDto, "estadoExpRiesgoDescripcion", activoBancario.getEstadoExpRiesgo().getDescripcion());
		}

		if(!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getEstadoExpIncorriente())) {
			BeanUtils.copyProperty(activoDto, "estadoExpIncorrienteCodigo", activoBancario.getEstadoExpIncorriente().getCodigo());
			BeanUtils.copyProperty(activoDto, "estadoExpIncorrienteDescripcion", activoBancario.getEstadoExpIncorriente().getDescripcion());
		}
		
		if (activoBancario != null && activoBancario.getCategoriaComercializacion() != null) {
			activoDto.setCategoriaComercializacionCod(activoBancario.getCategoriaComercializacion().getCodigo());
			activoDto.setCategoriaComercializacionDesc(activoBancario.getCategoriaComercializacion().getDescripcion());
		}

		// En la sección de activo bancario pero no dependiente del mismo.
		if(!Checks.esNulo(activo.getEntradaActivoBankia())) {
			BeanUtils.copyProperty(activoDto, "entradaActivoBankiaCodigo", activo.getEntradaActivoBankia().getCodigo());
			BeanUtils.copyProperty(activoDto, "entradaActivoBankiaDescripcion", activo.getEntradaActivoBankia().getDescripcion());
		}

		BeanUtils.copyProperty(activoDto, "integradoEnAgrupacionAsistida",activoApi.isIntegradoAgrupacionAsistida(activo));
		
		//Tipo de activo segun el Mediador
		if(!Checks.esNulo(activo.getInfoComercial()) && !Checks.esNulo(activo.getInfoComercial().getTipoActivo())) {
			BeanUtils.copyProperty(activoDto, "tipoActivoMediadorCodigo", activo.getInfoComercial().getTipoActivo().getCodigo());
		}
		
		if(!Checks.esNulo(activo.getGestorSelloCalidad())){
			BeanUtils.copyProperty(activoDto, "nombreGestorSelloCalidad", activo.getGestorSelloCalidad().getApellidoNombre());
		}

		List<VPreciosVigentes> listaPrecios = activoApi.getPreciosVigentesById(activo.getId());
		for (VPreciosVigentes listaPrecio : listaPrecios) {
			if (listaPrecio.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO)) {
				BeanUtils.copyProperty(activoDto, "minimoAutorizado", listaPrecio.getImporte());
			} else if (listaPrecio.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA)) {
				BeanUtils.copyProperty(activoDto, "aprobadoVentaWeb", listaPrecio.getImporte());
			} else if (listaPrecio.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA)) {
				BeanUtils.copyProperty(activoDto, "aprobadoRentaWeb", listaPrecio.getImporte());
			} else if (listaPrecio.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_DESC_APROBADO)) {
				BeanUtils.copyProperty(activoDto, "descuentoAprobado", listaPrecio.getImporte());
			} else if (listaPrecio.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_DESC_PUBLICADO)) {
				BeanUtils.copyProperty(activoDto, "descuentoPublicado", listaPrecio.getImporte());
			} else if (listaPrecio.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT)) {
				BeanUtils.copyProperty(activoDto, "valorNetoContable", listaPrecio.getImporte());
			} else if (listaPrecio.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_COSTE_ADQUISICION)) {
				BeanUtils.copyProperty(activoDto, "costeAdquisicion", listaPrecio.getImporte());
			}
		}
		
		if (DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())) {
			List<VPreciosVigentesCaixa> listaPreciosCaixa = activoApi.getPreciosVigentesCaixaById(activo.getId());
			for (VPreciosVigentesCaixa vPreciosVigentesCaixa : listaPreciosCaixa) {
				if (vPreciosVigentesCaixa.getCodigoTipoPrecioCaixa().equals(DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA)) {
					BeanUtils.copyProperty(activoDto, "aprobadoVentaWeb", vPreciosVigentesCaixa.getImporteCaixa());
				} else if (vPreciosVigentesCaixa.getCodigoTipoPrecioCaixa().equals(DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA)) {
					BeanUtils.copyProperty(activoDto, "aprobadoRentaWeb", vPreciosVigentesCaixa.getImporteCaixa());
				} else if (vPreciosVigentesCaixa.getCodigoTipoPrecioCaixa().equals(DDTipoPrecio.CODIGO_TPC_DESC_APROBADO)) {
					BeanUtils.copyProperty(activoDto, "descuentoAprobado", vPreciosVigentesCaixa.getImporteCaixa());
				} else if (vPreciosVigentesCaixa.getCodigoTipoPrecioCaixa().equals(DDTipoPrecio.CODIGO_TPC_DESC_PUBLICADO)) {
					BeanUtils.copyProperty(activoDto, "descuentoPublicado", vPreciosVigentesCaixa.getImporteCaixa());
				} else if (vPreciosVigentesCaixa.getCodigoTipoPrecioCaixa().equals(DDTipoPrecio.CODIGO_TPC_DES_APR_ALQ)) {
					BeanUtils.copyProperty(activoDto, "descuentoAprobadoAlquiler", vPreciosVigentesCaixa.getImporteCaixa());
				} else if (vPreciosVigentesCaixa.getCodigoTipoPrecioCaixa().equals(DDTipoPrecio.CODIGO_TPC_DES_PUB_ALQ)) {
					BeanUtils.copyProperty(activoDto, "descuentoPublicadoAlquiler", vPreciosVigentesCaixa.getImporteCaixa());
				} 
			}
		}

		if(!Checks.esNulo(activo.getTasacion()) && !activo.getTasacion().isEmpty()){
			//ActivoTasacion tasacionMasReciente = activo.getTasacion().get(0);
			ActivoTasacion tasacionMasReciente = activoApi.getTasacionMasReciente(activo);
			BeanUtils.copyProperty(activoDto, "valorUltimaTasacion", tasacionMasReciente.getImporteTasacionFin());
		}

		if(!Checks.esNulo(activo.getCodigoPromocionPrinex())) {
			BeanUtils.copyProperty(activoDto, "codigoPromocionPrinex", activo.getCodigoPromocionPrinex());
		}

		if(!Checks.esNulo(activo.getActivoBNK()) && !Checks.esNulo(activo.getActivoBNK().getAcbCoreaeTexto())){
			BeanUtils.copyProperty(activoDto, "acbCoreaeTexto", activo.getActivoBNK().getAcbCoreaeTexto());
		}

		if(!Checks.esNulo(activo.getActivoPublicacion())){
			BeanUtils.copyProperty(activoDto, "estadoAlquilerDescripcion", !Checks.esNulo(activo.getActivoPublicacion().getEstadoPublicacionAlquiler()) ? activo.getActivoPublicacion().getEstadoPublicacionAlquiler().getDescripcion() : "");
			BeanUtils.copyProperty(activoDto, "estadoVentaDescripcion", !Checks.esNulo(activo.getActivoPublicacion().getEstadoPublicacionVenta()) ? activo.getActivoPublicacion().getEstadoPublicacionVenta().getDescripcion(): "");
			BeanUtils.copyProperty(activoDto, "estadoAlquilerCodigo", !Checks.esNulo(activo.getActivoPublicacion().getEstadoPublicacionAlquiler()) ? activo.getActivoPublicacion().getEstadoPublicacionAlquiler().getCodigo() : "");
			BeanUtils.copyProperty(activoDto, "estadoVentaCodigo", !Checks.esNulo(activo.getActivoPublicacion().getEstadoPublicacionVenta()) ? activo.getActivoPublicacion().getEstadoPublicacionVenta().getCodigo(): "");
		}
		
		if(!Checks.esNulo(activo) && activoDao.isActivoMatriz(activo.getId())) {	
			activoDto.setCamposPropagablesUas(TabActivoService.TAB_DATOS_BASICOS);
		}else {
			// Buscamos los campos que pueden ser propagados para esta pestaña
			activoDto.setCamposPropagables(TabActivoService.TAB_DATOS_BASICOS);
		}
		
		if (!Checks.esNulo(activo.getSituacionPosesoria()) && !Checks.esNulo(activo.getSituacionPosesoria().getOcupado())) {
			activoDto.setOcupado(activo.getSituacionPosesoria().getOcupado());
		} else {
			activoDto.setOcupado(0);
		}

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		List<DtoListadoGestores> listaGestores = adapter.getGestoresActivos(activo.getId());
		for(DtoListadoGestores gestor : listaGestores){
			if(usuarioLogado.getId().equals(gestor.getIdUsuario())
					&& (GestorActivoApi.CODIGO_GESTOR_ALQUILERES.equals(gestor.getCodigo())
					|| GestorActivoApi.CODIGO_SUPERVISOR_ALQUILERES.equals(gestor.getCodigo())
					|| GestorActivoApi.CODIGO_GESTOR_COMERCIAL_ALQUILERES.equals(gestor.getCodigo())
					|| GestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_ALQUILERES.equals(gestor.getCodigo()))) {
				BeanUtils.copyProperty(activoDto, "esGestorAlquiler", true);
				break;
			}
		}

		ActivoPatrimonio activoP = activoPatrimonioDao.getActivoPatrimonioByActivo(activo.getId());
		if(!Checks.esNulo(activoP)) {
			if (!Checks.esNulo(activoP.getTipoEstadoAlquiler())) {
				activoDto.setTipoEstadoAlquiler(activoP.getTipoEstadoAlquiler().getCodigo());

			}

			if(!Checks.esNulo(activoP.getCheckHPM())) {
				BeanUtils.copyProperty(activoDto, "activoChkPerimetroAlquiler", activoP.getCheckHPM());
			}

			if(!Checks.esNulo(activoP.getTipoInquilino())) {
				activoDto.setTipoInquilino(activoP.getTipoInquilino().getCodigo());
			}
		}
		
		boolean tieneOfertaAlquilerViva = false;
		
		//Cambiamos la forma de obtener si una oferta esta viva, de comprobar si el estado de la oferta es 
		//Aceptado/tramitada a comprobar si una oferta tiene tareas activas, si tiene alguna tarea activa,
		//la oferta estara viva, si por el contrario, tiene todas las tareas finalizadas la oferta no estara viva
		List<TareaActivo> listaTareas = tareaActivoApi.getTareasActivo(activo.getId(),ActivoTramiteApi.CODIGO_TRAMITE_COMERCIAL_ALQUILER);
		if (!Checks.estaVacio(listaTareas)) {
			for (TareaActivo tarea : listaTareas) {
				if (!Checks.esNulo(tarea.getTareaFinalizada()) && !tarea.getTareaFinalizada()) {
					tieneOfertaAlquilerViva = true;
					break;
				}
			}
		}
		
		
		BeanUtils.copyProperty(activoDto, "tieneOfertaAlquilerViva", tieneOfertaAlquilerViva);

		Usuario gestorComercial = gestorActivoApi.getGestorComercialActual(activo, "GCOM");
		Usuario supervisorComercial = gestorActivoApi.getGestorComercialActual(activo, "SCOM");
		if(usuarioLogado.equals(gestorComercial) || usuarioLogado.equals(supervisorComercial) || genericAdapter.isSuper(usuarioLogado)) {
			activoDto.setIsLogUsuGestComerSupComerSupAdmin(true);
		}else{
			activoDto.setIsLogUsuGestComerSupComerSupAdmin(false);
		}
		
		//HREOS-4836 (GENCAT)
		Boolean afectoAGencat = false;
		if (!Checks.esNulo(activo)) {
			afectoAGencat = activoApi.isAfectoGencat(activo);
		}
		activoDto.setAfectoAGencat(afectoAGencat);
		
		Boolean tieneComunicacionGencat = false;
		if(afectoAGencat){
			tieneComunicacionGencat = activoApi.tieneComunicacionGencat(activo);
		}
		activoDto.setTieneComunicacionGencat(tieneComunicacionGencat);
	
		List<VAdmisionDocumentos> admisionDocumentos = adapter.getListAdmisionCheckDocumentos(activo.getId());
		
		for (VAdmisionDocumentos doc : admisionDocumentos) {
			if ("CEE (Certificado de eficiencia energética)".equals(doc.getDescripcionTipoDoc()) 
					&& doc.getAplica() != null && doc.getAplica().equals("1")) {
				BeanUtils.copyProperty(activoDto, "tieneCEE", true);
				break;
			}
		}
		
		if (!Checks.esNulo(activo)) {
			ActivoAgrupacionActivo aga = activoDao.getActivoAgrupacionActivoPA(activo.getId());			
			
			if (!Checks.esNulo(aga)) {				
				boolean isActivoMatriz = aga.getPrincipal() == 1;			
				activoDto.setUnidadAlquilable(!isActivoMatriz);
				activoDto.setIsPANoDadaDeBaja(true);
				
				if (isActivoMatriz) {				
					activoDto.setActivoMatriz(true);
					activoDto.setAgrupacionDadaDeBaja(false);
					activoDto.setUnidadesAlquilablesEnAgrupacion(aga.getAgrupacion().getActivos().size()-1L);
				}else {
					activoDto.setPorcentajeParticipacion(aga.getParticipacionUA());
					activoDto.setIdPrinexHPM(aga.getIdPrinexHPM());
					
					Long idAM = activoDao.getIdActivoMatriz(aga.getAgrupacion().getId());
					Activo activoMatriz = activoApi.get(idAM);
					if (!Checks.esNulo(activoMatriz)) {
						activoDto.setNumActivoMatriz(activoMatriz.getNumActivo());
					}
					
					activoDto.setUnidadAlquilable(!isActivoMatriz);
				}
				activoApi.bloquearChecksComercializacionActivo(aga, activoDto);
			}	
		}
		
		Boolean tieneRegistro = false;
		List<ActivoPatrimonioContrato> listActivoPatrimonioContrato = activoPatrimonioContratoDao.getActivoPatrimonioContratoByActivo(activo.getId());
		if(!Checks.estaVacio(listActivoPatrimonioContrato)) {
			tieneRegistro = true;
		} 
		activoDto.setTieneRegistroContrato(tieneRegistro);
		
		//HREOS-5779
		
		if(DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())) {
		
			Boolean cambioEstadoPublicacion = Boolean.FALSE;
			Boolean cambioEstadoPrecio = Boolean.FALSE;
			Boolean cambioEstadoActivo = Boolean.FALSE; 

			if((activo.getSituacionPosesoria() != null && !Checks.esNulo(activo.getSituacionPosesoria().getFechaUltCambioPos()) && calculodiasCambiosActivo(activo.getSituacionPosesoria().getFechaUltCambioPos()))
					|| (!Checks.esNulo(activo.getSituacionPosesoria().getFechaUltCambioTit()) && calculodiasCambiosActivo(activo.getSituacionPosesoria().getFechaUltCambioTit()))
					|| (!Checks.esNulo(activo.getSituacionPosesoria().getFechaUltCambioTapiado()) && calculodiasCambiosActivo(activo.getSituacionPosesoria().getFechaUltCambioTapiado()))
					|| (!Checks.esNulo(activo.getFechaUltCambioTipoActivo()) && calculodiasCambiosActivo(activo.getFechaUltCambioTipoActivo()))	
							) {
				cambioEstadoActivo = Boolean.TRUE;
	
			}

			
			if((activo.getActivoPublicacion() != null && !Checks.esNulo(activo.getActivoPublicacion().getFechaCambioPubAlq())&& calculodiasCambiosActivo(activo.getActivoPublicacion().getFechaCambioPubAlq()))) {
				if((!Checks.esNulo(activo.getActivoPublicacion().getEstadoPublicacionAlquiler()) && (!activo.getActivoPublicacion().getEstadoPublicacionAlquiler().getCodigo().equals(DDEstadoPublicacionAlquiler.CODIGO_PRE_PUBLICADO_ALQUILER)))	
						){
					cambioEstadoPublicacion = Boolean.TRUE;
				}
			}
			
			
			if((activo.getActivoPublicacion() != null && !Checks.esNulo(activo.getActivoPublicacion().getFechaCambioPubVenta()) && calculodiasCambiosActivo(activo.getActivoPublicacion().getFechaCambioPubVenta()))) {
				if((!Checks.esNulo(activo.getActivoPublicacion().getEstadoPublicacionVenta()) && (!activo.getActivoPublicacion().getEstadoPublicacionVenta().getCodigo().equals(DDEstadoPublicacionVenta.CODIGO_PRE_PUBLICADO_VENTA)))	
						){
					cambioEstadoPublicacion = Boolean.TRUE;
				}
			}
			

			if(((activo.getActivoPublicacion() != null &&  !Checks.esNulo(activo.getActivoPublicacion().getFechaCambioValorVenta())) && calculodiasCambiosActivo(activo.getActivoPublicacion().getFechaCambioValorVenta()))
				||	((activo.getActivoPublicacion() != null && !Checks.esNulo(activo.getActivoPublicacion().getFechaCambioValorAlq())) && calculodiasCambiosActivo(activo.getActivoPublicacion().getFechaCambioValorAlq()))
					) {
						cambioEstadoPrecio = Boolean.TRUE;
			}	
			
			
			activoDto.setCambioEstadoActivo(cambioEstadoActivo);
			activoDto.setCambioEstadoPrecio(cambioEstadoPrecio);
			activoDto.setCambioEstadoPublicacion(cambioEstadoPublicacion);
			
		}
		
		if (activo.getOfertas() != null) {
			BeanUtils.copyProperty(activoDto, "ofertasTotal", new Long(activo.getOfertas().size()));
		}else {
			BeanUtils.copyProperty(activoDto, "ofertasTotal",new Long(0));
		}
		if (activo.getVisitas() != null) {
			BeanUtils.copyProperty(activoDto, "visitasTotal", new Long(activo.getVisitas().size()));
		} else {
			BeanUtils.copyProperty(activoDto, "visitasTotal", new Long(0));
		}
		
		if(activo.getCesionSaneamiento() != null) {
			BeanUtils.copyProperty(activoDto, "cesionSaneamientoCodigo", activo.getCesionSaneamiento().getCodigo());
			BeanUtils.copyProperty(activoDto, "cesionSaneamientoDescripcion", activo.getCesionSaneamiento().getDescripcion());
		}
		
		if(activo.getServicerActivo() != null) {
			BeanUtils.copyProperty(activoDto, "servicerActivoCodigo", activo.getServicerActivo().getCodigo());
			BeanUtils.copyProperty(activoDto, "servicerActivoDescripcion", activo.getServicerActivo().getDescripcion());
		}
			
		if (!Checks.esNulo(activo.getSociedadDePagoAnterior())) {
			BeanUtils.copyProperty(activoDto, "sociedadPagoAnterior", activo.getSociedadDePagoAnterior().getCodigo());
			BeanUtils.copyProperty(activoDto, "sociedadPagoAnteriorDescripcion", activo.getSociedadDePagoAnterior().getDescripcion());
		}
		
		if (activo.getCartera() != null
				&& DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())) {
			BeanUtils.copyProperty(activoDto, "tramitable", isTramitable(activo));
		}
		
		Boolean muestraEditarFasePublicacion = activoApi.getMostrarEdicionTabFasesPublicacion(activo);
		
		activoDto.setMostrarEditarFasePublicacion(muestraEditarFasePublicacion);
		
		
		Filter idFiltro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		Filter borradoFiltro = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		ActivoPatrimonioContrato apc = genericDao.get(ActivoPatrimonioContrato.class, idFiltro, borradoFiltro);
		
		if(apc != null) {
			activoDto.setPazSocial(apc.getPazSocial());
		}
		
		if(activoP != null && activoP.getTramiteAlquilerSocial() != null) {
			activoDto.setCheckFormalizarReadOnly(activoP.getTramiteAlquilerSocial());
			activoDto.setCheckComercializarReadOnly(activoP.getTramiteAlquilerSocial());
			activoDto.setCheckPublicacionReadOnly(activoP.getTramiteAlquilerSocial());

		}else {
			activoDto.setCheckFormalizarReadOnly(false);
			activoDto.setCheckComercializarReadOnly(false);
			activoDto.setCheckPublicacionReadOnly(false);
		}
		
		if(activo.getTipoSegmento() != null) {
			activoDto.setTipoSegmentoCodigo(activo.getTipoSegmento().getCodigo());
			activoDto.setTipoSegmentoDescripcion(activo.getTipoSegmento().getDescripcion());
		}
		
		ActivoAdmisionRevisionTitulo actRevTitulo = genericDao.get(ActivoAdmisionRevisionTitulo.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
		boolean perimetroAdmision = false;
		if(perimetroActivo.getAplicaAdmision() != null) {
			perimetroAdmision = perimetroActivo.getAplicaAdmision();
			activoDto.setPerimetroAdmision(perimetroAdmision);
		}
		
		DDEstadoRegistralActivo ddEstadoReg = null;
		if (!Checks.esNulo(activo.getEstadoRegistral())) {
			activoDto.setEstadoRegistralCodigo(activo.getEstadoRegistral().getCodigo());
			activoDto.setEstadoRegistralDescripcion(activo.getEstadoRegistral().getDescripcion());
		} else if (perimetroAdmision && actRevTitulo != null && actRevTitulo.getTipoIncidenciaRegistral() != null) {
			ddEstadoReg = genericDao.get(DDEstadoRegistralActivo.class, genericDao.createFilter(FilterType.EQUALS ,"descripcion", actRevTitulo.getTipoIncidenciaRegistral().getDescripcion()));
		} else if (perimetroAdmision && actRevTitulo != null && actRevTitulo.getSituacionConstructivaRegistral() != null) {
			ddEstadoReg = genericDao.get(DDEstadoRegistralActivo.class, genericDao.createFilter(FilterType.EQUALS ,"descripcion", actRevTitulo.getSituacionConstructivaRegistral().getDescripcion()));
		}
		
		if(ddEstadoReg != null) {
			activoDto.setEstadoRegistralCodigo(ddEstadoReg.getCodigo());	
			activoDto.setEstadoRegistralDescripcion(ddEstadoReg.getDescripcion());
		}
		
		Double porcentajeContruccion = activo.getPorcentajeConstruccion();
		activoDto.setPorcentajeConstruccion(porcentajeContruccion);
		activoDto.setIsUA(activoDao.isUnidadAlquilable(activo.getId()));
		
		List<Perfil> perfilesUser = usuarioLogado.getPerfiles();
		
		boolean puedeEditarPorcentaje = false;
		
		if(activoDto.getIsUA() != null && !activoDto.getIsUA() && perimetroActivo.getIncluidoEnPerimetro() == 1) {
			activoDto.setIsEditablePorcentajeConstruccion(true);
		}else {
			activoDto.setIsEditablePorcentajeConstruccion(false);
		}
		
		
		activoDto.setIsUA(activoDao.isUnidadAlquilable(activo.getId()));
		
		Filter filtroActivoSareb = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoSareb activoSareb = genericDao.get(ActivoSareb.class, filtroActivoSareb);
		
		if (activoSareb != null ) {
			if (activoSareb.getSubtipoActivoOE() != null) {
				BeanUtils.copyProperty(activoDto, "tipoActivoCodigoOE", activoSareb.getTipoActivoOE().getCodigo());	
				BeanUtils.copyProperty(activoDto, "tipoActivoDescripcionOE", activoSareb.getTipoActivoOE().getDescripcion());	
			}
			if (activoSareb.getSubtipoActivoOE() != null) {
				BeanUtils.copyProperty(activoDto, "subtipoActivoCodigoOE", activoSareb.getSubtipoActivoOE().getCodigo());	
				BeanUtils.copyProperty(activoDto, "subtipoActivoDescripcionOE", activoSareb.getSubtipoActivoOE().getDescripcion());	
			}
			if (activoSareb.getTipoViaOE() != null) {
				BeanUtils.copyProperty(activoDto, "tipoViaCodigoOE", activoSareb.getTipoViaOE().getCodigo());	
				BeanUtils.copyProperty(activoDto, "tipoViaDescripcionOE", activoSareb.getTipoViaOE().getDescripcion());
			}
			
			if (activoSareb.getProvinciaOE() != null) {
				BeanUtils.copyProperty(activoDto, "provinciaCodigoOE", activoSareb.getProvinciaOE().getCodigo());	
				BeanUtils.copyProperty(activoDto, "provinciaDescripcionOE", activoSareb.getProvinciaOE().getDescripcion());
			}
			
			if (activoSareb.getLocalidadOE() != null) {
				BeanUtils.copyProperty(activoDto, "municipioCodigoOE", activoSareb.getLocalidadOE().getCodigo());	
				BeanUtils.copyProperty(activoDto, "municipioDescripcionOE", activoSareb.getLocalidadOE().getDescripcion());
			}
			
			if (activoSareb.getNombreViaOE() != null) {
				BeanUtils.copyProperty(activoDto, "nombreViaOE", activoSareb.getNombreViaOE());
			}
			
			if (activoSareb.getNumeroDomicilioOE() != null) {
				BeanUtils.copyProperty(activoDto, "numeroDomicilioOE", activoSareb.getNumeroDomicilioOE());
			}
			
			if (activoSareb.getEscaleraOE() != null) {
				BeanUtils.copyProperty(activoDto, "escaleraOE", activoSareb.getEscaleraOE());
			}
			
			if (activoSareb.getPisoOE() != null) {
				BeanUtils.copyProperty(activoDto, "pisoOE", activoSareb.getPisoOE());
			}
			
			if (activoSareb.getPuertaOE() != null) {
				BeanUtils.copyProperty(activoDto, "puertaOE", activoSareb.getPuertaOE());
			}
			
			if (activoSareb.getCodPostalOE() != null) {
				BeanUtils.copyProperty(activoDto, "codPostalOE", activoSareb.getCodPostalOE());
			}
			
			if (activoSareb.getLatitudOE() != null) {
				BeanUtils.copyProperty(activoDto, "latitudOE", activoSareb.getLatitudOE());
			}
			
			if (activoSareb.getLongitudOE() != null) {
				BeanUtils.copyProperty(activoDto, "longitudOE", activoSareb.getLongitudOE());
			}
			
			if (activoSareb.getFechaFinPrevistaAdecuacion() != null) {
				BeanUtils.copyProperty(activoDto, "fechaFinPrevistaAdecuacion", activoSareb.getFechaFinPrevistaAdecuacion());
			}
			
			if (activoSareb.getEstadoAdecuacionSareb() != null) {
				BeanUtils.copyProperty(activoDto, "estadoAdecuacionSarebCodigo", activoSareb.getEstadoAdecuacionSareb().getCodigo());	
				BeanUtils.copyProperty(activoDto, "estadoAdecuacionSarebDescripcion", activoSareb.getEstadoAdecuacionSareb().getDescripcion());
			}
			
			if (activoSareb != null && activoSareb.getReoContabilizado() != null) {
				if (DDSinSiNo.CODIGO_SI.equals(activoSareb.getReoContabilizado().getCodigo())) {
					activoDto.setReoContabilizadoSap(true);
				} else {
					activoDto.setReoContabilizadoSap(false);
				}
			}
		}
		

		if(perimetroActivo.getAplicaAdmision() != null) {
			activoDto.setPerimetroAdmision(perimetroActivo.getAplicaAdmision());
		}
			
		if(perimetroActivo.getFechaAplicaAdmision() != null) {
			activoDto.setFechaPerimetroAdmision(perimetroActivo.getFechaAplicaAdmision().toString());
		}
		if(perimetroActivo.getMotivoAplicaAdmision() != null) {
			activoDto.setMotivoPerimetroAdmision(perimetroActivo.getMotivoAplicaAdmision());
		}
		
		activoDto.setIncluidoEnPerimetroAdmision(perimetroActivo.getAplicaAdmision());
		
		if(activo.getEstadoAdmision() != null) {
			activoDto.setEstadoAdmisionCodigo(activo.getEstadoAdmision().getCodigo());
			activoDto.setEstadoAdmisionDesc(activo.getEstadoAdmision().getDescripcion());
		}
		if (activo.getSubestadoAdmision() != null) {
			activoDto.setSubestadoAdmisionCodigo(activo.getSubestadoAdmision().getCodigo());
			activoDto.setSubestadoAdmisionDesc(activo.getSubestadoAdmision().getDescripcion());
		}
		
		if(perimetroActivo.getAplicaAdmision() == null || (perimetroActivo.getAplicaAdmision() != null && !perimetroActivo.getAplicaAdmision())) {
			
			BeanUtils.copyProperty(activoDto, "estadoAdmisionDescCabecera", messageServices.getMessage(NO_GESTIONADO_POR_ADMISION));
			
		}else if (perimetroActivo.getAplicaAdmision() != null && perimetroActivo.getAplicaAdmision()){
			
			if(activo.getEstadoAdmision() != null) {
				BeanUtils.copyProperty(activoDto, "estadoAdmisionCodCabecera", activo.getEstadoAdmision().getCodigo());
				BeanUtils.copyProperty(activoDto, "estadoAdmisionDescCabecera", activo.getEstadoAdmision().getDescripcion());
			}
			
			if(activo.getSubestadoAdmision() != null) {
				BeanUtils.copyProperty(activoDto, "subestadoAdmisionCodCabecera", activo.getSubestadoAdmision().getCodigo());
				BeanUtils.copyProperty(activoDto, "subestadoAdmisionDescCabecera", activo.getSubestadoAdmision().getDescripcion());
			}
		}

		ActivoAdmisionRevisionTitulo activoAdmisionRevisionTitulo = genericDao.get(ActivoAdmisionRevisionTitulo.class, genericDao.createFilter(FilterType.EQUALS,  "activo.id", activo.getId()));
		String codigoHayaSuper = "HAYASUPER";
		String codigoGestorAdmision = "HAYAGESTADM";
		List<Perfil> perfilesUsuarioLogado = usuarioLogado.getPerfiles();
		boolean esUsuarioConPermisos = false;
		boolean revision = false;
		
		for(Perfil pef : perfilesUsuarioLogado){
			if(codigoHayaSuper.equals(pef.getCodigo()) || codigoGestorAdmision.equals(pef.getCodigo())) {
				esUsuarioConPermisos = true;
				break;
			}				
		}
			
		if(!Checks.esNulo(activoAdmisionRevisionTitulo) && !Checks.esNulo(activoAdmisionRevisionTitulo.getRevisado())) {
			revision = DDSinSiNo.CODIGO_SI.equals(activoAdmisionRevisionTitulo.getRevisado().getCodigo());	
		}
			
		boolean puedeEditar = (esUsuarioConPermisos && (!perimetroAdmision || (perimetroAdmision && revision)));
		activoDto.setEsEditableActivoEstadoRegistral(puedeEditar);
		
		if(perimetroActivo.getFechaGestionComercial()!=null) {
			activoDto.setFechaGestionComercial(perimetroActivo.getFechaGestionComercial());
		}
		
		if(activo.getEstadoValidacionActivoDND()!=null) {
			activoDto.setEstadoFisicoActivoDND(activo.getEstadoValidacionActivoDND().getCodigo());
			activoDto.setEstadoFisicoActivoDNDDescripcion(activo.getEstadoValidacionActivoDND().getDescripcion());
		}

		activoDto.setIsGrupoOficinaKAM(activoApi.isGrupoOficinaKAM());
		if(activo.getTipoTransmision() != null) {
			activoDto.setTipoTransmisionCodigo(activo.getTipoTransmision().getCodigo());
			activoDto.setTipoTransmisionDescripcion(activo.getTipoTransmision().getDescripcion());
		}

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoBbvaActivos activoBbva = genericDao.get(ActivoBbvaActivos.class, filtro);
		
		if(activoBbva != null) {
			if(activoBbva.getActivoEpa() != null) {
				if(DDSinSiNo.CODIGO_SI.equals(activoBbva.getActivoEpa().getCodigo())){
					activoDto.setActivoEpa(true);
				}else {
					activoDto.setActivoEpa(false);
				}
			}
			activoDto.setEmpresa(activoBbva.getEmpresa());
			activoDto.setOficina(activoBbva.getOficina());
			activoDto.setContrapartida(activoBbva.getContrapartida());
			activoDto.setFolio(activoBbva.getFolio());
			activoDto.setCdpen(activoBbva.getCdpen());
			
			
			if(activoBbva.getTipoTransmision() != null) {
				activoDto.setTipoTransmisionCodigo(activoBbva.getTipoTransmision().getCodigo());
				activoDto.setTipoTransmisionDescripcion(activoBbva.getTipoTransmision().getDescripcion());
			}
			
			if(activoBbva.getTipoAlta() != null) {
				activoDto.setTipoAltaCodigo(activoBbva.getTipoAlta().getCodigo());
				activoDto.setTipoAltaDescripcion(activoBbva.getTipoAlta().getDescripcion());
			}
			
			activoDto.setNumActivoBbva(activoBbva.getNumActivoBbva());
			activoDto.setLineaFactura(activoBbva.getLineaFactura());
			activoDto.setIdOrigenHre(activoBbva.getIdOrigenHre());
			activoDto.setUicBbva(activoBbva.getUicBbva());
			activoDto.setCexperBbva(activoBbva.getCexperBbva());

			if(activoBbva.getCodPromocion() != null)
				activoDto.setCodPromocionBbva(activoBbva.getCodPromocion());

			
			if (activoBbva != null && activoBbva.getIdOrigenHre() != null) {
				Activo activoOrigenHRE = activoApi.getByNumActivo(activoBbva.getIdOrigenHre());
				if (activoOrigenHRE != null) {
					if (activo.getSociedadDePagoAnterior() != null 
							&& activoBbva.getIdOrigenHre() != null
							&& (DDCartera.CODIGO_CARTERA_CERBERUS.equals(activoOrigenHRE.getCartera().getCodigo())) 
								&& (DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(activoOrigenHRE.getSubcartera().getCodigo()) 
										|| DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(activoOrigenHRE.getSubcartera().getCodigo()))) {
						
						activoDto.setSociedadPagoAnterior(activo.getPropietarioPrincipal().getDocIdentificativo());				
					}
				}
			}	
		}
		
		Filter filtroLoc = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoLocalizacion activoLoc = genericDao.get(ActivoLocalizacion.class, filtroLoc);
		
		if (activoLoc != null) {
			if(activoLoc.getPlantaEdificio() != null) {
				activoDto.setPlantaEdificioCodigo(activoLoc.getPlantaEdificio().getCodigo());
				activoDto.setPlantaEdificioDescripcion(activoLoc.getPlantaEdificio().getDescripcion());
			}
			
			if(activoLoc.getEscaleraEdificio() != null) {
				activoDto.setEscaleraEdificioCodigo(activoLoc.getEscaleraEdificio().getCodigo());
				activoDto.setEscaleraEdificioDescripcion(activoLoc.getEscaleraEdificio().getDescripcion());
			}
		}
		
		if (activo != null && activo.getLocalizacion() != null && activo.getLocalizacion().getDireccionDos() != null) {
			activoDto.setDireccionDos(activo.getLocalizacion().getDireccionDos());
		}
		
		if (activo != null && activo.getLocalizacion() != null && activo.getLocalizacion().getBloque() != null) {
			activoDto.setBloque(activo.getLocalizacion().getBloque());
		}
		
		if (activo.getProcedenciaProducto() != null) {
			activoDto.setProcedenciaProductoCodigo(activo.getProcedenciaProducto().getCodigo());
			activoDto.setProcedenciaProductoDescripcion(activo.getProcedenciaProducto().getDescripcion());
		}
		
		if (activo.getNumActivoCaixa() != null) {
			activoDto.setNumActivoCaixa(activo.getNumActivoCaixa());
		}	

		if(perimetroActivo.getExcluirValidaciones() != null) {
			activoDto.setExcluirValidacionesBool(DDSinSiNo.cambioDiccionarioaBooleano(perimetroActivo.getExcluirValidaciones()));
		}
		
		HistoricoFasePublicacionActivo fasePublicacionActivoVigente = activoPublicacionDao.getFasePublicacionVigentePorIdActivo(activo.getId());
		
		if(fasePublicacionActivoVigente != null && fasePublicacionActivoVigente.getSubFasePublicacion() != null) {
			activoDto.setCodSubfasePublicacion(fasePublicacionActivoVigente.getSubFasePublicacion().getCodigo());
		}
		
		Boolean estaEnRestringida = Boolean.FALSE; 
	
		if(activoApi.isActivoPrincipalAgrupacionRestringida(activo.getId())) {
			estaEnRestringida = Boolean.TRUE; 
		}
		activoDto.setEsActivoPrincipalAgrupacionRestringida(estaEnRestringida);
		
		Filter filtroActivoCaixa = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoCaixa activoCaixa = genericDao.get(ActivoCaixa.class, filtroActivoCaixa);
		
		if (activoCaixa != null && activoCaixa.getUnidadEconomicaCaixa() != null) {
			activoDto.setUnidadEconomicaCaixa(activoCaixa.getUnidadEconomicaCaixa());
		}
		Filter filterPrinex = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoPrinexActivos activoPrinexActivos = genericDao.get(ActivoPrinexActivos.class, filterPrinex);
		
		if(activoPrinexActivos != null) {
			if(activoPrinexActivos.getDisponibleAdministracion() != null) {
				activoDto.setDisponibleAdministrativoCodigo(activoPrinexActivos.getDisponibleAdministracion().getCodigo());
				activoDto.setDisponibleAdministrativoDescripcion(activoPrinexActivos.getDisponibleAdministracion().getDescripcion());
			}
			
			if(activoPrinexActivos.getDisponibleTecnico() != null) {
				activoDto.setDisponibleTecnicoCodigo(activoPrinexActivos.getDisponibleTecnico().getCodigo());
				activoDto.setDisponibleTecnicoDescripcion(activoPrinexActivos.getDisponibleTecnico().getDescripcion());
			}
			
			if(activoPrinexActivos.getMotivoTecnico() != null) {
				activoDto.setMotivoTecnicoCodigo(activoPrinexActivos.getMotivoTecnico().getCodigo());
				activoDto.setMotivoTecnicoDescripcion(activoPrinexActivos.getMotivoTecnico().getDescripcion());
			}			
		}
		
		return activoDto;
	}
	
	public Boolean calculodiasCambiosActivo(Date fechaIni){
		
		Boolean cumpleCond = Boolean.FALSE;
		Date fechaInicial=fechaIni;
		Date fechaFinal=new Date();
		Integer dias=(int) ((fechaFinal.getTime()-fechaInicial.getTime())/86400000);
		if (dias<7) {
			cumpleCond=Boolean.TRUE; 
		}
		
		return cumpleCond;
	} 

	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto)  throws JsonViewerException {
		DtoActivoFichaCabecera dto = (DtoActivoFichaCabecera) webDto;
		boolean borrarMotivoExcluirValidaciones = false;
		
		validateSaveDatosBasicos(dto, activo);
		
		
		try {
			beanUtilNotNull.copyProperties(activo, dto);
			
			boolean reiniciarPBC = false;
			
			if (Checks.esNulo(activo.getLocalizacion())) {
				activo.setLocalizacion(new ActivoLocalizacion());
				activo.getLocalizacion().setActivo(activo);
			}
			
			if (Checks.esNulo(activo.getLocalizacion().getLocalizacionBien())){
				NMBLocalizacionesBien localizacionesVacia = new NMBLocalizacionesBien();
				localizacionesVacia.setBien(activo.getBien());
				activo.getLocalizacion().setLocalizacionBien(localizacionesVacia);
				activo.getLocalizacion().setLocalizacionBien(genericDao.save(NMBLocalizacionesBien.class, activo.getLocalizacion().getLocalizacionBien()));
			}
			
			beanUtilNotNull.copyProperties(activo.getLocalizacion(), dto);
			beanUtilNotNull.copyProperties(activo.getLocalizacion().getLocalizacionBien(), dto);
			
			
			activo.setLocalizacion(genericDao.save(ActivoLocalizacion.class, activo.getLocalizacion()));
			
			if (!Checks.esNulo(dto.getPaisCodigo())) {
				DDCicCodigoIsoCirbeBKP pais = (DDCicCodigoIsoCirbeBKP) diccionarioApi.dameValorDiccionarioByCod(DDCicCodigoIsoCirbeBKP.class,  dto.getPaisCodigo());
				activo.getLocalizacion().getLocalizacionBien().setPais(pais);
				reiniciarPBC = true;
			}
			
			if (!Checks.esNulo(dto.getTipoViaCodigo())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoViaCodigo());
				DDTipoVia tipoViaNueva = (DDTipoVia) genericDao.get(DDTipoVia.class, filtro);
				activo.getLocalizacion().getLocalizacionBien().setTipoVia(tipoViaNueva);
				reiniciarPBC = true;
			}
			
			if (!Checks.esNulo(dto.getProvinciaCodigo())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaCodigo());
				DDProvincia provincia = (DDProvincia) genericDao.get(DDProvincia.class, filtro);
				activo.getLocalizacion().getLocalizacionBien().setProvincia(provincia);
				reiniciarPBC = true;
			}
			
			if (!Checks.esNulo(dto.getMunicipioCodigo())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
				Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);
				activo.getLocalizacion().getLocalizacionBien().setLocalidad(municipioNuevo);
				reiniciarPBC = true;
			}
			
			if (!Checks.esNulo(dto.getInferiorMunicipioCodigo())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getInferiorMunicipioCodigo());
				DDUnidadPoblacional inferiorNuevo = (DDUnidadPoblacional) genericDao.get(DDUnidadPoblacional.class, filtro);
				activo.getLocalizacion().getLocalizacionBien().setUnidadPoblacional(inferiorNuevo);
				reiniciarPBC = true;
			}
			
			if (!Checks.esNulo(dto.getCesionSaneamientoCodigo())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCesionSaneamientoCodigo());
				DDCesionSaneamiento cesionNuevo = (DDCesionSaneamiento) genericDao.get(DDCesionSaneamiento.class, filtro);
				activo.setCesionSaneamiento(cesionNuevo);
			}
						
			if (!Checks.esNulo(dto.getServicerActivoCodigo())) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getServicerActivoCodigo());
				DDServicerActivo servicerNuevo = (DDServicerActivo) genericDao.get(DDServicerActivo.class, filtro);
				activo.setServicerActivo(servicerNuevo);
			}
			
			if (!Checks.esNulo(dto.getPerimetroMacc())) {
				if (Integer.valueOf(0).equals(dto.getPerimetroMacc())) {
					activo.setTipoSegmento((DDTipoSegmento) genericDao.get(DDTipoSegmento.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoSegmento.CODIGO_SEGMENTO_SIN_CARTERIZAR)));
				}else if (Integer.valueOf(1).equals(dto.getPerimetroMacc())){
					activo.setTipoSegmento((DDTipoSegmento) genericDao.get(DDTipoSegmento.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoSegmento.CODIGO_SEGMENTO_MACC)));
				}
				activo.setPerimetroMacc(dto.getPerimetroMacc());
			}
			
			if(!Checks.esNulo(dto.getPerimetroCartera())) {
				activo.setPerimetroCartera(dto.getPerimetroCartera());
			}

			if(!Checks.esNulo(dto.getNombreCarteraPerimetro())) {
				activo.setNombreCarteraPerimetro(dto.getNombreCarteraPerimetro());
			}
			
			if(!Checks.esNulo(dto.getPorcentajeConstruccion())) {
				BigDecimal porcentajeDouble = new BigDecimal(dto.getPorcentajeConstruccion());
				porcentajeDouble = porcentajeDouble.setScale(2, BigDecimal.ROUND_HALF_EVEN);
				activo.setPorcentajeConstruccion(porcentajeDouble.doubleValue());	 
			}
			activo.getLocalizacion().setLocalizacionBien(genericDao.save(NMBLocalizacionesBien.class, activo.getLocalizacion().getLocalizacionBien()));
			
			if (!Checks.esNulo(dto.getSociedadPagoAnterior())) {
				DDSociedadPagoAnterior sociedaPagoAnterior = (DDSociedadPagoAnterior) diccionarioApi.dameValorDiccionarioByCod(DDSociedadPagoAnterior.class, dto.getSociedadPagoAnterior());
				activo.setSociedadDePagoAnterior(sociedaPagoAnterior);
			}
			
			if (!Checks.esNulo(dto.getTipoActivoCodigo())) {
				DDTipoActivo tipoActivo = (DDTipoActivo) diccionarioApi.dameValorDiccionarioByCod(DDTipoActivo.class,  dto.getTipoActivoCodigo());
				activo.setTipoActivo(tipoActivo);
				reiniciarPBC = true;
			}
			
			if (!Checks.esNulo(dto.getSubtipoActivoCodigo())) {
				DDSubtipoActivo subtipoActivo = (DDSubtipoActivo) diccionarioApi.dameValorDiccionarioByCod(DDSubtipoActivo.class,  dto.getSubtipoActivoCodigo());
				activo.setSubtipoActivo(subtipoActivo);
				reiniciarPBC = true;
			}
			
			if (dto.getTipoTransmisionCodigo() != null) {
				Filter filtroTr1 = genericDao.createFilter(FilterType.EQUALS, "codigo",
						dto.getTipoTransmisionCodigo());
				DDTipoTransmision ddtr1 = genericDao.get(DDTipoTransmision.class, filtroTr1);
				activo.setTipoTransmision(ddtr1);
			}
			
			Filter filterLbk = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			ActivoInfoLiberbank actInfLiber = genericDao.get(ActivoInfoLiberbank.class, filterLbk);

			if (!Checks.esNulo(actInfLiber)){
				if (!Checks.esNulo(dto.getTipoActivoCodigoBde())){
					DDTipoActivoBDE tipoActivoBde = (DDTipoActivoBDE) diccionarioApi.dameValorDiccionarioByCod(DDTipoActivoBDE.class,  dto.getTipoActivoCodigoBde());
					actInfLiber.setTipoActivoBde(tipoActivoBde);
				}
				if (!Checks.esNulo(dto.getSubtipoActivoCodigoBde())){
					DDSubtipoActivoBDE subTipoActivoBde = (DDSubtipoActivoBDE) diccionarioApi.dameValorDiccionarioByCod(DDSubtipoActivoBDE.class,  dto.getSubtipoActivoCodigoBde());
					actInfLiber.setSubtipoActivoBde(subTipoActivoBde);
				}
				genericDao.update(ActivoInfoLiberbank.class, actInfLiber);
			} else {
				actInfLiber = new ActivoInfoLiberbank();
				if (!Checks.esNulo(dto.getTipoActivoCodigoBde())){
					DDTipoActivoBDE tipoActivoBde = (DDTipoActivoBDE) diccionarioApi.dameValorDiccionarioByCod(DDTipoActivoBDE.class,  dto.getTipoActivoCodigoBde());
					actInfLiber.setTipoActivoBde(tipoActivoBde);
				}
				if (!Checks.esNulo(dto.getSubtipoActivoCodigoBde())){
					DDSubtipoActivoBDE subTipoActivoBde = (DDSubtipoActivoBDE) diccionarioApi.dameValorDiccionarioByCod(DDSubtipoActivoBDE.class,  dto.getSubtipoActivoCodigoBde());
					actInfLiber.setSubtipoActivoBde(subTipoActivoBde);
				}
				actInfLiber.setId(activo.getId());
				genericDao.save(ActivoInfoLiberbank.class, actInfLiber);
			}

			if (!Checks.esNulo(dto.getTipoTitulo())) {
				DDTipoTituloActivo tipoTitulo = (DDTipoTituloActivo) diccionarioApi.dameValorDiccionarioByCod(DDTipoTituloActivo.class,  dto.getTipoTitulo());
				activo.setTipoTitulo(tipoTitulo);
			}
			
			if (!Checks.esNulo(dto.getTipoUsoDestinoCodigo())) {
				DDTipoUsoDestino tipoUsoDestino = (DDTipoUsoDestino) diccionarioApi.dameValorDiccionarioByCod(DDTipoUsoDestino.class,  dto.getTipoUsoDestinoCodigo());
				activo.setTipoUsoDestino(tipoUsoDestino);				
				//Actualizar el tipoComercialización del activo
				updaterState.updaterStateTipoComercializacion(activo);
			}
			
			if (!Checks.esNulo(dto.getEstadoActivoCodigo())) {
				DDEstadoActivo estadoActivo = (DDEstadoActivo) diccionarioApi.dameValorDiccionarioByCod(DDEstadoActivo.class,  dto.getEstadoActivoCodigo());
				activo.setEstadoActivo(estadoActivo);
				activo.setFechaUltCambioTipoActivo(new Date());
			}
			
			// Se genera un registro en el histórico por la modificación de los datos en el apartado de 'Datos Admisión' de informe comercial.
			if(
				!Checks.esNulo(dto.getTipoActivoCodigo()) || !Checks.esNulo(dto.getSubtipoActivoCodigo()) ||
				!Checks.esNulo(dto.getTipoViaCodigo()) || !Checks.esNulo(dto.getNombreVia()) || 
				!Checks.esNulo(dto.getNumeroDomicilio()) || !Checks.esNulo(dto.getEscalera()) ||
				!Checks.esNulo(dto.getPiso()) || !Checks.esNulo(dto.getPuerta()) ||
				!Checks.esNulo(dto.getCodPostal()) || !Checks.esNulo(dto.getMunicipioCodigo()) ||
				!Checks.esNulo(dto.getProvinciaCodigo()) || !Checks.esNulo(dto.getLatitud()) ||
				!Checks.esNulo(dto.getLongitud()))
			{
				ActivoEstadosInformeComercialHistorico activoEstadoInfComercialHistorico = new ActivoEstadosInformeComercialHistorico();
				activoEstadoInfComercialHistorico.setActivo(activo);
				Filter filtroDDInfComercial = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_MODIFICACION);
				DDEstadoInformeComercial ddInfComercial = genericDao.get(DDEstadoInformeComercial.class, filtroDDInfComercial);
				activoEstadoInfComercialHistorico.setEstadoInformeComercial(ddInfComercial);
				activoEstadoInfComercialHistorico.setFecha(new Date());
				activoEstadoInfComercialHistorico.setMotivo(DtoEstadosInformeComercialHistorico.ESTADO_MOTIVO_MODIFICACION_MANUAL);
				genericDao.save(ActivoEstadosInformeComercialHistorico.class, activoEstadoInfComercialHistorico);
				reiniciarPBC = true;
			}
			
			// Perimetro -------
			// Solo se guardan los datos si el usuario ha cambiado algun campo de perimetros
			// El control de cambios se realiza revisando los datos que transporta el dto
			// Solo se modifican/crean nuevos registros de perimetros si hay guardado de datos
			if(dto.getAplicaAsignarMediador() != null || dto.getAplicaComercializar() != null || dto.getAplicaFormalizar() != null ||
				dto.getAplicaGestion() != null  || dto.getAplicaTramiteAdmision() != null || dto.getMotivoAplicaComercializarCodigo() != null ||
				dto.getMotivoNoAplicaComercializar() != null || dto.getIncluidoEnPerimetro() != null ||	dto.getFechaAltaActivoRem() != null ||
				dto.getFechaAplicaTramiteAdmision() != null || dto.getMotivoAplicaTramiteAdmision() != null || dto.getFechaAplicaGestion() != null ||
				dto.getMotivoAplicaGestion() != null || dto.getFechaAplicaAsignarMediador() != null || dto.getMotivoAplicaAsignarMediador() != null ||
				dto.getFechaAplicaComercializar() != null || dto.getMotivoAplicaComercializarDescripcion() != null ||
				dto.getFechaAplicaFormalizar() != null || dto.getMotivoAplicaFormalizar() != null || dto.getAplicaPublicar() != null ||
				dto.getFechaAplicaPublicar() != null || dto.getMotivoAplicaPublicar() != null ||dto.getMotivoGestionComercialCodigo() !=null ||
				dto.getMotivoGestionComercialDescripcion() !=null || dto.getFechaGestionComercial()  !=null || 
				dto.getCheckGestorComercial() !=null || dto.getExcluirValidacionesBool() !=null)
			{
				PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activo.getId());
				beanUtilNotNull.copyProperties(perimetroActivo, dto);
				
				//Si no existe perimetro, se creará un registro nuevo, con las opciones por defecto
				if(Checks.esNulo(perimetroActivo.getActivo())) {
					perimetroActivo.setActivo(activo);
					perimetroActivo.setIncluidoEnPerimetro(1);
					perimetroActivo.setAplicaAsignarMediador(1);
					perimetroActivo.setAplicaComercializar(1);
					perimetroActivo.setAplicaFormalizar(1);
					perimetroActivo.setAplicaGestion(1);
					perimetroActivo.setAplicaTramiteAdmision(1);
				}
				
				// Conversion manual. En el dto son booleanos y en la entidad Integer.
				// Asignar al cambiar estado de los checks también la fecha de hoy.
				if(!Checks.esNulo(dto.getAplicaAsignarMediador())) {
					perimetroActivo.setAplicaAsignarMediador(dto.getAplicaAsignarMediador() ? 1 : 0);
					perimetroActivo.setFechaAplicaAsignarMediador(new Date());
				}
				if ((dto.getAplicaComercializar() != null && dto.getAplicaComercializar())
				|| (dto.getAplicaPublicar() != null && dto.getAplicaPublicar())
				|| (dto.getAplicaFormalizar() != null && dto.getAplicaFormalizar())
				|| (dto.getCheckGestorComercial()!=null && dto.getCheckGestorComercial())) {
					this.isActivoInCesionUso(activo);
				}
				if(!Checks.esNulo(dto.getAplicaComercializar())) {	
					
					perimetroActivo.setAplicaComercializar(dto.getAplicaComercializar() ? 1 : 0);
					perimetroActivo.setFechaAplicaComercializar(new Date());					
					
					//Acciones al desmarcar check comercializar
					if(!dto.getAplicaComercializar()) {
						this.accionesDesmarcarComercializar(activo);
					}else  if(DDCartera.isCarteraSareb(activo.getCartera())) {
						this.accionesParaMarcarComercializar(activo);
					}
				}
				if(!Checks.esNulo(dto.getAplicaFormalizar())) {
					 
					perimetroActivo.setAplicaFormalizar(dto.getAplicaFormalizar() ? 1 : 0);
					perimetroActivo.setFechaAplicaFormalizar(new Date());

					//Validacion al desmarcar check formalizar
					if(!dto.getAplicaFormalizar()) {
						
						this.validarPerimetroActivo(activo,2);
					}
				}

				if(!Checks.esNulo(dto.getAplicaGestion())) {
					perimetroActivo.setAplicaGestion(dto.getAplicaGestion() ? 1 : 0);
					perimetroActivo.setFechaAplicaGestion(new Date());
				}
				
				if(!Checks.esNulo(dto.getAplicaTramiteAdmision())) {
					perimetroActivo.setAplicaTramiteAdmision(dto.getAplicaTramiteAdmision() ? 1 : 0);
					perimetroActivo.setFechaAplicaTramiteAdmision(new Date());
				}

				if (!Checks.esNulo(dto.getMotivoAplicaComercializarCodigo())) {
					DDMotivoComercializacion motivoAplicaComercializar = (DDMotivoComercializacion) diccionarioApi.dameValorDiccionarioByCod(DDMotivoComercializacion.class,  dto.getMotivoAplicaComercializarCodigo());
					perimetroActivo.setMotivoAplicaComercializar(motivoAplicaComercializar);
				}

				if(!Checks.esNulo(dto.getAplicaPublicar())) {
					perimetroActivo.setAplicaPublicar(dto.getAplicaPublicar());
					perimetroActivo.setFechaAplicaPublicar(new Date());
					
				}
				
				if(dto.getExcluirValidacionesBool() != null) {
					DDSinSiNo excluirValidaciones;
					if(dto.getExcluirValidacionesBool()) {
						excluirValidaciones =  (DDSinSiNo) diccionarioApi.dameValorDiccionarioByCod(DDSinSiNo.class, DDSinSiNo.CODIGO_SI);
					}else {
						excluirValidaciones =  (DDSinSiNo) diccionarioApi.dameValorDiccionarioByCod(DDSinSiNo.class, DDSinSiNo.CODIGO_NO);
					}
					perimetroActivo.setExcluirValidaciones(excluirValidaciones);	
					if(!dto.getExcluirValidacionesBool()) {
						perimetroActivo.setMotivoGestionComercial(null);
						borrarMotivoExcluirValidaciones = true;
					}
					if(Checks.esNulo(dto.getCheckGestorComercial())) {
						Map <Long,List<String>> map = recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(activo, null, DDSinSiNo.cambioDiccionarioaBooleano(perimetroActivo.getExcluirValidaciones()),true);
						recalculoVisibilidadComercialApi.lanzarPrimerErrorSiTiene(map);
					}
					
				}				
				
				if(!Checks.esNulo(dto.getCheckGestorComercial())) {		
					perimetroActivo.setCheckGestorComercial(dto.getCheckGestorComercial());
					perimetroActivo.setFechaGestionComercial(new Date());			
					Map <Long,List<String>> map = recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(activo, null, DDSinSiNo.cambioDiccionarioaBooleano(perimetroActivo.getExcluirValidaciones()),true);
					recalculoVisibilidadComercialApi.lanzarPrimerErrorSiTiene(map);

				}
								
				if (!Checks.esNulo(dto.getMotivoGestionComercialCodigo()) && !borrarMotivoExcluirValidaciones) {
					DDMotivoGestionComercial motivoGestionComercial = (DDMotivoGestionComercial) diccionarioApi.dameValorDiccionarioByCod(DDMotivoGestionComercial.class,  dto.getMotivoGestionComercialCodigo());
					
					perimetroActivo.setMotivoGestionComercial(motivoGestionComercial);
				}
				

				beanUtilNotNull.copyProperty(perimetroActivo, "motivoNoAplicaComercializar", dto.getMotivoNoAplicaComercializar());
				
				activoApi.saveOrUpdatePerimetroActivo(perimetroActivo);

			}
			if(activoDao.isActivoMatriz(activo.getId())) {
				PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activo.getId());
				ActivoAgrupacion agrupacionPa = activoDao.getAgrupacionPAByIdActivo(activo.getId());
				List<Activo> activosAgrupacionPa = activoAgrupacionActivoDao.getListUAsByIdAgrupacion(agrupacionPa.getId());
				for (Activo activoua  : activosAgrupacionPa) {
					Long idActivoUa = activoua.getId();
					PerimetroActivo perimetroActivoUA = genericDao.get(PerimetroActivo.class,genericDao.createFilter(FilterType.EQUALS,"activo.id", idActivoUa));
					if(!Checks.esNulo(dto.getAplicaComercializar()) && !dto.getAplicaComercializar()) {
						perimetroActivoUA.setAplicaComercializar(0);
						perimetroActivoUA.setFechaAplicaComercializar(new Date());
						if(Checks.esNulo(dto.getMotivoAplicaComercializarCodigo())) {
							perimetroActivoUA.setMotivoAplicaComercializar(perimetroActivo.getMotivoAplicaComercializar());
						}else {
							DDMotivoComercializacion comercializacion = genericDao.get(DDMotivoComercializacion.class,genericDao.createFilter(FilterType.EQUALS,"codigo", dto.getMotivoAplicaComercializarCodigo()));
							perimetroActivoUA.setMotivoAplicaComercializar(comercializacion);
						}
					}
						
					if(!Checks.esNulo(dto.getAplicaFormalizar()) && !dto.getAplicaFormalizar()) {
						perimetroActivoUA.setAplicaFormalizar(0);
						perimetroActivoUA.setFechaAplicaFormalizar(new Date());
						if(Checks.esNulo(dto.getMotivoAplicaFormalizar())) {
							perimetroActivoUA.setMotivoAplicaFormalizar(perimetroActivo.getMotivoAplicaFormalizar());
						}else {
							perimetroActivoUA.setMotivoAplicaFormalizar(dto.getMotivoAplicaFormalizar());
						}
					}
					
					if(!Checks.esNulo(dto.getAplicaGestion()) && !dto.getAplicaGestion()) {
						perimetroActivoUA.setAplicaGestion(0);
						perimetroActivoUA.setFechaAplicaGestion(new Date());
						if(Checks.esNulo(dto.getMotivoAplicaGestion())) {
							perimetroActivoUA.setMotivoAplicaGestion(perimetroActivo.getMotivoAplicaGestion());
						}else {
							perimetroActivoUA.setMotivoAplicaGestion(dto.getMotivoAplicaGestion());
						}
					}
					
					if(!Checks.esNulo(dto.getAplicaPublicar()) && !dto.getAplicaPublicar()) {
						perimetroActivoUA.setAplicaPublicar(false);
						perimetroActivoUA.setFechaAplicaFormalizar(new Date());
						if(Checks.esNulo(dto.getMotivoAplicaGestion())) {
							perimetroActivoUA.setMotivoAplicaPublicar(perimetroActivo.getMotivoAplicaPublicar());
						}else {
							perimetroActivoUA.setMotivoAplicaPublicar(dto.getMotivoAplicaPublicar());
						}
					}
					
					if(!Checks.esNulo(dto.getCheckGestorComercial())) {
						perimetroActivoUA.setCheckGestorComercial(perimetroActivo.getCheckGestorComercial());
						perimetroActivoUA.setFechaGestionComercial(perimetroActivo.getFechaGestionComercial());
						perimetroActivoUA.setMotivoGestionComercial(perimetroActivo.getMotivoGestionComercial());
						perimetroActivoUA.setExcluirValidaciones(perimetroActivo.getExcluirValidaciones());
						
					}
									
					activoApi.saveOrUpdatePerimetroActivo(perimetroActivoUA);
				}
			}
			
			
			// --------- Perimetro --> Bloque Comercializción
			if (!Checks.esNulo(dto.getTipoComercializarCodigo())) {
				DDTipoComercializar tipoComercializar = (DDTipoComercializar) diccionarioApi.dameValorDiccionarioByCod(DDTipoComercializar.class,  dto.getTipoComercializarCodigo());
				activo.setTipoComercializar(tipoComercializar);
			}
			//Hace referencia a Destino Comercial (Si te lía el nombre, habla con Fernando)
			if (!Checks.esNulo(dto.getTipoComercializacionCodigo()) && !Checks.esNulo(activo.getActivoPublicacion())) {
				if (activoApi.isActivoPerteneceAgrupacionRestringida(activo)) {
					List<ActivoAgrupacionActivo> agrupacionActivos = activoApi.getActivoAgrupacionActivoAgrRestringidaPorActivoID(activo.getId()).getAgrupacion().getActivos();	
					for (ActivoAgrupacionActivo agrupacionActivo : agrupacionActivos) {
						validarCambiosTipoComercializacion(activo,dto);
						activoEstadoPublicacionApi.actualizarPublicacionActivoCambioTipoComercializacion(agrupacionActivo.getActivo(), dto.getTipoComercializacionCodigo());
						// Actualizar registros del Historico Destino Comercial
						activoApi.updateHistoricoDestinoComercial(agrupacionActivo.getActivo(), null);
					}
				} else {
					// Hace throws en caso de inflingir alguna valdiacion con el cambio de TipoComercializacion a realizar
					validarCambiosTipoComercializacion(activo,dto);
					activoEstadoPublicacionApi.actualizarPublicacionActivoCambioTipoComercializacion(activo, dto.getTipoComercializacionCodigo());
					// Actualizar registros del Historico Destino Comercial
					activoApi.updateHistoricoDestinoComercial(activo, null);
				}
			}
			
			if (!Checks.esNulo(dto.getTipoAlquilerCodigo())) {
				DDTipoAlquiler tipoAlquiler = (DDTipoAlquiler) diccionarioApi.dameValorDiccionarioByCod(DDTipoAlquiler.class,  dto.getTipoAlquilerCodigo());
				activo.setTipoAlquiler(tipoAlquiler);
			}
			
			//Hace referencia a Equipo de gestion
			if (!Checks.esNulo(dto.getTipoEquipoGestionCodigo())) {
				DDEquipoGestion tipoEquipoGestion = (DDEquipoGestion) diccionarioApi.dameValorDiccionarioByCod(DDEquipoGestion.class,  dto.getTipoEquipoGestionCodigo());
				activo.setEquipoGestion(tipoEquipoGestion);
			}

			// --------- Perimetro --> Bloque Administración.
			beanUtilNotNull.copyProperty(activo, "numInmovilizadoBnk", dto.getNumInmovilizadoBankia());
			
			//HREOS-1983 - Si marcan el check de sello de calidad, ponemos la fecha actual y el gestor logueado.
			if((!Checks.esNulo(dto.getSelloCalidad()) && dto.getSelloCalidad()) || 
				(!Checks.esNulo(dto.getFechaRevisionSelloCalidad()) && !Checks.esNulo(dto.getNombreGestorSelloCalidad()))) {
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				if(!Checks.esNulo(usuarioLogado)){
					activo.setGestorSelloCalidad(usuarioLogado);
				}
				activo.setFechaRevisionSelloCalidad(new Date());
				activo.setSelloCalidad(true);
//				HREOS-13592 Se bloquea el evolutivo de ocultación de activos para la subida 
//				//HREOS-11733 Cambio en las fases de publicacion ( Se puede sacar a una funcion externa ) 
//				Filter filtroFecha = genericDao.createFilter(FilterType.NULL, "fechaFin");
//				Filter filtroActivoId = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
//				HistoricoFasePublicacionActivo histActivo = genericDao.get(HistoricoFasePublicacionActivo.class, filtroFecha,filtroActivoId);
//				
//				if(histActivo != null && histActivo.getFasePublicacion() != null && DDFasePublicacion.CODIGO_FASE_VI_CALIDAD_COMPROBADA.equals(histActivo.getFasePublicacion().getCodigo()) && 
//						histActivo.getSubFasePublicacion() != null && !DDSubfasePublicacion.CODIGO_CALIDAD_COMPROBADA.equals(histActivo.getSubFasePublicacion().getCodigo())) {
//					Filter filtroSubFase = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSubfasePublicacion.CODIGO_CALIDAD_COMPROBADA);
//					DDSubfasePublicacion subfase = genericDao.get(DDSubfasePublicacion.class, filtroSubFase);
//					histActivo.setFechaFin(new Date());
//					HistoricoFasePublicacionActivo histoNuevo = new HistoricoFasePublicacionActivo();
//					genericDao.update(HistoricoFasePublicacionActivo.class, histActivo);
//					
//					try {
//						BeanUtils.copyProperties(histoNuevo, histActivo);
//						histoNuevo.setSubFasePublicacion(subfase);
//						histoNuevo.setFechaFin(null);
//						genericDao.save(HistoricoFasePublicacionActivo.class, histoNuevo);
//					} catch (IllegalAccessException e) {
//						e.printStackTrace();
//					} catch (InvocationTargetException e) {
//						e.printStackTrace();
//					}
//				}
			}else if(!Checks.esNulo(dto.getSelloCalidad()) && !dto.getSelloCalidad()){
				activo.setGestorSelloCalidad(null);
				activo.setFechaRevisionSelloCalidad(null);
				activo.setSelloCalidad(false);
//				HREOS-13592 Se bloquea el evolutivo de ocultación de activos para la subida 
//				//HREOS-11733 Cambio en las fases de publicacion
//				Filter filtroFecha = genericDao.createFilter(FilterType.NULL, "fechaFin");
//				Filter filtroActivoId = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
//				HistoricoFasePublicacionActivo histActivo = genericDao.get(HistoricoFasePublicacionActivo.class, filtroFecha,filtroActivoId);
//				
//				if(histActivo != null && histActivo.getFasePublicacion() != null && DDFasePublicacion.CODIGO_FASE_VI_CALIDAD_COMPROBADA.equals(histActivo.getFasePublicacion().getCodigo()) && 
//						histActivo.getSubFasePublicacion() != null && DDSubfasePublicacion.CODIGO_CALIDAD_COMPROBADA.equals(histActivo.getSubFasePublicacion().getCodigo())) {
//					Filter filtroSubFase = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSubfasePublicacion.CODIGO_SIN_INCIDENCIAS);
//					DDSubfasePublicacion subfase = genericDao.get(DDSubfasePublicacion.class, filtroSubFase);
//					histActivo.setFechaFin(new Date());
//					HistoricoFasePublicacionActivo histoNuevo = new HistoricoFasePublicacionActivo();
//					genericDao.save(HistoricoFasePublicacionActivo.class, histActivo);
//					
//					try {
//						BeanUtils.copyProperties(histoNuevo, histActivo);
//						histoNuevo.setSubFasePublicacion(subfase);
//						histoNuevo.setFechaFin(null);
//						genericDao.save(HistoricoFasePublicacionActivo.class, histoNuevo);
//					} catch (IllegalAccessException e) {
//						e.printStackTrace();
//					} catch (InvocationTargetException e) {
//						e.printStackTrace();
//					}
//				}
			}
			
			
			// Activo bancario -------------
			// Solo se guardan los datos si el usuario ha cambiado algun campo del activo bancario.
			// El control de cambios se realiza revisando los datos que transporta el dto
			// Solo se modifican/crean nuevos registros de activo bancario si hay guardado de datos
			if(
				dto.getClaseActivoCodigo() != null || 
				dto.getClaseActivoDescripcion() != null || 
				dto.getSubtipoClaseActivoCodigo() != null || 
				dto.getSubtipoClaseActivoDescripcion() != null || 
				dto.getNumExpRiesgo() != null || 
				dto.getTipoProductoCodigo() != null || 
				dto.getTipoProductoDescripcion() != null || 
				dto.getEstadoExpRiesgoCodigo() != null || 
				dto.getEstadoExpRiesgoDescripcion() != null || 
				dto.getEstadoExpIncorrienteCodigo() != null || 
				dto.getEstadoExpIncorrienteDescripcion() != null ||
				dto.getProductoDescripcion() != null ||
				dto.getCategoriaComercializacionCod() != null) 
			{
				
				ActivoBancario activoBancario = activoApi.getActivoBancarioByIdActivo(activo.getId());
				
				beanUtilNotNull.copyProperties(activoBancario, dto);
	
				if(!Checks.esNulo(activoBancario) && Checks.esNulo(activoBancario.getActivo())) {
					activoBancario.setActivo(activo);
				}
				
				if(!Checks.esNulo(dto.getClaseActivoCodigo())) {
					DDClaseActivoBancario claseActivo = (DDClaseActivoBancario) diccionarioApi.dameValorDiccionarioByCod(DDClaseActivoBancario.class, dto.getClaseActivoCodigo());
					activoBancario.setClaseActivo(claseActivo);
				} else {
					DDClaseActivoBancario claseActivo = (DDClaseActivoBancario) diccionarioApi.dameValorDiccionarioByCod(DDClaseActivoBancario.class, DDClaseActivoBancario.CODIGO_INMOBILIARIO);
					activoBancario.setClaseActivo(claseActivo);
				}
				
				if(!Checks.esNulo(dto.getSubtipoClaseActivoCodigo())) {
					DDSubtipoClaseActivoBancario subtipoClaseActivo = (DDSubtipoClaseActivoBancario) diccionarioApi.dameValorDiccionarioByCod(DDSubtipoClaseActivoBancario.class, dto.getSubtipoClaseActivoCodigo());
					activoBancario.setSubtipoClaseActivo(subtipoClaseActivo);
				}
	
				if(!Checks.esNulo(dto.getTipoProductoCodigo())) {
					DDTipoProductoBancario tipoProducto = (DDTipoProductoBancario) diccionarioApi.dameValorDiccionarioByCod(DDTipoProductoBancario.class, dto.getTipoProductoCodigo());
					activoBancario.setTipoProducto(tipoProducto);
				}
				
				if(!Checks.esNulo(dto.getEstadoExpRiesgoCodigo())) {
					DDEstadoExpRiesgoBancario estadoExpRiesgo = (DDEstadoExpRiesgoBancario) diccionarioApi.dameValorDiccionarioByCod(DDEstadoExpRiesgoBancario.class, dto.getEstadoExpRiesgoCodigo());
					activoBancario.setEstadoExpRiesgo(estadoExpRiesgo);
				}
	
				if(!Checks.esNulo(dto.getEstadoExpIncorrienteCodigo())) {
					DDEstadoExpIncorrienteBancario estadoExpIncorriente = (DDEstadoExpIncorrienteBancario) diccionarioApi.dameValorDiccionarioByCod(DDEstadoExpIncorrienteBancario.class, dto.getEstadoExpIncorrienteCodigo());
					activoBancario.setEstadoExpIncorriente(estadoExpIncorriente);
				}
				
				if (dto.getCategoriaComercializacionCod() != null) {
					DDCategoriaComercializacion categComerc = (DDCategoriaComercializacion) diccionarioApi.dameValorDiccionarioByCod(DDCategoriaComercializacion.class, dto.getCategoriaComercializacionCod());
					activoBancario.setCategoriaComercializacion(categComerc);
				}
				
				activoApi.saveOrUpdateActivoBancario(activoBancario);
			
			}

			if(!Checks.esNulo(dto.getEntradaActivoBankiaCodigo())) {
				DDEntradaActivoBankia entradaActivoBankia = (DDEntradaActivoBankia) diccionarioApi.dameValorDiccionarioByCod(DDEntradaActivoBankia.class, dto.getEntradaActivoBankiaCodigo());
				activo.setEntradaActivoBankia(entradaActivoBankia);
			}
			
			if (dto.getTipoDistritoCodigoPostalCod() != null) {
				DDDistritoCaixa distrito = (DDDistritoCaixa) diccionarioApi.dameValorDiccionarioByCod(DDDistritoCaixa.class, dto.getTipoDistritoCodigoPostalCod());
				ActivoLocalizacion actLoc = activo.getLocalizacion();
				if (actLoc != null) {
					actLoc.setDistritoCaixa(distrito);
					genericDao.save(ActivoLocalizacion.class, actLoc);
				}
			}
			// -----
			
			if(reiniciarPBC) {
				ExpedienteComercial expediente = expedienteComercialApi.getExpedienteComercialResetPBC(activo);
				if(!Checks.esNulo(expediente)) {
					ofertaApi.resetPBC(expediente, false);
				}
			}
			
			if(dto.getTipoSegmentoCodigo() != null) {
				DDTipoSegmento tipoSegmento = (DDTipoSegmento) diccionarioApi.dameValorDiccionarioByCod(DDTipoSegmento.class, dto.getTipoSegmentoCodigo());
				activo.setTipoSegmento(tipoSegmento);
				
				if(DDTipoSegmento.CODIGO_SEGMENTO_MACC.equals(tipoSegmento.getCodigo())) {
					activo.setPerimetroMacc(1);
				}else {
					activo.setPerimetroMacc(0);
				}
			}
			

			if (!Checks.esNulo(activo)) {
				boolean isUnidadAlquilable = activoDao.isUnidadAlquilable(activo.getId());
				
				if(isUnidadAlquilable) {
					ActivoAgrupacion agrupacion = activoDao.getAgrupacionPAByIdActivo(activo.getId());
					
					if(!Checks.esNulo(agrupacion)) {
						//Los porcentajes de participación se encuentran en la tabla que relaciona agrupaciones con activos (AGA).
						Double porcentajeUAs = activoAgrupacionDao.getPorcentajeParticipacionUATotalDeUnAMById(agrupacion.getId());			//Obtenemos la suma de porcentajes
						Filter filterIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
						Filter filterIdAgrupacion = genericDao.createFilter(FilterType.EQUALS, "agrupacion.id", agrupacion.getId());
						ActivoAgrupacionActivo aga = genericDao.get(ActivoAgrupacionActivo.class, filterIdActivo, filterIdAgrupacion);		//Filtramos las agas en función del idAgrupacion y el idActivo
						
						if(!Checks.esNulo(dto.getPorcentajeParticipacion())) {
							//Si el porcentaje total se pasa de 100
							if(porcentajeUAs - aga.getParticipacionUA() + dto.getPorcentajeParticipacion() > 100) {
								throw new JsonViewerException(messageServices.getMessage(ERROR_PORCENTAJE_PARTICIPACION));
							} else {
								aga.setParticipacionUA(dto.getPorcentajeParticipacion());							
							}
						}
						
						if(!Checks.esNulo(dto.getIdPrinexHPM())) {
							aga.setIdPrinexHPM(dto.getIdPrinexHPM());
						}
					}
				}
			}		
			
			if (!Checks.esNulo(activo) && !Checks.esNulo(dto.getTipoComercializarCodigo()) || !Checks.esNulo(dto.getTipoActivoCodigo()) || !Checks.esNulo(dto.getSubtipoActivoCodigo())) {
				List <Oferta> ofertas = activoApi.getOfertasTramitadasByActivo(activo);
				
				for (Oferta oferta : ofertas) {
					ExpedienteComercial expedienteComercial = genericDao.get(ExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId()));
					if(!Checks.esNulo(expedienteComercial)) {
						expedienteComercialApi.actualizarGastosExpediente(expedienteComercial, oferta, null);
					}
				}
			}

			
			Filter filtroActivoSareb = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			ActivoSareb activoSareb = genericDao.get(ActivoSareb.class, filtroActivoSareb);
			
			if (activoSareb != null) {
				if (dto.getTipoActivoCodigoOE() != null) {
					DDTipoActivo tipoActivoOE = (DDTipoActivo) diccionarioApi.dameValorDiccionarioByCod(DDTipoActivo.class,  dto.getTipoActivoCodigoOE());
					activoSareb.setTipoActivoOE(tipoActivoOE);
				}
				
				if (dto.getSubtipoActivoCodigoOE() != null) {
					DDSubtipoActivo subtipoActivoOE = (DDSubtipoActivo) diccionarioApi.dameValorDiccionarioByCod(DDSubtipoActivo.class,  dto.getSubtipoActivoCodigoOE());
					activoSareb.setSubtipoActivoOE(subtipoActivoOE);
				}
				
				if (dto.getTipoViaCodigoOE() != null) {
					DDTipoVia tipoViaOE = (DDTipoVia) diccionarioApi.dameValorDiccionarioByCod(DDTipoVia.class,  dto.getTipoViaCodigoOE());
					activoSareb.setTipoViaOE(tipoViaOE);
				}
				
				if (dto.getProvinciaCodigoOE() != null) {
					DDProvincia provinciaOE = (DDProvincia) diccionarioApi.dameValorDiccionarioByCod(DDProvincia.class,  dto.getProvinciaCodigoOE());
					activoSareb.setProvinciaOE(provinciaOE);
				}
				
				if (dto.getMunicipioCodigoOE() != null) {
					Filter filtroCodigoLocalidad = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigoOE());
 					Localidad localidadOE = genericDao.get(Localidad.class, filtroCodigoLocalidad);
					activoSareb.setLocalidadOE(localidadOE);
				}
				
				if (dto.getNombreViaOE() != null) {
					activoSareb.setNombreViaOE(dto.getNombreViaOE());
				}
				
				if (dto.getNumeroDomicilioOE() != null) {
					activoSareb.setNumeroDomicilioOE(dto.getNumeroDomicilioOE());
				}
				
				if (dto.getEscaleraOE() != null) {
					activoSareb.setEscaleraOE(dto.getEscaleraOE());
				}
				
				if (dto.getPisoOE() != null) {
					activoSareb.setPisoOE(dto.getPisoOE());
				}
				
				if (dto.getPuertaOE() != null) {
					activoSareb.setPuertaOE(dto.getPuertaOE());
				}
				
				if (dto.getCodPostalOE() != null) {
					activoSareb.setCodPostalOE(dto.getCodPostalOE());
				}
				
				if (dto.getLatitudOE() != null) {
					activoSareb.setLatitudOE(new BigDecimal(dto.getLatitudOE()));
				}
				
				if (dto.getLongitudOE() != null) {
					activoSareb.setLongitudOE(new BigDecimal(dto.getLongitud()));
				}
				
				if (dto.getEstadoAdecuacionSarebCodigo() != null) {
					DDEstadoAdecucionSareb estadoAdecuacionSareb = (DDEstadoAdecucionSareb) diccionarioApi.dameValorDiccionarioByCod(DDEstadoAdecucionSareb.class,  dto.getEstadoAdecuacionSarebCodigo());
					activoSareb.setEstadoAdecuacionSareb(estadoAdecuacionSareb);
				}
				if (dto.getFechaFinPrevistaAdecuacion() != null) {
					activoSareb.setFechaFinPrevistaAdecuacion(dto.getFechaFinPrevistaAdecuacion());
				}
				
				if(dto.getReoContabilizadoSap() != null) {
					if(activoSareb != null) {
						if(dto.getReoContabilizadoSap() == true) {
							Filter filtroSi = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_SI);
							DDSinSiNo codigoSi = genericDao.get(DDSinSiNo.class, filtroSi);
							activoSareb.setReoContabilizado(codigoSi);	
							
							PerimetroActivo perimetroActivoSAP = activoApi.getPerimetroByIdActivo(activoSareb.getActivo().getId());
							if (perimetroActivoSAP != null) {
								perimetroActivoSAP.setAplicaComercializar(1);
								perimetroActivoSAP.setFechaAplicaComercializar(new Date());
								perimetroActivoSAP.setAplicaFormalizar(1);
								perimetroActivoSAP.setFechaAplicaFormalizar(new Date());
								activoApi.saveOrUpdatePerimetroActivo(perimetroActivoSAP);
								updaterState.updaterStateDisponibilidadComercial(activoSareb.getActivo());
							}		
						}else {
							Filter filtroNo = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_NO);
							DDSinSiNo codigoNo = genericDao.get(DDSinSiNo.class, filtroNo);
							activoSareb.setReoContabilizado(codigoNo);
						}
					}
				}				
				
				genericDao.update(ActivoSareb.class, activoSareb);
			}


			PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activo.getId());
			
			if(dto.getPerimetroAdmision() != null) {
				perimetroActivo.setAplicaAdmision(dto.getPerimetroAdmision());
				perimetroActivo.setFechaAplicaAdmision(new Date());
			}
			if(dto.getMotivoPerimetroAdmision() != null) {
				perimetroActivo.setMotivoAplicaAdmision(dto.getMotivoPerimetroAdmision());
			}
			activoApi.saveOrUpdatePerimetroActivo(perimetroActivo);
			
			DDEstadoRegistralActivo ddEstadoReg = (DDEstadoRegistralActivo) diccionarioApi.dameValorDiccionarioByCod(DDEstadoRegistralActivo.class, dto.getEstadoRegistralCodigo());
			if(ddEstadoReg != null) {
				activo.setEstadoRegistral(ddEstadoReg);
				activoDao.save(activo);
			}
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			ActivoBbvaActivos activoBbva = genericDao.get(ActivoBbvaActivos.class, filtro);
			if(activoBbva != null) {
				if(dto.getCodPromocionBbva() != null) {
					List<ActivoBbvaActivos> activosPromocion = genericDao.getList(ActivoBbvaActivos.class, 
							genericDao.createFilter(FilterType.EQUALS, "codPromocion", dto.getCodPromocionBbva()));
					DDPromocionBBVA pbb = genericDao.get(DDPromocionBBVA.class, genericDao.createFilter(FilterType.EQUALS, "descripcion", dto.getCodPromocionBbva()));
					if(activosPromocion != null && !activosPromocion.isEmpty() || pbb != null) {
						activoBbva.setCodPromocion(dto.getCodPromocionBbva());
					}else {
						throw new JsonViewerException("La Promoción con código \""+dto.getCodPromocionBbva()+"\" no existe.");
					}
				}
				//No comprobar los nulos, porque siempre se van a setear,
				//controlado por sencha (onSaveFormularioCompleto de ActivoDetalleController.js)
				activoBbva.setUicBbva(dto.getUicBbva());
				activoBbva.setCexperBbva(dto.getCexperBbva());
			}
			if (dto.getTipoTransmisionCodigo() != null || dto.getTipoAltaCodigo() != null || dto.getActivoEpa() != null ||
				dto.getEmpresa() != null || dto.getOficina() !=  null || dto.getContrapartida() != null ||
				dto.getFolio() != null || dto.getCdpen() != null || dto.getNumActivoBbva() != null ||
				dto.getLineaFactura() != null || dto.getIdOrigenHre() != null ||
				dto.getUicBbva() != null || dto.getCexperBbva() !=  null

			) {
				
				if (activoBbva != null) {
					if (dto.getTipoTransmisionCodigo() != null) {
						Filter filtroTr1 = genericDao.createFilter(FilterType.EQUALS, "codigo",
								dto.getTipoTransmisionCodigo());
						DDTipoTransmision ddtr1 = genericDao.get(DDTipoTransmision.class, filtroTr1);
						activoBbva.setTipoTransmision(ddtr1);
					}

					if (dto.getTipoAltaCodigo() != null) {
						Filter filtroAut = genericDao.createFilter(FilterType.EQUALS, "codigo",
								dto.getTipoAltaCodigo());
						DDTipoAlta ddAut = genericDao.get(DDTipoAlta.class, filtroAut);
						activoBbva.setTipoAlta(ddAut);
					}

					if (dto.getActivoEpa() != null) {
						if (dto.getActivoEpa()) {
							Filter filtroSi = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_SI);
							DDSinSiNo ddSi = genericDao.get(DDSinSiNo.class, filtroSi);
							activoBbva.setActivoEpa(ddSi);
						} else {
							Filter filtroNo = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_NO);
							DDSinSiNo ddNo = genericDao.get(DDSinSiNo.class, filtroNo);
							activoBbva.setActivoEpa(ddNo);
						}
					}

					if (dto.getEmpresa() != null) {
						activoBbva.setEmpresa(dto.getEmpresa());
					}

					if (dto.getOficina() != null) {	
						activoBbva.setOficina(dto.getOficina());
					}

					if (dto.getContrapartida() != null) {
						activoBbva.setContrapartida(dto.getContrapartida());
					}

					if (dto.getFolio() != null) {
						activoBbva.setFolio(dto.getFolio());
					}

					if (dto.getCdpen() != null) {
						activoBbva.setCdpen(dto.getCdpen());
					}

					if (dto.getNumActivoBbva() != null) {
						activoBbva.setNumActivoBbva(dto.getNumActivoBbva());
					}

					if (dto.getLineaFactura() != null) {
						activoBbva.setLineaFactura(dto.getLineaFactura());
					}

					if (dto.getIdOrigenHre() != null && !"".equals(String.valueOf(dto.getIdOrigenHre()))) {
						
						Activo activoOrigenHRE = activoApi.getByNumActivo(dto.getIdOrigenHre());
						
						boolean isVendido =  false;
						boolean isCarteraBBVADivarian =  false;
						boolean isFueraPerimetro =  false;

						if (activoOrigenHRE != null) {
							
							if (activoOrigenHRE.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BBVA) 
									|| (activoOrigenHRE.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_CERBERUS) 
									&& (activoOrigenHRE.getSubcartera().getCodigo().equals(DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB)) 
									|| activoOrigenHRE.getSubcartera().getCodigo().equals(DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB))) {
								isCarteraBBVADivarian=true;
							}else {
								isCarteraBBVADivarian=false;
							}

							isVendido = activoApi.isVendido(activoOrigenHRE.getId());
							isFueraPerimetro = !activoApi.isActivoIncluidoEnPerimetro(activoOrigenHRE.getId());							
						
							boolean isOrigenHRE = !activoDao.existeactivoIdHAYA(dto.getIdOrigenHre()); 
							isVendido = activoDao.activoEstadoVendido(dto.getIdOrigenHre()); 
							isFueraPerimetro = activoDao.activoFueraPerimetroHAYA(dto.getIdOrigenHre()); 
													
							if(isOrigenHRE) {
								throw new JsonViewerException(messageServices.getMessage(ID_HAYA_NO_EXISTE));
							}
							
							if (!isCarteraBBVADivarian) {
								throw new JsonViewerException(messageServices.getMessage(ACTIVO_NO_DIVARIAN_BBVA));
							}
							if (!isVendido && !isFueraPerimetro) {
								throw new JsonViewerException(messageServices.getMessage(ACTIVO_VENDIDO_FUERA_DE_PERIMETRO_HAYA));
							}							
						
							activoBbva.setIdOrigenHre(dto.getIdOrigenHre());
							
							activoBbva.setSociedadPagoAnterior(activoOrigenHRE.getPropietarioPrincipal());
							
							if(activoOrigenHRE.getTipoTitulo()!= null) {
								activo.setTipoTitulo(activoOrigenHRE.getTipoTitulo());
								activo.setTipoTituloBbva(activoOrigenHRE.getTipoTitulo());
							}
							
							if (DDTipoTituloActivo.tipoTituloNoJudicial.equals(activoOrigenHRE.getTipoTitulo().getCodigo())
									&& activoOrigenHRE.getAdjNoJudicial() != null) {
								activo.setFechaTituloAnterior(activoOrigenHRE.getAdjNoJudicial().getFechaTitulo());
							}
							if (DDTipoTituloActivo.tipoTituloJudicial.equals(activoOrigenHRE.getTipoTitulo().getCodigo())
									&& activoOrigenHRE.getAdjJudicial() != null) {
								activo.setFechaTituloAnterior(activoOrigenHRE.getAdjJudicial().getFechaAdjudicacion());
							}

							if(activoOrigenHRE.getSociedadDePagoAnterior() != null) {
								activo.setSociedadDePagoAnterior(activoOrigenHRE.getSociedadDePagoAnterior());
							}
						} else {
							throw new JsonViewerException(messageServices.getMessage(ACTIVO_NO_EXISTE));
						}
					}
				}else {
					//throw new JsonViewerException(messageServices.getMessage(ACTIVO_NO_BBVA));
				}
			}
			
			
			ActivoLocalizacion actLocMod = activo.getLocalizacion();
				
			if (actLocMod != null) {
				if (dto.getDireccionDos() != null) {
					actLocMod.setDireccionDos(dto.getDireccionDos());
				}
				if (dto.getBloque() != null) {
					actLocMod.setBloque(dto.getBloque());
				}
					
				genericDao.update(ActivoLocalizacion.class, actLocMod);
					
				activo.setLocalizacion(actLocMod);
			}
			
			
			Filter filtroLoc = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			ActivoLocalizacion activoLoc = genericDao.get(ActivoLocalizacion.class, filtroLoc);
			
			if (activoLoc != null) {
				if (dto.getPlantaEdificioCodigo() != null) {
					Filter filtroPlanta = genericDao.createFilter(FilterType.EQUALS, "codigo",
							dto.getPlantaEdificioCodigo());
					DDPlantaEdificio planta = genericDao.get(DDPlantaEdificio.class, filtroPlanta);
					activoLoc.setPlantaEdificio(planta);
				}
				
				if (dto.getEscaleraEdificioCodigo() != null) {
					Filter filtroEscalera = genericDao.createFilter(FilterType.EQUALS, "codigo",
							dto.getEscaleraEdificioCodigo());
					DDEscaleraEdificio escalera = genericDao.get(DDEscaleraEdificio.class, filtroEscalera);
					activoLoc.setEscaleraEdificio(escalera);
				}
			}
			
			if(activoApi.isActivoPrincipalAgrupacionRestringida(activo.getId()) && (dto.getCheckGestorComercial()!=null 
					|| dto.getExcluirValidacionesBool()!=null || dto.getMotivoGestionComercialCodigo()!=null)){
				modificarCheckVisibleGestionComercialRestringida(activo,dto);
			}
			
			Filter filterPrinex = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			ActivoPrinexActivos activoPrinexActivos = genericDao.get(ActivoPrinexActivos.class, filterPrinex);
			
			if(activoPrinexActivos != null) {
				if(dto.getDisponibleAdministrativoCodigo() != null) {
					Filter filtroDispAdm = genericDao.createFilter(FilterType.EQUALS, "codigo",
							dto.getDisponibleAdministrativoCodigo());
					DDDisponibleAdministracion disponibleAdministracion = genericDao.get(DDDisponibleAdministracion.class, filtroDispAdm);
					activoPrinexActivos.setDisponibleAdministracion(disponibleAdministracion);
				}
				
				if(dto.getDisponibleTecnicoCodigo() != null) {
					Filter filtroDispTec = genericDao.createFilter(FilterType.EQUALS, "codigo",
							dto.getDisponibleTecnicoCodigo());
					DDDisponibleTecnico disponibleTecnico = genericDao.get(DDDisponibleTecnico.class, filtroDispTec);
					activoPrinexActivos.setDisponibleTecnico(disponibleTecnico);
				}
				
				if(dto.getMotivoTecnicoCodigo() != null) {
					Filter filtroMotTec = genericDao.createFilter(FilterType.EQUALS, "codigo",
							dto.getMotivoTecnicoCodigo());
					DDMotivoTecnico motivoTecnico = genericDao.get(DDMotivoTecnico.class, filtroMotTec);
					activoPrinexActivos.setMotivoTecnico(motivoTecnico);
				}
				
			}else {
				activoPrinexActivos = new ActivoPrinexActivos();
				if (!Checks.esNulo(dto.getDisponibleAdministrativoCodigo())){
					DDDisponibleAdministracion disponibleAdministracion = (DDDisponibleAdministracion) diccionarioApi.dameValorDiccionarioByCod(DDDisponibleAdministracion.class,  dto.getDisponibleAdministrativoCodigo());
					activoPrinexActivos.setDisponibleAdministracion(disponibleAdministracion);
				}
				if (!Checks.esNulo(dto.getDisponibleTecnicoCodigo())){
					DDDisponibleTecnico disponibleTecnico = (DDDisponibleTecnico) diccionarioApi.dameValorDiccionarioByCod(DDDisponibleTecnico.class,  dto.getDisponibleTecnicoCodigo());
					activoPrinexActivos.setDisponibleTecnico(disponibleTecnico);
				}
				if (!Checks.esNulo(dto.getMotivoTecnicoCodigo())){
					DDMotivoTecnico motivoTecnico = (DDMotivoTecnico) diccionarioApi.dameValorDiccionarioByCod(DDMotivoTecnico.class,  dto.getMotivoTecnicoCodigo());
					activoPrinexActivos.setMotivoTecnico(motivoTecnico);
				}
				activoPrinexActivos.setActivo(activo);
				genericDao.save(ActivoPrinexActivos.class, activoPrinexActivos);
			}
		} catch(JsonViewerException jve) {
			throw jve;
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		return activo;
	}

	/**
	 * Acciones al desmarcar check Comercializar
	 * 1. Valida si se puede demarcar (Activo sin ofertas vivas).
	 * 2. Valida si el activo pertenece a una agrupación de tipo restringida y es el activo principal.
	 * 3. Si puede desmarcar y es activo principal de una agrupación de tipo restringida, actualizar estado publicación.
	 *
	 * @param activo: activo sobre el que se desmarca comercializar.
	 */
	private void accionesDesmarcarComercializar(Activo activo) {
		ArrayList<Long> idActivoActualizarPublicacion = new ArrayList<Long>();
		idActivoActualizarPublicacion.add(activo.getId());
		this.validarPerimetroActivo(activo,1);
		this.validarPerimetroActivo(activo,3);
		activoAdapter.actualizarEstadoPublicacionActivo(idActivoActualizarPublicacion,false);
		//activoAdapter.actualizarEstadoPublicacionActivo(activo.getId());
	}
	
	/**
	 * Valida condiciones del perimitro, según se marque/desmarque los checks.
	 * case 1: Al desmarcar check comercializar, no se puede hacer si el activo tiene ofertas vivas. (estado != rechazada)
	 * case 2: Al desmarcar check formalizar, no se puede hacer si el activo tiene un exp. comercial vivo (tareas activas)
	 * case 3: Al desmarcar check comercializar, no se puede hacer si el activo se encuentra en una agrupación restringida y NO es activo principal.
	 * case 4: Al marcar check Visible Gestión Comercial, el activo alquilado no debe de ser de tipo FSV.
	 * @param activo
	 * @return
	 */
	private void validarPerimetroActivo(Activo activo, Integer numVal) {
		
		String error = null;
		
		switch(numVal) {
			case 1: {
				if(activoApi.isActivoConOfertasVivas(activo))
					error = messageServices.getMessage(MSG_ERROR_PERIMETRO_COMERCIALIZACION_OFERTAS_VIVAS);
				break;
			}
			case 2: {
				if(expedienteComercialApi.isExpedienteComercialVivoByActivo(activo))
					error = messageServices.getMessage(MSG_ERROR_PERIMETRO_FORMALIZACION_EXPEDIENTE_VIVO);
				break;
			}
			case 3: {
				if(activoApi.isIntegradoAgrupacionRestringida(activo.getId(), genericAdapter.getUsuarioLogado())) {
					if(activoApi.isActivoPrincipalAgrupacionRestringida(activo.getId())) {
						// Quitar comercializar todos los activos de la misma AGR restringida que el activo.
						this.quitarComercializacionEnActivosAgrupacionRestringidaPorActivo(activo);
					} else {
						error = messageServices.getMessage(MSG_ERROR_PERIMETRO_COMERCIALIZACION_AGR_RESTRINGIDA_NO_PRINCIPAL);
					}
				}

				break;
			}
			default:
				break;
		}
		
		if(!Checks.esNulo(error))
			throw new JsonViewerException(error);
	}

	/**
	 * Este método pone la comercialización de todos los activos de una agrupación de tipo restringida
	 * a NO. Obtiene la agrupación en base a un activo.
	 * 
	 * @param activo: activo desde el que obtener la agrupación de tipo restringida.
	 */
	private void quitarComercializacionEnActivosAgrupacionRestringidaPorActivo(Activo activo) {
		ActivoAgrupacionActivo activoAgrupacionActivo = activoApi.getActivoAgrupacionActivoAgrRestringidaPorActivoID(activo.getId());

		if(activoAgrupacionActivo == null) {
			return;
		}

		List<ActivoAgrupacionActivo> activoAgrupacionActivoList = activoAgrupacionActivo.getAgrupacion().getActivos();
		Date fechaHoy = new Date();
		for(ActivoAgrupacionActivo activos : activoAgrupacionActivoList) {
			// No modificar el perímetro del activo de procedencia, su perimetro se actualiza en el método padre de la tab.
			if(activos.getActivo().getId() == activo.getId()) {
				continue;
			}

			PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activos.getActivo().getId());
			if(perimetroActivo != null) {
				perimetroActivo.setAplicaComercializar(0);
				perimetroActivo.setFechaAplicaComercializar(fechaHoy);

				perimetroActivo.setAplicaFormalizar(0);
				perimetroActivo.setFechaAplicaFormalizar(fechaHoy);
				
				if(DDCartera.isCarteraSareb(activo.getCartera())) {
					perimetroActivo.setCheckGestorComercial(false);
					perimetroActivo.setFechaGestionComercial(fechaHoy);
				}
				
				activoApi.saveOrUpdatePerimetroActivo(perimetroActivo);
				updaterState.updaterStateDisponibilidadComercial(activos.getActivo());
			}
		}
	}
	
	public void afterSaveTabActivo(Activo activo, WebDto dto) {
		
		DtoActivoFichaCabecera dtoFicha = (DtoActivoFichaCabecera) dto;
		
		// Comprueba si ha habido cambios en el Tipo Comercializar para
				// actualizar el gestor comercial de las tareas
		if (!Checks.esNulo(dtoFicha.getTipoComercializarCodigo())) {
			String codGestorSingular = "GCOMSIN", codGestorRetail = "GCOMRET";
			Boolean isActivoRetail = DDTipoComercializar.CODIGO_RETAIL.equals(activo.getTipoComercializar().getCodigo());

			// Comprobamos que se pueda realizar el cambio, analizando tareas
			// activas comerciales y si hay gestor adecuado en el activo
			if (gestorActivoApi.existeGestorEnActivo(activo, isActivoRetail ? codGestorRetail : codGestorSingular)) {
				if (gestorActivoApi.validarTramitesNoMultiActivo(activo.getId()))
					gestorActivoApi.actualizarTareas(activo.getId());
				else {
					// El activo pertenece a un trámite multiactivo, y por tanto no
					// se puede cambiar el gestor en las taras, enviamos un aviso al
					// gestor comercial anterior
					// Si ahora el activo es Retail, entonces antes era Singular. Y
					// viceversa.
					String codComercialAnterior = isActivoRetail ? "GCOMSIN" : "GCOMRET";
					Usuario usuario = gestorActivoApi.getGestorComercialActual(activo, codComercialAnterior);

					if (!Checks.esNulo(usuario) && activoTareaExternaApi.existenTareasActivasByTramiteAndTipoGestor(activo,
							ActivoTramiteApi.CODIGO_TRAMITE_COMERCIAL_VENTA, codComercialAnterior)) {
						Notificacion notif = new Notificacion();
						String tipoComercialDesc = !isActivoRetail ? DDTipoComercializar.DESCRIPCION_SINGULAR
								: DDTipoComercializar.DESCRIPCION_RETAIL;
						String tipoComercialDescAnterior = isActivoRetail ? DDTipoComercializar.DESCRIPCION_SINGULAR
								: DDTipoComercializar.DESCRIPCION_RETAIL;
						String[] datosDescripcion = { activo.getNumActivo().toString(), tipoComercialDescAnterior,
								tipoComercialDesc };
						String descripcion = messageServices.getMessage(AVISO_MENSAJE_GESTOR_COMERCIAL, datosDescripcion);

						notif.setIdActivo(activo.getId());
						notif.setDestinatario(usuario.getId());
						notif.setTitulo(messageServices.getMessage(AVISO_TITULO_GESTOR_COMERCIAL));
						notif.setDescripcion(descripcion);
						notif.setFecha(null);
						try {
							anotacionApi.saveNotificacion(notif);
						} catch (ParseException e) {
							logger.error("No se ha podido enviar el aviso por no poder cambiar el gestor comercial en las tareas: " + e);
						}
					}
				}
			}
		}
		
	}

	public void validarCambiosTipoComercializacion(Activo activo, DtoActivoFichaCabecera dto) {

		// Si intentamos cambiar de venta a alquiler
		// o de Alquiler y venta a alquilerisTramitable
		// Se validará que no exista ninguna oferta viva de tipo venta

		if (DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(dto.getTipoComercializacionCodigo())
				&& (DDTipoComercializacion.CODIGO_VENTA.equals(activo.getTipoComercializacion().getCodigo())
						|| DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(activo.getTipoComercializacion().getCodigo()))
				&& particularValidator.existeActivoConOfertaVentaViva("" + activo.getNumActivo())) {

				throw new JsonViewerException(messageServices.getMessage(MSG_ERROR_DESTINO_COMERCIAL_OFERTAS_VIVAS_VENTA));

		}

		// Si intentamos cambiar de alquiler a venta
		// o de Alquiler y venta a Venta
		// Se validará que no exista ninguna oferta viva de tipo alquiler

		if (DDTipoComercializacion.CODIGO_VENTA.equals(dto.getTipoComercializacionCodigo())
				&& (DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(activo.getTipoComercializacion().getCodigo())
						|| DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(activo.getTipoComercializacion().getCodigo()))
				&& particularValidator.existeActivoConOfertaAlquilerViva("" + activo.getNumActivo())) {

				throw new JsonViewerException(messageServices.getMessage(MSG_ERROR_DESTINO_COMERCIAL_OFERTAS_VIVAS_ALQUILER));

		}


	}
	
	private boolean isTramitable(Activo activo) {
		boolean tramitable = true;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", activo.getId());
		VTramitacionOfertaActivo activoNoTramitable = genericDao.get(VTramitacionOfertaActivo.class, filtro);

		if(!Checks.esNulo(activoNoTramitable)) {
			tramitable = false;
		}

		return tramitable;
	}
	private void isActivoInCesionUso(Activo activo) {
		ActivoPatrimonio activoP = activoPatrimonioDao.getActivoPatrimonioByActivo(activo.getId());
		Boolean puedeModificar = false;
		Usuario  usuario = genericAdapter.getUsuarioLogado();
		List<Perfil> perfiles = usuario.getPerfiles();
		for (Perfil perfil : perfiles) {
			if(PERFIL_CHECKCOMERCIALIZAR.equalsIgnoreCase(perfil.getCodigo())){
				puedeModificar = true;
			}
		}
		if (activoP != null && activoP.getCesionUso() != null) {
			DDCesionUso cesion =  activoP.getCesionUso();
			List<String> types = new ArrayList<String>(
					Arrays.asList(DDCesionUso.CARITAS, DDCesionUso.CESION_GENERALITAT_CX,
							DDCesionUso.CESION_OTRAS_OPERACIONES, DDCesionUso.EN_TRAMITE_OTRAS_OPERACIONES));
			if (types.contains(cesion.getCodigo()) && !puedeModificar) {
				throw new JsonViewerException(messageServices.getMessage(CESION_USO_ERROR));
			}
			
		}
	}
	
	private void validateSaveDatosBasicos(DtoActivoFichaCabecera dto, Activo activo) {
	
		if(dto != null && dto.getTipoSegmentoCodigo() != null
				&& DDTipoSegmento.CODIGO_SEGMENTO_MACC.equals(dto.getTipoSegmentoCodigo())
				&& !DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(activo.getTipoComercializacion().getCodigo())) {
			throw new JsonViewerException("No puede cambiar el segmento a MACC ya que el destino comercial tiene que ser alquiler");
		}
		
	}
	
	private void modificarCheckVisibleGestionComercialRestringida(Activo activo,DtoActivoFichaCabecera dto) {
		ActivoAgrupacionActivo activoAgrupacionActivo = activoApi.getActivoAgrupacionActivoAgrRestringidaPorActivoID(activo.getId());
			
		if(activoAgrupacionActivo == null) {
			return;
		}

		List<ActivoAgrupacionActivo> activoAgrupacionActivoList = activoAgrupacionActivo.getAgrupacion().getActivos();

		for(ActivoAgrupacionActivo activos : activoAgrupacionActivoList) {
			PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activos.getActivo().getId());
			if(perimetroActivo != null) {
				
				if(dto.getCheckGestorComercial()!=null) {
					perimetroActivo.setCheckGestorComercial(dto.getCheckGestorComercial());	
					if(dto.getCheckGestorComercial()) {
						perimetroActivo.setFechaGestionComercial(new Date());
					}				
				}
				
				if(dto.getExcluirValidacionesBool()!=null) {
					String excluir="";
					if(dto.getExcluirValidacionesBool()) {
						excluir=DDSinSiNo.CODIGO_SI;
					}else {
						excluir=DDSinSiNo.CODIGO_NO;
					}
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", excluir);
					
					DDSinSiNo siONo = genericDao.get(DDSinSiNo.class, filtro);
					perimetroActivo.setExcluirValidaciones(siONo);			
				}
				
				if(dto.getMotivoGestionComercialCodigo()!=null) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMotivoGestionComercialCodigo());
					DDMotivoGestionComercial motivo = genericDao.get(DDMotivoGestionComercial.class, filtro);
					perimetroActivo.setMotivoGestionComercial(motivo);
				}
				genericDao.save(PerimetroActivo.class, perimetroActivo);
			
			}
		}
	}
	
	public void accionesParaMarcarComercializar (Activo act) {
		if(!activoApi.isActivoPerteneceAgrupacionRestringida(act)) {
			return;
		}
		
		ActivoAgrupacionActivo aga = activoApi.getActivoAgrupacionActivoAgrRestringidaPorActivoID(act.getId());
		if(aga == null) {
			return;
		}
		
		ActivoAgrupacion agr = aga.getAgrupacion();
		if(agr != null) {
			List<Activo> activos = activoApi.getActivosNoPrincipalesByIdAgrupacionAndActivoPrincipal(agr.getId(),act.getId());
			if(!Checks.estaVacio(activos)) {
				Date fechaHoy = new Date();
				for (Activo activo : activos) {
					PerimetroActivo perimetroActivo =  activoApi.getPerimetroByIdActivo(activo.getId());
					if(perimetroActivo != null) {
						perimetroActivo.setAplicaComercializar(1);
						perimetroActivo.setFechaAplicaComercializar(fechaHoy);
						
						perimetroActivo.setCheckGestorComercial(true);
						perimetroActivo.setFechaGestionComercial(fechaHoy);
						
						perimetroActivo.setExcluirValidaciones((DDSinSiNo) diccionarioApi.dameValorDiccionarioByCod(DDSinSiNo.class, DDSinSiNo.CODIGO_NO));
						perimetroActivo.setMotivoGestionComercial(null);
						
						genericDao.update(PerimetroActivo.class,perimetroActivo);
					}
					
				}
			}
		}
	}
}

