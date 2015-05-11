package es.pfsgroup.commons.utils.web.controller.metaform;


import java.io.Serializable;

import es.pfsgroup.commons.utils.web.dto.metadata.MetadataDto;


public class MetaformEntry<T extends Serializable> {
	
	public static final String DEFAULT_VIEW = "lib/pfs-commons-java/metadataJSON";
	
	private Class<MetadataDto<T>> dto;
	
	private Class<T> entity;
	
	private String createBO;
	
	private String updateBO;
	
	private String getBO;
	
	private String view = DEFAULT_VIEW;

	public Class<MetadataDto<T>> getDtoType() {
		return dto;
	}

	public void setDtoType(Class<MetadataDto<T>> clazz) {
		this.dto = clazz;
	}

	public void setCreateBO(String createBO) {
		this.createBO = createBO;
	}

	public String getCreateBO() {
		return createBO;
	}

	public void setUpdateBO(String updateBO) {
		this.updateBO = updateBO;
	}

	public String getUpdateBO() {
		return updateBO;
	}

	public void setGetBO(String getBO) {
		this.getBO = getBO;
	}

	public String getGetBO() {
		return getBO;
	}

	public void setEntityType(Class<T> entity) {
		this.entity = entity;
	}

	public Class<T> getEntityType() {
		return entity;
	}

	public void setView(String customView) {
		this.view = customView;
	}

	public String getView() {
		return view;
	}

	

}
