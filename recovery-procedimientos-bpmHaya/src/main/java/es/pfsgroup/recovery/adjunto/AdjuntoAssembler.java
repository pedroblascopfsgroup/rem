package es.pfsgroup.recovery.adjunto;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.dto.ExtAdjuntoGenericoDto;
import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.core.api.asunto.EXTAdjuntoDto;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;
import es.pfsgroup.recovery.gestordocumental.dto.AdjuntoGridDto;

@Component
public class AdjuntoAssembler {
	
	
	@Autowired
	private  GenericABMDao genericDao;
	

	public  List<EXTAdjuntoDto> listAdjuntoGridDtoToEXTAdjuntoDto(List<AdjuntoGridDto> listDto, final Boolean borrarOtrosUsu){
		   
		List<EXTAdjuntoDto> adjuntosMapeados = new ArrayList<EXTAdjuntoDto>();

		if (!Checks.estaVacio(listDto)) {
			
			Comparator<AdjuntoGridDto> comparador = new Comparator<AdjuntoGridDto>() {
				@Override
				public int compare(AdjuntoGridDto o1, AdjuntoGridDto o2) {
					if (Checks.esNulo(o1) && Checks.esNulo(o2)) {
						return 0;
					} else if (Checks.esNulo(o1)) {
						return -1;
					} else if (Checks.esNulo(o2)) {
						return 1;
					} else {
						return o2.getAuditoria().getFechaCrear().compareTo(o1.getAuditoria().getFechaCrear());
					}
				}
			};
			
			Collections.sort(listDto, comparador);

			for(final AdjuntoGridDto adjDto : listDto){
				EXTAdjuntoDto dto = new EXTAdjuntoDto() {
					@Override
					public Boolean getPuedeBorrar() {
						/*if (borrarOtrosUsu || aa.getAuditoria().getUsuarioCrear().equals(usuario.getUsername())) {
							return true;
						} else {
							return false;
						}*/
						return false;
					}

					@Override
					public AdjuntoAsunto getAdjunto() {
						
						EXTAdjuntoAsunto adjAsu = new EXTAdjuntoAsunto();
						adjAsu.setId(adjDto.getId());
						adjAsu.setNombre(adjDto.getNombre());
						adjAsu.setContentType(adjDto.getContentType());
						if(!Checks.esNulo(adjDto.getLength())) {
							adjAsu.setLength(Long.parseLong(adjDto.getLength()));							
						}
						adjAsu.setDescripcion(adjDto.getDescripcion());
						adjAsu.setAuditoria(new Auditoria());
						adjAsu.getAuditoria().setFechaCrear(adjDto.getAuditoria().getFechaCrear());
						if(!Checks.esNulo(adjDto.getTipo())){
							adjAsu.setTipoFichero(genericDao.get(DDTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", adjDto.getTipo())));
						}
						if(!Checks.esNulo(adjDto.getNumActuacion())){
							adjAsu.setProcedimiento(genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", adjDto.getNumActuacion())));
						}
						
						return adjAsu;
					}

					@Override
					public String getTipoDocumento() {
						return adjDto.getContentType();
					}

					@Override
					public Long prcId() {
						return adjDto.getNumActuacion();
					}

					@Override
					public String getRefCentera() {
						return adjDto.getRefCentera();
					}
					
					@Override
					public String getNombreTipoDoc() {
						return adjDto.getNombreTipoDoc();
					}
				};
				adjuntosMapeados.add(dto);
			}

		}

		return adjuntosMapeados;
		
	}
	

	
	public List<ExtAdjuntoGenericoDto> listAdjuntoGridDtoTOListExtAdjuntoGenericoDto(List<AdjuntoGridDto> listDto, Long idEntidad, String descEntidad){
		   
		List<ExtAdjuntoGenericoDto> adjuntosMapeados = new ArrayList<ExtAdjuntoGenericoDto>();

		if (!Checks.estaVacio(listDto)) {
			
			Comparator<AdjuntoGridDto> comparador = new Comparator<AdjuntoGridDto>() {
				@Override
				public int compare(AdjuntoGridDto o1, AdjuntoGridDto o2) {
					if (Checks.esNulo(o1) && Checks.esNulo(o2)) {
						return 0;
					} else if (Checks.esNulo(o1)) {
						return -1;
					} else if (Checks.esNulo(o2)) {
						return 1;
					} else {
						return o2.getAuditoria().getFechaCrear().compareTo(o1.getAuditoria().getFechaCrear());
					}
				}
			};
			
			Collections.sort(listDto, comparador);

			for(final AdjuntoGridDto adjDto : listDto){
				
				ExtAdjuntoGenericoDto dto = createExtAdjuntoGenericoDtoFromAdjuntoGridDto(adjDto, descEntidad, idEntidad);

				adjuntosMapeados.add(dto);
				
				////solo descripcion para la primera fila
				descEntidad = null;
			}

		}

		return adjuntosMapeados;
		
	}
	
	private ExtAdjuntoGenericoDto createExtAdjuntoGenericoDtoFromAdjuntoGridDto(final AdjuntoGridDto adjDto, final String descriocionEntidad, final Long identidad){
		ExtAdjuntoGenericoDto dto = new ExtAdjuntoGenericoDto() {

			@Override
			public Long getId() {
				return identidad;
			}

			@Override
			public String getDescripcion() {
				return descriocionEntidad;
			}

			@Override
			public List getAdjuntosAsList() {
				List<AdjuntoGridDto> l = new ArrayList<AdjuntoGridDto>();
				l.add(adjDto);
				return l;
			}

			@Override
			public List getAdjuntos() {
				List<AdjuntoGridDto> l = new ArrayList<AdjuntoGridDto>();
				l.add(adjDto);
				return l;
			}
		};
		return dto;
	}
	
	public ExtAdjuntoGenericoDto contratoToExtAdjuntoGenericoDto(final Contrato contrato){
		
		ExtAdjuntoGenericoDto dto = new ExtAdjuntoGenericoDto() {

			@Override
			public Long getId() {
				return contrato.getId();
			}

			@Override
			public String getDescripcion() {
				return contrato.getNroContrato();
			}

			@Override
			public List getAdjuntosAsList() {
				return null;
			}

			@Override
			public List getAdjuntos() {
				return null;
			}
		};
		
		return dto;
	}
	
	
	public ExtAdjuntoGenericoDto personaToExtAdjuntoGenericoDto(final Persona persona){
		
		ExtAdjuntoGenericoDto dto = new ExtAdjuntoGenericoDto() {

			@Override
			public Long getId() {
				return persona.getId();
			}

			@Override
			public String getDescripcion() {
				return persona.getApellidoNombre();
			}

			@Override
			public List getAdjuntosAsList() {
				return null;
			}

			@Override
			public List getAdjuntos() {
				return null;
			}
		};
		
		return dto;
	}
	
	
	public ExtAdjuntoGenericoDto expedienteToExtAdjuntoGenericoDto(final Expediente expediente){
		
		ExtAdjuntoGenericoDto dto = new ExtAdjuntoGenericoDto() {

			@Override
			public Long getId() {
				return expediente.getId(); 
			}

			@Override
			public String getDescripcion() {
				return expediente.getDescripcion();
			}

			@Override
			public List getAdjuntosAsList() {
				return null;
			}

			@Override
			public List getAdjuntos() {
				return null;
			}
		};
		
		return dto;
	}


	public List<AdjuntoDto> listAdjuntoGridDtoTOListAdjuntoDto(List<AdjuntoGridDto> listDto, final Boolean borrarOtrosUsu){
		
		
		List<AdjuntoDto> adjuntosMapeados = new ArrayList<AdjuntoDto>();

		if (!Checks.estaVacio(listDto)) {
			
			Comparator<AdjuntoGridDto> comparador = new Comparator<AdjuntoGridDto>() {
				@Override
				public int compare(AdjuntoGridDto o1, AdjuntoGridDto o2) {
					if (Checks.esNulo(o1) && Checks.esNulo(o2)) {
						return 0;
					} else if (Checks.esNulo(o1)) {
						return -1;
					} else if (Checks.esNulo(o2)) {
						return 1;
					} else {
						return o2.getAuditoria().getFechaCrear().compareTo(o1.getAuditoria().getFechaCrear());
					}
				}
			};
			
			Collections.sort(listDto, comparador);
			
			for(final AdjuntoGridDto adjDto: listDto){
				
				EXTAdjuntoDto dto = new EXTAdjuntoDto() {
					
					@Override
					public Boolean getPuedeBorrar() {
						/*if (borrarOtrosUsu || adjAsun.getAuditoria().getUsuarioCrear().equals(usuario.getUsername())) {
							return true;
						} else {
							return false;
						}*/
						return false;
					}
					
					@Override
					public Object getAdjunto() {
						
						EXTAdjuntoAsunto adjAsu = new EXTAdjuntoAsunto();
						adjAsu.setId(adjDto.getId());
						adjAsu.setNombre(adjDto.getNombre());
						adjAsu.setContentType(adjDto.getContentType());
						if(!Checks.esNulo(adjDto.getLength())) {
							adjAsu.setLength(Long.parseLong(adjDto.getLength()));							
						}
						adjAsu.setDescripcion(adjDto.getDescripcion());
						adjAsu.setAuditoria(new Auditoria());
						adjAsu.getAuditoria().setFechaCrear(adjDto.getAuditoria().getFechaCrear());
						if(!Checks.esNulo(adjDto.getTipo())){
							adjAsu.setTipoFichero(genericDao.get(DDTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", adjDto.getTipo())));	
						}
						if(!Checks.esNulo(adjDto.getNumActuacion())){
							adjAsu.setProcedimiento(genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", adjDto.getNumActuacion())));	
						}
						
						return adjAsu;
					}
					
					@Override
					public Long prcId() {
						return adjDto.getNumActuacion();
					}
					
					@Override
					public String getTipoDocumento() {
						return adjDto.getContentType();
					}

					@Override
					public String getRefCentera() {
						return adjDto.getRefCentera();
					}

					@Override
					public String getNombreTipoDoc() {
						return adjDto.getNombreTipoDoc();
					}
				};

				adjuntosMapeados.add(dto);		
			}
		
		}

		return adjuntosMapeados;
		
	}
	
	
}
