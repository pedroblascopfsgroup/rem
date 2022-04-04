package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import es.pfsgroup.plugin.rem.alaskaComunicacion.AlaskaComunicacionManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdjudicacionBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionNoJudicial;
import es.pfsgroup.plugin.rem.model.ActivoCargas;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTitulo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.HistoricoOcupadoTitulo;
import es.pfsgroup.plugin.rem.model.VBusquedaTramitesActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.plugin.rem.tareasactivo.dao.TareaActivoDao;
import es.pfsgroup.plugin.rem.thread.ConvivenciaAlaska;

import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.ModelMap;

import javax.annotation.Resource;


@Component
public class MSVActualizadorTacticoEspartaPublicacionesCargaMasiva extends AbstractMSVActualizador implements MSVLiberator {
	
	private static final int DATOS_PRIMERA_FILA = 1;
	private static final int NUM_ACTIVO = 0;
	private static final int ESTADO_FISICO_DEL_ACTIVO = 1;
	private static final int ACTIVO_INSCRITO_DIVISION_HORIZONTAL = 2;
	private static final int TAPIADO = 3;
	private static final int FECHA_TAPIADO = 4;
	private static final int PUERTA_ANTIOCUPA = 5;
	private static final int FECHA_COLOCACION_PUERTA_ANTIOCUPA = 6;
	private static final int VPO = 7;
	private static final int OCUPADO = 8;
	private static final int CON_TITULO = 9;
	private static final int CON_CARGAS = 10;
	private static final int INFORME_COMERCIAL_APROBADO = 11;
	private static final int FECHA_DE_INSCRIPCION = 12;
	private static final int FECHA_POSESION = 13;
	private static final int SITUACION_TITULO = 14;
	private static final int FECHA_TITULO = 15;
	private static final String[] listaValidosPositivos = { "S", "SI" };
	
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private UsuarioApi usuarioApi;
		
	@Autowired
	private TareaActivoDao tareaActivoDao;

	@Autowired
	private AlaskaComunicacionManager alaskaComunicacionManager;
	
	@Autowired
	private UsuarioManager usuarioManager;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;


	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_TACTICO_ESPARTA_PUBLICACIONES;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws Exception {
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO)));
		
		if(activo != null) {
			
			rellenaActivo(activo, exc, fila);
			
			actualizaDependientesActivo(exc, fila, activo);
			
			if(!(exc.dameCelda(fila, INFORME_COMERCIAL_APROBADO)).isEmpty() &&
					traducirSiNo(exc.dameCelda(fila, INFORME_COMERCIAL_APROBADO)) == 1) {
				Filter filtroCodigoTipoTramite  = genericDao.createFilter(FilterType.EQUALS, "codigoTipoTramite", ActivoTramiteApi.CODIGO_TRAMITE_APROBACION_INFORME_COMERCIAL);
				Filter filtroActivoId  = genericDao.createFilter(FilterType.EQUALS, "idActivo", activo.getId());
				List<VBusquedaTramitesActivo> vBusquedaTramitesActivos = genericDao.getList(VBusquedaTramitesActivo.class, filtroCodigoTipoTramite, filtroActivoId);
			
				if(vBusquedaTramitesActivos != null && !vBusquedaTramitesActivos.isEmpty()) {
					for (VBusquedaTramitesActivo vBusquedaTramitesActivo : vBusquedaTramitesActivos) {
						Filter filtroTramite  = genericDao.createFilter(FilterType.EQUALS, "id", vBusquedaTramitesActivo.getIdTramite());
						ActivoTramite tramite = genericDao.get(ActivoTramite.class, filtroTramite);
						
						if(tramite != null && tramite.getEstadoTramite() != null && !DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO.equals(tramite.getEstadoTramite().getCodigo())) {
							Filter filtroDDEstadoProcedimiento  = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO);
							DDEstadoProcedimiento ddEstadoProcedimiento = genericDao.get(DDEstadoProcedimiento.class, filtroDDEstadoProcedimiento);
							tramite.setEstadoTramite(ddEstadoProcedimiento);
							
							genericDao.update(ActivoTramite.class, tramite);
						}
					}
				}
				
				tareaActivoDao.finalizarTareasActivoPorIdActivoAndCodigoTramite(activo.getId(), ActivoTramiteApi.CODIGO_TRAMITE_APROBACION_INFORME_COMERCIAL);
				
			}
			
		}
		
		genericDao.update(Activo.class, activo);
		
		return new ResultadoProcesarFila();
	}

	@Override
	public int getFilaInicial() {
		return DATOS_PRIMERA_FILA;
	}
	
	private int traducirSiNo(String celda) {
		if(celda != null && Arrays.asList(listaValidosPositivos).contains(celda.toUpperCase())) {
			return 1;
		}
		
		return 0;
	}
	private Boolean traducirSiNoBoolean(String celda) {
		if(celda != null && Arrays.asList(listaValidosPositivos).contains(celda.toUpperCase())) {
			return true;
		}
		
		return false;
	}
	private boolean esBorrar(String cadena) {
		return cadena.toUpperCase().trim().equals("X");
	}
	
	private Activo rellenaActivo(Activo activo, MSVHojaExcel exc, int fila) throws IOException, ParseException {
		
		Filter filtroDDEstadoActivo  = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, ESTADO_FISICO_DEL_ACTIVO));
		DDEstadoActivo ddEstadoActivo = genericDao.get(DDEstadoActivo.class, filtroDDEstadoActivo);
		
		if(!exc.dameCelda(fila, VPO).isEmpty()) {
			activo.setVpo(traducirSiNo(exc.dameCelda(fila, VPO)));
			recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(activo, null, false,false);
		}
		if(!exc.dameCelda(fila, CON_CARGAS).isEmpty()) {

			Filter activoCargasFilter  = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			List<ActivoCargas> activoCargasList = genericDao.getList(ActivoCargas.class, activoCargasFilter);
			if(activoCargasList != null && !activoCargasList.isEmpty()){
				for (ActivoCargas activoCarga : activoCargasList) {
					activoCarga.setOcultoPorMasivoEsparta(traducirSiNoBoolean(exc.dameCelda(fila, CON_CARGAS)));
					genericDao.update(ActivoCargas.class, activoCarga);
				}
			}
		}
		if(!exc.dameCelda(fila, ACTIVO_INSCRITO_DIVISION_HORIZONTAL).isEmpty()) {
			activo.setDivHorizontal(traducirSiNo(exc.dameCelda(fila, ACTIVO_INSCRITO_DIVISION_HORIZONTAL)));
		}
		if(ddEstadoActivo != null) {
			activo.setEstadoActivo(ddEstadoActivo);
		}
		
		return activo;
	}
	
	@Transactional(readOnly = false)
	private void actualizaDependientesActivo(MSVHojaExcel exc, int fila, Activo activo) throws IOException, ParseException {
		
		Filter filtroActivoSitPosesoria  = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoSituacionPosesoria sitPosesoria = genericDao.get(ActivoSituacionPosesoria.class, filtroActivoSitPosesoria);
		
		Filter filtroActivoTitulo  = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoTitulo activoTitulo = genericDao.get(ActivoTitulo.class, filtroActivoTitulo);
		
		Filter filtroActivoAdjNoJudicial  = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoAdjudicacionNoJudicial activoAdjNoJudicial = genericDao.get(ActivoAdjudicacionNoJudicial.class, filtroActivoAdjNoJudicial);
		
		String usuario = usuarioApi.getUsuarioLogado().getUsername();
		
		actualizaSituacionPosesoria(exc, fila, sitPosesoria, activo);
		
		
		
		if(activoTitulo != null) {
			
			if(!exc.dameCelda(fila, SITUACION_TITULO).isEmpty()) {
				Filter filtroDDSituacionTitulo  = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, SITUACION_TITULO));
				DDEstadoTitulo ddSituacionTitulo = genericDao.get(DDEstadoTitulo.class, filtroDDSituacionTitulo);

				activoTitulo.setEstado(ddSituacionTitulo);
			}
			if(!exc.dameCelda(fila, FECHA_DE_INSCRIPCION).isEmpty()) {
				if(esBorrar(exc.dameCelda(fila, FECHA_DE_INSCRIPCION))) {
					activoTitulo.setFechaInscripcionReg(null);
				}else {
					Date fechaInscripcion = new SimpleDateFormat("dd/MM/yyyy").parse(exc.dameCelda(fila, FECHA_DE_INSCRIPCION));
					activoTitulo.setFechaInscripcionReg(fechaInscripcion);
				}
			}
			
			genericDao.update(ActivoTitulo.class, activoTitulo);
		}
		
		if(activoAdjNoJudicial != null && !exc.dameCelda(fila, FECHA_TITULO).isEmpty()) {
			if(esBorrar(exc.dameCelda(fila, FECHA_TITULO))) {
				activoAdjNoJudicial.setFechaTitulo(null);
			}else {
				Date fechaTitulo = new SimpleDateFormat("dd/MM/yyyy").parse(exc.dameCelda(fila, FECHA_TITULO));
				activoAdjNoJudicial.setFechaTitulo(fechaTitulo);
			}
			genericDao.update(ActivoAdjudicacionNoJudicial.class, activoAdjNoJudicial);
		}
		
		if(!Checks.esNulo(activo.getAdjJudicial()) && !Checks.esNulo(activo.getAdjJudicial().getAdjudicacionBien()) 
			&& usuario != null && !exc.dameCelda(fila, FECHA_POSESION).isEmpty()) {
			NMBAdjudicacionBien adjudicacionBien = activo.getAdjJudicial().getAdjudicacionBien();
			
			if(adjudicacionBien != null) {
				if(esBorrar(exc.dameCelda(fila, FECHA_POSESION))) {
					adjudicacionBien.setFechaRealizacionPosesion(null);
				}else {
					Date fechaPosesion = new SimpleDateFormat("dd/MM/yyyy").parse(exc.dameCelda(fila, FECHA_POSESION));
					adjudicacionBien.setFechaRealizacionPosesion(fechaPosesion);
				}
				
				genericDao.update(NMBAdjudicacionBien.class, adjudicacionBien);
			}
			

		}

	}
	
	@Transactional(readOnly = false)
	public void actualizaSituacionPosesoria (MSVHojaExcel exc, int fila, ActivoSituacionPosesoria sitPosesoria,Activo activo) throws IOException, ParseException {

		if(sitPosesoria != null ) {
			Usuario usu = usuarioApi.getUsuarioLogado();
			String usuarioModificar = usu == null ? MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_TACTICO_ESPARTA_PUBLICACIONES : MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_TACTICO_ESPARTA_PUBLICACIONES + usu.getUsername();
			
			if(!exc.dameCelda(fila, PUERTA_ANTIOCUPA).isEmpty()) {
				sitPosesoria.setAccesoAntiocupa(traducirSiNo(exc.dameCelda(fila, PUERTA_ANTIOCUPA)));
			}
			if(!exc.dameCelda(fila, OCUPADO).isEmpty()) {
				sitPosesoria.setOcupado(traducirSiNo(exc.dameCelda(fila, OCUPADO)));
				sitPosesoria.setUsuarioModificarOcupado(usuarioModificar);
				sitPosesoria.setFechaModificarOcupado(new Date());
			}
			if(!exc.dameCelda(fila, CON_TITULO).isEmpty()) {
				Filter filtroDDTipoTituloActivoTPA  = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, CON_TITULO));
				DDTipoTituloActivoTPA ddTipoTituloActivoTPA = genericDao.get(DDTipoTituloActivoTPA.class, filtroDDTipoTituloActivoTPA);
				sitPosesoria.setConTitulo(ddTipoTituloActivoTPA);
				sitPosesoria.setUsuarioModificarConTitulo(usuarioModificar);
				sitPosesoria.setFechaModificarConTitulo(new Date());
			}
			if(!exc.dameCelda(fila, TAPIADO).isEmpty()) {
				sitPosesoria.setAccesoTapiado(traducirSiNo(exc.dameCelda(fila, TAPIADO)));
			}
			if(!exc.dameCelda(fila, FECHA_TAPIADO).isEmpty()) {
				if(esBorrar(exc.dameCelda(fila, FECHA_TAPIADO))) {
					sitPosesoria.setFechaAccesoTapiado(null);
				}else {
					Date fechaTapiado = new SimpleDateFormat("dd/MM/yyyy").parse(exc.dameCelda(fila, FECHA_TAPIADO));
					sitPosesoria.setFechaAccesoTapiado(fechaTapiado);
				}
			}
			
			if(!exc.dameCelda(fila, FECHA_COLOCACION_PUERTA_ANTIOCUPA).isEmpty()) {
				if(esBorrar(exc.dameCelda(fila, FECHA_COLOCACION_PUERTA_ANTIOCUPA))) {
					sitPosesoria.setFechaAccesoAntiocupa(null);
				}else {
					Date fechaPuertaAntiocupa = new SimpleDateFormat("dd/MM/yyyy").parse(exc.dameCelda(fila, FECHA_COLOCACION_PUERTA_ANTIOCUPA));
					sitPosesoria.setFechaAccesoAntiocupa(fechaPuertaAntiocupa);
				}
			}
							
			genericDao.update(ActivoSituacionPosesoria.class, sitPosesoria);
			if(activo!=null && sitPosesoria!=null && usu!=null && (!exc.dameCelda(fila, OCUPADO).isEmpty() || !exc.dameCelda(fila, CON_TITULO).isEmpty())) {
				String cmasivaCodigo = this.getValidOperation();
				Filter filterCMasiva = genericDao.createFilter(FilterType.EQUALS, "codigo", cmasivaCodigo);
				MSVDDOperacionMasiva cMasiva = genericDao.get(MSVDDOperacionMasiva.class, filterCMasiva);
				
				if(cMasiva!=null && cMasiva.getDescripcion()!=null) {
					HistoricoOcupadoTitulo histOcupado = new HistoricoOcupadoTitulo(activo,sitPosesoria,usu,HistoricoOcupadoTitulo.COD_CARGA_MASIVA,cMasiva.getDescripcion().toString());
					genericDao.save(HistoricoOcupadoTitulo.class, histOcupado);
				}
			
			}
		}
	}
	
	
}











































