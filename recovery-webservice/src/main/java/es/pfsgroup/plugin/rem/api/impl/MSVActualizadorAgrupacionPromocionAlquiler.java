package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBInformacionRegistralBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoInfoRegistral;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionVenta;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;

@Component
public class MSVActualizadorAgrupacionPromocionAlquiler extends AbstractMSVActualizador implements MSVLiberator {
	
	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private MSVRawSQLDao rawDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private AgrupacionAdapter agrupacionAdapter;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_AGRUPACION_PROMOCION_ALQUILER;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		
		//-----Usuariocrear, Fechacrear
		Auditoria auditoria = new Auditoria();
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		auditoria.setUsuarioCrear(usuarioLogado.getUsername());
		auditoria.setFechaCrear(new Date());
		
		//-----Nuevo Bien 
		NMBBien bien = new NMBBien();
		bien.setAuditoria(auditoria);
		genericDao.save(Bien.class, bien);
		
		//-----Nueva Unidad alquilable (activo)
		Activo unidadAlquilable = new Activo();
		Long newNumActivo = Long.valueOf(rawDao.getExecuteSQL("SELECT MAX(ACT_NUM_ACTIVO) + 1 FROM ACT_ACTIVO"));
		Long newNumActivoRem = Long.valueOf(rawDao.getExecuteSQL("SELECT MAX(ACT_NUM_ACTIVO_REM) + 1 FROM ACT_ACTIVO"));
		Filter tipoTituloFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoTituloActivo.UNIDAD_ALQUILABLE);
		DDTipoTituloActivo tituloUnidadAlquilable = genericDao.get(DDTipoTituloActivo.class, tipoTituloFilter);
		unidadAlquilable.setNumActivo(newNumActivo);
		unidadAlquilable.setNumActivoRem(newNumActivoRem);
		unidadAlquilable.setAuditoria(auditoria);
		unidadAlquilable.setBien(bien);
		unidadAlquilable.setTipoTitulo(tituloUnidadAlquilable);
		Filter scmFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSituacionComercial.CODIGO_DISPONIBLE_ALQUILER);
		DDSituacionComercial situacionComercial = genericDao.get(DDSituacionComercial.class, scmFilter);
		unidadAlquilable.setSituacionComercial(situacionComercial);
		
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
		
		genericDao.save(Activo.class, unidadAlquilable);
		
		//-----Nueva Publicacion
		ActivoPublicacion nuevaPublicacion = new ActivoPublicacion();
		nuevaPublicacion.setActivo(unidadAlquilable);
		Filter epaFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacionAlquiler.CODIGO_PUBLICADO_ALQUILER);
		DDEstadoPublicacionAlquiler estadoPublicacionAlquiler = genericDao.get(DDEstadoPublicacionAlquiler.class, epaFilter);
		nuevaPublicacion.setEstadoPublicacionAlquiler(estadoPublicacionAlquiler);
		Filter epvFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacionVenta.CODIGO_NO_PUBLICADO_VENTA);
		DDEstadoPublicacionVenta estadoPublicacionVenta = genericDao.get(DDEstadoPublicacionVenta.class, epvFilter);
		nuevaPublicacion.setEstadoPublicacionVenta(estadoPublicacionVenta);
		Filter tcoFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoComercializacion.CODIGO_SOLO_ALQUILER);
		DDTipoComercializacion tipoComercializacion = genericDao.get(DDTipoComercializacion.class, tcoFilter);
		nuevaPublicacion.setTipoComercializacion(tipoComercializacion);
		nuevaPublicacion.setCheckPublicarAlquiler(true);
		nuevaPublicacion.setCheckPublicarVenta(false);
		nuevaPublicacion.setCheckOcultarAlquiler(false);
		nuevaPublicacion.setCheckOcultarVenta(false);
		nuevaPublicacion.setCheckOcultarPrecioAlquiler(false);
		nuevaPublicacion.setCheckOcultarPrecioVenta(false);
		nuevaPublicacion.setCheckSinPrecioAlquiler(false);
		nuevaPublicacion.setCheckSinPrecioVenta(false);
		nuevaPublicacion.setAuditoria(auditoria);
		
		genericDao.save(ActivoPublicacion.class, nuevaPublicacion);
		
		//-----Nuevo NMBInformacionRegistralBien (Superficie construida)
		if(!Checks.esNulo(exc.dameCelda(fila, 11))){
			NMBInformacionRegistralBien bieInfoRegistral = new NMBInformacionRegistralBien();
			bieInfoRegistral.setBien(bien);
			bieInfoRegistral.setSuperficieConstruida(BigDecimal.valueOf(Double.valueOf(exc.dameCelda(fila, 11))));
			bieInfoRegistral.setAuditoria(auditoria);
			genericDao.save(NMBInformacionRegistralBien.class, bieInfoRegistral);
			
			//-----Nuevo ActivoInfoRegistral (superficie util)
			if(!Checks.esNulo(exc.dameCelda(fila, 12))){
				ActivoInfoRegistral actInfoRegistral = new ActivoInfoRegistral();
				actInfoRegistral.setActivo(unidadAlquilable);
				actInfoRegistral.setSuperficieUtil(Float.valueOf(exc.dameCelda(fila, 12)));
				actInfoRegistral.setInfoRegistralBien(bieInfoRegistral);
				actInfoRegistral.setAuditoria(auditoria);
				genericDao.save(ActivoInfoRegistral.class, actInfoRegistral);
			}
		}
		
		//-----Nuevo ActivoAgrupacionActivo
		if(!Checks.esNulo(exc.dameCelda(fila, 0))){
			ActivoAgrupacionActivo activoAgrupacionActivo= new ActivoAgrupacionActivo();
			
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
				activoAgrupacionActivo.setIdPrinexHPM(Long.valueOf(exc.dameCelda(fila, 1)));
			}
			
			//-----% Participacion
			if(!Checks.esNulo(exc.dameCelda(fila, 13))){
				activoAgrupacionActivo.setParticipacionUA(Double.valueOf(exc.dameCelda(fila, 13)));
			}
			
			activoAgrupacionActivo.setAuditoria(auditoria);
			genericDao.save(ActivoAgrupacionActivo.class, activoAgrupacionActivo);
		}
		
		//-----Nuevo NMBLocalizacionesBien
		NMBLocalizacionesBien localizacion = new NMBLocalizacionesBien();
		localizacion.setBien(bien);
		
		//-----Tipo de via
		if(!Checks.esNulo(exc.dameCelda(fila, 5))){
			String codTipoVia = exc.dameCelda(fila, 5);
			Filter tipoViaFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", codTipoVia);
			DDTipoVia tipoVia = genericDao.get(DDTipoVia.class, tipoViaFilter);
			localizacion.setTipoVia(tipoVia);
		}
		
		//-----Nombre de la via
		if(!Checks.esNulo(exc.dameCelda(fila, 6))){
			String nombreVia = exc.dameCelda(fila, 6);
			localizacion.setNombreVia(nombreVia);
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
		
		return new ResultadoProcesarFila();
	}

}
