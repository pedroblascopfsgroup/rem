package es.pfsgroup.common.utils.test.web.dto.dynamic.putallexample;

import java.util.Date;

public class MainEntity {

	private Long id;
	
	private String name;
	
	private Date date;
	
	private Dict dictionary;
	
	private OtherEntity other;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public Dict getDictionary() {
		return dictionary;
	}

	public void setDictionary(Dict dictionary) {
		this.dictionary = dictionary;
	}

	public OtherEntity getOther() {
		return other;
	}

	public void setOther(OtherEntity other) {
		this.other = other;
	}
}
