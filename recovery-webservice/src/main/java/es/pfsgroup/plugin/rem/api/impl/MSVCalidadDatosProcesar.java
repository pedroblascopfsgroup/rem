package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import es.pfsgroup.plugin.rem.alaskaComunicacion.AlaskaComunicacionManager;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoCatastro;
import es.pfsgroup.plugin.rem.model.ActivoConfigDocumento;
import es.pfsgroup.plugin.rem.model.CalidadDatosConfig;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalificacionEnergetica;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.thread.ConvivenciaAlaska;
import es.pfsgroup.plugin.rem.utils.DiccionarioTargetClassMap;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.ModelMap;

import javax.annotation.Resource;

@Component
public class MSVCalidadDatosProcesar extends AbstractMSVActualizador implements MSVLiberator {

	protected final Log logger = LogFactory.getLog(getClass());

	public static final class COL_NUM {
		static final int FILA_CABECERA = 0;
		static final int DATOS_PRIMERA_FILA = 1;
		
		static final int COL_NUM_IDENTIFICADOR = 0;
		static final int COL_NUM_CAMPO = 1;
		static final int COL_NUM_VALOR = 2;		
	}

	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private ActivoAgrupacionApi activoAgrupacionApi;
	
	@Autowired
	private ActivoAgrupacionActivoApi activoAgrupacionActivoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ActivoDao activoDao;

	@Autowired
	private AlaskaComunicacionManager alaskaComunicacionManager;
	
	@Autowired
	private UsuarioManager usuarioManager;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_MASIVO_CALIDAD_DATOS;
	}
	
	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException {

		String username = genericAdapter.getUsuarioLogado().getUsername();
		String identificador = exc.dameCelda(fila, COL_NUM.COL_NUM_IDENTIFICADOR);
		String campo = exc.dameCelda(fila, COL_NUM.COL_NUM_CAMPO);
		String valor = exc.dameCelda(fila, COL_NUM.COL_NUM_VALOR);
				
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroCampo = genericDao.createFilter(FilterType.EQUALS,"codCampo", campo);
		
		CalidadDatosConfig cdc = genericDao.get(CalidadDatosConfig.class, filtroCampo,filtroBorrado);
		Activo act = null;
		ActivoAdmisionDocumento ado;
		ActivoAgrupacion agrupacion;
		ActivoAgrupacionActivo activoAgrupacionActivo;
		
		if(cdc == null) {
			throw new ParseException("No se puede recuperar el registro cdc", fila);
		}
		
		switch (Integer.valueOf(campo)) {
		
		case 2:	// Fecha Posesion
			act = activoDao.getActivoByNumActivo(Long.valueOf(identificador));	
			if(DDTipoTituloActivo.tipoTituloJudicial.equals(act.getTipoTitulo().getCodigo())) {				
				Date fechaPosesion = Checks.esNulo(valor) ? null : DateFormat.toDate(valor);
				act.getSituacionPosesoria().setFechaTomaPosesion(fechaPosesion);
				activoDao.saveOrUpdate(act);
			}else {
				activoDao.actualizaDatoCDC(cdc, obtenerFormatoValor(cdc, valor), identificador, username);
			}
			break;
			
		case 5:	// Subtipo Activo
			act = activoDao.getActivoByNumActivo(Long.valueOf(identificador));			
			Filter filtroTipoActivo = genericDao.createFilter(FilterType.EQUALS,"tipoActivo.id", act.getTipoActivo().getId());
			Filter filtroDescripcion = genericDao.createFilter(FilterType.EQUALS,"descripcion", valor);
			DDSubtipoActivo ddSubtipoActivo = genericDao.get(DDSubtipoActivo.class, filtroTipoActivo, filtroDescripcion,filtroBorrado);
			act.setSubtipoActivo(ddSubtipoActivo);
			activoDao.saveOrUpdate(act);		
			break;
			
		case 18:	// Referencia Catastral
			String[] split = valor.split("\\|");
			act = activoDao.getActivoByNumActivo(Long.valueOf(identificador));
			for (ActivoCatastro cat : act.getCatastro()) {
				cat.getAuditoria().setBorrado(true);
				cat.getAuditoria().setUsuarioBorrar(username);
				genericDao.save(ActivoCatastro.class, cat);
			}
			ActivoCatastro ac;
			for (int i = 0; i < split.length; i++) {
				ac = new ActivoCatastro();
				ac.setAuditoria(Auditoria.getNewInstance());
				ac.setActivo(act);
				ac.setRefCatastral(split[i]);
				genericDao.save(ActivoCatastro.class, ac);
			}
			break;
			
		case 27 :	// CEE	
			act = activoDao.getActivoByNumActivo(Long.valueOf(identificador));					
			ado = obtenerDocumentoEtiquetaCEEporActivo(act);
			if(ado != null) {
				Dictionary ddTce = obtenerDiccionarioPorDescripcion(DDTipoCalificacionEnergetica.class, valor);
				ado.setTipoCalificacionEnergetica((DDTipoCalificacionEnergetica)ddTce);
				genericDao.save(ActivoAdmisionDocumento.class, ado);			
			}
			break;
			
		case 28:	// Fecha caducidad CEE			
			act = activoDao.getActivoByNumActivo(Long.valueOf(identificador));
			ado = obtenerDocumentoEtiquetaCEEporActivo(act);
			if(ado != null) {				
				Date fechaCaducidadCEE = DateFormat.toDate(valor);					
				ado.setFechaCaducidad(fechaCaducidadCEE);
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(fechaCaducidadCEE);
				calendar.add(Calendar.YEAR, -10);						
				ado.setFechaObtencion(calendar.getTime());			
				genericDao.save(ActivoAdmisionDocumento.class, ado);
			}
			break;
			
		case 29:	// Añadir a agrupacion			
			agrupacion = obtenerAgrupacionPorNumAgrupREM(valor);
			if(agrupacion != null) {
				act = activoDao.getActivoByNumActivo(Long.valueOf(identificador));			
				String codigoAgrupacion = agrupacion.getTipoAgrupacion().getCodigo();
				List<ActivoAgrupacionActivo> agrupaciones = act.getAgrupaciones();
				for (ActivoAgrupacionActivo agr : agrupaciones) {
					if(agr.getAgrupacion().getTipoAgrupacion().getCodigo().equals(codigoAgrupacion)) {
						activoAgrupacionActivoApi.delete(agr);
					}
				}				
				activoAgrupacionActivo = new ActivoAgrupacionActivo();
				activoAgrupacionActivo.setActivo(act);
				activoAgrupacionActivo.setAgrupacion(agrupacion);			
				activoAgrupacionActivo.setFechaInclusion(new Date());			
				activoAgrupacionActivoApi.save(activoAgrupacionActivo);
			}
			break;
			
		case 30:	// Eliminar de agrupacion
			agrupacion = obtenerAgrupacionPorNumAgrupREM(valor);
			act = activoDao.getActivoByNumActivo(Long.valueOf(identificador));			
			if(agrupacion != null && act != null) {
				activoAgrupacionActivo = activoAgrupacionActivoApi.getByIdActivoAndIdAgrupacion(act.getId(), agrupacion.getId());
				if(activoAgrupacionActivo != null) {
					activoAgrupacionActivoApi.delete(activoAgrupacionActivo);
				}
			}
			break;

		default:
			activoDao.actualizaDatoCDC(cdc, obtenerFormatoValor(cdc, valor), identificador, username);		
			break;
		}
		
		return new ResultadoProcesarFila();
	}
	
	private String obtenerFormatoValor(CalidadDatosConfig cdc, String valor) {
		String cadena = "NULL";
		if(!Checks.esNulo(valor)) {			
			String formato = cdc.getValidacion();			
			if("DD".equalsIgnoreCase(formato)) {				
				Dictionary dd = obtenerDiccionarioPorDescripcion((Class<? extends Dictionary>) DiccionarioTargetClassMap.convertToTargetClass(cdc.getClaveDiccionario()), valor);
				cadena = String.valueOf(dd.getId());
			}else if("F".equalsIgnoreCase(formato)) {
				cadena = "TO_DATE('" + valor + "', 'dd/MM/yy')";
			}else if("N".equalsIgnoreCase(formato)) {
				cadena = String.valueOf(Double.parseDouble(valor.replace(",", ".")));
			}else if("T".equalsIgnoreCase(formato)){
				cadena = "'" + valor + "'";
			}
		}
		return cadena;
	}	

	private Dictionary obtenerDiccionarioPorDescripcion(Class<? extends Dictionary> ddclass, String desc) {	
		Filter filtroDescripcion = genericDao.createFilter(FilterType.EQUALS,"descripcion", desc);
		return genericDao.get(ddclass, filtroDescripcion);						
	}
	
	private ActivoAgrupacion obtenerAgrupacionPorNumAgrupREM(String numAgrup) {	
		Long idAgrup = activoAgrupacionApi.getAgrupacionIdByNumAgrupRem(Long.valueOf(numAgrup));
		return activoAgrupacionApi.get(idAgrup);						
	}
	
	private ActivoAdmisionDocumento obtenerDocumentoEtiquetaCEEporActivo(Activo activo) {
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroCodigo = genericDao.createFilter(FilterType.EQUALS,"codigo", DDTipoDocumentoActivo.CODIGO_CEE_ETIQUETA_ACTIVO);
		DDTipoDocumentoActivo ddTpd = genericDao.get(DDTipoDocumentoActivo.class, filtroCodigo, filtroBorrado);
		
		Filter filtroTpd = genericDao.createFilter(FilterType.EQUALS,"tipoDocumentoActivo.id", ddTpd.getId());
		Filter filtroTipoActivo = genericDao.createFilter(FilterType.EQUALS,"tipoActivo.id", activo.getTipoActivo().getId());
		ActivoConfigDocumento cfd = genericDao.get(ActivoConfigDocumento.class, filtroTipoActivo, filtroTpd, filtroBorrado);
		
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS,"activo.id", activo.getId());
		Filter filtroCfd = genericDao.createFilter(FilterType.EQUALS,"configDocumento.id", cfd.getId());
		return genericDao.get(ActivoAdmisionDocumento.class, filtroActivo, filtroCfd, filtroBorrado);
	}
	
	@Override
	public int getFilaInicial() {
		return COL_NUM.DATOS_PRIMERA_FILA;
	}

}
