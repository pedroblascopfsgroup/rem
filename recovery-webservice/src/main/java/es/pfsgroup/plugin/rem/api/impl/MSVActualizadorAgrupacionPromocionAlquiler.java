package es.pfsgroup.plugin.rem.api.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorEntidadHistorico;
import es.pfsgroup.plugin.gestorDocumental.dto.ActivoOutputDto;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBInformacionRegistralBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.rem.activo.MaestroDeActivos;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.gestorDocumental.manager.GestorDocumentalAdapterManager;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionJudicial;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionNoJudicial;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoCargas;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoInfoRegistral;
import es.pfsgroup.plugin.rem.model.ActivoLocalizacion;
import es.pfsgroup.plugin.rem.model.ActivoOcupanteLegal;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.ActivoPublicacionHistorico;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTitulo;
import es.pfsgroup.plugin.rem.model.DtoHistoricoMediador;
import es.pfsgroup.plugin.rem.model.HistoricoOcupadoTitulo;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionVenta;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.service.AltaActivoService;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;
import es.pfsgroup.recovery.api.UsuarioApi;

@Component @Transactional(readOnly = false)
public class MSVActualizadorAgrupacionPromocionAlquiler extends AbstractMSVActualizador implements MSVLiberator {
	
	private static final String ERROR_ACTIVO_NO_PROC_CORREC = "Activo no procesado correctamente, intentelo de nuevo más tarde";
	
	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	ActivoAdapter activoAdapter;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoDao activoDao;
	
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private AgrupacionAdapter agrupacionAdapter;
	
	@Autowired 
	ActivoApi activoApi;
	
	@Autowired
	private UpdaterStateApi updaterState;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	@Autowired
	private GestorDocumentalAdapterManager gdAdapterManager;
	
	
	List<Activo> listaActivos = null;
	
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_AGRUPACION_PROMOCION_ALQUILER;
	}
	

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws Exception {
		
		//-----Usuariocrear, Fechacrear
		Auditoria auditoria = new Auditoria();
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado(); 
		auditoria.setUsuarioCrear(usuarioLogado.getUsername());
		auditoria.setFechaCrear(new Date());  
		
		listaActivos = new ArrayList<Activo>();
		
		//-----Nuevo Bien 
		NMBBien bien = new NMBBien();
		bien.setAuditoria(auditoria);
		genericDao.save(Bien.class, bien);
		
		//Agrupacion 
		ActivoAgrupacionActivo activoAgrupacionActivo = null;

		//-----Se obtiene el activo matriz de la agrupacion indicada en la carga masiva  para generar la plantilla de guardado de unidades alquilables.
		Activo activoMatriz = null; 
		if(!Checks.esNulo(exc.dameCelda(fila, 0))){
			Long idAgrupacion = agrupacionAdapter.getAgrupacionIdByNumAgrupRem(Long.valueOf(exc.dameCelda(fila, 0)));
			Long idActivoMatriz = activoDao.getIdActivoMatriz(idAgrupacion);
			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", idActivoMatriz);
			activoMatriz = genericDao.get(Activo.class, f1);
		}	
		//-----Nueva Unidad alquilable (activo)
		Activo unidadAlquilable = new Activo(); 
		DDSinSiNo ddNo = (DDSinSiNo)diccionarioApi.dameValorDiccionarioByCod(DDSinSiNo.class, DDSinSiNo.CODIGO_NO);
		//DDSinSiNo ddSi = (DDSinSiNo)diccionarioApi.dameValorDiccionarioByCod(DDSinSiNo.class, DDSinSiNo.CODIGO_SI);//descomentar para usar
		
		if (!Checks.esNulo(activoMatriz)) {    
				
			//Insercion de datos Basicos del Activo Matriz a la unidad alquilable
			if (!Checks.esNulo(activoMatriz.getBien())) {			
				//Insercion bien
				NMBBien bienMatriz = activoMatriz.getBien();
				 
				if (!Checks.esNulo(bienMatriz.getTipoBien()))
					bien.setTipoBien(bienMatriz.getTipoBien());
				if (!Checks.esNulo(bienMatriz.getParticipacion()))
					bien.setParticipacion((bienMatriz.getParticipacion()));
				if (!Checks.esNulo(bienMatriz.getTipoBien()))
					bien.setTipoBien(bienMatriz.getTipoBien());
				if (!Checks.esNulo(bienMatriz.getValorActual()))
					bien.setValorActual(bienMatriz.getValorActual());
				if (!Checks.esNulo(bienMatriz.getImporteCargas())) 
					bien.setImporteCargas(bienMatriz.getImporteCargas());
				if (!Checks.esNulo(bienMatriz.getSuperficie()))
					bien.setSuperficie(bienMatriz.getSuperficie());
				if (!Checks.esNulo(bienMatriz.getPoblacion()))
					bien.setPoblacion(bienMatriz.getPoblacion());
				if (!Checks.esNulo(bienMatriz.getDatosRegistrales()))
					bien.setDatosRegistrales(bienMatriz.getDatosRegistrales());
				if (!Checks.esNulo(bienMatriz.getReferenciaCatastral()))
					bien.setReferenciaCatastral(bienMatriz.getReferenciaCatastral());
				if (!Checks.esNulo(bienMatriz.getDescripcionBien()))
					bien.setDescripcionBien(bienMatriz.getDescripcionBien());
				if (!Checks.esNulo(bienMatriz.getFechaVerificacion()))
					bien.setFechaVerificacion(bienMatriz.getFechaVerificacion());
				if (!Checks.esNulo(bienMatriz.getEmbargoProcedimiento()))
					bien.setEmbargoProcedimiento(bienMatriz.getEmbargoProcedimiento());	
				genericDao.save(Bien.class, bien);
				unidadAlquilable.setBien(bien);				
			}

			//Estado del activo 
			if ( !Checks.esNulo(activoMatriz.getEstadoActivo())) 
					unidadAlquilable.setEstadoActivo(activoMatriz.getEstadoActivo());
			if (!Checks.esNulo(activoMatriz.getCartera())) {
					unidadAlquilable.setCartera(activoMatriz.getCartera());
					if (!Checks.esNulo(activoMatriz.getSubcartera()))
						unidadAlquilable.setSubcartera(activoMatriz.getSubcartera());
			}
			if (!Checks.esNulo(activoMatriz.getTipoAlquiler()))
				unidadAlquilable.setTipoAlquiler(activoMatriz.getTipoAlquiler());
			if (!Checks.esNulo(activoMatriz.getBloqueoTipoComercializacionAutomatico()))
				unidadAlquilable.setBloqueoTipoComercializacionAutomatico(activoMatriz.getBloqueoTipoComercializacionAutomatico());	
			
			//Seteo %Construccion
			if (activoMatriz.getPorcentajeConstruccion()!= null) {
				unidadAlquilable.setPorcentajeConstruccion(activoMatriz.getPorcentajeConstruccion());
			}
		}
		
		
		Filter tipoTituloFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoTituloActivo.UNIDAD_ALQUILABLE);
		DDTipoTituloActivo tituloUnidadAlquilable = genericDao.get(DDTipoTituloActivo.class, tipoTituloFilter);
		unidadAlquilable.setAuditoria(auditoria);
		unidadAlquilable.setBien(bien); 
		unidadAlquilable.setNumActivoRem(activoApi.getNextNumActivoRem());
		unidadAlquilable.setTipoTitulo(tituloUnidadAlquilable);
		Filter scmFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSituacionComercial.CODIGO_DISPONIBLE_ALQUILER);
		DDSituacionComercial situacionComercial = genericDao.get(DDSituacionComercial.class, scmFilter);
		unidadAlquilable.setSituacionComercial(situacionComercial);
		if (!Checks.esNulo(activoMatriz.getNumInmovilizadoBnk())) {
			unidadAlquilable.setNumInmovilizadoBnk(activoMatriz.getNumInmovilizadoBnk());
		}
		//-----Tipo del activo
		if(!Checks.esNulo(exc.dameCelda(fila, 2))){
			String codTipo = exc.dameCelda(fila, 2);
			if(codTipo.length() == 1){
				codTipo = "0".concat(codTipo);
			}
			Filter tipoFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", codTipo);
			DDTipoActivo tipoActivo = genericDao.get(DDTipoActivo.class, tipoFilter);
			unidadAlquilable.setTipoActivo(tipoActivo);
		}
		
		//-----Subtipo del activo
		if(!Checks.esNulo(exc.dameCelda(fila, 3))){
			String codSubtipo = exc.dameCelda(fila, 3);
			if(codSubtipo.length() == 1){
				codSubtipo = "0".concat(codSubtipo);
			}
			Filter subtipoFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", codSubtipo);
			DDSubtipoActivo subtipoActivo = genericDao.get(DDSubtipoActivo.class, subtipoFilter);
			unidadAlquilable.setSubtipoActivo(subtipoActivo);
		}
		 
		//-----Descripcion
		if(!Checks.esNulo(exc.dameCelda(fila, 4))){
			String descripcion = exc.dameCelda(fila, 4);
			unidadAlquilable.setDescripcion(descripcion);
		}
		
		Long idUnidadAlquilable = null;
		Long idActivoMatriz = null;
		Long numRemActivoMatriz = null;
		String cartera = null;
		//--Seteo mediante maestro de activos
		if (!Checks.esNulo(unidadAlquilable)) {
			if(!Checks.esNulo(unidadAlquilable.getNumActivoRem())) {
				idUnidadAlquilable = unidadAlquilable.getNumActivoRem();
			}else {
				idUnidadAlquilable = activoApi.getNextNumActivoRem();
				unidadAlquilable.setNumActivoRem(idUnidadAlquilable);
			}
			 
		}
		if (!Checks.esNulo(activoMatriz)) {
			 idActivoMatriz = activoMatriz.getNumActivo();
			 numRemActivoMatriz = activoMatriz.getNumActivoRem();
			if (!Checks.esNulo(activoMatriz.getCartera()) && !Checks.esNulo(activoMatriz.getSubcartera())) {
				cartera = gdAdapterManager.getClienteWSByCarteraySubcarterayPropietario(activoMatriz.getCartera(), activoMatriz.getSubcartera(), activoMatriz.getPropietarioPrincipal());
				
				if(!Checks.esNulo(cartera)) {
					cartera = cartera.toUpperCase();
				}else {
					cartera = activoMatriz.getCartera().getDescripcion().toUpperCase();
				}
			}
		}
		
		if (!Checks.esNulo(idActivoMatriz) && !Checks.esNulo(numRemActivoMatriz) && !Checks.esNulo(cartera)) {
			MaestroDeActivos maestroActivos = new MaestroDeActivos(idUnidadAlquilable, idActivoMatriz, numRemActivoMatriz, cartera);
			ActivoOutputDto activoOutput = maestroActivos.altaActivo();
			if(!Checks.esNulo(activoOutput) && "1001".equals(activoOutput.getResultCode())) {
				return activoNoValido(fila);
			}
			else if (!Checks.esNulo(activoOutput) && !"1001".equals(activoOutput.getResultCode())) {
				Long numActivoUnidadAlquilable = Long.valueOf(activoOutput.getNumActivoUnidadAlquilable());
				if(Checks.esNulo(numActivoUnidadAlquilable)) {
					return activoNoValido(fila);
				}
				if(activoDao.existeActivo(numActivoUnidadAlquilable)){
					return activoExistente(fila);
					
				}
				unidadAlquilable.setNumActivo(numActivoUnidadAlquilable);
				
			} 

		}
		
		//Miramos si se ha generado bien en numActivo y persistimos la UA, o en su defecto devolvemos el error
		if(Checks.esNulo(unidadAlquilable.getNumActivo())) {
			return falloConexionConMaestro(fila);
		}
		
		unidadAlquilable.setIsDnd(false);
		
		unidadAlquilable.setTieneObraNuevaAEfectosComercializacion(ddNo);
		
		genericDao.save(Activo.class, unidadAlquilable);
		
		
		 //-- Lista propietarios 
		if (!Checks.estaVacio(activoMatriz.getPropietariosActivo())){    
			List<ActivoPropietarioActivo> propietariosUA = new ArrayList<ActivoPropietarioActivo>();
			List<ActivoPropietarioActivo> propietariosAM = activoMatriz.getPropietariosActivo();
			//Bucle para evitar la Excepcion "Found shared references to a collection:"
			for (ActivoPropietarioActivo propietarioAM : propietariosAM) {
				ActivoPropietarioActivo nuevoPropietarioUA = new ActivoPropietarioActivo();
				if (!Checks.esNulo(propietarioAM.getPorcPropiedad()))
					nuevoPropietarioUA.setPorcPropiedad(propietarioAM.getPorcPropiedad());
				if (!Checks.esNulo(propietarioAM.getPropietario()))
					nuevoPropietarioUA.setPropietario(propietarioAM.getPropietario());
				if (!Checks.esNulo(propietarioAM.getTipoGradoPropiedad()))
					nuevoPropietarioUA.setTipoGradoPropiedad(propietarioAM.getTipoGradoPropiedad());
					nuevoPropietarioUA.setActivo(unidadAlquilable);
					nuevoPropietarioUA.setAuditoria(auditoria);
					genericDao.save(ActivoPropietarioActivo.class, nuevoPropietarioUA);
					propietariosUA.add(propietarioAM);
			}
			unidadAlquilable.setPropietariosActivo(propietariosUA);
		}
		
		unidadAlquilable.setComunidadPropietarios(activoMatriz.getComunidadPropietarios());
		
		//--Patrimonio Unidad Alquilable
		Filter patrimonioFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activoMatriz.getId());
		ActivoPatrimonio patrimonioAm = genericDao.get(ActivoPatrimonio.class, patrimonioFilter);
		ActivoPatrimonio patrimonioUa = new ActivoPatrimonio();
		if (!Checks.esNulo(unidadAlquilable.getId()) && !Checks.esNulo(patrimonioAm)) { 
			patrimonioUa.setActivo(unidadAlquilable);
			if (!Checks.esNulo(patrimonioAm.getAdecuacionAlquiler()))
				patrimonioUa.setAdecuacionAlquiler(patrimonioAm.getAdecuacionAlquiler());
			if (!Checks.esNulo(patrimonioAm.getAdecuacionAlquilerAnterior()))
				patrimonioUa.setAdecuacionAlquilerAnterior(patrimonioAm.getAdecuacionAlquilerAnterior());
			if (!Checks.esNulo(patrimonioAm.getCheckSubrogado()))
				patrimonioUa.setCheckSubrogado(patrimonioAm.getCheckSubrogado());
			if (!Checks.esNulo(patrimonioAm.getComboRentaAntigua()))
				patrimonioUa.setComboRentaAntigua(patrimonioAm.getComboRentaAntigua());
			if (!Checks.esNulo(patrimonioAm.getTipoEstadoAlquiler()))
				patrimonioUa.setTipoEstadoAlquiler(patrimonioAm.getTipoEstadoAlquiler());
			if (!Checks.esNulo(patrimonioAm.getTipoInquilino()))
				patrimonioUa.setTipoInquilino(patrimonioAm.getTipoInquilino());
			patrimonioUa.setAuditoria(auditoria);
			patrimonioUa.setCheckHPM(true);
			
			genericDao.save(ActivoPatrimonio.class, patrimonioUa);
		}
		
		//-----Nueva Publicacion
		
		ActivoPublicacion nuevaPublicacion = new ActivoPublicacion();
		nuevaPublicacion.setActivo(unidadAlquilable);
		Filter epaFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacionAlquiler.CODIGO_NO_PUBLICADO_ALQUILER);
		DDEstadoPublicacionAlquiler estadoPublicacionAlquiler = genericDao.get(DDEstadoPublicacionAlquiler.class, epaFilter);
		nuevaPublicacion.setEstadoPublicacionAlquiler(estadoPublicacionAlquiler);
		Filter epvFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacionVenta.CODIGO_NO_PUBLICADO_VENTA);
		DDEstadoPublicacionVenta estadoPublicacionVenta = genericDao.get(DDEstadoPublicacionVenta.class, epvFilter);
		nuevaPublicacion.setEstadoPublicacionVenta(estadoPublicacionVenta);
		Filter tcoFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoComercializacion.CODIGO_SOLO_ALQUILER);
		DDTipoComercializacion tipoComercializacion = genericDao.get(DDTipoComercializacion.class, tcoFilter);
		nuevaPublicacion.setTipoComercializacion(tipoComercializacion);		
		nuevaPublicacion.setCheckPublicarVenta(false);
		nuevaPublicacion.setCheckPublicarAlquiler(false);
		nuevaPublicacion.setCheckOcultarAlquiler(false);
		nuevaPublicacion.setCheckOcultarVenta(false);
		nuevaPublicacion.setCheckOcultarPrecioAlquiler(false);
		nuevaPublicacion.setCheckOcultarPrecioVenta(false);
		nuevaPublicacion.setCheckSinPrecioAlquiler(false);
		nuevaPublicacion.setCheckSinPrecioVenta(false);
		nuevaPublicacion.setAuditoria(auditoria);
		nuevaPublicacion.setFechaInicioAlquiler(new Date());
		
		genericDao.save(ActivoPublicacion.class, nuevaPublicacion);
		//--SE INSERTA REGISTRO EN EL HISTORICO
		ActivoPublicacionHistorico activoPublicacionHistorico = new ActivoPublicacionHistorico();
		BeanUtils.copyProperties(activoPublicacionHistorico, nuevaPublicacion);
		genericDao.save(ActivoPublicacionHistorico.class, activoPublicacionHistorico);
		
		
		//----Perimetro del activo matriz
		
		if (!Checks.esNulo(activoMatriz)) {
			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "activo.id", activoMatriz.getId());
			PerimetroActivo perimetroActivoMatriz = genericDao.get(PerimetroActivo.class, f1);
			if (!Checks.esNulo(perimetroActivoMatriz)) {  
				PerimetroActivo perimetroActivoUnidadAlquilable = new PerimetroActivo();
				perimetroActivoUnidadAlquilable.setActivo(unidadAlquilable);
				perimetroActivoUnidadAlquilable.setAuditoria(auditoria);
				if (!Checks.esNulo(perimetroActivoMatriz.getIncluidoEnPerimetro()))
					perimetroActivoUnidadAlquilable.setIncluidoEnPerimetro(perimetroActivoMatriz.getIncluidoEnPerimetro());
				
				if (!Checks.esNulo(perimetroActivoMatriz.getAplicaTramiteAdmision()))
					perimetroActivoUnidadAlquilable.setAplicaTramiteAdmision(perimetroActivoMatriz.getAplicaTramiteAdmision());
				
				if (!Checks.esNulo(perimetroActivoMatriz.getFechaAplicaTramiteAdmision()))
					perimetroActivoUnidadAlquilable.setFechaAplicaTramiteAdmision(perimetroActivoMatriz.getFechaAplicaTramiteAdmision());
				
				if (!Checks.esNulo(perimetroActivoMatriz.getMotivoAplicaTramiteAdmision()))
					perimetroActivoUnidadAlquilable.setMotivoAplicaTramiteAdmision(perimetroActivoMatriz.getMotivoAplicaTramiteAdmision());
				
				if (!Checks.esNulo(perimetroActivoMatriz.getAplicaGestion()))
					perimetroActivoUnidadAlquilable.setAplicaGestion(perimetroActivoMatriz.getAplicaGestion());
				
				if (!Checks.esNulo(perimetroActivoMatriz.getFechaAplicaGestion()))
					perimetroActivoUnidadAlquilable.setFechaAplicaGestion(perimetroActivoMatriz.getFechaAplicaGestion());
				
				if (!Checks.esNulo(perimetroActivoMatriz.getMotivoAplicaGestion()))
					perimetroActivoUnidadAlquilable.setMotivoAplicaGestion(perimetroActivoMatriz.getMotivoAplicaGestion());
				
				if (!Checks.esNulo(perimetroActivoMatriz.getAplicaAsignarMediador()))
					perimetroActivoUnidadAlquilable.setAplicaAsignarMediador(perimetroActivoMatriz.getAplicaAsignarMediador());
				
				if (!Checks.esNulo(perimetroActivoMatriz.getFechaAplicaAsignarMediador()))
					perimetroActivoUnidadAlquilable.setFechaAplicaAsignarMediador(perimetroActivoMatriz.getFechaAplicaAsignarMediador());
				
				if (!Checks.esNulo(perimetroActivoMatriz.getMotivoAplicaAsignarMediador()))
					perimetroActivoUnidadAlquilable.setMotivoAplicaAsignarMediador(perimetroActivoMatriz.getMotivoAplicaAsignarMediador());
				
				if (!Checks.esNulo(perimetroActivoMatriz.getAplicaComercializar()))
					perimetroActivoUnidadAlquilable.setAplicaComercializar(perimetroActivoMatriz.getAplicaComercializar());
				
				if (!Checks.esNulo(perimetroActivoMatriz.getFechaAplicaComercializar()))
					perimetroActivoUnidadAlquilable.setFechaAplicaComercializar(perimetroActivoMatriz.getFechaAplicaComercializar());
				
				if (!Checks.esNulo(perimetroActivoMatriz.getMotivoAplicaComercializar()))
					perimetroActivoUnidadAlquilable.setMotivoAplicaComercializar(perimetroActivoMatriz.getMotivoAplicaComercializar());
				
				if (!Checks.esNulo(perimetroActivoMatriz.getAplicaFormalizar()))
					perimetroActivoUnidadAlquilable.setAplicaFormalizar(perimetroActivoMatriz.getAplicaFormalizar());
				
				if (!Checks.esNulo(perimetroActivoMatriz.getFechaAplicaFormalizar()))
					perimetroActivoUnidadAlquilable.setFechaAplicaFormalizar(perimetroActivoMatriz.getFechaAplicaFormalizar());
				
				if (!Checks.esNulo(perimetroActivoMatriz.getMotivoAplicaFormalizar()))
					perimetroActivoUnidadAlquilable.setMotivoAplicaFormalizar(perimetroActivoMatriz.getMotivoAplicaFormalizar());
				
				if (!Checks.esNulo(perimetroActivoMatriz.getAplicaPublicar()))
					perimetroActivoUnidadAlquilable.setAplicaPublicar(perimetroActivoMatriz.getAplicaPublicar());
				
				if (!Checks.esNulo(perimetroActivoMatriz.getFechaAplicaPublicar()))
					perimetroActivoUnidadAlquilable.setFechaAplicaPublicar(perimetroActivoMatriz.getFechaAplicaPublicar());
				
				if (!Checks.esNulo(perimetroActivoMatriz.getMotivoAplicaPublicar()))
					perimetroActivoUnidadAlquilable.setMotivoAplicaPublicar(perimetroActivoMatriz.getMotivoAplicaPublicar());
				perimetroActivoUnidadAlquilable.setTrabajosVivos(false);
				perimetroActivoUnidadAlquilable.setOfertasVivas(false);
				
				genericDao.save(PerimetroActivo.class,perimetroActivoUnidadAlquilable);
				
				
			}
		}
		
		//-----Nuevo ActivoAgrupacionActivo
		if(!Checks.esNulo(exc.dameCelda(fila, 0))){
			activoAgrupacionActivo= new ActivoAgrupacionActivo();
			
			//-----Promocion ALquiler (Agrupacion)
			Long agrupacionId = agrupacionAdapter.getAgrupacionIdByNumAgrupRem(Long.valueOf(exc.dameCelda(fila, 0)));
			Filter agrupacionFilter = genericDao.createFilter(FilterType.EQUALS, "id", agrupacionId);
			ActivoAgrupacion promocionAlquiler = genericDao.get(ActivoAgrupacion.class, agrupacionFilter);
			activoAgrupacionActivo.setAgrupacion(promocionAlquiler);
			
			//-----Unidad Alquilable (Activo)
			activoAgrupacionActivo.setActivo(unidadAlquilable);
			activoAgrupacionActivo.setPrincipal(0);
			activoAgrupacionActivo.setFechaInclusion(new Date());
			
			//-----ID Prinex HPM
			if(!Checks.esNulo(exc.dameCelda(fila, 1))){
				activoAgrupacionActivo.setIdPrinexHPM(exc.dameCelda(fila, 1));
			}
			
			//-----% Participacion
			if(!Checks.esNulo(exc.dameCelda(fila, 13))){
				activoAgrupacionActivo.setParticipacionUA(Double.valueOf(exc.dameCelda(fila, 13)));
			}
			
			activoAgrupacionActivo.setAuditoria(auditoria);
			genericDao.save(ActivoAgrupacionActivo.class, activoAgrupacionActivo);
		}
		
		
		//-----Nuevo NMBInformacionRegistralBien (Superficie construida)
		if(!Checks.esNulo(exc.dameCelda(fila, 11))){
			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "activo.id", activoMatriz.getId());
			ActivoInfoRegistral infoRegistralActivoMatriz = genericDao.get(ActivoInfoRegistral.class, f1);
			NMBInformacionRegistralBien bieInfoRegistralActivoMatriz = infoRegistralActivoMatriz.getInfoRegistralBien();
			NMBInformacionRegistralBien bieInfoRegistral = new NMBInformacionRegistralBien();
			String numUnidadAlquilable = Integer.toString(activoAgrupacionActivo.getAgrupacion().getActivos().size());
			String numFinca = "-"+StringUtils.leftPad(numUnidadAlquilable, 4, "0");
			bieInfoRegistral.setNumFinca(bieInfoRegistralActivoMatriz.getNumFinca().concat(numFinca));
			bieInfoRegistral.setBien(bien);
			bieInfoRegistral.setSuperficieConstruida(BigDecimal.valueOf(Double.valueOf(exc.dameCelda(fila, 11))));
			bieInfoRegistral.setAuditoria(auditoria);
			if(!Checks.esNulo(bieInfoRegistralActivoMatriz)) {
				bieInfoRegistral.setLocalidad(bieInfoRegistralActivoMatriz.getLocalidad());
				bieInfoRegistral.setProvincia(bieInfoRegistralActivoMatriz.getProvincia());	
				bieInfoRegistral.setTomo(bieInfoRegistralActivoMatriz.getTomo());
				bieInfoRegistral.setLibro(bieInfoRegistralActivoMatriz.getLibro());
				bieInfoRegistral.setFolio(bieInfoRegistralActivoMatriz.getFolio());
			}
			genericDao.save(NMBInformacionRegistralBien.class, bieInfoRegistral);
			
			Filter f2 = genericDao.createFilter(FilterType.EQUALS, "activo.id", activoMatriz.getId());
			ActivoBancario infoBancarioActivoMatriz = genericDao.get(ActivoBancario.class, f2);
			ActivoBancario infoBancario =new ActivoBancario();
			if (!Checks.esNulo(infoBancarioActivoMatriz)) {
				infoBancario.setActivo(unidadAlquilable);
				infoBancario.setClaseActivo(infoBancarioActivoMatriz.getClaseActivo());
				infoBancario.setEstadoExpIncorriente(infoBancarioActivoMatriz.getEstadoExpIncorriente());
				infoBancario.setSubtipoClaseActivo(infoBancarioActivoMatriz.getSubtipoClaseActivo());
				infoBancario.setNumExpRiesgo(infoBancarioActivoMatriz.getNumExpRiesgo());
				infoBancario.setTipoProducto(infoBancarioActivoMatriz.getTipoProducto());
				infoBancario.setEstadoExpRiesgo(infoBancarioActivoMatriz.getEstadoExpRiesgo());
				infoBancario.setProductoDescripcion(infoBancario.getProductoDescripcion());
			}
			
			genericDao.save(ActivoBancario.class, infoBancario);
			
			//-----Nuevo ActivoInfoRegistral (superficie util)
			if(!Checks.esNulo(exc.dameCelda(fila, 12))){
				ActivoInfoRegistral actInfoRegistral = new ActivoInfoRegistral();
				actInfoRegistral.setActivo(unidadAlquilable);
				actInfoRegistral.setSuperficieUtil(Float.valueOf(exc.dameCelda(fila, 12)));
				actInfoRegistral.setInfoRegistralBien(bieInfoRegistral);
				if (!Checks.esNulo(infoRegistralActivoMatriz.getIdufir()))
					actInfoRegistral.setIdufir(infoRegistralActivoMatriz.getIdufir());
				if (!Checks.esNulo(infoRegistralActivoMatriz.getHanCambiado()))
					actInfoRegistral.setHanCambiado(infoRegistralActivoMatriz.getHanCambiado());
				if (!Checks.esNulo(infoRegistralActivoMatriz.getLocalidadAnterior()))
					actInfoRegistral.setLocalidadAnterior(infoRegistralActivoMatriz.getLocalidadAnterior());
				if (!Checks.esNulo(infoRegistralActivoMatriz.getNumAnterior()))
					actInfoRegistral.setNumAnterior(infoRegistralActivoMatriz.getNumAnterior());
				if (!Checks.esNulo(infoRegistralActivoMatriz.getNumFincaAnterior()))
					actInfoRegistral.setNumFincaAnterior(infoRegistralActivoMatriz.getNumFincaAnterior());
				if (!Checks.esNulo(infoRegistralActivoMatriz.getDivHorInscrito()))
					actInfoRegistral.setDivHorInscrito(infoRegistralActivoMatriz.getDivHorInscrito());
				if (!Checks.esNulo(infoRegistralActivoMatriz.getEstadoDivHorizontal()))
					actInfoRegistral.setEstadoDivHorizontal(infoRegistralActivoMatriz.getEstadoDivHorizontal());
				if (!Checks.esNulo(infoRegistralActivoMatriz.getEstadoObraNueva()))
					actInfoRegistral.setEstadoObraNueva(infoRegistralActivoMatriz.getEstadoObraNueva());
				if (!Checks.esNulo(infoRegistralActivoMatriz.getFechaCfo()))
					actInfoRegistral.setFechaCfo(infoRegistralActivoMatriz.getFechaCfo());
				if (!Checks.esNulo(infoRegistralActivoMatriz.getTieneAnejosRegistrales()))
					actInfoRegistral.setTieneAnejosRegistrales(infoRegistralActivoMatriz.getTieneAnejosRegistrales());
				else 
					actInfoRegistral.setTieneAnejosRegistrales(ddNo);
				
				actInfoRegistral.setAuditoria(auditoria);
				float superficieA0 = 0;			//Se pone la superficie de  elementos comunes y la superficie de la parcela a 0 en la creación de las UAs
				actInfoRegistral.setSuperficieElementosComunes(superficieA0);
				actInfoRegistral.setSuperficieParcela(superficieA0);
				genericDao.save(ActivoInfoRegistral.class, actInfoRegistral);
			}
		}
		
		ActivoAdjudicacionJudicial adJUA = new ActivoAdjudicacionJudicial();
		ActivoAdjudicacionJudicial adJAM = activoMatriz.getAdjJudicial();
		if(!Checks.esNulo(adJAM)) {
			adJUA.setActivo(unidadAlquilable);
			adJUA.setAuditoria(auditoria);
			adJUA.setAdjudicacionBien(adJAM.getAdjudicacionBien());
			adJUA.setDefectosTestimonio(adJAM.getDefectosTestimonio());
			adJUA.setEntidadEjecutante(adJAM.getEntidadEjecutante());
			adJUA.setEstadoAdjudicacion(adJAM.getEstadoAdjudicacion());
			adJUA.setFechaAdjudicacion(adJAM.getFechaAdjudicacion());
			adJUA.setIdAsunto(adJAM.getIdAsunto());
			adJUA.setJuzgado(adJAM.getJuzgado());
			adJUA.setLetrado(adJAM.getLetrado());
			adJUA.setNumAuto(adJAM.getNumAuto());
			adJUA.setPlazaJuzgado(adJAM.getPlazaJuzgado());
			adJUA.setProcurador(adJAM.getProcurador());
		
			genericDao.save(ActivoAdjudicacionJudicial.class, adJUA);
		}
		ActivoAdjudicacionNoJudicial adNJUA = new ActivoAdjudicacionNoJudicial();
		ActivoAdjudicacionNoJudicial adJNAM = activoMatriz.getAdjNoJudicial();
		if(!Checks.esNulo(adJNAM)) {
			adNJUA.setActivo(unidadAlquilable);
			adNJUA.setAuditoria(auditoria);
			adNJUA.setDefectosTestimonio(adJNAM.getDefectosTestimonio());
			adNJUA.setEntidadEjecutante(adJNAM.getEntidadEjecutante());
			adNJUA.setFechaFirmaTitulo(adJNAM.getFechaFirmaTitulo());
			adNJUA.setFechaTitulo(adJNAM.getFechaTitulo());
			adNJUA.setNumReferencia(adJNAM.getNumReferencia());
			adNJUA.setTramitadorTitulo(adJNAM.getTramitadorTitulo());
			adNJUA.setValorAdquisicion(adJNAM.getValorAdquisicion());
			
			genericDao.save(ActivoAdjudicacionNoJudicial.class, adNJUA);
		}
		
		
		ActivoTitulo activoTituloUa = new ActivoTitulo();
		activoTituloUa.setActivo(unidadAlquilable);
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "activo.id", activoMatriz.getId());
		ActivoTitulo activoTituloAM = genericDao.get(ActivoTitulo.class, f1);
		
		if(!Checks.esNulo(activoTituloAM)) {
			activoTituloUa.setFechaEntregaGestoria(activoTituloAM.getFechaEntregaGestoria());
			activoTituloUa.setFechaEnvioAuto(activoTituloAM.getFechaEnvioAuto());
			activoTituloUa.setFechaNotaSimple(activoTituloAM.getFechaNotaSimple());
			activoTituloUa.setFechaInscripcionReg(activoTituloAM.getFechaInscripcionReg());
			activoTituloUa.setFechaPres1Registro(activoTituloAM.getFechaPres1Registro());
			activoTituloUa.setFechaPres2Registro(activoTituloAM.getFechaPres2Registro());
			activoTituloUa.setFechaRetiradaReg(activoTituloAM.getFechaRetiradaReg());
			activoTituloUa.setFechaPresHacienda(activoTituloAM.getFechaPresHacienda());
			activoTituloUa.setEstado(activoTituloAM.getEstado());

			activoTituloUa.setAuditoria(auditoria);
		}
		genericDao.save(ActivoTitulo.class, activoTituloUa);
		
		List<ActivoCargas> cargasUa = new ArrayList <ActivoCargas>();
		List<ActivoCargas> cargasAM = activoMatriz.getCargas();
	
		if(!Checks.estaVacio(cargasAM)) {
			for (ActivoCargas cargaAM : cargasAM) {
				ActivoCargas cargaUA = new  ActivoCargas();
				
				cargaUA.setActivo(unidadAlquilable);
				cargaUA.setAuditoria(auditoria);
				cargaUA.setCargaBien(cargaAM.getCargaBien());
				cargaUA.setCargasPropias(cargaAM.getCargasPropias());
				cargaUA.setDescripcionCarga(cargaAM.getDescripcionCarga());
				cargaUA.setFechaCancelacionRegistral(cargaAM.getFechaCancelacionRegistral());
				cargaUA.setObservaciones(cargaAM.getObservaciones());
				cargaUA.setOrdenCarga(cargaAM.getOrdenCarga());
				cargaUA.setOrigenDato(cargaAM.getOrigenDato());
				cargaUA.setSubtipoCarga(cargaAM.getSubtipoCarga());
				cargaUA.setTipoCargaActivo(cargaAM.getTipoCargaActivo());
				cargaUA.setImpideVenta(cargaAM.getImpideVenta());
				cargasUa.add(cargaUA);
			}
		}
		unidadAlquilable.setCargas(cargasUa);
		unidadAlquilable.setConCargas(activoMatriz.getConCargas());
		unidadAlquilable.setFechaRevisionCarga(activoMatriz.getFechaRevisionCarga());
		unidadAlquilable.setVpo(activoMatriz.getVpo());
		unidadAlquilable.setTerritorio(activoMatriz.getTerritorio());
		
		//-----Insercion de gestores a la Unidad Alquilable
		if (!Checks.esNulo(activoMatriz)) {
			GestorEntidadDto gestorEntidadDto = new GestorEntidadDto();
			gestorEntidadDto.setIdEntidad(activoMatriz.getId());
			gestorEntidadDto.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_ACTIVO);
			List<GestorEntidadHistorico> gestoresEntidad = gestorActivoApi
					.getListGestoresActivosAdicionalesHistoricoData(gestorEntidadDto);
			
			for (GestorEntidadHistorico gestor : gestoresEntidad) {
				String gestorCode = gestor.getTipoGestor().getCodigo();
				if ( !gestorCode.matches("SADM|SUPADM|SADM|SCOM|GCOM|GTOADM|GGADM|GADM|GADMT|GIAADMT")) {
					//---- Se insertan los gestores				
					GestorEntidadDto dtoGestores = new GestorEntidadDto();
					dtoGestores.setIdEntidad(unidadAlquilable.getId());
					dtoGestores.setIdTipoGestor(gestor.getTipoGestor().getId());
					dtoGestores.setIdUsuario(gestor.getUsuario().getId());
					activoAdapter.insertarGestorAdicional(dtoGestores);
				}		
			}
		}
		//------Insercion del api (Mediador)
		if ( !Checks.esNulo(activoMatriz)) {
			
			
			ActivoInfoComercial infoComercialMatriz = activoMatriz.getInfoComercial();
			ActivoInfoComercial infoComercialUA = new ActivoInfoComercial();
			
			infoComercialUA.setActivo(unidadAlquilable);
			
			if(!Checks.esNulo(infoComercialMatriz.getMediadorInforme())) {
				infoComercialUA.setMediadorInforme(infoComercialMatriz.getMediadorInforme());
			}
			
			if(!Checks.esNulo(infoComercialMatriz.getFechaRecepcionLlaves())) {
				infoComercialUA.setFechaRecepcionLlaves(infoComercialMatriz.getFechaRecepcionLlaves());
			}
			
			if(!Checks.esNulo(infoComercialMatriz.getFechaUltimaVisita())) {
				infoComercialUA.setFechaUltimaVisita(infoComercialMatriz.getFechaUltimaVisita());
			}
			
			if(!Checks.esNulo(infoComercialMatriz.getAutorizacionWeb())){
				infoComercialUA.setAutorizacionWeb(infoComercialMatriz.getAutorizacionWeb());
				
			}
			
			if(!Checks.esNulo(infoComercialMatriz.getFechaAutorizacionHasta())){
				infoComercialUA.setFechaAutorizacionHasta(infoComercialMatriz.getFechaAutorizacionHasta());
			}
			unidadAlquilable.setInfoComercial(infoComercialUA);
			genericDao.save(ActivoInfoComercial.class,infoComercialUA);
			
			List<DtoHistoricoMediador> dtoHistoricoMediador = activoApi.getHistoricoMediadorByActivo(activoMatriz.getId());
			if(Checks.esNulo(dtoHistoricoMediador)) {
				for (DtoHistoricoMediador dto : dtoHistoricoMediador) {
					dto.setIdActivo(unidadAlquilable.getId());
					activoApi.createHistoricoMediador(dto);
				}
			}
		}
				
		//Asignación del tipo de activo indicado en el Excel de Carga Masiva para que aparezcan los paneles Vivienda y Calidades en la pestaña Publicación
		if(!Checks.esNulo(exc.dameCelda(fila, 2))){
			String codTipo = exc.dameCelda(fila, 2);
			if(codTipo.length() == 1){
				codTipo = "0".concat(codTipo);
			}
			Filter tipoFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", codTipo);
			DDTipoActivo tipoActivo = genericDao.get(DDTipoActivo.class, tipoFilter);
			unidadAlquilable.getInfoComercial().setTipoActivo(tipoActivo);
		}
		

		//-----Nuevo NMBLocalizacionesBien
		NMBLocalizacionesBien localizacion = new NMBLocalizacionesBien();
		localizacion.setBien(bien);
		localizacion.setAuditoria(auditoria);
		if (!Checks.esNulo(activoMatriz)) {
			Long  idBieLocalizacionAM = activoMatriz.getBien().getId();
			if (!Checks.esNulo(idBieLocalizacionAM)) {
				Filter bieLoc = genericDao.createFilter(FilterType.EQUALS, "bien.id", idBieLocalizacionAM);
				NMBLocalizacionesBien bieLocAM = genericDao.get(NMBLocalizacionesBien.class, bieLoc);
				//Insercion de localizacion del activo matriz a la unidad alquilable
				if (!Checks.esNulo(bieLocAM)){
					if (!Checks.esNulo(bieLocAM.getPoblacion()))
						localizacion.setPoblacion(bieLocAM.getPoblacion());
					if (!Checks.esNulo(bieLocAM.getPoblacion()))
						localizacion.setPoblacion(bieLocAM.getPoblacion());
					if (!Checks.esNulo(bieLocAM.getDireccion()))
						localizacion.setDireccion(bieLocAM.getDireccion());
					if (!Checks.esNulo(bieLocAM.getCodPostal()))
						localizacion.setCodPostal(bieLocAM.getCodPostal());
					if (!Checks.esNulo(bieLocAM.getProvincia()))
						localizacion.setProvincia(bieLocAM.getProvincia());
					if (!Checks.esNulo(bieLocAM.getProvincia()))
						localizacion.setProvincia(bieLocAM.getProvincia());
					if (!Checks.esNulo(bieLocAM.getPortal()))
						localizacion.setPortal(bieLocAM.getPortal());
					if (!Checks.esNulo(bieLocAM.getBloque()))
						localizacion.setBloque(bieLocAM.getBloque());
					if (!Checks.esNulo(bieLocAM.getEscalera()))
						localizacion.setEscalera(bieLocAM.getEscalera());
					if (!Checks.esNulo(bieLocAM.getPiso()))
						localizacion.setPiso(bieLocAM.getPiso());
					if (!Checks.esNulo(bieLocAM.getPuerta()))
						localizacion.setPuerta(bieLocAM.getPuerta());
					if (!Checks.esNulo(bieLocAM.getBarrio()))
						localizacion.setBarrio(bieLocAM.getBarrio());
					if (!Checks.esNulo(bieLocAM.getPais()))
						localizacion.setPais(bieLocAM.getPais());
					if (!Checks.esNulo(bieLocAM.getLocalidad()))
						localizacion.setLocalidad(bieLocAM.getLocalidad());
					if (!Checks.esNulo(bieLocAM.getUnidadPoblacional()))
						localizacion.setUnidadPoblacional(bieLocAM.getUnidadPoblacional());
				}
			}
		}


				
		//-----Tipo de via
		if(!Checks.esNulo(exc.dameCelda(fila, 5))){
			String codTipoVia = exc.dameCelda(fila, 5);
			Filter tipoViaFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", codTipoVia);
			DDTipoVia tipoVia = genericDao.get(DDTipoVia.class, tipoViaFilter);
			localizacion.setTipoVia(tipoVia);
		} else {
			localizacion.setTipoVia(activoMatriz.getBien().getLocalizacionActual().getTipoVia());
		}
		
		//-----Nombre de la via
		if(!Checks.esNulo(exc.dameCelda(fila, 6))){
			String nombreVia = exc.dameCelda(fila, 6);
			localizacion.setNombreVia(nombreVia);
		} else {
			localizacion.setNombreVia(activoMatriz.getBien().getLocalizacionActual().getNombreVia());
		}
		
		//-----Numero
		if(!Checks.esNulo(exc.dameCelda(fila, 7))){
			String numero = exc.dameCelda(fila, 7);
			localizacion.setNumeroDomicilio(numero);
		}
		
		//-----Escalera
		if(!Checks.esNulo(exc.dameCelda(fila, 8))){
			String escalera = exc.dameCelda(fila, 8);
			localizacion.setEscalera(escalera);
		}
		
		//-----Planta
		if(!Checks.esNulo(exc.dameCelda(fila, 9))){
			String planta = exc.dameCelda(fila, 9);
			localizacion.setPiso(planta);
		}
		
		//-----Puerta
		if(!Checks.esNulo(exc.dameCelda(fila, 10))){
			String puerta = exc.dameCelda(fila, 10);
			localizacion.setPuerta(puerta);
		}
		
		genericDao.save(NMBLocalizacionesBien.class, localizacion);
		
		//Localizacion (act_loc_localizacion)
		Filter actLocFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activoMatriz.getId());
		ActivoLocalizacion actLocAM = genericDao.get(ActivoLocalizacion.class, actLocFilter);
		ActivoLocalizacion actLocUA = new ActivoLocalizacion();
		actLocUA.setActivo(unidadAlquilable);
		if (!Checks.esNulo(actLocAM)) {
			Long bienId = unidadAlquilable.getBien().getId();
			Filter locUaFilter = genericDao.createFilter(FilterType.EQUALS, "bien.id", bienId);
			NMBLocalizacionesBien localizacionUa = genericDao.get(NMBLocalizacionesBien.class, locUaFilter);
			if (!Checks.esNulo(localizacionUa))
				actLocUA.setLocalizacionBien(localizacionUa);
			if (!Checks.esNulo(actLocAM.getLongitud()))
				actLocUA.setLongitud(actLocAM.getLongitud());
			if (!Checks.esNulo(actLocAM.getLongitud()))
				actLocUA.setLongitud(actLocAM.getLongitud());
			if (!Checks.esNulo(actLocAM.getLatitud()))
				actLocUA.setLatitud(actLocAM.getLatitud());
			if (!Checks.esNulo(actLocAM.getDistanciaPlaya()))
				actLocUA.setDistanciaPlaya(actLocAM.getDistanciaPlaya());	
			if (!Checks.esNulo(actLocAM.getTipoUbicacion()))
				actLocUA.setTipoUbicacion(actLocAM.getTipoUbicacion());	
		}
		genericDao.save(ActivoLocalizacion.class, actLocUA);
		actualizarEstadoPublicacion(activoMatriz);
		
		//Situacion posesoria
		ActivoSituacionPosesoria actSitPosAM = activoMatriz.getSituacionPosesoria();
		ActivoSituacionPosesoria actSitPosUA = new ActivoSituacionPosesoria();
		
		
		
		if(!Checks.esNulo(actSitPosAM)) {
/*d*/		if (!Checks.esNulo(actSitPosAM.getTipoTituloPosesorio())) {
				actSitPosUA.setTipoTituloPosesorio(actSitPosAM.getTipoTituloPosesorio());
			}
			if (!Checks.esNulo(actSitPosAM.getComboOtro())) {
				actSitPosUA.setComboOtro(actSitPosAM.getComboOtro());
			}else {
				actSitPosUA.setComboOtro(0);
			}
			if (!Checks.estaVacio(actSitPosAM.getActivoOcupanteLegal())) {
					List<ActivoOcupanteLegal> ocupantesIlegalesAM = actSitPosAM.getActivoOcupanteLegal();
					List<ActivoOcupanteLegal> ocupantesIlegalesUA = new ArrayList<ActivoOcupanteLegal>();
					for (ActivoOcupanteLegal ocupanteIlegalAM : ocupantesIlegalesAM) {
						ActivoOcupanteLegal ocupanteIlegalUA = new ActivoOcupanteLegal();
						if (!Checks.esNulo(ocupanteIlegalAM.getNombreOcupante())) {
							ocupanteIlegalUA.setNombreOcupante(ocupanteIlegalAM.getNombreOcupante());
						}
						if (!Checks.esNulo(ocupanteIlegalAM.getNifOcupante())) {
							ocupanteIlegalUA.setNifOcupante(ocupanteIlegalAM.getNifOcupante());
						}
						if (!Checks.esNulo(ocupanteIlegalAM.getEmailOcupante())) {
							ocupanteIlegalUA.setEmailOcupante(ocupanteIlegalAM.getEmailOcupante());
						}
						if (!Checks.esNulo(ocupanteIlegalAM.getTelefonoOcupante())) {
							ocupanteIlegalUA.setTelefonoOcupante(ocupanteIlegalAM.getTelefonoOcupante());
						}
						if (!Checks.esNulo(ocupanteIlegalAM.getObservacionesOcupante())) {
							ocupanteIlegalUA.setObservacionesOcupante(ocupanteIlegalAM.getObservacionesOcupante());
						}
						ocupanteIlegalUA.setAuditoria(auditoria);
						genericDao.save(ActivoOcupanteLegal.class, ocupanteIlegalUA);
						ocupantesIlegalesUA.add(ocupanteIlegalUA);
					}
					actSitPosUA.setActivoOcupanteLegal(ocupantesIlegalesUA);
			}
			if (!Checks.esNulo(actSitPosAM.getFechaRevisionEstado())) {
				actSitPosUA.setFechaRevisionEstado(actSitPosAM.getFechaRevisionEstado());
			}
			if (!Checks.esNulo(actSitPosAM.getFechaTomaPosesion())) {
				actSitPosUA.setFechaTomaPosesion(actSitPosAM.getFechaTomaPosesion());
			}
			if (!Checks.esNulo(actSitPosAM.getSitaucionJuridica())) {
				actSitPosUA.setSitaucionJuridica(actSitPosAM.getSitaucionJuridica());
			}
			//campos obligatorios
			actSitPosUA.setAuditoria(auditoria);
			actSitPosUA.setActivo(unidadAlquilable);
			actSitPosUA.setOcupado(0);
			Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			String usuarioModificar = usu == null ? MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_AGRUPACION_PROMOCION_ALQUILER : MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_AGRUPACION_PROMOCION_ALQUILER + " - " + usu.getUsername();
			actSitPosUA.setUsuarioModificarOcupado(usuarioModificar);
			actSitPosUA.setAccesoAntiocupa(0);
			actSitPosUA.setAccesoTapiado(0);
			actSitPosUA.setActivo(unidadAlquilable);
			genericDao.save(ActivoSituacionPosesoria.class, actSitPosUA);
			if(unidadAlquilable!=null && actSitPosUA!=null && usuarioLogado!=null) {
				String cmasivaCodigo = this.getValidOperation();
				Filter filterCMasiva = genericDao.createFilter(FilterType.EQUALS, "codigo", cmasivaCodigo);
				MSVDDOperacionMasiva cMasiva = genericDao.get(MSVDDOperacionMasiva.class, filterCMasiva);
				
				if(cMasiva!=null && cMasiva.getDescripcion()!=null) {
					HistoricoOcupadoTitulo histOcupado = new HistoricoOcupadoTitulo(unidadAlquilable,actSitPosUA,usuarioLogado,HistoricoOcupadoTitulo.COD_CARGA_MASIVA,cMasiva.getDescripcion().toString());
					genericDao.save(HistoricoOcupadoTitulo.class, histOcupado);
				}
			
			}
			
		}
		
		unidadAlquilable.setAdmision(activoMatriz.getAdmision());
		genericDao.save(Activo.class, unidadAlquilable);
		listaActivos.add(unidadAlquilable);
		return new ResultadoProcesarFila();
	}
	
	private ResultadoProcesarFila activoNoValido(int fila) {

		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		resultado.setFila(fila);
		resultado.setErrorDesc("No se ha conseguido conectar con el maestro de activos. Por favor intentelo de nuevo.");
		resultado.setCorrecto(false);

		return resultado;

	}
	
	private ResultadoProcesarFila activoExistente(int fila) {

		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		resultado.setFila(fila);
		resultado.setErrorDesc("El servidor ha devuelto un número de activo existente");
		resultado.setCorrecto(false);

		return resultado;

	}
	
	private ResultadoProcesarFila falloConexionConMaestro(int fila) {
		
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		resultado.setFila(fila);
		resultado.setErrorDesc(ERROR_ACTIVO_NO_PROC_CORREC);
		resultado.setCorrecto(false);

		return resultado;
	}
	
	
	//HREOS-5902. Los registros de la fila son correctos. Se lanza el SP_CAMBIO_ESTADO_PUBLICACION.
	private void actualizarEstadoPublicacion(Activo unidadAlquilable) {
		@SuppressWarnings("unused")
		boolean result = activoAdapter.actualizarEstadoPublicacionActivo(unidadAlquilable.getId(), false);
	}
	
	@Override
	public void postProcesado(MSVHojaExcel exc) throws Exception {
		for(Activo activo : listaActivos){
			updaterState.updaterStateTipoComercializacion(activo);
		}
		
	}
	
	
}
