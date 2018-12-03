package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;
import java.util.List;

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
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDCicCodigoIsoCirbeBKP;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoPropagacionApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.ActivoInfoLiberbank;
import es.pfsgroup.plugin.rem.model.ActivoLocalizacion;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.DtoActivoFichaCabecera;
import es.pfsgroup.plugin.rem.model.DtoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.VPreciosVigentes;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEntradaActivoBankia;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpIncorrienteBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpRiesgoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoInformeComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivoBDE;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivoBDE;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProductoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUsoDestino;
import es.pfsgroup.plugin.rem.notificacion.api.AnotacionApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.ENTIDADES;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;

@Component
public class TabActivoDatosBasicos implements TabActivoService {
	
	public static final String MSG_ERROR_PERIMETRO_COMERCIALIZACION_OFERTAS_VIVAS = "activo.aviso.demsarcar.comercializar.ofertas.vivas";
	public static final String MSG_ERROR_PERIMETRO_FORMALIZACION_EXPEDIENTE_VIVO = "activo.aviso.demsarcar.formalizar.expediente.vivo";
	public static final String MOTIVO_ACTIVO_NO_COMERCIALIZABLE_NO_PUBLICADO = "activo.motivo.desmarcar.comercializar.no.publicar";
	public static final String MSG_ERROR_PERIMETRO_COMERCIALIZACION_AGR_RESTRINGIDA_NO_PRINCIPAL = "activo.aviso.demsarcar.comercializar.agr.restringida.no.principal";
	public static final String AVISO_TITULO_GESTOR_COMERCIAL = "activo.aviso.titulo.cambio.gestor.comercial";
	public static final String AVISO_MENSAJE_GESTOR_COMERCIAL = "activo.aviso.descripcion.cambio.gestor.comercial";
    

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private UpdaterStateApi updaterState;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;
	
	@Autowired
	private AnotacionApi anotacionApi;
	
	@Autowired
	private ActivoPropagacionApi activoPropagacionApi;
	
	@Autowired
	private RestApi restApi;
	
	@Resource
    MessageService messageServices;
	
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
			}
			
			if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getTipoVia() != null) {
				BeanUtils.copyProperty(activoDto, "tipoViaDescripcion", activo.getLocalizacion().getLocalizacionBien().getTipoVia().getDescripcion());
			}
			
			if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getPais() != null) {
				BeanUtils.copyProperty(activoDto, "paisCodigo", activo.getLocalizacion().getLocalizacionBien().getPais().getCodigo());
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
		}
		
		if (activo.getTipoUsoDestino() != null) {
			BeanUtils.copyProperty(activoDto, "tipoUsoDestinoCodigo", activo.getTipoUsoDestino().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoUsoDestinoDescripcion", activo.getTipoUsoDestino().getDescripcion());
		}
		
		if (activo.getInfoComercial() != null && activo.getInfoComercial().getTipoInfoComercial() != null) {
			BeanUtils.copyProperty(activoDto, "tipoInfoComercialCodigo", activo.getInfoComercial().getTipoInfoComercial().getCodigo());
		}
		
		if(activo.getEstadoPublicacion() != null){
			// Si el activo contiene datos de publicación.
			BeanUtils.copyProperty(activoDto, "estadoPublicacionDescripcion", activo.getEstadoPublicacion().getDescripcion());
			BeanUtils.copyProperty(activoDto, "estadoPublicacionCodigo", activo.getEstadoPublicacion().getCodigo());
		} else {
			// Si el activo no contiene datos de publicación se trata como NO PUBLICADO.
			DDEstadoPublicacion estadoPublicacion = (DDEstadoPublicacion) diccionarioApi.dameValorDiccionarioByCod(DDEstadoPublicacion.class, DDEstadoPublicacion.CODIGO_NO_PUBLICADO);
			if(!Checks.esNulo(estadoPublicacion)) {
				activoDto.setEstadoPublicacionDescripcion(estadoPublicacion.getDescripcion());
			}
			activoDto.setEstadoPublicacionCodigo(DDEstadoPublicacion.CODIGO_NO_PUBLICADO);
		}
		
		if(activo.getTipoComercializar() != null){
			BeanUtils.copyProperty(activoDto, "tipoComercializarCodigo", activo.getTipoComercializar().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoComercializarDescripcion", activo.getTipoComercializar().getDescripcion());
		}
		//Hace referencia a Destino Comercial (Si te lía el nombre, habla con Fernando)
		if(activo.getTipoComercializacion() != null){
			BeanUtils.copyProperty(activoDto, "tipoComercializacionCodigo", activo.getTipoComercializacion().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoComercializacionDescripcion", activo.getTipoComercializacion().getDescripcion());
		}
		
		if(activo.getTipoAlquiler() != null){
			BeanUtils.copyProperty(activoDto, "tipoAlquilerCodigo", activo.getTipoAlquiler().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoAlquilerDescripcion", activo.getTipoAlquiler().getDescripcion());
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
			BeanUtils.copyProperty(activoDto, "pertenceAgrupacionComercial", pertenceAgrupacionComercial);
			BeanUtils.copyProperty(activoDto, "pertenceAgrupacionAsistida", pertenceAgrupacionAsistida);
			BeanUtils.copyProperty(activoDto, "pertenceAgrupacionObraNueva", pertenceAgrupacionObraNueva);
			BeanUtils.copyProperty(activoDto, "pertenceAgrupacionProyecto", pertenceAgrupacionProyecto);
		}
		
		for(ActivoAgrupacionActivo agrupaciones: activo.getAgrupaciones()){
			if(Checks.esNulo(agrupaciones.getAgrupacion().getFechaBaja()) && !Checks.esNulo(agrupaciones.getAgrupacion().getId())) {
				BeanUtils.copyProperty(activoDto,"idAgrupacion", agrupaciones.getAgrupacion().getId());
				break;
			}
		}

		// Obtener si el ultimo estado del informe comercial es ACEPTADO.
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
		


		//HREOS-843 Situacion Comercial del activo
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
		
		// Si no exite perimetro en BBDD, se crea una nueva instancia PerimetroActivo, con todas las condiciones marcadas
		// y por tanto, por defecto se marcan los checkbox.
		BeanUtils.copyProperty(activoDto,"aplicaTramiteAdmision", new Integer(1).equals( perimetroActivo.getAplicaTramiteAdmision())? true: false);
		BeanUtils.copyProperty(activoDto,"aplicaGestion", new Integer(1).equals( perimetroActivo.getAplicaGestion())? true: false);
		BeanUtils.copyProperty(activoDto,"aplicaAsignarMediador", new Integer(1).equals(perimetroActivo.getAplicaAsignarMediador())? true: false);
		BeanUtils.copyProperty(activoDto,"aplicaComercializar", new Integer(1).equals(perimetroActivo.getAplicaComercializar())? true: false);
		BeanUtils.copyProperty(activoDto,"aplicaFormalizar", new Integer(1).equals(perimetroActivo.getAplicaFormalizar())? true: false);

		// En la sección de perímetro pero no dependiente del mismo.
		BeanUtils.copyProperty(activoDto, "numInmovilizadoBankia", activo.getNumInmovilizadoBnk());
		// ----------
		
		// Datos de activo bancario -----------------
		// Datos de activo bancario del activo al Dto de datos basicos
		// - Puede no existir registro de activo bancario en la tabla. Esto no producira errores de carga/guardado
		ActivoBancario activoBancario = activoApi.getActivoBancarioByIdActivo(activo.getId());
		
		if(!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getClaseActivo())) {
			BeanUtils.copyProperty(activoDto, "claseActivoCodigo", activoBancario.getClaseActivo().getCodigo());
			BeanUtils.copyProperty(activoDto, "claseActivoDescripcion", activoBancario.getClaseActivo().getDescripcion());
		}
		
		if(!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getSubtipoClaseActivo())) {
			BeanUtils.copyProperty(activoDto, "subtipoClaseActivoCodigo", activoBancario.getSubtipoClaseActivo().getCodigo());
			BeanUtils.copyProperty(activoDto, "subtipoClaseActivoDescripcion", activoBancario.getSubtipoClaseActivo().getDescripcion());
		}
		
		/*if(!Checks.esNulo(activoBancario) && !Checks.esNulo(activoBancario.getTipoProducto())) {
			BeanUtils.copyProperty(activoDto, "tipoProductoCodigo", activoBancario.getTipoProducto().getCodigo());
			BeanUtils.copyProperty(activoDto, "tipoProductoDescripcion", activoBancario.getTipoProducto().getDescripcion());
		}*/
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
			
		}

		// En la sección de activo bancario pero no dependiente del mismo.
		if(!Checks.esNulo(activo.getEntradaActivoBankia())) {
			BeanUtils.copyProperty(activoDto, "entradaActivoBankiaCodigo", activo.getEntradaActivoBankia().getCodigo());
		}

		// ------------
		
		//Activo integrado en agrupación asisitida
		BeanUtils.copyProperty(activoDto, "integradoEnAgrupacionAsistida",activoApi.isIntegradoAgrupacionAsistida(activo));
		
		//Tipo de activo segun el Mediador
		if(!Checks.esNulo(activo.getInfoComercial()) && !Checks.esNulo(activo.getInfoComercial().getTipoActivo())) {
			BeanUtils.copyProperty(activoDto, "tipoActivoMediadorCodigo", activo.getInfoComercial().getTipoActivo().getCodigo());
		}
		
		if(!Checks.esNulo(activo.getGestorSelloCalidad())){
			BeanUtils.copyProperty(activoDto, "nombreGestorSelloCalidad", activo.getGestorSelloCalidad().getApellidoNombre());
		}
		
		List<VPreciosVigentes> listaPrecios = activoApi.getPreciosVigentesById(activo.getId());
		if (!Checks.esNulo(listaPrecios)) {
			for (int i = 0; i < listaPrecios.size(); i++) {
				if (listaPrecios.get(i).getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO)) {
					BeanUtils.copyProperty(activoDto, "minimoAutorizado", listaPrecios.get(i).getImporte());
				} else if (listaPrecios.get(i).getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA)) {
					BeanUtils.copyProperty(activoDto, "aprobadoVentaWeb", listaPrecios.get(i).getImporte());
				} else if (listaPrecios.get(i).getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA)) {
					BeanUtils.copyProperty(activoDto, "aprobadoRentaWeb", listaPrecios.get(i).getImporte());
				} else if (listaPrecios.get(i).getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_DESC_APROBADO)) {
					BeanUtils.copyProperty(activoDto, "descuentoAprobado", listaPrecios.get(i).getImporte());
				} else if (listaPrecios.get(i).getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_DESC_PUBLICADO)) {
					BeanUtils.copyProperty(activoDto, "descuentoPublicado", listaPrecios.get(i).getImporte());
				} else if (listaPrecios.get(i).getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT)) {
					BeanUtils.copyProperty(activoDto, "valorNetoContable", listaPrecios.get(i).getImporte());
				} else if (listaPrecios.get(i).getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_COSTE_ADQUISICION)) {
					BeanUtils.copyProperty(activoDto, "costeAdquisicion", listaPrecios.get(i).getImporte());
				}
			}
		}
		if(!Checks.esNulo(activo.getTasacion()) && activo.getTasacion().size()>0){
			ActivoTasacion tasacionMasReciente = activo.getTasacion().get(0);
			BeanUtils.copyProperty(activoDto, "valorUltimaTasacion", tasacionMasReciente.getImporteTasacionFin());
		}
		if(activo.getCodigoPromocionPrinex() != null ) {
			BeanUtils.copyProperty(activoDto, "codigoPromocionPrinex", activo.getCodigoPromocionPrinex());
		}
		
		if(activo.getActivoBNK() != null && activo.getActivoBNK().getAcbCoreaeTexto() != null && activo.getActivoBNK().getAcbCoreaeTexto() != ""){
			BeanUtils.copyProperty(activoDto, "acbCoreaeTexto", activo.getActivoBNK().getAcbCoreaeTexto());
		}

		// HREOS-2761: Buscamos si existen activos candidatos para propagar cambios. Llamada única para el activo
		// activoDto.setActivosPropagables(activoPropagacionApi.getAllActivosAgrupacionPorActivo(activo));
		 
		// HREOS-2761: Buscamos los campos que pueden ser propagados para esta pestaña
		 activoDto.setCamposPropagables(TabActivoService.TAB_DATOS_BASICOS);
		
		//REMVIP-REMVIP-2193
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		Usuario gestorComercial = gestorActivoApi.getGestorComercialActual(activo, "GCOM");
		Usuario supervisorComercial = gestorActivoApi.getGestorComercialActual(activo, "SCOM");
		if(usuarioLogado.equals(gestorComercial) 
				|| usuarioLogado.equals(supervisorComercial)
				|| genericAdapter.isSuper(usuarioLogado)){
			activoDto.setIsLogUsuGestComerSupComerSupAdmin(true);
		}else{
			activoDto.setIsLogUsuGestComerSupComerSupAdmin(false);
		}
		
		//HREOS-4836 (GENCAT)
		Boolean afectoAGencat = false;
		try {
			afectoAGencat = activoApi.isAfectoGencat(activo);
		}
		catch (ParseException e) {
			e.printStackTrace();
		}
		activoDto.setAfectoAGencat(afectoAGencat);
		
		return activoDto;	
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto)  throws JsonViewerException {
		DtoActivoFichaCabecera dto = (DtoActivoFichaCabecera) webDto;
		
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
			
			activo.getLocalizacion().setLocalizacionBien(genericDao.save(NMBLocalizacionesBien.class, activo.getLocalizacion().getLocalizacionBien()));
			
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
			if(
				dto.getAplicaAsignarMediador() != null || dto.getAplicaComercializar() != null || dto.getAplicaFormalizar() != null || 
				dto.getAplicaGestion() != null  || dto.getAplicaTramiteAdmision() != null || dto.getMotivoAplicaComercializarCodigo() != null ||
				dto.getMotivoNoAplicaComercializar() != null || 
				dto.getIncluidoEnPerimetro() != null ||	dto.getFechaAltaActivoRem() != null || dto.getAplicaTramiteAdmision() != null || 
				dto.getFechaAplicaTramiteAdmision() != null || dto.getMotivoAplicaTramiteAdmision() != null ||	dto.getAplicaGestion() != null ||
				dto.getFechaAplicaGestion() != null || dto.getMotivoAplicaGestion() != null || dto.getAplicaAsignarMediador() != null ||
				dto.getFechaAplicaAsignarMediador() != null || dto.getMotivoAplicaAsignarMediador() != null || dto.getAplicaComercializar() != null || 
				dto.getFechaAplicaComercializar() != null || dto.getMotivoAplicaComercializarCodigo() != null || dto.getMotivoAplicaComercializarDescripcion() != null ||
				dto.getMotivoNoAplicaComercializar() != null || dto.getAplicaFormalizar() != null || dto.getFechaAplicaFormalizar() != null || dto.getMotivoAplicaFormalizar() != null)
				 
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
				if(!Checks.esNulo(dto.getAplicaComercializar())) {
					perimetroActivo.setAplicaComercializar(dto.getAplicaComercializar() ? 1 : 0);
					perimetroActivo.setFechaAplicaComercializar(new Date());
					
					//Acciones al desmarcar check comercializar
					if(!dto.getAplicaComercializar()) {
						try {
							this.accionesDesmarcarComercializar(activo);
						} catch (SQLException e) {
							new JsonViewerException("Error en BBDD: ".concat(e.getMessage()));
							e.printStackTrace();
						}
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
				
				beanUtilNotNull.copyProperty(perimetroActivo, "motivoNoAplicaComercializar", dto.getMotivoNoAplicaComercializar());
				

				activoApi.saveOrUpdatePerimetroActivo(perimetroActivo);
			}
			
			// --------- Perimetro --> Bloque Comercializción
			if (!Checks.esNulo(dto.getTipoComercializarCodigo())) {
				DDTipoComercializar tipoComercializar = (DDTipoComercializar) diccionarioApi.dameValorDiccionarioByCod(DDTipoComercializar.class,  dto.getTipoComercializarCodigo());
				activo.setTipoComercializar(tipoComercializar);
			}
			//Hace referencia a Destino Comercial (Si te lía el nombre, habla con Fernando)
			if (!Checks.esNulo(dto.getTipoComercializacionCodigo())) {
				DDTipoComercializacion tipoComercializacion = (DDTipoComercializacion) diccionarioApi.dameValorDiccionarioByCod(DDTipoComercializacion.class,  dto.getTipoComercializacionCodigo());
				activo.setTipoComercializacion(tipoComercializacion);
			}
			
			if (!Checks.esNulo(dto.getTipoAlquilerCodigo())) {
				DDTipoAlquiler tipoAlquiler = (DDTipoAlquiler) diccionarioApi.dameValorDiccionarioByCod(DDTipoAlquiler.class,  dto.getTipoAlquilerCodigo());
				activo.setTipoAlquiler(tipoAlquiler);
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
			}else if(!Checks.esNulo(dto.getSelloCalidad()) && !dto.getSelloCalidad()){
				activo.setGestorSelloCalidad(null);
				activo.setFechaRevisionSelloCalidad(null);
				activo.setSelloCalidad(false);
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
				dto.getProductoDescripcion() != null) 
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
				
				activoApi.saveOrUpdateActivoBancario(activoBancario);
			
			}

			if(!Checks.esNulo(dto.getEntradaActivoBankiaCodigo())) {
				DDEntradaActivoBankia entradaActivoBankia = (DDEntradaActivoBankia) diccionarioApi.dameValorDiccionarioByCod(DDEntradaActivoBankia.class, dto.getEntradaActivoBankiaCodigo());
				activo.setEntradaActivoBankia(entradaActivoBankia);
			}
			// -----
			
			if(reiniciarPBC) {
				ExpedienteComercial expediente = expedienteComercialApi.getExpedienteComercialResetPBC(activo);
				if(!Checks.esNulo(expediente)) {
					ofertaApi.resetPBC(expediente, false);
				}
			}
			restApi.marcarRegistroParaEnvio(ENTIDADES.ACTIVO, activo);
			
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
	 * 3. Si puede desmarcar y es activo principal de una agrupación de tipo restringida, hay que poner
	 *  el activo en estado publicación a 'No publicado' y desmarcar todos los comercializar de los activos
	 *  que componen la agrupación restringida.
	 * @param activo
	 * @throws SQLException 
	 * @throws JsonViewerException 
	 */
	private void accionesDesmarcarComercializar(Activo activo) throws JsonViewerException, SQLException {
		this.validarPerimetroActivo(activo,1);
		this.validarPerimetroActivo(activo,3);
		//Si se permite desmarcar, cambiamos el estado de publicación del activo a 'No Publicado'
		String motivo = messageServices.getMessage(MOTIVO_ACTIVO_NO_COMERCIALIZABLE_NO_PUBLICADO);
		activoApi.setActivoToNoPublicado(activo, motivo);
	}
	
	/**
	 * Valida condiciones del perimitro, según se marque/desmarque los checks.
	 * case 1: Al desmarcar check comercializar, no se puede hacer si el activo tiene ofertas vivas. (estado != rechazada)
	 * case 2: Al desmarcar check formalizar, no se puede hacer si el activo tiene un exp. comercial vivo (tareas activas)
	 * case 3: Al desmarcar check comercializar, no se puede hacer si el activo se encuentra en una agrupación restringida y NO es activo principal.
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

		for(ActivoAgrupacionActivo activos : activoAgrupacionActivoList) {
			// No modificar el perímetro del activo de procedencia, su perimetro se actualiza en el método padre de la tab.
			if(activos.getActivo().getId() == activo.getId()) {
				continue;
			}

			PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activos.getActivo().getId());
			if(perimetroActivo != null) {
				perimetroActivo.setAplicaComercializar(0);
				perimetroActivo.setFechaAplicaComercializar(new Date());

				perimetroActivo.setAplicaFormalizar(0);
				perimetroActivo.setFechaAplicaFormalizar(new Date());

				activoApi.saveOrUpdatePerimetroActivo(perimetroActivo);
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


}
