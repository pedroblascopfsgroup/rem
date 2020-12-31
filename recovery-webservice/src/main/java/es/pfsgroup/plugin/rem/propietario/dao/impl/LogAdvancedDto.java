package es.pfsgroup.plugin.log.advanced.dto;


public class LogAdvancedDto {
	
	private int priorityDevo;
	private String messageDevo;
	private String messageRsyslog;
	
	public LogAdvancedDto(String messageDevo, int priorityDevo, String messageRsyslog){
		this.priorityDevo = priorityDevo;
		this.messageDevo = messageDevo;
		this.messageRsyslog = messageRsyslog;
	}
	
	public int getPriorityDevo() {
		return priorityDevo;
	}
	public void setPriorityDevo(int priorityDevo) {
		this.priorityDevo = priorityDevo;
	}
	public String getMessageDevo() {
		return messageDevo;
	}
	public void setMessageDevo(String messageDevo) {
		this.messageDevo = messageDevo;
	}
	public String getMessageRsyslog() {
		return messageRsyslog;
	}
	public void setMessageRsyslog(String messageRsyslog) {
		this.messageRsyslog = messageRsyslog;
	}
}