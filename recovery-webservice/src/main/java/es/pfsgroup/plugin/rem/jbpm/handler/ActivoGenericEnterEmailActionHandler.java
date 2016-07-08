package es.pfsgroup.plugin.rem.jbpm.handler;

import java.util.Date;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.mail.javamail.MimeMessageHelper;

import es.capgemini.devon.mail.MailManager;

public class ActivoGenericEnterEmailActionHandler extends ActivoGenericEnterActionHandler {

	private static final long serialVersionUID = -2997523481794698821L;

	@Resource(name = "mailManager")
	private MailManager mailManager;

	/**
	 * PONER JAVADOC FO.
	 * 
	 * @param delegateTransitionClass
	 *            delegateTransitionClass
	 * @param delegateSpecificClass
	 *            delegateSpecificClass
	 * @throws Exception
	 */
	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) throws Exception {
	
		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);
		
		MimeMessageHelper helper = mailManager.createMimeMessageHelper();
		helper.setFrom("daniel.gutierrez@pfsgroup.es");
		helper.setTo("daniel.gutierrez@pfsgroup.es");
		helper.setSubject("prueba de correo");
		helper.setText("cuerpo de correo", true);

//		mailManager.setHost("smtp.gmail.com");
//		mailManager.setPort(587);
//		mailManager.setUsername("daniel.gutierrez@pfsgroup.es");
//		mailManager.setPassword("hell1sh0t");
//
//		Properties props = new Properties();
//		
//		props.put("mail.debug", "true");
//		props.put("mail.smtp.auth", true);
//		props.put("mail.smtp.starttls.enable", true);
//		props.put("mail.smtp.host", "smtp.gmail.com");
//		props.put("mail.smtp.port", 587);
//		 
//		Session session = Session.getInstance(props, null);
//		 
//		  try {
//		   MimeMessage message = new MimeMessage(session);
//		   message.addRecipient(Message.RecipientType.TO, new InternetAddress(
//		     "daniel.gutierrez@pfsgroup.es"));
//		   message.setSubject("prueba de correo");
//		   message.setSentDate(new Date());
//		   message.setText("texto del correo");
//		    
//		   Transport tr = session.getTransport("smtp");
//		   tr.connect("smtp.gmail.com", "daniel.gutierrez@pfsgroup.es", "hell1sh0t");
//		   message.saveChanges();   
//		   tr.sendMessage(message, message.getAllRecipients());
//		   tr.close();
//		    
//		  } catch (MessagingException e) {
//		   e.printStackTrace();
//		  }
		  
		  
		//mailManager.setJavaMailProperties(props);
		mailManager.send(helper);

	}
}