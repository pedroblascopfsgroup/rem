package es.pfsgroup.recovery.ext.impl.mail;

import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;

import es.pfsgroup.recovery.ext.api.mail.GmailSender;

public class GmailSenderImpl extends JavaMailSenderImpl implements GmailSender{

	@Override
	public void send(MimeMessageHelper messageHelper) throws MailException {
		send(messageHelper.getMimeMessage());
		
	}

}
