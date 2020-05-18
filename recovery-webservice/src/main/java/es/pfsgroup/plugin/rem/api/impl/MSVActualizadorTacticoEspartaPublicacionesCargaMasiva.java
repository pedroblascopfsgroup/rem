package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.apache.velocity.runtime.directive.Foreach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionNoJudicial;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTitulo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.VBusquedaTramitesActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.tareasactivo.dao.TareaActivoDao;


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
	private ActivoDao activoDao;
	
	@Autowired
	private TareaActivoDao tareaActivoDao;
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_TACTICO_ESPARTA_PUBLICACIONES;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, NUM_ACTIVO)));
		if(activo != null) {
			Filter filtroActivoSitPosesoria  = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			ActivoSituacionPosesoria sitPosesoria = genericDao.get(ActivoSituacionPosesoria.class, filtroActivoSitPosesoria);
			
			Filter filtroDDEstadoActivo  = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, ESTADO_FISICO_DEL_ACTIVO));
			DDEstadoActivo ddEstadoActivo = genericDao.get(DDEstadoActivo.class, filtroDDEstadoActivo);
			
			Filter filtroActivoTitulo  = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			ActivoTitulo activoTitulo = genericDao.get(ActivoTitulo.class, filtroActivoTitulo);
			
			Filter filtroActivoAdjNoJudicial  = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			ActivoAdjudicacionNoJudicial activoAdjNoJudicial = genericDao.get(ActivoAdjudicacionNoJudicial.class, filtroActivoAdjNoJudicial);
			
			
			activo.setVpo(traducirSiNo(exc.dameCelda(fila, VPO)));
			activo.setConCargas(traducirSiNo(exc.dameCelda(fila, CON_CARGAS)));
			activo.setDivHorizontal(traducirSiNo(exc.dameCelda(fila, ACTIVO_INSCRITO_DIVISION_HORIZONTAL)));
			activo.setEstadoActivo(ddEstadoActivo);
			
			if(sitPosesoria != null ) {
				sitPosesoria.setAccesoAntiocupa(traducirSiNo(exc.dameCelda(fila, PUERTA_ANTIOCUPA)));
				sitPosesoria.setOcupado(traducirSiNo(exc.dameCelda(fila, OCUPADO)));
				sitPosesoria.setSpsConTitulo(traducirSiNo(exc.dameCelda(fila, CON_TITULO)));
				sitPosesoria.setAccesoTapiado(traducirSiNo(exc.dameCelda(fila, TAPIADO)));
				
				if(sitPosesoria.getAccesoTapiado() == 1 && !exc.dameCelda(fila, FECHA_TAPIADO).isEmpty()) {
					Date fechaTapiado = new SimpleDateFormat("dd/MM/yyyy").parse(exc.dameCelda(fila, FECHA_TAPIADO));
					sitPosesoria.setFechaAccesoTapiado(fechaTapiado);
				}
				
				if(sitPosesoria.getAccesoAntiocupa() == 1 && !exc.dameCelda(fila, FECHA_COLOCACION_PUERTA_ANTIOCUPA).isEmpty()) {
					Date fechaPuertaAntiocupa = new SimpleDateFormat("dd/MM/yyyy").parse(exc.dameCelda(fila, FECHA_COLOCACION_PUERTA_ANTIOCUPA));
					sitPosesoria.setFechaAccesoAntiocupa(fechaPuertaAntiocupa);
				}
					
				genericDao.update(ActivoSituacionPosesoria.class, sitPosesoria);
			}
			
			if(activoTitulo != null && !exc.dameCelda(fila, FECHA_DE_INSCRIPCION).isEmpty()) {
				Filter filtroDDSituacionTitulo  = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, SITUACION_TITULO));
				DDEstadoTitulo ddSituacionTitulo = genericDao.get(DDEstadoTitulo.class, filtroDDSituacionTitulo);

				activoTitulo.setEstado(ddSituacionTitulo);
				
				if(!exc.dameCelda(fila, FECHA_DE_INSCRIPCION).isEmpty()) {
					Date fechaInscripcion = new SimpleDateFormat("dd/MM/yyyy").parse(exc.dameCelda(fila, FECHA_DE_INSCRIPCION));
					activoTitulo.setFechaInscripcionReg(fechaInscripcion);
				}
				
				genericDao.update(ActivoTitulo.class, activoTitulo);
			}
			
			if(activoAdjNoJudicial != null && !exc.dameCelda(fila, FECHA_TITULO).isEmpty()) {
				Date fechaTitulo = new SimpleDateFormat("dd/MM/yyyy").parse(exc.dameCelda(fila, FECHA_TITULO));
				activoAdjNoJudicial.setFechaTitulo(fechaTitulo);
				
				genericDao.update(ActivoAdjudicacionNoJudicial.class, activoAdjNoJudicial);
			}
			
			String usuario = usuarioApi.getUsuarioLogado().getUsername();
			
			NMBBien bien = activo.getBien();
			if(bien != null && usuario != null && !exc.dameCelda(fila, FECHA_POSESION).isEmpty()) {
				Date fechaPosesion = new SimpleDateFormat("dd/MM/yyyy").parse(exc.dameCelda(fila, FECHA_POSESION));
				
				activoDao.updateFechaPosesion(bien.getId(), fechaPosesion, usuario);
			}
			
			if(traducirSiNo(exc.dameCelda(fila, INFORME_COMERCIAL_APROBADO)) == 1) {
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
	
}











































